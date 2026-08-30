---
name: inboxkit-project-overview
description: "InboxKit is now a Gmail placement lab (PHP 8, no Composer) built fresh on 2026-08-24, replacing the earlier subject-line optimizer"
metadata: 
  node_type: memory
  type: project
  originSessionId: 8d3abe58-9a8e-4cf1-bd19-af3511ea1294
  modified: 2026-08-23T19:36:44.242Z
---

InboxKit was rebuilt from scratch on 2026-08-24 against a new spec. It is no longer the
subject-line scorer described in [[project-bugs]] - that codebase is gone from
`C:\Users\sange\Documents\InboxKit` and its bug notes apply only to the superseded app.

**What it is now:** a Gmail placement lab. Compose a creative, the app injects a hidden marker,
you send manually from the ESP to a seeds-only list, a cron worker reads each seed over the Gmail
API (`gmail.readonly`) and records Primary/Updates/Promotions/Social/Spam/undelivered from
`labelIds`, scores it, and Thompson-samples a tactic to generate the next variant.

**Why:** sending is manual on purpose - the ESP (ManyChat over SendGrid) can read stats but cannot
create or send campaigns.

**How to apply:** plain PDO and curl, no framework, no Composer. Two deploy trees:
`docroot/` holds only `.php` plus `.user.ini` (on LiteSpeed any non-PHP file under the docroot is
world-readable regardless of `.htaccess`), and `private/` holds migrations, docs and tools.
All timestamp arithmetic happens in SQL, never in PHP - see the clock trap section of
`private/DEPLOYMENT.md`. Deploy target is cPanel at eloanlens.com/inboxkit/ over SSH via
`tools/deploy.sh`. Server timezone is Asia/Kolkata.
