# DASHBOARDS Module API Documentation

## Overview

The DASHBOARDS module provides comprehensive data visualization and summary interfaces for all user roles in the MediConnect healthcare platform. It aggregates data from multiple modules to present role-specific insights, KPIs, and actionable information through unified dashboard endpoints.

### Key Features

- **Role-Based Dashboards**: Customized views for Admin, Doctor, Patient, and Clinic Staff
- **Real-Time Metrics**: Live updates of critical performance indicators
- **Multi-Dimensional Analytics**: Combining appointment, billing, patient, and operational data
- **Trend Analysis**: Historical data visualization and pattern recognition
- **Actionable Insights**: AI-generated recommendations and alerts
- **Performance Monitoring**: KPI tracking and goal achievement indicators
- **Data Aggregation**: Consolidated views from all platform modules

## Dashboard Types

### 1. Doctor Dashboard

**Primary Focus**: Individual practitioner performance and patient management
**Key Metrics**: Appointments, patient statistics, revenue, efficiency indicators
**Update Frequency**: Real-time for appointments, daily for analytics

### 2. Patient Dashboard

**Primary Focus**: Personal health management and upcoming care
**Key Metrics**: Appointments, medical records, treatment progress, billing status
**Update Frequency**: Real-time for appointments and messages

### 3. Clinic Dashboard

**Primary Focus**: Operational oversight and clinic-wide performance
**Key Metrics**: Multi-doctor statistics, resource utilization, revenue tracking
**Update Frequency**: Real-time for operations, hourly for analytics

### 4. Admin Dashboard

**Primary Focus**: System-wide monitoring and management
**Key Metrics**: Platform usage, user management, system health, global analytics
**Update Frequency**: Real-time for critical metrics

### 5. Billing Dashboard

**Primary Focus**: Financial performance and payment tracking
**Key Metrics**: Revenue, payment methods, outstanding invoices, financial trends
**Update Frequency**: Real-time for payments, daily for reports

### 6. Analytics Dashboard

**Primary Focus**: Advanced data insights and predictive analytics
**Key Metrics**: Behavioral patterns, performance trends, predictive insights
**Update Frequency**: Daily batch processing with real-time overlays

## API Endpoints

### 1. Doctor Dashboard

#### GET /api/dashboard/doctor/

**Description**: Comprehensive dashboard for individual doctors
**Permission**: Authenticated doctors only
**User Roles**: Doctor

**Response Structure**:

```json
{
  "doctor_info": {
    "id": 123,
    "name": "Dr. Sarah Johnson",
    "specialization": "Cardiology",
    "license_number": "MD12345",
    "clinic_affiliations": [
      {
        "clinic_id": 1,
        "clinic_name": "Downtown Medical Center",
        "role": "attending",
        "is_primary": true
      }
    ]
  },
  "today_metrics": {
    "date": "2024-01-15",
    "appointments": {
      "total": 8,
      "completed": 5,
      "upcoming": 2,
      "cancelled": 1,
      "no_show": 0
    },
    "patients": {
      "new": 2,
      "returning": 6,
      "total_seen": 5
    },
    "revenue": {
      "generated": "1250.00",
      "target": "1500.00",
      "achievement_rate": 0.83
    },
    "efficiency": {
      "avg_appointment_duration": 25.5,
      "on_time_percentage": 87.5,
      "patient_wait_time": 8.2
    }
  },
  "weekly_summary": {
    "period": "2024-01-08 to 2024-01-14",
    "appointments": {
      "total": 45,
      "completion_rate": 0.91,
      "cancellation_rate": 0.07,
      "no_show_rate": 0.02
    },
    "patient_metrics": {
      "total_patients": 38,
      "new_patients": 8,
      "retention_rate": 0.89,
      "satisfaction_avg": 4.6
    },
    "revenue": {
      "weekly_total": "6750.00",
      "avg_per_appointment": "150.00",
      "insurance_vs_private": {
        "insurance": 0.65,
        "private": 0.35
      }
    }
  },
  "monthly_trends": {
    "current_month": "2024-01",
    "appointments": [
      {
        "week": 1,
        "total": 42,
        "completed": 38,
        "revenue": "5700.00"
      },
      {
        "week": 2,
        "total": 45,
        "completed": 41,
        "revenue": "6150.00"
      }
    ],
    "patient_growth": {
      "new_patients": 15,
      "vs_last_month": 0.12,
      "trend": "increasing"
    },
    "performance_indicators": {
      "punctuality": 0.89,
      "documentation_completeness": 0.94,
      "follow_up_compliance": 0.87
    }
  },
  "upcoming_appointments": [
    {
      "id": 456,
      "patient": {
        "id": 789,
        "name": "John Doe",
        "age": 45,
        "last_visit": "2023-12-15",
        "condition": "Hypertension"
      },
      "scheduled_time": "2024-01-15T14:30:00Z",
      "type": "follow_up",
      "duration_minutes": 30,
      "notes": "Blood pressure check",
      "preparation_required": ["Recent labs", "Blood pressure log"]
    }
  ],
  "patient_alerts": [
    {
      "type": "overdue_followup",
      "patient_id": 234,
      "patient_name": "Jane Smith",
      "message": "Follow-up overdue by 2 weeks",
      "priority": "high",
      "last_visit": "2023-12-01"
    },
    {
      "type": "medication_interaction",
      "patient_id": 567,
      "patient_name": "Bob Wilson",
      "message": "Potential drug interaction detected",
      "priority": "critical",
      "medications": ["Warfarin", "Aspirin"]
    }
  ],
  "performance_insights": [
    {
      "category": "efficiency",
      "insight": "Your average appointment duration decreased by 3 minutes this week",
      "impact": "positive",
      "recommendation": "Continue current time management practices"
    },
    {
      "category": "satisfaction",
      "insight": "Patient satisfaction increased to 4.6/5.0",
      "impact": "positive",
      "recommendation": "Consider sharing best practices with colleagues"
    }
  ],
  "quick_actions": [
    {
      "action": "view_schedule",
      "label": "Today's Schedule",
      "url": "/appointments/today",
      "count": 8
    },
    {
      "action": "pending_results",
      "label": "Pending Lab Results",
      "url": "/lab-results/pending",
      "count": 3
    },
    {
      "action": "messages",
      "label": "Unread Messages",
      "url": "/messages",
      "count": 5
    }
  ]
}
```

