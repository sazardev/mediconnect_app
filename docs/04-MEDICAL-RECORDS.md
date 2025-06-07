# 🏥 HISTORIALES MÉDICOS - MEDICAL RECORDS

## 📋 **RESUMEN EJECUTIVO**

El módulo de historiales médicos gestiona los expedientes digitales completos de los pacientes, incluyendo diagnósticos, tratamientos, estudios de laboratorio, recetas médicas, imágenes diagnósticas, y el seguimiento continuo de la salud del paciente. Es un módulo crítico que requiere estrictos controles de privacidad y acceso según HIPAA y regulaciones médicas.

---

## 🎯 **ENDPOINTS PRINCIPALES**

### **Base URL**: `/api/medical-records/`

| Método   | Endpoint                                             | Descripción                               | Permisos        |
| -------- | ---------------------------------------------------- | ----------------------------------------- | --------------- |
| `GET`    | `/api/medical-records/`                              | Listar expedientes (filtrados por acceso) | Doctor, Admin   |
| `POST`   | `/api/medical-records/`                              | Crear nueva entrada médica                | Doctor, Admin   |
| `GET`    | `/api/medical-records/{id}/`                         | Obtener expediente específico             | Authorized      |
| `PUT`    | `/api/medical-records/{id}/`                         | Actualizar expediente completo            | Doctor, Admin   |
| `PATCH`  | `/api/medical-records/{id}/`                         | Actualizar campos específicos             | Doctor, Admin   |
| `DELETE` | `/api/medical-records/{id}/`                         | Eliminar entrada (soft delete)            | Admin           |
| `GET`    | `/api/medical-records/patient/{patient_id}/`         | Historial completo de paciente            | Authorized      |
| `GET`    | `/api/medical-records/patient/{patient_id}/summary/` | Resumen ejecutivo del paciente            | Authorized      |
| `POST`   | `/api/medical-records/diagnoses/`                    | Agregar nuevo diagnóstico                 | Doctor, Admin   |
| `POST`   | `/api/medical-records/prescriptions/`                | Crear nueva receta                        | Doctor, Admin   |
| `POST`   | `/api/medical-records/lab-results/`                  | Subir resultados de laboratorio           | Doctor, Admin   |
| `POST`   | `/api/medical-records/images/`                       | Subir imágenes diagnósticas               | Doctor, Admin   |
| `GET`    | `/api/medical-records/vitals/{patient_id}/`          | Signos vitales históricos                 | Authorized      |
| `POST`   | `/api/medical-records/vitals/`                       | Registrar signos vitales                  | Doctor, Admin   |
| `GET`    | `/api/medical-records/medications/{patient_id}/`     | Historial de medicamentos                 | Authorized      |
| `GET`    | `/api/medical-records/allergies/{patient_id}/`       | Alergias documentadas                     | Authorized      |
| `POST`   | `/api/medical-records/share/`                        | Compartir expediente con otro doctor      | Doctor, Patient |
| `GET`    | `/api/medical-records/export/{patient_id}/`          | Exportar expediente (PDF)                 | Authorized      |
| `GET`    | `/api/medical-records/timeline/{patient_id}/`        | Línea de tiempo médica                    | Authorized      |
| `GET`    | `/api/medical-records/search/`                       | Búsqueda avanzada en expedientes          | Doctor, Admin   |

---

## 🏗️ **ESTRUCTURAS DE DATOS JSON**

### **1. Expediente Médico Base (MedicalRecord)**

