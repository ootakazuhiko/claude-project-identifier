# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Identification

When working with this project, Claude Code should always display the following information at startup and when waiting for user input:

```
[WAITING] ユーザー入力待機中... / Waiting for user input...
================================================
 Project: Express API Server
 Type: Node.js REST API
 Environment: Development
 Current Directory: [current path]
 Time: [current time]
================================================
```

## Project Overview

Express API Server is a modern RESTful API built with Express.js and TypeScript, featuring JWT authentication, PostgreSQL database, and comprehensive testing.

## Project Structure

```
express-api-server/
├── src/               # TypeScript source code
│   ├── controllers/   # Route controllers
│   ├── middleware/    # Express middleware
│   ├── models/        # Database models
│   ├── routes/        # API routes
│   ├── services/      # Business logic
│   └── utils/         # Utility functions
├── tests/             # Test files
├── dist/              # Compiled JavaScript
└── config/            # Configuration files
```

## Development Commands

### Quick Start
```bash
# Install dependencies
npm install

# Start development server with hot reload
npm run dev

# Run tests
npm test

# Build for production
npm run build

# Start production server
npm start
```

## Key Features

- RESTful API design
- JWT authentication
- PostgreSQL with Prisma ORM
- TypeScript for type safety
- Comprehensive test coverage
- API documentation with Swagger
- Rate limiting and security headers
- Docker support

## API Endpoints

- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/users` - List users (protected)
- `GET /api/users/:id` - Get user details (protected)
- `PUT /api/users/:id` - Update user (protected)
- `DELETE /api/users/:id` - Delete user (protected)

## Environment Variables

```
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:pass@localhost:5432/db
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=7d
```

## Testing

```bash
# Unit tests
npm run test:unit

# Integration tests
npm run test:integration

# Test coverage
npm run test:coverage
```

## Git Workflow

All commits should follow the pattern:
```bash
git commit -m "[AI: Claude Code] feat: Add user authentication endpoint"
```

Commit types:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `test:` - Test additions or changes
- `refactor:` - Code refactoring
- `chore:` - Maintenance tasks

---

Remember: Always display the project identification banner when starting work on this project, and show the waiting indicator when idle.