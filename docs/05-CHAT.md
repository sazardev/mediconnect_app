# 💬 CHAT Y MENSAJERÍA - REAL-TIME COMMUNICATION

## 📋 **RESUMEN EJECUTIVO**

El módulo de chat y mensajería permite comunicación segura en tiempo real entre doctores y pacientes, incluyendo mensajes de texto, intercambio de archivos médicos, videollamadas, y salas de chat grupales para equipos médicos. Utiliza WebSockets para comunicación instantánea y mantiene cifrado end-to-end para proteger la información médica sensible.

---

## 🎯 **ENDPOINTS PRINCIPALES**

### **Base URL**: `/api/chat/`

| Método   | Endpoint                                 | Descripción                              | Permisos      |
| -------- | ---------------------------------------- | ---------------------------------------- | ------------- |
| `GET`    | `/api/chat/conversations/`               | Listar conversaciones del usuario        | Authenticated |
| `POST`   | `/api/chat/conversations/`               | Crear nueva conversación                 | Authenticated |
| `GET`    | `/api/chat/conversations/{id}/`          | Obtener detalles de conversación         | Participant   |
| `PUT`    | `/api/chat/conversations/{id}/`          | Actualizar configuración de conversación | Participant   |
| `DELETE` | `/api/chat/conversations/{id}/`          | Eliminar/abandonar conversación          | Participant   |
| `GET`    | `/api/chat/conversations/{id}/messages/` | Obtener mensajes de conversación         | Participant   |
| `POST`   | `/api/chat/conversations/{id}/messages/` | Enviar nuevo mensaje                     | Participant   |
| `GET`    | `/api/chat/messages/{id}/`               | Obtener mensaje específico               | Participant   |
| `PUT`    | `/api/chat/messages/{id}/`               | Editar mensaje (solo propio)             | Owner         |
| `DELETE` | `/api/chat/messages/{id}/`               | Eliminar mensaje (soft delete)           | Owner         |
| `POST`   | `/api/chat/messages/{id}/read/`          | Marcar mensaje como leído                | Participant   |
| `POST`   | `/api/chat/upload-file/`                 | Subir archivo médico                     | Authenticated |
| `GET`    | `/api/chat/search/`                      | Buscar en conversaciones y mensajes      | Authenticated |
| `POST`   | `/api/chat/video-call/start/`            | Iniciar videollamada                     | Participant   |
| `POST`   | `/api/chat/video-call/join/`             | Unirse a videollamada                    | Participant   |
| `POST`   | `/api/chat/video-call/end/`              | Terminar videollamada                    | Participant   |
| `GET`    | `/api/chat/unread-count/`                | Obtener conteo de mensajes no leídos     | Authenticated |
| `POST`   | `/api/chat/block-user/`                  | Bloquear usuario                         | Authenticated |
| `POST`   | `/api/chat/report-message/`              | Reportar mensaje inapropiado             | Authenticated |

---

## 🏗️ **ESTRUCTURAS DE DATOS JSON**

### **1. Conversación (Conversation)**

