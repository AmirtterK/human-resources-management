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
    autonumber
    participant PM as "PM (UI)"
    participant UI as "Add Employee Dialog\n(Flutter)"
    participant HTTP as "HTTP / EmployeeService"
    participant PMCtrl as "PM Controller\n(/api/pm/employees)"
    participant PMSvc as "PM Service"
    participant Validator as "Validation Module"
    participant Repo as "Employee Repository"
    participant DB as "PostgreSQL"
    participant AuditQ as "Audit Queue (Kafka/RabbitMQ)"
    participant Notif as "Notification Service"

    PM->>UI: Fill form & Submit
    UI->>HTTP: POST /api/pm/employees {employeeDTO, token}
    HTTP->>PMCtrl: forward
    PMCtrl->>PMSvc: createEmployee(dto, user)
    activate PMSvc
    PMSvc->>Validator: validate(dto)
    alt validation fail
        Validator-->>PMSvc: errors
        PMSvc-->>PMCtrl: 400 + errors
        PMCtrl-->>HTTP: 400
        HTTP-->>UI: show validation errors
        UI-->>PM: Correct form
    else validation ok
        PMSvc->>Repo: save(mapToEntity(dto))
        Repo->>DB: INSERT INTO employee...
        DB-->>Repo: persisted entity (id, timestamps)
        Repo-->>PMSvc: savedEntity
        PMSvc->>AuditQ: publish(EmployeeCreatedEvent {id, actor})
        AuditQ-->>Notif: (async) -> notify archive / PM / logs
        PMSvc-->>PMCtrl: 201 Created + entity
        PMCtrl-->>HTTP: 201
        HTTP-->>UI: success (entity)
        UI-->>PM: show success message & refresh
    end
```

### 4.3 Modify Employee Process (PM)
Sequence diagram for updating an existing employee's details (e.g., promotion).

```mermaid
sequenceDiagram
    autonumber
    participant PM as "PM (UI)"
    participant UI as "Modify Dialog"
    participant HTTP as "HTTP / EmployeeService"
    participant PMCtrl as "PM Controller\nPUT /{id}"
    participant PMSvc as "PM Service"
    participant Repo as "Employee Repository"
    participant DB as "PostgreSQL"
    participant Cache as "Cache (optional)"
    participant AuditQ as "Audit Queue"

    PM->>UI: Edit fields & Save
    UI->>HTTP: PUT /api/pm/employees/{id} {dto, version, token}
    HTTP->>PMCtrl: request
    PMCtrl->>PMSvc: modifyEmployee(id,dto,version,user)
    activate PMSvc
    PMSvc->>Repo: findById(id)
    Repo->>DB: SELECT ... FOR UPDATE / or get version
    DB-->>Repo: entity
    Repo-->>PMSvc: entity
    PMSvc->>PMSvc: if (entity.version != dto.version) throw OptimisticLock
    alt optimistic lock
        PMSvc-->>PMCtrl: 409 Conflict (stale resource)
        PMCtrl-->>HTTP: 409
        HTTP-->>UI: show conflict -> offer refresh
    else proceed
        PMSvc->>PMSvc: apply changes, recalc fields (e.g., step/rank)
        PMSvc->>Repo: save(entity)
        Repo->>DB: UPDATE employee set ... WHERE id...
        DB-->>Repo: success
        Repo-->>PMSvc: updatedEntity
        PMSvc->>Cache: invalidate employee cache (if exists)
        PMSvc->>AuditQ: publish(EmployeeModifiedEvent)
        PMSvc-->>PMCtrl: 200 + updatedEntity
        PMCtrl-->>HTTP: 200
        HTTP-->>UI: success -> refresh list
    end
