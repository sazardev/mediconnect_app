# 📅 CITAS MÉDICAS - APPOINTMENTS

## 📋 **RESUMEN EJECUTIVO**

El módulo de citas médicas es el corazón operativo de MediConnect, gestionando la programación, modificación, cancelación y seguimiento de citas entre doctores y pacientes. Incluye disponibilidad en tiempo real, recordatorios automáticos, políticas de cancelación, y integración completa con WebSockets para actualizaciones en vivo.

---

## 🎯 **ENDPOINTS PRINCIPALES**

### **Base URL**: `/api/appointments/`

| Método   | Endpoint                                         | Descripción                          | Permisos             |
| -------- | ------------------------------------------------ | ------------------------------------ | -------------------- |
| `GET`    | `/api/appointments/`                             | Listar citas (filtradas por usuario) | Authenticated        |
| `POST`   | `/api/appointments/`                             | Crear nueva cita                     | Patient, Admin       |
| `GET`    | `/api/appointments/{id}/`                        | Obtener detalles de cita específica  | Owner, Doctor, Admin |
| `PUT`    | `/api/appointments/{id}/`                        | Actualizar cita completa             | Owner, Doctor, Admin |
| `PATCH`  | `/api/appointments/{id}/`                        | Actualizar campos específicos        | Owner, Doctor, Admin |
| `DELETE` | `/api/appointments/{id}/`                        | Cancelar cita (soft delete)          | Owner, Doctor, Admin |
| `GET`    | `/api/appointments/calendar/`                    | Vista de calendario con citas        | Authenticated        |
| `GET`    | `/api/appointments/available-slots/`             | Obtener horarios disponibles         | All                  |
| `POST`   | `/api/appointments/{id}/confirm/`                | Confirmar cita                       | Doctor, Admin        |
| `POST`   | `/api/appointments/{id}/reschedule/`             | Reprogramar cita                     | Owner, Doctor, Admin |
| `POST`   | `/api/appointments/{id}/cancel/`                 | Cancelar con razón                   | Owner, Doctor, Admin |
| `POST`   | `/api/appointments/{id}/complete/`               | Marcar como completada               | Doctor, Admin        |
| `POST`   | `/api/appointments/{id}/no-show/`                | Marcar como no asistió               | Doctor, Admin        |
| `GET`    | `/api/appointments/upcoming/`                    | Próximas citas del usuario           | Authenticated        |
| `GET`    | `/api/appointments/history/`                     | Historial de citas                   | Authenticated        |
| `GET`    | `/api/appointments/statistics/`                  | Estadísticas de citas                | Doctor, Admin        |
| `POST`   | `/api/appointments/book-emergency/`              | Agendar cita de emergencia           | Patient, Admin       |
| `GET`    | `/api/appointments/doctor-schedule/{doctor_id}/` | Horario de doctor específico         | All                  |
| `PUT`    | `/api/appointments/bulk-update/`                 | Actualización masiva                 | Doctor, Admin        |

---

## 🏗️ **ESTRUCTURAS DE DATOS JSON**

### **1. Cita Médica (Appointment)**