```json
{
  "id": 1001,
  "conversation_id": "CONV-2024-001001",
  "type": "direct", // direct, group, emergency, consultation
  "title": "Consulta - Dra. María Martínez",
  "description": "Seguimiento post-consulta hipertensión arterial",
  "participants": [
    {
      "user_id": 789,
      "user_type": "patient",
      "full_name": "Ana López García",
      "avatar": "https://storage.googleapis.com/avatars/ana_lopez.jpg",
      "status": "active",
      "role": "participant",
      "joined_at": "2024-12-25T10:30:00Z",
      "last_seen": "2024-12-26T09:15:00Z",
      "is_online": true,
      "can_leave": true
    },
    {
      "user_id": 123,
      "user_type": "doctor",
      "full_name": "Dra. María Martínez García",
      "avatar": "https://storage.googleapis.com/avatars/doctor_martinez.jpg",
      "status": "active",
      "role": "moderator",
      "joined_at": "2024-12-25T10:30:00Z",
      "last_seen": "2024-12-26T08:45:00Z",
      "is_online": false,
      "can_leave": false
    }
  ],
  "settings": {
    "is_encrypted": true,
    "auto_delete_messages": false,
    "auto_delete_days": null,
    "file_sharing_enabled": true,
    "video_calls_enabled": true,
    "notifications_enabled": true,
    "typing_indicators": true,
    "read_receipts": true,
    "message_editing": true,
    "message_deletion": true
  },
  "metadata": {
    "related_appointment_id": 1001,
    "related_patient_id": 789,
    "medical_record_access": true,
    "consultation_type": "follow_up",
    "priority": "normal",
    "tags": ["hipertension", "seguimiento", "medicacion"]
  },
  "last_message": {
    "id": 5001,
    "sender": {
      "id": 123,
      "name": "Dra. María Martínez",
      "user_type": "doctor"
    },
    "content": "¿Cómo se ha sentido con la nueva medicación?",
    "timestamp": "2024-12-26T08:45:00Z",
    "message_type": "text",
    "is_read": false
  },
  "unread_count": 2,
  "total_messages": 15,
  "created_at": "2024-12-25T10:30:00Z",
  "updated_at": "2024-12-26T08:45:00Z",
  "created_by": 123,
  "is_active": true,
  "expires_at": null // Conversaciones médicas no expiran automáticamente
}
```

### **2. Mensaje (Message)**

```json
{
  "id": 5001,
  "message_id": "MSG-2024-005001",
  "conversation_id": 1001,
  "sender": {
    "id": 123,
    "full_name": "Dra. María Martínez García",
    "user_type": "doctor",
    "avatar": "https://storage.googleapis.com/avatars/doctor_martinez.jpg"
  },
  "message_type": "text", // text, file, image, audio, video, system, appointment, prescription
  "content": "Buenos días Ana. He revisado sus últimos estudios de laboratorio y todo parece estar mejorando. ¿Cómo se ha sentido con la nueva medicación para la presión arterial?",
  "formatted_content": {
    "html": "Buenos días Ana. He revisado sus últimos <strong>estudios de laboratorio</strong> y todo parece estar mejorando. ¿Cómo se ha sentido con la nueva medicación para la presión arterial?",
    "mentions": [],
    "hashtags": [],
    "medical_terms": [
      "estudios de laboratorio",
      "presión arterial",
      "medicación"
    ]
  },
  "attachments": [
    {
      "id": 101,
      "type": "lab_result",
      "filename": "laboratorio_20241220.pdf",
      "original_filename": "Química Sanguínea - Ana López.pdf",
      "size": 2048576, // bytes
      "mime_type": "application/pdf",
      "url": "https://secure-storage.mediconnect.com/chat-files/lab_101.pdf",
      "thumbnail_url": "https://secure-storage.mediconnect.com/thumbnails/lab_101_thumb.jpg",
      "upload_date": "2024-12-26T08:40:00Z",
      "uploaded_by": 123,
      "is_medical_document": true,
      "requires_signature": false,
      "virus_scan_status": "clean"
    }
  ],
  "reply_to": {
    "message_id": 5000,
    "sender_name": "Ana López",
    "content_preview": "Doctora, ¿ya llegaron mis resultados?",
    "timestamp": "2024-12-26T08:30:00Z"
  },
  "reactions": [
    {
      "emoji": "👍",
      "count": 1,
      "users": [
        {
          "id": 789,
          "name": "Ana López",
          "reacted_at": "2024-12-26T08:46:00Z"
        }
      ]
    }
  ],
  "read_by": [
    {
      "user_id": 789,
      "read_at": "2024-12-26T09:15:00Z",
      "delivery_status": "delivered"
    }
  ],
  "delivery_status": "delivered", // sent, delivered, read, failed
  "priority": "normal", // low, normal, high, urgent
  "is_edited": false,
  "edit_history": [],
  "is_deleted": false,
  "deleted_at": null,
  "scheduled_for": null, // Para mensajes programados
  "expires_at": null,
  "metadata": {
    "client_message_id": "client_msg_12345",
    "source": "web_app",
    "location": null,
    "forwarded_from": null,
    "is_automated": false,
    "confidence_score": null // Para mensajes generados por IA
  },
  "encryption": {
    "is_encrypted": true,
    "encryption_key_id": "key_789_123_20241226",
    "signature": "SHA256:abc123def456..."
  },
  "timestamp": "2024-12-26T08:45:00Z",
  "created_at": "2024-12-26T08:45:00Z",
  "updated_at": "2024-12-26T08:45:00Z"
}
```

