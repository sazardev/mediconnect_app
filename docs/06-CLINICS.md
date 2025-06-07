# 🏥 CLÍNICAS - Documentación API

## 📋 **RESUMEN DEL MÓDULO**

El módulo de **Clínicas** gestiona toda la información relacionada con centros médicos, especialidades, recursos, configuraciones y asociaciones doctor-clínica. Permite administrar múltiples clínicas y sus operaciones.

---

## 🔑 **PERMISOS Y ROLES**

### **Permisos por Rol:**

| **Acción**          | **Admin** | **Doctor**                | **Paciente**           |
| ------------------- | --------- | ------------------------- | ---------------------- |
| Crear clínica       | ✅        | ❌                        | ❌                     |
| Ver clínicas        | ✅        | ✅ (asociadas)            | ✅ (donde tiene citas) |
| Editar clínica      | ✅        | ✅ (propia)               | ❌                     |
| Eliminar clínica    | ✅        | ❌                        | ❌                     |
| Gestionar doctores  | ✅        | ✅ (agregar a su clínica) | ❌                     |
| Ver estadísticas    | ✅        | ✅ (propia clínica)       | ❌                     |
| Configurar horarios | ✅        | ✅ (propia clínica)       | ❌                     |

---

## 🌐 **ENDPOINTS PRINCIPALES**

### **Base URL:** `/api/clinics/`

---

## 🏢 **1. GESTIÓN DE CLÍNICAS**

### **GET** `/api/clinics/` - Listar Clínicas

```http
GET /api/clinics/
Authorization: Bearer {token}
```

**Query Parameters:**

```javascript
{
  status: "active" | "inactive" | "pending",     // Filtrar por estado
  city: "string",                                // Filtrar por ciudad
  page: 1,                                       // Paginación
  page_size: 20,                                // Tamaño de página
  search: "string"                               // Búsqueda por nombre
}
```

**Respuesta Exitosa (200):**

```json
{
  "count": 25,
  "next": "http://localhost:8000/api/clinics/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "name": "Clínica San Rafael",
      "code": "CSR001",
      "description": "Clínica especializada en medicina general",
      "phone": "+51987654321",
      "email": "contacto@clinicasanrafael.com",
      "website": "https://www.clinicasanrafael.com",
      "address": "Av. Arequipa 1234",
      "city": "Lima",
      "state": "Lima",
      "postal_code": "15001",
      "country": "PE",
      "latitude": -12.0464,
      "longitude": -77.0428,
      "status": "active",
      "is_main_clinic": true,
      "operating_hours": {
        "monday": { "open": "08:00", "close": "18:00" },
        "tuesday": { "open": "08:00", "close": "18:00" },
        "wednesday": { "open": "08:00", "close": "18:00" },
        "thursday": { "open": "08:00", "close": "18:00" },
        "friday": { "open": "08:00", "close": "17:00" },
        "saturday": { "open": "09:00", "close": "13:00" },
        "sunday": { "closed": true }
      },
      "appointment_duration": 30,
      "max_appointments_per_day": 50,
      "tax_id": "20123456789",
      "billing_address": "Av. Arequipa 1234, Lima, Lima",
      "created_at": "2025-01-15T10:30:00Z",
      "updated_at": "2025-06-07T16:45:00Z",
      "administrator_id": 1
    }
  ]
}
```

---

### **GET** `/api/clinics/{id}/` - Detalle de Clínica

```http
GET /api/clinics/1/
Authorization: Bearer {token}
```

**Respuesta Exitosa (200):**

