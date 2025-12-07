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
This diagram represents the internal structure of the system, matching the Spring Boot entities (`hr-server/src/main/kotlin/com/gl/hr/server/models/`).

```mermaid
classDiagram
    %% Enums
    class Status {
        <<enumeration>>
        ACTIVE
        RETIRED
    }

    class Rank {
        <<enumeration>>
        GOLD
        PLATINUM
        DIAMOND
        SILVER
    }

    %% Classes
    class Employee {
        +Long id
        +String firstName
        +String lastName
        +LocalDate dateOfBirth
        +String address
        +String reference
        +Rank originalRank
        +Rank currentRank
        +int step
        +boolean retireRequest
        +Status status
    }

    class Department {
        +Long id
        +String name
        +List~Employee~ employees
    }

    class Body {
        +Long id
        +String code
        +String designationFR
        +String designationAR
        +List~Grade~ grades
        +List~Employee~ employees
    }
    
    class Grade {
        +Long id
        +String code
        +String designationFR
        +String designationAR
        +Body body
    }

    class Speciality {
        +Long id
        +String name
        +String code
        +List~Employee~ employees
    }

    %% Relationships
    Department "1" *-- "*" Employee : contains
    Body "1" *-- "*" Employee : contains
    Body "1" *-- "*" Grade : has
    Speciality "1" -- "*" Employee : defines
    Grade "0..1" -- "*" Employee : assigned_to
    
    Employee ..> Status : uses
    Employee ..> Rank : uses
```

## 4. Sequence Diagrams

### 4.1 Authentication Process
Sequence diagram for the login flow utilizing `AuthService` connecting to the Spring Boot backend.

```mermaid
sequenceDiagram
    participant User
    participant "Login Page" as Login
    participant "Flutter Service" as FService
    participant "Auth Controller" as Controller
    participant "User Service" as UService
    participant "Database" as DB

    User->>Login: Enter Username and Password
    Login->>FService: authenticate(username, password)
    activate FService
    FService->>Controller: POST /api/auth/login
    activate Controller
    Controller->>UService: login(username, password)
    activate UService
    UService->>DB: findByUsername(username)
    activate DB
    DB-->>UService: Return User Entity
    deactivate DB
    UService-->>Controller: Return Token & Role
    deactivate UService
    Controller-->>FService: Return 200 OK + JSON
    deactivate Controller
    FService-->>Login: Return UserRole
    deactivate FService
    
    alt Validation Success
        Login->>Home: Navigate to Dashboard
    else Validation Fail
        Login-->>User: Show Error Message
    end
```

### 4.2 Add Employee Process
Sequence diagram for adding a new employee involving the Flutter client and Spring Boot backend layers.

```mermaid
sequenceDiagram
    participant PM
    participant "Add Dialog" as Dialog
    participant "Flutter Service" as FService
    participant "PM Controller" as Controller
    participant "PM Service" as PService
    participant "Repository" as Repo
    participant "PostgreSQL" as DB

    PM->>Dialog: Fill Employee Details
    PM->>Dialog: Click Confirm
    activate Dialog
    Dialog->>FService: addEmployee(data)
    activate FService
    
    FService->>Controller: POST /api/pm/employees/add
    activate Controller
    Controller->>PService: addEmployee(dto)
    activate PService
    PService->>Repo: save(employee)
    activate Repo
    Repo->>DB: INSERT INTO employee...
    activate DB
    DB-->>Repo: Return Saved Entity
    deactivate DB
    Repo-->>PService: Return Employee
    deactivate Repo
    PService-->>Controller: Return Success
    deactivate PService
    Controller-->>FService: Return 201 Created
    deactivate Controller
    
    FService-->>Dialog: Return Success
    deactivate FService
    
    Dialog-->>PM: Show Success Message
    deactivate Dialog
```

### 4.3 Modify Employee Process (PM)
Sequence diagram for updating an existing employee's details (e.g., promotion).

```mermaid
sequenceDiagram
    participant PM
    participant "Modify Dialog" as Dialog
    participant "Flutter Service" as FService
    participant "PM Controller" as Controller
    participant "PM Service" as PService
    participant "Repository" as Repo
    participant "PostgreSQL" as DB

    PM->>Dialog: Update Details (Step/Rank)
    PM->>Dialog: Click Save
    activate Dialog
    Dialog->>FService: modifyEmployee(id, data)
    activate FService
    
    FService->>Controller: PUT /api/pm/employees/{id}/modify
    activate Controller
    Controller->>PService: modifyEmployee(id, dto)
    activate PService
    PService->>Repo: findById(id)
    activate Repo
    Repo-->>PService: Return Employee
    deactivate Repo
    
    PService->>PService: Update Fields
    PService->>Repo: save(employee)
    activate Repo
    Repo->>DB: UPDATE employee...
    activate DB
    DB-->>Repo: Return Success
    deactivate DB
    Repo-->>PService: Return Updated Entity
    deactivate Repo
    
    PService-->>Controller: Return Success
    deactivate PService
    Controller-->>FService: Return 200 OK
    deactivate Controller
    
    FService-->>Dialog: Return Success
    deactivate FService
    
    Dialog-->>PM: Close Dialog & Refresh
    deactivate Dialog
```