### **3. Llamada de Video (Video Call)**

```json
{
  "id": 2001,
  "call_id": "CALL-2024-002001",
  "conversation_id": 1001,
  "type": "video", // audio, video, screen_share
  "status": "active", // pending, ringing, active, ended, failed
  "initiator": {
    "id": 123,
    "name": "Dra. María Martínez",
    "user_type": "doctor"
  },
  "participants": [
    {
      "user_id": 123,
      "status": "connected",
      "joined_at": "2024-12-26T10:00:00Z",
      "camera_enabled": true,
      "microphone_enabled": true,
      "screen_sharing": false
    },
    {
      "user_id": 789,
      "status": "connected",
      "joined_at": "2024-12-26T10:01:00Z",
      "camera_enabled": true,
      "microphone_enabled": true,
      "screen_sharing": false
    }
  ],
  "room_settings": {
    "max_participants": 2,
    "recording_enabled": false, // Requiere consentimiento explícito
    "waiting_room": false,
    "password_protected": false,
    "end_to_end_encrypted": true
  },
  "quality_settings": {
    "video_resolution": "720p",
    "bitrate": "auto",
    "frame_rate": 30
  },
  "room_url": "https://video.mediconnect.com/room/CALL-2024-002001",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...", // JWT para acceso a sala
  "duration_seconds": 1800, // Duración actual en segundos
  "max_duration_minutes": 60, // Límite máximo
  "recording": {
    "is_recording": false,
    "consent_given": false,
    "recording_url": null,
    "started_at": null,
    "duration": null
  },
  "connection_quality": {
    "overall": "good", // excellent, good, fair, poor
    "latency_ms": 45,
    "packet_loss_percentage": 0.1,
    "bandwidth_mbps": 2.5
  },
  "started_at": "2024-12-26T10:00:00Z",
  "ended_at": null,
  "created_at": "2024-12-26T09:58:00Z"
}
```

### **4. Archivo Compartido (Shared File)**

```json
{
  "id": 3001,
  "file_id": "FILE-2024-003001",
  "conversation_id": 1001,
  "message_id": 5001,
  "uploader": {
    "id": 123,
    "name": "Dra. María Martínez",
    "user_type": "doctor"
  },
  "file_info": {
    "original_filename": "Receta_Ana_Lopez_20241226.pdf",
    "stored_filename": "encrypted_file_3001.enc",
    "size_bytes": 524288,
    "mime_type": "application/pdf",
    "file_type": "prescription", // lab_result, prescription, image, audio, video, document
    "checksum": "SHA256:def789abc123...",
    "virus_scan_result": "clean",
    "is_encrypted": true
  },
  "access_info": {
    "download_url": "https://secure-files.mediconnect.com/download/FILE-2024-003001",
    "preview_url": "https://secure-files.mediconnect.com/preview/FILE-2024-003001",
    "thumbnail_url": "https://secure-files.mediconnect.com/thumb/FILE-2024-003001",
    "access_token_required": true,
    "expires_at": "2025-12-26T10:00:00Z", // URL expira en 1 año
    "download_count": 2,
    "max_downloads": null
  },
  "medical_metadata": {
    "is_medical_document": true,
    "document_type": "prescription",
    "patient_id": 789,
    "related_appointment": 1001,
    "contains_phi": true, // Protected Health Information
    "requires_patient_consent": true,
    "retention_period_years": 7
  },
  "permissions": {
    "can_download": ["conversation_participants"],
    "can_forward": false,
    "can_print": true,
    "watermark_required": true
  },
  "upload_info": {
    "uploaded_at": "2024-12-26T08:40:00Z",
    "upload_ip": "192.168.1.100", // Para auditoría
    "upload_device": "web_browser",
    "upload_location": null
  },
  "status": "active", // active, expired, deleted, quarantined
  "created_at": "2024-12-26T08:40:00Z",
  "updated_at": "2024-12-26T08:40:00Z"
}
```

---

## 🔐 **PERMISOS Y AUTORIZACIONES**