```json
{
  "id": 1001,
  "appointment_number": "APT-2024-001001",
  "patient": {
    "id": 789,
    "full_name": "Ana López García",
    "email": "ana.lopez@email.com",
    "phone": "+52-555-111-2222",
    "avatar": "https://storage.googleapis.com/avatars/ana_lopez.jpg",
    "medical_record_number": "PAT-2024-005678",
    "age": 32,
    "gender": "F"
  },
  "doctor": {
    "id": 123,
    "full_name": "Dra. María Martínez García",
    "email": "dr.martinez@medicenter.com",
    "phone": "+52-555-123-4567",
    "avatar": "https://storage.googleapis.com/avatars/doctor_martinez.jpg",
    "license_number": "MED-2024-001234",
    "specialties": ["Cardiología", "Medicina Interna"],
    "consultation_fee": 1500.0
  },
  "clinic": {
    "id": 1,
    "name": "Centro Médico ABC",
    "address": "Av. Reforma 123, Col. Centro, CDMX",
    "phone": "+52-555-200-3000"
  },
  "appointment_date": "2024-12-25T10:00:00Z",
  "appointment_end": "2024-12-25T10:30:00Z",
  "duration_minutes": 30,
  "appointment_type": "consultation",
  "consultation_method": "presencial",
  "status": "scheduled",
  "priority": "normal",
  "reason": "Revisión de rutina y control de presión arterial",
  "symptoms": [
    "Dolor de cabeza ocasional",
    "Fatiga matutina",
    "Presión alta en casa"
  ],
  "notes": "Paciente reporta lecturas de PA de 150/90 en mediciones caseras",
  "internal_notes": "Revisar medicación actual. Considerar ajuste de dosis.", // Solo visible para doctor/admin
  "fees": {
    "consultation_fee": 1500.0,
    "additional_fees": 0.0,
    "total_amount": 1500.0,
    "currency": "MXN",
    "payment_status": "pending",
    "payment_method": null,
    "discount": 0.0,
    "insurance_covered": 1350.0,
    "patient_pays": 150.0
  },
  "reminders": {
    "email_24h": {
      "sent": true,
      "sent_at": "2024-12-24T10:00:00Z"
    },
    "sms_2h": {
      "sent": false,
      "scheduled_for": "2024-12-25T08:00:00Z"
    },
    "push_30m": {
      "sent": false,
      "scheduled_for": "2024-12-25T09:30:00Z"
    }
  },
  "follow_up": {
    "required": true,
    "suggested_date": "2025-01-25T10:00:00Z",
    "interval_days": 30,
    "reason": "Control de medicación y monitoreo de PA"
  },
  "attachments": [
    {
      "id": 101,
      "type": "lab_result",
      "filename": "laboratorio_20241215.pdf",
      "url": "https://storage.googleapis.com/attachments/lab_101.pdf",
      "uploaded_by": "patient",
      "uploaded_at": "2024-12-20T14:30:00Z"
    }
  ],
  "medications_prescribed": [
    {
      "medication": "Losartán",
      "dosage": "50mg",
      "frequency": "Una vez al día",
      "duration": "30 días",
      "instructions": "Tomar en ayunas"
    }
  ],
  "vitals_recorded": {
    "blood_pressure": {
      "systolic": 145,
      "diastolic": 88,
      "recorded_at": "2024-12-25T10:15:00Z"
    },
    "heart_rate": 72,
    "temperature": 36.5,
    "weight": 70.2,
    "height": 175.5
  },
  "cancellation_policy": {
    "can_cancel_until": "2024-12-25T04:00:00Z", // 6 horas antes
    "penalty_amount": 0.0,
    "free_cancellations_remaining": 2
  },
  "created_at": "2024-12-20T15:45:00Z",
  "updated_at": "2024-12-22T09:30:00Z",
  "created_by": "patient",
  "last_modified_by": "doctor"
}
```

### **2. Horarios Disponibles (Available Slots)**

```json
{
  "doctor_id": 123,
  "doctor_name": "Dra. María Martínez García",
  "clinic_id": 1,
  "clinic_name": "Centro Médico ABC",
  "date": "2024-12-25",
  "available_slots": [
    {
      "start_time": "08:00:00",
      "end_time": "08:30:00",
      "datetime": "2024-12-25T08:00:00Z",
      "is_available": true,
      "appointment_type": "consultation",
      "consultation_methods": ["presencial", "videollamada"],
      "slot_id": "slot_20241225_0800"
    },
    {
      "start_time": "08:30:00",
      "end_time": "09:00:00",
      "datetime": "2024-12-25T08:30:00Z",
      "is_available": true,
      "appointment_type": "consultation",
      "consultation_methods": ["presencial", "videollamada"],
      "slot_id": "slot_20241225_0830"
    },
    {
      "start_time": "09:00:00",
      "end_time": "09:30:00",
      "datetime": "2024-12-25T09:00:00Z",
      "is_available": false,
      "reason": "Ya reservada",
      "appointment_id": 1000,
      "slot_id": "slot_20241225_0900"
    }
  ],
  "total_slots": 16,
  "available_slots_count": 15,
  "next_available": "2024-12-25T08:00:00Z",
  "booking_window": {
    "earliest_booking": "2024-12-21T00:00:00Z",
    "latest_booking": "2025-01-24T23:59:59Z"
  }
}
```