```json
{
  "id": 2001,
  "record_number": "MR-2024-002001",
  "patient": {
    "id": 789,
    "full_name": "Ana López García",
    "date_of_birth": "1992-03-15",
    "age": 32,
    "gender": "F",
    "medical_record_number": "PAT-2024-005678",
    "blood_type": "O+",
    "emergency_contact": {
      "name": "Juan López",
      "phone": "+52-555-111-2222",
      "relationship": "Padre"
    }
  },
  "primary_doctor": {
    "id": 123,
    "full_name": "Dra. María Martínez García",
    "license_number": "MED-2024-001234",
    "specialties": ["Cardiología", "Medicina Interna"]
  },
  "clinic": {
    "id": 1,
    "name": "Centro Médico ABC",
    "address": "Av. Reforma 123, Col. Centro, CDMX"
  },
  "visit_date": "2024-12-25T10:00:00Z",
  "appointment_id": 1001,
  "visit_type": "consultation",
  "chief_complaint": "Dolor de cabeza recurrente y fatiga",
  "history_present_illness": "Paciente refiere cefaleas frontales de 3 semanas de evolución, asociadas a fatiga matutina. Intensidad 6/10 en escala de dolor. Sin náuseas ni vómitos.",
  "physical_examination": {
    "general_appearance": "Paciente consciente, orientada, cooperadora",
    "vital_signs": {
      "blood_pressure": {
        "systolic": 145,
        "diastolic": 88,
        "unit": "mmHg",
        "position": "sentada"
      },
      "heart_rate": 72,
      "respiratory_rate": 16,
      "temperature": 36.5,
      "oxygen_saturation": 98,
      "weight": 70.2,
      "height": 175.5,
      "bmi": 22.9
    },
    "head_neck": "Normocéfala, sin adenopatías palpables",
    "cardiovascular": "Ruidos cardíacos rítmicos, sin soplos audibles",
    "respiratory": "Murmullo vesicular conservado bilateral",
    "abdomen": "Blando, depresible, sin masas palpables",
    "extremities": "Sin edema, pulsos periféricos presentes",
    "neurological": "Consciente, orientada, sin déficit neurológico focal"
  },
  "diagnoses": [
    {
      "id": 301,
      "primary": true,
      "diagnosis": "Hipertensión arterial esencial",
      "icd_10_code": "I10",
      "description": "Hipertensión arterial primaria sin causa identificable",
      "severity": "moderate",
      "status": "active",
      "diagnosed_date": "2024-12-25T10:00:00Z",
      "notes": "Primera vez diagnosticada. Requiere seguimiento estrecho."
    },
    {
      "id": 302,
      "primary": false,
      "diagnosis": "Cefalea tensional",
      "icd_10_code": "G44.2",
      "description": "Cefalea por tensión asociada a estrés",
      "severity": "mild",
      "status": "active",
      "diagnosed_date": "2024-12-25T10:00:00Z",
      "notes": "Relacionada con hipertensión arterial."
    }
  ],
  "medications_prescribed": [
    {
      "id": 401,
      "medication": "Losartán",
      "generic_name": "Losartán potásico",
      "dosage": "50mg",
      "form": "Tableta",
      "frequency": "Una vez al día",
      "route": "oral",
      "duration": "30 días",
      "quantity": 30,
      "refills": 2,
      "instructions": "Tomar en ayunas por las mañanas",
      "start_date": "2024-12-25",
      "end_date": "2025-01-24",
      "status": "active",
      "interactions": [],
      "side_effects_to_monitor": ["Mareos", "Tos seca", "Hipotensión"]
    }
  ],
  "laboratory_results": [
    {
      "id": 501,
      "test_name": "Química sanguínea completa",
      "ordered_date": "2024-12-20T10:00:00Z",
      "collection_date": "2024-12-21T08:00:00Z",
      "result_date": "2024-12-22T14:00:00Z",
      "status": "completed",
      "results": {
        "glucose": {
          "value": 95,
          "unit": "mg/dL",
          "reference_range": "70-100",
          "status": "normal"
        },
        "creatinine": {
          "value": 0.9,
          "unit": "mg/dL",
          "reference_range": "0.6-1.2",
          "status": "normal"
        },
        "cholesterol_total": {
          "value": 220,
          "unit": "mg/dL",
          "reference_range": "<200",
          "status": "high"
        },
        "hdl_cholesterol": {
          "value": 45,
          "unit": "mg/dL",
          "reference_range": ">40",
          "status": "normal"
        },
        "ldl_cholesterol": {
          "value": 150,
          "unit": "mg/dL",
          "reference_range": "<100",
          "status": "high"
        }
      },
      "interpretation": "Dislipidemia leve. Requiere modificaciones dietéticas.",
      "lab_facility": "Laboratorio Clínico ABC",
      "ordered_by": 123,
      "report_url": "https://storage.googleapis.com/lab-results/lab_501.pdf"
    }
  ],
  "imaging_studies": [
    {
      "id": 601,
      "study_type": "Radiografía de tórax",
      "body_part": "Tórax PA y lateral",
      "modality": "X-Ray",
      "ordered_date": "2024-12-25T10:00:00Z",
      "performed_date": "2024-12-26T09:00:00Z",
      "status": "completed",
      "findings": "Campos pulmonares libres. Silueta cardíaca normal. Sin alteraciones óseas.",
      "impression": "Estudio normal",
      "radiologist": "Dr. Carlos Imaging",
      "facility": "Centro de Radiología Médica",
      "images": [
        {
          "url": "https://storage.googleapis.com/imaging/xray_601_pa.jpg",
          "view": "PA",
          "format": "JPEG"
        },
        {
          "url": "https://storage.googleapis.com/imaging/xray_601_lateral.jpg",
          "view": "Lateral",
          "format": "JPEG"
        }
      ],
      "report_url": "https://storage.googleapis.com/imaging/report_601.pdf"
    }
  ],
  "procedures": [
    {
      "id": 701,
      "procedure": "Electrocardiograma de 12 derivaciones",
      "cpt_code": "93000",
      "performed_date": "2024-12-25T10:15:00Z",
      "performed_by": 123,
      "status": "completed",
      "results": "Ritmo sinusal normal. Frecuencia cardíaca 72 lpm. Sin alteraciones del ST-T.",
      "complications": "Ninguna",
      "notes": "Procedimiento sin complicaciones. Paciente toleró bien."
    }
  ],
  "allergies": [
    {
      "id": 801,
      "allergen": "Penicilina",
      "allergen_type": "medication",
      "severity": "severe",
      "reaction": "Anafilaxia",
      "symptoms": [
        "Dificultad respiratoria",
        "Erupción cutánea",
        "Hipotensión"
      ],
      "onset": "inmediata",
      "documented_date": "2020-05-15T00:00:00Z",
      "verified": true,
      "status": "active"
    }
  ],
  "social_history": {
    "smoking": {
      "status": "never",
      "packs_per_day": 0,
      "years_smoking": 0,
      "quit_date": null
    },
    "alcohol": {
      "status": "social",
      "drinks_per_week": 2,
      "type": "wine"
    },
    "drugs": {
      "status": "never"
    },
    "occupation": "Contadora",
    "exercise": "Sedentaria",
    "diet": "Balanceada"
  },
  "family_history": [
    {
      "relative": "Padre",
      "condition": "Hipertensión arterial",
      "age_of_onset": 45,
      "status": "alive"
    },
    {
      "relative": "Madre",
      "condition": "Diabetes tipo 2",
      "age_of_onset": 52,
      "status": "alive"
    }
  ],
  "review_of_systems": {
    "constitutional": "Fatiga ocasional",
    "cardiovascular": "Palpitaciones ocasionales",
    "respiratory": "Sin disnea ni tos",
    "gastrointestinal": "Sin náuseas ni dolor abdominal",
    "genitourinary": "Sin disuria ni urgencia",
    "musculoskeletal": "Sin dolor articular",
    "neurological": "Cefaleas recurrentes",
    "psychiatric": "Estado de ánimo estable",
    "endocrine": "Sin poliuria ni polidipsia",
    "hematologic": "Sin sangrados anormales",
    "skin": "Sin erupciones ni lesiones"
  },
  "treatment_plan": {
    "medications": [
      {
        "action": "start",
        "medication": "Losartán 50mg",
        "instructions": "Una vez al día en ayunas"
      }
    ],
    "lifestyle_modifications": [
      "Dieta baja en sodio (<2g/día)",
      "Ejercicio aeróbico 30 min, 5 días/semana",
      "Reducir estrés laboral",
      "Monitoreo de presión arterial en casa"
    ],
    "follow_up": [
      {
        "type": "office_visit",
        "interval": "4 semanas",
        "reason": "Evaluación de respuesta al tratamiento"
      },
      {
        "type": "lab_work",
        "interval": "6 semanas",
        "tests": ["Perfil lipídico", "Función renal"]
      }
    ],
    "patient_education": [
      "Información sobre hipertensión arterial",
      "Técnica correcta para toma de presión arterial",
      "Signos de alarma para buscar atención médica"
    ]
  },
  "doctor_notes": "Paciente presenta hipertensión arterial de novo. Buen candidato para manejo inicial con IECA. Enfatizar importancia de cambios en estilo de vida.",
  "privacy_settings": {
    "shared_with": [
      {
        "doctor_id": 124,
        "doctor_name": "Dr. Juan Cardiólogo",
        "shared_date": "2024-12-25T15:00:00Z",
        "reason": "Interconsulta cardiológica",
        "expires": "2025-06-25T15:00:00Z"
      }
    ],
    "patient_access": true,
    "research_consent": false
  },
  "billing_codes": [
    {
      "code": "99214",
      "description": "Office visit, established patient, moderate complexity",
      "amount": 1500.0
    }
  ],
  "quality_measures": {
    "hypertension_control": {
      "target_bp": "140/90",
      "current_bp": "145/88",
      "controlled": false
    },
    "medication_adherence": {
      "prescribed": true,
      "patient_understands": true
    }
  },
  "created_at": "2024-12-25T10:00:00Z",
  "updated_at": "2024-12-25T11:30:00Z",
  "created_by": 123,
  "last_modified_by": 123,
  "record_status": "active",
  "version": 1
}
```