### **Matriz de Permisos por Endpoint**

| Endpoint                                      | Admin | Doctor | Patient | Descripción                             |
| --------------------------------------------- | ----- | ------ | ------- | --------------------------------------- |
| `GET /api/chat/conversations/`                | ✅    | ✅     | ✅      | Solo conversaciones donde participa     |
| `POST /api/chat/conversations/`               | ✅    | ✅     | 🟡      | Paciente: solo con doctores asignados   |
| `GET /api/chat/conversations/{id}/`           | ✅    | 🟡     | 🟡      | Solo participantes                      |
| `POST /api/chat/conversations/{id}/messages/` | ✅    | 🟡     | 🟡      | Solo participantes activos              |
| `POST /api/chat/upload-file/`                 | ✅    | ✅     | 🟡      | Paciente: solo archivos médicos propios |
| `POST /api/chat/video-call/start/`            | ✅    | ✅     | ✅      | Con restricciones de horario            |
| `POST /api/chat/block-user/`                  | ✅    | ✅     | ✅      | No puede bloquear admin                 |
| `POST /api/chat/report-message/`              | ✅    | ✅     | ✅      | Todos pueden reportar                   |

### **Reglas de Negocio Críticas**

1. **Relación Médico-Paciente**: Pacientes solo pueden iniciar chat con doctores que los han atendido
2. **Horarios de Chat**: Comunicación limitada a horarios profesionales (8 AM - 10 PM)
3. **Cifrado Obligatorio**: Todos los mensajes médicos son cifrados end-to-end
4. **Retención de Datos**: Mensajes médicos se conservan 7 años por regulación
5. **Emergencias**: Canal especial para comunicaciones urgentes 24/7
6. **Archivos Médicos**: Solo documentos relacionados con tratamiento del paciente
7. **Grabación de Llamadas**: Requiere consentimiento explícito de ambas partes

---

## 🔌 **WEBSOCKETS - COMUNICACIÓN EN TIEMPO REAL**

### **Conexión WebSocket**

```javascript
// URL de conexión
ws://localhost:8000/ws/chat/{conversation_id}/?token={access_token}

// Estructura de mensajes WebSocket
{
  "type": "message_type",
  "data": {...},
  "timestamp": "2024-12-26T10:00:00Z",
  "conversation_id": 1001,
  "sender_id": 123
}
```

### **Tipos de Eventos WebSocket**

```javascript
// Mensaje nuevo
{
  "type": "new_message",
  "data": {
    "message_id": 5002,
    "sender": {
      "id": 789,
      "name": "Ana López",
      "user_type": "patient"
    },
    "content": "Buenos días doctora, me siento mucho mejor con la nueva medicación.",
    "timestamp": "2024-12-26T10:15:00Z",
    "attachments": []
  }
}

// Usuario escribiendo
{
  "type": "typing_indicator",
  "data": {
    "user_id": 789,
    "user_name": "Ana López",
    "is_typing": true
  }
}

// Mensaje leído
{
  "type": "message_read",
  "data": {
    "message_id": 5001,
    "read_by": 789,
    "read_at": "2024-12-26T10:16:00Z"
  }
}

// Usuario en línea/desconectado
{
  "type": "user_status",
  "data": {
    "user_id": 123,
    "status": "online", // online, offline, away, busy
    "last_seen": "2024-12-26T10:15:00Z"
  }
}

// Llamada de video iniciada
{
  "type": "video_call_started",
  "data": {
    "call_id": "CALL-2024-002001",
    "initiator": {
      "id": 123,
      "name": "Dra. María Martínez"
    },
    "room_url": "https://video.mediconnect.com/room/CALL-2024-002001",
    "access_token": "eyJhbGci..."
  }
}

// Archivo compartido
{
  "type": "file_shared",
  "data": {
    "file_id": "FILE-2024-003001",
    "filename": "Receta_Ana_Lopez.pdf",
    "size": 524288,
    "type": "prescription",
    "uploader": {
      "id": 123,
      "name": "Dra. María Martínez"
    },
    "download_url": "https://secure-files.mediconnect.com/download/FILE-2024-003001"
  }
}
```

---

## 🔍 **PARÁMETROS DE CONSULTA (QUERY PARAMETERS)**

