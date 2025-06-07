# 🚀 DEPLOYMENT & SETUP - MediConnect

## 📋 **RESUMEN DEL MÓDULO**

Guía completa para despliegue, configuración y administración del sistema MediConnect en diferentes entornos (desarrollo, staging, producción).

---

## 🔧 **ARQUITECTURA DEL SISTEMA**

### **Stack Tecnológico**

```
Backend: Django 5.2 + Django REST Framework
Database: PostgreSQL (producción) / SQLite (desarrollo)
Cache/Message Broker: Redis
WebSockets: Django Channels
Task Queue: Celery
Authentication: JWT (Simple JWT)
File Storage: Local/AWS S3
Monitoring: Django Logging
```

### **Estructura de Módulos**

```
MediConnect/
├── users/              # Gestión de usuarios (doctores, pacientes)
├── appointments/       # Sistema de citas médicas
├── medical_records/    # Historiales médicos
├── chat/              # Chat en tiempo real
├── notifications/     # Sistema de notificaciones
├── clinics/           # Gestión de clínicas
├── billing/           # Facturación y pagos
├── analytics/         # Métricas y reportes
├── core/              # Configuración central
└── docs/              # Documentación
```

---

## 🐳 **DEPLOYMENT CON DOCKER**

### **Docker Compose - Producción**

```yaml
version: "3.8"
services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DEBUG=False
      - DB_HOST=db
      - DB_NAME=mediconnect
      - DB_USER=mediconnect_user
      - DB_PASSWORD=${DB_PASSWORD}
      - REDIS_HOST=redis
      - SECRET_KEY=${SECRET_KEY}
    depends_on:
      - db
      - redis
    volumes:
      - ./media:/app/media
      - ./static:/app/static

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=mediconnect
      - POSTGRES_USER=mediconnect_user
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  celery:
    build: .
    command: celery -A mediconnect worker -l info
    environment:
      - DEBUG=False
      - DB_HOST=db
      - REDIS_HOST=redis
    depends_on:
      - db
      - redis

  celery-beat:
    build: .
    command: celery -A mediconnect beat -l info
    environment:
      - DEBUG=False
      - DB_HOST=db
      - REDIS_HOST=redis
    depends_on:
      - db
      - redis

volumes:
  postgres_data:
  redis_data:
```

### **Dockerfile**

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health/ || exit 1

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mediconnect.wsgi:application"]
```

---

## 🔐 **VARIABLES DE ENTORNO**

### **Archivo .env para Desarrollo**

```env
# Django Configuration
DEBUG=True
SECRET_KEY=your-secret-key-here
ALLOWED_HOSTS=localhost,127.0.0.1

# Database Configuration
DB_HOST=localhost
DB_NAME=mediconnect
DB_USER=mediconnect_user
DB_PASSWORD=your-password-here
DB_PORT=5432

# Redis Configuration
REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# JWT Configuration
JWT_ACCESS_TOKEN_LIFETIME=1440  # minutes (24 hours)
JWT_REFRESH_TOKEN_LIFETIME=10080  # minutes (7 days)

# File Storage
MEDIA_URL=/media/
STATIC_URL=/static/

# Push Notifications
FCM_SERVER_KEY=your-fcm-server-key

# Email Configuration (opcional)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
```

### **Variables de Producción**

```env
# Django Configuration
DEBUG=False
SECRET_KEY=generate-strong-secret-key
ALLOWED_HOSTS=yourdomain.com,api.yourdomain.com

# Database Configuration
DB_HOST=your-postgres-host
DB_NAME=mediconnect_prod
DB_USER=mediconnect_prod_user
DB_PASSWORD=strong-password-here
DB_PORT=5432

# Security
SECURE_SSL_REDIRECT=True
SECURE_HSTS_SECONDS=31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS=True
SECURE_HSTS_PRELOAD=True
```

---

## 🏗️ **CONFIGURACIÓN INICIAL**

### **1. Instalación - Desarrollo Local**

```bash
# Clonar repositorio
git clone https://github.com/yourorg/mediconnect.git
cd mediconnect

# Crear entorno virtual
python -m venv venv
source venv/bin/activate  # Linux/Mac
# o
venv\Scripts\activate     # Windows

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus configuraciones

