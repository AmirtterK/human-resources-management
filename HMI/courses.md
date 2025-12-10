Chapter 1 — Introduction to Human–Machine Interface

(From 

Chapter1 HMI_Introduction_c0ced…

)

1. What Is an Interface?

An interface is the point of contact between two different elements.
In Human–Machine Interaction, the three essential components are:

The Human (User)

The person who provides input, interacts with the system, and expects meaningful feedback.

The Machine (Computer)

The device that processes data, executes tasks, and produces results.

The Interface

The communication bridge between user and machine.

Examples: screens, buttons, touch interfaces, keyboards, dashboards, software interfaces.

A simple diagram (described):
Human ↔ Interface ↔ Machine

2. Different Names for HMI

You will encounter multiple terms. All refer to similar concepts:

HMI: Human–Machine Interface

HMI: Human–Machine Interaction

HCI: Human–Computer Interaction

UI: User Interface

GUI: Graphical User Interface

Human–Machine Dialogue / Communication

All describe how humans interact with machines using hardware and software.

3. Definitions
Human–Machine Interface

A set of hardware and software components enabling communication between humans and machines.

Examples:

A touchscreen in a car

A website interface

A machine dashboard in a factory

Human–Machine Interaction

The relationship between the human and the machine through the interface.

Includes:

Pressing buttons

Moving a mouse

Typing

Touch gestures

Speaking to a voice assistant

4. Where Is HMI Used?

HMI is everywhere in modern society:

Healthcare

(From the image on page 6)
Machines for monitoring patients, surgical interfaces, X-ray systems.

Industry

Control rooms, production dashboards, robots, automation interfaces.

Education

Interactive screens, e-learning platforms.

Transportation

Airline booking systems, car dashboards, aircraft cockpits.

5. Why Is HMI Important?
User Perspective

Users judge a system mainly through its interface, not its internal code.

Development Perspective

Up to 48% of software code is interface-related.

Up to 80–90% of development time is spent on interface design.

Social & Safety Perspective

Bad interfaces can cause accidents.

Example: Mont Sainte-Odile Airbus A320 Crash (1992)

(From page 8)

87 fatalities.

Cause: one physical control performed two different functions, creating confusion.

Shows how poor interface design can be fatal.

6. Evolution of Interfaces
1945–1970: Early Era

Devices:

Punch cards

Control panels

Printers

Command languages

Interaction was primitive and technical.

1963 — First Interactive Graphics System

Sketchpad by Ivan Sutherland
→ Allowed drawing on screen using a light pen
→ Beginning of graphical interaction

1968 — The Mouse

Douglas Engelbart’s “Mother of All Demos”
→ Revolutionized computing
→ Introduced mouse + windows + hypertext + videoconferencing concepts

1980s — Consumer Computers

Widespread graphical interfaces

Birth of personal computers

Direct manipulation (click, drag, drop)

1993 — First Augmented Reality System

Digital Desk by Pierre Wellner
→ Digital + real workspace combined

2010s — Natural Interfaces

Multi-touch screens

Pinch/zoom

Gestural interfaces

Voice interfaces

7. Two Approaches to Interface Design
Techno-Centered (1969–1983)

Focus: machine capabilities

Users adapt to the machine

Command Line Interfaces (CLI) dominant

Used by engineers only

Anthropo-Centered (1984–Today)

Focus: user needs

Machine adapts to user

GUIs dominate

Mouse interactions, icons, windows, direct manipulation

Chapter 2 — Principles of Human–Machine Interaction

(From 

Chapter2 HMI_43ec595b5368a87943…

)

1. What Is Human–Machine Interaction (HCI)?

A discipline concerned with:

Designing

Implementing

Evaluating

interactive systems that are:

Efficient

Easy to use

Adapted to human needs

2. Principles of an Interactive System

An interactive system must:

Show Visible State

The system must display what it is doing (loading, waiting, editing, etc.), so users can understand and react.

Example:

A text editor shows the blinking cursor → indicates the system is ready for typing.

Allow User Modification

User actions (mouse, keyboard, touch) must change system state.

Input–Output Dependency

Outputs influence the next input; this creates interaction cycles.

3. Interaction Cycle (Essential Concept)

Described from page 7:

User acts (clicks, types, drags)

Interface sends request to functional core

Core executes command and returns results

Interface displays result

User perceives result and acts again

This loop continues constantly.

4. Multidisciplinary Nature of HMI

HMI combines:

Computer Science

→ ensures correctness and performance

Ergonomics

→ ensures the system is easy to use

Psychology

→ understanding memory limits, attention, human behavior

5. Human Memory and HMI
Short-Term Memory (STM)

Stores ±7 items

Lasts 15–30 seconds

Sequential search

Easy to overload

Example: remembering a phone number long enough to dial it.

Long-Term Memory (LTM)

Unlimited capacity

