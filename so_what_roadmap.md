# So-what roadmap — state of discussion (2026-08-13)

Notes from the working session on the missing "so-what" of *Internal Securities Markets*.
Purpose: pick this up tomorrow without re-litigating anything.

---

## 1. The big-picture claim we converged on

**Intragroup markets are the only mechanism by which anyone can trade across the gates
that segment funding markets — CCP membership, client franchises, supervisory geography —
and that makes global banks the (concentrated) infrastructure connecting national
liquidity pools.**

- The gates are *legal*, not frictional: memberships and client relationships are
  non-tradable, so no external market can bridge segments. Only groups owning
  endowments on both sides of a gate can cross — by trading with themselves.
- Where Stein-style internal capital markets substitute for *failed* external markets,
  ours substitute for *legally impossible* ones.
- Framing discipline: we can show **integration** (measurable), not **efficiency**
  (normative, unidentifiable). Welfare = discussion section (integration gains vs.
  hidden leverage / drain), never the headline.
- Why chains exist at all (key institutional insight): the ECB desk-mapping regime pinned
  the market-facing leg onshore (EU entity) while the client franchise stayed in London.
  The chain reconciles conflicting regulatory and client geographies. The Brexit
  migrations changed the **form** of the crossing (UK sub clearing directly at the EA CCP
  → EA sub clears + intragroup to London), not the **function** — cross-border
  intermediation existed throughout.
- One-liner candidates: "the intragroup market is what replaced passporting";
  "access to the world's core funding markets is intermediated by a handful of firms
  trading with themselves, at prices nobody sees, in a market no regulator observes whole."

## 2. Ground rules established (do not violate tomorrow)

1. **Visibility.** EUR: we see euro-area entities' legs (intragroup, cleared, direct
   trades incl. vs Cayman funds) and UK subs' *cleared* trades via the CCP leg. We never
   see the EUR HF leg (booked at UK subs of foreign groups). USD: we see UK branches of
   EA groups (HF legs + intragroup legs); never the US cleared leg.
2. **Intragroup-necessity rule.** An analysis counts only if it needs the intragroup
   transactions themselves (EUR side, where chain volume is the *only* trace of hidden
   HF positioning). Anything running off the USD HF legs uses the reporting perimeter,
   not intragroups.
3. **No intragroup causality.** An intragroup repo is internal implementation of a group
   decision — it cannot be a causal agent separate from that decision. The so-what is
   measurement, structure, and mechanism-tracing; not "intragroups cause X".
4. There is **no function-removal experiment** in this sample (see graveyard). Don't hunt
   for the kill-shot; build the five analyses below.

## 3. The five surviving analyses (the empirical core)