### **2. Resumen de Expediente (Patient Summary)**

```json
{
  "patient_id": 789,
  "patient_name": "Ana López García",
  "summary_generated": "2024-12-26T10:00:00Z",
  "summary_period": {
    "from": "2020-01-01T00:00:00Z",
    "to": "2024-12-26T10:00:00Z"
  },
  "demographics": {
    "age": 32,
    "gender": "F",
    "blood_type": "O+",
    "primary_language": "Español"
  },
  "current_diagnoses": [
    {
      "diagnosis": "Hipertensión arterial esencial",
      "icd_10": "I10",
      "since": "2024-12-25",
      "status": "active",
      "managing_doctor": "Dra. María Martínez"
    }
  ],
  "chronic_conditions": [
    {
      "condition": "Hipertensión arterial",
      "duration_months": 1,
      "control_status": "newly_diagnosed",
      "last_assessment": "2024-12-25"
    }
  ],
  "current_medications": [
    {
      "medication": "Losartán 50mg",
      "started": "2024-12-25",
      "prescribing_doctor": "Dra. María Martínez",
      "indication": "Hipertensión arterial"
    }
  ],
  "allergies": {
    "drug_allergies": [
      {
        "allergen": "Penicilina",
        "severity": "severe",
        "reaction": "Anafilaxia"
      }
    ],
    "environmental_allergies": [],
    "food_allergies": []
  },
  "vital_signs_trends": {
    "blood_pressure": {
      "last_reading": {
        "systolic": 145,
        "diastolic": 88,
        "date": "2024-12-25"
      },
      "trend": "elevated",
      "readings_count": 1
    },
    "weight": {
      "current": 70.2,
      "trend": "stable",
      "last_recorded": "2024-12-25"
    }
  },
  "recent_visits": [
    {
      "date": "2024-12-25",
      "doctor": "Dra. María Martínez",
      "reason": "Dolor de cabeza y fatiga",
      "diagnosis": "Hipertensión arterial",
      "visit_type": "consultation"
    }
  ],
  "upcoming_appointments": [
    {
      "date": "2025-01-25T10:00:00Z",
      "doctor": "Dra. María Martínez",
      "reason": "Control de hipertensión"
    }
  ],
  "pending_orders": [
    {
      "type": "lab_work",
      "tests": ["Perfil lipídico", "Función renal"],
      "ordered_date": "2024-12-25",
      "due_date": "2025-02-10"
    }
  ],
  "health_maintenance": {
    "preventive_care": [
      {
        "service": "Mamografía",
        "last_done": null,
        "due_date": "2025-03-15",
        "status": "overdue"
      },
      {
        "service": "Papanicolaou",
        "last_done": "2023-08-15",
        "due_date": "2024-08-15",
        "status": "overdue"
      }
    ],
    "immunizations": [
      {
        "vaccine": "Influenza",
        "last_given": "2023-10-15",
        "next_due": "2024-10-15",
        "status": "due"
      }
    ]
  },
  "risk_factors": [
    {
      "factor": "Sedentarismo",
      "level": "moderate",
      "recommendation": "Ejercicio aeróbico regular"
    },
    {
      "factor": "Historia familiar de hipertensión",
      "level": "high",
      "recommendation": "Monitoreo regular de presión arterial"
    }
  ],
  "quality_scores": {
    "medication_adherence": null, // Muy reciente para evaluar
    "appointment_compliance": 100,
    "preventive_care_completion": 25
  }
}
```

