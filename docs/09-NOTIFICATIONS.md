# NOTIFICATIONS Module API Documentation

## Overview

The NOTIFICATIONS module provides a comprehensive real-time notification system for the MediConnect healthcare platform. It supports multiple notification channels including in-app notifications, push notifications (FCM), email, and SMS, with sophisticated delivery mechanisms including WebSocket real-time updates and scheduled delivery through Celery tasks.

### Key Features

- **Multi-Channel Delivery**: In-app, push notifications, email, SMS
- **Real-Time Updates**: WebSocket integration for instant notification delivery
- **Automatic Generation**: Signal-based notification creation from system events
- **Scheduled Notifications**: Celery task integration for appointment reminders
- **Device Management**: Push notification device registration and management
- **Priority Levels**: Critical, high, medium, low priority notifications
- **Read Status Tracking**: Comprehensive read/unread state management
- **Bulk Operations**: Mass notification delivery and management

## Data Models

### Notification Model

```json
{
  "id": "uuid",
  "recipient": {
    "id": "integer",
    "username": "string",
    "email": "string",
    "first_name": "string",
    "last_name": "string"
  },
  "sender": {
    "id": "integer",
    "username": "string",
    "first_name": "string",
    "last_name": "string"
  },
  "notification_type": "appointment|message|medical_record|system|billing|reminder",
  "title": "string",
  "message": "string",
  "priority": "critical|high|medium|low",
  "is_read": "boolean",
  "created_at": "datetime",
  "read_at": "datetime|null",
  "scheduled_for": "datetime|null",
  "delivery_status": "pending|sent|delivered|failed",
  "channels": ["in_app", "push", "email", "sms"],
  "metadata": {
    "appointment_id": "integer|null",
    "message_id": "integer|null",
    "medical_record_id": "integer|null",
    "invoice_id": "integer|null",
    "action_url": "string|null",
    "deep_link": "string|null"
  },
  "delivery_attempts": "integer",
  "last_delivery_attempt": "datetime|null",
  "delivery_errors": ["string"]
}
```

### PushNotificationDevice Model

```json
{
  "id": "integer",
  "user": {
    "id": "integer",
    "username": "string"
  },
  "device_token": "string",
  "device_type": "android|ios|web",
  "device_name": "string",
  "app_version": "string",
  "is_active": "boolean",
  "created_at": "datetime",
  "updated_at": "datetime",
  "last_used_at": "datetime"
}
```

### NotificationPreferences Model

```json
{
  "id": "integer",
  "user": {
    "id": "integer",
    "username": "string"
  },
  "notification_types": {
    "appointment": {
      "in_app": "boolean",
      "push": "boolean",
      "email": "boolean",
      "sms": "boolean"
    },
    "message": {
      "in_app": "boolean",
      "push": "boolean",
      "email": "boolean",
      "sms": "boolean"
    },
    "medical_record": {
      "in_app": "boolean",
      "push": "boolean",
      "email": "boolean",
      "sms": "boolean"
    },
    "system": {
      "in_app": "boolean",
      "push": "boolean",
      "email": "boolean",
      "sms": "boolean"
    },
    "billing": {
      "in_app": "boolean",
      "push": "boolean",
      "email": "boolean",
      "sms": "boolean"
    },
    "reminder": {
      "in_app": "boolean",
      "push": "boolean",
      "email": "boolean",
      "sms": "boolean"
    }
  },
  "quiet_hours": {
    "enabled": "boolean",
    "start_time": "time",
    "end_time": "time",
    "timezone": "string"
  },
  "frequency_limits": {
    "max_per_hour": "integer",
    "max_per_day": "integer"
  }
}
```

## API Endpoints

### 1. Notification Management

#### GET /api/notifications/

**Description**: Retrieve user's notifications with filtering and pagination
**Permission**: Authenticated users (own notifications only)
**User Roles**: Admin, Doctor, Patient

**Query Parameters**:

```json
{
  "page": "integer (default: 1)",
  "page_size": "integer (default: 20, max: 100)",
  "is_read": "boolean (optional)",
  "notification_type": "appointment|message|medical_record|system|billing|reminder (optional)",
  "priority": "critical|high|medium|low (optional)",
  "from_date": "datetime (optional)",
  "to_date": "datetime (optional)",
  "ordering": "string (default: -created_at)"
}
```

**Response**:

```json
{
  "count": 150,
  "next": "string|null",
  "previous": "string|null",
  "results": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "notification_type": "appointment",
      "title": "Appointment Reminder",
      "message": "Your appointment with Dr. Smith is scheduled for tomorrow at 2:00 PM",
      "priority": "high",
      "is_read": false,
      "created_at": "2024-01-15T10:30:00Z",
      "metadata": {
        "appointment_id": 123,
        "action_url": "/appointments/123",
        "deep_link": "mediconnect://appointment/123"
      }
    }
  ]
}
```

#### GET /api/notifications/{id}/

**Description**: Retrieve specific notification details
**Permission**: Authenticated users (own notifications only)
**User Roles**: Admin, Doctor, Patient

**Response**: Single notification object with full details

#### POST /api/notifications/

**Description**: Create new notification (Admin/System only)
**Permission**: Admin users only
**User Roles**: Admin

**Request Body**:

```json
{
  "recipient_id": 123,
  "notification_type": "system",
  "title": "System Maintenance Notice",
  "message": "The system will be under maintenance on Jan 20th from 2-4 AM",
  "priority": "medium",
  "channels": ["in_app", "email"],
  "scheduled_for": "2024-01-20T01:30:00Z",
  "metadata": {
    "action_url": "/system/maintenance"
  }
}
```

#### PATCH /api/notifications/{id}/

**Description**: Update notification (mark as read, etc.)
**Permission**: Authenticated users (own notifications only)
**User Roles**: Admin, Doctor, Patient

**Request Body**:

```json
{
  "is_read": true
}
```

#### DELETE /api/notifications/{id}/

**Description**: Delete notification
**Permission**: Authenticated users (own notifications only)
**User Roles**: Admin, Doctor, Patient

### 2. Bulk Operations

#### POST /api/notifications/mark-all-read/

**Description**: Mark all notifications as read for the current user
**Permission**: Authenticated users
**User Roles**: Admin, Doctor, Patient

**Request Body**:

```json
{
  "notification_type": "appointment (optional - to mark specific type as read)"
}
```

#### POST /api/notifications/mark-multiple-read/

**Description**: Mark multiple notifications as read
**Permission**: Authenticated users (own notifications only)
**User Roles**: Admin, Doctor, Patient

**Request Body**:

```json
{
  "notification_ids": [
    "550e8400-e29b-41d4-a716-446655440000",
    "550e8400-e29b-41d4-a716-446655440001"
  ]
}
```

#### DELETE /api/notifications/bulk-delete/

**Description**: Delete multiple notifications
**Permission**: Authenticated users (own notifications only)
**User Roles**: Admin, Doctor, Patient

**Request Body**:

```json
{
  "notification_ids": [
    "550e8400-e29b-41d4-a716-446655440000",
    "550e8400-e29b-41d4-a716-446655440001"
  ]
}
```

### 3. Push Notification Device Management

#### GET /api/notifications/devices/

**Description**: Retrieve user's registered devices
**Permission**: Authenticated users (own devices only)
**User Roles**: Admin, Doctor, Patient

**Response**:

```json
{
  "results": [
    {
      "id": 1,
      "device_token": "encrypted_token_string",
      "device_type": "android",
      "device_name": "Samsung Galaxy S21",
      "app_version": "1.2.3",
      "is_active": true,
      "last_used_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

#### POST /api/notifications/devices/

**Description**: Register new push notification device
**Permission**: Authenticated users
**User Roles**: Admin, Doctor, Patient

**Request Body**:

```json
{
  "device_token": "FCM_or_APNS_token_string",
  "device_type": "android",
  "device_name": "User's Phone",
  "app_version": "1.2.3"
}
```

#### PATCH /api/notifications/devices/{id}/

**Description**: Update device information
**Permission**: Authenticated users (own devices only)
**User Roles**: Admin, Doctor, Patient

**Request Body**:

```json
{
  "is_active": false,
  "device_name": "Updated Name"
}
```

#### DELETE /api/notifications/devices/{id}/

**Description**: Unregister device
**Permission**: Authenticated users (own devices only)
**User Roles**: Admin, Doctor, Patient

### 4. Notification Preferences

#### GET /api/notifications/preferences/

**Description**: Get user's notification preferences
**Permission**: Authenticated users (own preferences only)
**User Roles**: Admin, Doctor, Patient

**Response**: NotificationPreferences object

#### PUT /api/notifications/preferences/

**Description**: Update notification preferences
**Permission**: Authenticated users (own preferences only)
**User Roles**: Admin, Doctor, Patient

**Request Body**: Complete NotificationPreferences object

#### PATCH /api/notifications/preferences/

**Description**: Partially update notification preferences
**Permission**: Authenticated users (own preferences only)
**User Roles**: Admin, Doctor, Patient

**Request Body**:

```json
{
  "notification_types": {
    "appointment": {
      "push": false,
      "email": true
    }
  },
  "quiet_hours": {
    "enabled": true,
    "start_time": "22:00:00",
    "end_time": "08:00:00"
  }
}
```

### 5. Statistics and Analytics

#### GET /api/notifications/stats/

**Description**: Get notification statistics for the user
**Permission**: Authenticated users (own stats only)
**User Roles**: Admin, Doctor, Patient

**Query Parameters**:

```json
{
  "period": "day|week|month|year (default: month)",
  "from_date": "date (optional)",
  "to_date": "date (optional)"
}
```

**Response**:

```json
{
  "total_notifications": 250,
  "unread_count": 15,
  "by_type": {
    "appointment": 120,
    "message": 80,
    "medical_record": 30,
    "system": 15,
    "billing": 5
  },
  "by_priority": {
    "critical": 2,
    "high": 25,
    "medium": 150,
    "low": 73
  },
  "delivery_stats": {
    "success_rate": 98.5,
    "failed_deliveries": 3,
    "pending_deliveries": 1
  },
  "engagement_metrics": {
    "read_rate": 85.2,
    "average_read_time": "2.5 hours",
    "click_through_rate": 45.8
  }
}
```

#### GET /api/notifications/admin/stats/

**Description**: Get system-wide notification statistics (Admin only)
**Permission**: Admin users only
**User Roles**: Admin

**Query Parameters**: Same as user stats plus:

```json
{
  "user_id": "integer (optional)",
  "clinic_id": "integer (optional)"
}
```

**Response**: Extended statistics with system-wide metrics

## WebSocket Integration

### Real-Time Notification Delivery

#### WebSocket Endpoint

**URL**: `ws://domain/ws/notifications/{user_id}/`
**Authentication**: Token-based authentication via query parameter or header

#### Connection Setup