```json
{
  "id": 1,
  "name": "Clínica San Rafael",
  "code": "CSR001",
  "description": "Clínica especializada en medicina general",
  "phone": "+51987654321",
  "email": "contacto@clinicasanrafael.com",
  "website": "https://www.clinicasanrafael.com",
  "address": "Av. Arequipa 1234",
  "city": "Lima",
  "state": "Lima",
  "postal_code": "15001",
  "country": "PE",
  "latitude": -12.0464,
  "longitude": -77.0428,
  "status": "active",
  "is_main_clinic": true,
  "operating_hours": {
    "monday": { "open": "08:00", "close": "18:00" },
    "tuesday": { "open": "08:00", "close": "18:00" },
    "wednesday": { "open": "08:00", "close": "18:00" },
    "thursday": { "open": "08:00", "close": "18:00" },
    "friday": { "open": "08:00", "close": "17:00" },
    "saturday": { "open": "09:00", "close": "13:00" },
    "sunday": { "closed": true }
  },
  "appointment_duration": 30,
  "max_appointments_per_day": 50,
  "tax_id": "20123456789",
  "billing_address": "Av. Arequipa 1234, Lima, Lima",
  "created_at": "2025-01-15T10:30:00Z",
  "updated_at": "2025-06-07T16:45:00Z",
  "administrator_id": 1,
  "specialties": [
    {
      "id": 1,
      "name": "Cardiología",
      "description": "Especialidad del corazón",
      "is_available": true
    },
    {
      "id": 2,
      "name": "Neurología",
      "description": "Especialidad del sistema nervioso",
      "is_available": true
    }
  ],
  "doctors": [
    {
      "id": 1,
      "doctor": {
        "id": 1,
        "user": {
          "id": 2,
          "username": "dr_rodriguez",
          "first_name": "Carlos",
          "last_name": "Rodríguez",
          "email": "carlos.rodriguez@email.com"
        },
        "license_number": "CMP12345",
        "speciality": "Cardiología",
        "consultation_fee": "150.00"
      },
      "status": "active",
      "start_date": "2025-01-15",
      "end_date": null
    }
  ],
  "resources": [
    {
      "id": 1,
      "name": "Sala de Consulta 1",
      "resource_type": "consultation_room",
      "description": "Sala equipada para consultas generales",
      "is_available": true,
      "capacity": 2
    }
  ],
  "settings": {
    "id": 1,
    "business_hours": {
      "monday": { "open": "08:00", "close": "18:00" },
      "tuesday": { "open": "08:00", "close": "18:00" }
    },
    "appointment_settings": {
      "default_duration": 30,
      "buffer_time": 10,
      "allow_weekend_appointments": false,
      "max_advance_booking_days": 90
    },
    "notification_settings": {
      "send_appointment_reminders": true,
      "reminder_hours_before": [24, 2],
      "send_email_notifications": true,
      "send_sms_notifications": false
    }
  }
}
```

---

### **POST** `/api/clinics/` - Crear Clínica (Solo Admin)

