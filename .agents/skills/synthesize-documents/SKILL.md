---
name: synthesize-documents
description: Synthesize multiple provided documents into one comprehensive replacement document. Use when the user asks to merge, consolidate, reconcile, summarize comprehensively, produce a consensus report, integrate several drafts/reviews/memos, or create a final synthesis that preserves shared points, minority-only points, disagreements, source structures, user-specific requirements, and evidence-based evaluation.
---

<!-- Ver 2026-05-10 15:09, by GPT-5 -->

# Synthesize Documents

Use this skill to turn several source documents into one rigorous synthesis that can replace the inputs. The core task is not to average the documents. It is to preserve the full content surface: what most documents agree on, what only some documents mention, where documents disagree, and which minority points deserve to survive after evaluation.

## Core Principles

- Read all provided documents before synthesizing.
- Preserve all major points from every input document, including minority views and disagreements.
- Separate source extraction, consensus building, disagreement mapping, evaluation, and final writing.
- Do not treat frequency as truth. Use frequency to classify consensus, then use evidence and context to judge validity.
- Do not force false precision. When the inputs depend on tacit knowledge, practitioner judgment, or local context, state the uncertainty and evaluate the practical implications.
- Use external search only when it materially affects factual evaluation, current facts, market/regulatory context, or user-requested verification. Cite sources when external search is used.
- Make the final document coherent enough to stand alone, not a stitched list of summaries.

## Workflow

Follow these steps in order.

### Step 1: Confirm Inputs And Goal

Identify:

- the full set of source documents, including file paths, attachments, pasted text, URLs, or prior chat content;
- the expected output format and destination, especially whether the user wants a new Markdown file;
- any extra user requirements, such as target audience, language, tone, structure, length, or whether the final document should replace the older documents.

If source coverage is ambiguous, ask one short clarification question. If the user clearly provided the sources, proceed.

### Step 2: Build A Source Inventory

For each document, extract a compact "document card":

- source name or path;
- document type and likely purpose;
- top-level structure;
- core claims, recommendations, or conclusions;
- key evidence, examples, assumptions, and definitions;
- points that seem unique to this document;
- obvious gaps, weak claims, or internal tensions.

Use this inventory for reasoning. Include it in the final output only when the user asks for traceability or when the synthesis would otherwise be hard to audit.

### Step 3: Classify The Content Surface

Group extracted points into four buckets:

1. **Shared consensus**: most documents mention the point and broadly agree.
2. **Partial consensus**: several documents mention the point, but each contributes different structure, details, examples, or emphasis.
3. **Minority-only content**: one or a few documents mention the point, while most documents are silent.
4. **Disagreement or tension**: documents make incompatible claims, recommend different priorities, use conflicting assumptions, or frame the problem differently in a way that changes the final recommendation.

When classifying, distinguish silence from disagreement. A point is not false merely because most documents omit it.

### Step 4: Build The Consensus Backbone

Turn shared and partial consensus into the main body structure.

Rules:

- Use the best structure from the input documents, or create a clearer structure when none is strong enough.
- Merge overlapping points into one coherent section.
- Pull in the strongest details, examples, definitions, caveats, and implementation steps from all relevant documents.
- Avoid repetitive attribution unless the final document is explicitly an audit report.
- Mark uncertainty where the inputs agree on direction but not on mechanism, magnitude, sequencing, or evidence.

The consensus backbone should feel like a complete document, not a comparison table.

### Step 5: Evaluate Minority And Divergent Points

Create a concise evaluation section for content that did not become part of the main consensus body.

Use practical groupings such as:

- minority but likely valid additions;
- minority but context-dependent points;
- direct disagreements requiring a choice;
- unsupported or weak claims;
- outdated, fact-sensitive, or externally verifiable claims;
- useful framing differences that should influence wording but not change the main conclusion.

For each point, state:

- what the point says;
- which source(s) raised it, if useful;
- why it differs from the mainstream synthesis;
- evaluation: accept, partially accept, reject, or leave as an open question;
- brief rationale grounded in source evidence, context, and external verification when used.

Keep this section sharper and shorter than the main body. The goal is not to litigate every sentence, but to make sure no non-consensus point disappears without judgment.

### Step 6: Search Or Verify When Needed

Use search when:

- the point depends on current facts, laws, prices, API behavior, market conditions, product availability, company status, or standards;
- sources conflict about a factual matter that can be checked;
- the user explicitly requests external evidence;
- accepting or rejecting a minority claim would materially change the final recommendation.

When using external sources:

- prefer primary or authoritative sources for technical, legal, medical, financial, regulatory, or official facts;
- cite links in the final output;
- distinguish verified facts from inference;
- do not over-expand the final document with raw research notes.

If search is not available or not worth the time, say the evaluation is based only on the provided documents and context.

### Step 7: Write The Final Synthesis

Produce a final document that can replace the inputs.

Default structure:

1. Title
2. Executive summary
3. Scope and source basis
4. Main synthesis built from consensus and partial consensus
5. Integrated details, examples, decisions, and practical implications
6. Minority points, disagreements, and evaluation
7. Final conclusions or recommendations
8. Remaining uncertainties, open questions, or next actions
9. Sources or appendix, only when useful

Adapt the structure to the user's requested format or the source material. For example, a product strategy synthesis may need "Decision", "Rationale", "Execution Plan", and "Risks"; a research synthesis may need "Findings", "Evidence", and "Limitations".

### Step 8: Save Or Deliver

If the user asks to save the output:

- create a new Markdown file unless the user specified an exact target path;
- include the model name suffix in the filename when the repo convention requires it;
- add the required version header for the workspace;
- preserve the original documents unless the user explicitly asks to delete or replace them.

If the user asks for chat-only output, return the synthesis directly.

## Output Standards

The synthesis must:

- cover every source document's main content;
- explicitly handle non-consensus and disagreement points;
- make clear which points are accepted, rejected, partially accepted, or left uncertain;
- keep the main body comprehensive and the evaluation section concise;
- avoid generic filler and abstract summary language;
- use concrete examples, counterexamples, and practical implications where they clarify meaning;
- be readable as a standalone document.

Before finalizing, check:

- Did every input document materially influence either the main synthesis or the minority/disagreement evaluation?
- Did any unique source point get silently dropped?
- Did the final structure improve on the input documents instead of merely concatenating them?
- Are factual claims either supported by the provided documents, externally cited, or clearly marked as judgment?
- Does the final answer satisfy the user's extra requirements?
