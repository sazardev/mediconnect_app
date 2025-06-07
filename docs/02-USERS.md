# 👥 USUARIOS - DOCTORES Y PACIENTES

## 📋 **RESUMEN EJECUTIVO**

Este módulo gestiona los perfiles completos de usuarios (doctores y pacientes), incluyendo información personal, profesional, médica, especialidades, horarios de disponibilidad, y configuraciones de cuenta. Es fundamental para el funcionamiento de todo el sistema MediConnect.

---

## 🎯 **ENDPOINTS PRINCIPALES**

### **Base URL**: `/api/users/`

| Método   | Endpoint                                      | Descripción                              | Permisos      |
| -------- | --------------------------------------------- | ---------------------------------------- | ------------- |
| `GET`    | `/api/users/`                                 | Listar usuarios (filtrado por rol)       | Admin         |
| `POST`   | `/api/users/`                                 | Crear nuevo usuario                      | Admin         |
| `GET`    | `/api/users/{id}/`                            | Obtener detalles de usuario específico   | Admin, Owner  |
| `PUT`    | `/api/users/{id}/`                            | Actualizar usuario completo              | Admin, Owner  |
| `PATCH`  | `/api/users/{id}/`                            | Actualizar campos específicos de usuario | Admin, Owner  |
| `DELETE` | `/api/users/{id}/`                            | Eliminar usuario (soft delete)           | Admin         |
| `GET`    | `/api/users/me/`                              | Obtener perfil del usuario autenticado   | Authenticated |
| `PUT`    | `/api/users/me/`                              | Actualizar perfil propio                 | Authenticated |
| `GET`    | `/api/users/doctors/`                         | Listar solo doctores                     | All           |
| `GET`    | `/api/users/patients/`                        | Listar pacientes asignados               | Doctor, Admin |
| `GET`    | `/api/users/search/`                          | Buscar usuarios por criterios            | Admin, Doctor |
| `POST`   | `/api/users/upload-avatar/`                   | Subir foto de perfil                     | Authenticated |
| `POST`   | `/api/users/change-password/`                 | Cambiar contraseña                       | Authenticated |
| `POST`   | `/api/users/reset-password/`                  | Solicitar reset de contraseña            | All           |
| `GET`    | `/api/users/specialties/`                     | Obtener especialidades médicas           | All           |
| `GET`    | `/api/users/doctor-availability/{doctor_id}/` | Obtener disponibilidad de doctor         | All           |
| `PUT`    | `/api/users/doctor-availability/{doctor_id}/` | Actualizar disponibilidad                | Doctor, Admin |

---

## 🏗️ **ESTRUCTURAS DE DATOS JSON**

### **1. Usuario Base (User)**

```json
{
  "id": 123,
  "username": "doctor_martinez",
  "email": "dr.martinez@medicenter.com",
  "first_name": "María",
  "last_name": "Martínez García",
  "user_type": "doctor",
  "is_active": true,
  "is_verified": true,
  "date_joined": "2024-01-15T10:30:00Z",
  "last_login": "2024-12-20T09:15:00Z",
  "avatar": "https://storage.googleapis.com/mediconnect/avatars/doctor_martinez.jpg",
  "phone": "+52-555-123-4567",
  "date_of_birth": "1985-03-20",
  "gender": "F",
  "address": {
    "street": "Av. Reforma 123",
    "city": "Ciudad de México",
    "state": "CDMX",
    "zip_code": "06100",
    "country": "México"
  },
  "emergency_contact": {
    "name": "Juan Martínez",
    "phone": "+52-555-987-6543",
    "relationship": "Esposo"
  },
  "preferences": {
    "language": "es",
    "timezone": "America/Mexico_City",
    "notifications": {
      "email": true,
      "sms": false,
      "push": true,
      "appointment_reminders": true,
      "chat_messages": true
    }
  },
  "profile_completion": 85,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-12-20T08:45:00Z"
}
```

### **2. Perfil de Doctor (DoctorProfile)**