### **GET /api/chat/conversations/**

```javascript
// Filtros para conversaciones
{
  "type": "direct|group|emergency|consultation",
  "with_user": "123", // Conversaciones con usuario específico
  "has_unread": "true|false",
  "updated_since": "2024-12-20T00:00:00Z",
  "include_archived": "false",
  "participant_type": "doctor|patient",
  "related_appointment": "1001",
  "tags": "hipertension,seguimiento",
  "search": "término de búsqueda",
  "ordering": "-updated_at|created_at|title",
  "page": 1,
  "page_size": 20
}
```

### **GET /api/chat/conversations/{id}/messages/**

```javascript
// Parámetros para mensajes
{
  "before": "2024-12-26T10:00:00Z", // Mensajes antes de esta fecha
  "after": "2024-12-25T10:00:00Z", // Mensajes después de esta fecha
  "message_type": "text|file|image|system",
  "sender": "123", // Mensajes de usuario específico
  "has_attachments": "true|false",
  "search": "término de búsqueda",
  "include_deleted": "false",
  "ordering": "-timestamp|timestamp",
  "page": 1,
  "page_size": 50
}
```

### **GET /api/chat/search/**

```javascript
// Búsqueda global en chats
{
  "query": "término de búsqueda",
  "in_conversations": "1001,1002", // IDs específicas
  "message_types": "text,file",
  "from_user": "123",
  "date_from": "2024-12-01",
  "date_to": "2024-12-31",
  "file_types": "prescription,lab_result",
  "has_medical_terms": "true",
  "ordering": "-timestamp|relevance",
  "page": 1,
  "page_size": 20
}
```

---

## 📝 **CASOS DE USO DETALLADOS**

### **1. Iniciar Conversación Doctor-Paciente**

**Flujo completo:**

```javascript
// 1. Doctor inicia conversación después de consulta
POST /api/chat/conversations/
{
  "type": "consultation",
  "title": "Seguimiento - Hipertensión Arterial",
  "description": "Canal para seguimiento post-consulta",
  "participants": [789], // ID del paciente
  "metadata": {
    "related_appointment_id": 1001,
    "consultation_type": "follow_up",
    "priority": "normal",
    "tags": ["hipertension", "seguimiento"]
  },
  "settings": {
    "file_sharing_enabled": true,
    "video_calls_enabled": true,
    "auto_delete_messages": false
  }
}

// Respuesta
{
  "id": 1001,
  "conversation_id": "CONV-2024-001001",
  "status": "created",
  "participants_notified": true,
  "websocket_channel": "conversation_1001"
}

// 2. Enviar mensaje inicial
POST /api/chat/conversations/1001/messages/
{
  "message_type": "text",
  "content": "Hola Ana, he creado este canal para que podamos dar seguimiento a su tratamiento. ¿Cómo se ha sentido con la nueva medicación?",
  "priority": "normal"
}
```

### **2. Compartir Archivo Médico**

**Proceso de subir receta:**

```javascript
// 1. Subir archivo
POST /api/chat/upload-file/
// FormData with file
{
  "file": [PDF file],
  "file_type": "prescription",
  "conversation_id": 1001,
  "description": "Receta para medicación hipertensión",
  "requires_patient_consent": true,
  "is_medical_document": true
}

// Respuesta
{
  "file_id": "FILE-2024-003001",
  "upload_status": "success",
  "file_url": "https://secure-files.mediconnect.com/FILE-2024-003001",
  "processing_status": "completed",
  "virus_scan": "clean"
}

// 2. Enviar mensaje con archivo
POST /api/chat/conversations/1001/messages/
{
  "message_type": "file",
  "content": "Aquí está su nueva receta. Por favor descárguela y sígala según las indicaciones.",
  "attachments": ["FILE-2024-003001"]
}
```

### **3. Iniciar Videollamada**

**Flujo de videoconsulta:**