```

### 4.4 Filter & Search Employees (Client-Side)
Sequence diagram for the client-side filtering of employees (Search, Department, Rank, Status).

```mermaid
sequenceDiagram
    autonumber
    participant Agent as "Agent (UI)"
    participant Flutter as "Flutter App"
    participant HTTP as "HTTP Client"
    participant Server as "Server API"

    Note over Agent, Server: 1. Initial Data Fetch
    Agent->>Flutter: Open Employees Tab
    Flutter->>HTTP: GET /api/employees
    HTTP->>Server: fetchAllEmployees()
    Server-->>HTTP: List<Employee> (JSON)
    HTTP-->>Flutter: List<Employee>
    Flutter->>Flutter: Store in _allEmployees

    Note over Agent, Flutter: 2. Local Filtering Algorithm
    Agent->>Flutter: Enter Search Query / Select Filter
    activate Flutter
    Flutter->>Flutter: _filterEmployees()
    note right of Flutter: Filter by: <br/>1. Name/ID (contains)<br/>2. Department (exact)<br/>3. Rank (exact)<br/>4. Status (exact)
    Flutter->>Flutter: Update _filteredEmployees
    Flutter-->>Agent: Display Filtered List
    deactivate Flutter
```

### 4.5 Request Retirement (PM)
Sequence diagram for a Project Manager initiating a retirement request for an employee.

```mermaid
sequenceDiagram
    autonumber
    participant PM as "Project Manager"
    participant UI as "Retirement Tab"
    participant HTTP as "HTTP Client"
    participant Ctrl as "PM Controller"
    participant Svc as "PM Service"
    participant Repo as "Employee Repository"
    participant DB as "PostgreSQL"
    participant Audit as "Audit Service"

    PM->>UI: Select Employee & Request Retirement
    UI->>HTTP: POST /api/pm/retireRequests {employeeId}
    HTTP->>Ctrl: createRetireRequest(id)
    Ctrl->>Svc: requestRetirement(id, pmUser)
    activate Svc
    Svc->>Repo: findById(id)
    Repo-->>Svc: employee

    alt Success
        Svc->>Svc: validate(not already requested)
        Svc->>Repo: save(employee.setRetireRequest(true))
        Repo->>DB: UPDATE employee SET retire_request=true...
        DB-->>Repo: success
        Svc->>Audit: logAction("REQUEST_RETIREMENT", employeeId)
        Svc-->>Ctrl: success
        Ctrl-->>HTTP: 200 OK
        HTTP-->>UI: Update Status to "Retirement Requested"
    else Failure
        Svc-->>Ctrl: failure message
        Ctrl-->>HTTP: 400/500 Error
        HTTP-->>UI: Show "Request Failed"
    end

    deactivate Svc
```

### 4.6 Validate Retirement Request (ASM)
Sequence diagram for the validation of a retirement request.

```mermaid
sequenceDiagram
    autonumber
    participant ASM as "ASM (UI)"
    participant UI as "Retirement Tab"
    participant HTTP as "HTTP / RetirementService"
    participant ASMCtrl as "ASM Controller\nPOST /validate"
    participant ASMSvc as "ASM Service"
    participant Repo as "Employee Repository"
    participant DB as "PostgreSQL"
    participant HRArchive as "Archive Service"
    participant AuditQ as "Audit Queue"
    participant Email as "Email/Notif Service"

    ASM->>UI: Click Validate on request id
    UI->>HTTP: POST /api/asm/retireRequests/{id}/validate {token}
    HTTP->>ASMCtrl: request
    ASMCtrl->>ASMSvc: validateRetireRequest(id, actor)
    activate ASMSvc
    ASMSvc->>Repo: findById(id)
    Repo->>DB: SELECT employee...
    DB-->>Repo: employee
    Repo-->>ASMSvc: employeeEntity
    ASMSvc->>ASMSvc: check preconditions (seniority, docs)
    alt preconditions fail
        ASMSvc-->>ASMCtrl: 400 Bad Request (reason)
        ASMCtrl-->>HTTP: 400
        HTTP-->>UI: show error
    else ok
        ASMSvc->>ASMSvc: setStatus(RETIRED), setRetirementDate(now)
        ASMSvc->>Repo: save(employee)
        Repo->>DB: UPDATE employee.status = RETIRED...
        DB-->>Repo: success
        Repo-->>ASMSvc: updatedEntity
        ASMSvc->>HRArchive: sendForArchival(employeeSnapshot)
        HRArchive-->>ASMSvc: ack (async)
        ASMSvc->>AuditQ: publish(RetirementValidatedEvent)
        AuditQ-->>Email: send notification to employee & HR
        ASMSvc-->>ASMCtrl: 200 OK
        ASMCtrl-->>HTTP: 200
        HTTP-->>UI: success -> remove from pending list
    end