### **3. Línea de Tiempo Médica (Medical Timeline)**

```json
{
  "patient_id": 789,
  "timeline_period": {
    "from": "2020-01-01T00:00:00Z",
    "to": "2024-12-26T10:00:00Z"
  },
  "events": [
    {
      "date": "2024-12-25T10:00:00Z",
      "type": "visit",
      "category": "consultation",
      "title": "Consulta inicial - Hipertensión arterial",
      "doctor": "Dra. María Martínez García",
      "location": "Centro Médico ABC",
      "details": {
        "chief_complaint": "Dolor de cabeza y fatiga",
        "diagnoses": ["Hipertensión arterial esencial", "Cefalea tensional"],
        "procedures": ["Electrocardiograma"],
        "medications_started": ["Losartán 50mg"]
      },
      "importance": "high"
    },
    {
      "date": "2024-12-22T14:00:00Z",
      "type": "lab_result",
      "category": "diagnostic",
      "title": "Resultados de laboratorio - Química sanguínea",
      "ordered_by": "Dra. María Martínez García",
      "details": {
        "abnormal_results": [
          "Colesterol total elevado (220 mg/dL)",
          "LDL elevado (150 mg/dL)"
        ],
        "normal_results": ["Glucosa", "Creatinina", "HDL"]
      },
      "importance": "medium"
    },
    {
      "date": "2024-12-20T10:00:00Z",
      "type": "order",
      "category": "diagnostic",
      "title": "Orden de laboratorio",
      "doctor": "Dra. María Martínez García",
      "details": {
        "tests_ordered": ["Química sanguínea completa"],
        "reason": "Evaluación inicial para cefalea y fatiga"
      },
      "importance": "low"
    },
    {
      "date": "2020-05-15T00:00:00Z",
      "type": "allergy",
      "category": "safety",
      "title": "Alergia a Penicilina documentada",
      "doctor": "Dr. Médico Anterior",
      "details": {
        "allergen": "Penicilina",
        "reaction": "Anafilaxia",
        "severity": "severe"
      },
      "importance": "critical"
    }
  ],
  "filters": {
    "available_types": [
      "visit",
      "lab_result",
      "imaging",
      "medication",
      "allergy",
      "procedure",
      "hospitalization"
    ],
    "available_categories": [
      "consultation",
      "diagnostic",
      "treatment",
      "safety",
      "emergency"
    ],
    "importance_levels": ["critical", "high", "medium", "low"]
  }
}
```

