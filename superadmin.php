<?php
session_start();
require_once 'config_local.php'; // Twilio details: $twilioSid, $twilioAuthToken, $twilioNumber
// Optionally initialize Twilio client if SDK is available.
// If you use the Twilio PHP SDK, create $twilio = new Twilio\Rest\Client($twilioSid, $twilioAuthToken);
// But this file will check isset($twilio) before sending.

if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'superadmin') {
    header("Location: login.php");
    exit();
}

$mysqli = new mysqli("localhost", "root", "", "miniproject");
if ($mysqli->connect_error) die("DB Connection Error: " . $mysqli->connect_error);

function h($s){ return htmlspecialchars($s ?? '', ENT_QUOTES, 'UTF-8'); }

$errors = [];
$success = "";

// LOGOUT
if (isset($_POST['logout'])) {
    session_destroy();
    header("Location: login.php");
    exit();
}

// APPROVE
if (isset($_POST['approve_hospital'])) {
    $id = (int)($_POST['id'] ?? 0);
    if ($id > 0) {
        $reqStmt = $mysqli->prepare("SELECT * FROM hospital_requests WHERE id=? AND status='pending' LIMIT 1");
        $reqStmt->bind_param("i", $id);
        $reqStmt->execute();
        $req = $reqStmt->get_result()->fetch_assoc();
        $reqStmt->close();

        if ($req) {
            // generate hospital_code
            $base = strtoupper(substr(preg_replace('/\s+/', '', $req['hospital_name']), 0, 3));
            $code = $base;
            $i = 1;
            while (true) {
                $chk = $mysqli->prepare("SELECT id FROM hospitals WHERE hospital_code=? LIMIT 1");
                $chk->bind_param("s", $code);
                $chk->execute();
                $res = $chk->get_result();
                if ($res->num_rows === 0) { $chk->close(); break; }
                $chk->close();
                $i++;
                $code = $base . $i;
            }

            // admin credentials
            $username = strtolower($code) . "_admin";
            $password_plain = substr(md5(uniqid()), 0, 8);
            $password_hash = password_hash($password_plain, PASSWORD_DEFAULT);

            $mysqli->begin_transaction();
            try {
                // Insert hospital (using fields available from request)
                $ins = $mysqli->prepare("INSERT INTO hospitals
                    (name, hospital_code, location, contact, address, contact_person, contact_phone, contact_email, license_no, license_doc, dlt_registered, approved, deleted, created_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 1, 0, NOW())");
                $ins->bind_param(
                    "ssssssssss",
                    $req['hospital_name'],
                    $code,
                    $req['address'],   // using address as location (you can change if you store separately)
                    $req['phone'],
                    $req['address'],
                    $req['contact_person'],
                    $req['phone'],
                    $req['email'],
                    $req['reg_number'],
                    $req['documents']
                );
                $ins->execute();
                $hospital_id = $ins->insert_id;
                $ins->close();

                // Create admin in admins table
                $adm = $mysqli->prepare("INSERT INTO admins (hospital_id, username, password, created_at) VALUES (?, ?, ?, NOW())");
                $adm->bind_param("iss", $hospital_id, $username, $password_hash);
                $adm->execute();
                $adm->close();

                // Update request status
                $upd = $mysqli->prepare("UPDATE hospital_requests SET status='approved' WHERE id=?");
                $upd->bind_param("i", $id);
                $upd->execute();
                $upd->close();

                $mysqli->commit();

                // send WhatsApp (if $twilio client exists)
                $phone = preg_replace('/\D/', '', $req['phone']);
                if (strlen($phone) === 10) $phone = '+91' . $phone;
                $waSent = false;
                $msg = "✅ *MediCo Approval Update*\n\n"
                     . "Dear *{$req['contact_person']}*,\n\n"
                     . "Your hospital *{$req['hospital_name']}* has been *approved* for MediCo.\n\n"
                     . "🏥 *Hospital Code:* {$code}\n"
                     . "👤 *Admin Username:* {$username}\n"
                     . "🔑 *Password:* {$password_plain}\n\n"
                     . "You can now login to the MediCo admin portal.\n\n— MediCo Support Team";

                if (isset($twilio)) {
                    try {
                        $twilio->messages->create("whatsapp:$phone", ["from"=>$twilioNumber, "body"=>$msg]);
                        $waSent = true;
                    } catch (Exception $e) {
                        error_log("Twilio error (approve): " . $e->getMessage());
                    }
                }

                $success = "✅ Hospital approved successfully.<br>Admin Username: <b>{$username}</b><br>Password: <b>{$password_plain}</b>" .
                           ($waSent ? "<br>📱 WhatsApp sent." : "<br>⚠ WhatsApp not sent (Twilio not configured).");

            } catch (Exception $e) {
                $mysqli->rollback();
                $errors[] = "DB error during approval: " . $e->getMessage();
            }
        } else {
            $errors[] = "Request not found or already processed.";
        }
    } else {
        $errors[] = "Invalid request id.";
    }
}

// REJECT
if (isset($_POST['reject_hospital'])) {
    $rid = (int)($_POST['rid'] ?? 0);
    $reason = trim($_POST['reason'] ?? 'Not specified');

    if ($rid > 0) {
        $reqStmt = $mysqli->prepare("SELECT * FROM hospital_requests WHERE id=? LIMIT 1");
        $reqStmt->bind_param("i", $rid);
        $reqStmt->execute();
        $req = $reqStmt->get_result()->fetch_assoc();
        $reqStmt->close();

        if ($req) {
            $upd = $mysqli->prepare("UPDATE hospital_requests SET status='rejected' WHERE id=?");
            $upd->bind_param("i", $rid);
            $upd->execute();
            $upd->close();

            // Send reason via WhatsApp if Twilio present
            $phone = preg_replace('/\D/', '', $req['phone']);
            if (strlen($phone) === 10) $phone = '+91' . $phone;
            $msg = "❌ *MediCo Request Rejected*\n\n"
                 . "Dear *{$req['contact_person']}*,\n\n"
                 . "Your hospital request for *{$req['hospital_name']}* was rejected.\n\n"
                 . "*Reason:* {$reason}\n\n— MediCo Support Team";
            if (isset($twilio)) {
                try {
                    $twilio->messages->create("whatsapp:$phone", ["from"=>$twilioNumber, "body"=>$msg]);
                } catch (Exception $e) {
                    error_log("Twilio error (reject): " . $e->getMessage());
                }
            }

            $success = "❌ Hospital request rejected.";
        } else {
            $errors[] = "Request not found.";
        }
    } else {
        $errors[] = "Invalid request id.";
    }
}

// DELETE HOSPITAL
if (isset($_POST['delete_hospital'])) {
    $hid = (int)($_POST['hid'] ?? 0);
    if ($hid > 0) {
        $info = $mysqli->prepare("SELECT * FROM hospitals WHERE id=? LIMIT 1");
        $info->bind_param("i", $hid);
        $info->execute();
        $hinfo = $info->get_result()->fetch_assoc();
        $info->close();

        if ($hinfo) {
            $mysqli->begin_transaction();
            try {
                $upd = $mysqli->prepare("UPDATE hospitals SET deleted=1, approved=0 WHERE id=?");
                $upd->bind_param("i", $hid);
                $upd->execute();
                $upd->close();

                $delAdm = $mysqli->prepare("DELETE FROM admins WHERE hospital_id=?");
                $delAdm->bind_param("i", $hid);
                $delAdm->execute();
                $delAdm->close();

                // mark request (if exists) as deleted
                $rq = $mysqli->prepare("UPDATE hospital_requests SET status='deleted' WHERE hospital_name=?");
                $rq->bind_param("s", $hinfo['name']);
                $rq->execute();
                $rq->close();

                $mysqli->commit();

                // notify via WA
                $phone = preg_replace('/\D/', '', ($hinfo['contact_phone'] ?? $hinfo['contact'] ?? ''));
                if (strlen($phone) === 10) $phone = '+91' . $phone;
                if (isset($twilio)) {
                    try {
                        $twilio->messages->create("whatsapp:$phone", ["from"=>$twilioNumber, "body"=>"⚠️ *MediCo:* Your hospital \"{$hinfo['name']}\" has been removed from MediCo. Contact support if needed."]);
                    } catch (Exception $e) {
                        error_log("Twilio error (delete): " . $e->getMessage());
                    }
                }

                $success = "✅ Hospital deleted and database updated.";
            } catch (Exception $e) {
                $mysqli->rollback();
                $errors[] = "Delete error: " . $e->getMessage();
            }
        } else {
            $errors[] = "Hospital not found.";
        }
    } else {
        $errors[] = "Invalid hospital id.";
    }
}

// Helper to generate a JSON-safe object for JS (only used inline when rendering)
function json_safe($arr) {
    return json_encode($arr, JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_SLASHES);
}
?>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>MediCo • Superadmin</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
*{box-sizing:border-box;font-family:'Segoe UI',sans-serif}
body{margin:0;background:#eef7fb;padding:20px}
.container{max-width:1100px;margin:0 auto}
.header{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px}
.logo{font-size:28px;font-weight:800;color:#0078b7}.logo span{color:#00bcd4}
.controls{display:flex;gap:12px;align-items:center}
.btn{background:#0078b7;color:#fff;border:none;border-radius:8px;padding:8px 12px;cursor:pointer}
.btn.ghost{background:#fff;color:#0078b7;border:1px solid #cfeffb}
.card{background:#fff;border-radius:12px;padding:16px;box-shadow:0 8px 24px rgba(0,0,0,.06);margin-bottom:16px}
.table{width:100%;border-collapse:collapse}
.table th,.table td{padding:10px;border-bottom:1px solid #eee;text-align:left;vertical-align:middle}
.table th{background:#f3fbff}
.small{color:#607d8b;font-size:13px}
.view-btn{background:#0094d4;border:none;color:#fff;padding:6px 10px;border-radius:6px;cursor:pointer}
.approve-btn{background:#0078b7;color:#fff;padding:6px 10px;border-radius:6px;border:none}
.reject-btn{background:#e53935;color:#fff;padding:6px 10px;border-radius:6px;border:none}
.delete-btn{background:#c62828;color:#fff;padding:6px 10px;border-radius:6px;border:none}
.modal{display:none;position:fixed;z-index:1000;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.6);justify-content:center;align-items:center}
.modal-content{background:#fff;padding:18px;border-radius:10px;width:92%;max-width:780px;max-height:90vh;overflow:auto}
.modal-close{float:right;font-size:20px;cursor:pointer}
.doc-embed{width:100%;height:400px;border:1px solid #ddd;border-radius:8px;object-fit:contain}
.row-actions{display:flex;gap:8px;align-items:center}
.alert{padding:10px;border-radius:8px;margin-bottom:10px}
.alert.success{background:#e8f8f2;color:#006a39}
.alert.error{background:#ffecec;color:#a20000}
.back-home{background:#00bcd4;color:#fff;padding:8px 12px;border-radius:8px;text-decoration:none}
.form-inline{display:inline-block;margin:0}
</style>
</head>
<body>
<div class="container">
  <div class="header">
    <div>
      <div class="logo">Medi<span>Co</span></div>
      <div class="small">Superadmin — verify & approve hospitals</div>
    </div>
    <div class="controls">
      <a class="back-home" href="index.php"><i class="fa fa-home"></i>&nbsp;Home</a>
      <form method="POST" style="display:inline">
        <button class="btn ghost" name="logout" type="submit"><i class="fa fa-right-from-bracket"></i>&nbsp;Logout</button>
      </form>
    </div>
  </div>

  <?php if ($errors): ?>
    <div class="alert error"><?php foreach($errors as $e) echo h($e)."<br>"; ?></div>
  <?php endif; ?>
  <?php if ($success): ?>
    <div class="alert success"><?= $success ?></div>
  <?php endif; ?>

  <!-- Pending -->
  <div class="card">
    <h3>Pending Hospital Requests</h3>
    <?php
      $pending = $mysqli->query("SELECT * FROM hospital_requests WHERE status='pending' ORDER BY created_at DESC");
      if ($pending->num_rows === 0) {
        echo "<div class='small'>No pending requests.</div>";
      } else {
    ?>
    <table class="table">
      <thead><tr><th>Name</th><th>Contact</th><th>Email</th><th>Submitted</th><th>Actions</th></tr></thead>
      <tbody>
      <?php while ($r = $pending->fetch_assoc()): ?>
        <tr>
          <td><?= h($r['hospital_name']) ?></td>
          <td><?= h($r['phone']) ?></td>
          <td><?= h($r['email']) ?></td>
          <td><?= h($r['created_at']) ?></td>
          <td>
            <div class="row-actions">
              <button class="view-btn" onclick='openViewModal(<?= json_safe($r) ?>)'><i class="fa fa-eye"></i> View</button>

              <form method="POST" class="form-inline" onsubmit="return confirm('Approve this hospital?')">
                <input type="hidden" name="id" value="<?= (int)$r['id'] ?>">
                <button type="submit" name="approve_hospital" class="approve-btn"><i class="fa fa-check"></i> Approve</button>
              </form>

              <button class="reject-btn" onclick="openRejectModal(<?= (int)$r['id'] ?>)"><i class="fa fa-times"></i> Reject</button>
            </div>
          </td>
        </tr>
      <?php endwhile; ?>
      </tbody>
    </table>
    <?php } ?>
  </div>

  <!-- Approved -->
  <div class="card">
    <h3>Approved Hospitals</h3>
    <?php
      $approved = $mysqli->query("SELECT h.*, a.username AS admin_username FROM hospitals h LEFT JOIN admins a ON a.hospital_id=h.id WHERE h.approved=1 AND h.deleted=0 ORDER BY h.created_at DESC");
      if ($approved->num_rows === 0) {
        echo "<div class='small'>No approved hospitals.</div>";
      } else {
    ?>
    <table class="table">
      <thead><tr><th>Name</th><th>Code</th><th>Admin</th><th>Phone</th><th>Created</th><th>Actions</th></tr></thead>
      <tbody>
      <?php while ($h = $approved->fetch_assoc()): 
           // prepare object for view modal
           $obj = [
             'name'=>$h['name'],'hospital_code'=>$h['hospital_code'],
             'address'=>$h['address'],'contact_person'=>$h['contact_person'],
             'contact_phone'=>$h['contact_phone'],'contact_email'=>$h['contact_email'],
             'license_no'=>$h['license_no'],'documents'=>$h['license_doc'],'created_at'=>$h['created_at']
           ];
      ?>
        <tr>
          <td><?= h($h['name']) ?></td>
          <td><?= h($h['hospital_code']) ?></td>
          <td><?= h($h['admin_username'] ?? '-') ?></td>
          <td><?= h($h['contact_phone']) ?></td>
          <td><?= h($h['created_at']) ?></td>
          <td>
            <div class="row-actions">
              <button class="view-btn" onclick='openViewModal(<?= json_safe($obj) ?>)'><i class="fa fa-eye"></i> View</button>

              <form method="POST" class="form-inline" onsubmit="return confirm('Delete this hospital?')">
                <input type="hidden" name="hid" value="<?= (int)$h['id'] ?>">
                <button type="submit" name="delete_hospital" class="delete-btn"><i class="fa fa-trash"></i> Delete</button>
              </form>
            </div>
          </td>
        </tr>
      <?php endwhile; ?>
      </tbody>
    </table>
    <?php } ?>
  </div>

  <!-- Deleted -->
  <div class="card">
    <h3>Deleted Hospitals</h3>
    <?php
      $deleted = $mysqli->query("SELECT * FROM hospitals WHERE deleted=1 ORDER BY created_at DESC");
      if ($deleted->num_rows === 0) {
        echo "<div class='small'>No deleted hospitals.</div>";
      } else {
    ?>
    <table class="table">
      <thead><tr><th>Name</th><th>Code</th><th>Deleted At</th><th>Actions</th></tr></thead>
      <tbody>
      <?php while ($d = $deleted->fetch_assoc()):
          $obj = [
            'name'=>$d['name'],'hospital_code'=>$d['hospital_code'],
            'address'=>$d['address'],'contact_person'=>$d['contact_person'],
            'contact_phone'=>$d['contact_phone'],'contact_email'=>$d['contact_email'],
            'license_no'=>$d['license_no'],'documents'=>$d['license_doc'],'created_at'=>$d['created_at']
          ];
      ?>
        <tr>
          <td><?= h($d['name']) ?></td>
          <td><?= h($d['hospital_code']) ?></td>
          <td><?= h($d['created_at']) ?></td>
          <td><button class="view-btn" onclick='openViewModal(<?= json_safe($obj) ?>)'><i class="fa fa-eye"></i> View</button></td>
        </tr>
      <?php endwhile; ?>
      </tbody>
    </table>
    <?php } ?>
  </div>

</div>

<!-- View Modal -->
<div class="modal" id="viewModal">
  <div class="modal-content">
    <span class="modal-close" onclick="closeViewModal()">&times;</span>
    <h3>Hospital Details</h3>
    <div id="viewBody" style="margin-top:10px"></div>
  </div>
</div>

<!-- Reject Modal -->
<div class="modal" id="rejectModal">
  <div class="modal-content">
    <span class="modal-close" onclick="closeRejectModal()">&times;</span>
    <h3>Reject Hospital Request</h3>
    <form method="POST" style="margin-top:10px">
      <input type="hidden" name="rid" id="reject_id">
      <label style="display:block;margin-bottom:6px">Reason for rejection</label>
      <textarea name="reason" id="reject_reason" required style="width:100%;height:90px;padding:8px;border-radius:6px;border:1px solid #ddd"></textarea>
      <div style="margin-top:12px">
        <button type="submit" name="reject_hospital" class="reject-btn" style="width:100%">Submit rejection</button>
      </div>
    </form>
  </div>
</div>

<script>
// View modal functions
function openViewModal(obj) {
  const m = document.getElementById('viewModal');
  const body = document.getElementById('viewBody');
  // build HTML
  let html = "<div style='display:grid;grid-template-columns:1fr 1fr;gap:12px'>";
  html += "<div><b>Hospital:</b><br>" + (obj.hospital_name || obj.name || '') + "</div>";
  html += "<div><b>Code/Reg:</b><br>" + (obj.hospital_code || obj.reg_number || obj.license_no || '') + "</div>";
  html += "<div><b>Address:</b><br>" + (obj.address || '') + "</div>";
  html += "<div><b>Contact Person:</b><br>" + (obj.contact_person || '') + "</div>";
  html += "<div><b>Phone:</b><br>" + (obj.phone || obj.contact_phone || '') + "</div>";
  html += "<div><b>Email:</b><br>" + (obj.email || obj.contact_email || '') + "</div>";
  html += "</div><hr style='margin:12px 0'>";

  // Documents embed (PDF or image) — obj.documents expected as path
  if (obj.documents) {
    const doc = obj.documents;
    const ext = doc.split('.').pop().toLowerCase();
    if (['pdf'].includes(ext)) {
      html += "<div><b>Document (PDF):</b><br><embed class='doc-embed' src='" + doc + "' type='application/pdf'></div>";
    } else if (['jpg','jpeg','png','gif','webp'].includes(ext)) {
      html += "<div><b>Document (Image):</b><br><img class='doc-embed' src='" + doc + "' alt='document preview' style='width:100%;height:auto;border-radius:8px'></div>";
    } else {
      html += "<div><b>Document:</b><br><a href='" + doc + "' target='_blank'>View / Download</a></div>";
    }
  } else {
    html += "<div class='small' style='color:#555'>No document uploaded.</div>";
  }

  html += "<div style='margin-top:12px;color:#777;font-size:13px'><b>Submitted:</b> " + (obj.created_at || '') + "</div>";

  body.innerHTML = html;
  m.style.display = 'flex';
}

function closeViewModal(){ document.getElementById('viewModal').style.display = 'none'; }

// Reject modal
function openRejectModal(id){
  document.getElementById('reject_id').value = id;
  document.getElementById('reject_reason').value = '';
  document.getElementById('rejectModal').style.display = 'flex';
}
function closeRejectModal(){ document.getElementById('rejectModal').style.display = 'none'; }

// Close on outside click
window.onclick = function(e) {
  const v = document.getElementById('viewModal');
  const r = document.getElementById('rejectModal');
  if (e.target === v) closeViewModal();
  if (e.target === r) closeRejectModal();
}
</script>
</body>
</html>
