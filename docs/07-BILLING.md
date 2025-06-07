# BILLING API DOCUMENTATION

## Overview

The Billing API provides comprehensive financial management capabilities for MediConnect, handling invoicing, payments, credit accounts, and financial reporting. This module manages all aspects of medical service billing, payment processing, and financial analytics.

## Base URL

```
/api/billing/
```

## Authentication

All endpoints require authentication. Include the JWT token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

---

## API ENDPOINTS

### 1. PAYMENT METHODS MANAGEMENT

#### 1.1 List Payment Methods

**Endpoint:** `GET /api/billing/payment-methods/`  
**Description:** Retrieve list of available payment methods  
**Permissions:** Authenticated users (Admin/Doctor/Patient)

**Query Parameters:**

- `is_active` (boolean): Filter by active status
- `payment_type` (string): Filter by payment type (cash, card, transfer, insurance, credit)

**Response:**

```json
{
  "count": 5,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "name": "Efectivo",
      "payment_type": "cash",
      "is_active": true,
      "description": "Pago en efectivo",
      "created_at": "2024-01-15T10:00:00Z"
    }
  ]
}
```

#### 1.2 Create Payment Method

**Endpoint:** `POST /api/billing/payment-methods/`  
**Description:** Create new payment method  
**Permissions:** Admin/Doctor only

**Request Body:**

```json
{
  "name": "Tarjeta de Crédito",
  "payment_type": "card",
  "is_active": true,
  "description": "Pagos con tarjeta de crédito/débito"
}
```

#### 1.3 Update Payment Method

**Endpoint:** `PUT /api/billing/payment-methods/{id}/`  
**Description:** Update payment method  
**Permissions:** Admin/Doctor only

#### 1.4 Delete Payment Method

**Endpoint:** `DELETE /api/billing/payment-methods/{id}/`  
**Description:** Delete payment method  
**Permissions:** Admin only

---

### 2. INVOICE MANAGEMENT

#### 2.1 List Invoices

**Endpoint:** `GET /api/billing/invoices/`  
**Description:** Retrieve invoices based on user role  
**Permissions:** Authenticated users (filtered by role)

**Query Parameters:**

- `status` (string): Filter by status (draft, sent, paid, overdue, cancelled)
- `overdue` (boolean): Filter overdue invoices
- `patient` (int): Filter by patient ID
- `doctor` (int): Filter by doctor ID
- `clinic` (int): Filter by clinic ID
- `issue_date__gte` (date): Filter from date
- `issue_date__lte` (date): Filter to date

**Response:**

```json
{
  "count": 25,
  "next": "http://api/billing/invoices/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "invoice_number": "INV-2024-000001",
      "patient": 1,
      "patient_name": "Juan Pérez",
      "doctor": 2,
      "doctor_name": "Dr. María García",
      "clinic": 1,
      "clinic_name": "Clínica Central",
      "appointment": 15,
      "status": "sent",
      "subtotal": "150.00",
      "tax_amount": "27.00",
      "discount_amount": "0.00",
      "total_amount": "177.00",
      "issue_date": "2024-01-15",
      "due_date": "2024-01-30",
      "paid_date": null,
      "notes": "Consulta general + análisis",
      "is_overdue": false,
      "created_at": "2024-01-15T09:30:00Z",
      "updated_at": "2024-01-15T09:30:00Z",
      "items": [
        {
          "id": 1,
          "description": "Consulta médica general",
          "quantity": 1,
          "unit_price": "100.00",
          "total_price": "100.00"
        },
        {
          "id": 2,
          "description": "Análisis de sangre completo",
          "quantity": 1,
          "unit_price": "50.00",
          "total_price": "50.00"
        }
      ]
    }
  ]
}
```

#### 2.2 Create Invoice

**Endpoint:** `POST /api/billing/invoices/`  
**Description:** Create new invoice with items  
**Permissions:** Admin/Doctor only

**Request Body:**

```json
{
  "patient": 1,
  "doctor": 2,
  "appointment": 15,
  "clinic": 1,
  "subtotal": "150.00",
  "tax_amount": "27.00",
  "discount_amount": "0.00",
  "issue_date": "2024-01-15",
  "due_date": "2024-01-30",
  "notes": "Consulta general + análisis",
  "items": [
    {
      "description": "Consulta médica general",
      "quantity": 1,
      "unit_price": "100.00"
    },
    {
      "description": "Análisis de sangre completo",
      "quantity": 1,
      "unit_price": "50.00"
    }
  ]
}
```

#### 2.3 Get Invoice Details

