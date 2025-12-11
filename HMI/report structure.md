Human Resources Management System
HMI Project Report
Course: Human–Machine Interface (HMI)
Level: L3 Computer Science
Academic Year: 2025/2026
________________________________________
1. Introduction
1.1 Project Presentation
This report presents the Human Resources Management System, a comprehensive Flutter-based application designed to streamline HR operations. The system provides a unified interface for managing employees, departments, organizational bodies, retirement processes, and administrative requests.
1.2 Context
In modern organizations, efficient human resource management is crucial. Traditional paper-based or fragmented digital systems lead to:
•	Inefficient data access and retrieval
•	Poor user experience for HR staff
•	Increased cognitive load and errors
This application addresses these challenges by applying HMI principles to create an intuitive, efficient, and user-centered interface.
1.3 Objectives
•	Primary: Develop a user-friendly interface that reduces cognitive load and increases productivity
•	Secondary: Apply ergonomic principles and HMI design methodologies
•	Implement direct manipulation paradigm for intuitive interactions
•	Ensure consistency across all interface components

2. Analysis
2.1 User Identification
The system identifies three primary user roles:
Role	Description	Access Level
Project Manager (PM)	Full administrative access	Complete CRUD operations
Agent	Standard HR operations	View & Edit operations
Archiver	Read-only access	View only
2.2 Task Analysis
Based on interaction cycle theory (users act → system responds → users perceive → users act again), the main tasks are:
Task Category	Specific Tasks	Interaction Type
Input Tasks	Add employees, create departments	Form-based input
Selection Tasks	Filter employees, choose departments	Menu & dropdown selection
Action Tasks	Approve retirement, modify records	Button triggers
Specification Tasks	Configure settings, set filters	Dialog-based
2.3 Usage Context
•	Environment: Desktop/web-based HR office environment
•	Frequency: Daily use by HR personnel
•	Criticality: High - affects employee records and organizational structure
 
3. Architecture
3.1 Chosen Model: MVC (Model-View-Controller)
The application follows the MVC architectural pattern, adapted for Flutter's reactive framework:  
4.3 Ergonomic Principles Applied
4.3.1 Color System
Color	Hex Code	Usage	Psychological Effect
Primary (Teal)	#09866F	Actions, highlights	Trust, stability
Success (Green)	Semantic	Confirmations	Positive feedback
Error (Red)	Semantic	Errors, warnings	Alert, attention
Background	#F5F5F5	Content areas	Reduces eye strain
4.3.2 Typography
•	Primary Font: Trap (custom font)
•	Fallback: Alfont (Arabic support)
•	Hierarchy: Font weights 300-900 for visual structure
4.3.3 Button States (Following GUI Standards)
 
4.4 Dialog Design Guidelines
Following the course principles for Dialog Boxes:
•	✅ Maximum 5 buttons per dialog
•	✅ Always include OK/Cancel actions
•	✅ Input validation before submission
•	✅ Clear error messages


5. Implementation
5.1 Technology Stack
Layer	Technology	Justification
Frontend	Flutter 3.8+	Cross-platform, reactive UI framework
Language	Dart	Strong typing, async/await support
Routing	go_router	Declarative navigation
State	setState + StatefulWidgets	Simple, effective for this scale
5.2 Interface Screens
5.2.1 Main Navigation (7 Tabs)
Tab	Icon	Content	Key Interactions
Employees	👥	Employee table with search/filter	Add, Modify, Delete
Departments	🏢	Department cards grid	View details, Assign
Retirement	📅	Retirement management	Approve, Modify dates
Bodies	🏛️	Organizational units	Add, View members
Requests	📋	HR request queue	Approve, Reject
Domains	🌐	Domain management	CRUD operations
Settings	⚙️	App configuration	Preferences
5.2.2 Interaction Types Implemented
Based on Chapter 4 - Interaction Tasks:
Interaction Type	Implementation	Example
Text Input	TextFormField	Employee name entry
Selection (Single)	DropdownButtonFormField	Status selection
Selection (Multiple)	Checkbox lists	Role assignment
Direct Manipulation	DataTable rows	Click to select/edit
Drag & Drop	Planned	Future enhancement
5.3 Error Management
Following Chapter 4 - Error Handling principles:
Prevention Strategies:
•	✅ Form validation before submission
•	✅ Disabled buttons for invalid states
•	✅ Required field indicators
Correction Strategies:
•	✅ Clear error messages below input fields
•	✅ Red border highlighting on errors
•	✅ Undo capability via cancel buttons
5.4 Help System
Help Type	Implementation
Contextual	Tooltips on hover
Factual	Label descriptions
Procedural	Form placeholders



6. Conclusion
6.1 Summary
This Human Resources Management System successfully applies HMI principles to create an effective, user-centered interface:
•	✅ MVC Architecture provides clear separation of concerns
•	✅ Direct Manipulation paradigm enables intuitive interactions
•	✅ Ergonomic Design reduces cognitive load
•	✅ Consistent Components improve learnability
•	✅ Error Prevention minimizes user mistakes
6.2 HMI Principles Applied
Chapter	Concept	Application
1	Interface as communication bridge	Sidebar + Content Area design
2	Short-term memory limits	7 navigation items
3	GUI component standards	Consistent buttons, dialogs, forms
4	Error management	Validation, clear messages
6.3 Perspectives & Improvements
Area	Current State	Proposed Enhancement
Accessibility	Basic	Add ARIA labels, keyboard navigation
Multi-user	Role-based	Real-time collaboration features
Responsiveness	Desktop-first	Full mobile adaptation
Help System	Minimal	Comprehensive onboarding wizard
6.4 Lessons Learned
The development of this HR Management system reinforced key HMI concepts:
1.	User-centered design leads to better adoption
2.	Consistency reduces learning curve
3.	Visible system state builds user confidence
4.	Error prevention is preferable to error handling
 

 

