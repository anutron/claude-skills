## Standard Tech Stack

**For all new applications, use the Thanx stack** (modeled on `~/Development/thanx/sherlock`):

### Backend
- **Ruby on Rails** (API-only mode) with **Grape** for versioned REST endpoints
- **MySQL** database with Active Record
- **Redis** + **Sidekiq** for background jobs
- **Interactors** for business logic (separate from API endpoints)
- **Puma** web server
- **RSpec** + **FactoryBot** + **WebMock** for testing
- **RuboCop** + **Brakeman** for linting/security

### Frontend
- **Next.js** (App Router) with **TypeScript** (strict mode)
- **React** with **Redux Toolkit** for state management
- **Jest** + **React Testing Library** for testing
- **ESLint** + **Prettier** for linting/formatting

### Project Structure (Monorepo)
```
<app-name>/
├── api/                # Rails API-only backend
│   ├── app/api/        # Grape endpoints (v1/)
│   ├── app/models/
│   ├── app/interactors/
│   ├── spec/           # RSpec tests
│   │   ├── spec_helper.rb
│   │   ├── rails_helper.rb
│   │   ├── api/v1/     # Endpoint tests (*_api_spec.rb)
│   │   ├── models/     # Model tests (*_spec.rb)
│   │   └── factories/  # FactoryBot definitions
│   └── Gemfile
├── ux/                 # Next.js frontend
│   ├── jest.config.ts
│   ├── jest.setup.ts   # imports @testing-library/jest-dom
│   ├── src/app/        # App Router pages
│   ├── src/lib/        # API client, utilities
│   ├── src/__tests__/  # Jest tests (*.test.tsx)
│   └── package.json
├── ops/                # Terraform (when deploying to AWS)
├── specs/              # SPECs (our development workflow)
└── CLAUDE.md           # App-specific instructions
```

### Legacy Python Applications
Existing apps (`fitbit-cli`, `memory-mcp`, `things-mcp`) use Python/Node and stay as-is. The `/dev` skill and all tooling must work with these codebases. When modifying legacy apps, use their existing stack -- do not migrate them.

### When to Use What
- **New app or service** → Thanx stack (Rails + Next.js monorepo)
- **Existing Python/Node app** → Keep existing stack, follow existing patterns
- **One-off script or utility** → Python is fine (no need for Rails for a CLI tool)
- **MCP server** → Node.js/TypeScript (MCP SDK is Node-native)
