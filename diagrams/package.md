# Package Diagram - Human Resource Management System

This document presents the UML Package Diagram for the HR Management System, showing the **logical organization** of the system with package dependencies between layers.

---

## Complete Package Diagram

```mermaid
graph LR
    subgraph UILayer["UI"]
        Pages["Pages"]
        Views["Views"]
        Components["Components"]
    end
    
    subgraph AppLayer["Application Services"]
        AuthService["AuthService"]
        EmployeeService["EmployeeService"]
        DepartmentService["DepartmentService"]
        BodyService["BodyService"]
        DomainService["DomainService"]
        GradeService["GradeService"]
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
        Enums["Status / Role / Rank"]
    end
    
    subgraph PersistenceLayer["Persistence"]
        EmployeeRepo["EmployeeRepository"]
        DepartmentRepo["DepartmentRepository"]
        BodyRepo["BodyRepository"]
        DomainRepo["DomainRepository"]
        GradeRepo["GradeRepository"]
        UserRepo["UserRepository"]
    end
    
    subgraph InfraLayer["Infrastructure"]
        DatabaseConfig["DatabaseConfig"]
        ExceptionHandler["ExceptionHandler"]
        APIConfig["APIConfig"]
    end

    UILayer -.-> AppLayer
    UILayer -.-> DomainLayer
    AppLayer -.-> DomainLayer
    AppLayer -.-> PersistenceLayer
    PersistenceLayer -.-> DomainLayer
    PersistenceLayer -.-> InfraLayer
```

---

## Layered Architecture View

```mermaid
graph LR
    UI_Pkg["UI<br/>───────<br/>Pages<br/>Views<br/>Components"]
    App_Pkg["Application Services<br/>───────<br/>AuthService<br/>EmployeeService<br/>DepartmentService<br/>BodyService<br/>GradeService"]
    Domain_Pkg["Domain Model<br/>───────<br/>Employee<br/>Department<br/>Body<br/>Domain<br/>Grade<br/>User"]
    Persistence_Pkg["Persistence<br/>───────<br/>EmployeeRepository<br/>DepartmentRepository<br/>BodyRepository<br/>GradeRepository"]
    Infra_Pkg["Infrastructure<br/>───────<br/>Database<br/>ExceptionHandler<br/>Configuration"]

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
graph LR
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
        
        subgraph ValuesPkg["Enumerations"]
            StatusEnum["Status"]
            RoleEnum["Role"]
            RankEnum["Rank"]
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
```

---

## Application Services Package Details

```mermaid
graph LR
    subgraph AppServicesPkg["Application Services"]
        subgraph AuthPkg["Authentication"]
            AuthSvc["AuthService"]
            UserAuthSvc["UserAuthService"]
        end
        
        subgraph EmpMgmtPkg["Employee Management"]
            EmpSvc["EmployeeService"]
        end
        
        subgraph OrgMgmtPkg["Organization Management"]
            DeptSvc["DepartmentService"]
            BodySvc["BodyService"]
            DomSvc["DomainService"]
            GrdSvc["GradeService"]
        end
        
        subgraph UtilPkg["Utilities"]
            PdfSvc["PdfService"]
        end
    end
```

---

## Package Dependencies Summary

| Package | Depends On | Description |
|---------|------------|-------------|
| **UI** | Application Services, Domain | User interface layer |
| **Application Services** | Domain, Persistence | Business logic layer |
| **Domain** | - | Core entities and enumerations |
| **Persistence** | Domain, Infrastructure | Data access layer |
| **Infrastructure** | - | Cross-cutting concerns |

---

## Notation Legend

| Symbol | Meaning |
|--------|---------|
| `-.->` | Dependency (dashed arrow) |
| Package box | Logical grouping of related elements |
