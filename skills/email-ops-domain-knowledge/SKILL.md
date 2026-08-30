---
name: email-ops-domain-knowledge
version: 1.0.0
description: >
  Domain knowledge for affiliate email lead-gen operations: segment naming
  conventions (Live / D / H / T suffixes), which lists are inbox-placement
  seeds and must be excluded from performance reporting, per-domain compliance
  footers, and the pre-send QA gates. Use whenever the user asks to pull,
  analyze, or report campaign stats (Pinpointe, CAMPS_GMAIL, ManyChat,
  SendGrid), write or QA an email creative or subject line, or discuss
  open rate / click rate / inbox placement for LendinBlue, SnapFundsNow,
  RightFundUSA, NorthPortLoans or sibling loan-vertical domains.
---

# Email Ops Domain Knowledge

Portable version of the learnings captured across the email lead-gen projects.
Load this before touching campaign data, creatives, or deliverability numbers.

## 1. Segment naming conventions

These suffixes are used consistently across LendinBlue, SnapFundsNow and
sibling domains:

| Token | Meaning |
|-------|---------|
| `Live` | Raw / cold data users who have NOT received email from us before |
| `Live_O`, `Live Openers` | Users from the Live segment who opened |
| `1D`, `2D`, `5D`, `15D` | Recency window in **days** (opened/engaged within N days) |
| `1H`, `2H`, `3H` | Recency window in **hours** |
| `50T`, `150T`, `200T` | Frequency in **times** (opened or clicked N times) |

Bulk production segments (`Live`, `5D`, `15D`, `Last`, `CL`) are the only ones
that reflect real subscriber behaviour.

## 2. Seed lists - always exclude from reporting

These are inbox-placement seed / warmup services, not real subscribers:

- **Warmy** (also `Warmy1`) - warmup seed list
- **WSI** - warmup seed internal
- **EM** - email monitor / seed list
- **IA** - internal / inactive seed list

**Why:** they show 23-57% CTR on 1,500-6,000 recipients because they are
controlled test addresses. Reporting them as creative performance is wrong by
an order of magnitude.

**How to apply:** when pulling campaign stats from Pinpointe or CAMPS_GMAIL or
Live_Penetration, filter these rows out before computing blended OR/CTR. Seed
numbers belong in the Seed Reports tab, never in production metrics.

## 3. Compliance footer (RightFundUSA.com)

Every email, template and creative for RightFundUSA must end with this block
verbatim:

```
Sent by RightFundUSA
Sent to: %%emailaddress%%
7272 Theodore Dawes Rd, Ste C, Theodore, AL 36582

You are receiving this ad-supported email because you subscribed at RightFundUSA.
Safely unsubscribe
```

**Why:** sender-identity and CAN-SPAM compliance for the ad-supported mailing
program. The physical address and unsubscribe line are non-optional.

**How to apply:** in HTML, wrap in `<div class="footer">`, keep
`%%emailaddress%%` as a live merge tag (also linked as `mailto:`), and point
"Safely unsubscribe" at `%%unsubscribelink%%`.

Adapt the entity name and street address per domain; the structure stays.

## 4. Pre-send QA gates

Before any send, content passes two checks:

1. The ESP's built-in **SpamAssassin** checker - target **0.0** on both the
   HTML and the plain-text part.
2. **sendcheckit.com** Email Subject Line Tester - target grade **A, 90+**.

Plus a hard size budget: **under 4 KB** total campaign size.

**How to write to pass:**
- No all-caps, no stacked exclamation marks, no currency amounts in raw HTML,
  no classic spam trigger phrases.
- Subject lines: short, lowercase-styled, curiosity-driven, no merge tags, no
  punctuation triggers.
- Inline CSS only. No external assets, no embedded images, no bloated markup.

**Limitation to state out loud:** both tools score *content only*. Neither sees
domain reputation, complaint rate, or actual inbox placement.

## 5. Vertical context

The loan-vertical domains (LendinBlue, SnapFundsNow, RightFundUSA,
NorthPortLoans) target a **US** audience seeking **payday and personal loans**.
Optimize deliverability, copy and list management for that vertical, and treat
CAN-SPAM plus financial-marketing regulation as a hard constraint, not a
nice-to-have.

## 6. InboxKit (Gmail placement lab) architecture notes

If the workspace includes InboxKit, these constraints apply:

- Plain PDO and curl. No framework, no Composer.
- Two deploy trees: `docroot/` holds only `.php` plus `.user.ini` (on LiteSpeed
  any non-PHP file under the docroot is world-readable regardless of
  `.htaccess`), and `private/` holds migrations, docs and tools.
- **All timestamp arithmetic happens in SQL, never in PHP.** Server timezone is
  Asia/Kolkata and the mismatch will bite you.
- Sending is manual by design: the ESP (ManyChat over SendGrid) can read stats
  but cannot create or send campaigns.
- Flow: compose creative -> app injects hidden marker -> manual ESP send to a
  seeds-only list -> cron worker reads each seed over the Gmail API
  (`gmail.readonly`) and records Primary/Updates/Promotions/Social/Spam/
  undelivered from `labelIds` -> score -> Thompson-sample the next tactic.