### 4.4 Search Employees by Specialty (Agent)
Sequence diagram for an Agent filtering employees by functionality.

```mermaid
sequenceDiagram
    participant Agent
    participant "Employees Tab" as UI
    participant "Flutter Service" as FService
    participant "Agent Controller" as Controller
    participant "Agent Service" as AService
    participant "Repository" as Repo
    
    Agent->>UI: Select Specialty Filter
    activate UI
    UI->>FService: getEmployeesBySpecialty(id)
    activate FService
    
    FService->>Controller: GET /api/agent/employees?specialtyId=...
    activate Controller
    Controller->>AService: getEmployeesBySpecialty(id)
    activate AService
    AService->>Repo: findBySpecialtyId(id)
    activate Repo
    Repo-->>AService: Return List<Employee>
    deactivate Repo
    AService-->>Controller: Return List
    deactivate AService
    Controller-->>FService: Return JSON List
    deactivate Controller
    
    FService-->>UI: Return List<Employee>
    deactivate FService
    UI-->>Agent: Display Filtered List
    deactivate UI
```

### 4.5 Validate Retirement Request (ASM)
Sequence diagram for the validation of a retirement request.

```mermaid
sequenceDiagram
    participant ASM
    participant "Retirement Tab" as UI
    participant "Flutter Service" as FService
    participant "ASM Controller" as Controller
    participant "ASM Service" as Service
    participant "Repository" as Repo

    ASM->>UI: Click Validate Request
    activate UI
    UI->>FService: validateRetireRequest(id)
    activate FService
    
    FService->>Controller: POST /api/asm/retireRequests/{id}/validate
    activate Controller
    Controller->>Service: validateRetireRequest(id)
    activate Service
    
    Service->>Repo: findById(id)
    activate Repo
    Repo-->>Service: Return Employee
    deactivate Repo
    
    Service->>Service: setStatus(RETIRED)
    Service->>Repo: save(employee)
    activate Repo
    Repo-->>Service: Return Success
    deactivate Repo
    
    Service-->>Controller: Return SuccessMessage
    deactivate Service
    Controller-->>FService: Return 200 OK
    deactivate Controller
    
    FService-->>UI: Return Success
    deactivate FService
    UI-->>ASM: Update List
    deactivate UI
```

### 4.6 Create Body (Agent)
Sequence diagram for an Agent creating a new organizational body.

```mermaid
sequenceDiagram
    participant Agent
    participant "Bodies Tab" as UI
    participant "Flutter Service" as FService
    participant "Agent Controller" as Controller
    participant "Agent Service" as AService
    participant "Repository" as Repo
    
    Agent->>UI: Click Add Body
    Agent->>UI: Fill Body Details (FR/AR)
    activate UI
    UI->>FService: createBody(dto)
    activate FService
    
    FService->>Controller: POST /api/agent/bodies/create
    activate Controller
    Controller->>AService: createBody(dto)
    activate AService
    
    AService->>Repo: save(body)
    activate Repo
    Repo-->>AService: Return Success
    deactivate Repo
    
    AService-->>Controller: Return Success Message
    deactivate AService
    Controller-->>FService: Return 200 OK
    deactivate Controller
    
    FService-->>UI: Return Success
    deactivate FService
    UI-->>Agent: Refresh List
    deactivate UI
```

## 5. Deployment Diagram
Illustrates the physical architecture of the system including the Spring Boot backend and PostgreSQL database.

```mermaid
graph TD
    subgraph "Client Tier"
        FlutterApp[("Flutter Application\n(Windows/Mobile/Web)")]
    end

    subgraph "Application Tier"
        SpringBoot[("Spring Boot Server\n(Kotlin)")]
    end

    subgraph "Data Tier"
        PostgreSQL[("PostgreSQL Database")]
    end

    FlutterApp -- "HTTPS / JSON\n(REST API)" --> SpringBoot
    SpringBoot -- "JPA / Hibernate\n(JDBC)" --> PostgreSQL
```
