# Full Output Example: Mode B — Investment Memo

> Fictional case, used only to demonstrate output format and depth standards.

**User Input**:
> I want to build an AI contract review tool targeting small and medium-sized law firms in China (5–20 people), helping them automatically identify risky contract clauses. Tech stack: JS/Python + openrouter.ai. Currently have zero users and want to know whether it’s worth doing and where to start.

---

## Step 1: Rapid Framing

**Thesis**:Provide AI-powered contract risk identification SaaS for Chinese SME law firms, functioning as a “junior lawyer assistant” that replaces the manual first-pass review.

**Stage**:Idea — no prototype, no users, no revenue.

**Archetype**:AI Vertical SaaS (Legal Industry)

**Kill Switch**:The life or death of this project depends on one thing — **whether law firms are willing to pay for an AI tool, rather than perceiving it as eroding the core value of a lawyer**. The willingness of Chinese lawyers to adopt AI tools has not been validated at scale.

---

## Step 2: Adaptive Lens Analysis

*Lens selected:Problem intensity & WTP / Team-idea fit / GTM & distribution / Business model / Regulatory & structural risk*

### Lens 1:Problem Intensity & Willingness to Pay

**Assessment**:Contract review is a real pain point — in SME law firms it is typically done manually by junior lawyers, consuming 2–4 hours per contract, with high error rates, and intense price competition leading to thin margins. Law firms have an incentive to reduce costs; this is a positive signal.

**Key Assumption**:Law firms are willing to pay on a per-contract basis for the review tool, rather than demanding a perpetual license or project-based pricing.

**Bull case**:A law firm processes 20+ contracts per month; if each saves 1.5 hours, the ROI is clear.
**Bear case**:Lawyer culture tends to be conservative; they may think “AI’s output doesn’t count,” requiring a full re-check by a lawyer — which means no time is actually saved.

---

### Lens 2:Team-idea Fit & Execution

**Assessment**:The JS/Python + openrouter.ai stack is fully capable of building an MVP: PDF parsing + LLM risk clause identification + structured report output. Technical feasibility is high; a 3-person team can produce a prototype in 4–6 weeks.

**Core obstacle is not technical**:it lies in how to enter the law firm circle — the legal profession is an industry that highly relies on word-of-mouth and personal relationships. A 3-person team cannot quickly acquire customers through content SEO or product-led self-growth; at least one person must have law firm connections or a legal industry background.

**Key Assumption**:At least one person on the team can directly contact 3–5 law firms willing to trial (former colleagues, friends, alumni).

**Bull case**:If law firm connections exist, the cold start can be driven by warm relationships.
**Bear case**:All three members have only a technical background; entering the legal circle is extremely difficult, and the cold start cost is exceedingly high.

---

### Lens 3:GTM & Distribution Wedge

**Assessment**:The legal SaaS circle is small; word-of-mouth spreads quickly, but the barrier to entry is high. The main information channels for Chinese law firm circles are: lawyer industry WeChat groups, Bar Association events, vertical legal media (e.g., Wusong, Legal Reader).

**Distribution advantage**:If an influential law firm can be turned into a case study, diffusion within the circle is fast.
**Distribution disadvantage**:The cold start entirely depends on personal networks; there is no PLG path (law firms will not “invite colleagues” to use a contract review tool).

**Key Assumption**:Once the first law firm is secured, it is possible to achieve 5–10 referrals within 60 days via Bar Association groups / industry media.

---

### Lens 4:Business Model & Unit Economics

| Metric | Estimate |
|--------|----------|
| Pricing assumption | ¥2,000–5,000/month (incl. 100 contracts/month) |
| Target customer ARPU | ¥3,000/month = ¥36,000/year |
| To reach $300K ARR requires | ~58 paying law firms |
| To reach $1M ARR requires | ~194 paying law firms |
| Gross margin | ~75% (main costs: LLM API + small amount of storage) |

**Small & beautiful check**:58 law firms to reach $300K ARR is completely viable for a 3-person team; 194 is a higher target but would require a stronger customer acquisition engine.

**Hidden costs**:If a legal vertical model needs fine-tuning, costs rise significantly; customer support pressure is also higher than typical SaaS (lawyers have very high expectations for output quality).

---

### Lens 5:Regulatory & Structural Risk

**Assessment**:China’s Lawyers Law imposes strict qualification requirements for legal services; an AI tool cannot “provide legal advice” and can only act as an auxiliary tool. This is actually a form of protection — positioning as a “review assistant” rather than “replacing lawyers” can sidestep regulatory risks.

**Key risk**:If the AI output is accepted as a final conclusion rather than a reference by the law firm, and a missed review incident occurs, the product could face reputation risk. Disclaimer design must be done on the product UI.

---

### Three-Layer Challenge Summary

**Survival Layer**:
Acquiring the first 10 paying law firms — this is the hardest step. Without industry connections, a cold start is impossible; this must be validated within 90 days.