# Configurar base de datos
python manage.py makemigrations
python manage.py migrate

# Crear superusuario
python manage.py createsuperuser

# Cargar datos de prueba (opcional)
python manage.py loaddata fixtures/initial_data.json

# Ejecutar servidor
python manage.py runserver
```

### **2. Configuración de Redis (Desarrollo)**

```bash
# Instalar Redis
# Ubuntu/Debian
sudo apt-get install redis-server

# macOS
brew install redis

# Windows
# Descargar desde https://redis.io/download

# Iniciar Redis
redis-server

# Verificar conexión
redis-cli ping
```

### **3. Configuración de Celery**

```bash
# Terminal 1 - Worker
celery -A mediconnect worker -l info

# Terminal 2 - Beat Scheduler
celery -A mediconnect beat -l info

# Terminal 3 - Monitor (opcional)
celery -A mediconnect flower
```

---

## 🗄️ **CONFIGURACIÓN DE BASE DE DATOS**

### **PostgreSQL - Producción**

```sql
-- Crear base de datos y usuario
CREATE DATABASE mediconnect;
CREATE USER mediconnect_user WITH ENCRYPTED PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE mediconnect TO mediconnect_user;

-- Configurar extensiones
\c mediconnect;
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### **Migraciones y Índices**

```bash
# Crear migraciones
python manage.py makemigrations

# Aplicar migraciones
python manage.py migrate

# Crear índices adicionales (opcional)
python manage.py dbshell
```

```sql
-- Índices de rendimiento para consultas frecuentes
CREATE INDEX CONCURRENTLY idx_appointments_datetime ON appointments_appointment(datetime);
CREATE INDEX CONCURRENTLY idx_messages_created_at ON chat_message(created_at);
CREATE INDEX CONCURRENTLY idx_users_user_type ON users_user(user_type);
```

---

## 🔒 **CONFIGURACIÓN DE SEGURIDAD**

### **Django Security Settings**

```python
# settings/production.py
SECURE_SSL_REDIRECT = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_BROWSER_XSS_FILTER = True
X_FRAME_OPTIONS = 'DENY'

# CORS Configuration
CORS_ALLOWED_ORIGINS = [
    "https://yourdomain.com",
    "https://app.yourdomain.com",
]

# JWT Security
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(hours=24),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
}
```

### **Firewall y Nginx**

```nginx
# /etc/nginx/sites-available/mediconnect
server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /ws/ {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }

    location /static/ {
        alias /path/to/static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location /media/ {
        alias /path/to/media/;
        expires 1y;
        add_header Cache-Control "public";
    }
}
```

---

## 📊 **MONITOREO Y LOGGING**

### **Django Logging Configuration**

```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '/var/log/mediconnect/django.log',
            'maxBytes': 1024*1024*5,  # 5 MB
            'backupCount': 5,
            'formatter': 'verbose',
        },
        'error_file': {
            'level': 'ERROR',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '/var/log/mediconnect/error.log',
            'maxBytes': 1024*1024*5,  # 5 MB
            'backupCount': 5,
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'INFO',
            'propagate': True,
        },
        'mediconnect': {
            'handlers': ['file', 'error_file'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
}
```

### **Health Check Endpoints**

```python
# core/views.py
@api_view(['GET'])
@permission_classes([AllowAny])
def health_check(request):
    """Health check endpoint for monitoring."""
    checks = {
        'database': False,
        'redis': False,
        'celery': False,
    }

    # Database check
    try:
        from django.db import connection
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
        checks['database'] = True
    except Exception:
        pass

    # Redis check
    try:
        import redis
        r = redis.Redis(host=settings.REDIS_HOST)
        r.ping()
        checks['redis'] = True
    except Exception:
        pass

    # Celery check (simplified)
    checks['celery'] = True  # Implement actual check

    all_healthy = all(checks.values())
    status_code = 200 if all_healthy else 503

    return Response({
        'status': 'healthy' if all_healthy else 'unhealthy',
        'checks': checks,
        'timestamp': timezone.now().isoformat()
    }, status=status_code)
```

---

## 🔄 **BACKUP Y RECOVERY**

