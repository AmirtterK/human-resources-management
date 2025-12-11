# Package Diagram - Human Resource Management System

This document presents the UML Package Diagram for the HR Management System, showing the **logical organization** of the system with package dependencies between layers.

---

## Complete Package Diagram

```mermaid
graph TB
    subgraph HRManagement["HRManagement"]
        direction TB
        
        subgraph UILayer["UI"]
            Pages["Pages<br/>─────────<br/>LoginPage<br/>HomePage"]
            Views["Views<br/>─────────<br/>EmployeesView<br/>DepartmentsView<br/>BodiesView<br/>RetirementView<br/>RequestsView<br/>DomainsView<br/>GradesView"]
            Components["Components<br/>─────────<br/>SideBar<br/>EmployeesTable<br/>StatusChip<br/>Cards<br/>Dialogs"]
        end
        
        subgraph AppLayer["Application Services"]
            AuthService["AuthService"]
            EmployeeService["EmployeeService"]
            DepartmentService["DepartmentService"]
            BodyService["BodyService"]
            DomainService["DomainService"]
            GradeService["GradeService"]
            SpecialityService["SpecialityService"]
            PdfService["PdfService"]
        end
        
        subgraph DomainLayer["Domain Model"]
            EmployeeEntity["Employee"]
            DepartmentEntity["Department"]
            BodyEntity["Body"]
            DomainEntity["Domain"]
            GradeEntity["Grade"]
            SpecialityEntity["Speciality"]
            UserEntity["User"]
            Enums["«enumeration»<br/>Status<br/>Role<br/>Rank"]
        end
        
        subgraph PersistenceLayer["Persistence"]
            EmployeeRepository["EmployeeRepository"]
            DepartmentRepository["DepartmentRepository"]
            BodyRepository["BodyRepository"]
            DomainRepository["DomainRepository"]
            GradeRepository["GradeRepository"]
            SpecialityRepository["SpecialityRepository"]
            UserRepository["UserRepository"]
        end
        
        subgraph InfraLayer["Infrastructure"]
            DatabaseConfig["DatabaseConfig"]
            ExceptionHandler["ExceptionHandler"]
            APIConfig["APIConfig"]
        end
    end
    
    %% Dependencies (dashed arrows)
    UILayer -.->|uses| AppLayer
    UILayer -.->|displays| DomainLayer
    AppLayer -.->|manipulates| DomainLayer
    AppLayer -.->|calls| PersistenceLayer
    PersistenceLayer -.->|persists| DomainLayer
    PersistenceLayer -.->|uses| InfraLayer
    AppLayer -.->|uses| InfraLayer
```

---

## Layered Architecture View

```mermaid
graph TB
    subgraph PresentationLayer["Presentation Layer"]
        UI_Pkg["UI<br/>─────────<br/>• Pages<br/>• Views<br/>• Components<br/>• Dialogs"]
    end
    
    subgraph ApplicationLayer["Application Layer"]
        App_Pkg["Application Services<br/>─────────<br/>• AuthService<br/>• EmployeeService<br/>• DepartmentService<br/>• BodyService<br/>• GradeService<br/>• PdfService"]
    end
    
    subgraph DomainModelLayer["Domain Layer"]
        Domain_Pkg["Domain Model<br/>─────────<br/>• Employee<br/>• Department<br/>• Body<br/>• Domain<br/>• Grade<br/>• Speciality<br/>• User"]
    end
    
    subgraph DataLayer["Persistence Layer"]
        Persistence_Pkg["Persistence<br/>─────────<br/>• EmployeeRepository<br/>• DepartmentRepository<br/>• BodyRepository<br/>• GradeRepository<br/>• UserRepository"]
    end
    
    subgraph InfrastructureLayer["Infrastructure Layer"]
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
    subgraph DomainPkg["Domain"]
        subgraph EntitiesPkg["Entities"]
            Emp["Employee"]
            Dept["Department"]
            Bdy["Body"]
            Dom["Domain"]
            Grd["Grade"]
            Spec["Speciality"]
            Usr["User"]
        end
        
        subgraph ValueObjectsPkg["Value Objects / Enumerations"]
            StatusEnum["«enumeration»<br/>Status<br/>─────────<br/>EMPLOYED<br/>TO_RETIRE<br/>RETIRED"]
            RoleEnum["«enumeration»<br/>Role<br/>─────────<br/>PM<br/>AGENT<br/>ARCHIVER"]
            RankEnum["«enumeration»<br/>Rank<br/>─────────<br/>PRINCIPAL<br/>NORMAL<br/>EXCEPTIONAL"]
        end
    end
    
    Emp -.-> StatusEnum
    Emp -.-> RankEnum
    Emp -.-> Dept
    Emp -.-> Bdy
    Emp -.-> Grd
    Usr -.-> RoleEnum
    Bdy -.-> Dom
    Grd -.-> Spec
    Spec -.-> Bdy
```

---

## Application Services Package Details

```mermaid
graph TB
    subgraph AppServicesPkg["Application Services"]
        subgraph AuthPkg["Authentication"]
            AuthSvc["AuthService<br/>─────────<br/>+ login()<br/>+ logout()<br/>+ resetPassword()"]
            UserAuthSvc["UserAuthService<br/>─────────<br/>+ validateCredentials()<br/>+ verifyDirectorCode()"]
        end
        
        subgraph EmpMgmtPkg["Employee Management"]
            EmpSvc["EmployeeService<br/>─────────<br/>+ getAllEmployees()<br/>+ addEmployee()<br/>+ modifyEmployee()<br/>+ deleteEmployee()"]
        end
        
        subgraph OrgMgmtPkg["Organization Management"]
            DeptSvc["DepartmentService<br/>─────────<br/>+ getDepartments()<br/>+ addDepartment()"]
            BodySvc["BodyService<br/>─────────<br/>+ getBodies()<br/>+ addBody()"]
            DomSvc["DomainService<br/>─────────<br/>+ getDomains()<br/>+ addDomain()"]
            GrdSvc["GradeService<br/>─────────<br/>+ getGrades()<br/>+ addGrade()"]
        end
        
        subgraph UtilPkg["Utilities"]
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
