# Paper Writing Guide

Methodology for drafting and revising each section. Read the relevant part before writing — it encodes what reviewers look for and the mistakes that get papers rejected.

## Table of contents

- [General principles](#general-principles)
- [Abstract](#abstract)
- [Introduction](#introduction)
- [Background & Related Work](#background--related-work)
- [Methodology](#methodology)
- [Evaluation](#evaluation)
- [Threats to Validity](#threats-to-validity)
- [Conclusion](#conclusion)
- [Astronomy papers (AAS journals)](#astronomy-papers-aas-journals)
- [Revision checklist](#revision-checklist)

## General principles

- **One idea per paragraph.** A paragraph that makes two points will be read as making neither. First sentence states the point; the rest supports it; the last sentence links forward.
- **Claims need evidence.** Every comparative ("faster", "more accurate"), every causal ("because"), and every universal ("always") must be backed by a citation, a table, or an explicit qualification. Reviewers hunt for unbacked claims.
- **Tense**: present for facts and the paper itself ("Section 3 presents..."), past for what you did ("we trained the model for..."). Keep it consistent — drift reads as sloppiness.
- **Voice**: prefer active ("we formulate") over passive ("is formulated") — modern venues accept first person. Passive is fine where the actor is irrelevant.
- **Sentence length**: when a sentence passes ~40 words, split it. Long sentences hide quantifiers ("all", "some") that change the meaning.
- **Forward references only for structure.** "As shown in Section 4" is fine; "as discussed above" chains that force re-reading are not.
- **The paper is an argument, not a report.** Every section exists to support the contributions claimed in the introduction. When a paragraph does not, cut it or move it to an appendix.

## Abstract

150–250 words (IEEE conference limit 250). Four moves in order, roughly one to two sentences each:

1. **Problem**: what gap or challenge, and why it matters.
2. **Approach**: the key idea in one sentence — the insight, not the implementation details.
3. **Results**: the headline empirical numbers ("improves F1 by 4.2 points over the strongest baseline on three datasets").
4. **Significance**: what this changes for practitioners/researchers.

Hard rules: no citations (the abstract is copied to indexes where they break), no undefined acronyms, no "this paper is organized as follows". Write the abstract LAST — it is the paper compressed, and you can only compress what exists.

## Introduction

The four-move structure (1–1.5 pages in a conference paper):

1. **Problem context** (1–2 paragraphs). Funnel from the broad area to the specific problem. Open with the tension — a cost, a failure mode, an unsolved case — not with "recent years have seen". The test: could a researcher outside your subfield tell in 30 seconds whether this paper is relevant to them?
2. **Gap** (1 paragraph). What existing approaches do and where they stop. Specific limitation, cited: "profile-guided optimizers [3], [7] rely on ... and therefore cannot handle ...". The gap sentence is the hinge of the whole paper.
3. **This paper** (1–2 paragraphs). "In this paper, we propose X, which ..." Key insight first, mechanism second. A reader should reconstruct the system's shape from these two paragraphs.
4. **Contributions** (bulleted, 3–4 items). Each is a verifiable claim: identification, method, evaluation-with-number. Match them to sections — a contribution with no supporting section is a rejection reason.

Common mistakes: burying the gap (reviewers should not have to infer it); contributions that restate the method's features rather than outcomes; an introduction that is a mini related-work survey.

## Background & Related Work

Two different jobs — keep them separate.

**Background**: only concepts a reviewer needs to follow YOUR paper. For each: define, cite the origin, one sentence on how the paper uses it. If your paper defines a formalism, put it here with numbered equations. Skip the textbook treatment.

**Related work**: organize by theme/approach, never by chronology or paper-by-paper. Each thematic paragraph: (1) what unites the group, (2) 2–4 key works with the specific technique each contributed — cited together as `\cite{a,b}` only when they genuinely share the point, (3) the shared limitation your work addresses. End the section with explicit positioning: "Unlike prior work that X, our approach Y because Z."

A comparison table is worth writing when there are 3+ close competitors: rows = approaches, columns = the properties that constitute your novelty. Be fair in the table — a reviewer who authored row 3 will check it.

Common mistakes: citation dumping (ten cites, zero characterization); arguing against a strawman version of prior work; omitting the most similar paper (reviewers will find it and assume bad faith).

## Methodology

The standard skeleton: Overview → Problem Formulation → Proposed Algorithm → Implementation Details.

- **Overview**: the whole approach in 1–2 paragraphs + an architecture figure. Test: after reading only this, a reviewer should place every later subsection in the pipeline.
- **Formulation**: notation defined once (a notation table if heavy), inputs/outputs, objective. Math must match the prose.
- **Algorithm**: pseudocode for anything with non-trivial control flow (`algorithm` + `algpseudocode` in the templates). Walk through the key steps in prose after the listing; add complexity when it supports a claim.
- **Implementation**: hyperparameters, versions, hardware — the details someone needs to replicate. Every non-obvious design choice gets a *why*: "we use X instead of Y because [reason/ablation ref]". Choices without rationale read as arbitrariness, and reviewers probe arbitrariness.

Common mistakes: math that never connects back to the implementation; hiding the one risky approximation inside prose; figures whose notation differs from the text.

## Evaluation

Structure around research questions (RQs) declared at the top. Every RQ gets answered by at least one table/figure; every table/figure answers exactly one RQ.

- **Setup**: datasets (source, size, splits, preprocessing), baselines (versions, why they are the right comparisons, tuning budget — *equal* budget or the comparison is unfair), metrics (definitions, citations, edge cases), environment. Enough to replicate; full configs in an artifact.
- **Main results**: booktabs table, best in bold, ours last. Then *interpret*: why does the method win, tied to the mechanism ("the gain concentrates on long inputs, consistent with the attention pruning in Sec. 3.2"). State where it loses, honestly.
- **Ablation**: remove one component at a time. This validates the design choices the methodology section argued for.
- **Sensitivity**: vary key hyperparameters; show stability (or honest fragility).
- Report variance: ≥3 seeds with mean±std or error bars. A 0.5-point win inside a ±2-point error bar is not a win, and reviewers know it.

Numbers never stand alone — every table is followed by interpretation. Tables that merely exist, uninterpreted, are the most common evaluation defect.

## Threats to Validity

For empirical/SE venues. Three standard subsections — internal (confounds, bugs, unfair baselines, leakage), external (dataset/domain/scale generalization), construct (do metrics measure the claim). Each threat named specifically and paired with its mitigation; vague boilerplate ("our dataset may be limited") actively damages trust. If the venue doesn't use this section, delete the file and its `\input` line.

## Conclusion

Half a page. Mirror the introduction's contributions, now with results attached. No new claims, no new citations. Future work: 2–3 concrete directions that follow from limitations already named — not a wish list.

## Astronomy papers (AAS journals)

Astronomy papers follow a different arc than the CS sections above — the `aas-journal` template ships its own chapter skeletons (data → method → validation → results → discussion → summary), and each carries detailed guidance in comments. The structural essentials:

- **The Introduction is also the literature review.** There is no Related Work section; prior work is woven in chronologically/thematically as the argument builds, which makes astro introductions longer (2–5 pages). Close with "In this paper, we..." plus a prose preview of results — bulleted contribution lists are rare.
- **Data before Method.** A standalone section establishing the observations, sample selection (with reproducible cuts), and reduction. Reproducibility of the *sample* is the review bar.
- **Validation replaces benchmark evaluation.** Astronomy has no ground-truth labels, so credibility comes from mock/recovery tests (with realism matched to the real data) and comparison with established methods on shared objects.
- **Discussion is distinct from Summary.** Discussion interprets and compares with literature; Summary recaps findings with numbers. Astronomers often read only abstract + Summary — make both self-contained.
- **Citation craft is `\citet` vs `\citep`.** Textual ("Hubble 1926 showed") vs parenthetical ("(Dressler 1980)") — the choice carries meaning; never use numeric-style bare `\cite`.
- Quantify with dex/percent where the field does, report systematic and statistical errors side by side, and remember facility/software acknowledgments (`\facilities`, `\software`) are part of the paper, not optional etiquette.

## Revision checklist

Run this pass before showing anyone the draft:

1. Do the contributions in the introduction match what the evaluation shows?
2. Does every section's first paragraph say what it does?
3. Grep the text for "very", "significantly" (without a test), "obviously", "clearly" — replace with the number or cut.
4. Read only the first sentence of each paragraph, in order — that skeleton should still tell the paper's story.
5. Read the abstract against the final results — numbers must match.