#### GET /api/dashboard/doctor/analytics/

**Description**: Advanced analytics dashboard for doctors
**Permission**: Authenticated doctors only
**Query Parameters**:

```json
{
  "period": "day|week|month|quarter|year",
  "start_date": "date (optional)",
  "end_date": "date (optional)",
  "clinic_id": "integer (optional)",
  "comparison": "boolean (compare with previous period)"
}
```

### 2. Patient Dashboard

#### GET /api/dashboard/patient/

**Description**: Personal health dashboard for patients
**Permission**: Authenticated patients only
**User Roles**: Patient

**Response Structure**:

```json
{
  "patient_info": {
    "id": 789,
    "name": "John Doe",
    "age": 45,
    "date_of_birth": "1979-03-15",
    "primary_doctor": {
      "id": 123,
      "name": "Dr. Sarah Johnson",
      "specialization": "Cardiology",
      "next_available": "2024-01-20T10:00:00Z"
    },
    "insurance_info": {
      "provider": "HealthCare Plus",
      "policy_number": "HP123456789",
      "coverage_status": "active"
    }
  },
  "health_summary": {
    "current_conditions": [
      {
        "condition": "Hypertension",
        "diagnosed_date": "2023-06-15",
        "status": "managed",
        "last_reading": {
          "value": "130/85",
          "date": "2024-01-10",
          "status": "improving"
        }
      }
    ],
    "vital_signs": {
      "last_updated": "2024-01-10T09:30:00Z",
      "blood_pressure": "130/85",
      "heart_rate": 72,
      "weight": "185 lbs",
      "temperature": "98.6°F"
    },
    "allergies": [
      {
        "allergen": "Penicillin",
        "severity": "severe",
        "reaction": "Anaphylaxis"
      }
    ]
  },
  "upcoming_care": {
    "next_appointment": {
      "id": 456,
      "doctor": "Dr. Sarah Johnson",
      "date": "2024-01-20T10:00:00Z",
      "type": "follow_up",
      "location": "Downtown Medical Center",
      "preparation": [
        "Bring blood pressure log",
        "List current medications",
        "Fasting for blood work"
      ],
      "estimated_duration": 30
    },
    "upcoming_appointments": [
      {
        "id": 457,
        "doctor": "Dr. Michael Chen",
        "specialty": "Ophthalmology",
        "date": "2024-02-05T14:00:00Z",
        "type": "routine_checkup"
      }
    ],
    "scheduled_tests": [
      {
        "test_name": "Annual Blood Panel",
        "scheduled_date": "2024-01-18T08:00:00Z",
        "location": "Lab Services Center",
        "fasting_required": true,
        "preparation_time": "12 hours"
      }
    ]
  },
  "medications": {
    "current": [
      {
        "name": "Lisinopril",
        "dosage": "10mg",
        "frequency": "Once daily",
        "prescribed_date": "2023-06-15",
        "prescribing_doctor": "Dr. Sarah Johnson",
        "next_refill": "2024-01-25",
        "remaining_doses": 15
      }
    ],
    "reminders": [
      {
        "medication": "Lisinopril",
        "next_dose": "2024-01-15T08:00:00Z",
        "missed_doses": 0
      }
    ]
  },
  "recent_activity": {
    "appointments": [
      {
        "date": "2024-01-10T10:00:00Z",
        "doctor": "Dr. Sarah Johnson",
        "type": "follow_up",
        "summary": "Blood pressure check - improving",
        "action_items": ["Continue current medication", "Daily BP monitoring"]
      }
    ],
    "test_results": [
      {
        "test_name": "Lipid Panel",
        "date": "2024-01-08T09:00:00Z",
        "status": "completed",
        "results_available": true,
        "summary": "Cholesterol levels within normal range",
        "view_url": "/medical-records/tests/789"
      }
    ],
    "messages": [
      {
        "from": "Dr. Sarah Johnson",
        "date": "2024-01-12T15:30:00Z",
        "subject": "Blood Pressure Update",
        "preview": "Your recent readings show good improvement...",
        "is_read": false
      }
    ]
  },
  "health_goals": [
    {
      "goal": "Blood Pressure Control",
      "target": "< 130/80",
      "current": "130/85",
      "progress": 0.75,
      "deadline": "2024-03-15",
      "actions": [
        "Take medication daily",
        "Exercise 30 min, 3x/week",
        "Reduce sodium intake"
      ]
    }
  ],
  "billing_summary": {
    "outstanding_balance": "125.00",
    "recent_charges": [
      {
        "date": "2024-01-10",
        "description": "Office Visit - Follow Up",
        "amount": "150.00",
        "insurance_covered": "125.00",
        "patient_responsibility": "25.00"
      }
    ],
    "payment_due_date": "2024-02-10",
    "auto_pay_enabled": true
  },
  "quick_actions": [
    {
      "action": "book_appointment",
      "label": "Schedule Appointment",
      "url": "/appointments/book",
      "available": true
    },
    {
      "action": "request_prescription",
      "label": "Request Prescription Refill",
      "url": "/prescriptions/refill",
      "urgent_needed": 2
    },
    {
      "action": "view_results",
      "label": "View Test Results",
      "url": "/medical-records/results",
      "new_results": 1
    },
    {
      "action": "message_doctor",
      "label": "Message Doctor",
      "url": "/messages/compose",
      "unread_count": 1
    }
  ]
}
```

