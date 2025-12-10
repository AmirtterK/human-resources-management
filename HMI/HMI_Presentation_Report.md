# Human Resources Management System
## HMI Project Report

**Course:** Human–Machine Interface (HMI)  
**Level:** L3 Computer Science  
**Academic Year:** 2025/2026  

---

## 1. Introduction

### 1.1 Project Presentation

This report presents the **Human Resources Management System**, a comprehensive Flutter-based application designed to streamline HR operations. The system provides a unified interface for managing employees, departments, organizational bodies, retirement processes, and administrative requests.

### 1.2 Context

In modern organizations, efficient human resource management is crucial. Traditional paper-based or fragmented digital systems lead to:
- Inefficient data access and retrieval
- Poor user experience for HR staff
- Increased cognitive load and errors

This application addresses these challenges by applying HMI principles to create an intuitive, efficient, and user-centered interface.

### 1.3 Objectives

- **Primary:** Develop a user-friendly interface that reduces cognitive load and increases productivity
- **Secondary:** Apply ergonomic principles and HMI design methodologies
- Implement **direct manipulation** paradigm for intuitive interactions
- Ensure **consistency** across all interface components

---

## 2. Analysis

### 2.1 User Identification

The system identifies three primary user roles:

| Role | Description | Access Level |
|------|-------------|--------------|
| **Project Manager (PM)** | Full administrative access | Complete CRUD operations |
| **Agent** | Standard HR operations | View & Edit operations |
| **Archiver** | Read-only access | View only |

### 2.2 Task Analysis

Based on **interaction cycle theory** (users act → system responds → users perceive → users act again), the main tasks are:

| Task Category | Specific Tasks | Interaction Type |
|---------------|----------------|------------------|
| **Input Tasks** | Add employees, create departments | Form-based input |
| **Selection Tasks** | Filter employees, choose departments | Menu & dropdown selection |
| **Action Tasks** | Approve retirement, modify records | Button triggers |
| **Specification Tasks** | Configure settings, set filters | Dialog-based |

### 2.3 Usage Context

- **Environment:** Desktop/web-based HR office environment
- **Frequency:** Daily use by HR personnel
- **Criticality:** High - affects employee records and organizational structure

---

## 3. Architecture

### 3.1 Chosen Model: MVC (Model-View-Controller)

The application follows the **MVC architectural pattern**, adapted for Flutter's reactive framework:

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER INTERFACE                           │
│  ┌──────────┐  ┌─────────────┐  ┌─────────────┐  ┌────────────┐│
│  │ SideBar  │  │ EmployeesTab│  │ Departments │  │  Dialogs   ││
│  │          │  │             │  │    Tab      │  │            ││
│  └──────────┘  └─────────────┘  └─────────────┘  └────────────┘│
│                         VIEW LAYER                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      CONTROLLER LAYER                           │
│  ┌────────────┐  ┌────────────────┐  ┌───────────────────────┐ │
│  │ Navigation │  │ State Managers │  │ Event Handlers        │ │
│  │ Controller │  │ (setState)     │  │ (onTap, onSubmit)     │ │
│  └────────────┘  └────────────────┘  └───────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        MODEL LAYER                              │
│  ┌──────────────┐  ┌─────────────┐  ┌────────────┐  ┌────────┐ │
│  │ Employee.dart│  │Department.   │  │ Body.dart  │  │types.  │ │
│  │              │  │dart          │  │            │  │dart    │ │
│  └──────────────┘  └─────────────┘  └────────────┘  └────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Justification of MVC

| Criterion | MVC Advantage |
|-----------|---------------|
| **Separation of concerns** | Clear distinction between data, presentation, and logic |
| **Maintainability** | Each component can be modified independently |
| **Testability** | Models can be tested without UI dependencies |
| **Flutter alignment** | Natural fit with Flutter's widget-based reactive architecture |

### 3.3 Component Mapping

| MVC Component | Flutter Implementation |
|---------------|----------------------|
| **Model** | `lib/classes/` - Employee, Department, Body, types |
| **View** | `lib/components/` - UI widgets (18 reusable components) |
| **Controller** | `lib/pages/`, `lib/tabs/` - State management & routing |

---

## 4. Design

### 4.1 Applied HMI Principles

#### 4.1.1 Visibility of System State
Following the principle that **"the system must display what it is doing"**:

- **Status indicators** show employee status (Employed, To Retire, Retired)
- **Loading states** during data operations
- **Notification badges** indicate pending items

#### 4.1.2 Short-Term Memory Consideration
Based on **Miller's Law (7±2 items)**:

- Sidebar limited to **7 main navigation items**
- Forms organized into logical sections
- Related actions grouped together

### 4.2 Interface Components

#### 4.2.1 Window Structure

The application uses a **hierarchical window model**:

```
┌────────────────────────────────────────────────────────────────────┐
│  Header Bar (Title + Logo + Notifications)                        │
├──────────┬─────────────────────────────────────────────────────────┤
│          │                                                         │
│  Sidebar │              Main Content Area                          │
│  (Nav)   │              (Active Tab Content)                       │
│          │                                                         │
│  ┌────┐  │   ┌─────────────────────────────────────────────────┐  │
│  │ 🏠 │  │   │  EmployeesTable / DepartmentCards / etc.        │  │
│  │ 📁 │  │   │                                                 │  │
│  │ 🏛  │  │   │  ┌─────────────────────────────────────────┐   │  │
│  │ 📋 │  │   │  │     Data Display Area                   │   │  │
│  │ 💼 │  │   │  │     (Tables, Cards, Lists)              │   │  │
│  │ ⚙️ │  │   │  └─────────────────────────────────────────┘   │  │
│  └────┘  │   └─────────────────────────────────────────────────┘  │
└──────────┴─────────────────────────────────────────────────────────┘
```

#### 4.2.2 Component Catalog (18 Reusable Components)

| Component | Type | Purpose | HMI Principle Applied |
|-----------|------|---------|----------------------|
| `SideBar` | Navigation | Main app navigation | Consistency, Recognition |
| `EmployeesTable` | Data Display | Tabular employee data | Direct Manipulation |
| `DepartmentCard` | Card | Department summary | Visual Hierarchy |
| `BodieCard` | Card | Organization unit display | Chunking |
| `StatusChip` | Status | Employee status indicator | System State Visibility |
| `AuthenticationDialog` | Modal | Login form | Form-based Interaction |
| `AddEmployeeDialog` | Modal | Employee creation form | Error Prevention |
| `ModifyEmployeeDialog` | Modal | Employee editing | Undo Support |
| `ForgotPasswordDialog` | Modal | Password recovery | User Assistance |

### 4.3 Ergonomic Principles Applied

#### 4.3.1 Color System

| Color | Hex Code | Usage | Psychological Effect |
|-------|----------|-------|---------------------|
| **Primary (Teal)** | `#09866F` | Actions, highlights | Trust, stability |
| **Success (Green)** | Semantic | Confirmations | Positive feedback |
| **Error (Red)** | Semantic | Errors, warnings | Alert, attention |
| **Background** | `#F5F5F5` | Content areas | Reduces eye strain |

#### 4.3.2 Typography

- **Primary Font:** Trap (custom font)
- **Fallback:** Alfont (Arabic support)
- **Hierarchy:** Font weights 300-900 for visual structure

#### 4.3.3 Button States (Following GUI Standards)

```
┌─────────────────────────────────────────────────────────┐
│  Button States (per Chapter 3 - GUI Elements):         │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
│  │ Released │  │ Hovered  │  │ Pressed  │  │Disabled │ │
│  │ (Normal) │  │ (Hover)  │  │ (Active) │  │ (Gray)  │ │
│  └──────────┘  └──────────┘  └──────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────┘
```

### 4.4 Dialog Design Guidelines

Following the course principles for **Dialog Boxes**:

- ✅ Maximum 5 buttons per dialog
- ✅ Always include OK/Cancel actions
- ✅ Input validation before submission
- ✅ Clear error messages

---

## 5. Implementation

### 5.1 Technology Stack

| Layer | Technology | Justification |
|-------|------------|---------------|
| **Frontend** | Flutter 3.8+ | Cross-platform, reactive UI framework |
| **Language** | Dart | Strong typing, async/await support |
| **Routing** | go_router | Declarative navigation |
| **State** | setState + StatefulWidgets | Simple, effective for this scale |

### 5.2 Interface Screens

#### 5.2.1 Main Navigation (7 Tabs)