---

## 🔐 **PERMISOS Y AUTORIZACIONES**

### **Matriz de Permisos por Endpoint**

| Endpoint                                 | Admin | Doctor | Patient | Descripción                               |
| ---------------------------------------- | ----- | ------ | ------- | ----------------------------------------- |
| `GET /api/medical-records/`              | ✅    | 🟡     | ❌      | Admin: todos; Doctor: pacientes asignados |
| `POST /api/medical-records/`             | ✅    | ✅     | ❌      | Solo médicos pueden crear registros       |
| `GET /api/medical-records/{id}/`         | ✅    | 🟡     | 🟡      | Según relación médico-paciente            |
| `PUT /api/medical-records/{id}/`         | ✅    | 🟡     | ❌      | Solo médico que creó el registro          |
| `DELETE /api/medical-records/{id}/`      | ✅    | ❌     | ❌      | Solo admin puede eliminar                 |
| `GET /api/medical-records/patient/{id}/` | ✅    | 🟡     | 🟡      | Paciente: propio; Doctor: asignados       |
| `POST /api/medical-records/share/`       | ✅    | ✅     | ✅      | Con consentimiento del paciente           |
| `GET /api/medical-records/export/{id}/`  | ✅    | 🟡     | ✅      | Según relación autorizada                 |