### 3. Clinic Dashboard

#### GET /api/clinics/{clinic_id}/dashboard/

**Description**: Comprehensive operational dashboard for clinic management
**Permission**: Admin, Doctor (if affiliated), Clinic Staff
**User Roles**: Admin, Doctor, Clinic Staff

**Response Structure**:

```json
{
  "clinic_info": {
    "id": 1,
    "name": "Downtown Medical Center",
    "location": "123 Main St, City, State",
    "established": "2015-03-01",
    "status": "active",
    "accreditation": "JCI Accredited",
    "total_staff": 45,
    "total_doctors": 12,
    "departments": 8
  },
  "operational_metrics": {
    "today": {
      "date": "2024-01-15",
      "appointments": {
        "total_scheduled": 85,
        "completed": 62,
        "in_progress": 8,
        "cancelled": 6,
        "no_show": 3,
        "completion_rate": 0.91
      },
      "patient_flow": {
        "total_patients": 78,
        "new_patients": 12,
        "returning_patients": 66,
        "average_wait_time": 15.5,
        "patient_satisfaction": 4.4
      },
      "resource_utilization": {
        "examination_rooms": {
          "total": 15,
          "occupied": 8,
          "utilization_rate": 0.53
        },
        "equipment": {
          "ecg_machines": 0.75,
          "ultrasound": 0.6,
          "xray": 0.45
        }
      },
      "staff_metrics": {
        "doctors_on_duty": 8,
        "nurses_on_duty": 12,
        "support_staff": 6,
        "efficiency_score": 8.2
      }
    },
    "weekly_performance": {
      "period": "2024-01-08 to 2024-01-14",
      "appointments": {
        "total": 425,
        "completion_rate": 0.89,
        "average_per_day": 85,
        "peak_day": "Wednesday",
        "peak_time": "10:00-12:00"
      },
      "revenue": {
        "total": "63750.00",
        "daily_average": "12750.00",
        "vs_target": 1.05,
        "trend": "increasing"
      },
      "patient_metrics": {
        "unique_patients": 320,
        "new_patients": 58,
        "retention_rate": 0.87,
        "satisfaction_score": 4.3
      }
    }
  },
  "financial_summary": {
    "revenue": {
      "today": "12500.00",
      "week": "63750.00",
      "month": "245000.00",
      "year_to_date": "245000.00"
    },
    "billing": {
      "outstanding_invoices": 125,
      "total_outstanding": "45000.00",
      "collection_rate": 0.92,
      "average_collection_time": 18.5
    },
    "payment_methods": [
      {
        "method": "Insurance",
        "percentage": 0.65,
        "amount": "159250.00"
      },
      {
        "method": "Credit Card",
        "percentage": 0.25,
        "amount": "61250.00"
      },
      {
        "method": "Cash",
        "percentage": 0.1,
        "amount": "24500.00"
      }
    ]
  },
  "doctor_performance": [
    {
      "doctor_id": 123,
      "name": "Dr. Sarah Johnson",
      "specialization": "Cardiology",
      "appointments": {
        "today": 8,
        "week": 45,
        "completion_rate": 0.96
      },
      "patient_metrics": {
        "satisfaction": 4.7,
        "retention": 0.91
      },
      "revenue": {
        "week": "6750.00",
        "avg_per_appointment": "150.00"
      },
      "efficiency": {
        "punctuality": 0.92,
        "documentation": 0.95
      }
    }
  ],
  "department_metrics": [
    {
      "department": "Cardiology",
      "appointments": {
        "today": 25,
        "week": 125,
        "month": 480
      },
      "revenue": {
        "week": "18750.00",
        "percentage_of_total": 0.29
      },
      "utilization": 0.87,
      "wait_times": {
        "average": 12.5,
        "target": 15.0
      }
    }
  ],
  "alerts_and_notifications": [
    {
      "type": "capacity",
      "severity": "medium",
      "message": "Cardiology department at 90% capacity",
      "recommendation": "Consider scheduling overflow to other time slots"
    },
    {
      "type": "equipment",
      "severity": "high",
      "message": "X-ray machine #2 requires maintenance",
      "action_required": "Schedule maintenance within 24 hours"
    },
    {
      "type": "staffing",
      "severity": "low",
      "message": "Nurse shortage expected next Tuesday",
      "recommendation": "Consider temporary staffing solutions"
    }
  ],
  "trends_and_insights": [
    {
      "category": "appointments",
      "insight": "15% increase in appointment volume vs last month",
      "impact": "positive",
      "recommendation": "Consider expanding hours or adding providers"
    },
    {
      "category": "satisfaction",
      "insight": "Patient satisfaction improved by 0.3 points",
      "impact": "positive",
      "recommendation": "Identify and replicate successful practices"
    }
  ],
  "upcoming_events": [
    {
      "type": "maintenance",
      "title": "HVAC System Maintenance",
      "date": "2024-01-20T06:00:00Z",
      "duration": "4 hours",
      "impact": "Minimal - backup systems available"
    },
    {
      "type": "staff",
      "title": "Nursing Education Session",
      "date": "2024-01-22T14:00:00Z",
      "attendees": 15,
      "impact": "Reduced afternoon capacity"
    }
  ]
}
```