**Growth Layer**:
Establish a word-of-mouth flywheel. The legal industry relies on case studies and endorsements; 3–5 publicly referenceable flagship clients are needed to unlock industry media and Bar Association channels.

**Moat Layer**:
Accumulate a law-firm-specific contract template library and risk clause database — this is the only defensible moat; generic LLMs cannot replace industry-specific data.

---

## Step 3: Assumption Mapping + Validation Plan

*Extracted the 3 most dangerous assumptions from Step 2 lens analysis, ranked by “probability of being wrong × cost of being wrong”:*

**Priority 1 (validate this week)**:“Law firms are willing to pay for an AI contract review tool”
- Test:Contact 10 lawyer acquaintances, show a PDF + simple prototype, directly quote a ¥500/month pilot.
- Success criteria:≥3 people express purchase intent or are willing to sign an LOI.

**Priority 2**:“We can access target law firms”
- Test:Contact 20 law firms within 2 weeks through alumni/former-colleague channels, inviting them to a free trial.
- Success criteria:≥5 agree to trial (25% response rate means the channel is viable).

**Priority 3**:“AI’s accuracy on Chinese contracts is sufficiently high”
- Test:Use openrouter.ai + existing models, manually run 30 real contracts, and compare results against a lawyer’s manual review.
- Success criteria:Miss rate for critical risk clauses <10% (better to flag too many than to miss any).

**Rule**:Do not start product development before Priority 1 is validated. Law firms not willing to pay = Kill Switch triggered.

---

## Step 4: Market Analysis

### Market Size

**Method A:Bottom-Up Unit Economics**

- Approximately 38,000 law firms in China; those with 5–20 people are about 15,000 (referencing Ministry of Justice data).
- Filter: those that use SaaS tools and have contract review needs → roughly 4,000 firms.
- Conservative penetration of 3% (within 3 years) = 120 paying law firms.
- ARPU ¥3,000/month = ¥4,320,000 ARR base market.

**Method B:Spend Displacement**

- SME law firm hires one junior lawyer dedicated to contract review: ¥8,000–12,000/month.
- If the AI tool replaces 40% of the workload → saves ¥3,200–4,800/month.
- Pricing at ¥2,000–3,000/month → savings exceed the tool cost, ROI is justified.
- Corresponding market size aligns closely with Method A.

**Range**:¥3M–¥8M ARR (SAM, Chinese SME law firms).

**Small & beautiful check**:✅ Fully viable. ¥4M ARR is an excellent outcome for a 3-person team, with high gross margins.

**International market**:Not considered for now; China’s legal system differs greatly, and internationalization would require separate regulatory training data. Recommend going deep in the China market first.

### Competitive Landscape

**Direct competitors**:
- Wusong (Westlaw China–type tool, focused on case search, not contract review).
- Fadada (e-signature platform, no risk identification).
- A few emerging domestic Legal AI startups (most target large law firms or legal departments; SMBs are unserved).

**Indirect substitute**:Lawyers directly querying GPT-4o / ERNIE Bot — this is the most real competitive pressure.

**Kill-zone risk**:Low. Big players (Alibaba / Tencent Legal Cloud) currently focus on large enterprise legal departments; 5–20 person law firms are outside their service radius.

**Positioning white space**:Targeting SME law firms, Chinese contracts, subscription-based, no on-premise deployment required — none of the existing competitors cover this niche.

### Pricing Model

**Recommended model**:SaaS subscription, ¥2,000–5,000/month (including 100 contracts processed per month), overage charged per contract.

**ARPU benchmark**:
- Domestic legal SaaS reference (case-database category) ¥1,000–3,000/month.
- U.S. equivalents (Lawgeex, Luminance) $500–2,000/month; China market WTP roughly 40% discount.

**Path to $1M ARR**:194 law firms × ¥3,000/month = ¥7M ≈ $1M USD — needs roughly 3 years to build word-of-mouth in the Chinese SMB law firm circle.

**WTP evidence**:Law firms currently pay ¥8,000–12,000/month for a junior lawyer to do contract review; tool priced at ¥3,000/month means clear ROI and WTP exists; the critical barrier is trust, not price.

---

## Step 5: Unit Economics Sanity Check

**Revenue side:**
- ARPU:¥3,000/month (¥36,000/year).
- Target customers by month 12:20 law firms (based on warm relationship channel capacity).
- ARR at month 12:¥720,000 (approx. $100K USD).

**Cost side:**
- LLM API:~¥500/law firm/month (contract parsing + risk identification, per openrouter.ai pricing).
- Infrastructure + tools:~¥2,000/month fixed.
- Total monthly cost at 20 firms:¥10,000 + ¥2,000 = ¥12,000.
- Gross margin:(¥60,000 − ¥12,000) ÷ ¥60,000 = **80%** ✅.