```http
POST /api/clinics/
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**

```json
{
  "name": "Clínica Santa María",
  "code": "CSM001",
  "description": "Clínica especializada en pediatría",
  "phone": "+51987654322",
  "email": "contacto@clinicasantamaria.com",
  "website": "https://www.clinicasantamaria.com",
  "address": "Jr. Puno 567",
  "city": "Lima",
  "state": "Lima",
  "postal_code": "15002",
  "country": "PE",
  "latitude": -12.0464,
  "longitude": -77.0428,
  "operating_hours": {
    "monday": { "open": "08:00", "close": "17:00" },
    "tuesday": { "open": "08:00", "close": "17:00" },
    "wednesday": { "open": "08:00", "close": "17:00" },
    "thursday": { "open": "08:00", "close": "17:00" },
    "friday": { "open": "08:00", "close": "16:00" },
    "saturday": { "closed": true },
    "sunday": { "closed": true }
  },
  "appointment_duration": 20,
  "max_appointments_per_day": 40,
  "tax_id": "20123456790",
  "billing_address": "Jr. Puno 567, Lima, Lima",
  "administrator_id": 1
}
```

**Respuesta Exitosa (201):**

```json
{
  "id": 2,
  "name": "Clínica Santa María",
  "code": "CSM001",
  "description": "Clínica especializada en pediatría",
  "phone": "+51987654322",
  "email": "contacto@clinicasantamaria.com",
  "website": "https://www.clinicasantamaria.com",
  "address": "Jr. Puno 567",
  "city": "Lima",
  "state": "Lima",
  "postal_code": "15002",
  "country": "PE",
  "latitude": -12.0464,
  "longitude": -77.0428,
  "status": "active",
  "is_main_clinic": false,
  "operating_hours": {
    "monday": { "open": "08:00", "close": "17:00" },
    "tuesday": { "open": "08:00", "close": "17:00" },
    "wednesday": { "open": "08:00", "close": "17:00" },
    "thursday": { "open": "08:00", "close": "17:00" },
    "friday": { "open": "08:00", "close": "16:00" },
    "saturday": { "closed": true },
    "sunday": { "closed": true }
  },
  "appointment_duration": 20,
  "max_appointments_per_day": 40,
  "tax_id": "20123456790",
  "billing_address": "Jr. Puno 567, Lima, Lima",
  "created_at": "2025-06-07T17:30:00Z",
  "updated_at": "2025-06-07T17:30:00Z",
  "administrator_id": 1
}
```

---

### **PUT/PATCH** `/api/clinics/{id}/` - Actualizar Clínica

```http
PATCH /api/clinics/1/
Authorization: Bearer {token}
Content-Type: application/json
```

**Body (PATCH - campos parciales):**

```json
{
  "phone": "+51987654999",
  "operating_hours": {
    "monday": { "open": "07:00", "close": "19:00" },
    "tuesday": { "open": "07:00", "close": "19:00" },
    "wednesday": { "open": "07:00", "close": "19:00" },
    "thursday": { "open": "07:00", "close": "19:00" },
    "friday": { "open": "07:00", "close": "18:00" },
    "saturday": { "open": "08:00", "close": "14:00" },
    "sunday": { "closed": true }
  }
}
```

**Respuesta Exitosa (200):** Objeto clínica actualizado

---

## 📊 **2. ESTADÍSTICAS DE CLÍNICA**

### **GET** `/api/clinics/{id}/stats/` - Estadísticas de Clínica

```http
GET /api/clinics/1/stats/
Authorization: Bearer {token}
```

**Query Parameters:**

```javascript
{
  period: "day" | "week" | "month" | "year",    // Período de estadísticas
  start_date: "2025-01-01",                     // Fecha inicio (YYYY-MM-DD)
  end_date: "2025-06-07"                        // Fecha fin (YYYY-MM-DD)
}
```

**Respuesta Exitosa (200):**

```json
{
  "clinic_id": 1,
  "clinic_name": "Clínica San Rafael",
  "period": "month",
  "start_date": "2025-05-01",
  "end_date": "2025-05-31",
  "statistics": {
    "appointments": {
      "total": 250,
      "completed": 230,
      "cancelled": 15,
      "no_show": 5,
      "completion_rate": 92.0
    },
    "patients": {
      "total_patients": 180,
      "new_patients": 25,
      "returning_patients": 155,
      "retention_rate": 86.1
    },
    "doctors": {
      "active_doctors": 8,
      "total_doctors": 10,
      "average_appointments_per_doctor": 31.25
    },
    "revenue": {
      "total_revenue": "37500.00",
      "average_per_appointment": "150.00",
      "payment_methods": {
        "cash": "15000.00",
        "card": "18750.00",
        "insurance": "3750.00"
      }
    },
    "operational": {
      "utilization_rate": 78.5,
      "average_wait_time": 12,
      "patient_satisfaction": 4.6
    }
  }
}
```

---

## 🏆 **3. DASHBOARD DE CLÍNICA**

### **GET** `/api/clinics/{id}/dashboard/` - Dashboard Completo

```http
GET /api/clinics/1/dashboard/
Authorization: Bearer {token}
```

**Respuesta Exitosa (200):**

```json
{
  "clinic": {
    "id": 1,
    "name": "Clínica San Rafael",
    "status": "active",
    "total_doctors": 8,
    "total_patients": 180,
    "total_appointments_today": 15
  },
  "statistics": {
    "appointments": {
      "today": 15,
      "this_week": 85,
      "this_month": 250,
      "completion_rate": 92.0
    },
    "revenue": {
      "today": "2250.00",
      "this_week": "12750.00",
      "this_month": "37500.00"
    },
    "patients": {
      "new_this_month": 25,
      "total_active": 180,
      "retention_rate": 86.1
    }
  },
  "recent_appointments": [
    {
      "id": 145,
      "patient": "María González",
      "doctor": "Dr. Carlos Rodríguez",
      "datetime": "2025-06-07T14:30:00Z",
      "status": "confirmed"
    },
    {
      "id": 144,
      "patient": "Juan Pérez",
      "doctor": "Dra. Ana Martínez",
      "datetime": "2025-06-07T13:00:00Z",
      "status": "completed"
    }
  ],
  "top_doctors": [
    {
      "name": "Dr. Carlos Rodríguez",
      "appointments_count": 45
    },
    {
      "name": "Dra. Ana Martínez",
      "appointments_count": 38
    }
  ],
  "monthly_trends": [
    {
      "month": "2025-01",
      "appointments": 220,
      "revenue": "33000.00",
      "patients": 165
    },
    {
      "month": "2025-02",
      "appointments": 195,
      "revenue": "29250.00",
      "patients": 148
    },
    {
      "month": "2025-03",
      "appointments": 235,
      "revenue": "35250.00",
      "patients": 172
    },
    {
      "month": "2025-04",
      "appointments": 210,
      "revenue": "31500.00",
      "patients": 158
    },
    {
      "month": "2025-05",
      "appointments": 250,
      "revenue": "37500.00",
      "patients": 180
    }
  ]
}
```

---

## 👨‍⚕️ **4. GESTIÓN DE DOCTORES EN CLÍNICA**

### **POST** `/api/clinics/{id}/add_doctor/` - Agregar Doctor a Clínica

```http
POST /api/clinics/1/add_doctor/
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**