### **3. Calendario de Citas (Calendar View)**

```json
{
  "month": "2024-12",
  "user_type": "patient",
  "user_id": 789,
  "days": [
    {
      "date": "2024-12-25",
      "appointments": [
        {
          "id": 1001,
          "time": "10:00",
          "duration": 30,
          "doctor_name": "Dra. María Martínez",
          "status": "scheduled",
          "type": "consultation",
          "priority": "normal"
        }
      ],
      "has_appointments": true,
      "appointments_count": 1
    },
    {
      "date": "2024-12-26",
      "appointments": [],
      "has_appointments": false,
      "appointments_count": 0
    }
  ],
  "summary": {
    "total_appointments": 5,
    "scheduled": 3,
    "completed": 1,
    "cancelled": 1,
    "upcoming_this_week": 2
  }
}
```

---

## 🔐 **PERMISOS Y AUTORIZACIONES**

### **Matriz de Permisos por Endpoint**

| Endpoint                                 | Admin | Doctor | Patient | Descripción                                   |
| ---------------------------------------- | ----- | ------ | ------- | --------------------------------------------- |
| `GET /api/appointments/`                 | ✅    | 🟡     | 🟡      | Admin: todas; Others: propias                 |
| `POST /api/appointments/`                | ✅    | ❌     | ✅      | Pacientes crean, admin puede crear para otros |
| `GET /api/appointments/{id}/`            | ✅    | 🟡     | 🟡      | Si están involucrados en la cita              |
| `PUT /api/appointments/{id}/`            | ✅    | 🟡     | 🟡      | Con restricciones según rol                   |
| `DELETE /api/appointments/{id}/`         | ✅    | 🟡     | 🟡      | Cancelación con políticas                     |
| `GET /api/appointments/calendar/`        | ✅    | ✅     | ✅      | Vista personal de calendario                  |
| `GET /api/appointments/available-slots/` | ✅    | ✅     | ✅      | Consulta pública de disponibilidad            |
| `POST /api/appointments/{id}/confirm/`   | ✅    | ✅     | ❌      | Solo doctor puede confirmar                   |
| `POST /api/appointments/{id}/complete/`  | ✅    | ✅     | ❌      | Solo doctor marca como completada             |
| `POST /api/appointments/{id}/no-show/`   | ✅    | ✅     | ❌      | Solo doctor marca inasistencia                |

### **Reglas de Negocio Críticas**

1. **Ventana de Reserva**: Citas solo se pueden agendar entre 1 hora y 30 días de anticipación
2. **Horarios de Doctor**: Solo se pueden agendar citas en horarios definidos por el doctor
3. **Confirmación**: Doctor debe confirmar citas dentro de 2 horas o se cancelan automáticamente
4. **Cancelación**: Pacientes pueden cancelar hasta 6 horas antes sin penalización
5. **Reprogramación**: Máximo 2 reprogramaciones por cita
6. **Citas Simultáneas**: Un doctor no puede tener citas simultáneas
7. **Emergencias**: Citas de emergencia pueden sobrepasar límites normales

---

## 🔍 **PARÁMETROS DE CONSULTA (QUERY PARAMETERS)**

### **GET /api/appointments/**

```javascript
// Filtros disponibles
{
  "status": "scheduled|confirmed|completed|cancelled|no_show",
  "appointment_type": "consultation|follow_up|emergency|check_up",
  "consultation_method": "presencial|videollamada|telefono",
  "doctor": "123", // ID del doctor
  "patient": "789", // ID del paciente
  "clinic": "1", // ID de la clínica
  "date_from": "2024-12-01", // Formato YYYY-MM-DD
  "date_to": "2024-12-31",
  "priority": "low|normal|high|urgent",
  "payment_status": "pending|paid|refunded",
  "has_follow_up": "true|false",
  "created_by": "patient|doctor|admin",
  "search": "término de búsqueda", // Busca en razón, síntomas, notas
  "ordering": "appointment_date|created_at|status|-appointment_date",
  "page": 1,
  "page_size": 20
}
```

