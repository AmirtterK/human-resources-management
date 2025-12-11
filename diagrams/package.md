# Package Diagram - Human Resource Management System

This document presents the package diagram for the complete HR Management System, showing both the **Flutter Frontend** and **Spring Boot Backend** architectures and their relationships.

----

## System Overview

```mermaid
graph TB
    subgraph "HR Management System"
        direction TB
        FE["Frontend (Flutter)"]
        BE["Backend (Spring Boot/Kotlin)"]
        DB[(PostgreSQL Database)]
        
        FE <-->|HTTP/REST API| BE
        BE <-->|JPA/Hibernate| DB
    end
```

---

## Complete Package Diagram

```mermaid
graph TB
    subgraph Frontend["Frontend - Flutter Application"]
        direction TB
        
        subgraph FE_UI["ui"]
            subgraph FE_Pages["pages"]
                LoginPage["LoginPage"]
                HomePage["HomePage"]
            end
            
            subgraph FE_Tabs["tabs"]
                EmployeesTab["EmployeesTab"]
                DepartmentsTab["DepartmentsTab"]
                BodiesTab["BodiesTab"]
                RetirementTab["RetirementTab"]
                RequestsTab["RequestsTab"]
                DomainsTab["DomainsTab"]
                GradesTab["GradesTab"]
                ExtendedBodiesTab["ExtendedBodiesTab"]
                ExtendedDepartmentsTab["ExtendedDepartmentsTab"]
                ExtendedGradesTab["ExtendedGradesTab"]
            end
            
            subgraph FE_Components["components"]
                SideBar["SideBar"]
                EmployeesTable["EmployeesTable"]
                StatusChip["StatusChip"]
                DepartmentCard["DepartmentCard"]
                BodieCard["BodieCard"]
                DomainCard["DomainCard"]
                AuthDialog["AuthinticationDialog"]
                AddEmployeeDialog["AddEmployeeDialog"]
                ModifyEmployeeDialog["ModifyEmployeeDialog"]
                ModifyRetireeDialog["ModifyRetireeDialog"]
                ForgotPasswordDialog["ForgotPasswordDialog"]
            end
        end
        
        subgraph FE_Services["services"]
            AuthService["auth_service"]
            EmployeeService["employee_service"]
            DepartmentService["department_service"]
            BodyService["body_service"]
            DomainService["domain_service"]
            GradeService["grade_service"]
            SpecialityService["speciality_service"]
            PdfService["pdf_service"]
        end
        
        subgraph FE_Domain["domain"]
            subgraph FE_Classes["classes"]
                Employee["Employee"]
                Department["Department"]
                Body["Body"]
                Domain["Domain"]
                Grade["Grade"]
                Speciality["Speciality"]
                Types["types (User, Status)"]
            end
            
            subgraph FE_Data["data"]
                AppData["data.dart"]
            end
        end
    end
    
    subgraph Backend["Backend - Spring Boot (Kotlin)"]
        direction TB
        
        subgraph BE_Controllers["controllers"]
            ASMController["ASMController"]
            AgentController["AgentController"]
            PMController["PersonnelManagerController"]
            AuthController["AuthController"]
            CommonController["CommonController"]
        end
        
        subgraph BE_Services["services"]
            ASMService["ASMService"]
            AgentService["AgentService"]
            PMService["PersonnelManagerService"]
            UserAuthService["UserAuthService"]
            CommonService["CommonService"]
        end
        
        subgraph BE_DTOs["dto"]
            EmployeeDTOPM["EmployeeDTOPM"]
            BodyDTO["BodyDTO"]
            GradeDTO["GradeDTO"]
        end
        
        subgraph BE_Models["models"]
            BE_Employee["Employee"]
            BE_Department["Department"]
            BE_Body["Body"]
            BE_Domain["Domain"]
            BE_Grade["Grade"]
            BE_Speciality["Speciality"]
            BE_User["User"]
            BE_Role["Role"]
            BE_Rank["Rank"]
            BE_Status["Status"]
        end
        
        subgraph BE_Repositories["repositories"]
            EmployeeRepo["EmployeeRepository"]
            DepartmentRepo["DepartmentRepository"]
            BodyRepo["BodyRepository"]
            DomainRepo["DomainRepository"]
            GradeRepo["GradeRepository"]
            SpecialityRepo["SpecialityRepository"]
            UserRepo["UserRepository"]
        end
        
        subgraph BE_Core["core"]
            HrServerApp["HrServerApplication"]
            DbInit["DatabaseInitializer"]
            Exceptions["Exceptions"]
            ExHandler["GlobalExceptionHandler"]
        end
    end
    
    subgraph Database["PostgreSQL Database"]
        direction TB
        DB_Tables[("employees<br/>departments<br/>bodies<br/>domains<br/>grades<br/>specialities<br/>users")]
    end

    %% Frontend internal dependencies
    FE_Pages --> FE_Tabs
    FE_Pages --> FE_Components
    FE_Tabs --> FE_Components
    FE_Tabs --> FE_Services
    FE_Components --> FE_Services
    FE_Components --> FE_Classes
    FE_Services --> FE_Classes
    FE_Tabs --> FE_Classes
    FE_Data --> FE_Classes
    
    %% Backend internal dependencies
    BE_Controllers --> BE_Services
    BE_Controllers --> BE_DTOs
    BE_Services --> BE_Repositories
    BE_Services --> BE_Models
    BE_DTOs --> BE_Models
    BE_Repositories --> BE_Models
    BE_Core --> BE_Models
    
    %% Cross-layer communication
    FE_Services <-.->|REST API| BE_Controllers
    BE_Repositories <-.->|JPA| Database
```

