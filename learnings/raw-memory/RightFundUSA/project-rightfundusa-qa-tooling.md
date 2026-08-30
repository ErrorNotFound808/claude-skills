---
name: project-rightfundusa-qa-tooling
description: RightFundUSA email QA gates - SpamAssassin checker in the ESP and sendcheckit for subject lines
metadata:
  type: project
---

Before a RightFundUSA send, content is run through two checks: the ESP's built-in SpamAssassin checker (target 0.0 on both HTML and text) and sendcheckit.com's Email Subject Line Tester (target grade A, 90+). Every template must also come in under 4 KB campaign size.

**Why:** The user validates every template and subject line through these tools and treats passing scores as the go signal. Small payloads render faster, avoid Gmail clipping, and keep the ESP pre-flight checks green.

**How to apply:** Write copy that clears SpamAssassin content rules (no all caps, no exclamation stacking, no currency amounts in the raw HTML, no classic trigger phrases) and keep subject lines short, lowercase-styled, curiosity-driven, no merge tags, no punctuation triggers. Keep total file size under 4 KB (inline CSS only, no external assets, no image embeds, no bloated markup). Note that both tools score content only, not domain reputation or complaint rate. See [[project-rightfundusa-email-footer]].