### **GET /api/appointments/available-slots/**

```javascript
// Parámetros para obtener horarios disponibles
{
  "doctor": "123", // Obligatorio - ID del doctor
  "date": "2024-12-25", // Obligatorio - Formato YYYY-MM-DD
  "consultation_method": "presencial|videollamada|telefono",
  "appointment_type": "consultation|follow_up",
  "duration": "30", // Duración en minutos (opcional)
  "clinic": "1" // ID de clínica específica (opcional)
}
```

### **GET /api/appointments/calendar/**

```javascript
// Vista de calendario
{
  "year": "2024",
  "month": "12", // 1-12
  "view": "month|week|day",
  "doctor": "123", // Solo para admin - ver calendario de doctor específico
  "include_cancelled": "false",
  "timezone": "America/Mexico_City"
}
```

---

## 📝 **CASOS DE USO DETALLADOS**

### **1. Agendar Nueva Cita (Paciente)**

**Flujo Completo:**

1. **Buscar doctores disponibles**:

   ```javascript
   GET /api/users/doctors/?specialties=1&city=CDMX&accepting_patients=true
   ```

2. **Verificar horarios disponibles**:

   ```javascript
   GET /api/appointments/available-slots/?doctor=123&date=2024-12-25&consultation_method=presencial
   ```

3. **Crear la cita**:

   ```javascript
   POST /
     api /
     appointments /
     {
       doctor: 123,
       appointment_date: "2024-12-25T10:00:00Z",
       consultation_method: "presencial",
       appointment_type: "consultation",
       reason: "Revisión de rutina y control de presión arterial",
       symptoms: ["Dolor de cabeza ocasional", "Fatiga matutina"],
       notes: "Paciente reporta lecturas de PA elevadas",
       preferred_reminder: {
         email: true,
         sms: true,
         push: true,
       },
     };
   ```

4. **Respuesta de creación exitosa**:
   ```javascript
   HTTP 201 Created
   {
     "id": 1001,
     "appointment_number": "APT-2024-001001",
     "status": "scheduled",
     "confirmation_required_by": "2024-12-25T12:00:00Z",
     "message": "Cita agendada exitosamente. El doctor debe confirmar en las próximas 2 horas."
   }
   ```

### **2. Confirmación de Cita (Doctor)**

**Doctor confirma cita pendiente:**

```javascript
POST /api/appointments/1001/confirm/
{
  "confirmation_notes": "Cita confirmada. Favor traer estudios recientes de laboratorio.",
  "preparation_instructions": [
    "Ayuno de 8 horas antes de la cita",
    "Traer lista de medicamentos actuales",
    "Llevar estudios de laboratorio recientes"
  ],
  "estimated_duration": 45, // Puede ajustar duración
  "send_patient_notification": true
}

// Respuesta
{
  "status": "confirmed",
  "confirmed_at": "2024-12-22T14:30:00Z",
  "patient_notified": true,
  "message": "Cita confirmada exitosamente"
}
```

### **3. Reprogramar Cita**

**Flujo de reprogramación:**

```javascript
POST /api/appointments/1001/reschedule/
{
  "new_date": "2024-12-26T14:00:00Z",
  "reason": "Emergencia familiar del paciente",
  "notify_all_parties": true,
  "keep_same_duration": true
}

// Respuesta
{
  "status": "rescheduled",
  "old_date": "2024-12-25T10:00:00Z",
  "new_date": "2024-12-26T14:00:00Z",
  "reschedule_count": 1,
  "max_reschedules": 2,
  "message": "Cita reprogramada exitosamente"
}
```

### **4. Completar Cita con Diagnóstico**

**Doctor marca cita como completada:**

```javascript
POST /
  api /
  appointments /
  1001 /
  complete /
  {
    diagnosis: "Hipertensión arterial controlada",
    treatment_notes:
      "Paciente responde bien al tratamiento actual. Continuar con medicación.",
    vitals: {
      blood_pressure: {
        systolic: 135,
        diastolic: 85,
      },
      heart_rate: 72,
      temperature: 36.5,
      weight: 70.2,
    },
    medications_prescribed: [
      {
        medication: "Losartán",
        dosage: "50mg",
        frequency: "Una vez al día",
        duration: "30 días",
        instructions: "Tomar en ayunas por las mañanas",
      },
    ],
    follow_up: {
      required: true,
      interval_days: 30,
      reason: "Control de medicación y monitoreo de presión arterial",
    },
    patient_instructions: [
      "Continuar con dieta baja en sodio",
      "Ejercicio ligero 30 minutos diarios",
      "Monitoreo de presión arterial 3 veces por semana",
    ],
  };
```

