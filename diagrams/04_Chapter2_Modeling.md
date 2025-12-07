# Chapter 2: Modeling

## 1. Introduction
This chapter presents the static and dynamic views of the system using Unified Modeling Language (UML) diagrams.

## 2. Use Case Diagram
The following diagram illustrates the interactions between the primary actors (PM, Agent, Archiver) and the system's main use cases.

```mermaid
graph LR
    %% Actors represented as circles/nodes
    PM((PM))
    Agent((Agent))
    Archiver((Archiver))

    %% System Boundary
    subgraph "HR Management System"
        UC1(Login)
        UC2(Manage Employees)
        UC3(Add Employee)
        UC4(Modify Employee)
        UC5(View Departments)
        UC6(Manage Bodies)
        UC7(Request Retirement)
        UC8(View Archives)
    end

    %% Relationships
    PM --> UC1
    PM --> UC2
    PM --> UC3
    PM --> UC4
    PM --> UC5
    PM --> UC6
    PM --> UC7

    Agent --> UC1
    Agent --> UC2
    Agent --> UC4
    Agent --> UC5

    Archiver --> UC1
    Archiver --> UC5
    Archiver --> UC8

    %% Extend relationships shown with dotted lines
    UC3 -.-> UC2
    UC4 -.-> UC2
```

## 3. Class Diagram
This diagram represents the internal structure of the system, matching the actual data models implemented in the Flutter code (`lib/classes/`).

```mermaid
classDiagram
    %% Enums
    class Status {
        <<enumeration>>
        employed
        toRetire
        retired
    }

    class UserRole {
        <<enumeration>>
        pm
        agent
        archiver
    }

    %% Classes
    class Employee {
        +String id
        +String fullName
        +String rank
        +String category
        +String specialty
        +String department
        +Status status
        +DateTime requestDate
        +String gradeEn
        +String gradeAr
        +int step
        +int departmentId
        +int specialityId
    }

    class Department {
        +String id
        +String name
        +String headName
        +int totalStaffMembers
        +List~Employee~ employees
    }

    class Body {
        +String id
        +String nameEn
        +String nameAr
        +int totalMembers
        +List~Employee~ employees
    }

    %% Relationships
    Department "1" *-- "*" Employee : contains
    Body "1" *-- "*" Employee : contains
    Employee ..> Status : uses
```

## 4. Sequence Diagrams

### 4.1 Authentication Process
Sequence diagram for the login flow utilizing `AuthService`.

```mermaid
sequenceDiagram
    participant User
    participant "Login Page" as Login
    participant "Auth Service" as Auth
    participant "Home Page" as Home

    User->>Login: Enter Username and Password
    Login->>Auth: authenticate(username, password)
    activate Auth
    Auth-->>Login: return UserRole
    deactivate Auth
    
    alt Validation Success
        Login->>Home: Navigate to Dashboard
        activate Home
        Home-->>User: Display Features
        deactivate Home
    else Validation Fail
        Login-->>User: Show Error Message
    end
```

### 4.2 Add Employee Process
Sequence diagram for adding a new employee involving the `EmployeeService` and REST API.

```mermaid
sequenceDiagram
    participant PM
    participant "Add Dialog" as Dialog
    participant "Employee Service" as Service
    participant "REST API" as API

    PM->>Dialog: Fill Employee Details
    PM->>Dialog: Click Confirm
    activate Dialog
    Dialog->>Service: addEmployee(data)
    activate Service
    
    Service->>API: POST /api/pm/employees/add
    activate API
    API-->>Service: Return 201 Created
    deactivate API
    
    Service-->>Dialog: Return Success
    deactivate Service
    
    Dialog-->>PM: Show Success Message
    deactivate Dialog
```

## 5. Deployment Diagram
Illustrates the physical architecture of the system.

```mermaid
graph TD
    subgraph "Client Device (Windows/Android)"
        FlutterApp[("Flutter Application")]
    end

    subgraph "Backend Server (Render)"
        API[("REST API Node/Spring")]
    end

    subgraph "Data Layer"
        DB[("Database")]
    end

    FlutterApp -- HTTPS JSON --> API
    API -- Read/Write --> DB
```
