# Package Diagram - Human Resource Management System

This document presents the UML Package Diagram for the HR Management System, showing the **logical organization** of the system with package dependencies between layers.

---

## Complete Package Diagram

```mermaid
graph TB
    subgraph HRManagement["HRManagement"]
        direction TB
        
        subgraph UI["UI"]
            Pages["Pages<br/>─────────<br/>LoginPage<br/>HomePage"]
            Views["Views<br/>─────────<br/>EmployeesView<br/>DepartmentsView<br/>BodiesView<br/>RetirementView<br/>RequestsView<br/>DomainsView<br/>GradesView"]
            Components["Components<br/>─────────<br/>SideBar<br/>EmployeesTable<br/>StatusChip<br/>Cards<br/>Dialogs"]
        end
        
        subgraph Application["Application Services"]
            AuthService["AuthService"]
            EmployeeService["EmployeeService"]
            DepartmentService["DepartmentService"]
            BodyService["BodyService"]
            DomainService["DomainService"]
            GradeService["GradeService"]
            SpecialityService["SpecialityService"]
            PdfService["PdfService"]
        end
        
        subgraph Domain["Domain Model"]
            Employee["Employee"]
            Department["Department"]
            Body["Body"]
            Domain["Domain"]
            Grade["Grade"]
            Speciality["Speciality"]
            User["User"]
            Enums["«enumeration»<br/>Status<br/>Role<br/>Rank"]
        end
        
        subgraph Persistence["Persistence"]
            EmployeeRepository["EmployeeRepository"]
            DepartmentRepository["DepartmentRepository"]
            BodyRepository["BodyRepository"]
            DomainRepository["DomainRepository"]
            GradeRepository["GradeRepository"]
            SpecialityRepository["SpecialityRepository"]
            UserRepository["UserRepository"]
        end
        
        subgraph Infrastructure["Infrastructure"]
            DatabaseConfig["DatabaseConfig"]
            ExceptionHandler["ExceptionHandler"]
            APIConfig["APIConfig"]
        end
    end
    
    %% Dependencies (dashed arrows)
    UI -.->|uses| Application
    UI -.->|displays| Domain
    Application -.->|manipulates| Domain
    Application -.->|calls| Persistence
    Persistence -.->|persists| Domain
    Persistence -.->|uses| Infrastructure
    Application -.->|uses| Infrastructure
```

---

## Layered Architecture View

```mermaid
graph TB
    subgraph "Presentation Layer"
        UI_Pkg["UI<br/>─────────<br/>• Pages<br/>• Views<br/>• Components<br/>• Dialogs"]
    end
    
    subgraph "Application Layer"
        App_Pkg["Application Services<br/>─────────<br/>• AuthService<br/>• EmployeeService<br/>• DepartmentService<br/>• BodyService<br/>• GradeService<br/>• PdfService"]
    end
    
    subgraph "Domain Layer"
        Domain_Pkg["Domain Model<br/>─────────<br/>• Employee<br/>• Department<br/>• Body<br/>• Domain<br/>• Grade<br/>• Speciality<br/>• User"]
    end
    
    subgraph "Persistence Layer"
        Persistence_Pkg["Persistence<br/>─────────<br/>• EmployeeRepository<br/>• DepartmentRepository<br/>• BodyRepository<br/>• GradeRepository<br/>• UserRepository"]
    end
    
    subgraph "Infrastructure Layer"
        Infra_Pkg["Infrastructure<br/>─────────<br/>• Database<br/>• ExceptionHandler<br/>• Configuration"]
    end
    
    UI_Pkg -.->|depends on| App_Pkg
    UI_Pkg -.->|depends on| Domain_Pkg
    App_Pkg -.->|depends on| Domain_Pkg
    App_Pkg -.->|depends on| Persistence_Pkg
    Persistence_Pkg -.->|depends on| Domain_Pkg
    Persistence_Pkg -.->|depends on| Infra_Pkg
```

---

## Domain Package Details

```mermaid
graph TB
    subgraph Domain["Domain"]
        subgraph Entities["Entities"]
            Employee["Employee"]
            Department["Department"]
            Body["Body"]
            DomainEntity["Domain"]
            Grade["Grade"]
            Speciality["Speciality"]
            User["User"]
        end
        
        subgraph ValueObjects["Value Objects / Enumerations"]
            Status["«enumeration»<br/>Status<br/>─────────<br/>EMPLOYED<br/>TO_RETIRE<br/>RETIRED"]
            Role["«enumeration»<br/>Role<br/>─────────<br/>PM<br/>AGENT<br/>ARCHIVER"]
            Rank["«enumeration»<br/>Rank<br/>─────────<br/>PRINCIPAL<br/>NORMAL<br/>EXCEPTIONAL"]
        end
    end
    
    Employee -.-> Status
    Employee -.-> Rank
    Employee -.-> Department
    Employee -.-> Body
    Employee -.-> Grade
    User -.-> Role
    Body -.-> DomainEntity
    Grade -.-> Speciality
    Speciality -.-> Body
```

---

## Application Services Package Details

```mermaid
graph TB
    subgraph ApplicationServices["Application Services"]
        subgraph Authentication["Authentication"]
            AuthSvc["AuthService<br/>─────────<br/>+ login()<br/>+ logout()<br/>+ resetPassword()"]
            UserAuthSvc["UserAuthService<br/>─────────<br/>+ validateCredentials()<br/>+ verifyDirectorCode()"]
        end
        
        subgraph EmployeeManagement["Employee Management"]
            EmpSvc["EmployeeService<br/>─────────<br/>+ getAllEmployees()<br/>+ addEmployee()<br/>+ modifyEmployee()<br/>+ deleteEmployee()"]
        end
        
        subgraph OrganizationManagement["Organization Management"]
            DeptSvc["DepartmentService<br/>─────────<br/>+ getDepartments()<br/>+ addDepartment()"]
            BodySvc["BodyService<br/>─────────<br/>+ getBodies()<br/>+ addBody()"]
            DomainSvc["DomainService<br/>─────────<br/>+ getDomains()<br/>+ addDomain()"]
            GradeSvc["GradeService<br/>─────────<br/>+ getGrades()<br/>+ addGrade()"]
        end
        
        subgraph Utilities["Utilities"]
            PdfSvc["PdfService<br/>─────────<br/>+ generatePDF()<br/>+ generateCertificate()"]
        end
    end
```

---

## Package Dependencies Summary

| Package | Depends On | Description |
|---------|------------|-------------|
| **UI** | Application Services, Domain | User interface layer displaying domain data |
| **Application Services** | Domain, Persistence | Business logic and use case orchestration |
| **Domain** | - | Core business entities and enumerations |
| **Persistence** | Domain, Infrastructure | Data access repositories |
| **Infrastructure** | - | Cross-cutting concerns (DB, Config, Exceptions) |

---

## Notation Legend

| Symbol | Meaning |
|--------|---------|
| `-.->` | Dependency (dashed arrow) |
| `«enumeration»` | Stereotype for enum types |
| Package box | Logical grouping of related elements |
| Nested package | Sub-package within parent package |