---

## ⚠️ **VALIDACIONES Y ERRORES**

### **Errores Específicos del Módulo**

```javascript
// Error 400 - Horario no disponible
{
  "error": "slot_not_available",
  "message": "El horario seleccionado no está disponible",
  "details": {
    "requested_time": "2024-12-25T10:00:00Z",
    "doctor_id": 123,
    "next_available": "2024-12-25T10:30:00Z"
  }
}

// Error 400 - Fuera de ventana de reserva
{
  "error": "booking_window_violation",
  "message": "La cita debe agendarse entre 1 hora y 30 días de anticipación",
  "details": {
    "earliest_allowed": "2024-12-21T15:00:00Z",
    "latest_allowed": "2025-01-20T15:00:00Z"
  }
}

// Error 400 - Doctor no disponible
{
  "error": "doctor_not_available",
  "message": "El doctor no está disponible en la fecha seleccionada",
  "details": {
    "doctor_id": 123,
    "requested_date": "2024-12-25",
    "doctor_schedule": {
      "works_on_date": false,
      "reason": "day_off"
    }
  }
}

// Error 403 - Límite de cancelaciones
{
  "error": "cancellation_limit_exceeded",
  "message": "Has excedido el límite de cancelaciones gratuitas",
  "details": {
    "free_cancellations_used": 3,
    "free_cancellations_limit": 3,
    "penalty_amount": 500.00,
    "currency": "MXN"
  }
}
```

### **Validaciones de Negocio**

```javascript
// Validaciones automáticas
{
  "appointment_date": {
    "future_only": true,
    "min_advance_hours": 1,
    "max_advance_days": 30,
    "business_hours_only": true
  },
  "consultation_method": {
    "must_match_doctor_availability": true,
    "requires_video_setup": ["videollamada"],
    "requires_clinic": ["presencial"]
  },
  "duration": {
    "min_minutes": 15,
    "max_minutes": 120,
    "must_fit_schedule": true
  }
}
```

---

## 🔔 **TRIGGERS DE NOTIFICACIONES Y WEBSOCKETS**

### **Eventos WebSocket**

```javascript
// Canal: appointment_updates
{
  "event": "appointment_created",
  "data": {
    "appointment_id": 1001,
    "patient_id": 789,
    "doctor_id": 123,
    "appointment_date": "2024-12-25T10:00:00Z",
    "status": "scheduled"
  },
  "recipients": ["doctor_123", "admin"]
}

{
  "event": "appointment_confirmed",
  "data": {
    "appointment_id": 1001,
    "confirmed_by": "doctor",
    "confirmation_time": "2024-12-22T14:30:00Z"
  },
  "recipients": ["patient_789"]
}

{
  "event": "appointment_reminder",
  "data": {
    "appointment_id": 1001,
    "reminder_type": "30_minutes_before",
    "appointment_time": "2024-12-25T10:00:00Z"
  },
  "recipients": ["patient_789", "doctor_123"]
}
```

### **Notificaciones Automáticas**

```javascript
// Sistema de recordatorios
{
  "24_hours_before": {
    "channels": ["email", "push"],
    "template": "appointment_reminder_24h",
    "includes": ["appointment_details", "preparation_instructions"]
  },
  "2_hours_before": {
    "channels": ["sms", "push"],
    "template": "appointment_reminder_2h",
    "includes": ["clinic_address", "contact_info"]
  },
  "30_minutes_before": {
    "channels": ["push"],
    "template": "appointment_starting_soon",
    "includes": ["doctor_name", "clinic_location"]
  }
}
```

---

## 📊 **MÉTRICAS Y ANALYTICS**

### **Estadísticas Disponibles**