**Endpoint:** `GET /api/billing/invoices/{id}/`  
**Description:** Retrieve specific invoice  
**Permissions:** Owner, assigned doctor, or admin

#### 2.4 Update Invoice

**Endpoint:** `PUT /api/billing/invoices/{id}/`  
**Description:** Update invoice (only draft status)  
**Permissions:** Admin/Doctor only

#### 2.5 Mark Invoice as Sent

**Endpoint:** `POST /api/billing/invoices/{id}/mark_as_sent/`  
**Description:** Change invoice status to sent  
**Permissions:** Admin/Doctor only

**Response:**

```json
{
  "status": "Factura marcada como enviada"
}
```

#### 2.6 Mark Invoice as Paid

**Endpoint:** `POST /api/billing/invoices/{id}/mark_as_paid/`  
**Description:** Manually mark invoice as paid  
**Permissions:** Admin/Doctor only

**Response:**

```json
{
  "status": "Factura marcada como pagada"
}
```

#### 2.7 List Overdue Invoices

**Endpoint:** `GET /api/billing/invoices/overdue/`  
**Description:** Get all overdue invoices  
**Permissions:** Admin/Doctor only

---

### 3. PAYMENT PROCESSING

#### 3.1 List Payments

**Endpoint:** `GET /api/billing/payments/`  
**Description:** Retrieve payments based on user role  
**Permissions:** Authenticated users (filtered by role)

**Query Parameters:**

- `status` (string): Filter by status (pending, processing, completed, failed, refunded)
- `payment_method` (int): Filter by payment method ID
- `invoice` (int): Filter by invoice ID
- `payment_date__gte` (date): Filter from date
- `payment_date__lte` (date): Filter to date

**Response:**

```json
{
  "count": 15,
  "results": [
    {
      "id": 1,
      "invoice": 1,
      "invoice_number": "INV-2024-000001",
      "patient": 1,
      "patient_name": "Juan Pérez",
      "payment_method": 1,
      "payment_method_name": "Tarjeta de Crédito",
      "amount": "177.00",
      "status": "completed",
      "transaction_id": "TXN123456789",
      "payment_date": "2024-01-16T14:30:00Z",
      "notes": "Pago completado exitosamente",
      "reference_number": "REF001",
      "created_at": "2024-01-16T14:25:00Z",
      "updated_at": "2024-01-16T14:30:00Z"
    }
  ]
}
```

#### 3.2 Create Payment

**Endpoint:** `POST /api/billing/payments/`  
**Description:** Process new payment  
**Permissions:** Admin/Doctor/Patient (filtered by role)

**Request Body:**

```json
{
  "invoice": 1,
  "patient": 1,
  "payment_method": 1,
  "amount": "177.00",
  "transaction_id": "TXN123456789",
  "reference_number": "REF001",
  "notes": "Pago con tarjeta"
}
```

**Validation Rules:**

- Amount cannot exceed invoice remaining balance
- Invoice must exist and be payable
- Payment method must be active

#### 3.3 Confirm Payment

**Endpoint:** `POST /api/billing/payments/{id}/confirm/`  
**Description:** Confirm pending payment  
**Permissions:** Admin/Doctor only

**Response:**

```json
{
  "status": "Pago confirmado"
}
```

**Business Logic:**

- Changes payment status to 'completed'
- Updates invoice status to 'paid' if fully paid
- Sets invoice paid_date

---

### 4. PATIENT CREDIT ACCOUNTS

#### 4.1 List Credit Accounts

**Endpoint:** `GET /api/billing/credit-accounts/`  
**Description:** Retrieve patient credit accounts  
**Permissions:** Admin/Doctor only

**Response:**