### 4. Admin Dashboard

#### GET /api/dashboard/admin/

**Description**: System-wide administrative dashboard
**Permission**: Admin users only
**User Roles**: Admin

**Response Structure**:

```json
{
  "system_overview": {
    "platform_status": "operational",
    "uptime": "99.8%",
    "last_updated": "2024-01-15T10:30:00Z",
    "active_users": {
      "total": 1250,
      "online_now": 189,
      "doctors": 45,
      "patients": 1180,
      "staff": 25
    },
    "system_health": {
      "database_performance": "excellent",
      "api_response_time": "120ms",
      "error_rate": "0.02%",
      "storage_usage": "65%"
    }
  },
  "clinic_management": {
    "total_clinics": 8,
    "active_clinics": 7,
    "pending_verification": 1,
    "top_performing_clinics": [
      {
        "clinic_id": 1,
        "name": "Downtown Medical Center",
        "revenue_month": "245000.00",
        "appointments_month": 1250,
        "satisfaction_score": 4.5
      }
    ],
    "metrics_summary": {
      "total_appointments_today": 425,
      "total_patients": 8750,
      "total_doctors": 120,
      "system_revenue_month": "1850000.00"
    }
  },
  "user_analytics": {
    "registration_trends": [
      {
        "date": "2024-01-08",
        "new_patients": 25,
        "new_doctors": 2,
        "activations": 23
      }
    ],
    "engagement_metrics": {
      "daily_active_users": 892,
      "average_session_duration": "22 minutes",
      "feature_usage": {
        "appointments": 0.95,
        "messaging": 0.78,
        "billing": 0.65,
        "analytics": 0.42
      }
    },
    "geographic_distribution": [
      {
        "region": "North",
        "clinics": 3,
        "patients": 3200,
        "doctors": 45
      }
    ]
  },
  "financial_overview": {
    "subscription_revenue": {
      "monthly": "125000.00",
      "annual": "1500000.00",
      "growth_rate": 0.08
    },
    "transaction_fees": {
      "monthly": "18500.00",
      "total_processed": "2850000.00"
    },
    "payment_health": {
      "success_rate": 0.97,
      "failed_payments": 45,
      "chargeback_rate": 0.01
    }
  },
  "security_monitoring": {
    "login_attempts": {
      "successful": 2850,
      "failed": 45,
      "suspicious": 3,
      "blocked": 1
    },
    "data_protection": {
      "encryption_status": "active",
      "backup_status": "completed",
      "last_backup": "2024-01-15T02:00:00Z",
      "compliance_status": "HIPAA Compliant"
    },
    "security_incidents": [
      {
        "type": "failed_login_attempts",
        "count": 5,
        "source_ip": "192.168.1.100",
        "action_taken": "temporary_block"
      }
    ]
  },
  "support_metrics": {
    "tickets": {
      "open": 12,
      "in_progress": 8,
      "resolved_today": 15,
      "average_resolution_time": "4.2 hours"
    },
    "common_issues": [
      {
        "issue": "Password reset requests",
        "count": 25,
        "trend": "stable"
      },
      {
        "issue": "Appointment scheduling errors",
        "count": 8,
        "trend": "decreasing"
      }
    ]
  },
  "system_alerts": [
    {
      "type": "performance",
      "severity": "medium",
      "message": "Database query performance degraded by 15%",
      "recommendation": "Consider query optimization"
    },
    {
      "type": "capacity",
      "severity": "low",
      "message": "Storage usage reached 65%",
      "recommendation": "Plan for storage expansion"
    }
  ]
}
```

### 5. Billing Dashboard

#### GET /api/billing/dashboard/

**Description**: Financial performance dashboard
**Permission**: Admin, Doctor (own data), Billing Staff
**User Roles**: Admin, Doctor, Billing Staff

**Response Structure**:

```json
{
  "revenue_metrics": {
    "today": {
      "total": "12500.00",
      "target": "15000.00",
      "achievement": 0.83,
      "transactions": 45
    },
    "week": {
      "total": "67500.00",
      "vs_last_week": 0.12,
      "trend": "increasing"
    },
    "month": {
      "total": "245000.00",
      "vs_last_month": 0.08,
      "vs_target": 1.02
    },
    "year_to_date": {
      "total": "245000.00",
      "vs_last_year": 0.15,
      "projection": "2940000.00"
    }
  },
  "payment_analysis": {
    "collection_metrics": {
      "collection_rate": 0.92,
      "average_collection_time": 18.5,
      "outstanding_amount": "125000.00",
      "overdue_amount": "35000.00"
    },
    "payment_methods": [
      {
        "method": "Credit Card",
        "count": 285,
        "amount": "127500.00",
        "percentage": 0.52,
        "success_rate": 0.97
      },
      {
        "method": "Insurance",
        "count": 180,
        "amount": "108000.00",
        "percentage": 0.44,
        "processing_time": "7.5 days"
      }
    ],
    "failed_payments": {
      "count": 12,
      "total_amount": "3600.00",
      "common_reasons": [
        "Insufficient funds",
        "Expired card",
        "Invalid billing address"
      ]
    }
  },
  "invoice_management": {
    "invoice_status": {
      "draft": 25,
      "sent": 125,
      "paid": 450,
      "overdue": 35,
      "cancelled": 8
    },
    "aging_analysis": {
      "0_30_days": {
        "count": 125,
        "amount": "45000.00"
      },
      "31_60_days": {
        "count": 28,
        "amount": "12500.00"
      },
      "61_90_days": {
        "count": 15,
        "amount": "8500.00"
      },
      "over_90_days": {
        "count": 7,
        "amount": "4500.00"
      }
    },
    "automation_metrics": {
      "auto_generated": 0.85,
      "auto_sent": 0.92,
      "reminder_effectiveness": 0.68
    }
  },
  "patient_accounts": {
    "credit_accounts": {
      "total_accounts": 125,
      "total_credit": "25000.00",
      "average_balance": "200.00",
      "utilization_rate": 0.45
    },
    "payment_plans": {
      "active_plans": 45,
      "total_amount": "67500.00",
      "on_time_rate": 0.87,
      "default_rate": 0.03
    },
    "insurance_processing": {
      "claims_submitted": 285,
      "claims_approved": 265,
      "claims_denied": 12,
      "approval_rate": 0.93,
      "average_processing_time": "5.2 days"
    }
  },
  "financial_trends": [
    {
      "period": "2024-01-01",
      "revenue": "35000.00",
      "collections": "32000.00",
      "outstanding": "15000.00"
    },
    {
      "period": "2024-01-08",
      "revenue": "38500.00",
      "collections": "35000.00",
      "outstanding": "16500.00"
    }
  ],
  "alerts": [
    {
      "type": "overdue",
      "message": "15 invoices overdue by more than 30 days",
      "amount": "12500.00",
      "action": "Send collection notices"
    },
    {
      "type": "payment_failure",
      "message": "Credit card failure rate increased to 5%",
      "recommendation": "Review payment processor settings"
    }
  ],
  "reports_available": [
    {
      "name": "Monthly Revenue Report",
      "last_generated": "2024-01-01T09:00:00Z",
      "next_scheduled": "2024-02-01T09:00:00Z",
      "download_url": "/reports/monthly-revenue/2024-01"
    },
    {
      "name": "Aging Report",
      "last_generated": "2024-01-15T08:00:00Z",
      "next_scheduled": "2024-01-22T08:00:00Z",
      "download_url": "/reports/aging/2024-01-15"
    }
  ]
}
```

### 6. Analytics Dashboard

#### GET /api/analytics/dashboard/

**Description**: Advanced analytics and insights dashboard
**Permission**: Admin, Doctor (own data), Analytics Staff
**User Roles**: Admin, Doctor, Analytics Staff

**Query Parameters**:

```json
{
  "period": "day|week|month|quarter|year",
  "clinic_id": "integer (optional)",
  "department": "string (optional)",
  "metrics": "comma-separated list (optional)"
}
```

**Response Structure**:

```json
{
  "overview": {
    "analytics_period": "month",
    "data_freshness": "2024-01-15T10:30:00Z",
    "completeness": 0.98,
    "confidence_level": 0.95
  },
  "patient_analytics": {
    "behavior_insights": {
      "total_patients_analyzed": 8750,
      "engagement_score": {
        "average": 7.8,
        "trend": "increasing",
        "top_quartile": 9.2
      },
      "retention_metrics": {
        "overall_retention": 0.87,
        "new_patient_retention": 0.82,
        "at_risk_patients": 145,
        "churn_prediction": {
          "next_30_days": 23,
          "confidence": 0.89
        }
      },
      "satisfaction_analysis": {
        "average_score": 4.4,
        "response_rate": 0.68,
        "nps_score": 72,
        "improvement_areas": ["Wait times", "Communication", "Billing clarity"]
      }
    },
    "demographic_insights": {
      "age_distribution": [
        { "range": "18-30", "count": 1250, "percentage": 0.14 },
        { "range": "31-50", "count": 3500, "percentage": 0.4 },
        { "range": "51-70", "count": 3200, "percentage": 0.37 },
        { "range": "70+", "count": 800, "percentage": 0.09 }
      ],
      "geographic_patterns": [
        { "region": "Urban", "count": 6125, "avg_visit_frequency": 4.2 },
        { "region": "Suburban", "count": 2100, "avg_visit_frequency": 3.8 },
        { "region": "Rural", "count": 525, "avg_visit_frequency": 2.9 }
      ]
    }
  },
  "doctor_performance": {
    "overall_metrics": {
      "total_doctors": 120,
      "average_performance_score": 8.3,
      "top_performers": [
        {
          "doctor_id": 123,
          "name": "Dr. Sarah Johnson",
          "score": 9.4,
          "specialization": "Cardiology"
        }
      ],
      "improvement_opportunities": 8
    },
    "efficiency_analysis": {
      "appointment_efficiency": {
        "average_duration": 24.5,
        "on_time_percentage": 0.89,
        "utilization_rate": 0.85
      },
      "productivity_metrics": {
        "appointments_per_day": 12.5,
        "revenue_per_hour": "125.00",
        "patient_throughput": 0.92
      }
    },
    "quality_indicators": {
      "patient_satisfaction": 4.4,
      "clinical_outcomes": 0.91,
      "safety_metrics": {
        "incidents": 2,
        "near_misses": 5,
        "safety_score": 9.2
      }
    }
  },
  "operational_insights": {
    "capacity_analysis": {
      "average_utilization": 0.78,
      "peak_hours": [
        { "time": "09:00-11:00", "utilization": 0.95 },
        { "time": "14:00-16:00", "utilization": 0.88 }
      ],
      "capacity_recommendations": [
        "Add morning slots for pediatrics",
        "Extend afternoon hours for cardiology"
      ]
    },
    "resource_optimization": {
      "equipment_utilization": {
        "mri": 0.72,
        "ct_scan": 0.65,
        "ultrasound": 0.83,
        "ecg": 0.91
      },
      "room_efficiency": {
        "examination_rooms": 0.78,
        "procedure_rooms": 0.65,
        "consultation_rooms": 0.82
      }
    },
    "workflow_analysis": {
      "patient_flow_time": "45 minutes",
      "bottlenecks": [
        "Check-in process",
        "Lab result processing",
        "Insurance verification"
      ],
      "optimization_potential": "15% efficiency gain"
    }
  },
  "financial_analytics": {
    "revenue_insights": {
      "growth_rate": 0.08,
      "revenue_per_patient": "280.00",
      "profit_margins": {
        "by_service": [
          { "service": "Consultation", "margin": 0.65 },
          { "service": "Procedures", "margin": 0.45 },
          { "service": "Diagnostics", "margin": 0.72 }
        ]
      }
    },
    "cost_analysis": {
      "operational_costs": "125000.00",
      "cost_per_patient": "45.50",
      "efficiency_score": 8.2,
      "cost_optimization": [
        "Reduce administrative overhead",
        "Optimize supply chain"
      ]
    }
  },
  "predictive_insights": [
    {
      "type": "demand_forecast",
      "title": "Appointment Volume Prediction",
      "prediction": "15% increase in next 30 days",
      "confidence": 0.87,
      "recommendation": "Increase staffing during peak hours",
      "impact": "high"
    },
    {
      "type": "risk_assessment",
      "title": "Patient Churn Risk",
      "prediction": "23 patients at high churn risk",
      "confidence": 0.92,
      "recommendation": "Implement retention program",
      "impact": "medium"
    },
    {
      "type": "revenue_forecast",
      "title": "Monthly Revenue Projection",
      "prediction": "5% above target",
      "confidence": 0.84,
      "recommendation": "Maintain current strategies",
      "impact": "positive"
    }
  ],
  "custom_reports": [
    {
      "report_id": "custom_001",
      "name": "Cardiology Department Analysis",
      "last_run": "2024-01-15T08:00:00Z",
      "schedule": "weekly",
      "status": "completed"
    }
  ]
}
```

## Real-Time Features

### WebSocket Integration

#### Dashboard Updates

**WebSocket URL**: `ws://domain/ws/dashboard/{dashboard_type}/`
**Authentication**: JWT token required

**Message Types**:

```json
{
  "type": "metric_update",
  "data": {
    "metric_name": "today_appointments",
    "value": 85,
    "timestamp": "2024-01-15T10:30:00Z",
    "change": "+3"
  }
}
```

```json
{
  "type": "alert",
  "data": {
    "severity": "high",
    "message": "System capacity at 95%",
    "action_required": true,
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

### Live Data Refresh

#### Auto-refresh Configuration

```json
{
  "refresh_intervals": {
    "critical_metrics": "30 seconds",
    "standard_metrics": "2 minutes",
    "historical_data": "15 minutes",
    "analytics": "1 hour"
  },
  "manual_refresh": true,
  "pause_refresh": true
}
```

## Permission Matrix

| Dashboard Type          | Admin   | Doctor         | Patient | Clinic Staff    | Billing Staff |
| ----------------------- | ------- | -------------- | ------- | --------------- | ------------- |
| **Doctor Dashboard**    | ✓ (all) | ✓ (own)        | ✗       | ✗               | ✗             |
| **Patient Dashboard**   | ✓ (all) | ✓ (patients)   | ✓ (own) | ✓ (limited)     | ✗             |
| **Clinic Dashboard**    | ✓ (all) | ✓ (affiliated) | ✗       | ✓ (own clinic)  | ✗             |
| **Admin Dashboard**     | ✓       | ✗              | ✗       | ✗               | ✗             |
| **Billing Dashboard**   | ✓ (all) | ✓ (own data)   | ✗       | ✗               | ✓ (assigned)  |
| **Analytics Dashboard** | ✓ (all) | ✓ (own data)   | ✗       | ✓ (clinic data) | ✗             |

## Error Codes

| Code     | Message                     | Description                            | Resolution                       |
| -------- | --------------------------- | -------------------------------------- | -------------------------------- |
| DASH_001 | Dashboard not found         | Requested dashboard type doesn't exist | Check dashboard type parameter   |
| DASH_002 | Insufficient permissions    | User lacks access to dashboard         | Verify user role and permissions |
| DASH_003 | Data unavailable            | Required data not accessible           | Check data source connectivity   |
| DASH_004 | Invalid time period         | Requested period is invalid            | Use valid period format          |
| DASH_005 | Clinic not found            | Specified clinic doesn't exist         | Verify clinic ID                 |
| DASH_006 | User not associated         | User not linked to requested resource  | Check user associations          |
| DASH_007 | Analytics timeout           | Dashboard data processing timeout      | Retry or reduce data scope       |
| DASH_008 | Real-time connection failed | WebSocket connection error             | Check network and authentication |
| DASH_009 | Cache miss                  | Cached dashboard data expired          | Allow time for data refresh      |
| DASH_010 | Rate limit exceeded         | Too many dashboard requests            | Respect rate limits              |

## Performance Optimization

### Caching Strategy

#### Redis Cache Implementation

```python
cache_keys = {
    'doctor_dashboard': 'dash:doctor:{user_id}:{period}',
    'clinic_metrics': 'dash:clinic:{clinic_id}:metrics',
    'patient_summary': 'dash:patient:{patient_id}:summary',
    'analytics_data': 'dash:analytics:{type}:{period}'
}