```javascript
// GET /api/appointments/statistics/
{
  "period": "last_30_days",
  "total_appointments": 450,
  "by_status": {
    "scheduled": 120,
    "confirmed": 200,
    "completed": 100,
    "cancelled": 25,
    "no_show": 5
  },
  "by_type": {
    "consultation": 300,
    "follow_up": 100,
    "emergency": 30,
    "check_up": 20
  },
  "by_method": {
    "presencial": 350,
    "videollamada": 80,
    "telefono": 20
  },
  "revenue": {
    "total": 675000.00,
    "pending": 180000.00,
    "collected": 495000.00,
    "currency": "MXN"
  },
  "avg_appointment_duration": 35.5,
  "patient_satisfaction": 4.7,
  "doctor_utilization": 78.3,
  "peak_hours": [
    {"hour": "10:00", "count": 45},
    {"hour": "14:00", "count": 42},
    {"hour": "16:00", "count": 38}
  ],
  "busiest_days": [
    {"day": "martes", "count": 95},
    {"day": "jueves", "count": 87},
    {"day": "lunes", "count": 82}
  ]
}
```

---

## 🚀 **IMPLEMENTACIÓN RECOMENDADA**

### **Orden de Implementación Frontend**

1. **Vista de Disponibilidad** (Calendario de horarios libres)
2. **Creación de Citas Básica** (Formulario simple)
3. **Lista de Citas del Usuario** (Mis citas)
4. **Detalles de Cita** (Vista individual)
5. **Funciones de Gestión** (Cancelar, reprogramar)
6. **Confirmación de Doctor** (Panel médico)
7. **Sistema de Recordatorios** (Notificaciones)
8. **Vista de Calendario** (Mensual/semanal)
9. **Citas de Emergencia** (Flujo especial)
10. **Analytics y Estadísticas** (Dashboard)

### **Consideraciones de UX/UI**

- **Calendario Visual**: Interfaz de calendario intuitiva con disponibilidad
- **Confirmación Visual**: Estados claros (pendiente, confirmada, completada)
- **Recordatorios Prominentes**: Notificaciones visibles de citas próximas
- **Búsqueda Rápida**: Filtros para encontrar citas específicas
- **Acciones Contextuales**: Botones de acción según estado de la cita
- **Información Móvil**: Optimizado para gestión desde móvil
- **Tiempo Real**: Updates instantáneos vía WebSocket

### **Estados de Cita y Transiciones**

```javascript
// Flujo de estados
{
  "scheduled": {
    "next_states": ["confirmed", "cancelled"],
    "actions": ["confirm", "cancel", "reschedule"],
    "auto_transitions": {
      "to_cancelled": "2 hours without confirmation"
    }
  },
  "confirmed": {
    "next_states": ["completed", "no_show", "cancelled"],
    "actions": ["complete", "mark_no_show", "cancel", "reschedule"]
  },
  "completed": {
    "next_states": [],
    "actions": ["view_details", "create_follow_up"],
    "final_state": true
  }
}
```

---

## 🔗 **RELACIONES CON OTROS MÓDULOS**

- **Users**: Doctores y pacientes involucrados en citas
- **Medical Records**: Diagnósticos y notas se guardan en expediente
- **Chat**: Comunicación antes y después de citas
- **Notifications**: Sistema completo de recordatorios
- **Billing**: Facturación automática de citas completadas
- **Clinics**: Ubicación y recursos para citas presenciales
- **Analytics**: Métricas de rendimiento y satisfacción

---

## 🛡️ **CONSIDERACIONES DE SEGURIDAD**

```javascript
// Validaciones de seguridad
{
  "appointment_access": {
    "patient_can_view": "only_own_appointments",
    "doctor_can_view": "only_assigned_appointments",
    "admin_can_view": "all_appointments"
  },
  "sensitive_data": {
    "internal_notes": "doctor_and_admin_only",
    "payment_info": "encrypted_storage",
    "medical_data": "hipaa_compliant"
  },
  "rate_limiting": {
    "booking_requests": "5_per_minute",
    "cancellation_requests": "3_per_hour",
    "reschedule_requests": "2_per_hour"
  }
}
```

---

_Última actualización: Diciembre 2024_
