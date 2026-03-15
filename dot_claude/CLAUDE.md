@~/AGENTS.md

## AI-Specific Behavior

- Read files in full before editing — partial reads lead to corrupted edits
- Do not say "The issue is..." before you actually know what the issue is. Investigate first
- Do not guess at root causes — read code, check logs, reproduce the problem
- Do not add error handling, fallbacks, or validation for scenarios that can't happen
