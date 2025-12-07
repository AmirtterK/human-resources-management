# Human Resources Management System (HRMS)
## HMI Project Report

---

**Course**: Human-Machine Interface (HMI)  
**Level**: L3 Computer Science  
**Academic Year**: 2025/2026  
**Submission Date**: December 2025

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Analysis](#2-analysis)
3. [Architecture](#3-architecture)
4. [Design](#4-design)
5. [Implementation](#5-implementation)
6. [Conclusion](#6-conclusion)

---

## 1. Introduction

### 1.1 Project Context

This project presents a **Human Resources Management System (HRMS)** - a comprehensive desktop/mobile application designed to streamline HR operations. The system enables organizations to manage employees, departments, organizational bodies, retirement processes, and administrative domains through an intuitive graphical interface.

### 1.2 Objectives

- **Primary Goal**: Create a user-friendly interface for comprehensive HR management
- **Target Users**: HR administrators, managers, and organizational staff
- **Key Functions**:
  - Employee lifecycle management (hiring, promotion, retirement)
  - Department and organizational structure management
  - Multi-role access control (PM, Agent, Archiver)
  - Bilingual support (English/Arabic)

### 1.3 Technology Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.8.1+ |
| Language | Dart |
| Routing | go_router |
| State Management | setState (local state) |
| UI Components | Custom Flutter widgets |
| Platforms | Windows, Web, Android, iOS, macOS, Linux |

---

## 2. Analysis

### 2.1 User Identification

The system identifies **three primary user roles** with distinct interaction patterns:

| Role | Description | Access Level |
|------|-------------|--------------|
| **PM (Project Manager)** | Full system access, can perform all CRUD operations | Administrator |
| **Agent** | Standard user, can view and modify records | Standard User |
| **Archiver** | Limited access, primarily viewing and archival operations | Restricted |

### 2.2 Task Analysis

The primary tasks users perform within the system:

```
┌─────────────────────────────────────────────────────────────┐
│                    USER TASK HIERARCHY                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. EMPLOYEE MANAGEMENT                                     │
│     ├── View employee list (table format)                   │
│     ├── Add new employee (dialog form)                      │
│     ├── Modify employee details (dialog form)               │
│     ├── Promote employee (step increment)                   │
│     └── Filter/Search employees (by ID, name)               │
│                                                              │
│  2. DEPARTMENT MANAGEMENT                                   │
│     ├── View all departments (card grid)                    │
│     ├── View department details (extended view)             │
│     └── Search within department                            │
│                                                              │
│  3. RETIREMENT MANAGEMENT                                   │
│     ├── View retirement candidates                          │
│     ├── Process retirement requests                         │
│     └── Modify retiree information                          │
│                                                              │
│  4. ORGANIZATIONAL BODIES                                   │
│     ├── View bodies (card grid)                             │
│     ├── Add new body (dialog form)                          │
│     ├── Add employees to body                               │
│     └── Extended body details view                          │
│                                                              │
│  5. DOMAIN MANAGEMENT                                       │
│     ├── View domains                                        │
│     ├── Add new domain                                      │
│     └── View domain details                                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Usage Context

- **Environment**: Office/administrative settings
- **Frequency**: Daily use during business hours
- **Device Types**: Desktop computers (primary), tablets, mobile devices
- **Network**: Connected to backend API services

---

## 3. Architecture

### 3.1 Chosen Model: MVC (Model-View-Controller)

We adopted the **MVC architectural pattern** for our HRMS interface, which provides clear separation of concerns and facilitates maintainability.

### 3.2 MVC Architecture Diagram

```
┌────────────────────────────────────────────────────────────────────────┐
│                        MVC ARCHITECTURE                                 │
├────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   ┌─────────────────────────────────────────────────────────────────┐  │
│   │                         VIEW LAYER                               │  │
│   │                    (lib/components/ + lib/tabs/)                │  │
│   │                                                                  │  │
│   │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐             │  │
│   │  │  SideBar     │ │EmployeesTable│ │DepartmentCard│             │  │
│   │  └──────────────┘ └──────────────┘ └──────────────┘             │  │
│   │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐             │  │
│   │  │  BodieCard   │ │  DomainCard  │ │  StatusChip  │             │  │
│   │  └──────────────┘ └──────────────┘ └──────────────┘             │  │
│   │  ┌──────────────────────────────────────────────────┐           │  │
│   │  │              DIALOG COMPONENTS                    │           │  │
│   │  │  AddEmployeeDialog | ModifyEmployeeDialog | etc.  │           │  │
│   │  └──────────────────────────────────────────────────┘           │  │
│   └─────────────────────────────────────────────────────────────────┘  │
│                              │                                          │
│                              │ User Events                              │
│                              ▼                                          │
│   ┌─────────────────────────────────────────────────────────────────┐  │
│   │                     CONTROLLER LAYER                             │  │
│   │                       (lib/pages/)                               │  │
│   │                                                                  │  │
│   │   ┌─────────────────────┐    ┌─────────────────────┐            │  │
│   │   │                     │    │                     │            │  │
│   │   │     HomePage        │    │    LoginPage        │            │  │
│   │   │  (Tab Controller)   │    │  (Auth Controller)  │            │  │
│   │   │                     │    │                     │            │  │
│   │   └─────────────────────┘    └─────────────────────┘            │  │
│   │                                                                  │  │
│   └─────────────────────────────────────────────────────────────────┘  │
│                              │                                          │
│                              │ Data Access                              │
│                              ▼                                          │
│   ┌─────────────────────────────────────────────────────────────────┐  │
│   │                       MODEL LAYER                                │  │
│   │              (lib/classes/ + lib/data/ + lib/services/)         │  │
│   │                                                                  │  │
│   │   ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌──────────┐  │  │
│   │   │ Employee   │  │ Department │  │    Body    │  │  types   │  │  │
│   │   │   .dart    │  │   .dart    │  │   .dart    │  │  .dart   │  │  │
│   │   └────────────┘  └────────────┘  └────────────┘  └──────────┘  │  │
│   │                                                                  │  │
│   │   ┌────────────────────────┐  ┌────────────────────────┐        │  │
│   │   │       data.dart        │  │    api_service.dart    │        │  │
│   │   │    (Data Provider)     │  │   (API Integration)    │        │  │
│   │   └────────────────────────┘  └────────────────────────┘        │  │
│   └─────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.3 Architecture Justification

| MVC Principle | Implementation in HRMS |
|---------------|------------------------|
| **Model** | Data classes (`Employee`, `Department`, `Body`) encapsulate business entities with JSON serialization support |
| **View** | 17 reusable UI components (dialogs, cards, tables) provide consistent user interaction |
| **Controller** | Pages manage navigation, state, and coordinate between views and models |

**Benefits of MVC for this project:**
- **Separation of Concerns**: UI components are independent of data logic
- **Reusability**: Components like `EmployeesTable` and `StatusChip` are reused across multiple tabs
- **Maintainability**: Changes to data models don't require UI modifications
- **Testability**: Each layer can be tested independently

### 3.4 File Organization

```
lib/
├── classes/              ← MODEL (Data Entities)
│   ├── Employee.dart     
│   ├── Department.dart   
│   ├── Body.dart         
│   └── types.dart        
│
├── data/                 ← MODEL (Data Provider)
│   └── data.dart         
│
├── services/             ← MODEL (Business Logic)
│   └── api_service.dart  
│
├── pages/                ← CONTROLLER
│   ├── HomePage.dart     
│   └── Loginpage.dart    
│
├── components/           ← VIEW (Reusable Widgets)
│   ├── AddEmployeeDialog.dart
│   ├── ModifyEmployeeDialog.dart
│   ├── EmployeesTable.dart
│   ├── DepartmentCard.dart
│   ├── BodieCard.dart
│   ├── SideBar.dart
│   └── ... (17 total)
│
├── tabs/                 ← VIEW (Tab Content)
│   ├── EmployeesTab.dart
│   ├── DepartmentsTab.dart
│   ├── RetirementTab.dart
│   ├── BodiesTab.dart
│   ├── RequestsTab.dart
│   ├── DomainsTab.dart
│   └── Extended*Tab.dart
│
└── main.dart             ← App Entry + Routing
```

---

## 4. Design

### 4.1 Design Principles Applied

#### 4.1.1 Ergonomic Principles

| Principle | Implementation |
|-----------|----------------|
| **Visibility** | Clear sidebar navigation with labeled icons, active tab highlighting |
| **Feedback** | Status chips with color coding (Green=Employed, Orange=To Retire, Red=Retired) |
| **Consistency** | Uniform color scheme (Teal primary), consistent button styles, uniform card layouts |
| **Flexibility** | Multi-platform support, responsive layouts for different screen sizes |
| **Error Prevention** | Form validation in dialogs, confirmation dialogs for destructive actions |

#### 4.1.2 Color System

```
┌─────────────────────────────────────────────────┐
│              COLOR PALETTE                       │
├─────────────────────────────────────────────────┤
│                                                  │
│  PRIMARY:    #09866F (Teal)    ████████████     │
│                                                  │
│  BACKGROUND: #F5F5F5 (Light Gray) ████████████  │
│                                                  │
│  STATUS COLORS:                                  │
│  • Employed:  Green   ████                      │
│  • To Retire: Orange  ████                      │
│  • Retired:   Red     ████                      │
│                                                  │
│  NOTIFICATION: Red badge indicator              │
│                                                  │
└─────────────────────────────────────────────────┘
```

### 4.2 UI Mockups and Wireframes

#### 4.2.1 Main Layout Structure

```
┌────────────────────────────────────────────────────────────────────────┐
│  ┌──────┐  Human Resource Management                    🔔 (badge)    │
│  │ LOGO │                                                              │
│  └──────┘                                                              │
├──────────────┬─────────────────────────────────────────────────────────┤
│              │                                                          │
│  ┌────────┐  │    ┌──────────────────────────────────────────────────┐ │
│  │👥 Empl │  │    │                                                  │ │
│  └────────┘  │    │              TAB CONTENT AREA                    │ │
│  ┌────────┐  │    │                                                  │ │
│  │📁 Dept │  │    │  (EmployeesTab / DepartmentsTab / RetirementTab  │ │
│  └────────┘  │    │   / BodiesTab / RequestsTab / DomainsTab)        │ │
│  ┌────────┐  │    │                                                  │ │
│  │🔄 Retir│  │    │                                                  │ │
│  └────────┘  │    │                                                  │ │
│  ┌────────┐  │    │                                                  │ │
│  │🏢 Bodi │  │    └──────────────────────────────────────────────────┘ │
│  └────────┘  │                                                          │
│  ┌────────┐  │                                                          │
│  │📋 Requ │  │                                                          │
│  └────────┘  │                                                          │
│  ┌────────┐  │                                                          │
│  │🌐 Doma │  │                                                          │
│  └────────┘  │                                                          │
│  ┌────────┐  │                                                          │
│  │⚙️ Sett │  │                                                          │
│  └────────┘  │                                                          │
│              │                                                          │
└──────────────┴─────────────────────────────────────────────────────────┘
```

#### 4.2.2 Employees Tab Wireframe

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           EMPLOYEES TAB                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   [🔍 Search by ID or Name...              ]         [+ Add Employee]   │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐│
│  │  ID  │  Full Name      │  Rank  │ Category │ Specialty │  Status   ││
│  ├─────────────────────────────────────────────────────────────────────┤│
│  │ #001 │ John Smith      │ Gold   │    A     │ Driver    │ [Employed]││
│  │ #002 │ Jane Doe        │Platinum│    B     │ Engineer  │ [Employed]││
│  │ #003 │ Bob Johnson     │Diamond │    A     │ Manager   │ [ToRetire]││
│  │ #004 │ Alice Williams  │ Silver │    C     │ Analyst   │ [Retired] ││
│  │ ...  │ ...             │ ...    │   ...    │   ...     │    ...    ││
│  └─────────────────────────────────────────────────────────────────────┘│
│                                                                          │
│                    [<] [1] [2] [3] [>]  Pagination                       │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

#### 4.2.3 Add Employee Dialog Wireframe

```
┌────────────────────────────────────────────────┐
│           ✕  ADD NEW EMPLOYEE                  │
├────────────────────────────────────────────────┤
│                                                │
│  Full Name:                                    │
│  ┌────────────────────────────────────────┐   │
│  │                                        │   │
│  └────────────────────────────────────────┘   │
│                                                │
│  Rank:              Category:                  │
│  ┌──────────────┐   ┌──────────────┐          │
│  │ Gold      ▼ │   │ A         ▼ │          │
│  └──────────────┘   └──────────────┘          │
│                                                │
│  Specialty:                                    │
│  ┌────────────────────────────────────────┐   │
│  │                                        │   │
│  └────────────────────────────────────────┘   │
│                                                │
│  Department:        Body:                      │
│  ┌──────────────┐   ┌──────────────┐          │
│  │ Racing    ▼ │   │ Ferrari   ▼ │          │
│  └──────────────┘   └──────────────┘          │
│                                                │
│  Step:              Grade:                     │
│  ┌──────────────┐   ┌──────────────┐          │
│  │ 1            │   │              │          │
│  └──────────────┘   └──────────────┘          │
│                                                │
│         [Cancel]          [Add Employee]       │
│                                                │
└────────────────────────────────────────────────┘
```

### 4.3 Component Reusability

Our design emphasizes **component reusability** across the application:

| Component | Reused In |
|-----------|-----------|
| `StatusChip` | EmployeesTable, RetirementTab, Extended views |
| `EmployeesTable` | EmployeesTab, ExtendedBodiesTab, ExtendedDepartmentsTab |
| `DepartmentCard` | DepartmentsTab (grid layout) |
| `BodieCard` | BodiesTab (grid layout) |
| `SideBar` | HomePage (persistent navigation) |

---

## 5. Implementation

### 5.1 Technology Overview

The HRMS interface is implemented using **Flutter**, a cross-platform UI framework, enabling deployment across:
- Windows Desktop
- Web Browsers
- Android & iOS Devices
- macOS & Linux

### 5.2 Key Interface Screenshots

#### 5.2.1 Login Page

The authentication screen provides secure access to the system:

![Login Page Interface](screenshots/login_page.png)

#### 5.2.2 Employees Tab (Main Dashboard)

The main interface displays employees in a table format with sidebar navigation:

![Employees Tab - Main Dashboard](screenshots/employees_tab.png)

**Key Features Visible:**
- Persistent sidebar navigation with 7 sections
- Employee data table with columns for ID, Name, Rank, Category, Specialty, and Status
- Search functionality for filtering employees
- Add Employee button for data entry
- Color-coded status chips (Green=Employed, Orange=To Retire, Red=Retired)

#### 5.2.3 Departments Tab

Department management with card-based layout:

![Departments Tab - Card Grid View](screenshots/departments_tab.png)

**Key Features Visible:**
- Grid layout of department cards
- Each card shows department name, head name, and staff count
- Navigation arrows to view department details
- Consistent card styling with rounded corners

#### 5.2.4 Bodies Tab

Organizational body management with bilingual support:

![Bodies Tab - Organizational Units](screenshots/bodies_tab.png)

**Key Features Visible:**
- Card-based layout for organizational bodies
- Bilingual labels (English/Arabic names)
- Member count display
- Add Body functionality

#### 5.2.5 Data Entry Forms

The system provides intuitive dialog-based forms for data entry:

- **AddEmployeeDialog**: Comprehensive form with dropdown selections for rank, category, department, and body
- **ModifyEmployeeDialog**: Edit existing employee data with promotion capabilities
- **AddBodieDialog**: Create organizational bodies with English/Arabic naming
- **AddDomainDialog**: Add new operational domains

#### 5.2.6 Data Display Components Summary

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| `EmployeesTable` | Display employee data | Sortable columns, status chips, action buttons |
| `DepartmentCard` | Show department info | Head name, staff count, navigation to details |
| `BodieCard` | Display body info | Member count, bilingual labels, navigation |
| `DomainCard` | Show domain info | Domain name, details view |

### 5.3 User Interaction Examples

#### 5.3.1 Employee Management Flow

```
User → Clicks "Add Employee" button
     → AddEmployeeDialog opens
     → User fills form fields
     → User clicks "Confirm"
     → Data validated
     → Employee added to system
     → Table refreshes automatically
     → Success feedback shown
```

#### 5.3.2 Navigation Flow

```
User → Clicks sidebar item (e.g., "Departments")
     → Homepage controller updates selected index
     → TabView animates to DepartmentsTab
     → Department cards load and display
     → User can click card for extended details
```

### 5.4 Responsive Design

The interface adapts to different screen sizes:

- **Desktop (>1200px)**: Full sidebar + spacious content area
- **Tablet (768-1200px)**: Collapsible sidebar + adjusted layouts
- **Mobile (<768px)**: Bottom navigation + single-column layouts

### 5.5 Accessibility Features

- **Color Contrast**: High contrast between text and backgrounds
- **Touch Targets**: Minimum 48px touch targets for interactive elements
- **Font Scaling**: Supports system font size preferences
- **Screen Reader**: Semantic widgets with proper labels

---

## 6. Conclusion

### 6.1 Summary

This HRMS project successfully demonstrates the application of HMI principles in a real-world human resources management context. Key achievements include:

- ✅ **MVC Architecture**: Clean separation between data models, controllers, and views
- ✅ **Component Reusability**: 17 reusable components reducing code duplication
- ✅ **Ergonomic Design**: Color-coded status indicators, consistent layouts, clear navigation
- ✅ **Multi-Platform**: Single codebase supporting 6 target platforms
- ✅ **Bilingual Support**: Arabic and English language support for organizational bodies

### 6.2 Future Improvements

| Area | Proposed Enhancement |
|------|---------------------|
| **State Management** | Migrate from setState to Riverpod/Bloc for scalability |
| **Dark Mode** | Implement system-aware dark theme |
| **Offline Support** | Add local caching for offline operation |
| **Analytics Dashboard** | Visual charts for HR metrics |
| **Advanced Search** | Multi-field filtering with saved searches |
| **Audit Logging** | Track all user actions for compliance |

### 6.3 Lessons Learned

1. **Component Design First**: Planning reusable components early saved development time
2. **MVC Benefits**: Clear architecture simplified debugging and feature additions
3. **Ergonomic Testing**: User feedback on color choices improved usability
4. **Cross-Platform Considerations**: Flutter enabled true write-once, run-anywhere development

---

## Appendices

### A. Component Reference

| Component | File | Lines of Code |
|-----------|------|---------------|
| AddEmployeeDialog | AddEmployeeDialog.dart | ~17,160 bytes |
| ModifyEmployeeDialog | ModifyEmployeeDialog.dart | ~15,793 bytes |
| EmployeesTable | EmployeesTable.dart | ~10,004 bytes |
| SideBar | SideBar.dart | ~7,281 bytes |

### B. Data Model Summary

```dart
// Employee Status Enum
enum Status { employed, toRetire, retired }

// User Role Enum
enum User { pm, agent, archiver }
```

### C. Technology Stack

- **Frontend**: Flutter 3.8.1+
- **Language**: Dart
- **Router**: go_router ^17.0.0
- **UI Extras**: popover ^0.3.1, intl ^0.20.2

---

*Report prepared for HMI Course - L3 Computer Science*  
*Abdelhamid Ibn Badis University - Mostaganem*  
*Academic Year 2025/2026*