**Key ratios:**
- Breakeven:Fixed cost ¥2,000 ÷ contribution margin/firm ¥2,500 = **only 1 paying law firm needed** — extremely low threshold.
- LTV:CAC:Customer acquisition via warm relationships (CAC ≈ founder time cost), estimated annual renewal rate 75%, LTV ≈ ¥108,000; LTV:CAC is extremely high, not a bottleneck.
- Time to first revenue:warm relationship outreach → pilot → paying, estimated **6–8 weeks**.

**Bootstrap survival check:**
- Monthly burn:Before product launch near ¥0 (no employee salaries, founders self-sustaining).
- Reserves needed before first revenue:6 weeks of living expenses.
- ✓ Math works:High gross margin, extremely low breakeven, nearly zero capital requirements.

**Verdict:✓ Math works** — 20 customers reach ¥720K ARR, an excellent outcome for a 3-person team; if penetration reaches 58 firms ≈ $300K USD, achieving the small-and-beautiful goal. The only variable is customer acquisition, not the business model.

---

## Step 6: MV-GTM

**Product type**:Painkiller — contract review is a must-do task, not an optional improvement.

**Phase 0→1 (0–10 paying)**

- Beachhead:5–20 person law firms in Shanghai / Beijing specializing in commercial contracts.
- Channel:**Direct warm relationship outreach** — founders contact through friends/alumni/former colleagues with the goal of securing 5–10 free trial invitations.
- Loop proof:Trial → lawyer confirms time saved → convert to paying (¥500/month pilot) → refer peer.
- North-star metric:≥30% of trial firms proactively renew within 30 days.

**Phase 1→10 (10–100 firms)**

- Keep single channel:Lawyer circle word-of-mouth + one deep case-study article on Wusong / Legal Reader.
- Done criteria:3 publicly referenceable flagship law firms, with word-of-mouth referrals accounting for 50% of new customers.

**Phase 10→100 (100+ firms)**

- Add one channel:Bar Association partnership or legal SaaS integration (e.g., iManage Chinese edition).
- Start building a contract template library as a second product line.

**Do not do for now**:
1. Paid advertising (CAC far exceeds LTV).
2. Enterprise law firms (compliance requirements are completely different).
3. International markets (legal systems are not universal).
4. Self-developed legal LLM (too costly, wrong timing).
5. Simultaneous multi-city rollout (penetrate one city deeply first).

---

## Step 7: Pre-Mortem + Investment Verdict

**If this dies in 24 months, the most likely causes:**

**Cause 1:Cold start fails, cannot enter the law firm circle**
*Description*:The team has no legal industry connections; content/SEO cannot acquire price-sensitive law firm clients with slow decision-making processes.
*Early warning signal*:Contact 50 law firms within 90 days, yet still fewer than 5 willing to do a free trial.
*Mitigation*:Before starting, spend 2 weeks reaching out to 20 known lawyer friends; if none show interest, reassess the Beachhead.

**Cause 2:Lawyers do not trust AI output, usage frequency is low**
*Description*:Lawyers recheck every AI risk identification result from scratch every time; no real time saved, leading to non-renewal.
*Early warning signal*:Trial firm D30 retention <20%, user feedback “AI often misses judgments.”
*Mitigation*:At the MVP stage, start with simple contract types (labor contracts, procurement contracts) rather than complex commercial contracts; lower the AI output confidence threshold, erring on the side of flagging too many risks rather than missing any.

**Cause 3:Competitors enter, generic LLM capability compresses product value**
*Description*:GPT-4o / ERNIE Bot directly offer contract review features; lawyers start using them directly without needing to pay for a specialized tool.
*Early warning signal*:Prospective clients say during the demo “I can just ask ChatGPT.”
*Mitigation*:Quickly build a law-firm-specific contract template library and risk clause database, so the product surpasses the depth of generic LLMs.

**Pivot scan**:If acquiring law firm clients is too difficult, the same tech stack can pivot to **corporate legal departments** (internal legal teams at 100–500 person companies; higher ARPU, faster purchasing decisions, and they have internal budgets).

---

**Investment Verdict**

Decision:**Watch**

Bull thesis:If the founders have law firm connections to quickly validate a trial, a painkiller product + high margin + limited competition in a small market is an excellent small-and-beautiful opportunity.

Bear thesis:Trust in the legal industry builds slowly; if no connections exist, the cold start cost is too high, and a 3-person team will exhaust itself before finding PMF.

**Evidence to see within 6 months**:
1. ≥10 law firms complete trial, of which ≥4 proactively convert to paying.
2. At least 1 law firm provides a publicly referenceable case study and endorsement.
3. One repeatable customer acquisition path exists (not dependent solely on founder’s personal relationships).

**Straight Verdict**:
“Small & Beautiful” — suitable for a 3-person team to operate long-term, healthy cash flow, no need for outside funding, exactly the optimal solution for this team — **provided you have law firm connections**. If not, validate customer acquisition first before building.