```

### 4.7 Create Body (Agent)
Sequence diagram for an Agent creating a new organizational body.

```mermaid
sequenceDiagram
    autonumber
    participant UI as "Agent UI"
    participant HTTP as "HTTP Client"
    participant Ctrl as "Body Controller"
    participant Svc as "Body Service"
    participant Repo as "Body Repository"
    participant DB as "Database"

    UI->>HTTP: Submit Create Body Request
    HTTP->>Ctrl: POST /bodies {dto}

    Ctrl->>Svc: createBody(dto)
    Svc->>Repo: save(entity)
    Repo->>DB: INSERT body...

    alt Success
        DB-->>Repo: OK
        Repo-->>Svc: saved
        Svc-->>Ctrl: success message
        Ctrl-->>HTTP: 201 Created + success msg
        HTTP-->>UI: Show success message
    else Failure
        DB-->>Repo: Error
        Repo-->>Svc: Error
        Svc-->>Ctrl: failure message
        Ctrl-->>HTTP: 400/500 + failure msg
        HTTP-->>UI: Show failure message
    end
```

### 4.8 Department Change
Sequence diagram for changing an employee's department.

```mermaid
sequenceDiagram
    autonumber
    participant PM as "Project Manager"
    participant UI as "Employee Details"
    participant HTTP as "HTTP Client"
    participant Ctrl as "PM Controller"
    participant Svc as "Employee Service"
    participant Repo as "Employee Repository"
    participant DB as "PostgreSQL"

    PM->>UI: Select New Department & Save
    UI->>HTTP: PUT /api/pm/employees/{id}/department {deptId}
    HTTP->>Ctrl: updateDepartment(id, deptId)
    Ctrl->>Svc: changeDepartment(id, deptId)
    activate Svc
    Svc->>Repo: findById(id)
    Repo-->>Svc: employee

    Svc->>Repo: findDepartmentById(deptId)
    Repo-->>Svc: newDepartment

    alt Success
        Svc->>Svc: employee.setDepartment(newDepartment)
        Svc->>Repo: save(employee)
        Repo->>DB: UPDATE employee SET dept_id=...
        DB-->>Repo: success
        Svc-->>Ctrl: updatedEmployee
        Ctrl-->>HTTP: 200 OK
        HTTP-->>UI: Show success & refresh
    else Failure
        Svc-->>Ctrl: failure message
        Ctrl-->>HTTP: 400/500 Error
        HTTP-->>UI: Show failure message
    end

    deactivate Svc
```

### 4.9 Modify Retired Employee
Sequence diagram for modifying a retired employee's information, requiring a Director's code for authorization.

```mermaid
sequenceDiagram
    autonumber
    participant PM as "Project Manager"
    participant UI as "Retiree Details"
    participant HTTP as "HTTP Client"
    participant Ctrl as "PM Controller"
    participant Svc as "PM Service"
    participant Repo as "Employee Repository"
    participant DB as "PostgreSQL"

    PM->>UI: Edit Retiree details
    UI-->>PM: Prompt for Director Code
    PM->>UI: Enter Code & Confirm
    UI->>HTTP: PUT /api/pm/retired-employees/{id} {dto, directorCode}
    HTTP->>Ctrl: updateRetiredEmployee(id, dto, code)
    Ctrl->>Svc: modifyRetiredEmployee(id, dto, code)
    activate Svc
    
    Svc->>Svc: validateDirectorCode(code)
    alt Invalid Code
        Svc-->>Ctrl: throw InvalidAuthException
        Ctrl-->>HTTP: 403 Forbidden
        HTTP-->>UI: Show "Invalid Director Code"
    else Valid Code
        Svc->>Repo: findById(id)
        Repo-->>Svc: employee
        Svc->>Svc: check(employee.status == RETIRED)
        Svc->>Svc: updateFields(employee, dto)
        Svc->>Repo: save(employee)
        Repo->>DB: UPDATE employee ...
        DB-->>Repo: success
        Svc-->>Ctrl: updatedEntity
        Ctrl-->>HTTP: 200 OK
        HTTP-->>UI: Show success
    end
    deactivate Svc
