# 📘 MediCo – OutPatient Management System

A lightweight, fast, and user-friendly OP ticket management system designed for hospitals.  
Built with **PHP, MySQL, Twilio WhatsApp API, HTML/CSS/JS**, and supports:

- Multi-hospital onboarding  
- Admin panels  
- Automated token generation  
- WhatsApp ticket delivery  
- Analytics dashboard  

---

## 🚀 Project Overview

MediCo helps hospitals manage:

- Patient registration  
- Token generation  
- Department-wise queues  
- Daily analytics  

The system supports three major roles:

- **Superadmin**
- **Hospital Admin**
- **Patients**

The goal is to digitize the entire outpatient workflow using a modern, simple UI.

---

## 🧑‍💼 User Roles

---

### **1️⃣ Superadmin**

Superadmin controls the entire platform:

- Approves or rejects hospital registration requests  
- Views full hospital details + submitted documents  
- Sends WhatsApp approval messages (Admin username + password)  
- Deletes hospitals  
- Updates request status as **approved / rejected / deleted**
- Views:
  - Pending Requests  
  - Approved Hospitals  
  - Deleted Hospitals  

---

### **2️⃣ Hospital Admin**

After approval, the admin receives login credentials through WhatsApp.

Admin capabilities:

- Manage departments  
  - Add  
  - Delete  
  - View patient count in each department  
- Register patients  
- Filter patients by:
  - Department  
  - Date  
- View date-wise analytics  
- Change password  
- Export patient details to Excel  

---

### **3️⃣ Patients**

Patients can:

- Register for OP  
- Receive token number instantly  
- Receive WhatsApp OP ticket (for age < 18)  
- Make payment (₹5) if age ≥ 18  

---

## 📂 Project Structure

| File | Description |
|------|-------------|
| `index.php` | Landing page |
| `register.php` | Patient registration |
| `login.php` | Admin & Superadmin login |
| `superadmin.php` | Superadmin dashboard |
| `admin.php` | Hospital admin dashboard |
| `admin_departments.php` | Department management |
| `get_departments.php` | Dynamic department loading |
| `payment.php` | Razorpay payment page |
| `send_sms.php` | WhatsApp ticket sender |
| `sendWhatsApp.php` | WhatsApp approval message |
| `config_local.php` | Twilio API setup |

---

## 🗄 Database Structure

### **1. hospital_requests**
Stores new hospital signup requests.

### **2. hospitals**
Stores approved hospitals with unique hospital_code.

### **3. admins**
Contains admin login details for each hospital.

### **4. departments**
Department list per hospital.

### **5. patients**
Patient records with token and department info.

### **6. patient_counter**
Maintains unique patient UID per hospital.

---

## 🧠 Key Features

✔ Multi-Hospital Support  
✔ Auto Token Generation  
✔ Twilio WhatsApp Notifications  
✔ Razorpay Payment Integration  
✔ Dynamic Department Management  
✔ Analytics Dashboard  
✔ Excel Export  
✔ Document Verification System  

---