### **Reglas de Negocio Críticas**

1. **Relación Médico-Paciente**: Los doctores solo pueden acceder a expedientes de pacientes que han atendido
2. **Consentimiento del Paciente**: Compartir expedientes requiere consentimiento explícito
3. **Tiempo de Acceso**: El acceso a expedientes expira si no hay citas recientes (6 meses)
4. **Auditoría Completa**: Todos los accesos a expedientes son registrados
5. **Datos Sensibles**: Información psiquiátrica y reproductiva requiere permisos especiales
6. **Firma Digital**: Diagnósticos y recetas requieren firma digital del médico
7. **Versionado**: Los expedientes mantienen historial de cambios

---

## 🔍 **PARÁMETROS DE CONSULTA (QUERY PARAMETERS)**

### **GET /api/medical-records/patient/{patient_id}/**

```javascript
// Filtros para historial del paciente
{
  "date_from": "2024-01-01", // Formato YYYY-MM-DD
  "date_to": "2024-12-31",
  "visit_type": "consultation|follow_up|emergency|procedure",
  "doctor": "123", // ID del doctor específico
  "diagnosis": "I10", // Código ICD-10
  "has_prescriptions": "true|false",
  "has_lab_results": "true|false",
  "has_imaging": "true|false",
  "record_status": "active|inactive|amended",
  "include_shared": "true|false", // Incluir registros compartidos
  "ordering": "visit_date|-visit_date|created_at",
  "page": 1,
  "page_size": 20
}
```

### **GET /api/medical-records/search/**

```javascript
// Búsqueda avanzada (Solo Doctor/Admin)
{
  "patient_name": "Ana López",
  "medical_record_number": "PAT-2024-005678",
  "diagnosis": "hipertensión", // Búsqueda en texto
  "icd_code": "I10",
  "medication": "losartan",
  "date_range": "2024-01-01,2024-12-31",
  "doctor": "123",
  "age_range": "30-40",
  "gender": "F|M",
  "has_allergies": "true|false",
  "chronic_conditions": "true|false",
  "last_visit_days": "30", // Últimos N días
  "ordering": "patient_name|last_visit|-last_visit",
  "page": 1,
  "page_size": 15
}
```

### **GET /api/medical-records/timeline/{patient_id}/**

```javascript
// Parámetros para línea de tiempo
{
  "start_date": "2024-01-01",
  "end_date": "2024-12-31",
  "event_types": "visit,lab_result,imaging,medication",
  "importance": "critical,high", // Filtrar por importancia
  "doctor": "123", // Eventos de doctor específico
  "include_details": "true|false",
  "max_events": "50"
}
```

---

## 📝 **CASOS DE USO DETALLADOS**

### **1. Crear Nuevo Registro Médico (Doctor)**

**Flujo durante consulta:**

```javascript
POST /api/medical-records/
{
  "patient": 789,
  "appointment_id": 1001,
  "visit_type": "consultation",
  "chief_complaint": "Dolor de cabeza recurrente y fatiga",
  "history_present_illness": "Paciente refiere cefaleas frontales de 3 semanas...",
  "physical_examination": {
    "vital_signs": {
      "blood_pressure": {"systolic": 145, "diastolic": 88},
      "heart_rate": 72,
      "temperature": 36.5,
      "weight": 70.2,
      "height": 175.5
    },
    "general_appearance": "Paciente consciente, orientada, cooperadora",
    "cardiovascular": "Ruidos cardíacos rítmicos, sin soplos"
  },
  "diagnoses": [
    {
      "diagnosis": "Hipertensión arterial esencial",
      "icd_10_code": "I10",
      "primary": true,
      "severity": "moderate"
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
  "treatment_plan": {
    "lifestyle_modifications": [
      "Dieta baja en sodio",
      "Ejercicio aeróbico regular"
    ],
    "follow_up": [
      {
        "type": "office_visit",
        "interval": "4 semanas"
      }
    ]
  }
}

// Respuesta
{
  "id": 2001,
  "record_number": "MR-2024-002001",
  "status": "created",
  "requires_signature": true,
  "signature_deadline": "2024-12-25T18:00:00Z"
}
```