```

### 4.10 Document Extraction
#### 4.10.1 List of Workers
Sequence diagram for generating the full list of employees.

```mermaid
sequenceDiagram
    autonumber
    participant User as "User (PM/Agent)"
    participant UI as "Employees Tab"
    participant HTTP as "HTTP Client"
    participant Ctrl as "Document Controller"
    participant Svc as "Report Service"
    participant Repo as "Employee Repository"
    participant PDF as "PDF Generator"

    User->>UI: Click "Print all employees"
    UI->>HTTP: GET /api/docs/employees/pdf
    HTTP->>Ctrl: generateEmployeeList()
    Ctrl->>Svc: getAllEmployeesForReport()
    Svc->>Repo: findAll()
    Repo-->>Svc: List<Employee>

    alt Success
        Svc->>PDF: generateEmployeeListPdf(list)
        activate PDF
        PDF-->>Svc: byte[] pdfData
        deactivate PDF
        Svc-->>Ctrl: pdfData
        Ctrl-->>HTTP: 200 OK (application/pdf)
        HTTP-->>UI: Open PDF Blob
        UI-->>User: Display/Download PDF
    else Failure
        Svc-->>Ctrl: failure message
        Ctrl-->>HTTP: 400/500 Error
        HTTP-->>UI: Show failure message
    end
```

#### 4.10.2 Work Certificate
Sequence diagram for generating a work certificate for an active employee.

```mermaid
sequenceDiagram
    autonumber
    participant User as "User (PM/Agent)"
    participant UI as "Employee Details"
    participant HTTP as "HTTP Client"
    participant Ctrl as "Document Controller"
    participant Svc as "Report Service"
    participant Repo as "Employee Repository"
    participant PDF as "PDF Generator"

    User->>UI: Click "Work Certificate"
    UI->>HTTP: GET /api/docs/certificate/{id}
    HTTP->>Ctrl: getWorkCertificate(id)
    Ctrl->>Svc: generateCertificate(id)
    Svc->>Repo: findById(id)
    Repo-->>Svc: employee

    alt Success
        Svc->>PDF: generateWorkCertificate(employee)
        activate PDF
        PDF-->>Svc: pdfData
        deactivate PDF
        Svc-->>Ctrl: pdfData
        Ctrl-->>HTTP: 200 OK (application/pdf)
        HTTP-->>UI: Open PDF Blob
    else Failure
        Svc-->>Ctrl: failure message
        Ctrl-->>HTTP: 400/500 Error
        HTTP-->>UI: Show failure message
    end
```

#### 4.10.3 Work Certificate (Retiree)
Sequence diagram for generating a certificate for a retired employee.

```mermaid
sequenceDiagram
    autonumber
    participant User as "Archiver/Agent"
    participant UI as "Archive/Retiree View"
    participant HTTP as "HTTP Client"
    participant Ctrl as "Document Controller"
    participant Svc as "Report Service"
    participant Repo as "Employee Repository"
    participant PDF as "PDF Generator"

    User->>UI: Click "Retirement Certificate"
    UI->>HTTP: GET /api/docs/retire-certificate/{id}
    HTTP->>Ctrl: getRetireCertificate(id)
    Ctrl->>Svc: generateRetireCertificate(id)
    Svc->>Repo: findById(id)
    Repo-->>Svc: employee

    alt Success (Employee is retired)
        Svc->>PDF: generateRetireCertificate(employee)
        PDF-->>Svc: pdfData
        Svc-->>Ctrl: pdfData
        Ctrl-->>HTTP: 200 OK (application/pdf)
        HTTP-->>UI: Open PDF
    else Failure
        Svc-->>Ctrl: failure message
        Ctrl-->>HTTP: 400/500 Error
        HTTP-->>UI: Show failure message
    end
```


## 5. Deployment Diagram
Illustrates the physical architecture of the system including the Spring Boot backend and PostgreSQL database.

```mermaid
graph TD
    subgraph "Client Tier"
        FlutterApp[("Flutter Application (Windows)")]
    end

    subgraph "Application Tier"
        SpringBoot[("Spring Boot Server 
        (Kotlin, hosted on Render)")]
    end

    subgraph "Data Tier"
        PostgreSQL[("PostgreSQL Database
        (Hosted on Aiven)")]
    end

    FlutterApp -- "HTTP / JSON
    (REST API)" --> SpringBoot
    SpringBoot -- "JPA / Hibernate" --> PostgreSQL
```