Permanent

Stores skills and knowledge

Example: knowing how to use a keyboard.

Why It Matters for HMI

Good interfaces:

Reduce STM load

Leverage LTM patterns

Follow conventions users already know

6. Types of Interaction
A. Natural Language

Speak or type in normal language

Easy for humans, hard for machines (ambiguity)

Used in: Siri, Google Assistant, chatbots

B. Command Language (CLI)

Requires precise syntax

Fast and powerful once learned

Not beginner-friendly

Examples:

delete *.*

copy A:*.doc C:

C. Menu Interaction

Users select from a list of commands

Easy to use

Commands may require:

no argument

one argument

multiple arguments

D. Forms

Used to collect large amounts of information.

Two types:

Closed questions → Yes/No, multiple choice

Open questions → free text

Used for:

Registrations

Surveys

Login pages

E. Query Languages

Used by advanced users

Query syntax (SQL)

Used in databases, search engines

F. Direct Manipulation

Characteristics:

Objects visible on screen

Immediate feedback

Reversible actions

“What you see is what you get”

Examples:

File drag-and-drop

Graphic design tools

Touchscreen interfaces

Chapter 3 — Graphical User Interface (GUI) Elements

(From 

HMI_Introduction_part3_d13e1426…

)

1. Style Guides

A style guide defines:

Fonts

Colors

Icons

Component layouts

Interaction states

Used to:

Maintain consistency

Make interfaces predictable and learnable

2. Typography

Affects readability.

Elements:

Font types

Text size

Line spacing

Good typography:

Improves clarity

Highlights hierarchy

3. Color Usage

Defines:

Backgrounds

Text colors

Buttons

Status indicators

Color meanings:

Green → success

Red → error

Blue → neutral action

4. Icons

Icons must be:

Recognizable

Consistent

Meaningful

Levels of abstraction:

Resemblance → trash bin = delete

Analogy → scissors = cut

Symbolic → abstract shapes

Arbitrary → refresh icon

5. GUI Window Components

A typical window contains:

Title bar

Menu bar

Toolbar

Client area

Scroll bars

Status bar

Borders and corners

6. Window Models
Multi-window System

Tiled → no overlap

Overlapping → common modern model

Problem: hidden information

Hierarchical Windows

Parent window + child windows

Closing parent closes all children

7. Window Types
Application Window (MDI)

Main workspace + document subwindows

Utility Window

Small toolboxes that stay on top

Pop-Up Windows

Temporary menus or notifications

Dialog Boxes

Ask for input or confirmation
Types:

Modal (blocks use)

Modeless (non-blocking)

Rules:

Max 5 buttons

Must have OK/Cancel

Input validation required

8. Other Components
Buttons

States:

Released

Hovered

Pressed

Disabled

Radio Buttons

Select one option only.

Checkboxes

Select multiple options.

Lists & Combo Boxes

Used for choosing items.
Combo boxes can be editable or not.

Hierarchical Lists

Show tree structures.

Tabs

Organize content into multiple pages.

Chapter 4 — Interaction Tasks & Error Handling

(From 

HMI_Introduction_part4_d6dabd45…

)

1. Interaction Tasks
A. Input Tasks

Text → text box + keyboard

Numbers → slider or scroll wheel

Position → mouse or stylus

Drawing → drag motions

B. Selection Tasks

One element → radio button, drop-down

Multiple elements → checkboxes, multi-select lists

Selection methods:

Ctrl → select group

Shift → select range

C. Action Triggering

Buttons

Menus

D. Drag & Drop

Action depends on context:

Same disk → move

Different disks → copy

2. Scrolling

Types:

Direct scrolling (drag scrollbar)

Automatic scrolling (content moves itself)

Scroll by line, page, or percentage

3. Specification Tasks

Done using:

Dialog boxes → user chooses settings

Properties windows → configure objects

Preview → show result before applying

4. Transformation Tasks

Resize handles

Horizontal/vertical/proportional resize

5. Help Systems

Types:

Contextual help → “What can I do?”

Factual help → “What is this?”

Procedural help → “How do I do it?”

Tools:

Manuals

Online help

Tooltips

6. Error Management
Prevention

Disable unavailable commands

Validate input

Avoid ambiguous destructive actions

Correction

Detect and highlight errors

Provide short, clear messages

Offer undo

Allow interruptions

7. Types of Interactive Applications
Conversational

Command–response (CLI, chatbots)

Extended Conversational

Wizards and installers

Limited Manipulation

Menus, forms

Direct Manipulation Applications

Visible objects

Immediate feedback

Reversible actions

Examples:

Smartphones

Graphic editors

Conclusion

HMI combines:

Technology

Psychology

Ergonomics

Its evolution led from punch cards → CLI → GUI → touch → AR/VR.
A good interface:

Respects human limitations

Reduces errors

Increases usability

Enhances safety