```json
{
  "doctor_id": 3,
  "start_date": "2025-06-07",
  "status": "active"
}
```

**Respuesta Exitosa (201):**

```json
{
  "id": 5,
  "doctor": {
    "id": 3,
    "user": {
      "id": 5,
      "username": "dr_martinez",
      "first_name": "Ana",
      "last_name": "Martínez",
      "email": "ana.martinez@email.com"
    },
    "license_number": "CMP67890",
    "speciality": "Pediatría",
    "consultation_fee": "120.00"
  },
  "clinic": 1,
  "status": "active",
  "start_date": "2025-06-07",
  "end_date": null,
  "created_at": "2025-06-07T17:45:00Z"
}
```

---

### **GET** `/api/clinic-doctors/` - Listar Asociaciones Doctor-Clínica

```http
GET /api/clinic-doctors/
Authorization: Bearer {token}
```

**Query Parameters:**

```javascript
{
  clinic: 1,                      // Filtrar por clínica
  doctor: 3,                      // Filtrar por doctor
  status: "active" | "inactive",  // Filtrar por estado
  page: 1,
  page_size: 20
}
```

**Respuesta Exitosa (200):**

```json
{
  "count": 15,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "doctor": {
        "id": 1,
        "user": {
          "id": 2,
          "username": "dr_rodriguez",
          "first_name": "Carlos",
          "last_name": "Rodríguez",
          "email": "carlos.rodriguez@email.com"
        },
        "license_number": "CMP12345",
        "speciality": "Cardiología",
        "consultation_fee": "150.00"
      },
      "clinic": {
        "id": 1,
        "name": "Clínica San Rafael",
        "code": "CSR001"
      },
      "status": "active",
      "start_date": "2025-01-15",
      "end_date": null,
      "created_at": "2025-01-15T10:30:00Z"
    }
  ]
}
```

