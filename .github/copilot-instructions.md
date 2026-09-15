# Copilot Instructions for nf-agora

## Writing pull request descriptions

Base the PR description on the actual code changes (diff + commit messages), not just the PR title.

### For non-trivial PRs

Follow the structure in [`.github/pull_request_template.md`](pull_request_template.md), using these section headers (matching the convention already used in this repo's PR history):

```
# Problem

<What technical problem this PR solves. Why the change is needed, how the problem
was found/reproduced, and links to relevant Jira tickets (AG-XXXX, IBCDPE-XXXX) or
related PRs/issues if inferable from the branch name or commit messages.>

# Solution

<What the PR actually changes to solve the problem. Call out any notable design
decisions, trade-offs, or follow-up/technical debt. If the change is a set of
distinct edits rather than a single fix, use "# Changes" instead of "# Solution"
and list them as bullet points.>

# Test

<How the change was or should be validated: local test commands (e.g.
`nextflow run main.nf -profile ...`), links to CI/Seqera Tower runs, or new
automated tests. Do not fabricate test results — if you cannot determine how
something was tested, say so or leave the section for the author to fill in
rather than inventing details.>
```

Only include a section if there is real content for it — don't pad the description with boilerplate restating the template's own instructions.

### For simple PRs

If the change is small and self-explanatory (e.g. a one-line bug fix, typo/doc fix, dependency bump, config value tweak, or minor refactor with no behavioral change), do **not** force the full Problem/Solution/Test structure. Instead, write a short 1-3 sentence summary of what changed and why.

### General notes

- Be concise. Prefer bullet points over long paragraphs for multi-part changes.
- Reference specific files, processes, or parameters changed (e.g. `main.nf`, a Nextflow process name, a CLI flag) instead of vague descriptions.
- If a Jira ticket ID appears in the branch name or commits (e.g. `AG-2149`, `IBCDPE-947`), mention it in the summary.
- Never invent test results, run links, or reproduction steps that aren't backed by the diff, commits, or provided context.
