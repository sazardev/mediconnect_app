# WEBSOCKETS Module API Documentation

## Overview

The WEBSOCKETS module provides comprehensive real-time communication infrastructure for the MediConnect healthcare platform. Built on Django Channels with Redis as the channel layer backend, it enables instant bidirectional communication for chat messaging, notifications, live updates, and real-time collaboration features.

### Key Features

- **Real-Time Chat**: Instant messaging between doctors, patients, and staff
- **Live Notifications**: Real-time delivery of system notifications
- **Connection Management**: Automatic reconnection and connection state handling
- **Authentication**: JWT-based WebSocket authentication
- **Room-Based Communication**: Organized message routing through chat rooms
- **Presence Indicators**: Online/offline status tracking
- **Message Persistence**: Automatic message storage and history
- **Multi-Device Support**: Concurrent connections across multiple devices

## Architecture Overview

### WebSocket Infrastructure

- **Protocol**: WebSocket (ws://) and Secure WebSocket (wss://)
- **Backend**: Django Channels with ASGI
- **Channel Layer**: Redis for message routing and persistence
- **Authentication**: JWT token-based authentication middleware
- **Load Balancing**: Horizontal scaling support through Redis

### Connection Flow

1. Client initiates WebSocket connection with JWT token
2. Authentication middleware validates token and sets user context
3. Consumer accepts connection and joins relevant groups
4. Real-time message routing through channel groups
5. Automatic reconnection handling on connection loss

## WebSocket Endpoints

### 1. Chat WebSocket

#### Connection URL

**WebSocket URL**: `ws://domain/ws/chat/{room_name}/`
**Authentication**: JWT token via query parameter or header

#### Room Naming Convention

```
Room Name Format: {user1_id}_{user2_id}
Example: 123_456 (where user_id 123 < user_id 456)
Group Rooms: clinic_{clinic_id}, department_{dept_id}
```

#### Connection Parameters

```javascript
// Query parameter authentication
ws://localhost:8000/ws/chat/123_456/?token=jwt_token_here

// Header authentication (if supported by client)
Headers: {
    'Authorization': 'Bearer jwt_token_here'
}
```

#### Message Types - Client to Server

##### 1. Send Message

```json
{
  "type": "send_message",
  "data": {
    "message": "Hello, how are you?",
    "sender_id": 123,
    "receiver_id": 456,
    "message_type": "text|image|file|voice",
    "metadata": {
      "file_url": "string (optional)",
      "file_name": "string (optional)",
      "file_size": "integer (optional)",
      "duration": "integer (optional for voice)"
    }
  }
}
```

##### 2. Typing Indicator

```json
{
  "type": "typing_start",
  "data": {
    "sender_id": 123,
    "receiver_id": 456
  }
}
```

```json
{
  "type": "typing_stop",
  "data": {
    "sender_id": 123,
    "receiver_id": 456
  }
}
```

##### 3. Message Status Update

```json
{
  "type": "message_read",
  "data": {
    "message_id": 789,
    "reader_id": 456
  }
}
```

##### 4. Presence Update

```json
{
  "type": "presence_update",
  "data": {
    "status": "online|away|busy|offline",
    "last_seen": "datetime"
  }
}
```

#### Message Types - Server to Client

##### 1. New Message

```json
{
  "type": "chat_message",
  "data": {
    "id": 789,
    "sender": {
      "id": 123,
      "username": "dr_smith",
      "first_name": "John",
      "last_name": "Smith",
      "avatar_url": "string"
    },
    "receiver": {
      "id": 456,
      "username": "patient_doe",
      "first_name": "Jane",
      "last_name": "Doe"
    },
    "message": "Hello, how are you?",
    "message_type": "text",
    "timestamp": "2024-01-15T10:30:00Z",
    "is_read": false,
    "metadata": {}
  }
}
```

##### 2. Typing Notification

```json
{
  "type": "typing_notification",
  "data": {
    "user": {
      "id": 123,
      "username": "dr_smith",
      "first_name": "John"
    },
    "is_typing": true,
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

##### 3. Message Status

```json
{
  "type": "message_status",
  "data": {
    "message_id": 789,
    "status": "delivered|read",
    "timestamp": "2024-01-15T10:30:00Z",
    "user_id": 456
  }
}
```

##### 4. Presence Status

```json
{
  "type": "presence_status",
  "data": {
    "user": {
      "id": 123,
      "username": "dr_smith",
      "first_name": "John"
    },
    "status": "online|away|busy|offline",
    "last_seen": "2024-01-15T10:30:00Z"
  }
}
```

##### 5. Connection Status

```json
{
  "type": "connection_status",
  "data": {
    "status": "connected|reconnected|disconnected",
    "timestamp": "2024-01-15T10:30:00Z",
    "room_name": "123_456",
    "active_users": [123, 456]
  }
}
```

##### 6. Error Message

```json
{
  "type": "error",
  "data": {
    "code": "CHAT_001",
    "message": "Message delivery failed",
    "details": "Recipient is not available",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

### 2. Notifications WebSocket

#### Connection URL

**WebSocket URL**: `ws://domain/ws/notifications/`
**Authentication**: JWT token via query parameter

#### Connection Setup

```javascript
const ws = new WebSocket(
  `ws://localhost:8000/ws/notifications/?token=${authToken}`
);
```

#### Message Types - Server to Client

##### 1. New Notification

```json
{
  "type": "new_notification",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "notification_type": "appointment|message|medical_record|system|billing",
    "title": "Appointment Reminder",
    "message": "Your appointment is in 30 minutes",
    "priority": "critical|high|medium|low",
    "created_at": "2024-01-15T10:30:00Z",
    "metadata": {
      "appointment_id": 123,
      "action_url": "/appointments/123",
      "deep_link": "mediconnect://appointment/123"
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

##### 3. Bulk Update

```json
{
  "type": "bulk_update",
  "data": {
    "action": "mark_all_read|delete_all",
    "affected_count": 15,
    "notification_type": "appointment",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

##### 4. Unread Count Update

```json
{
  "type": "unread_count_update",
  "data": {
    "total_unread": 7,
    "by_type": {
      "appointment": 3,
      "message": 2,
      "medical_record": 1,
      "system": 1
    },
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

#### Message Types - Client to Server

##### 1. Mark as Read

```json
{
  "type": "mark_read",
  "data": {
    "notification_id": "550e8400-e29b-41d4-a716-446655440000"
  }
}
```

##### 2. Subscribe to Types

```json
{
  "type": "subscribe",
  "data": {
    "notification_types": ["appointment", "message"],
    "priorities": ["critical", "high"]
  }
}
```

##### 3. Heartbeat

```json
{
  "type": "heartbeat",
  "data": {
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

## Authentication & Security

### JWT Authentication Middleware

#### Token Validation Process

1. Extract JWT token from query parameter or header
2. Validate token signature and expiration
3. Extract user_id from token payload
4. Fetch user object from database
5. Set user context in WebSocket scope

#### Authentication Implementation

```python
# Middleware validation flow
async def authenticate_websocket(scope):
    # Extract token from query string
    query_string = scope.get('query_string', b'').decode()
    query_params = parse_qs(query_string)
    token = query_params.get('token', [None])[0]

    if not token:
        # Reject connection
        return None

    try:
        # Validate JWT token
        access_token = AccessToken(token)
        user_id = access_token.payload.get('user_id')
        user = await get_user_by_id(user_id)
        return user
    except TokenError:
        return None
```

#### Security Headers

```http
Sec-WebSocket-Protocol: chat
Sec-WebSocket-Version: 13
Origin: https://mediconnect.com
Authorization: Bearer jwt_token_here
```

### Permission Validation

#### Chat Permissions

- Users can only join rooms they have access to
- Doctor-patient communication requires active relationship
- Admin users can join any room for moderation
- Group rooms require membership validation

#### Notification Permissions

- Users receive only their own notifications
- Admin users can broadcast system notifications
- Role-based notification filtering

## Connection Management

### Connection Lifecycle

#### 1. Connection Establishment

```python
async def connect(self):
    # Authenticate user
    user = self.scope['user']
    if user.is_anonymous:
        await self.close()
        return

    # Join user-specific group
    self.group_name = f'user_{user.id}'
    await self.channel_layer.group_add(
        self.group_name,
        self.channel_name
    )

    # Accept connection
    await self.accept()

    # Send connection confirmation
    await self.send_connection_status('connected')
```

#### 2. Message Handling

```python
async def receive(self, text_data):
    try:
        data = json.loads(text_data)
        message_type = data.get('type')

        # Route message based on type
        handler = getattr(self, f'handle_{message_type}', None)
        if handler:
            await handler(data.get('data', {}))
        else:
            await self.send_error('INVALID_MESSAGE_TYPE')

    except json.JSONDecodeError:
        await self.send_error('INVALID_JSON')
```

#### 3. Disconnection Handling

```python
async def disconnect(self, close_code):
    # Update user presence
    await self.update_user_presence('offline')

    # Leave groups
    await self.channel_layer.group_discard(
        self.group_name,
        self.channel_name
    )

    # Clean up resources
    await self.cleanup_connection()
```

### Reconnection Strategy

#### Client-Side Reconnection

```javascript
class WebSocketManager {
  constructor(url, options = {}) {
    this.url = url;
    this.maxReconnectAttempts = options.maxReconnectAttempts || 5;
    this.reconnectInterval = options.reconnectInterval || 1000;
    this.currentAttempt = 0;
    this.isReconnecting = false;
  }

  connect() {
    this.ws = new WebSocket(this.url);
    this.setupEventHandlers();
  }

  setupEventHandlers() {
    this.ws.onopen = this.onOpen.bind(this);
    this.ws.onmessage = this.onMessage.bind(this);
    this.ws.onclose = this.onClose.bind(this);
    this.ws.onerror = this.onError.bind(this);
  }

  onClose(event) {
    if (
      !this.isReconnecting &&
      this.currentAttempt < this.maxReconnectAttempts
    ) {
      this.reconnect();
    }
  }

  reconnect() {
    this.isReconnecting = true;
    this.currentAttempt++;

    setTimeout(() => {
      console.log(`Reconnection attempt ${this.currentAttempt}`);
      this.connect();
      this.isReconnecting = false;
    }, this.reconnectInterval * this.currentAttempt);
  }
}
```

#### Exponential Backoff

```javascript
const calculateBackoffDelay = (attempt) => {
  return Math.min(1000 * Math.pow(2, attempt), 30000);
};
```

## Message Persistence & History

### Database Integration

#### Message Storage

```python
@database_sync_to_async
def save_message(self, sender_id, receiver_id, content, message_type='text'):
    return Message.objects.create(
        sender_id=sender_id,
        receiver_id=receiver_id,
        content=content,
        message_type=message_type,
        timestamp=timezone.now()
    )
```

#### Message History Retrieval

```python
@database_sync_to_async
def get_message_history(self, room_name, page=1, page_size=50):
    # Parse room participants
    user_ids = room_name.split('_')

    messages = Message.objects.filter(
        Q(sender_id__in=user_ids) & Q(receiver_id__in=user_ids)
    ).order_by('-timestamp')

    # Pagination logic
    start = (page - 1) * page_size
    end = start + page_size

    return messages[start:end]
```

### Message Delivery Guarantees

#### At-Least-Once Delivery

```python
async def send_with_retry(self, message_data, max_retries=3):
    for attempt in range(max_retries):
        try:
            await self.channel_layer.group_send(
                self.group_name,
                message_data
            )
            return True
        except Exception as e:
            if attempt == max_retries - 1:
                await self.log_delivery_failure(message_data, str(e))
                return False
            await asyncio.sleep(0.5 * (attempt + 1))
```

#### Message Acknowledgment

```python
async def handle_message_ack(self, data):
    message_id = data.get('message_id')
    if message_id:
        await self.mark_message_delivered(message_id)
```

## Real-Time Features

### 1. Typing Indicators

#### Implementation

```python
async def handle_typing_start(self, data):
    await self.channel_layer.group_send(
        self.room_group_name,
        {
            'type': 'typing_notification',
            'user_id': self.scope['user'].id,
            'is_typing': True,
            'timestamp': timezone.now().isoformat()
        }
    )

    # Auto-stop typing after 3 seconds
    await asyncio.sleep(3)
    await self.handle_typing_stop(data)
```

#### Client-Side Debouncing

```javascript
class TypingIndicator {
  constructor(websocket, delay = 1000) {
    this.ws = websocket;
    this.delay = delay;
    this.timeout = null;
    this.isTyping = false;
  }

  startTyping() {
    if (!this.isTyping) {
      this.ws.send(
        JSON.stringify({
          type: "typing_start",
          data: {},
        })
      );
      this.isTyping = true;
    }

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.stopTyping();
    }, this.delay);
  }

  stopTyping() {
    if (this.isTyping) {
      this.ws.send(
        JSON.stringify({
          type: "typing_stop",
          data: {},
        })
      );
      this.isTyping = false;
    }
    clearTimeout(this.timeout);
  }
}
```

### 2. Presence Management

#### Online Status Tracking

```python
class PresenceManager:
    def __init__(self):
        self.online_users = set()

    async def user_connected(self, user_id):
        self.online_users.add(user_id)
        await self.broadcast_presence_update(user_id, 'online')

    async def user_disconnected(self, user_id):
        self.online_users.discard(user_id)
        await self.broadcast_presence_update(user_id, 'offline')

    async def get_online_users(self):
        return list(self.online_users)
```

#### Last Seen Updates

```python
@database_sync_to_async
def update_last_seen(self, user_id):
    User.objects.filter(id=user_id).update(
        last_seen=timezone.now(),
        is_online=True
    )
```

### 3. File Sharing

#### Real-Time File Upload Notifications

```python
async def handle_file_upload(self, data):
    file_info = {
        'type': 'file_shared',
        'data': {
            'file_name': data['file_name'],
            'file_size': data['file_size'],
            'file_url': data['file_url'],
            'uploader': self.scope['user'].id,
            'timestamp': timezone.now().isoformat()
        }
    }

    await self.channel_layer.group_send(
        self.room_group_name,
        file_info
    )
```

## Error Handling & Monitoring

### Error Codes

| Code   | Message                 | Description                      | Resolution                         |
| ------ | ----------------------- | -------------------------------- | ---------------------------------- |
| WS_001 | Authentication failed   | Invalid or expired JWT token     | Refresh token and reconnect        |
| WS_002 | Connection rejected     | User not authorized for room     | Check user permissions             |
| WS_003 | Message delivery failed | Failed to send message           | Retry or check connection          |
| WS_004 | Invalid message format  | Malformed JSON or missing fields | Validate message structure         |
| WS_005 | Room not found          | Chat room doesn't exist          | Create room or check room name     |
| WS_006 | User not found          | Message recipient not found      | Verify user ID                     |
| WS_007 | Rate limit exceeded     | Too many messages sent           | Wait before sending more           |
| WS_008 | Connection timeout      | WebSocket connection timed out   | Reconnect with exponential backoff |
| WS_009 | Channel layer error     | Redis connection failed          | Check Redis server status          |
| WS_010 | Message too large       | Message exceeds size limit       | Reduce message size                |

### Error Response Format

```json
{
  "type": "error",
  "data": {
    "code": "WS_003",
    "message": "Message delivery failed",
    "details": "Recipient is not online",
    "timestamp": "2024-01-15T10:30:00Z",
    "retry_after": 5000
  }
}
```

### Logging & Monitoring

#### Connection Logging

```python
import logging

websocket_logger = logging.getLogger('websockets')

async def log_connection_event(self, event_type, details=None):
    websocket_logger.info(
        f"WebSocket {event_type}",
        extra={
            'user_id': getattr(self.scope['user'], 'id', None),
            'channel_name': self.channel_name,
            'event_type': event_type,
            'details': details,
            'timestamp': timezone.now().isoformat()
        }
    )
```

#### Performance Metrics

```python
import time
from django.core.cache import cache

async def track_message_latency(self, start_time):
    latency = time.time() - start_time
    cache.set(f'ws_latency_{self.scope["user"].id}', latency, 300)

    if latency > 1.0:  # Log slow messages
        websocket_logger.warning(
            f"Slow message delivery: {latency:.2f}s",
            extra={'user_id': self.scope['user'].id}
        )
```

## Performance Optimization

### 1. Connection Pooling

```python
# Redis connection pooling
CHANNEL_LAYERS = {
    'default': {
        'BACKEND': 'channels_redis.core.RedisChannelLayer',
        'CONFIG': {
            "hosts": [('127.0.0.1', 6379)],
            "capacity": 1500,
            "expiry": 60,
            "group_expiry": 86400,
            "symmetric_encryption_keys": [SECRET_KEY],
        }
    }
}
```

### 2. Message Batching

```python
class MessageBatcher:
    def __init__(self, batch_size=10, flush_interval=0.1):
        self.batch_size = batch_size
        self.flush_interval = flush_interval
        self.message_queue = []
        self.last_flush = time.time()

    async def add_message(self, message):
        self.message_queue.append(message)

        if (len(self.message_queue) >= self.batch_size or
            time.time() - self.last_flush > self.flush_interval):
            await self.flush_messages()

    async def flush_messages(self):
        if self.message_queue:
            await self.send_batch(self.message_queue)
            self.message_queue.clear()
            self.last_flush = time.time()
```

### 3. Memory Management

```python
async def cleanup_inactive_connections(self):
    """Remove connections that haven't sent heartbeat in 60 seconds"""
    current_time = time.time()
    inactive_connections = []

    for channel_name, last_heartbeat in self.connection_timestamps.items():
        if current_time - last_heartbeat > 60:
            inactive_connections.append(channel_name)

    for channel_name in inactive_connections:
        await self.force_disconnect(channel_name)
```

## Frontend Integration Examples

### 1. React WebSocket Hook

```typescript
import { useEffect, useRef, useState } from "react";

interface WebSocketHook {
  sendMessage: (message: any) => void;
  lastMessage: any;
  connectionStatus: "connecting" | "connected" | "disconnected";
  reconnect: () => void;
}

export const useWebSocket = (url: string, token: string): WebSocketHook => {
  const ws = useRef<WebSocket | null>(null);
  const [lastMessage, setLastMessage] = useState(null);
  const [connectionStatus, setConnectionStatus] = useState<
    "connecting" | "connected" | "disconnected"
  >("disconnected");
  const reconnectTimeoutRef = useRef<NodeJS.Timeout>();
  const [reconnectAttempts, setReconnectAttempts] = useState(0);

  const connect = useCallback(() => {
    setConnectionStatus("connecting");
    ws.current = new WebSocket(`${url}?token=${token}`);

    ws.current.onopen = () => {
      setConnectionStatus("connected");
      setReconnectAttempts(0);
    };

    ws.current.onmessage = (event) => {
      const data = JSON.parse(event.data);
      setLastMessage(data);
    };

    ws.current.onclose = () => {
      setConnectionStatus("disconnected");

      // Exponential backoff reconnection
      if (reconnectAttempts < 5) {
        const delay = Math.pow(2, reconnectAttempts) * 1000;
        reconnectTimeoutRef.current = setTimeout(() => {
          setReconnectAttempts((prev) => prev + 1);
          connect();
        }, delay);
      }
    };
  }, [url, token, reconnectAttempts]);

  const sendMessage = useCallback((message: any) => {
    if (ws.current?.readyState === WebSocket.OPEN) {
      ws.current.send(JSON.stringify(message));
    }
  }, []);

  const reconnect = useCallback(() => {
    setReconnectAttempts(0);
    connect();
  }, [connect]);

  useEffect(() => {
    connect();

    return () => {
      if (reconnectTimeoutRef.current) {
        clearTimeout(reconnectTimeoutRef.current);
      }
      ws.current?.close();
    };
  }, [connect]);

  return { sendMessage, lastMessage, connectionStatus, reconnect };
};
```

### 2. Chat Component Integration

```typescript
const ChatWindow: React.FC<ChatWindowProps> = ({
  roomName,
  currentUser,
  targetUser,
}) => {
  const { sendMessage, lastMessage, connectionStatus } = useWebSocket(
    `ws://localhost:8000/ws/chat/${roomName}/`,
    getAuthToken()
  );
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [newMessage, setNewMessage] = useState("");
  const [isTyping, setIsTyping] = useState(false);
  const [partnerTyping, setPartnerTyping] = useState(false);

  // Handle incoming messages
  useEffect(() => {
    if (lastMessage) {
      switch (lastMessage.type) {
        case "chat_message":
          setMessages((prev) => [...prev, lastMessage.data]);
          break;
        case "typing_notification":
          if (lastMessage.data.user.id !== currentUser.id) {
            setPartnerTyping(lastMessage.data.is_typing);
          }
          break;
        case "message_status":
          updateMessageStatus(lastMessage.data);
          break;
      }
    }
  }, [lastMessage]);

  const handleSendMessage = () => {
    if (newMessage.trim()) {
      sendMessage({
        type: "send_message",
        data: {
          message: newMessage,
          sender_id: currentUser.id,
          receiver_id: targetUser.id,
          message_type: "text",
        },
      });
      setNewMessage("");
    }
  };

  const handleTyping = (isTyping: boolean) => {
    setIsTyping(isTyping);
    sendMessage({
      type: isTyping ? "typing_start" : "typing_stop",
      data: {
        sender_id: currentUser.id,
        receiver_id: targetUser.id,
      },
    });
  };

  return (
    <div className="chat-window">
      <div className="connection-status">Status: {connectionStatus}</div>

      <div className="messages-container">
        {messages.map((message) => (
          <MessageBubble key={message.id} message={message} />
        ))}
        {partnerTyping && <TypingIndicator user={targetUser} />}
      </div>

      <MessageInput
        value={newMessage}
        onChange={setNewMessage}
        onSend={handleSendMessage}
        onTyping={handleTyping}
        disabled={connectionStatus !== "connected"}
      />
    </div>
  );
};
```

### 3. Notification WebSocket Integration

```typescript
const NotificationManager: React.FC = () => {
  const { sendMessage, lastMessage } = useWebSocket(
    "ws://localhost:8000/ws/notifications/",
    getAuthToken()
  );
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);

  useEffect(() => {
    if (lastMessage) {
      switch (lastMessage.type) {
        case "new_notification":
          setNotifications((prev) => [lastMessage.data, ...prev]);
          setUnreadCount((prev) => prev + 1);
          showToastNotification(lastMessage.data);
          break;

        case "notification_read":
          markNotificationAsRead(lastMessage.data.notification_id);
          setUnreadCount((prev) => Math.max(0, prev - 1));
          break;

        case "unread_count_update":
          setUnreadCount(lastMessage.data.total_unread);
          break;
      }
    }
  }, [lastMessage]);

  const markAsRead = (notificationId: string) => {
    sendMessage({
      type: "mark_read",
      data: { notification_id: notificationId },
    });
  };

  return (
    <div className="notification-manager">
      <NotificationBadge count={unreadCount} />
      <NotificationList
        notifications={notifications}
        onMarkAsRead={markAsRead}
      />
    </div>
  );
};
```

## Testing Strategies

### 1. Unit Tests

```python
import pytest
from channels.testing import WebsocketCommunicator
from django.test import TransactionTestCase

class ChatConsumerTest(TransactionTestCase):
    async def test_chat_message_flow(self):
        # Create test users
        user1 = await self.create_test_user('user1')
        user2 = await self.create_test_user('user2')

        # Create communicator
        communicator = WebsocketCommunicator(
            ChatConsumer.as_asgi(),
            f'/ws/chat/{user1.id}_{user2.id}/?token={user1.token}'
        )

        # Test connection
        connected, subprotocol = await communicator.connect()
        assert connected

        # Test message sending
        await communicator.send_json_to({
            'type': 'send_message',
            'data': {
                'message': 'Hello',
                'sender_id': user1.id,
                'receiver_id': user2.id
            }
        })

        # Test message reception
        response = await communicator.receive_json_from()
        assert response['type'] == 'chat_message'
        assert response['data']['message'] == 'Hello'

        # Disconnect
        await communicator.disconnect()
```

### 2. Integration Tests

```python
class WebSocketIntegrationTest(TransactionTestCase):
    async def test_multi_user_chat(self):
        # Test multiple users in same room
        # Test message broadcasting
        # Test typing indicators
        # Test presence updates
        pass

    async def test_notification_delivery(self):
        # Test notification creation
        # Test real-time delivery
        # Test read status updates
        pass
```

### 3. Load Testing

```python
import asyncio
import websockets

async def load_test_websocket():
    """Simulate 100 concurrent connections"""
    connections = []

    for i in range(100):
        try:
            ws = await websockets.connect(
                f'ws://localhost:8000/ws/chat/test_room/?token={get_test_token()}'
            )
            connections.append(ws)
        except Exception as e:
            print(f"Connection {i} failed: {e}")

    # Send messages from all connections
    tasks = []
    for ws in connections:
        tasks.append(send_test_messages(ws))

    await asyncio.gather(*tasks)

    # Close all connections
    for ws in connections:
        await ws.close()
```

This comprehensive WebSocket documentation provides all the technical details needed for implementing real-time features in the MediConnect application, covering both chat and notification systems with complete integration examples and testing strategies.
