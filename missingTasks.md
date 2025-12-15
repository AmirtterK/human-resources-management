# Missing Tasks - Frontend vs Backend/Functionality Gap

This file documents functionality that exists in `functionality.txt` but **cannot be implemented** in the frontend because:
1. The backend does not have a corresponding endpoint, OR
2. It requires features/infrastructure not currently available

---

## Features NOT in Backend (Cannot Implement)

### 1. CSV Export for Filtered Employee Lists
**From:** UC-Agent02 - Extract a List of Names
**Issue:** The functionality.txt mentions exporting to PDF **or CSV**, but:
- Backend only returns JSON data
- No backend endpoint generates CSV files
- Frontend can only do PDF generation client-side

**Workaround:** Currently only PDF export is available via `PdfService`.

---

### 2. Director PIN Verification for Retirement Validation
**From:** UC-ASM03 - Validate Retirement Request
**Issue:** The functionality.txt mentions:
> "If Director PIN required: ASM inputs Director PIN → backend verifies PIN"

However:
- Backend endpoint `POST /api/asm/retireRequests/{id}/validate` does not accept a PIN parameter
- The validation happens without PIN verification

**Status:** Backend simplified this flow; no PIN required for validation.

---

### 3. Audit Trail Viewing
**From:** UC-ASM04 - Modify Archived Employee
**Issue:** The functionality mentions "audit trail preserved" but:
- No backend endpoint to retrieve audit logs
- Frontend cannot display audit history

**Status:** Audit may be stored server-side but is not exposed to frontend.

---

### 4. Promotion with Director Approval Workflow
**From:** UC06 - Promote Personnel
**Issue:** The functionality mentions:
> "Request created with status PENDING_DIRECTOR_APPROVAL"

However:
- Backend `POST /api/pm/promotions` appears to apply promotions immediately
- No pending approval workflow visible in backend

**Status:** Simplified to immediate promotion without approval workflow.

---

### 5. Print Personnel Decision Document
**From:** UC06 - Promote Personnel
**Issue:** The functionality mentions:
> "PM can click Print personnel decision → client requests PDF generation"

However:
- No backend endpoint for generating personnel decision documents
- Would need to create custom PDF template client-side

**Status:** Not implemented. Could be added as a frontend-only PDF similar to work certificates.

---

### 6. Department CRUD Operations
**From:** Implied by system architecture
**Issue:** 
- Backend has `CommonController` for reading departments but no Agent/ASM endpoints for CRUD
- Only Bodies and Grades have full CRUD

**Status:** Departments are read-only in the system.

---

### 7. Specialty CRUD (Delete/Modify)
**From:** UC-ASM02 - Manage Domains & Specialties
**Issue:**
- Backend has `POST /api/asm/domains/{domainId}/specialities/create`
- No modify or delete endpoints for specialties visible

**Status:** Specialties can only be created, not modified or deleted.

---

## Summary

| Feature | Status | Reason |
|---------|--------|--------|
| CSV Export | ❌ Not Available | No backend support |
| Director PIN for Validation | ❌ Simplified | Backend doesn't require |
| Audit Trail Viewing | ❌ Not Exposed | No API endpoint |
| Promotion Approval Workflow | ❌ Simplified | Immediate promotion only |
| Personnel Decision PDF | ⚠️ Could Add | Frontend-only possible |
| Department CRUD | ❌ Read-Only | No backend endpoints |
| Specialty Delete/Modify | ❌ Create-Only | Limited backend |