---

## Frontend Package Structure

| Package | Description | Key Files |
|---------|-------------|-----------|
| **pages** | Main application screens | `LoginPage`, `HomePage` |
| **tabs** | Content tabs for different modules | `EmployeesTab`, `DepartmentsTab`, `RequestsTab`, etc. |
| **components** | Reusable UI widgets | `SideBar`, `EmployeesTable`, `StatusChip`, dialogs |
| **services** | API communication layer | `employee_service`, `auth_service`, `pdf_service`, etc. |
| **classes** | Domain models | `Employee`, `Department`, `Body`, `Domain`, `Grade` |
| **data** | Application state | `data.dart` (global state) |

---

## Backend Package Structure

| Package | Description | Key Files |
|---------|-------------|-----------|
| **controllers** | REST API endpoints | `ASMController`, `PMController`, `AgentController` |
| **services** | Business logic layer | `ASMService`, `PersonnelManagerService`, `AgentService` |
| **dto** | Data Transfer Objects | `EmployeeDTOPM`, `BodyDTO`, `GradeDTO` |
| **models** | JPA entities | `Employee`, `Department`, `Body`, `User`, `Role` |
| **repositories** | Data access layer | `EmployeeRepository`, `DepartmentRepository`, etc. |
| **core** | Application setup | `HrServerApplication`, `DatabaseInitializer` |

---

## Layer Dependencies

```mermaid
graph LR
    subgraph "Frontend Layers"
        UI["UI Layer<br/>(pages, tabs, components)"]
        SVC["Service Layer<br/>(services)"]
        DOM["Domain Layer<br/>(classes, data)"]
        
        UI --> SVC
        UI --> DOM
        SVC --> DOM
    end
    
    subgraph "Backend Layers"
        CTRL["Controller Layer<br/>(controllers)"]
        BSVC["Service Layer<br/>(services)"]
        REPO["Repository Layer<br/>(repositories)"]
        MDL["Model Layer<br/>(models, dto)"]
        
        CTRL --> BSVC
        CTRL --> MDL
        BSVC --> REPO
        BSVC --> MDL
        REPO --> MDL
    end
    
    SVC <-.->|HTTP| CTRL
```

---

## User Role Access Mapping

```mermaid
graph TB
    subgraph "Role-Based Access"
        PM["Personnel Manager (PM)"]
        Agent["Agent"]
        ASM["Archive Manager (ASM)"]
    end
    
    subgraph "Backend Controllers"
        PMCtrl["PersonnelManagerController<br/>/api/pm/*"]
        AgentCtrl["AgentController<br/>/api/agent/*"]
        ASMCtrl["ASMController<br/>/api/asm/*"]
        CommonCtrl["CommonController<br/>/api/common/*"]
    end
    
    PM --> PMCtrl
    Agent --> AgentCtrl
    ASM --> ASMCtrl
    PM --> CommonCtrl
    Agent --> CommonCtrl
    ASM --> CommonCtrl
```

---

## Technology Stack Summary

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter (Dart) |
| **Backend** | Spring Boot (Kotlin) |
| **Database** | PostgreSQL |
| **API** | REST (JSON) |
| **ORM** | Spring Data JPA / Hibernate |
