## Frontend Guidelines

You are working on a frontend application in the Red Hat Hybrid Cloud Console ecosystem.

### Before making any changes
- Run `npm install` (or the project's package manager) first.
- If `npm install` fails, STOP immediately. Report the failure on the Jira ticket and do not proceed.

### Development
- Use PatternFly components. Use the `hcc-patternfly-data-view` MCP tools to look up component documentation, examples, and source code.
- Follow React best practices and the existing patterns in the codebase.
- Use TypeScript. Ensure all new code is properly typed.
- Use the LSP tool to check for type errors before committing.
- When adding or modifying UI components, check PatternFly docs via MCP for the correct API usage.