---

### **POST** `/api/clinic-doctors/{id}/activate/` - Activar Doctor en Clínica

```http
POST /api/clinic-doctors/1/activate/
Authorization: Bearer {token}
```

**Respuesta Exitosa (200):**

```json
{
  "status": "Doctor activado"
}
```

### **POST** `/api/clinic-doctors/{id}/deactivate/` - Desactivar Doctor en Clínica

```http
POST /api/clinic-doctors/1/deactivate/
Authorization: Bearer {token}
```

**Respuesta Exitosa (200):**

```json
{
  "status": "Doctor desactivado"
}
```

---

## 🏥 **5. ESPECIALIDADES DE CLÍNICA**

### **GET** `/api/specialties/` - Listar Especialidades

```http
GET /api/specialties/
Authorization: Bearer {token}
```

**Query Parameters:**

```javascript
{
  clinic: 1,                      // Filtrar por clínica
  is_available: true,             // Solo especialidades disponibles
  page: 1,
  page_size: 20
}
```

**Respuesta Exitosa (200):**

```json
{
  "count": 8,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "clinic": {
        "id": 1,
        "name": "Clínica San Rafael"
      },
      "name": "Cardiología",
      "description": "Especialidad médica dedicada al estudio del corazón",
      "is_available": true,
      "created_at": "2025-01-15T10:30:00Z"
    },
    {
      "id": 2,
      "clinic": {
        "id": 1,
        "name": "Clínica San Rafael"
      },
      "name": "Neurología",
      "description": "Especialidad médica del sistema nervioso",
      "is_available": true,
      "created_at": "2025-01-15T10:35:00Z"
    }
  ]
}
```

---

### **POST** `/api/specialties/` - Crear Especialidad

```http
POST /api/specialties/
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**

```json
{
  "clinic": 1,
  "name": "Dermatología",
  "description": "Especialidad médica de la piel",
  "is_available": true
}
```

**Respuesta Exitosa (201):**

```json
{
  "id": 9,
  "clinic": {
    "id": 1,
    "name": "Clínica San Rafael"
  },
  "name": "Dermatología",
  "description": "Especialidad médica de la piel",
  "is_available": true,
  "created_at": "2025-06-07T17:50:00Z"
}
```

---

## 🏗️ **6. RECURSOS DE CLÍNICA**

### **GET** `/api/resources/` - Listar Recursos

```http
GET /api/resources/
Authorization: Bearer {token}
```

**Query Parameters:**

```javascript
{
  clinic: 1,                                          // Filtrar por clínica
  resource_type: "consultation_room" | "equipment" | "laboratory" | "other",
  is_available: true,                                 // Solo recursos disponibles
  page: 1,
  page_size: 20
}
```

**Respuesta Exitosa (200):**

```json
{
  "count": 12,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "clinic": {
        "id": 1,
        "name": "Clínica San Rafael"
      },
      "name": "Sala de Consulta 1",
      "resource_type": "consultation_room",
      "description": "Sala equipada para consultas generales",
      "is_available": true,
      "capacity": 2,
      "created_at": "2025-01-15T10:30:00Z",
      "updated_at": "2025-06-07T16:45:00Z"
    },
    {
      "id": 2,
      "clinic": {
        "id": 1,
        "name": "Clínica San Rafael"
      },
      "name": "Electrocardiografo",
      "resource_type": "equipment",
      "description": "Equipo para realizar electrocardiogramas",
      "is_available": true,
      "capacity": 1,
      "created_at": "2025-01-15T10:35:00Z",
      "updated_at": "2025-06-07T16:45:00Z"
    }
  ]
}
```

---

### **POST** `/api/resources/` - Crear Recurso

```http
POST /api/resources/
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**

