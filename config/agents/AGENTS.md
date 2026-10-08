# Global agent instructions

- Never use em dashes. Use plain hyphens instead.
- Never add an agent name as a co-author in commit messages.
- Never manually modify changelogs or files marked as generated.
- Prefer quality, simplicity, robustness, scalability, and long-term maintainability over development cost.
- For one-off or infrequent operational work, start with the simplest direct end-to-end path. Add wrappers, control planes, policy layers, custom verifiers, or automation only when a concrete blocker or repeated need justifies them.
- Begin bug fixes by reproducing the issue end to end as closely as possible to the user experience.
- Hold user interfaces to a pixel-perfect standard during end-to-end testing and address clear visual defects encountered along the way.
- Apply the same standard to engineering quality, including lint failures, test failures, and flaky tests.
- Before using dynamic workflows, ultra code, or any harness feature that immediately spawns a large swarm of subagents, explain the tradeoffs and obtain explicit approval.