```json
{
  "id": 456,
  "user": 123,
  "license_number": "MED-2024-001234",
  "specialties": [
    {
      "id": 1,
      "name": "Cardiología",
      "code": "CARD",
      "description": "Especialista en enfermedades del corazón"
    },
    {
      "id": 2,
      "name": "Medicina Interna",
      "code": "MINT",
      "description": "Medicina general para adultos"
    }
  ],
  "medical_school": "Universidad Nacional Autónoma de México",
  "graduation_year": 2010,
  "residency": "Hospital General de México",
  "board_certifications": [
    {
      "specialty": "Cardiología",
      "certification_body": "Consejo Mexicano de Cardiología",
      "certification_date": "2015-06-15",
      "expiry_date": "2025-06-15",
      "certificate_number": "CMC-2015-5432"
    }
  ],
  "years_experience": 14,
  "consultation_fee": 1500.0,
  "currency": "MXN",
  "languages": ["Español", "Inglés", "Francés"],
  "bio": "Cardióloga con más de 14 años de experiencia en el diagnóstico y tratamiento de enfermedades cardiovasculares. Especializada en ecocardiografía y cateterismo cardíaco.",
  "education": [
    {
      "degree": "Médico Cirujano",
      "institution": "UNAM - Facultad de Medicina",
      "year": 2010
    },
    {
      "degree": "Especialidad en Cardiología",
      "institution": "Hospital General de México",
      "year": 2014
    }
  ],
  "achievements": [
    "Certificación en Ecocardiografía Avanzada - 2016",
    "Premio Nacional de Cardiología - 2020",
    "Miembro del Colegio de Cardiología - 2015"
  ],
  "clinic_affiliations": [
    {
      "clinic_id": 1,
      "clinic_name": "Centro Médico ABC",
      "role": "Médico Titular",
      "start_date": "2015-03-01"
    }
  ],
  "availability": {
    "monday": {
      "available": true,
      "morning": { "start": "08:00", "end": "12:00" },
      "afternoon": { "start": "14:00", "end": "18:00" }
    },
    "tuesday": {
      "available": true,
      "morning": { "start": "08:00", "end": "12:00" },
      "afternoon": { "start": "14:00", "end": "18:00" }
    },
    "wednesday": {
      "available": true,
      "morning": { "start": "08:00", "end": "12:00" },
      "afternoon": null
    },
    "thursday": {
      "available": true,
      "morning": { "start": "08:00", "end": "12:00" },
      "afternoon": { "start": "14:00", "end": "18:00" }
    },
    "friday": {
      "available": true,
      "morning": { "start": "08:00", "end": "12:00" },
      "afternoon": null
    },
    "saturday": { "available": false },
    "sunday": { "available": false }
  },
  "appointment_duration": 30,
  "max_daily_appointments": 16,
  "advance_booking_days": 30,
  "rating": 4.8,
  "total_reviews": 124,
  "total_patients": 890,
  "is_accepting_new_patients": true,
  "consultation_methods": ["presencial", "videollamada", "telefono"],
  "verification_status": "verified",
  "verification_documents": [
    {
      "type": "cedula_profesional",
      "status": "approved",
      "uploaded_at": "2024-01-15T10:30:00Z"
    },
    {
      "type": "certificado_especialidad",
      "status": "approved",
      "uploaded_at": "2024-01-15T10:35:00Z"
    }
  ],
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-12-20T08:45:00Z"
}
```

### **3. Perfil de Paciente (PatientProfile)**

