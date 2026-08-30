---
name: segment-terminology
description: Email segment naming conventions and seed provider list used across LendinBlue and sibling domains
metadata: 
  node_type: memory
  type: project
  originSessionId: c489eb37-b897-41c5-880e-91f6a5e5e10e
---

## Segment naming conventions

- **Live** = raw/cold data users who have NOT received emails from us before (fresh list, no prior sends)
- **Live_O / Live Openers** = users from the Live (raw) segment who opened the email
- **1D, 2D, 3D, 4D, 5D...** = recency windows in **Days** (e.g. 1D Opener = opened within last 1 day)
- **1H, 2H, 3H...** = recency windows in **Hours** (e.g. 3H Opener = opened within last 3 hours)
- **50T, 150T, 200T...** = frequency in **Times** (e.g. 50T Opener = opened 50 times; used for Openers or Clickers)

## Seed providers (always treat as seeds, not production)

These are inbox-placement seed test services, not real subscribers:
- **Warmy**
- **WSI**
- **EM**
- **IA**

**Why:** When analyzing data, filter these out of production metrics. Seed data goes in the Seed Reports tab, not in production OR/CTR calculations.

**How to apply:** When pulling CAMPS_GMAIL or Live_Penetration data, if any rows reference these as segments or sources, treat them as test/seed data. Do not mix with production performance numbers.