| Tab | Icon | Content | Key Interactions |
|-----|------|---------|------------------|
| **Employees** | 👥 | Employee table with search/filter | Add, Modify, Delete |
| **Departments** | 🏢 | Department cards grid | View details, Assign |
| **Retirement** | 📅 | Retirement management | Approve, Modify dates |
| **Bodies** | 🏛️ | Organizational units | Add, View members |
| **Requests** | 📋 | HR request queue | Approve, Reject |
| **Domains** | 🌐 | Domain management | CRUD operations |
| **Settings** | ⚙️ | App configuration | Preferences |

#### 5.2.2 Interaction Types Implemented

Based on **Chapter 4 - Interaction Tasks**:

| Interaction Type | Implementation | Example |
|------------------|----------------|---------|
| **Text Input** | TextFormField | Employee name entry |
| **Selection (Single)** | DropdownButtonFormField | Status selection |
| **Selection (Multiple)** | Checkbox lists | Role assignment |
| **Direct Manipulation** | DataTable rows | Click to select/edit |
| **Drag & Drop** | Planned | Future enhancement |

### 5.3 Error Management

Following **Chapter 4 - Error Handling** principles:

#### Prevention Strategies:
- ✅ Form validation before submission
- ✅ Disabled buttons for invalid states
- ✅ Required field indicators

#### Correction Strategies:
- ✅ Clear error messages below input fields
- ✅ Red border highlighting on errors
- ✅ Undo capability via cancel buttons

### 5.4 Help System

| Help Type | Implementation |
|-----------|----------------|
| **Contextual** | Tooltips on hover |
| **Factual** | Label descriptions |
| **Procedural** | Form placeholders |

---

## 6. Conclusion

### 6.1 Summary

This Human Resources Management System successfully applies HMI principles to create an effective, user-centered interface:

- ✅ **MVC Architecture** provides clear separation of concerns
- ✅ **Direct Manipulation** paradigm enables intuitive interactions
- ✅ **Ergonomic Design** reduces cognitive load
- ✅ **Consistent Components** improve learnability
- ✅ **Error Prevention** minimizes user mistakes

### 6.2 HMI Principles Applied

| Chapter | Concept | Application |
|---------|---------|-------------|
| 1 | Interface as communication bridge | Sidebar + Content Area design |
| 2 | Short-term memory limits | 7 navigation items |
| 3 | GUI component standards | Consistent buttons, dialogs, forms |
| 4 | Error management | Validation, clear messages |

### 6.3 Perspectives & Improvements

| Area | Current State | Proposed Enhancement |
|------|--------------|---------------------|
| **Accessibility** | Basic | Add ARIA labels, keyboard navigation |
| **Multi-user** | Role-based | Real-time collaboration features |
| **Responsiveness** | Desktop-first | Full mobile adaptation |
| **Help System** | Minimal | Comprehensive onboarding wizard |

### 6.4 Lessons Learned

The development of this HR Management system reinforced key HMI concepts:

1. **User-centered design** leads to better adoption
2. **Consistency** reduces learning curve
3. **Visible system state** builds user confidence
4. **Error prevention** is preferable to error handling

---

## Appendix: Project Structure

```
lib/
├── classes/           # Data Models (MVC - Model)
│   ├── Employee.dart
│   ├── Department.dart
│   ├── Body.dart
│   └── types.dart
│
├── components/        # Reusable UI (MVC - View)
│   ├── SideBar.dart
│   ├── EmployeesTable.dart
│   ├── DepartmentCard.dart
│   ├── BodieCard.dart
│   ├── StatusChip.dart
│   ├── AddEmployeeDialog.dart
│   ├── ModifyEmployeeDialog.dart
│   ├── AuthenticationDialog.dart
│   └── ... (18 total)
│
├── pages/             # Main Pages (MVC - Controller)
│   ├── HomePage.dart
│   └── LoginPage.dart
│
├── tabs/              # Tab Content (MVC - View/Controller)
│   ├── EmployeesTab.dart
│   ├── DepartmentsTab.dart
│   ├── RetirementTab.dart
│   ├── BodiesTab.dart
│   ├── RequestsTab.dart
│   ├── DomainsTab.dart
│   └── ExtendedViews...
│
└── main.dart          # App Entry & Configuration
```

---

**Report prepared for:** HMI Course - L3 Computer Science  
**University:** Abdelhamid Ibn Badis University – Mostaganem  
**Instructor:** M. ZEBOUDJ