```json
{
  "id": 789,
  "user": 124,
  "medical_record_number": "PAT-2024-005678",
  "blood_type": "O+",
  "height": 175.5,
  "weight": 70.2,
  "bmi": 22.8,
  "allergies": [
    {
      "allergen": "Penicilina",
      "severity": "high",
      "reaction": "Erupción cutánea severa",
      "diagnosed_date": "2020-05-15"
    },
    {
      "allergen": "Mariscos",
      "severity": "medium",
      "reaction": "Urticaria",
      "diagnosed_date": "2018-08-20"
    }
  ],
  "chronic_conditions": [
    {
      "condition": "Hipertensión Arterial",
      "icd_code": "I10",
      "diagnosed_date": "2022-03-10",
      "status": "controlled",
      "medications": ["Losartán 50mg", "Hidroclorotiazida 25mg"]
    }
  ],
  "current_medications": [
    {
      "medication": "Losartán",
      "dosage": "50mg",
      "frequency": "Una vez al día",
      "start_date": "2022-03-15",
      "prescribed_by": "Dr. Martínez",
      "notes": "Tomar en ayunas"
    }
  ],
  "emergency_contacts": [
    {
      "name": "Ana López",
      "relationship": "Madre",
      "phone": "+52-555-111-2222",
      "email": "ana.lopez@email.com",
      "is_primary": true
    },
    {
      "name": "Carlos López",
      "relationship": "Padre",
      "phone": "+52-555-333-4444",
      "email": "carlos.lopez@email.com",
      "is_primary": false
    }
  ],
  "insurance_info": {
    "provider": "Seguros Monterrey New York Life",
    "policy_number": "POL-2024-789456",
    "group_number": "GRP-001",
    "coverage_type": "Gastos Médicos Mayores",
    "coverage_amount": 2000000.0,
    "deductible": 10000.0,
    "copay_percentage": 10,
    "expiry_date": "2025-12-31",
    "status": "active"
  },
  "family_history": [
    {
      "condition": "Diabetes Tipo 2",
      "relative": "Padre",
      "age_diagnosed": 55,
      "notes": "Controlada con dieta y medicamentos"
    },
    {
      "condition": "Hipertensión",
      "relative": "Madre",
      "age_diagnosed": 48,
      "notes": "Requirió medicación"
    }
  ],
  "lifestyle": {
    "smoking": {
      "status": "never",
      "packs_per_day": 0,
      "years_smoking": 0,
      "quit_date": null
    },
    "alcohol": {
      "status": "social",
      "drinks_per_week": 2,
      "type": "beer_wine"
    },
    "exercise": {
      "frequency": "3-4 times per week",
      "type": "cardio_strength",
      "duration_minutes": 45
    },
    "diet": {
      "type": "balanced",
      "restrictions": ["low_sodium"],
      "notes": "Siguiendo dieta para hipertensión"
    }
  },
  "primary_doctor": {
    "doctor_id": 123,
    "doctor_name": "Dra. María Martínez",
    "specialty": "Cardiología",
    "assigned_date": "2022-03-01"
  },
  "preferred_language": "Español",
  "preferred_contact_method": "email",
  "consent_forms": [
    {
      "type": "tratamiento_datos_personales",
      "signed": true,
      "signed_date": "2024-01-15T10:30:00Z",
      "version": "1.2"
    },
    {
      "type": "comunicacion_electronica",
      "signed": true,
      "signed_date": "2024-01-15T10:30:00Z",
      "version": "1.0"
    }
  ],
  "last_visit_date": "2024-12-15T14:30:00Z",
  "next_appointment_date": "2025-01-20T10:00:00Z",
  "total_visits": 15,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-12-20T08:45:00Z"
}
```

---

## 🔐 **PERMISOS Y AUTORIZACIONES**

### **Matriz de Permisos por Endpoint**

| Endpoint                   | Admin | Doctor | Patient | Descripción                                |
| -------------------------- | ----- | ------ | ------- | ------------------------------------------ |
| `GET /api/users/`          | ✅    | ❌     | ❌      | Solo admin puede listar todos los usuarios |
| `POST /api/users/`         | ✅    | ❌     | ❌      | Solo admin puede crear usuarios            |
| `GET /api/users/{id}/`     | ✅    | 🟡     | 🟡      | Admin: todos; Otros: solo su perfil        |
| `PUT /api/users/{id}/`     | ✅    | 🟡     | 🟡      | Admin: todos; Otros: solo su perfil        |
| `DELETE /api/users/{id}/`  | ✅    | ❌     | ❌      | Solo admin puede eliminar usuarios         |
| `GET /api/users/me/`       | ✅    | ✅     | ✅      | Todos pueden ver su propio perfil          |
| `PUT /api/users/me/`       | ✅    | ✅     | ✅      | Todos pueden actualizar su perfil          |
| `GET /api/users/doctors/`  | ✅    | ✅     | ✅      | Listado público de doctores                |
| `GET /api/users/patients/` | ✅    | ✅     | ❌      | Admin: todos; Doctor: sus pacientes        |
| `GET /api/users/search/`   | ✅    | ✅     | ❌      | Búsqueda para admin y doctores             |

### **Reglas de Negocio Críticas**

1. **Verificación de Doctores**: Los doctores deben subir y aprobar documentos antes de aparecer en búsquedas públicas
2. **Pacientes Asignados**: Un doctor solo puede ver pacientes que han tenido citas con él
3. **Información Sensible**: Los datos médicos de pacientes solo son visibles para doctores autorizados y admin
4. **Perfil Propio**: Todos los usuarios pueden editar su información básica, pero no pueden cambiar su `user_type`
5. **Soft Delete**: Los usuarios eliminados mantienen sus registros históricos pero se marcan como inactivos

---

## 🔍 **PARÁMETROS DE CONSULTA (QUERY PARAMETERS)**

### **GET /api/users/** (Solo Admin)

