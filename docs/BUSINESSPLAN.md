# GlobalFlavors — Business Plan

**One‑page Lean Canvas (Google Slides):** [Open the slide](https://docs.google.com/presentation/d/1AdgIL1-TdeeoC_RMIq0idQqPlhmNeccVTQsqzTekolU/edit?slide=id.gc8216bd24_20_0#slide=id.gc8216bd24_20_0)

---

# GlobalFlavors — Lean Canvas

## Problem

- Home cooks want authentic regional dishes but don't know where to start or what’s actually authentic.
- Turning a recipe into a shoppable cart is tedious; ingredients & grocery lists are scattered across sites.
- Local ingredient availability and culturally accurate substitutions—especially with dietary needs—are unclear.
- Many cooks have a confidence gap in the kitchen; they want guided steps, timers, and confirmations.

## Solution

**V1 (8 weeks)**

- Region‑first discovery → country/region → dish → curated recipe.
- One‑tap grocery list generation and “send to cart” deep links.
- Local availability + dietary flags (vegan, halal, gluten‑free, etc.).
- Guided cook mode with timers and step confirmations.

**V2 (post‑beta)**

- AI assistant for substitution guidance and step help.
- Pantry sync (track staples; auto‑remove what you already have).
- Social features: save, share, and remix culturally authentic dishes.

## Unique Value Proposition

- **Tagline:** Discover authentic regional dishes you can cook tonight.
- **Promise:** Culture‑first browsing + local‑ingredient substitutions + one‑tap grocery checkout.

## Advantage (Unfair)

- **Culture Graph:** Links regions → dishes → ingredients → viable local substitutes.
- **Curator Network:** Chefs and adept home cooks verify authenticity.
- **Data Network Effects:** Feedback on substitutions and outcomes continuously improves picks.
- **Retail Integrations:** Cart deep links with Instacart/Walmart/Amazon Fresh affiliates.

## Customer Segments

- **Primary:** Adults 20–40 in 1–2 person households seeking authentic, weeknight‑friendly meals.
- **Secondary:** New immigrants and travelers recreating dishes from abroad.
- **Early Adopters:** Foodies already using Instacart or Walmart Online Grocery.

## Channels

- SEO for “authentic [dish] at home,” regional pages, and culture guides.
- Partnerships with cultural student orgs, travel bloggers, and ethnic grocers.
- App store optimization + in‑app referral loops.
- Social (short‑form video, UGC challenges, Discord/Reddit communities).

## Key Metrics

- **North Star:** Completed “recipe → cart checkout” per weekly active user.
- **Activation:** A1 Discovery→Recipe Open ≥ 60%/session; A2 Recipe→Grocery List ≥ 35%; A3 List→Cart Sent ≥ 25% within 3 days.
- **Retention:** ≥ 2 dishes cooked/month/user; 4‑week retention ≥ 25%; NPS ≥ 40.

## Revenue

- Affiliate commissions from grocery carts (Instacart, Walmart, Amazon Fresh).
- Premium tier: $4.99/month or $29.99/year for advanced substitutions, offline cook cards, and AI assistant upgrades.
- Future: Sponsored placements by grocers/brands for culturally accurate products.

## Cost Structure

- Cloud hosting + CDN + push notifications.
- Third‑party APIs (recipes, catalogs/availability, locations).
- LLM inference for substitution prompts and step guidance.
- Content curation & moderation; creator stipends.
- Marketing and community.

## App Proposal & Feasibility

This MVP is feasible in eight weeks using readily available APIs and affiliate programs. The critical path is: (1) a region‑first search experience that maps region→dish→ingredients using a curated recipe set; (2) grocery‑list generation and cart deep links for Instacart/Walmart/Amazon Fresh via affiliate integrations; (3) local availability and dietary flags from retailer catalog APIs; and (4) a guided cook mode with timers and confirmations. The UI can be a mobile‑first web app with React + a lightweight backend (Python/Node) and a document store for recipes and the Culture Graph. Analytics will instrument the A1/A2/A3 funnel from day one. Post‑beta, an AI assistant handles substitution suggestions, pantry sync, and step‑by‑step help. This scope avoids heavy custom integrations, keeps compliance within standard affiliate terms, and is sized for a student team to ship and learn quickly.

---
