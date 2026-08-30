---
name: segment-naming-conventions
description: "SnapFundsNow email segment naming conventions - what Live, D, H, T suffixes mean and which lists are seeds"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 6d37fad7-59ca-4875-a252-42e147ca4556
---

## Segment naming conventions (SnapFundsNow / Pinpointe)

**Live** = raw data users who have NOT received emails from us before (fresh/unsent)
**Live_O / Live Openers** = raw data users who have opened after receiving

**D suffix (Days):** 1D, 2D, 3D, 5D, 15D = users who opened/engaged within that many days
**H suffix (Hours):** 1H, 2H, 3H = users who opened/engaged within that many hours
**T suffix (Times):** 50T, 150T, 200T = users who opened or clicked that many times (frequency-based)

## Seed/test lists (always exclude from real performance reporting)

These are internal seed/warmup lists - NOT real subscriber engagement:
- **Warmy / Warmy1** = warmup seed list
- **WSI** = warmup seed internal
- **EM** = email monitor/seed list
- **IA** = internal/inactive seed list

**Why:** These lists show 23-57% CTR on 1,500-6,000 recipients because they are controlled test addresses. Never report their metrics as real creative performance.

**How to apply:** When pulling campaign stats from Pinpointe or CAMPS_GMAIL, filter out Warmy/WSI/EM/IA rows before computing blended OR/CTR. Only bulk production segments (Live, 5D, 15D, Last, CL, etc.) reflect real subscriber behavior.

Related: [[snapfundsnow-segmentation-model]]
