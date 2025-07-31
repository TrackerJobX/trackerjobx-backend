# 🚀 TrackerJobX – Backend API

**TrackerJobX** is a simple SaaS for job seekers to track job applications, monitor statuses, schedule interviews, and manage related documents. This repository contains the **backend API**, built using **Ruby on Rails** and **PostgreSQL**.

---

## 🧱 Tech Stack

- **Framework:** Ruby on Rails (API-only mode)
- **Database:** PostgreSQL
- **ORM:** ActiveRecord
- **Authentication:** Devise / Token-based
- **File Upload:** ActiveStorage (local/S3-ready)
- **Soft Delete:** Paranoia gem
- **Serialization:** Blueprinter
- **Testing:** RSpec / Minitest (TBD)
- **Deployment:** Fly.io (production ready)

---

## 📦 Setup Instructions

### 1. Prerequisites

- Ruby (v3.x recommended)
- Rails (`~> 8.0`)
- PostgreSQL
- Node.js & Yarn (for ActiveStorage, if needed)

### 2. Clone & Install Dependencies

```bash
git clone https://github.com/yourusername/trackerjobx-backend.git
cd trackerjobx-backend

bundle install
````

### 3. Database Setup

```bash
rails db:create db:migrate db:seed
```

> Note: Make sure your PostgreSQL is running.

### 4. Run the Server

```bash
rails s
```

Server will run at: [http://localhost:3000](http://localhost:3000)

---

## 🛠️ API Structure

All endpoints are prefixed with `/api/v1`

### 🔐 Auth

| Method | Endpoint         | Description        |
| ------ | ---------------- | ------------------ |
| POST   | `/auth/login`    | User login (token) |
| POST   | `/auth/register` | Register new user  |

### 👤 Users

| Method | Endpoint     | Description      |
| ------ | ------------ | ---------------- |
| GET    | `/users/:id` | Get user detail  |
| PUT    | `/users/:id` | Update user info |

### 📄 Job Applications

| Method | Endpoint                | Description     |
| ------ | ----------------------- | --------------- |
| GET    | `/job_applications`     | List jobs       |
| POST   | `/job_applications`     | Create new job  |
| GET    | `/job_applications/:id` | Show job detail |
| PUT    | `/job_applications/:id` | Update job      |
| DELETE | `/job_applications/:id` | Soft delete job |

> ...more endpoints coming soon!

---

## 📂 Project Structure

```
app/
├── controllers/
│   └── api/v1/
├── models/
├── services/
├── blueprints/
├── serializers/
├── jobs/
├── uploaders/
```

---

## ✅ Development Checklist

* [ ] User CRUD (with Paranoia soft delete)
* [ ] Job Application CRUD
* [ ] Attachments (CV, Cover Letter, Portfolio)
* [ ] Tag management
* [ ] Interview scheduler
* [ ] Auth (login, register)
* [ ] Unit tests
* [ ] API documentation (OpenAPI / Postman)
* [ ] Background jobs (email reminder, optional)

---

## 🚀 Deployment

Deployed via [Fly.io](https://fly.io).
Secrets and ENV vars managed via `fly secrets`.

To deploy:

```bash
fly deploy
```

---

## 📄 License

MIT © 2025 — [Your Name or Org](https://github.com/yourusername)

```
