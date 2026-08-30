# Claude Skills Export Bundle

Everything portable from this machine's Claude Code setup, packaged so it can be
imported on another machine, another user account, or into a repo.

Generated: 2026-08-30
Source layout: `~/.claude` (Claude Code user scope)

---

## Quick import

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

macOS / Linux:

```bash
bash install.sh
```

That installs the 21 core skills into `~/.claude/skills/`. Existing folders are
skipped unless you pass `-Force` / `--force`. Start a new Claude Code session
afterwards to pick them up.

Other flags:

| Flag (ps1 / sh) | Effect |
|---|---|
| `-Project <path>` / `--project <path>` | Install into `<path>/.claude/skills` instead of user scope |
| `-WithGstack` / `--with-gstack` | Also install the 54 gstack wrapper skills |
| `-WithLearnings` / `--with-learnings` | Also copy the raw memory files |
| `-Force` / `--force` | Overwrite skills that already exist |

Manual import works too: copy any folder from `skills/` into
`~/.claude/skills/` or `<repo>/.claude/skills/`. Each folder is a self-contained
skill with its own `SKILL.md`.

---

## What is in the bundle

```
Export-Skills/
  README.md                 this file
  MANIFEST.json             machine-readable inventory of every skill
  install.ps1 / install.sh  importers
  skills/                   21 core skills (import these)
  optional/gstack-skills/   54 wrappers that need the gstack runtime
  learnings/                global CLAUDE.md + raw per-project memory
  config/                   hooks, api-branch scanner, settings reference
```

### Core skills (`skills/`, 21 total)

**Standalone, work anywhere (13):**

| Skill | What it does |
|---|---|
| `dev-protocol` | **Generated from learnings.** Verify-first, spec-first, 3-file deploy batches, anti-drift response rules |
| `email-ops-domain-knowledge` | **Generated from learnings.** Segment naming, seed-list exclusion, compliance footer, pre-send QA gates, InboxKit architecture |
| `digital-marketing-pro` | Affiliate lead-gen marketing: SEO, ads, email, landing pages |
| `fullstack-developer` | Node/Python/React, API design, auth, encryption, security review |
| `ops-manager` | SOPs, trackers, priorities, handoffs across domains and campaigns |
| `security-guardian` | Audits generated code and skills for secrets and vulnerabilities |
| `cyber-security` | Vibe-coded app vulnerabilities plus password storage fundamentals |
| `senior-dev-mode` | Production coding standards, phased execution, mandatory verification |
| `ui-ux-pro-max` | UI/UX intelligence: styles, palettes, font pairings, accessibility |
| `superpowers-brainstorming` | Design before code |
| `superpowers-writing-plans` | Break a spec into bite-sized tasks |
| `superpowers-tdd` | RED-GREEN-REFACTOR enforcement |
| `superpowers-debugging` | Root-cause investigation before fixes |

**Need something installed on the target machine (8):**

| Skill | Requires |
|---|---|
| `gitnexus-cli`, `gitnexus-exploring`, `gitnexus-debugging`, `gitnexus-impact-analysis`, `gitnexus-pr-review`, `gitnexus-refactoring`, `gitnexus-guide` | The GitNexus MCP server, configured in the target's MCP settings |
| `terra` | The gstack runtime. Its preamble calls `~/.claude/skills/gstack/bin/*`. It degrades on missing binaries but was written for gstack |

### Optional gstack skills (`optional/gstack-skills/`, 54 total)

`browse`, `ship`, `qa`, `review`, `investigate`, `spec`, `plan-*-review`,
`ios-*`, `design-*` and the rest. Every one of these is a thin wrapper whose
preamble shells out to `~/.claude/skills/gstack/bin/`. They do nothing useful
without that repo.

To make them work on the target machine, install gstack first
(<https://github.com/garrytan/gstack>, this machine ran v1.58.1.0), then run the
importer with `-WithGstack`. If you install gstack normally it will lay down its
own copies of these wrappers, so importing them is only worth it if you want
this machine's exact versions.

### Learnings (`learnings/`)

- `global-CLAUDE.md` - the global instruction file from `~/.claude/CLAUDE.md`.
  Drop it in as `~/.claude/CLAUDE.md` on the target, or merge it into an
  existing one. Its content is also encoded as the `dev-protocol` skill.
- `raw-memory/<project>/` - the per-project memory files, verbatim, from
  `~/.claude/projects/<slug>/memory/`. Four projects: Lendinblue, RightFundUSA,
  Snapfundnow, InboxKit. Their substance is encoded as the
  `email-ops-domain-knowledge` skill, which is what makes them portable to a
  machine with different project paths.

Memory folders are keyed by an absolute-path slug, so they cannot be copied
blind. `--with-learnings` drops them in `~/.claude/imported-memory/` and you move
each into the matching `~/.claude/projects/<slug>/memory/`.

### Config (`config/`)

- `settings.reference.json` - the source machine's hook wiring. **Not installed
  automatically.** Paths inside are absolute to `C:/Users/sange`, and the hooks
  reference GitNexus and a power-kit that may not exist on the target. Read it,
  rewrite the paths, then merge what you want into the target's
  `~/.claude/settings.json`.
- `hooks/` - the hook scripts themselves (preflight, dev rules guard, memory
  sync and health, session title generator, GitNexus hook).
- `api-branch/` - the API branch scanner invoked at session start.

---

## What was deliberately left out

| Excluded | Why |
|---|---|
| `~/.claude/skills/gstack` | A full git checkout of the upstream gstack repo. Reinstall it from source rather than copying a few hundred MB |
| `plugins/marketplaces/claude-plugins-official` | Upstream Anthropic marketplace (data, anthropic-skills, cowork-plugin-management and the external plugins). Re-add the marketplace on the target instead |
| `.credentials.json`, session transcripts, telemetry, shell snapshots | Secrets and personal session data. These must never leave the machine |

## Notes on cleanup done during export

Several skills on the source machine had a duplicated nested copy of themselves
(`digital-marketing-pro/digital-marketing-pro/...`), an artifact of an earlier
install. The nested copies were byte-identical to the top level and were dropped
from this bundle. The source machine still has them; harmless, but worth
deleting there too.
