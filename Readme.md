# Incident Management System

A full-stack Incident Management System built using **FastAPI + SQLAlchemy** on the backend and **HTML, CSS, JavaScript, jQuery** on the frontend.

This application allows users to:
- Create incidents
- View incidents with pagination
- Delete incidents
- Automatically calculate severity
- Manage master data (ERP Module, Environment, Business Unit, Category)
- Use a modern modal-based UI

---

## Tech Stack

### Backend
- Python 3.13
- FastAPI
- SQLAlchemy (ORM)
- MySQL
- Uvicorn

### Frontend
- HTML5
- CSS3
- JavaScript
- jQuery (AJAX)

---

## Database Schema

### Tables
- `incidents`
- `erp_module`
- `business_unit`
- `environments`
- `categories`

Each table has:
- `id` (Primary Key)
- `status`
- `created_at`
- `updated_at`

Incidents table maintains foreign keys to all master tables.

#### URL -> http://127.0.0.1:8000/static/index.html
    - once all the requirement are installed as per the requirement.txt file then please run the following command.
    python -m uvicorn main:app --reload
    - Download the sql file that I have placed in the repo and import that database, you can see the data when we open the UI.

### used S3 for the logs to store the details of the each incident