cache_durations = {
    'real_time_metrics': 30,      # 30 seconds
    'hourly_summaries': 3600,     # 1 hour
    'daily_analytics': 86400,     # 24 hours
    'historical_trends': 604800   # 7 days
}
```

#### Smart Cache Invalidation

```python
invalidation_triggers = {
    'appointment_created': ['doctor_dashboard', 'clinic_metrics'],
    'payment_received': ['billing_dashboard', 'clinic_revenue'],
    'patient_registered': ['admin_dashboard', 'clinic_patients']
}
```

### Database Optimization

#### Optimized Queries

```sql
-- Doctor dashboard appointments
SELECT a.*, p.first_name, p.last_name
FROM appointments a
JOIN patients p ON a.patient_id = p.id
WHERE a.doctor_id = ? AND a.date = CURRENT_DATE
ORDER BY a.start_time;

-- Clinic performance metrics
SELECT
    COUNT(*) as total_appointments,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed,
    AVG(CASE WHEN status = 'completed' THEN duration_minutes END) as avg_duration
FROM appointments
WHERE clinic_id = ? AND date >= ?;
```

#### Materialized Views

```sql
-- Daily clinic statistics
CREATE MATERIALIZED VIEW daily_clinic_stats AS
SELECT
    clinic_id,
    date,
    COUNT(*) as appointment_count,
    SUM(revenue) as daily_revenue,
    COUNT(DISTINCT patient_id) as unique_patients
FROM appointments_with_revenue
GROUP BY clinic_id, date;
```

## Frontend Integration Examples

### 1. React Dashboard Components

#### Doctor Dashboard Component

```typescript
interface DoctorDashboardProps {
  doctorId: string;
  period?: "today" | "week" | "month";
}

const DoctorDashboard: React.FC<DoctorDashboardProps> = ({
  doctorId,
  period = "today",
}) => {
  const [dashboardData, setDashboardData] =
    useState<DoctorDashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [lastUpdated, setLastUpdated] = useState<Date>(new Date());

  // WebSocket for real-time updates
  const { lastMessage } = useWebSocket(
    `ws://localhost:8000/ws/dashboard/doctor/`
  );

  useEffect(() => {
    loadDashboard();
  }, [doctorId, period]);

  useEffect(() => {
    if (lastMessage) {
      handleRealTimeUpdate(lastMessage);
    }
  }, [lastMessage]);

  const loadDashboard = async () => {
    try {
      setLoading(true);
      const response = await fetch(`/api/dashboard/doctor/?period=${period}`, {
        headers: {
          Authorization: `Bearer ${getAuthToken()}`,
          "Content-Type": "application/json",
        },
      });

      if (!response.ok) {
        throw new Error("Failed to load dashboard");
      }

      const data = await response.json();
      setDashboardData(data);
      setLastUpdated(new Date());
    } catch (error) {
      console.error("Dashboard load error:", error);
      showError("Failed to load dashboard data");
    } finally {
      setLoading(false);
    }
  };

  const handleRealTimeUpdate = (message: any) => {
    const { type, data } = message;

    if (type === "metric_update") {
      setDashboardData((prev) => {
        if (!prev) return prev;

        // Update specific metric
        return {
          ...prev,
          today_metrics: {
            ...prev.today_metrics,
            [data.metric_name]: data.value,
          },
        };
      });
      setLastUpdated(new Date());
    }
  };

  if (loading) {
    return <DashboardSkeleton />;
  }

  if (!dashboardData) {
    return (
      <ErrorMessage
        message="Unable to load dashboard"
        onRetry={loadDashboard}
      />
    );
  }

  return (
    <div className="doctor-dashboard">
      <DashboardHeader
        title="Doctor Dashboard"
        lastUpdated={lastUpdated}
        onRefresh={loadDashboard}
      />

      <div className="dashboard-grid">
        <MetricCard
          title="Today's Appointments"
          value={dashboardData.today_metrics.appointments.total}
          change={`+${dashboardData.today_metrics.appointments.completed}`}
          trend="up"
          icon="calendar"
        />

        <MetricCard
          title="Patients Seen"
          value={dashboardData.today_metrics.patients.total_seen}
          subtitle={`${dashboardData.today_metrics.patients.new} new`}
          icon="users"
        />

        <MetricCard
          title="Revenue Today"
          value={`$${dashboardData.today_metrics.revenue.generated}`}
          target={`$${dashboardData.today_metrics.revenue.target}`}
          progress={dashboardData.today_metrics.revenue.achievement_rate}
          icon="dollar-sign"
        />

        <UpcomingAppointments
          appointments={dashboardData.upcoming_appointments}
          onAppointmentClick={handleAppointmentClick}
        />

        <PatientAlerts
          alerts={dashboardData.patient_alerts}
          onAlertAction={handleAlertAction}
        />

        <PerformanceChart
          data={dashboardData.weekly_performance}
          period={period}
        />
      </div>
    </div>
  );
};
```

#### Dashboard WebSocket Hook

```typescript
interface DashboardWebSocketOptions {
  dashboardType: "doctor" | "patient" | "clinic" | "admin";
  userId?: string;
  clinicId?: string;
  onUpdate?: (data: any) => void;
  onAlert?: (alert: any) => void;
}

