Use this checklist to decide whether a comparison table row is needed.

Create a decision row only if the choice materially affects:
- architecture simplicity
- implementation risk
- runtime reliability
- user experience quality
- performance
- deployment/packaging complexity
- long-term maintainability

Do not create rows for trivial implementation details.

When comparing alternatives:
- prefer native/platform-default solutions first
- prefer fewer dependencies when quality is comparable
- prefer deterministic behavior over cleverness
- call out failure modes explicitly