### 3.1 The drain number (headline quantification)
Hedge funds' total claim on the euro-area collateral float = direct route + chain route
(both from the matched construction; the two are economically identical, so they add).
Price it with the **borrowed QE elasticity** (Arrata–Nguyen–Rahmouni-Rousseau–Vari, JFE
2020 — Benoit's paper): in a standard supply–demand framework the spot price responds to
the *excess-demand shift*, so one unit of chain borrowing demand = one unit of withdrawn
float. Quantities from accounting, slope from supply-side identification → endogeneity
objection removed.
- **Correction from discussion:** repo removes nothing permanently. Correct statement: a
  rolled chain position is a persistent claim on the daily lendable supply. Persistence
  is measurable from term/rollover fields — that's what licenses the QE analogy.
- **Recirculation adjustment λ:** the short-sold bond lands with a buyer who may re-lend.
  Report gross (λ=0, upper bound) and λ-adjusted numbers. λ partially measurable: does
  total cleared lending in a bond expand following chain take-up?
- Headline shape: "leveraged shorting absorbs X% as much float as the Eurosystem did;
  more than half of it runs through banks' internal markets, invisible to every national
  observer."
- Inputs: chain volumes (done); amounts outstanding per ISIN (public); Eurosystem
  holdings per ISIN (via Benoit); persistence + λ checks (our data).

### 3.2 Gates structure + migration natural experiments (form)
- **Org chart predicts chains:** a group runs a chain iff client franchise and CCP
  membership sit on opposite sides of a gate. Cross-section with public Eurex/LCH
  RepoClear member lists. (Simple; fine as a table/robustness.)
- **Migrations (staggered, documented, powered):** GS ramps 2022-08-16 → 2022-09-18
  (15→40bn outstanding); MS at its own date; JPM present throughout (benchmark).
  Confirmed organizational: composition flips from UK-sub-direct-clearing to
  EA-sub + intragroup. Squeeze coincidence handled: ramp precedes gilt crisis
  (starts 2022-09-23) and the acute Oct–Dec squeeze; staggering across groups is the
  defense (a demand story predicts synchronized ramps).
- Tests: **seam continuity** (group's *total* cleared sourcing per bond continuous while
  composition flips — demand held fixed); **transfer price at birth** (when the chain
  switches on, is the intragroup leg priced at the market cleared rate from day one?
  nobody has observed an internal market being born); functional split (chain-matched
  sourcing moves to EA sub, own-account may stay at UK entity — linked/unlinked
  decomposition).

### 3.3 Calendar test, headroom-interacted (regulation's calendar becomes a market cycle)
Pre-migration the crossing lived in a UK entity consolidating to a US parent
(daily-average SLR; year-end G-SIB) → year-end pressure only. Post-migration it lives in
an EU institution with **point-in-time quarter-end** leverage reporting → Q1–Q3
sensitivity should *appear* at migration.
- **Fact-checked (2026-08):** EU binding LR is still quarter-end point-in-time; averaging
  exists only in disclosure; ECB imposed LR add-ons Dec 2023 on window-dressers (biases
  against us = conservative); Basel Mar 2024 daily-average proposal = consultation only.
  ECB evidence (Bassi et al., JFI 2024): repo cut ~12.5% at quarter-ends, ~25% at
  year-ends.
- **User's chart insight:** quarter-end dips are irregular → treatment is
  "quarter-end × how binding the constraint is". Interact with **public Pillar 3
  headroom** of GSBE / MSESE / JPMSE (quarterly; also disclosed spot-vs-average gap as
  validation). Book doubled 40→80bn over sample → headroom shrank → dips emerge late,
  consistent with chart.
- Check **prices not just volumes** (constrained entity may keep volume and charge a
  quarter-end wedge on the intragroup rate). Year-end = always-on anchor (dip ratio).
- Triple-diff table: pre (no Q-dip, Y-dip) vs post (Q-dip appears, Y-dip); EA banks
  always Q-dip (no change at migration dates); migrators stagger as each other's controls.
- Null is publishable too: "formally onshored, economically unconstrained" (subs too
  overcapitalized for the EU calendar to bind).

### 3.4 Shadow price of the gate (matched-leg spreads)
- EUR: intragroup rate − same-bond-same-day cleared rate within the EA sub (how the
  specialness rent transfers along the chain).
- USD: HF rate − intragroup rate at the UK branch; benchmark vs SOFR (public) for the
  full markup vs the cleared benchmark.
- Market-power cut (new): spread vs number of competing chains serving that bond —
  rent increasing in corridor concentration = "structural monopoly" as a number.
- Caveats: tenor-match the legs (term fields); transfer prices may be administered —
  either finding is informative (market-priced internal market vs quantities-only
  reallocation).
- Splice logic (if needed): EUR shows the internal leg's wedge directly; USD shows the
  client markup; combining assumes group-wide transfer-pricing practice (arm's-length
  rules) — state it, test the EUR half.

### 3.5 Basket-entry / futures-roll events (function switch-on, bond level)
Deliverable-basket entry switches on offshore basis demand for a specific bond at
mechanically predetermined times (issuance calendar + contract specs). Watch how the
marginal demand arrives: route split (chain vs direct), speed, and what happens to
specialness / bid-ask. Hundreds of events, exogenous timing. Delivers "the crossing
carries the marginal offshore demand", NOT a removal counterfactual — don't overclaim.

### Optional: the model
Two gated pools + client franchises; internal market as the only crossing technology;
chains form endogenously where endowments straddle gates. Earns its keep only through
predictions we test: currency mirror, pass-through ≈ 1 at the conduit, spread = shadow
price of the gate, drain vs integration channels for liquidity. Welfare = trade-off
discussion. If it doesn't predict beyond these, skip it.

### Liquidity outcome (runs through 3.3/3.5)
Bond-day bid-ask/depth (MTS via Benoit). Two competing channels, sign pairs adjudicate:
- drain: chain take-up → borrow costs ↑ → wider spreads (operates *through* specialness);
- integration: global investor base / turnover → tighter spreads.
E.g. specialness ↑ **and** bid-ask tighter = integration dominates the drain.

## 4. Graveyard (killed, with reasons — do not resurrect)

| Idea | Cause of death |
|---|---|
| Spillover designs (Apr 2025 → EUR via EA groups) | Branch = same legal entity (no intragroup channel needed); USD intragroup runs London↔NY, not →Frankfurt; internal legs are implementation, not channels |
| Fund/dealer-pair contagion designs | Only 2 dominant USD-chain banks = the 2 biggest (collinear with size); survives only as pair-level FE design, but the intragroup market itself does no work |
| Clearing-mandate scope quantification | Too transient/policy-cycle-bound (user call). Context kept for motivation: repo mandate 2027-06-30; inter-affiliate exemption + outward-facing condition fights (SIFMA/MFA 2026) |
| Haircut facts | EUR HF leg invisible; USD version doesn't need intragroups; portfolio margining contests levels |
| Twin bonds + conditional return prediction | Internally inconsistent: if hidden shorts are priced, twins can't look identical today |
| Augmenting Arrata et al. regression with demand | Just adding a regressor (≠ revision). Borrowing their *elasticity* is fine → 3.1 |
| CS failure as centerpiece | Power: ~€2bn peak net outstanding vs GS alone 40bn (~1–2% of system). Optional close-out: bond-level share histogram; keep as narrative case study. A−B−C logic (chain bonds vs unlinked-CS bonds vs clean) was sound — reusable if a bigger exit ever appears |
| Year-end as chain-specific event | Common shock: EA banks + US G-SIB + market-wide all shut at year-end |
| Naive quarter-end dummy | Irregular effects; needs headroom interaction (→ 3.3) |
| UK-only holidays as node switch-off | Checked in data: EUR desks follow the TARGET calendar; London EUR books trade through UK holidays |
| Pooled OLS specialness-on-chain-volume as causal | Joint determination conceded in paper; replaced by 3.1's borrowed elasticity + predetermined-rollover component + 3.5 events |

**Identification tools that survived** for any pricing regression: predetermined
rollover component of chain volume (term fields — positions contracted before today's
specialness innovation); basket-entry events. CTD status as IV: dead (demand arrives
through all routes), fine as event study.

## 5. Key dates & facts reference

- JPM SE created (LU+IE merged into Frankfurt AG→SE): **2022-01-22**
- ECB desk-mapping conclusions (rates desks incl. EGBs must relocate; 70% back-to-back;
  21% of 264 desks flagged): **2022-05-19**; binding decisions H2 2022→; Nov 2023
  stocktake: 56 material desks local/enhanced
- MS Europe SE under direct ECB supervision: **2022-09-02** (~$120bn migration announced
  Dec 2020)
- GS ramp in our data: **2022-08-16 → 2022-09-18** (15→40bn); GS euro-swaps desk move
  reported Nov 2022
- Gilt crisis: 2022-09-23 → 2022-10-14; Finanzagentur +€54bn for repo lending: Oct 2022;
  bund squeeze peak: year-end 2022
- CS: PB exit announced 2021-11 (not visible in our chain data); run Oct 2022; death
  2023-03-19; UBS legal merger Jun 2023
- ECB LR add-ons for window dressing: Dec 2023; Basel daily-average G-SIB consultation:
  Mar 2024 (not in force)
- UK-only closures (TARGET open) 2021–2025: 2021-05-03, 05-31, 08-30, 12-27, 12-28;
  2022-05-02, 06-02, 06-03, 08-29, 09-19, 12-27; 2023-01-02, 05-08, 05-29, 08-28;
  2024-05-06, 05-27, 08-26; 2025-05-05, 05-26, 08-25. Reverse (TARGET-only): 2024-05-01,
  2025-05-01. (Now only relevant as calendar hygiene.)
- **Data-quality flag:** near-zero volume days 2026-03-18 and 2026-04-28 are NOT
  holidays → check reporting completeness (count of reporting entities) and T2S/CCP
  incident logs; blacklist from all event windows.

## 6. To-do list for next session

1. Verify GS/MS flip dates from our volume series against the public org dates above;
   confirm staggering (JPM flat, GS/MS at own dates).
2. Seam-continuity plot: each migrator's *total* cleared sourcing per bond around its
   migration (sum continuous, composition flips?).
3. Persistence of chain positions (term/rollover fields) + recirculation check (λ):
   both feed 3.1.
4. Ask Benoit: Eurosystem holdings by ISIN (float denominator, 3.1); MTS bid-ask/depth
   (liquidity outcome).
5. Collect Pillar 3 leverage headroom series for GSBE / MSESE / JPMSE (quarterly,
   public), incl. disclosed spot-vs-average SFT gap (3.3).
6. Check PRA solo leverage-ratio scope for GSI/MSIP pre-2022 (should be out of scope —
   retail-deposit-based; confirms "no Q-end incentive pre-migration").
7. Investigate the two near-zero data days; blacklist if feed gaps.
8. Transfer-price-at-birth: pull intragroup rates vs cleared rates for GS/MS in the
   first weeks post-flip (3.2).
9. (Optional, to close CS out:) histogram of CS bond-level chain shares pre-2022-10.

## 7. Sources for checked facts

- JPM SE: jpmorgan.com corporate news 2022 (consolidation into single EU entity)
- ECB desk-mapping: bankingsupervision.europa.eu blog 2022-05-19; SSM newsletter
  2023-11-15 (post-Brexit stocktake)
- MS: Bloomberg 2020-12-10 ($120bn to Frankfurt); ECB significance assessment 2022
- Window dressing: Bassi–Behn–Grill–Waibel, JFI 2024 (ECB WP 2771); ECB blog
  "Closing the blinds" 2024-05-02; ECB Macroprudential Bulletin 2023-12; BIS/BCBS
  statement on LR window dressing
- Treasury clearing (motivation only): SEC compliance dates extension (repo 2027-06-30);
  SIFMA/MFA exemptive-relief requests 2026; SEC order 2026-06-18 (captive clearing subs)
- Arrata, Nguyen, Rahmouni-Rousseau, Vari (JFE 2020): QE scarcity elasticity for 3.1