```javascript
// Frontend connection example
const ws = new WebSocket(
  `ws://localhost:8000/ws/notifications/${userId}/?token=${authToken}`
);
```

#### Message Types

##### 1. New Notification

```json
{
  "type": "new_notification",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "notification_type": "appointment",
    "title": "New Appointment Scheduled",
    "message": "Your appointment has been confirmed for Jan 20th at 2:00 PM",
    "priority": "high",
    "created_at": "2024-01-15T10:30:00Z",
    "metadata": {
      "appointment_id": 123,
      "action_url": "/appointments/123"
    }
  }
}
```

##### 2. Notification Read

```json
{
  "type": "notification_read",
  "data": {
    "notification_id": "550e8400-e29b-41d4-a716-446655440000",
    "read_at": "2024-01-15T10:35:00Z"
  }
}
```

##### 3. Bulk Updates

```json
{
  "type": "bulk_update",
  "data": {
    "action": "mark_all_read",
    "affected_count": 15,
    "notification_type": "message"
  }
}
```

##### 4. Connection Status

```json
{
  "type": "connection_status",
  "data": {
    "status": "connected",
    "unread_count": 7,
    "last_sync": "2024-01-15T10:30:00Z"
  }
}
```

#### Client-to-Server Messages

##### Mark as Read

```json
{
  "type": "mark_read",
  "notification_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

##### Subscribe to Types

```json
{
  "type": "subscribe",
  "notification_types": ["appointment", "message"]
}
```

## Business Logic Implementation

### 1. Automatic Notification Creation

#### Signal-Based Generation

The system automatically creates notifications based on various events:

**Appointment Events**:

- New appointment scheduled → Notification to patient and doctor
- Appointment cancelled → Notification to both parties
- Appointment rescheduled → Notification with old/new times
- Appointment reminder → 24h, 2h, 30min before scheduled time

**Message Events**:

- New chat message → Real-time notification to recipient
- Missed call → Notification with callback option
- File shared → Notification with download link

**Medical Record Events**:

- New record created → Notification to patient
- Record updated → Notification to patient and related doctors
- Test results available → High-priority notification

**System Events**:

- Account created → Welcome notification
- Password changed → Security notification
- System maintenance → Advance notice notification

**Billing Events**:

- Invoice generated → Notification to patient
- Payment received → Confirmation notification
- Payment failed → Retry notification

#### Notification Priority Logic

```python
def calculate_priority(notification_type, context):
    """
    Priority calculation based on type and context
    """
    if notification_type == 'medical_record' and context.get('urgent'):
        return 'critical'
    elif notification_type == 'appointment' and context.get('same_day'):
        return 'high'
    elif notification_type == 'billing' and context.get('overdue'):
        return 'high'
    elif notification_type == 'system':
        return 'medium'
    else:
        return 'low'
```

### 2. Delivery Management

#### Multi-Channel Delivery Strategy

1. **In-App**: Always delivered for active users
2. **Push Notification**: Based on user preferences and device availability
3. **Email**: For important notifications or inactive users
4. **SMS**: For critical notifications only

#### Delivery Retry Logic

```python
def retry_delivery(notification_id):
    """
    Exponential backoff retry strategy
    """
    attempts = [1, 5, 15, 30, 60]  # minutes
    max_attempts = 5

    # Retry logic with increasing delays
    # Failed deliveries are logged for analysis
```

#### Quiet Hours Enforcement

```python
def should_deliver_now(user, notification):
    """
    Check if notification should be delivered based on quiet hours
    """
    if not user.preferences.quiet_hours.enabled:
        return True

    if notification.priority == 'critical':
        return True  # Always deliver critical notifications

    # Check current time against user's quiet hours
    # Consider user's timezone
```

### 3. Performance Optimization

#### Batch Processing

- Bulk notification creation for system-wide announcements
- Batch database updates for read status changes
- Optimized queries with select_related and prefetch_related

#### Caching Strategy

- Redis caching for unread counts
- Cached user preferences
- Device token caching for push notifications

#### Database Optimization

```sql
-- Indexes for performance
CREATE INDEX idx_notifications_recipient_created ON notifications(recipient_id, created_at);
CREATE INDEX idx_notifications_type_priority ON notifications(notification_type, priority);
CREATE INDEX idx_notifications_unread ON notifications(recipient_id, is_read, created_at);
```

## Permission Matrix

| Endpoint                    | Admin   | Doctor  | Patient | Notes                              |
| --------------------------- | ------- | ------- | ------- | ---------------------------------- |
| GET /notifications/         | ✓ (all) | ✓ (own) | ✓ (own) | Users see only their notifications |
| POST /notifications/        | ✓       | ✗       | ✗       | System notification creation       |
| PATCH /notifications/{id}/  | ✓       | ✓ (own) | ✓ (own) | Update own notifications           |
| DELETE /notifications/{id}/ | ✓       | ✓ (own) | ✓ (own) | Delete own notifications           |
| POST /mark-all-read/        | ✓       | ✓       | ✓       | Bulk read operations               |
| GET /devices/               | ✓ (all) | ✓ (own) | ✓ (own) | Device management                  |
| POST /devices/              | ✓       | ✓       | ✓       | Device registration                |
| GET /preferences/           | ✓ (all) | ✓ (own) | ✓ (own) | Notification preferences           |
| PUT /preferences/           | ✓       | ✓ (own) | ✓ (own) | Update preferences                 |
| GET /stats/                 | ✓ (all) | ✓ (own) | ✓ (own) | Statistics access                  |
| GET /admin/stats/           | ✓       | ✗       | ✗       | System-wide statistics             |

## Error Codes

| Code      | Message                      | Description                            | Resolution                        |
| --------- | ---------------------------- | -------------------------------------- | --------------------------------- |
| NOTIF_001 | Notification not found       | Requested notification doesn't exist   | Verify notification ID            |
| NOTIF_002 | Invalid notification type    | Unsupported notification type provided | Use valid type from enum          |
| NOTIF_003 | Device registration failed   | FCM/APNS token registration error      | Check token format and validity   |
| NOTIF_004 | Delivery failed              | Notification delivery unsuccessful     | Check delivery channels and retry |
| NOTIF_005 | Invalid recipient            | Target user not found or inactive      | Verify recipient user ID          |
| NOTIF_006 | Preferences validation error | Invalid preference configuration       | Check preference format           |
| NOTIF_007 | Rate limit exceeded          | Too many notifications sent            | Respect rate limits               |
| NOTIF_008 | WebSocket connection error   | Real-time connection failed            | Check authentication and network  |
| NOTIF_009 | Bulk operation failed        | Mass operation partially failed        | Check individual item errors      |
| NOTIF_010 | Scheduling error             | Invalid scheduled delivery time        | Verify future timestamp           |

## Integration Points

### 1. Appointments Module

- Automatic reminder notifications
- Status change notifications
- Cancellation/rescheduling alerts

### 2. Chat Module

- New message notifications
- Missed call alerts
- File sharing notifications

### 3. Medical Records Module

- New record availability
- Test result notifications
- Record sharing alerts

### 4. Users Module

- Account security notifications
- Profile update confirmations
- Role change notifications

### 5. Billing Module

- Invoice generation alerts
- Payment confirmations
- Overdue payment reminders

### 6. Analytics Module

- Report generation completion
- Anomaly detection alerts
- Performance milestone notifications

## Frontend Implementation Guidelines

### 1. Real-Time Updates Setup

```typescript
// WebSocket connection management
class NotificationService {
  private ws: WebSocket;
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 5;

  connect(userId: string, token: string) {
    const wsUrl = `ws://localhost:8000/ws/notifications/${userId}/?token=${token}`;
    this.ws = new WebSocket(wsUrl);

    this.ws.onmessage = this.handleMessage.bind(this);
    this.ws.onclose = this.handleClose.bind(this);
    this.ws.onerror = this.handleError.bind(this);
  }

  private handleMessage(event: MessageEvent) {
    const data = JSON.parse(event.data);

    switch (data.type) {
      case "new_notification":
        this.showNotification(data.data);
        this.updateUnreadCount();
        break;
      case "notification_read":
        this.markAsRead(data.data.notification_id);
        break;
      case "bulk_update":
        this.handleBulkUpdate(data.data);
        break;
    }
  }
}
```

### 2. Notification Display Component

```typescript
// Notification list management
interface NotificationListProps {
  userId: string;
  filters?: NotificationFilters;
}

