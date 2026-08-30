---
name: project-rightfundusa-email-footer
description: Required footer block for all RightFundUSA.com email content
metadata:
  type: project
---

All content created for RightFundUSA.com must end with this exact footer:

```
Sent by RightFundUSA
Sent to: %%emailaddress%%
7272 Theodore Dawes Rd, Ste C, Theodore, AL 36582

You are receiving this ad-supported email because you subscribed at RightFundUSA.
Safely unsubscribe
```

**Why:** Compliance and sender-identity requirement for the ad-supported mailing program; the physical address and unsubscribe line are non-optional.

**How to apply:** Append verbatim to every email, template, or creative for this project. In HTML, wrap in `<div class="footer">`, keep `%%emailaddress%%` as a live merge tag (also linked as `mailto:`), and point "Safely unsubscribe" at `%%unsubscribelink%%`. Existing templates in the project root (template_v1_credit_update.html and siblings) are the reference implementation.