### **2. Compartir Expediente con Otro Doctor**

**Proceso de interconsulta:**

```javascript
POST /api/medical-records/share/
{
  "patient_id": 789,
  "recipient_doctor_id": 124,
  "reason": "Interconsulta cardiológica",
  "shared_records": [2001, 2002, 2003], // IDs de registros específicos
  "include_full_history": false,
  "access_duration_days": 180,
  "patient_consent": {
    "obtained": true,
    "consent_date": "2024-12-25T10:30:00Z",
    "consent_method": "verbal_in_person"
  },
  "sharing_permissions": {
    "view_only": false,
    "can_add_notes": true,
    "can_order_tests": false
  }
}

// Respuesta
{
  "share_id": "SHARE-2024-001",
  "status": "active",
  "expires_at": "2025-06-25T15:00:00Z",
  "recipient_notified": true,
  "audit_trail_created": true
}
```

### **3. Paciente Solicita Expediente (Export)**

**Exportación para segunda opinión:**

```javascript
GET /api/medical-records/export/789/?format=pdf&include_images=true&date_range=2024-01-01,2024-12-31

// Respuesta
{
  "export_id": "EXP-2024-001",
  "status": "processing",
  "estimated_completion": "2024-12-26T10:05:00Z",
  "download_url": null, // Se proporcionará cuando esté listo
  "includes": {
    "medical_records": 15,
    "lab_results": 5,
    "imaging_studies": 3,
    "prescriptions": 8
  },
  "watermarked": true,
  "expiry_date": "2025-01-02T10:00:00Z" // El link expira en 7 días
}

// Notificación WebSocket cuando esté listo
{
  "event": "export_ready",
  "data": {
    "export_id": "EXP-2024-001",
    "download_url": "https://secure-downloads.mediconnect.com/exports/EXP-2024-001.pdf",
    "file_size": "2.5MB"
  }
}
```

---

## ⚠️ **VALIDACIONES Y ERRORES**

### **Errores Específicos del Módulo**

```javascript
// Error 403 - Sin relación médico-paciente
{
  "error": "no_patient_relationship",
  "message": "No tienes autorización para acceder al expediente de este paciente",
  "details": {
    "patient_id": 789,
    "last_interaction": null,
    "required_permission": "active_patient_relationship"
  }
}

// Error 400 - Expediente ya firmado
{
  "error": "record_already_signed",
  "message": "No se puede modificar un expediente que ya ha sido firmado digitalmente",
  "details": {
    "record_id": 2001,
    "signed_by": "Dr. María Martínez",
    "signed_date": "2024-12-25T12:00:00Z"
  }
}

// Error 400 - Consentimiento requerido
{
  "error": "patient_consent_required",
  "message": "Se requiere consentimiento del paciente para compartir información médica",
  "details": {
    "patient_id": 789,
    "recipient_doctor": 124,
    "consent_type": "medical_record_sharing"
  }
}
```

### **Validaciones Médicas**

```javascript
// Validaciones de diagnósticos
{
  "icd_10_code": {
    "required": true,
    "must_be_valid": true,
    "must_match_diagnosis": true
  },
  "medications": {
    "dosage_validation": true,
    "interaction_check": true,
    "allergy_cross_check": true,
    "duplicate_prevention": true
  },
  "vital_signs": {
    "blood_pressure": {
      "systolic_range": [70, 250],
      "diastolic_range": [40, 150]
    },
    "heart_rate_range": [30, 200],
    "temperature_range": [32.0, 42.0]
  }
}
```

---

## 🔔 **TRIGGERS DE NOTIFICACIONES**

### **Eventos Críticos**