```json
{
  "clinic": 1,
  "name": "Laboratorio Principal",
  "resource_type": "laboratory",
  "description": "Laboratorio para análisis clínicos",
  "is_available": true,
  "capacity": 10
}
```

**Respuesta Exitosa (201):**

```json
{
  "id": 13,
  "clinic": {
    "id": 1,
    "name": "Clínica San Rafael"
  },
  "name": "Laboratorio Principal",
  "resource_type": "laboratory",
  "description": "Laboratorio para análisis clínicos",
  "is_available": true,
  "capacity": 10,
  "created_at": "2025-06-07T18:00:00Z",
  "updated_at": "2025-06-07T18:00:00Z"
}
```

---

## ⚙️ **7. CONFIGURACIONES DE CLÍNICA**

### **GET** `/api/settings/` - Listar Configuraciones

```http
GET /api/settings/
Authorization: Bearer {token}
```

**Query Parameters:**

```javascript
{
  clinic: 1,                      // Filtrar por clínica
  page: 1,
  page_size: 20
}
```

**Respuesta Exitosa (200):**

```json
{
  "count": 3,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "clinic": {
        "id": 1,
        "name": "Clínica San Rafael"
      },
      "business_hours": {
        "monday": { "open": "08:00", "close": "18:00" },
        "tuesday": { "open": "08:00", "close": "18:00" },
        "wednesday": { "open": "08:00", "close": "18:00" },
        "thursday": { "open": "08:00", "close": "18:00" },
        "friday": { "open": "08:00", "close": "17:00" },
        "saturday": { "open": "09:00", "close": "13:00" },
        "sunday": { "closed": true }
      },
      "appointment_settings": {
        "default_duration": 30,
        "buffer_time": 10,
        "allow_weekend_appointments": false,
        "max_advance_booking_days": 90,
        "cancellation_hours_limit": 24,
        "allow_same_day_booking": true
      },
      "notification_settings": {
        "send_appointment_reminders": true,
        "reminder_hours_before": [24, 2],
        "send_email_notifications": true,
        "send_sms_notifications": false,
        "send_push_notifications": true
      },
      "created_at": "2025-01-15T10:30:00Z",
      "updated_at": "2025-06-07T16:45:00Z"
    }
  ]
}
```

---

### **GET** `/api/settings/by_clinic/` - Configuraciones por Clínica

```http
GET /api/settings/by_clinic/?clinic_id=1
Authorization: Bearer {token}
```

**Respuesta Exitosa (200):**

```json
{
  "id": 1,
  "clinic": {
    "id": 1,
    "name": "Clínica San Rafael"
  },
  "business_hours": {
    "monday": { "open": "08:00", "close": "18:00" },
    "tuesday": { "open": "08:00", "close": "18:00" },
    "wednesday": { "open": "08:00", "close": "18:00" },
    "thursday": { "open": "08:00", "close": "18:00" },
    "friday": { "open": "08:00", "close": "17:00" },
    "saturday": { "open": "09:00", "close": "13:00" },
    "sunday": { "closed": true }
  },
  "appointment_settings": {
    "default_duration": 30,
    "buffer_time": 10,
    "allow_weekend_appointments": false,
    "max_advance_booking_days": 90,
    "cancellation_hours_limit": 24,
    "allow_same_day_booking": true
  },
  "notification_settings": {
    "send_appointment_reminders": true,
    "reminder_hours_before": [24, 2],
    "send_email_notifications": true,
    "send_sms_notifications": false,
    "send_push_notifications": true
  },
  "created_at": "2025-01-15T10:30:00Z",
  "updated_at": "2025-06-07T16:45:00Z"
}
```

---

### **POST** `/api/settings/{id}/update_business_hours/` - Actualizar Horarios