```javascript
// Filtros disponibles
{
  "user_type": "doctor|patient|admin",
  "is_active": "true|false",
  "is_verified": "true|false",
  "specialties": "1,2,3", // IDs de especialidades (solo doctores)
  "city": "Ciudad de México",
  "state": "CDMX",
  "accepting_patients": "true|false", // Solo doctores
  "search": "término de búsqueda", // Busca en nombre, email, especialidades
  "ordering": "first_name|last_name|date_joined|rating", // Ordenamiento
  "page": 1,
  "page_size": 20
}
```

### **GET /api/users/doctors/**

```javascript
// Filtros públicos para doctores
{
  "specialties": "1,2,3",
  "city": "Ciudad de México",
  "accepting_patients": "true",
  "min_rating": "4.0",
  "max_fee": "2000",
  "languages": "Español,Inglés",
  "consultation_method": "presencial|videollamada|telefono",
  "available_today": "true", // Doctores con citas disponibles hoy
  "search": "término de búsqueda",
  "ordering": "rating|fee|experience|-rating", // - para descendente
  "page": 1,
  "page_size": 12
}
```

### **GET /api/users/patients/** (Doctor/Admin)

```javascript
// Para doctores: solo sus pacientes asignados
{
  "blood_type": "A+|B+|AB+|O+|A-|B-|AB-|O-",
  "has_allergies": "true|false",
  "chronic_conditions": "diabetes,hipertension",
  "age_range": "18-30", // formato: min-max
  "last_visit": "30", // días desde última visita
  "search": "término de búsqueda",
  "ordering": "last_name|last_visit|next_appointment",
  "page": 1,
  "page_size": 15
}
```

---

## 📝 **CASOS DE USO DETALLADOS**

### **1. Registro de Nuevo Doctor**

**Flujo Completo:**

1. **Admin crea usuario base**:

   ```javascript
   POST /
     api /
     users /
     {
       username: "doctor_nuevo",
       email: "doctor@email.com",
       first_name: "Juan",
       last_name: "Pérez",
       user_type: "doctor",
       phone: "+52-555-123-4567",
       password: "temporal123",
     };
   ```

2. **Doctor completa su perfil**:

   ```javascript
   PUT /api/users/me/
   {
     "date_of_birth": "1980-05-15",
     "address": {...},
     "doctor_profile": {
       "license_number": "MED-2024-001235",
       "specialties": [1, 3],
       "medical_school": "UNAM",
       "graduation_year": 2005,
       "consultation_fee": 1200.00,
       "bio": "Descripción profesional...",
       "languages": ["Español", "Inglés"]
     }
   }
   ```

3. **Doctor sube documentos de verificación**:

   ```javascript
   POST /api/users/upload-verification-documents/
   // FormData con archivos PDF
   ```

4. **Admin verifica y aprueba documentos**:
   ```javascript
   PUT /
     api /
     users /
     { doctor_id } /
     verify /
     {
       verification_status: "verified",
       documents_approved: ["cedula_profesional", "certificado_especialidad"],
     };
   ```

### **2. Búsqueda de Doctores por Paciente**

**Implementación Frontend:**

```javascript
// Búsqueda inicial con filtros básicos
GET /api/users/doctors/?specialties=1&city=CDMX&accepting_patients=true&page=1

// Búsqueda avanzada con múltiples filtros
GET /api/users/doctors/?specialties=1,2&min_rating=4.0&max_fee=1500&languages=Español&consultation_method=videollamada&available_today=true&ordering=rating&page=1&page_size=12

// Respuesta esperada
{
  "count": 45,
  "next": "http://localhost:8000/api/users/doctors/?page=2",
  "previous": null,
  "results": [
    {
      "id": 123,
      "first_name": "María",
      "last_name": "Martínez",
      "specialties": [...],
      "rating": 4.8,
      "consultation_fee": 1500.00,
      "languages": ["Español", "Inglés"],
      "avatar": "https://...",
      "is_accepting_new_patients": true,
      "next_available_slot": "2024-12-21T10:00:00Z"
    }
  ]
}
```

### **3. Gestión de Perfil de Paciente**

**Actualización de Información Médica:**

```javascript
PATCH /
  api /
  users /
  me /
  {
    patient_profile: {
      allergies: [
        {
          allergen: "Aspirina",
          severity: "high",
          reaction: "Dificultad respiratoria",
          diagnosed_date: "2024-12-20",
        },
      ],
      chronic_conditions: [
        {
          condition: "Diabetes Tipo 2",
          icd_code: "E11",
          diagnosed_date: "2024-12-15",
          status: "newly_diagnosed",
          medications: ["Metformina 850mg"],
        },
      ],
    },
  };
```

---

## ⚠️ **VALIDACIONES Y ERRORES**

