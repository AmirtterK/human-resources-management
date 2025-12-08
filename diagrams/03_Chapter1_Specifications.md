# Chapter 1: Specifications

## 1. Introduction
This chapter outlines the detailed requirements of the HRMS. It serves as the foundation for the system design and implementation, created during the Inception phase of RUP.

## 2. Functional Requirements
The system must allow users to perform the following actions:

### 2.1 Employee Management
- **Add Employee**: Create new employee records with detailed attributes (Rank, Category, Specialty, Department, Body).
- **Modify Employee**: Update existing information, including promotion (rank/step adjustment).
- **View Employees**: List all employees with status indicators (Employed, To Retire, Retired).
- **Request Retirement for an Employee**: Send a retirement request to the ASM (PM role only).
- **Modify Retired Emplyee**: Update existing information of a retired employee, with the authentication of the director.
- **Search**: Filter employees by ID or Name.

### 2.2 Organization Management
- **Manage Departments**: detailed view of departments including staff counts and head names.
- **Manage Bodies**: structural entities with bilingual (English/Arabic) support.
- **Domains**: Manage operational domains.

### 2.3 Retirement Management
- **Accept/Deny Retirement of an Employee**: Accept and deny a retirement request (ASM role only).
- **Process Requests**: Handle retirement requests and update status to "Retired".

### 2.4 Access Control
- **Authentication**: Secure login system.
- **Role Management**: Support for different user roles:
  - **PM (Project Manager)**: Full administrative access.
  - **Agent**: Operational access.
  - **Archiver**: Read-only/Historical access.

### 2.5 Document Generation ("Extraction of Papers")
- **Employee List Extraction**: Ability to generate and print the full list of employees as a PDF document.
- **Work Certificate**: Generate a formal "Work Certificate" PDF for any selected employee, including their details and a signature placeholder.

## 3. Non-Functional Requirements
- **Usability**: The interface must be intuitive, following Material Design guidelines.
- **Performance**: The application should respond to user inputs within 1 second.
- **Reliability**: API connections must handle timeouts (set to 60 seconds) gracefully.
- **Portability**: The system must run on Windows Desktop and supports.
- **Localization**: Support for mixed content (English UI with Arabic data fields).


