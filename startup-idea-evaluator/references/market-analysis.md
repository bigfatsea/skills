# Market Analysis Reference

**Primary skill**: Use `everything-claude-code:market-research` for research execution (sizing, competitive analysis, data sourcing, output format). This file provides startup-evaluator-specific overlays only.

Run ≥2 areas per Mode B analysis: market sizing + competitive landscape + pricing model.

---

## 小而美 Calibration (read before sizing)

Not every business needs a $1B TAM. For a 3-person bootstrap-first team:

| ARR Target | Customers needed at various ARPU | Viability |
|------------|----------------------------------|-----------|
| $300K | 300 × $1K / 30 × $10K / 3 × $100K | Ramen profitable |
| $1M | 1,000 × $1K / 100 × $10K / 10 × $100K | Comfortable |
| $3M | 3,000 × $1K / 300 × $10K / 30 × $100K | Strong lifestyle business |
| $10M | 10,000 × $1K / 1,000 × $10K / 100 × $100K | VC-interesting |

Before calling a market "too small": can this generate $1–3M ARR at reasonable penetration with 70%+ gross margin? If yes, it's a valid outcome for this team — often better than a large market with fierce competition.

---

## Market Sizing

Follow `everything-claude-code:market-research` → Market Sizing section. Apply these additional constraints:

- **Always bottom-up**: top-down TAM is context, not a size estimate. Show the path to the first 100 paying customers.
- **Penetration reality**: >10% penetration in year 3 requires explaining the distribution mechanism. B2B SaaS without major distribution advantage rarely exceeds 5% SAM in 5 years.
- **For this team**: a business requiring 50,000+ customers to be viable is distribution-constrained. Prefer higher ARPU / narrower niche.

### Dual-Market Template (CN + International)

Use when the idea targets both markets:

```
China market:
  SAM estimate: ¥[X]M / year  (method: bottom-up / spend displacement / analogous)
  Key assumption: [one thing that could be wrong]
  Penetration to $1M ARR: [X%] — realistic?

International market:
  SAM estimate: $[X]M / year  (method: ...)
  Key assumption: [one thing]
  Penetration to $1M ARR: [X%] — realistic?

Enter first: [China / International / simultaneous]
Reason: [distribution advantage, competitive density, price point]
```

### Red Flags in Market Claims

Push back when you see:
- "$X billion market" with no path to capture even 0.1%
- Top-down only (industry TAM ÷ nothing = fake precision)
- Penetration >10% in year 3 with no distribution explanation
- Conflating total industry value with software revenue opportunity
- Using 2030 projections as current reality
- No named buyers — if you can't name 20 specific companies/people who'd buy today, the market is theoretical

---

## Competitive Analysis

Follow `everything-claude-code:market-research` → Competitive Analysis section. Focus specifically on:

- **Kill-zone risk**: is this on a big player's roadmap? Would they copy or acquire?
- **Distribution gaps**: what acquisition channels are incumbents NOT using that a 3-person team can exploit?
- **Pricing gaps**: are incumbents over-priced for a specific segment, or under-serving a niche?
- **Moat realism**: data, switching cost, network effect, or brand — which is actually achievable for this team in 12–24 months?

---

## Pricing Model Assessment

Not covered by the market-research skill. Evaluate:

1. **Model fit** — does the pricing model match how buyers budget and perceive value?
2. **ARPU benchmark** — compare against closest analogues in same category and geography
3. **WTP signal** — is the target customer already paying for an inferior solution? At what price?
4. **Path to ARR** — can this model reach $1M ARR with a realistic customer count?

| Revenue model | Typical ARPU | Good fit when |
|---------------|--------------|---------------|
| B2B SaaS subscription | $500–$50K/yr | Repeatable pain, measurable ROI |
| Usage-based | $0–variable | Unpredictable value delivery, API products |
| Marketplace / commission | 3–20% of GMV | High-frequency transactions |
| Freemium → paid | $0 → $X/mo | Strong viral loops or network effects |
| One-time / perpetual | $50–$5K | Low support burden, commodity utility |

**China-specific**: SaaS WTP is typically 30–50% lower than US equivalents. Annual prepay is more common than monthly. Factor into ARPU assumptions.

---

## Output Format

Per `everything-claude-code:market-research` standards, structured as:

```
Market size:
  Method A: ~$X SAM  [assumption: ...]
  Method B: ~$Y SAM  [assumption: ...]
  Range: $X–Y
  小而美 check: viable at niche scale for 3-person team? Yes / No / Marginal

Competitive landscape:
  Direct: [names + key differentiation]
  Indirect: [substitution risk]
  Kill-zone risk: [yes/no + reasoning]
  Positioning gap: [where to play]

Pricing model:
  Recommended: [model] at [price point]
  ARPU benchmark: [comparable product/market]
  Path to $1M ARR: [X customers at $Y]
  WTP evidence: [paying for alternatives? at what price?]
```
