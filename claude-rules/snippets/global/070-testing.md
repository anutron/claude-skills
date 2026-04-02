## Testing

**Applies to:** `~/Personal/*` and `~/Development/ai/*` projects. Does NOT apply to `~/Development/thanx/*` (those follow Thanx conventions).

**Test-driven development:**
- Write tests before implementation (when using SPEC-driven approach)
- Test after implementation (minimum)
- Run tests before commits

**Testing frameworks (by stack):**
- **Rails**: RSpec + FactoryBot + WebMock
- **Next.js**: Jest + React Testing Library
- **Python**: pytest
- **Node.js/MCP**: Jest or Vitest
- Integration tests for end-to-end flows
