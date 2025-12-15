# Project Analysis: Human Resources Management System

## 1. Main System Responsibilities
The Human Resources Management System (HRMS) is designed to manage the lifecycle of employees within an organization structure composed of Bodies and Departments. Its core responsibilities include:

*   **Employee Lifecycle Management**: Onboarding (adding), modifying details, promoting (rank/step), and offboarding (retirement).
*   **Organizational Structure Management**: defining and managing hierarchical structures (Bodies -> Departments) and support hierarchies (Domains -> Specialities).
*   **Role-Based Access Control**: Enforcing strict permission boundaries between different user roles (Project Manager, Agent, ASM/Director).
*   **Document Generation**: producing official PDF documents like Employee Lists and Work Certificates.
*   **Retirement Processing**: A dedicated workflow for handling retirement requests, validation, and status updates.

## 2. Logical Layers & Architecture
The system follows a classic **N-Tier Architecture**, split between a Flutter Frontend and a Spring Boot Backend.

### Frontend (Presentation Layer)
*   **Technology**: Flutter (Dart)
*   **Responsibility**: UI rendering, state management, input validation, and API communication.
*   **Key Modules**:
    *   `pages/`: Top-level screens (HomePage, LoginPage).
    *   `tabs/`: Feature-specific views (EmployeesTab, DepartmentsTab, RetirementTab).
    *   `components/`: Reusable UI widgets (AddEmployeeDialog, SideBar).
    *   `classes/`: Data models mirroring backend entities.
    *   `services/`: (Planned) HTTP client for backend communication.

### Backend (Server Layer)
*   **Technology**: Kotlin with Spring Boot
*   **Responsibility**: Business logic, data consistency, authorization, and persistence.
*   **packages**: `com.gl.hr.server`

#### Layer Breakdown:
1.  **Controller Layer (`.controllers`)**:
    *   **Responsibility**: Handling HTTP REST requests.
    *   **Organization**: Segmented by Actor/Role to enforce security boundaries.
        *   `ASMController`: Endpoints for ASM level operations (Retirement, Grading).
        *   `AgentController`: Standard operational endpoints.
        *   `PersonnelManagerController`: PM specific endpoints.
        *   `common`: Shared endpoints (Auth).

2.  **Service Layer (`.services`)**:
    *   **Responsibility**: Business logic implementation.
    *   **Organization**: Mirrors the controllers.
        *   `ASMService`: Contains logic for validating retirement, modifying grades/specialities, and "Director" authorized actions (e.g., modifying specific employee fields requires a director's code).
        *   `AgentService`: General employee management logic.
    
3.  **Domain Layer (`.models`)**:
    *   **Responsibility**: Defining core business entities and their relationships.
    *   **Key Entities**:
        *   `Employee`: Core entity with `Status` (Active, Retired), `Rank`, `Step`.
        *   `Department`: Grouping of employees.
        *   `Body`: Higher-level organization unit.
        *   `Grade`, `Speciality`, `Domain`.
        *   `User`: System users (PM, AGENT, DIRECTOR) for auth.

4.  **Persistence Layer (`.repositories`)**:
    *   **Responsibility**: Database abstraction using Spring Data JPA.
    *   **Components**: `EmployeeRepository`, `DepartmentRepository`, etc.

## 3. Direction and Type of Dependencies

### Package Dependencies
*   **`controllers` -> `services`**: Controllers inject Services to delegate business processing.
*   **`services` -> `repositories`**: Services inject Repositories to perform CRUD operations.
*   **`repositories` -> `models`**: Repositories manage the lifecycle of Model entities.
*   **`services` -> `models`**: Services manipulate Model state (e.g., `employee.status = Status.RETIRED`).
*   **`dto` (Data Transfer Objects)**: Used across Control and Service layers to decouple API contract from database entities (e.g., `EmployeeDTOPM`, `GradeDTO`).

### Cross-Layer Dependencies
*   **Frontend -> Backend**: The standard dependency is HTTP/JSON. The Frontend `classes` packages effectively duplicate the schema of Backend `models` and `dto` package to ensure compatibility.

## 4. Key System Constraints & Rules identified in Code
*   **Retirement Workflow**: An employee must have `retireRequest = true` before they can be validated as `Status.RETIRED` by the ASM.
*   **Director Authorization**: Modifying sensitive employee data (in `ASMService.modifyEmployee`) requires a strict check of a `directorsCode` against the `DIRECTOR` role user's password.
*   **Hierarchy**: A `Speciality` must belong to a `Domain`. A `Grade` must belong to a `Body`.