const NotificationList: React.FC<NotificationListProps> = ({
  userId,
  filters,
}) => {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);
  const [unreadCount, setUnreadCount] = useState(0);

  // Load notifications with pagination
  const loadNotifications = async (page = 1) => {
    const params = new URLSearchParams({
      page: page.toString(),
      page_size: "20",
      ...filters,
    });

    const response = await fetch(`/api/notifications/?${params}`, {
      headers: {
        Authorization: `Bearer ${getToken()}`,
        "Content-Type": "application/json",
      },
    });

    const data = await response.json();
    setNotifications((prev) =>
      page === 1 ? data.results : [...prev, ...data.results]
    );
    setLoading(false);
  };

  // Mark notification as read
  const markAsRead = async (notificationId: string) => {
    await fetch(`/api/notifications/${notificationId}/`, {
      method: "PATCH",
      headers: {
        Authorization: `Bearer ${getToken()}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ is_read: true }),
    });

    // Update local state
    setNotifications((prev) =>
      prev.map((n) => (n.id === notificationId ? { ...n, is_read: true } : n))
    );
    setUnreadCount((prev) => Math.max(0, prev - 1));
  };
};
```

### 3. Push Notification Setup

```typescript
// Device registration for push notifications
class PushNotificationManager {
  async registerDevice(userId: string) {
    // Get FCM token
    const token = await this.getFCMToken();

    // Register with backend
    const response = await fetch("/api/notifications/devices/", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${getToken()}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        device_token: token,
        device_type: this.getDeviceType(),
        device_name: this.getDeviceName(),
        app_version: this.getAppVersion(),
      }),
    });

    if (!response.ok) {
      throw new Error("Device registration failed");
    }
  }

  private async getFCMToken(): Promise<string> {
    // Firebase Cloud Messaging implementation
    // Return device token for push notifications
  }
}
```

### 4. Preference Management

```typescript
// Notification preferences interface
interface NotificationPreferencesForm {
  preferences: NotificationPreferences;
  onSave: (preferences: NotificationPreferences) => Promise<void>;
}

const PreferencesForm: React.FC<NotificationPreferencesForm> = ({
  preferences,
  onSave,
}) => {
  const [formData, setFormData] = useState(preferences);
  const [saving, setSaving] = useState(false);

  const handleSave = async () => {
    setSaving(true);
    try {
      await fetch("/api/notifications/preferences/", {
        method: "PUT",
        headers: {
          Authorization: `Bearer ${getToken()}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });

      await onSave(formData);
    } catch (error) {
      console.error("Failed to save preferences:", error);
    } finally {
      setSaving(false);
    }
  };

  // Form rendering logic with channel toggles
  // Quiet hours configuration
  // Frequency limit settings
};
```

### 5. Bulk Operations

```typescript
// Bulk notification management
class BulkNotificationManager {
  async markAllAsRead(notificationType?: string) {
    const body = notificationType
      ? { notification_type: notificationType }
      : {};

    const response = await fetch("/api/notifications/mark-all-read/", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${getToken()}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      throw new Error("Failed to mark notifications as read");
    }

    return response.json();
  }

  async deleteMultiple(notificationIds: string[]) {
    const response = await fetch("/api/notifications/bulk-delete/", {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${getToken()}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ notification_ids: notificationIds }),
    });

    if (!response.ok) {
      throw new Error("Failed to delete notifications");
    }

    return response.json();
  }
}
```

## Testing Considerations

### 1. Unit Tests

- Notification creation logic
- Delivery channel selection
- Priority calculation
- Permission checking

### 2. Integration Tests

- WebSocket connection handling
- Signal-based notification generation
- Multi-channel delivery
- Celery task execution

### 3. Performance Tests

- Bulk notification creation
- Real-time delivery under load
- Database query optimization
- WebSocket connection limits

### 4. End-to-End Tests

- Complete notification workflows
- Cross-module integration
- Mobile app push notifications
- Email/SMS delivery

This comprehensive documentation provides all the necessary information for frontend teams to implement notification features without including any frontend code, focusing entirely on API routes, business logic, permissions, and integration guidelines.