### **Errores Comunes y Manejo**

```javascript
// Error 400 - Datos inválidos
{
  "error": "validation_error",
  "message": "Los datos proporcionados no son válidos",
  "details": {
    "email": ["Este email ya está registrado"],
    "license_number": ["El número de cédula ya existe"],
    "phone": ["Formato de teléfono inválido"]
  }
}

// Error 403 - Permisos insuficientes
{
  "error": "permission_denied",
  "message": "No tienes permisos para acceder a este recurso",
  "required_permission": "view_user_profile",
  "user_type_required": "admin"
}

// Error 404 - Usuario no encontrado
{
  "error": "not_found",
  "message": "El usuario solicitado no existe",
  "resource": "user",
  "id": 999
}
```

### **Validaciones de Campo**

```javascript
// Validaciones para Doctor Profile
{
  "license_number": {
    "required": true,
    "pattern": "^MED-\\d{4}-\\d{6}$",
    "unique": true
  },
  "consultation_fee": {
    "min": 100.00,
    "max": 10000.00,
    "decimal_places": 2
  },
  "specialties": {
    "min_items": 1,
    "max_items": 5,
    "must_exist": true
  }
}

// Validaciones para Patient Profile
{
  "blood_type": {
    "choices": ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
  },
  "height": {
    "min": 50.0,
    "max": 250.0,
    "unit": "cm"
  },
  "weight": {
    "min": 10.0,
    "max": 500.0,
    "unit": "kg"
  }
}
```

---

## 🔔 **TRIGGERS DE NOTIFICACIONES**

### **Eventos que Generan Notificaciones**

```javascript
// Al completar perfil de doctor
{
  "event": "doctor_profile_completed",
  "recipients": ["admin"],
  "data": {
    "doctor_id": 123,
    "doctor_name": "Dr. Juan Pérez",
    "requires_verification": true
  }
}

// Al verificar doctor
{
  "event": "doctor_verified",
  "recipients": ["doctor"],
  "data": {
    "verification_status": "approved",
    "can_receive_appointments": true
  }
}

// Al actualizar información médica crítica
{
  "event": "patient_medical_info_updated",
  "recipients": ["primary_doctor", "admin"],
  "data": {
    "patient_id": 789,
    "updated_fields": ["allergies", "medications"],
    "critical_changes": true
  }
}
```

---

## 📊 **MÉTRICAS Y ANALYTICS**

### **Datos de Rendimiento del Módulo**

```javascript
// Métricas disponibles en /api/analytics/users/
{
  "total_users": 1500,
  "users_by_type": {
    "doctors": 120,
    "patients": 1350,
    "admins": 30
  },
  "verified_doctors": 95,
  "active_users_last_30_days": 890,
  "new_registrations_this_month": 45,
  "profile_completion_rates": {
    "doctors": 85.3,
    "patients": 92.1
  },
  "top_specialties": [
    {"specialty": "Medicina General", "count": 25},
    {"specialty": "Cardiología", "count": 18},
    {"specialty": "Dermatología", "count": 15}
  ]
}
```

---

## 🚀 **IMPLEMENTACIÓN RECOMENDADA**

### **Orden de Implementación Frontend**

1. **Autenticación y Roles** (Prerequisito)
2. **Listado de Doctores** (Funcionalidad pública)
3. **Perfil de Usuario Básico** (Me endpoint)
4. **Búsqueda Avanzada de Doctores**
5. **Gestión Completa de Perfiles**
6. **Sistema de Verificación de Doctores** (Admin)
7. **Configuraciones y Preferencias**

### **Consideraciones de UX/UI**

- **Progreso de Perfil**: Mostrar barra de completitud de perfil
- **Verificación Visual**: Badges para doctores verificados
- **Filtros Intuitivos**: Interfaz de búsqueda con filtros colapsables
- **Información Sensible**: Campos médicos con adecuada privacidad
- **Disponibilidad**: Calendario visual para horarios de doctores
- **Responsive**: Optimizado para móvil (muchos usuarios son pacientes)

---

## 🔗 **RELACIONES CON OTROS MÓDULOS**

- **Appointments**: Los usuarios crean y gestionan citas
- **Medical Records**: Doctores acceden a historiales de sus pacientes
- **Chat**: Comunicación entre doctores y pacientes
- **Notifications**: Alertas sobre cambios de perfil y verificaciones
- **Billing**: Información de facturación vinculada a perfiles
- **Analytics**: Métricas de uso y comportamiento de usuarios

---

_Última actualización: Diciembre 2024_