```http
POST /api/settings/1/update_business_hours/
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**

```json
{
  "business_hours": {
    "monday": { "open": "07:00", "close": "19:00" },
    "tuesday": { "open": "07:00", "close": "19:00" },
    "wednesday": { "open": "07:00", "close": "19:00" },
    "thursday": { "open": "07:00", "close": "19:00" },
    "friday": { "open": "07:00", "close": "18:00" },
    "saturday": { "open": "08:00", "close": "14:00" },
    "sunday": { "closed": true }
  }
}
```

**Respuesta Exitosa (200):** Configuración actualizada

---

### **POST** `/api/settings/{id}/update_appointment_settings/` - Actualizar Configuración de Citas

```http
POST /api/settings/1/update_appointment_settings/
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**

```json
{
  "appointment_settings": {
    "default_duration": 25,
    "buffer_time": 15,
    "allow_weekend_appointments": true,
    "max_advance_booking_days": 120,
    "cancellation_hours_limit": 12,
    "allow_same_day_booking": false
  }
}
```

**Respuesta Exitosa (200):** Configuración actualizada

---

### **POST** `/api/settings/{id}/update_notification_settings/` - Actualizar Configuración de Notificaciones

```http
POST /api/settings/1/update_notification_settings/
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**

```json
{
  "notification_settings": {
    "send_appointment_reminders": true,
    "reminder_hours_before": [48, 24, 1],
    "send_email_notifications": true,
    "send_sms_notifications": true,
    "send_push_notifications": true
  }
}
```

**Respuesta Exitosa (200):** Configuración actualizada

---

### **GET** `/api/settings/default_settings/` - Configuraciones por Defecto

```http
GET /api/settings/default_settings/
Authorization: Bearer {token}
```

**Respuesta Exitosa (200):**

```json
{
  "default_business_hours": {
    "monday": { "open": "08:00", "close": "17:00" },
    "tuesday": { "open": "08:00", "close": "17:00" },
    "wednesday": { "open": "08:00", "close": "17:00" },
    "thursday": { "open": "08:00", "close": "17:00" },
    "friday": { "open": "08:00", "close": "17:00" },
    "saturday": { "closed": true },
    "sunday": { "closed": true }
  },
  "default_appointment_settings": {
    "default_duration": 30,
    "buffer_time": 10,
    "allow_weekend_appointments": false,
    "max_advance_booking_days": 60,
    "cancellation_hours_limit": 24,
    "allow_same_day_booking": true
  },
  "default_notification_settings": {
    "send_appointment_reminders": true,
    "reminder_hours_before": [24, 2],
    "send_email_notifications": true,
    "send_sms_notifications": false,
    "send_push_notifications": true
  }
}
```

---

## 🌐 **8. ENDPOINTS ADICIONALES**

### **GET** `/api/user_clinics/` - Clínicas del Usuario Actual

```http
GET /api/user_clinics/
Authorization: Bearer {token}
```

**Respuesta Exitosa (200):**

```json
{
  "user_id": 2,
  "user_type": "doctor",
  "clinics": [
    {
      "id": 1,
      "name": "Clínica San Rafael",
      "code": "CSR001",
      "status": "active",
      "role": "doctor",
      "association_status": "active",
      "start_date": "2025-01-15"
    },
    {
      "id": 2,
      "name": "Clínica Santa María",
      "code": "CSM001",
      "status": "active",
      "role": "doctor",
      "association_status": "active",
      "start_date": "2025-03-01"
    }
  ]
}
```

---

### **GET** `/api/clinic_summary/` - Resumen del Sistema de Clínicas

```http
GET /api/clinic_summary/
Authorization: Bearer {token}
```

**Respuesta Exitosa (200):**

```json
{
  "total_clinics": 15,
  "active_clinics": 12,
  "inactive_clinics": 3,
  "total_doctors": 85,
  "total_patients": 2500,
  "total_appointments_today": 180,
  "total_revenue_this_month": "125000.00",
  "top_performing_clinics": [
    {
      "id": 1,
      "name": "Clínica San Rafael",
      "appointments_this_month": 250,
      "revenue_this_month": "37500.00"
    },
    {
      "id": 3,
      "name": "Clínica Los Andes",
      "appointments_this_month": 220,
      "revenue_this_month": "33000.00"
    }
  ]
}
```

---

## 🚨 **CÓDIGOS DE ERROR ESPECÍFICOS**

### **Errores Comunes:**

| **Código**   | **Mensaje**                                     | **Descripción**                                |
| ------------ | ----------------------------------------------- | ---------------------------------------------- |
| `CLINIC_001` | "Clinic not found"                              | Clínica no encontrada                          |
| `CLINIC_002` | "Doctor already associated with clinic"         | Doctor ya asociado                             |
| `CLINIC_003` | "Invalid operating hours format"                | Formato de horarios inválido                   |
| `CLINIC_004` | "Cannot delete clinic with active appointments" | No se puede eliminar clínica con citas activas |
| `CLINIC_005` | "Resource not available"                        | Recurso no disponible                          |
| `CLINIC_006` | "Invalid clinic status"                         | Estado de clínica inválido                     |
| `CLINIC_007` | "Settings not found for clinic"                 | Configuraciones no encontradas                 |

### **Ejemplo de Respuesta de Error:**

```json
{
  "success": false,
  "message": "Doctor already associated with clinic",
  "code": "CLINIC_002",
  "details": {
    "doctor_id": 3,
    "clinic_id": 1,
    "existing_association_id": 5
  }
}
```

---

## 📱 **CASOS DE USO FRONTEND**

### **1. Dashboard de Clínica para Doctor:**

```javascript
// 1. Obtener clínicas del doctor
GET /api/user_clinics/

