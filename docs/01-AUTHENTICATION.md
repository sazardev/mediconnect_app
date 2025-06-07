# 🔐 **AUTENTICACIÓN Y USUARIOS - Documentación Frontend**

## 📋 **ÍNDICE**

1. [Sistema de Autenticación](#sistema-de-autenticación)
2. [Endpoints de Autenticación](#endpoints-de-autenticación)
3. [Tipos de Usuario y Permisos](#tipos-de-usuario-y-permisos)
4. [Implementación de Tokens JWT](#implementación-de-tokens-jwt)
5. [Interceptores y Middleware](#interceptores-y-middleware)
6. [Casos de Uso por Rol](#casos-de-uso-por-rol)
7. [Ejemplos de Implementación](#ejemplos-de-implementación)

---

## 🔑 **SISTEMA DE AUTENTICACIÓN**

MediConnect utiliza **JWT (JSON Web Tokens)** con sistema de refresh tokens para mantener sesiones seguras.

### **Flujo de Autenticación**

```
1. Usuario ingresa email/password
2. POST /api/auth/login/ → Recibe access_token + refresh_token
3. Usar access_token en header Authorization
4. Cuando access_token expire → POST /api/auth/refresh/
5. Repetir proceso o redirect a login
```

### **Duración de Tokens**

```javascript
ACCESS_TOKEN_LIFETIME = 60 minutos
REFRESH_TOKEN_LIFETIME = 24 horas
```

---

## 🛣️ **ENDPOINTS DE AUTENTICACIÓN**

### **1. LOGIN - Iniciar Sesión**

```http
POST /api/auth/login/
Content-Type: application/json
```

**Request Body:**

```json
{
  "email": "doctor@example.com",
  "password": "securepassword123"
}
```

**Response (200 OK):**

```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "email": "doctor@example.com",
    "username": "dr_smith",
    "first_name": "Dr. John",
    "last_name": "Smith",
    "user_type": "doctor",
    "phone_number": "+1234567890",
    "avatar": "http://localhost:8000/media/avatars/doctor.jpg",
    "is_verified": true,
    "date_joined": "2025-01-01T00:00:00Z"
  },
  "user_type": "doctor"
}
```

**Response (400 Bad Request):**

```json
{
  "success": false,
  "message": "Credenciales inválidas",
  "detail": "No active account found with the given credentials",
  "code": "invalid_credentials"
}
```

### **2. REFRESH TOKEN - Renovar Token**

```http
POST /api/auth/refresh/
Content-Type: application/json
```

**Request Body:**

```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

**Response (200 OK):**

```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

---

## 👥 **TIPOS DE USUARIO Y PERMISOS**

### **Jerarquía de Permisos**

```
ADMIN > DOCTOR > PATIENT
```

### **1. ADMIN (Administrador)**

```javascript
const ADMIN_PERMISSIONS = {
  // Usuarios
  can_view_all_users: true,
  can_create_users: true,
  can_modify_any_user: true,
  can_delete_users: true,

  // Clínicas
  can_manage_clinics: true,
  can_assign_doctors_to_clinics: true,
  can_view_clinic_analytics: true,

  // Citas
  can_view_all_appointments: true,
  can_modify_any_appointment: true,

  // Facturación
  can_access_billing: true,
  can_generate_reports: true,

  // Sistema
  can_access_admin_panel: true,
  can_configure_system: true,
};
```

### **2. DOCTOR (Médico)**

```javascript
const DOCTOR_PERMISSIONS = {
  // Usuarios
  can_view_own_profile: true,
  can_view_assigned_patients: true,
  can_modify_own_profile: true,

  // Citas
  can_view_own_appointments: true,
  can_create_appointments: true,
  can_modify_own_appointments: true,
  can_cancel_appointments: true,

  // Expedientes
  can_view_patient_records: true,
  can_create_medical_records: true,
  can_update_medical_records: true,

  // Chat
  can_chat_with_patients: true,

  // Analytics
  can_view_own_performance: true,
  can_view_clinic_metrics: true,

  // Clínicas
  can_view_clinic_resources: true,
  can_manage_clinic_schedule: true,
};
```

### **3. PATIENT (Paciente)**

```javascript
const PATIENT_PERMISSIONS = {
  // Usuarios
  can_view_own_profile: true,
  can_modify_own_profile: true,

  // Citas
  can_view_own_appointments: true,
  can_request_appointments: true,
  can_cancel_own_appointments: true,

  // Expedientes
  can_view_own_records: true, // (solo no privados)

  // Chat
  can_chat_with_doctors: true,

  // Facturación
  can_view_own_invoices: true,
  can_make_payments: true,
};
```

---

## 🔧 **IMPLEMENTACIÓN DE TOKENS JWT**

### **Headers Requeridos**

```javascript
// Para todas las peticiones autenticadas
const headers = {
  Authorization: `Bearer ${accessToken}`,
  "Content-Type": "application/json",
  Accept: "application/json",
};
```

### **Validación de Token**

```javascript
// Verificar si token está expirado
function isTokenExpired(token) {
  try {
    const decoded = jwt_decode(token);
    const currentTime = Date.now() / 1000;
    return decoded.exp < currentTime;
  } catch (error) {
    return true;
  }
}

// Obtener información del usuario del token
function getUserFromToken(token) {
  try {
    const decoded = jwt_decode(token);
    return {
      user_id: decoded.user_id,
      user_type: decoded.user_type,
      email: decoded.email,
      exp: decoded.exp,
    };
  } catch (error) {
    return null;
  }
}
```

---

## 🔄 **INTERCEPTORES Y MIDDLEWARE**

### **Interceptor para Refresh Automático**

```javascript
// Ejemplo para Axios
axios.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const refreshToken = localStorage.getItem("refresh_token");
        const response = await axios.post("/api/auth/refresh/", {
          refresh: refreshToken,
        });

        const newAccessToken = response.data.access;
        localStorage.setItem("access_token", newAccessToken);

        // Actualizar header y reintentar petición original
        originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
        return axios(originalRequest);
      } catch (refreshError) {
        // Refresh falló, redirect a login
        localStorage.clear();
        window.location.href = "/login";
        return Promise.reject(refreshError);
      }
    }

    return Promise.reject(error);
  }
);
```

### **Guard de Rutas por Rol**

```javascript
// Ejemplo para React Router
const ProtectedRoute = ({ children, requiredRole, requiredPermissions }) => {
  const user = getCurrentUser();

  if (!user) {
    return <Navigate to="/login" />;
  }

  if (requiredRole && user.user_type !== requiredRole) {
    return <Navigate to="/unauthorized" />;
  }

  if (requiredPermissions) {
    const hasPermissions = requiredPermissions.every((permission) =>
      checkUserPermission(user, permission)
    );

    if (!hasPermissions) {
      return <Navigate to="/unauthorized" />;
    }
  }

  return children;
};

// Uso
<Route
  path="/admin/*"
  element={
    <ProtectedRoute requiredRole="admin">
      <AdminDashboard />
    </ProtectedRoute>
  }
/>;
```

---

## 🎯 **CASOS DE USO POR ROL**

### **ADMIN - Panel de Administración**

```javascript
// URLs permitidas para admin
const ADMIN_ROUTES = [
  "/admin/dashboard",
  "/admin/users",
  "/admin/clinics",
  "/admin/analytics",
  "/admin/billing",
  "/admin/settings",
];

// Endpoints accesibles
const ADMIN_ENDPOINTS = [
  "GET /api/users/", // Ver todos los usuarios
  "POST /api/users/", // Crear usuarios
  "DELETE /api/users/{id}/", // Eliminar usuarios
  "GET /analytics/api/reports/", // Ver todos los reportes
  "POST /clinics/api/clinics/", // Crear clínicas
];
```

### **DOCTOR - Panel Médico**

```javascript
// URLs permitidas para doctor
const DOCTOR_ROUTES = [
  "/doctor/dashboard",
  "/doctor/appointments",
  "/doctor/patients",
  "/doctor/medical-records",
  "/doctor/chat",
  "/doctor/profile",
];

// Endpoints accesibles
const DOCTOR_ENDPOINTS = [
  "GET /api/appointments/", // Solo sus citas
  "POST /api/appointments/", // Crear citas
  "GET /api/medical-records/", // Solo sus pacientes
  "POST /api/medical-records/", // Crear expedientes
  "GET /api/conversations/", // Sus conversaciones
  "GET /analytics/api/doctor-performance/", // Sus métricas
];
```

### **PATIENT - Panel Paciente**

```javascript
// URLs permitidas para patient
const PATIENT_ROUTES = [
  "/patient/dashboard",
  "/patient/appointments",
  "/patient/medical-history",
  "/patient/chat",
  "/patient/billing",
  "/patient/profile",
];

// Endpoints accesibles
const PATIENT_ENDPOINTS = [
  "GET /api/appointments/", // Solo sus citas
  "GET /api/medical-records/", // Solo sus expedientes (no privados)
  "GET /api/conversations/", // Sus conversaciones
  "GET /billing/api/invoices/", // Solo sus facturas
  "POST /billing/api/payments/", // Realizar pagos
];
```

---

## 💻 **EJEMPLOS DE IMPLEMENTACIÓN**

### **1. Servicio de Autenticación (JavaScript)**

```javascript
class AuthService {
  constructor() {
    this.baseURL = "http://localhost:8000";
  }

  async login(email, password) {
    try {
      const response = await fetch(`${this.baseURL}/api/auth/login/`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ email, password }),
      });

      if (!response.ok) {
        throw new Error("Login failed");
      }

      const data = await response.json();

      // Guardar tokens
      localStorage.setItem("access_token", data.access);
      localStorage.setItem("refresh_token", data.refresh);
      localStorage.setItem("user", JSON.stringify(data.user));

      return data;
    } catch (error) {
      throw error;
    }
  }

  async refreshToken() {
    const refreshToken = localStorage.getItem("refresh_token");

    if (!refreshToken) {
      throw new Error("No refresh token");
    }

    try {
      const response = await fetch(`${this.baseURL}/api/auth/refresh/`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ refresh: refreshToken }),
      });

      if (!response.ok) {
        throw new Error("Token refresh failed");
      }

      const data = await response.json();
      localStorage.setItem("access_token", data.access);

      return data.access;
    } catch (error) {
      this.logout();
      throw error;
    }
  }

  logout() {
    localStorage.removeItem("access_token");
    localStorage.removeItem("refresh_token");
    localStorage.removeItem("user");
    window.location.href = "/login";
  }

  getCurrentUser() {
    const user = localStorage.getItem("user");
    return user ? JSON.parse(user) : null;
  }

  isAuthenticated() {
    const token = localStorage.getItem("access_token");
    return token && !this.isTokenExpired(token);
  }

  isTokenExpired(token) {
    try {
      const decoded = JSON.parse(atob(token.split(".")[1]));
      return decoded.exp * 1000 < Date.now();
    } catch {
      return true;
    }
  }

  hasRole(requiredRole) {
    const user = this.getCurrentUser();
    return user && user.user_type === requiredRole;
  }

  canAccess(endpoint, method = "GET") {
    const user = this.getCurrentUser();
    if (!user) return false;

    // Lógica de permisos específica por endpoint
    const permissions = this.getPermissionsForUser(user.user_type);
    return this.checkEndpointPermission(permissions, endpoint, method);
  }
}

// Instancia global
const authService = new AuthService();
```

### **2. Hook de React para Autenticación**

```javascript
import { useState, useEffect, createContext, useContext } from "react";

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const initAuth = async () => {
      const token = localStorage.getItem("access_token");
      const userData = localStorage.getItem("user");

      if (token && userData) {
        try {
          if (!authService.isTokenExpired(token)) {
            setUser(JSON.parse(userData));
          } else {
            await authService.refreshToken();
            setUser(JSON.parse(localStorage.getItem("user")));
          }
        } catch (error) {
          authService.logout();
        }
      }
      setLoading(false);
    };

    initAuth();
  }, []);

  const login = async (email, password) => {
    try {
      const data = await authService.login(email, password);
      setUser(data.user);
      return data;
    } catch (error) {
      throw error;
    }
  };

  const logout = () => {
    authService.logout();
    setUser(null);
  };

  const value = {
    user,
    login,
    logout,
    loading,
    isAuthenticated: !!user,
    hasRole: (role) => user?.user_type === role,
    canAccess: (endpoint, method) => authService.canAccess(endpoint, method),
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within AuthProvider");
  }
  return context;
};
```

### **3. Componente de Login**

```javascript
import React, { useState } from "react";
import { useAuth } from "./AuthContext";
import { useNavigate } from "react-router-dom";

const LoginForm = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const data = await login(email, password);

      // Redirect basado en tipo de usuario
      switch (data.user.user_type) {
        case "admin":
          navigate("/admin/dashboard");
          break;
        case "doctor":
          navigate("/doctor/dashboard");
          break;
        case "patient":
          navigate("/patient/dashboard");
          break;
        default:
          navigate("/dashboard");
      }
    } catch (error) {
      setError("Credenciales inválidas. Por favor intenta de nuevo.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {error && <div className="error">{error}</div>}

      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
      />

      <input
        type="password"
        placeholder="Contraseña"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />

      <button type="submit" disabled={loading}>
        {loading ? "Iniciando sesión..." : "Iniciar Sesión"}
      </button>
    </form>
  );
};
```

---

## 🔐 **SEGURIDAD Y MEJORES PRÁCTICAS**

### **1. Almacenamiento Seguro de Tokens**

```javascript
// ✅ CORRECTO: Usar localStorage para desarrollo
localStorage.setItem("access_token", token);

// 🔒 PRODUCCIÓN: Considerar httpOnly cookies
// Las cookies httpOnly son más seguras pero requieren configuración adicional
```

### **2. Validación de Permisos en Frontend**

```javascript
// ⚠️ IMPORTANTE: La validación de frontend es solo UX
// El backend SIEMPRE valida permisos
const canCreateAppointment = user.user_type === "doctor";

// Solo ocultar UI, no confiar en seguridad frontend
{
  canCreateAppointment && (
    <button onClick={createAppointment}>Crear Cita</button>
  );
}
```

### **3. Manejo de Errores de Autenticación**

```javascript
const handleAuthError = (error) => {
  switch (error.response?.status) {
    case 401:
      // Token expirado o inválido
      authService.logout();
      break;
    case 403:
      // Sin permisos
      showErrorMessage("No tienes permisos para esta acción");
      break;
    case 429:
      // Demasiadas peticiones
      showErrorMessage("Demasiados intentos. Intenta más tarde.");
      break;
    default:
      showErrorMessage("Error de conexión");
  }
};
```

---

## 🧪 **DATOS DE PRUEBA**

### **Usuarios de Prueba Disponibles**

```javascript
// Admin
{
  email: "admin@mediconnect.com",
  password: "admin123",
  user_type: "admin"
}

// Doctor
{
  email: "doctor_docker@mediconnect.com",
  password: "docker123",
  user_type: "doctor"
}

// Paciente
{
  email: "patient_docker@mediconnect.com",
  password: "docker123",
  user_type: "patient"
}
```

---

## 📝 **CHECKLIST DE IMPLEMENTACIÓN**

- [ ] Instalar y configurar jwt-decode
- [ ] Implementar AuthService con login/refresh/logout
- [ ] Crear interceptores HTTP para tokens
- [ ] Implementar guards de rutas por rol
- [ ] Configurar redirects automáticos por tipo de usuario
- [ ] Implementar manejo de errores 401/403
- [ ] Crear componentes de login/logout
- [ ] Testear flujo completo con usuarios de prueba
- [ ] Implementar refresh automático de tokens
- [ ] Configurar timeouts y reintentos

**¡La autenticación es la base del sistema! Implementa esto correctamente antes de continuar con otros módulos.**