```javascript
// Nuevo diagnóstico crítico
{
  "event": "critical_diagnosis_added",
  "data": {
    "patient_id": 789,
    "diagnosis": "Infarto agudo de miocardio",
    "icd_code": "I21.9",
    "doctor_id": 123,
    "severity": "critical"
  },
  "recipients": ["patient_789", "emergency_contacts", "primary_care_doctor"]
}

// Alergia nueva documentada
{
  "event": "new_allergy_documented",
  "data": {
    "patient_id": 789,
    "allergen": "Aspirina",
    "severity": "severe",
    "reaction": "Angioedema"
  },
  "recipients": ["patient_789", "all_treating_doctors"]
}

// Expediente compartido
{
  "event": "medical_record_shared",
  "data": {
    "patient_id": 789,
    "shared_with_doctor": 124,
    "sharing_reason": "Interconsulta cardiológica",
    "expires_at": "2025-06-25T15:00:00Z"
  },
  "recipients": ["doctor_124", "patient_789"]
}
```

---

## 📊 **MÉTRICAS Y ANALYTICS**

### **Dashboard Médico**

```javascript
// GET /api/medical-records/statistics/doctor/
{
  "doctor_id": 123,
  "period": "last_30_days",
  "records_created": 45,
  "patients_seen": 38,
  "diagnoses_distribution": [
    {"diagnosis": "Hipertensión arterial", "count": 12, "percentage": 26.7},
    {"diagnosis": "Diabetes tipo 2", "count": 8, "percentage": 17.8},
    {"diagnosis": "Cefalea tensional", "count": 6, "percentage": 13.3}
  ],
  "medications_prescribed": [
    {"medication": "Losartán", "count": 15},
    {"medication": "Metformina", "count": 12},
    {"medication": "Atorvastatina", "count": 10}
  ],
  "procedures_performed": 23,
  "lab_orders": 67,
  "imaging_orders": 12,
  "referrals_made": 8,
  "follow_up_compliance": 78.5,
  "documentation_score": 94.2,
  "avg_time_to_signature": "2.5 hours"
}
```

---

## 🚀 **IMPLEMENTACIÓN RECOMENDADA**

### **Orden de Implementación Frontend**

1. **Vista de Expediente Básico** (Información esencial del paciente)
2. **Historial de Visitas** (Lista cronológica)
3. **Creación de Registros** (Formulario médico completo)
4. **Visualización de Diagnósticos** (Con códigos ICD-10)
5. **Gestión de Medicamentos** (Prescripciones activas/históricas)
6. **Resultados de Laboratorio** (Con gráficas de tendencias)
7. **Línea de Tiempo Médica** (Vista cronológica visual)
8. **Sistema de Compartir** (Interconsultas)
9. **Exportación de Expedientes** (PDF completo)
10. **Dashboard de Métricas** (Para doctores/admin)

### **Consideraciones de UX/UI**

- **Información Crítica Prominente**: Alergias y diagnósticos importantes siempre visibles
- **Código de Colores**: Sistema visual para severidad y estado
- **Búsqueda Inteligente**: Autocomplete para diagnósticos y medicamentos
- **Firmas Digitales**: Proceso claro de firma de documentos
- **Responsive Medical**: Optimizado para tablets (uso común en consultorios)
- **Modo de Emergencia**: Acceso rápido a información crítica
- **Privacidad Visual**: Indicadores claros de información sensible

### **Seguridad y Cumplimiento**

```javascript
// Medidas de seguridad implementadas
{
  "data_encryption": {
    "at_rest": "AES-256",
    "in_transit": "TLS 1.3",
    "field_level": "sensitive_fields_only"
  },
  "access_logging": {
    "who_accessed": true,
    "when_accessed": true,
    "what_accessed": true,
    "from_where": true,
    "retention_period": "7_years"
  },
  "patient_consent": {
    "granular_permissions": true,
    "revocable": true,
    "audit_trail": true
  },
  "hipaa_compliance": {
    "minimum_necessary": true,
    "purpose_limitation": true,
    "data_minimization": true
  }
}
```

---

## 🔗 **RELACIONES CON OTROS MÓDULOS**

- **Appointments**: Cada cita puede generar uno o más registros médicos
- **Users**: Doctores crean registros, pacientes los visualizan
- **Chat**: Comunicación sobre hallazgos médicos
- **Notifications**: Alertas sobre resultados críticos
- **Billing**: Códigos de procedimientos para facturación
- **Analytics**: Métricas de calidad y outcomes clínicos

---

_Última actualización: Diciembre 2024_