```json
{
  "count": 5,
  "results": [
    {
      "id": 1,
      "patient": 1,
      "patient_name": "Juan Pérez",
      "credit_limit": "1000.00",
      "current_balance": "250.00",
      "available_credit": "750.00",
      "is_over_limit": false,
      "is_active": true,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

#### 4.2 Create Credit Account

**Endpoint:** `POST /api/billing/credit-accounts/`  
**Description:** Create credit account for patient  
**Permissions:** Admin only

**Request Body:**

```json
{
  "patient": 1,
  "credit_limit": "1000.00",
  "is_active": true
}
```

#### 4.3 Add Credit

**Endpoint:** `POST /api/billing/credit-accounts/{id}/add_credit/`  
**Description:** Add credit to patient account  
**Permissions:** Admin/Doctor only

**Request Body:**

```json
{
  "amount": "200.00"
}
```

**Response:**

```json
{
  "status": "Crédito agregado",
  "new_balance": "450.00"
}
```

---

### 5. BILLING REPORTS

#### 5.1 List Reports

**Endpoint:** `GET /api/billing/reports/`  
**Description:** Retrieve billing reports  
**Permissions:** Admin/Doctor only (filtered by clinic)

**Response:**

```json
{
  "count": 10,
  "results": [
    {
      "id": 1,
      "clinic": 1,
      "clinic_name": "Clínica Central",
      "doctor": 2,
      "doctor_name": "Dr. María García",
      "report_type": "monthly",
      "start_date": "2024-01-01",
      "end_date": "2024-01-31",
      "total_invoices": 45,
      "total_revenue": "12500.00",
      "paid_amount": "10200.00",
      "pending_amount": "2300.00",
      "generated_at": "2024-02-01T09:00:00Z"
    }
  ]
}
```

#### 5.2 Generate Report

**Endpoint:** `POST /api/billing/reports/generate_report/`  
**Description:** Generate billing report  
**Permissions:** Admin/Doctor only

**Request Body:**

```json
{
  "report_type": "monthly",
  "start_date": "2024-01-01",
  "end_date": "2024-01-31",
  "clinic_id": 1
}
```

**Response:**

```json
{
  "id": 2,
  "report_type": "monthly",
  "period": "2024-01-01 to 2024-01-31",
  "total_invoices": 45,
  "total_revenue": "12500.00",
  "pending_amount": "2300.00",
  "overdue_amount": "800.00",
  "collection_rate": 0.816,
  "payment_methods": [
    {
      "payment_method__name": "Tarjeta de Crédito",
      "total": "6200.00",
      "count": 28
    },
    {
      "payment_method__name": "Efectivo",
      "total": "3100.00",
      "count": 15
    }
  ],
  "top_services": [
    {
      "items__description": "Consulta general",
      "revenue": "4500.00",
      "count": 45
    }
  ]
}
```

#### 5.3 Summary Dashboard

**Endpoint:** `GET /api/billing/reports/summary_dashboard/`  
**Description:** Get billing dashboard summary  
**Permissions:** Admin/Doctor only

**Response:**

```json
{
  "monthly_revenue": 12500.0,
  "pending_invoices": 15,
  "overdue_invoices": 5,
  "monthly_trends": [
    {
      "month": "2023-08",
      "revenue": 8500.0
    },
    {
      "month": "2023-09",
      "revenue": 9200.0
    },
    {
      "month": "2023-10",
      "revenue": 10100.0
    },
    {
      "month": "2023-11",
      "revenue": 11300.0
    },
    {
      "month": "2023-12",
      "revenue": 11800.0
    },
    {
      "month": "2024-01",
      "revenue": 12500.0
    }
  ],
  "collection_rate": 0.816,
  "top_payment_methods": [
    {
      "payment_method__name": "Tarjeta de Crédito",
      "total": "6200.00",
      "count": 28
    }
  ]
}
```

---

### 6. DASHBOARD ENDPOINTS

#### 6.1 Billing Dashboard (Doctors)

**Endpoint:** `GET /api/billing/dashboard/`  
**Description:** Financial dashboard for doctors  
**Permissions:** Admin/Doctor only

**Response:**

```json
{
  "total_revenue_today": "850.00",
  "total_revenue_month": "12500.00",
  "pending_payments": "2300.00",
  "overdue_invoices_count": 5,
  "recent_payments": [
    {
      "id": 15,
      "amount": "200.00",
      "payment_method_name": "Tarjeta",
      "patient_name": "Ana López",
      "payment_date": "2024-01-16T15:30:00Z"
    }
  ],
  "top_payment_methods": [
    {
      "payment_method__name": "Tarjeta de Crédito",
      "count": 28,
      "total_amount": "6200.00"
    }
  ],
  "monthly_revenue_trend": [
    {
      "month": "2023-08",
      "revenue": "8500.00"
    }
  ]
}
```

#### 6.2 Patient Billing Info

**Endpoint:** `GET /api/billing/patient-info/`  
**Description:** Billing information for patients  
**Permissions:** Patient/Admin only

**Response:**

```json
{
  "total_invoices": 8,
  "total_amount_due": "450.00",
  "overdue_amount": "150.00",
  "recent_invoices": [
    {
      "id": 25,
      "invoice_number": "INV-2024-000025",
      "total_amount": "200.00",
      "status": "sent",
      "due_date": "2024-01-25",
      "is_overdue": false
    }
  ],
  "recent_payments": [
    {
      "id": 18,
      "amount": "300.00",
      "payment_method_name": "Efectivo",
      "payment_date": "2024-01-10T11:00:00Z",
      "status": "completed"
    }
  ],
  "credit_account": {
    "credit_limit": "1000.00",
    "current_balance": "250.00",
    "available_credit": "750.00",
    "is_over_limit": false
  }
}
```

---

## PERMISSION MATRIX

| Endpoint            | Admin    | Doctor          | Patient           |
| ------------------- | -------- | --------------- | ----------------- |
| **Payment Methods** |          |                 |                   |
| List                | ✅       | ✅              | ✅                |
| Create              | ✅       | ✅              | ❌                |
| Update              | ✅       | ✅              | ❌                |
| Delete              | ✅       | ❌              | ❌                |
| **Invoices**        |          |                 |                   |
| List                | ✅ (all) | ✅ (clinic/own) | ✅ (own)          |
| Create              | ✅       | ✅              | ❌                |
| View Details        | ✅       | ✅ (authorized) | ✅ (own)          |
| Update              | ✅       | ✅ (own clinic) | ❌                |
| Mark as Sent/Paid   | ✅       | ✅              | ❌                |
| **Payments**        |          |                 |                   |
| List                | ✅ (all) | ✅ (clinic)     | ✅ (own)          |
| Create              | ✅       | ✅              | ✅ (own invoices) |
| Confirm             | ✅       | ✅              | ❌                |
| **Credit Accounts** |          |                 |                   |
| List                | ✅       | ✅              | ❌                |
| Create              | ✅       | ❌              | ❌                |
| Add Credit          | ✅       | ✅              | ❌                |
| **Reports**         |          |                 |                   |
| List                | ✅ (all) | ✅ (clinic)     | ❌                |
| Generate            | ✅       | ✅              | ❌                |
| Dashboard           | ✅       | ✅              | ❌                |
| **Patient Info**    |          |                 |                   |
| View Billing Info   | ✅       | ❌              | ✅ (own)          |

---

## ERROR CODES

| Code        | Description                            | HTTP Status |
| ----------- | -------------------------------------- | ----------- |
| BILLING_001 | Invoice not found                      | 404         |
| BILLING_002 | Payment amount exceeds invoice balance | 400         |
| BILLING_003 | Invalid payment method                 | 400         |
| BILLING_004 | Invoice already paid                   | 400         |
| BILLING_005 | Credit limit exceeded                  | 400         |
| BILLING_006 | Invalid date range for report          | 400         |
| BILLING_007 | Insufficient permissions               | 403         |
| BILLING_008 | Payment processing failed              | 400         |
| BILLING_009 | Invoice cannot be modified             | 400         |
| BILLING_010 | Credit account not found               | 404         |

**Error Response Format:**

```json
{
  "error": "BILLING_002",
  "message": "Payment amount exceeds invoice balance",
  "details": {
    "invoice_balance": "150.00",
    "payment_amount": "200.00"
  }
}
```

---

## BUSINESS LOGIC

### Invoice Generation

1. **Auto-numbering**: Invoice numbers are automatically generated as `INV-YYYY-XXXXXX`
2. **Total calculation**: `total = subtotal + tax_amount - discount_amount`
3. **Status workflow**: draft → sent → paid/overdue
4. **Overdue detection**: Invoices past due_date with unpaid status

### Payment Processing

1. **Balance validation**: Payments cannot exceed remaining invoice balance
2. **Status updates**: Successful payments mark invoices as paid when fully covered
3. **Partial payments**: Multiple payments allowed per invoice
4. **Transaction tracking**: Each payment gets unique transaction_id

### Credit Management

1. **Credit limits**: Patients can have credit accounts with spending limits
2. **Balance tracking**: Current balance tracks outstanding credit usage
3. **Overlimit protection**: System prevents credit usage beyond limits
4. **Credit adjustments**: Admins can add/remove credit

### Financial Reporting

1. **Automated calculations**: Reports auto-calculate revenue, collection rates
2. **Period filtering**: Reports can be generated for custom date ranges
3. **Clinic segmentation**: Multi-clinic support with proper data isolation
4. **Performance metrics**: Collection rates, payment method analysis

---

## INTEGRATION POINTS

### With Appointments Module

- **Invoice creation**: Invoices can be linked to specific appointments
- **Service billing**: Appointment services become invoice items
- **Fee synchronization**: Appointment fees populate invoice amounts

### With Users Module

- **Patient billing**: Patient-specific invoice and payment history
- **Doctor assignments**: Invoices linked to treating doctors
- **Clinic filtering**: Multi-clinic billing separation

### With Analytics Module

- **Financial metrics**: Billing data feeds into analytics reports
- **Revenue tracking**: Payment data for financial analysis
- **Performance indicators**: Collection rates and payment patterns

---

## FRONTEND IMPLEMENTATION GUIDELINES

### Invoice Management UI

```javascript
// Invoice creation with items
const createInvoice = async (invoiceData) => {
  const response = await fetch("/api/billing/invoices/", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      patient: patientId,
      doctor: doctorId,
      clinic: clinicId,
      items: [
        {
          description: "Consulta médica",
          quantity: 1,
          unit_price: "100.00",
        },
      ],
      // ... other fields
    }),
  });
  return response.json();
};
```

### Payment Processing

```javascript
// Process patient payment
const processPayment = async (paymentData) => {
  const response = await fetch("/api/billing/payments/", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      invoice: invoiceId,
      payment_method: paymentMethodId,
      amount: paymentAmount,
      transaction_id: transactionId,
    }),
  });

  if (response.ok) {
    // Payment successful - update UI
    await refreshInvoiceStatus();
  }

  return response.json();
};
```

### Dashboard Implementation

```javascript
// Load billing dashboard
const loadBillingDashboard = async () => {
  const response = await fetch("/api/billing/dashboard/", {
    headers: { Authorization: `Bearer ${token}` },
  });

  const data = await response.json();

  // Update dashboard components
  updateRevenueMetrics(data.total_revenue_month);
  updatePendingPayments(data.pending_payments);
  updateRecentPayments(data.recent_payments);
  updateRevenueTrend(data.monthly_revenue_trend);
};
```

### Patient Billing Portal

```javascript
// Patient billing information
const loadPatientBilling = async () => {
  const response = await fetch("/api/billing/patient-info/", {
    headers: { Authorization: `Bearer ${token}` },
  });

  const data = await response.json();

  // Display patient billing info
  displayOutstandingInvoices(data.recent_invoices);
  displayPaymentHistory(data.recent_payments);
  displayCreditAccount(data.credit_account);
};
```

### Report Generation

```javascript
// Generate billing report
const generateReport = async (reportParams) => {
  const response = await fetch("/api/billing/reports/generate_report/", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      report_type: "monthly",
      start_date: "2024-01-01",
      end_date: "2024-01-31",
      clinic_id: clinicId,
    }),
  });

  const report = await response.json();

  // Display report data
  displayReportMetrics(report);
  generateReportCharts(report.payment_methods, report.top_services);
};
```

---

## SEARCH AND FILTERING

### Invoice Filtering

- **Status-based**: Filter by draft, sent, paid, overdue, cancelled
- **Date ranges**: Issue date, due date, payment date filtering
- **User-based**: Filter by patient, doctor, clinic
- **Amount ranges**: Min/max total amount filtering
- **Overdue flag**: Quick filter for overdue invoices

### Payment Search

- **Status filtering**: pending, completed, failed payments
- **Method filtering**: Filter by payment method type
- **Date ranges**: Payment date filtering
- **Transaction search**: Search by transaction ID or reference number

### Report Filtering

- **Period selection**: Daily, weekly, monthly, yearly, custom ranges
- **Clinic filtering**: Multi-clinic report segmentation
- **Doctor filtering**: Individual doctor performance reports
- **Service analysis**: Revenue by service type

---

## WEBHOOKS AND REAL-TIME UPDATES

### Payment Status Updates

```javascript
// WebSocket connection for payment updates
const paymentSocket = new WebSocket(`ws://api/billing/payments/status/`);

paymentSocket.onmessage = (event) => {
  const data = JSON.parse(event.data);

  if (data.type === "payment_confirmed") {
    // Update payment status in UI
    updatePaymentStatus(data.payment_id, "completed");

    // Refresh invoice if fully paid
    if (data.invoice_fully_paid) {
      updateInvoiceStatus(data.invoice_id, "paid");
    }
  }
};
```

### Invoice Status Changes

```javascript
// Real-time invoice updates
const invoiceSocket = new WebSocket(`ws://api/billing/invoices/updates/`);

invoiceSocket.onmessage = (event) => {
  const data = JSON.parse(event.data);

  switch (data.type) {
    case "invoice_sent":
      updateInvoiceStatus(data.invoice_id, "sent");
      break;
    case "invoice_paid":
      updateInvoiceStatus(data.invoice_id, "paid");
      break;
    case "invoice_overdue":
      markInvoiceOverdue(data.invoice_id);
      break;
  }
};
```

This comprehensive billing documentation provides all the necessary information for frontend developers to implement a complete financial management interface for MediConnect, including invoice generation, payment processing, credit management, and financial reporting capabilities.
