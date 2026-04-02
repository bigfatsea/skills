<!-- Ver 2026-04-03 00:00, by GPT-5 -->
Use this checklist to decide whether a comparison-table row is needed.

Create a decision row only if the choice materially affects:

- architecture simplicity
- delivery speed
- implementation risk
- runtime reliability
- user experience quality
- performance
- deployment/packaging complexity
- long-term maintainability
- platform compatibility or permission model
- system-state restoration or recovery behavior

Strong signals that a decision row is warranted:

- the user named a stack but multiple viable implementation paths still exist
- the feature crosses OS, browser, device, desktop, or external API boundaries
- a naive shortcut would produce a demo that works poorly in real use
- the product needs concrete defaults for out-of-box usability
- one option handles failure modes, cleanup, or state restoration much better
- packaging, distribution, signing, installation, or entitlements are non-trivial

Do not create rows for trivial implementation details.

When comparing alternatives:

- prefer native or platform-default solutions first
- prefer fewer dependencies when quality is comparable
- prefer deterministic behavior over cleverness
- prefer solutions with clearer failure handling and restoration paths
- call out low-quality shortcuts explicitly when they are tempting
- include tradeoffs, not just recommendations
