---
name: InboxKit bug fixes
description: 3 bugs found and fixed in May 2026 initial review
type: project
originSessionId: a734066d-a660-4993-a439-4fc31c1ad8bc
---
Three bugs found and fixed in the initial code review (2026-05-23):

**Bug 1 (CRITICAL) — view helper $content overwrite** (fixed)
File: `app/helpers.php`, `view()` function
The outer `ob_get_clean()` call overwrote `$content` that view files set via their own inner `ob_start()`/`ob_get_clean()`. All pages rendered with empty layout content.
Fix: renamed outer buffer capture to `$directOutput`, preserved view-set `$content`.

**Bug 2 (CRITICAL) — session FK violation for guests** (fixed)
File: `app/Session.php` line 63, `migrations/002_nullable_session_user.sql` created
Guest sessions stored `user_id = 0`, violating NOT NULL FK on `user_sessions.user_id`. Session writes silently failed → CSRF tokens lost → login/register always returned CSRF mismatch.
Fix: changed `$userId ?: 0` to `$userId` (null for guests) + new migration to make column nullable.

**Bug 3 (MEDIUM) — JS hardcoded absolute paths** (fixed)
Files: `public/assets/js/scorer.js`, `app/Views/domains/show.php`
Fetch calls used `/scorer/preview`, `/scorer/save`, `/domains/{id}/recheck` — these fail in subdirectory deployment at `/inboxkit/`.
Fix: added `<meta name="app-base">` to `app.php` layout, updated JS to prefix `baseUrl`.

**Bug 4 (CRITICAL) — Router didn't strip subdirectory prefix** (fixed)
File: `app/Router.php`, `dispatch()` method
The router matched routes against raw `REQUEST_URI`. Deployed at `/inboxkit/`, the dispatch path was `/inboxkit/login` but the registered route was `/login` → every URL returned 404.
Fix: parse `APP_URL` path, strip it from the incoming path before route matching.

**Minor — 404 page broken home link** (fixed)
File: `app/Views/errors/404.php`
Used `$GLOBALS['__app_url']` (never set) instead of `url('/')`.

**Why:** These were all pre-deployment bugs in the initial codebase.
**How to apply:** Run migration 002 on the cPanel MySQL database before deploying.
