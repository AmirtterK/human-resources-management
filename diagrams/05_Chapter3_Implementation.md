# Chapter 3: Implementation

## 1. Introduction
This chapter details the technical realization of the HMRS, including the development environment, software architecture, and security mechanisms implemented.

## 2. Development Tools and Environment

### 2.1 Hardware Environment
- **Development Machine**: Windows 10/11 Workstation
- **Mobile Testing**: Android Emulator (Pixel 6 API 33) / Physical Android Device

### 2.2 Software Environment
- **IDE**: Visual Studio Code
- **SDK**: Flutter SDK 3.8.1+
- **Language**: Dart 3.0+
- **Version Control**: Git / GitHub
- **Diagramming**: Mermaid.js

## 3. Technology Stack

### 3.1 Frontend: Flutter
We chose **Flutter** for its ability to compile to native code for multiple platforms (Windows, Android, Web) from a single codebase.
- **Widgets**: Uses Material Design components for a native look and feel.
- **State management**: Utilizes `setState` for local UI state and `FutureBuilder` for asynchronous data handling.
- **Routing**: Implemented using `go_router` for deep linking and navigation simplified maintenance.

### 3.2 Backend: REST API
The system connects to a remote REST API hosted on Render (`https://hr-server-3s0m.onrender.com`).
- **Protocol**: HTTPS (Secure HTTP)
- **Data Format**: JSON (JavaScript Object Notation)

## 4. Software Architecture: MVC
We implemented the **Model-View-Controller (MVC)** pattern to separate concerns and improve maintainability.

### 4.1 Model Layer
Located in `lib/classes/` and `lib/services/`.
- **Classes**: `Employee`, `Department`, `Body` encapsulate data and JSON serialization logic (`fromJson`, `toJson`).
- **Services**: `EmployeeService`, `DepartmentService` handle all HTTP requests and business logic.

### 4.2 View Layer
Located in `lib/components/` and `lib/tabs/`.
- **Components**: Reusable widgets like `EmployeesTable`, `DepartmentCard`, `AddEmployeeDialog`.
- **Tabs**: Screen content like `EmployeesTab`, `DepartmentsTab`.

### 4.3 Controller Layer
Located in `lib/pages/`.
- **Pages**: `HomePage` manages global state (current tab, sidebar selection) and `LoginPage` handles authentication state.

## 5. Security Mechanisms

### 5.1 Role-Based Access Control (RBAC)
The system enforces security privileges based on user roles defined in `Code/types.dart`:
- **PM**: Full access to modification and deletion.
- **Agent**: Can view and modify but cannot delete critical records.
- **Archiver**: Read-only access to historical data.

### 5.2 Network Security
- **HTTPS**: All API communications are encrypted.
- **Timeouts**: API requests have a configured 60-second timeout to prevent indefinite hanging on poor connections.
- **Error Handling**: Graceful degradation when the server is unreachable.