### **Database Backup**

```bash
#!/bin/bash
# backup_db.sh
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/mediconnect"
DB_NAME="mediconnect"

# Crear directorio si no existe
mkdir -p $BACKUP_DIR

# Backup de base de datos
pg_dump -h localhost -U mediconnect_user $DB_NAME | gzip > $BACKUP_DIR/db_backup_$DATE.sql.gz

# Backup de archivos media
tar -czf $BACKUP_DIR/media_backup_$DATE.tar.gz /path/to/media/

# Limpiar backups antiguos (mantener últimos 7 días)
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
```

### **Automated Backup con Cron**

```bash
# Agregar a crontab
# Backup diario a las 2:00 AM
0 2 * * * /path/to/backup_db.sh

# Backup semanal completo los domingos a las 3:00 AM
0 3 * * 0 /path/to/full_backup.sh
```

---

## 🚀 **DEPLOYMENT CHECKLIST**

### **Pre-Deployment**

- [ ] Configurar variables de entorno de producción
- [ ] Generar SECRET_KEY fuerte
- [ ] Configurar base de datos PostgreSQL
- [ ] Configurar Redis
- [ ] Configurar SSL/HTTPS
- [ ] Configurar dominio y DNS
- [ ] Preparar certificados SSL

### **Deployment**

- [ ] Ejecutar migraciones: `python manage.py migrate`
- [ ] Recopilar archivos estáticos: `python manage.py collectstatic`
- [ ] Crear superusuario: `python manage.py createsuperuser`
- [ ] Configurar servidor web (Nginx/Apache)
- [ ] Configurar supervisor/systemd para procesos
- [ ] Configurar Celery workers

### **Post-Deployment**

- [ ] Verificar health check: `/api/health/`
- [ ] Probar autenticación y endpoints principales
- [ ] Verificar WebSockets funcionando
- [ ] Configurar monitoreo y alertas
- [ ] Configurar backups automáticos
- [ ] Documentar credenciales de acceso

---

## 🐛 **TROUBLESHOOTING**

### **Problemas Comunes**

**1. Error de conexión a base de datos**

```bash
# Verificar configuración
python manage.py dbshell

# Verificar variables de entorno
echo $DB_HOST $DB_NAME $DB_USER
```

**2. WebSockets no funcionan**

```bash
# Verificar Redis
redis-cli ping

# Verificar configuración de Channels
python manage.py shell
>>> from channels.layers import get_channel_layer
>>> channel_layer = get_channel_layer()
>>> channel_layer
```

**3. Celery tasks no se ejecutan**

```bash
# Verificar Celery worker
celery -A mediconnect inspect active

# Verificar Redis queue
redis-cli
> KEYS celery*
```

**4. Static files no se sirven**

```bash
# Recopilar archivos estáticos
python manage.py collectstatic --clear

# Verificar configuración de Nginx
nginx -t
```

---

## 📚 **COMANDOS ÚTILES**

```bash
# Development
python manage.py runserver
python manage.py shell
python manage.py makemigrations
python manage.py migrate

# Database
python manage.py dbshell
python manage.py dumpdata > backup.json
python manage.py loaddata backup.json

# Static files
python manage.py collectstatic
python manage.py findstatic filename.css

# Celery
celery -A mediconnect worker -l info
celery -A mediconnect beat -l info
celery -A mediconnect flower

# Testing
python manage.py test
python manage.py test appointments.tests
```

---

## 🔧 **CONFIGURACIÓN DE DESARROLLO**

### **PyCharm/VSCode Settings**

```json
{
  "python.defaultInterpreterPath": "./venv/bin/python",
  "python.linting.enabled": true,
  "python.linting.flake8Enabled": true,
  "python.formatting.provider": "black",
  "files.exclude": {
    "**/__pycache__": true,
    "**/*.pyc": true
  }
}
```

### **Git Hooks**

```bash
#!/bin/sh
# .git/hooks/pre-commit
python manage.py test
flake8 .
black --check .
```

---

Este documento proporciona toda la información necesaria para desplegar y mantener el sistema MediConnect en cualquier entorno. Para soporte adicional, consulta la documentación específica de cada módulo o contacta al equipo de desarrollo.
