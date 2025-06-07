# 📚 MediConnect API - Documentación Completa para Frontend

## 🎯 **RESUMEN EJECUTIVO**

Esta documentación está diseñada para que el equipo de frontend pueda implementar correctamente todas las funcionalidades del sistema MediConnect. Incluye endpoints, permisos, autenticación, WebSockets, estructuras de datos y casos de uso detallados.

## 🚀 **QUICK START**

### **Para Desarrolladores Frontend**

```javascript
// 1. Configuración inicial de API
const API_BASE_URL = "http://localhost:8000/api";

// 2. Login básico
const login = async (email, password) => {
  const response = await fetch(`${API_BASE_URL}/auth/login/`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });
  const data = await response.json();
  localStorage.setItem("access_token", data.access);
  return data;
};

// 3. Request autenticado básico
const makeAuthenticatedRequest = async (endpoint) => {
  const token = localStorage.getItem("access_token");
  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  return response.json();
};

// 4. WebSocket básico para notificaciones
const connectNotifications = (userId) => {
  const ws = new WebSocket(`ws://localhost:8000/ws/notifications/${userId}/`);
  ws.onmessage = (event) => {
    const notification = JSON.parse(event.data);
    console.log("Nueva notificación:", notification);
  };
  return ws;
};
```

### **Endpoints Más Utilizados**

- `POST /api/auth/login/` - Autenticación
- `GET /api/appointments/` - Listar citas
- `POST /api/appointments/` - Crear cita
- `GET /api/dashboard/doctor/` - Dashboard del doctor
- `GET /api/dashboard/patient/` - Dashboard del paciente
- `WS /ws/chat/{conversation_id}/` - Chat en tiempo real
- `WS /ws/notifications/{user_id}/` - Notificaciones en tiempo real

### **📋 ÍNDICE DE DOCUMENTACIÓN**

#### **🔧 Core Documentation**

1. **[AUTENTICACIÓN Y USUARIOS](./01-AUTHENTICATION.md)** - Sistema de autenticación, roles y permisos
2. **[USUARIOS - DOCTORES Y PACIENTES](./02-USERS.md)** - Gestión de perfiles de usuarios

#### **⚕️ Medical Modules**

3. **[CITAS MÉDICAS](./03-APPOINTMENTS.md)** - Sistema completo de citas
4. **[HISTORIALES MÉDICOS](./04-MEDICAL-RECORDS.md)** - Expedientes y registros médicos
5. **[CLÍNICAS](./06-CLINICS.md)** - Gestión de clínicas y recursos

#### **💬 Communication & Notifications**

6. **[CHAT Y MENSAJERÍA](./05-CHAT.md)** - Sistema de comunicación en tiempo real
7. **[NOTIFICACIONES](./09-NOTIFICATIONS.md)** - Sistema de notificaciones push y en tiempo real
8. **[WEBSOCKETS](./10-WEBSOCKETS.md)** - Comunicación en tiempo real

#### **💰 Business Operations**

9. **[FACTURACIÓN](./07-BILLING.md)** - Sistema de facturación y pagos
10. **[ANALYTICS](./08-ANALYTICS.md)** - Reportes y métricas avanzadas
11. **[DASHBOARDS](./11-DASHBOARDS.md)** - Paneles de control por rol

#### **🚀 Setup & Integration**

12. **[DEPLOYMENT & SETUP](./12-DEPLOYMENT-SETUP.md)** - Guía completa de despliegue y configuración
13. **[INTEGRATION GUIDE](./13-INTEGRATION-GUIDE.md)** - Cómo los módulos trabajan juntos

---

## 🔐 **INFORMACIÓN CRÍTICA DE AUTENTICACIÓN**

### **Base URL de la API**

```
Desarrollo: http://localhost:8000
Producción: https://tu-dominio.com
```

### **Headers Obligatorios para Todas las Peticiones Autenticadas**

```http
Authorization: Bearer {access_token}
Content-Type: application/json
Accept: application/json
```

### **Tipos de Usuario y Permisos**

```javascript
USER_TYPES = {
  admin: "Administrador del sistema",
  doctor: "Médico/Doctor",
  patient: "Paciente",
};
```

### **Estados de Respuesta HTTP**

```javascript
HTTP_STATUS = {
  200: "OK - Petición exitosa",
  201: "Created - Recurso creado exitosamente",
  400: "Bad Request - Error en los datos enviados",
  401: "Unauthorized - Token inválido o expirado",
  403: "Forbidden - Sin permisos para esta acción",
  404: "Not Found - Recurso no encontrado",
  500: "Internal Server Error - Error del servidor",
};
```

---

## 🏗️ **ARQUITECTURA DE LA API**

### **Estructura de Endpoints**

```
/api/
├── auth/                    # Autenticación
├── users/                   # Usuarios base
├── doctors/                 # Doctores
├── patients/                # Pacientes
├── appointments/            # Citas médicas
├── medical-records/         # Expedientes médicos
├── conversations/           # Chat - Conversaciones
├── messages/                # Chat - Mensajes
├── notifications/           # Notificaciones
├── dashboard/               # Dashboards por rol
└── health/                  # Health check

/billing/api/                # Facturación
├── payment-methods/
├── invoices/
├── payments/
├── credit-accounts/
└── reports/

/clinics/api/                # Clínicas
├── clinics/
├── specialties/
├── clinic-doctors/
├── resources/
└── settings/