export const useDashboardWebSocket = (options: DashboardWebSocketOptions) => {
  const ws = useRef<WebSocket | null>(null);
  const [connectionStatus, setConnectionStatus] = useState<
    "connecting" | "connected" | "disconnected"
  >("disconnected");
  const [lastUpdate, setLastUpdate] = useState<Date | null>(null);

  const connect = useCallback(() => {
    const token = getAuthToken();
    const wsUrl = `ws://localhost:8000/ws/dashboard/${options.dashboardType}/?token=${token}`;

    if (options.userId) {
      wsUrl += `&user_id=${options.userId}`;
    }
    if (options.clinicId) {
      wsUrl += `&clinic_id=${options.clinicId}`;
    }

    ws.current = new WebSocket(wsUrl);
    setConnectionStatus("connecting");

    ws.current.onopen = () => {
      setConnectionStatus("connected");
      console.log("Dashboard WebSocket connected");
    };

    ws.current.onmessage = (event) => {
      const message = JSON.parse(event.data);
      setLastUpdate(new Date());

      switch (message.type) {
        case "metric_update":
          options.onUpdate?.(message.data);
          break;
        case "alert":
          options.onAlert?.(message.data);
          break;
        case "dashboard_refresh":
          // Trigger full dashboard reload
          window.location.reload();
          break;
      }
    };

    ws.current.onclose = () => {
      setConnectionStatus("disconnected");
      // Attempt reconnection after 5 seconds
      setTimeout(connect, 5000);
    };

    ws.current.onerror = (error) => {
      console.error("Dashboard WebSocket error:", error);
      setConnectionStatus("disconnected");
    };
  }, [options]);

  useEffect(() => {
    connect();

    return () => {
      ws.current?.close();
    };
  }, [connect]);

  return {
    connectionStatus,
    lastUpdate,
    reconnect: connect,
  };
};
```

### 2. Dashboard Metric Components

#### Metric Card Component

```typescript
interface MetricCardProps {
  title: string;
  value: number | string;
  change?: string;
  trend?: "up" | "down" | "stable";
  target?: string;
  progress?: number;
  icon?: string;
  subtitle?: string;
  onClick?: () => void;
}

const MetricCard: React.FC<MetricCardProps> = ({
  title,
  value,
  change,
  trend,
  target,
  progress,
  icon,
  subtitle,
  onClick,
}) => {
  const getTrendColor = () => {
    switch (trend) {
      case "up":
        return "text-green-600";
      case "down":
        return "text-red-600";
      default:
        return "text-gray-600";
    }
  };

  const getTrendIcon = () => {
    switch (trend) {
      case "up":
        return "↗";
      case "down":
        return "↘";
      default:
        return "→";
    }
  };

  return (
    <div
      className={`metric-card ${
        onClick ? "cursor-pointer hover:shadow-lg" : ""
      }`}
      onClick={onClick}
    >
      <div className="metric-header">
        {icon && <Icon name={icon} className="metric-icon" />}
        <h3 className="metric-title">{title}</h3>
      </div>

      <div className="metric-content">
        <div className="metric-value">{value}</div>

        {subtitle && <div className="metric-subtitle">{subtitle}</div>}

        {change && (
          <div className={`metric-change ${getTrendColor()}`}>
            <span className="trend-icon">{getTrendIcon()}</span>
            <span>{change}</span>
          </div>
        )}

        {target && <div className="metric-target">Target: {target}</div>}

        {progress !== undefined && (
          <div className="metric-progress">
            <div className="progress-bar">
              <div
                className="progress-fill"
                style={{ width: `${Math.min(progress * 100, 100)}%` }}
              />
            </div>
            <span className="progress-text">{Math.round(progress * 100)}%</span>
          </div>
        )}
      </div>
    </div>
  );
};
```

#### Chart Component for Trends

```typescript
interface DashboardChartProps {
  data: any[];
  type: "line" | "bar" | "area";
  xAxis: string;
  yAxis: string;
  title?: string;
  height?: number;
}

const DashboardChart: React.FC<DashboardChartProps> = ({
  data,
  type,
  xAxis,
  yAxis,
  title,
  height = 300,
}) => {
  const chartConfig = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: "top" as const,
      },
      title: {
        display: !!title,
        text: title,
      },
    },
    scales: {
      y: {
        beginAtZero: true,
      },
    },
  };

  const chartData = {
    labels: data.map((item) => item[xAxis]),
    datasets: [
      {
        label: yAxis,
        data: data.map((item) => item[yAxis]),
        borderColor: "rgb(59, 130, 246)",
        backgroundColor: "rgba(59, 130, 246, 0.1)",
        fill: type === "area",
      },
    ],
  };

  const ChartComponent = {
    line: Line,
    bar: Bar,
    area: Line,
  }[type];

  return (
    <div className="dashboard-chart" style={{ height }}>
      <ChartComponent data={chartData} options={chartConfig} />
    </div>
  );
};
```

This comprehensive DASHBOARDS documentation provides all the technical details needed for implementing dashboard functionality across all user roles in the MediConnect application, with complete API specifications, real-time features, and frontend implementation examples.