```javascript
// 1. Iniciar llamada
POST /api/chat/video-call/start/
{
  "conversation_id": 1001,
  "type": "video",
  "max_duration_minutes": 30,
  "recording_enabled": false
}

// Respuesta
{
  "call_id": "CALL-2024-002001",
  "status": "pending",
  "room_url": "https://video.mediconnect.com/room/CALL-2024-002001",
  "access_token": "eyJhbGci...",
  "expires_at": "2024-12-26T11:00:00Z",
  "participants_notified": true
}

// 2. WebSocket notifica a participantes
{
  "type": "video_call_invitation",
  "data": {
    "call_id": "CALL-2024-002001",
    "initiator": "Dra. María Martínez",
    "room_url": "https://video.mediconnect.com/room/CALL-2024-002001",
    "expires_in_seconds": 60
  }
}

// 3. Participante se une
POST /api/chat/video-call/join/
{
  "call_id": "CALL-2024-002001"
}
```

---

## ⚠️ **VALIDACIONES Y ERRORES**

### **Errores Específicos del Módulo**

```javascript
// Error 403 - No puede iniciar conversación
{
  "error": "conversation_not_allowed",
  "message": "No puede iniciar conversación con este usuario",
  "details": {
    "target_user_id": 123,
    "reason": "no_medical_relationship",
    "suggestion": "Debe tener una cita programada o histórica"
  }
}

// Error 400 - Fuera de horario
{
  "error": "outside_chat_hours",
  "message": "Los chats médicos están disponibles de 8 AM a 10 PM",
  "details": {
    "current_time": "23:30",
    "allowed_hours": "08:00-22:00",
    "emergency_channel": "/api/chat/emergency/"
  }
}

// Error 413 - Archivo muy grande
{
  "error": "file_too_large",
  "message": "El archivo excede el tamaño máximo permitido",
  "details": {
    "file_size": 52428800, // 50MB
    "max_size": 10485760, // 10MB
    "suggested_compression": true
  }
}

// Error 400 - Tipo de archivo no permitido
{
  "error": "file_type_not_allowed",
  "message": "Este tipo de archivo no está permitido en conversaciones médicas",
  "details": {
    "file_type": "executable",
    "allowed_types": ["pdf", "jpg", "png", "doc", "docx"],
    "security_reason": "potential_malware_risk"
  }
}
```

### **Validaciones de Seguridad**

```javascript
// Validaciones automáticas
{
  "message_content": {
    "max_length": 5000,
    "profanity_filter": true,
    "phi_detection": true, // Detecta información médica sensible
    "spam_detection": true
  },
  "file_upload": {
    "virus_scan": "required",
    "file_type_whitelist": ["pdf", "jpg", "png", "doc", "docx", "mp3", "mp4"],
    "max_size_mb": 10,
    "encryption": "automatic"
  },
  "rate_limits": {
    "messages_per_minute": 20,
    "files_per_hour": 10,
    "video_calls_per_day": 5
  }
}
```

---

## 🔔 **NOTIFICACIONES Y ALERTAS**

### **Notificaciones Push**

```javascript
// Mensaje nuevo
{
  "notification_type": "new_message",
  "title": "Nuevo mensaje de Dra. María Martínez",
  "body": "¿Cómo se ha sentido con la nueva medicación?",
  "data": {
    "conversation_id": 1001,
    "message_id": 5001,
    "sender_name": "Dra. María Martínez",
    "sender_type": "doctor"
  },
  "priority": "normal",
  "sound": "default",
  "badge": 3 // Número de mensajes no leídos
}

// Llamada de video entrante
{
  "notification_type": "video_call_incoming",
  "title": "Videollamada entrante",
  "body": "Dra. María Martínez te está llamando",
  "data": {
    "call_id": "CALL-2024-002001",
    "caller_name": "Dra. María Martínez",
    "room_url": "https://video.mediconnect.com/room/CALL-2024-002001"
  },
  "priority": "high",
  "sound": "ringtone",
  "vibrate": [200, 100, 200]
}

// Archivo médico compartido
{
  "notification_type": "medical_file_shared",
  "title": "Nuevo documento médico",
  "body": "Dra. María Martínez compartió una receta",
  "data": {
    "file_id": "FILE-2024-003001",
    "file_type": "prescription",
    "conversation_id": 1001
  },
  "priority": "high",
  "requires_action": true
}
```

---

## 📊 **MÉTRICAS Y ANALYTICS**

### **Dashboard de Chat**

