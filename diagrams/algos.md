# System Algorithms

This document formally describes the key algorithms used in the Human Resources Management System.

## 1. Authentication

### Algorithm: Login
**Goal**: Authenticate a user and return their role.
**Input**: 
*   `username`: String
*   `password`: String
**Output**: `Role` (Enum) or Exception

```algo
Algorithm Login(username, password)
Begin
    user ← FindUserByUsername(username)
    
    If user is NULL Then
        Throw InvalidUsernameOrPasswordException
    End If
    
    If user.password ≠ password Then
        Throw InvalidUsernameOrPasswordException
    End If
    
    Return user.role
End
```

### Algorithm: ResetPasswordByDirector
**Goal**: Allow a Director to reset another user's password.
**Input**: 
*   `directorsCode`: String
*   `targetUsername`: String
*   `newPassword`: String
**Output**: Void or Exception

```algo
Algorithm ResetPassword(directorsCode, targetUsername, newPassword)
Begin
    director ← FindUserByRole(DIRECTOR)
    
    If director is NULL Then
        Throw UserNotFoundByRoleException
    End If
    
    If director.password ≠ directorsCode Then
        Throw AccessDeniedException
    End If
    
    targetUser ← FindUserByUsername(targetUsername)
    
    If targetUser is NULL Then
        Throw UserNotFoundByUsernameException
    End If
    
    targetUser.password ← newPassword
    Save(targetUser)
End
```

## 2. Retirement Operations

### Algorithm: ValidateRetirementRequest
**Goal**: Finalize the retirement process for an employee.
**Input**: 
*   `employeeId`: Long
**Output**: Void or Exception

```algo
Algorithm ValidateRetirement(employeeId)
Begin
    employee ← FindEmployeeById(employeeId)
    
    If employee is NULL Then
        Throw EmployeeNotFoundException
    End If
    
    employee.retireRequest ← False
    employee.status ← RETIRED
    
    Save(employee)
End
```

## 3. Employee Modifications

### Algorithm: ModifyEmployeeByASM
**Goal**: Allow ASM (Admin) to override employee data with Director's authorization.
**Input**: 
*   `employeeId`: Long
*   `directorsCode`: String
*   `data`: EmployeeDTO (Contains new DepartmentId, SpecialityId, etc.)
**Output**: Void or Exception

```algo
Algorithm ModifyEmployeeByASM(employeeId, directorsCode, data)
Begin
    // 1. Authorize
    director ← FindUserByRole(DIRECTOR)
    If director.password ≠ directorsCode Then
        Throw AccessDeniedException
    End If
    
    // 2. Fetch & Validate Target
    employee ← FindEmployeeById(employeeId)
    If employee is NULL Then
        Throw EmployeeNotFoundException
    End If
    
    If employee.status ≠ ACTIVE Then
        Throw AccessDeniedException
    End If
    
    // 3. Validate Dependencies
    department ← FindDepartmentById(data.departmentId)
    If department is NULL Then
        Throw DepartmentNotFoundException
    End If
    
    speciality ← FindSpecialityById(data.specialityId)
    If speciality is NULL Then
        Throw SpecialtyNotFoundException
    End If
    
    // 4. Update Fields
    employee.firstName ← data.firstName
    employee.lastName ← data.lastName
    employee.dateOfBirth ← data.dateOfBirth
    employee.address ← data.address
    employee.originalRank ← data.originalRank
    employee.currentRank ← data.originalRank
    employee.step ← data.step
    employee.reference ← data.reference
    employee.retireRequest ← data.retireRequest
    
    // 5. Update Relations
    employee.department ← department
    employee.speciality ← speciality
    
    Save(employee)
End
```

## 4. Entity Construction

### Algorithm: CreateGrade
**Goal**: Create a new grade associated with a body.
**Input**: 
*   `bodyId`: Long
*   `gradeData`: GradeDTO
**Output**: Void or Exception

```algo
Algorithm CreateGrade(bodyId, gradeData)
Begin
    body ← FindBodyById(bodyId)
    
    If body is NULL Then
        Throw BodyNotFoundException
    End If
    
    newGrade ← New Grade()
    newGrade.code ← gradeData.code
    newGrade.designationFR ← gradeData.designationFR
    newGrade.designationAR ← gradeData.designationAR
    newGrade.body ← body
    
    Save(newGrade)
End
```

### Algorithm: CreateSpeciality
**Goal**: Create a new speciality within a domain.
**Input**: 
*   `domainId`: Long
*   `name`: String
**Output**: Speciality

```algo
Algorithm CreateSpeciality(domainId, name)
Begin
    domain ← FindDomainById(domainId)
    
    If domain is NULL Then
        Throw DomainNotFoundException
    End If
    
    newSpeciality ← New Speciality()
    newSpeciality.name ← name
    newSpeciality.domain ← domain
    
    return Save(newSpeciality)
End
```