/analytics/api/              # Analytics
├── reports/
├── patient-behavior/
├── doctor-performance/
├── predictive-insights/
├── custom-queries/
└── operational-metrics/
```

---

## 🔄 **FLUJOS DE TRABAJO PRINCIPALES**

### **1. Flujo de Autenticación**

```
1. POST /api/auth/login/ → Obtener tokens
2. Usar Bearer token en todas las peticiones
3. POST /api/auth/refresh/ → Renovar token cuando expire
```

### **2. Flujo de Citas (Doctor)**

```
1. GET /api/appointments/ → Ver todas las citas
2. POST /api/appointments/ → Crear nueva cita
3. PATCH /api/appointments/{id}/ → Actualizar estado
4. GET /api/appointments/{id}/ → Ver detalles
```

### **3. Flujo de Chat**

```
1. GET /api/conversations/ → Obtener conversaciones
2. WebSocket: /ws/chat/{room_name}/ → Conectar chat en tiempo real
3. POST /api/messages/ → Enviar mensaje
4. GET /api/messages/?conversation={id} → Obtener historial
```

### **4. Flujo de Notificaciones**

```
1. WebSocket: /ws/notifications/ → Conectar a notificaciones
2. GET /api/notifications/ → Obtener notificaciones
3. PATCH /api/notifications/{id}/ → Marcar como leída
```

---

## 📱 **CASOS DE USO POR ROL**

### **ADMIN (Administrador)**

- ✅ Acceso completo a todos los endpoints
- ✅ Gestionar usuarios, clínicas, doctores, pacientes
- ✅ Ver todos los reportes y analytics
- ✅ Configurar sistema global
- ✅ Acceso a facturación completa

### **DOCTOR (Médico)**

- ✅ Gestionar sus propias citas
- ✅ Ver expedientes de sus pacientes
- ✅ Chat con pacientes asignados
- ✅ Crear y actualizar historiales médicos
- ✅ Ver sus métricas de rendimiento
- ✅ Gestionar recursos de sus clínicas
- ❌ No puede ver otros doctores (excepto en la misma clínica)
- ❌ No puede modificar configuraciones globales

### **PATIENT (Paciente)**

- ✅ Ver sus propias citas
- ✅ Chat con sus doctores
- ✅ Ver sus expedientes médicos (no privados)
- ✅ Ver sus facturas y pagos
- ✅ Actualizar su perfil
- ❌ No puede crear citas (solo solicitar)
- ❌ No puede ver información de otros pacientes
- ❌ No puede acceder a analytics

---

## 🚨 **ERRORES COMUNES Y SOLUCIONES**

### **Error 401 - Token Expirado**

```javascript
// Solución: Renovar token automáticamente
if (response.status === 401) {
  await refreshToken();
  // Reintentar petición original
}
```

### **Error 403 - Sin Permisos**

```javascript
// Verificar rol del usuario antes de hacer petición
if (user.user_type !== "doctor") {
  // No mostrar botón de "Crear Cita"
}
```

### **Error 400 - Datos Inválidos**

```javascript
// Validar datos antes de enviar
const requiredFields = ["patient", "doctor", "date", "start_time"];
const isValid = requiredFields.every((field) => data[field]);
```

---

## 📊 **ESTRUCTURA ESTÁNDAR DE RESPUESTAS**

### **Respuesta de Lista (GET /api/model/)**

```json
{
  "count": 150,
  "next": "http://localhost:8000/api/model/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "field1": "valor1",
      "field2": "valor2",
      "created_at": "2025-06-07T10:00:00Z",
      "updated_at": "2025-06-07T10:00:00Z"
    }
  ]
}
```

### **Respuesta de Detalle (GET /api/model/{id}/)**

```json
{
  "id": 1,
  "field1": "valor1",
  "field2": "valor2",
  "related_field": {
    "id": 2,
    "name": "Relacionado"
  },
  "created_at": "2025-06-07T10:00:00Z",
  "updated_at": "2025-06-07T10:00:00Z"
}
```

### **Respuesta de Error**

```json
{
  "success": false,
  "message": "Error de autenticación",
  "detail": "Authentication credentials were not provided.",
  "code": "authentication_error"
}
```

---

## 🔧 **HERRAMIENTAS DE DESARROLLO**

### **URLs de Testing**

```
Health Check: GET /health/
API Root: GET /api/
API Info: GET /api/info/
```

### **Filtros y Búsquedas Comunes**

```
?search=término               # Búsqueda de texto
?ordering=-created_at         # Ordenamiento
?status=active               # Filtro por estado
?date__gte=2025-01-01        # Filtro por fecha mayor igual
?page=2&page_size=20         # Paginación
```

### **Parámetros de URL Estándar**

```
{id}            # ID numérico del recurso
{pk}            # Primary key del recurso
{user_id}       # ID del usuario
{room_name}     # Nombre de sala de chat
```

---

## 📝 **PRÓXIMOS PASOS**

1. **Leer documentación específica por módulo** en el orden sugerido
2. **Implementar autenticación** como primer paso
3. **Configurar interceptores HTTP** para manejo de tokens
4. **Implementar WebSockets** para funcionalidades en tiempo real
5. **Testear con datos de prueba** disponibles en el entorno Docker

---

## 🆘 **SOPORTE Y CONTACTO**

- **Documentación completa**: Ver archivos en `/docs/`
- **Datos de prueba**: Disponibles en entorno Docker
- **Endpoints de testing**: `/health/`, `/api/info/`
- **Logs de desarrollo**: Disponibles en contenedor Docker

**¡Esta es tu guía central! Cada módulo tiene su documentación detallada con ejemplos específicos, casos de uso y implementaciones paso a paso.**