```javascript
// GET /api/chat/analytics/
{
  "period": "last_30_days",
  "user_id": 123,
  "user_type": "doctor",
  "conversations": {
    "total_active": 45,
    "new_conversations": 12,
    "completed_conversations": 8,
    "avg_duration_days": 5.2
  },
  "messages": {
    "total_sent": 230,
    "total_received": 189,
    "avg_response_time_minutes": 24,
    "peak_hours": ["10:00", "14:00", "16:00"]
  },
  "files_shared": {
    "total": 56,
    "by_type": {
      "prescription": 25,
      "lab_result": 15,
      "image": 10,
      "document": 6
    },
    "total_size_mb": 450.5
  },
  "video_calls": {
    "total_initiated": 15,
    "total_completed": 12,
    "avg_duration_minutes": 18.5,
    "technical_issues": 2
  },
  "patient_satisfaction": {
    "response_time_rating": 4.6,
    "communication_clarity": 4.8,
    "overall_experience": 4.7
  }
}
```

---

## 🚀 **IMPLEMENTACIÓN RECOMENDADA**

### **Orden de Implementación Frontend**

1. **Chat Básico** (Mensajes de texto simples)
2. **Lista de Conversaciones** (Inbox/bandeja)
3. **WebSocket Integration** (Tiempo real)
4. **Indicadores de Estado** (Leído, escribiendo, en línea)
5. **Compartir Archivos** (Upload/download seguro)
6. **Búsqueda en Chats** (Buscar mensajes/archivos)
7. **Videollamadas** (Integración WebRTC)
8. **Notificaciones Push** (Mensajes y llamadas)
9. **Chat Grupal** (Equipos médicos)
10. **Configuraciones Avanzadas** (Privacidad, archivado)

### **Consideraciones de UX/UI**

- **Indicador Médico**: Visual claro de que es comunicación doctor-paciente
- **Cifrado Visible**: Indicador de seguridad para confianza
- **Archivos Médicos**: Preview y categorización clara
- **Horarios**: Mostrar disponibilidad y límites de tiempo
- **Emergencias**: Botón de emergencia prominente
- **Responsive**: Optimizado para móvil (chat frecuente)
- **Accesibilidad**: Soporte para lectores de pantalla
- **Offline**: Sincronización cuando regrese conexión

### **Integración WebRTC para Video**

```javascript
// Configuración recomendada
{
  "video_settings": {
    "resolution": "720p",
    "frame_rate": 30,
    "bitrate": "adaptive",
    "echo_cancellation": true,
    "noise_suppression": true
  },
  "audio_settings": {
    "echo_cancellation": true,
    "noise_suppression": true,
    "auto_gain_control": true
  },
  "security": {
    "dtls_fingerprint": true,
    "srtp_encryption": true,
    "turn_server_auth": true
  }
}
```

---

## 🔗 **RELACIONES CON OTROS MÓDULOS**

- **Users**: Participantes en conversaciones (doctores/pacientes)
- **Appointments**: Conversaciones se crean post-consulta
- **Medical Records**: Archivos compartidos se vinculan a expedientes
- **Notifications**: Sistema completo de alertas
- **Video Calling**: Integración con sistema de videollamadas
- **Analytics**: Métricas de comunicación y satisfacción

---

## 🛡️ **CONSIDERACIONES DE SEGURIDAD CRÍTICAS**

```javascript
// Medidas de seguridad implementadas
{
  "encryption": {
    "end_to_end": "Signal Protocol",
    "at_rest": "AES-256",
    "in_transit": "TLS 1.3",
    "key_rotation": "monthly"
  },
  "privacy": {
    "message_retention": "7_years", // Regulación médica
    "automatic_deletion": "configurable",
    "phi_protection": "hipaa_compliant",
    "audit_logging": "comprehensive"
  },
  "access_control": {
    "participant_verification": "required",
    "session_timeout": "30_minutes",
    "concurrent_sessions": "limited",
    "geographic_restrictions": "configurable"
  },
  "monitoring": {
    "unusual_activity": "detected",
    "bulk_downloads": "flagged",
    "suspicious_messages": "reviewed",
    "breach_detection": "automated"
  }
}
```

---

_Última actualización: Diciembre 2024_