// 2. Seleccionar clínica y obtener dashboard
GET /api/clinics/{clinic_id}/dashboard/

// 3. Mostrar estadísticas en tiempo real
```

### **2. Configuración de Horarios:**

```javascript
// 1. Obtener configuraciones actuales
GET /api/settings/by_clinic/?clinic_id=1

// 2. Actualizar horarios de atención
POST /api/settings/{id}/update_business_hours/

// 3. Confirmar cambios y notificar usuarios
```

### **3. Gestión de Recursos:**

```javascript
// 1. Listar recursos de la clínica
GET /api/resources/?clinic=1

// 2. Agregar nuevo recurso
POST /api/resources/

// 3. Actualizar disponibilidad
PATCH /api/resources/{id}/
```

---

## 🔄 **INTEGRACIÓN CON OTROS MÓDULOS**

### **Con Citas (Appointments):**

- Verificar disponibilidad de recursos
- Aplicar configuraciones de duración y horarios
- Validar especialidades disponibles

### **Con Usuarios (Users):**

- Asociar doctores a clínicas
- Verificar permisos por clínica
- Gestionar roles y accesos

### **Con Facturación (Billing):**

- Aplicar tarifas por clínica
- Generar reportes de ingresos
- Configurar métodos de pago

### **Con Analytics:**

- Generar métricas de rendimiento
- Comparar clínicas
- Reportes operacionales

---

## 📝 **NOTAS IMPORTANTES**

1. **Permisos Granulares:** Los doctores solo pueden ver y modificar sus clínicas asociadas
2. **Configuraciones Heredadas:** Las nuevas clínicas heredan configuraciones por defecto
3. **Validación de Horarios:** Los horarios deben ser consistentes con las citas programadas
4. **Multi-clínica:** Un doctor puede estar asociado a múltiples clínicas
5. **Geolocalización:** Incluir coordenadas para mapas y distancias
6. **Estados de Clínica:** Respetar el flujo de estados (activa, inactiva, pendiente)
7. **Recursos Compartidos:** Los recursos pueden ser compartidos entre especialidades
