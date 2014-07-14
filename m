From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/6] cgroup: initialize cgrp_dfl_root_inhibit_ss_mask from !->dfl_files test
Date: Mon, 14 Jul 2014 11:44:08 -0400
Message-ID: <1405352648-4279-7-git-send-email-tj@kernel.org>
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z87yOd35MD6BUzhFD2em77izRsuCBM0sZcACM4bwe0k=;
        b=mk8hclsN5yN1d+IZ39L3Q+H/flWGFZDPseqZzaDA+iEDRDdQSC2lNsIbojY0kmdhx3
         1O+OugUXi39pfNcdElrEJYTfXAjs16tlvKp0NLO7shpu4nPAixnI9UzQaerNPKM8lCsh
         CYjrOSTzT9oIYYZtKY237NTqBpKj8uMdvW/QSTSfKnhsRMNC6Qr5vUF3yH0sz0u6mj0D
         6CwIBe3pCUlYmInuOyveRWoFTWWSBhT5bt+Gj42yj6tv+Q3V5JbgKbe0KWd6Ki0zq+Df
         b+yw4Ue56pBpOtjkkkiRRSQcB0ZRuVt/zW9bs4FvEdRuoEX7fM0+nQhh/Zz7zaoZJN/p
         TW7w==
In-Reply-To: <1405352648-4279-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgrp_dfl_root_inhibit_ss_mask determines which subsystems are not
supported on the default hierarchy and is currently initialized
statically and just includes the debug subsystem.  Now that there's
cgroup_subsys->dfl_files, we can easily tell which subsystems support
the default hierarchy or not.

Let's initialize cgrp_dfl_root_inhibit_ss_mask by testing whether
cgroup_subsys->dfl_files is NULL.  After all, subsystems with NULL
->dfl_files aren't useable on the default hierarchy anyway.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f41d164..f2a6795 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -156,11 +156,7 @@ static bool cgrp_dfl_root_visible;
 static bool cgroup_legacy_files_on_dfl;
 
 /* some controllers are not supported in the default hierarchy */
-static const unsigned int cgrp_dfl_root_inhibit_ss_mask = 0
-#ifdef CONFIG_CGROUP_DEBUG
-	| (1 << debug_cgrp_id)
-#endif
-	;
+static unsigned int cgrp_dfl_root_inhibit_ss_mask;
 
 /* The list of hierarchy roots */
 
@@ -4939,6 +4935,9 @@ int __init cgroup_init(void)
 		if (cgroup_legacy_files_on_dfl && !ss->dfl_cftypes)
 			ss->dfl_cftypes = ss->legacy_cftypes;
 
+		if (!ss->dfl_cftypes)
+			cgrp_dfl_root_inhibit_ss_mask |= 1 << ss->id;
+
 		if (ss->dfl_cftypes == ss->legacy_cftypes) {
 			WARN_ON(cgroup_add_cftypes(ss, ss->dfl_cftypes));
 		} else {
-- 
1.9.3
