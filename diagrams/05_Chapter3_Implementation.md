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

### 3.2 Backend: Spring Boot (Kotlin)
The backend is a robust REST API developed using **Spring Boot** with **Kotlin**.
- **Framework**: Spring Boot 3.0+
- **Language**: Kotlin 1.8+
- **Build Tool**: Gradle (Kotlin DSL)
- **Database**: PostgreSQL (Production) / H2 (Development)
- **ORM**: Hibernate / Spring Data JPA
- **Hosting**: Render.com

## 4. Software Architecture: Full Stack
We implemented a **Multi-Tier Architecture** connecting the Flutter client to the Spring Boot backend.

### 4.1 Client Tier (Flutter)
- **MVC Pattern**: Separates logic (Pages/Processors) from UI (Widgets).
- **Service Layer**: HTTP clients (`EmployeeService`) act as a bridge to the backend.

### 4.2 Application Tier (Spring Boot)
- **Controller Layer**: REST endpoints (`EmployeeController`, `AuthController`) handling HTTP requests.
- **Service Layer**: Business logic implementation (`EmployeeService`, `AuthService`).
- **Data Access Layer**: Repositories extending `JpaRepository` for database interactions.
- **DTO Pattern**: Data Transfer Objects isolate internal entities from API contracts.

### 4.3 Data Tier
- **PostgreSQL**: Relational database storing all persistent data with rigid schema enforcement.

## 5. Security Mechanisms

### 5.1 Authentication & Authorization
- **Token-Based Auth**: Users authenticate via `AuthController` to receive a session token (implementation ready).
- **Role-Based Access Control (RBAC)**: Backend endpoints are secured based on roles (PM, Agent, Archiver).

### 5.2 Network Security
- **HTTPS**: All API communications are encrypted.
- **CORS Configuration**: Restricted cross-origin resource sharing to trusted clients.
- **Input Validation**: Backend validation (`@Valid` via Hibernate Validator) prevents SQL injection.
