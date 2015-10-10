From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 05/14] cgroup: relocate cgroup_[try]get/put()
Date: Fri,  9 Oct 2015 23:29:32 -0400
Message-ID: <1444447781-16182-6-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=us7Kq+k+ZrYZRuEsLnFEc3YmEELG/EStXrQUOA/FNNw=;
        b=hO3ZExiwfHa7hhboo5aqYEbdRPUoU41yU2DTlW+JGFX0UQYBD+dIv4SObb6jgRLRKz
         xRzoNhOjx876BoD92YWH2et1j7G6BYgHVZLubaOYyCymxIbSm3QWavMTdS0RploqSUSa
         C50WE7LB+qZw9W6oAPtPAQiTD3vvMPNWpPwJONSA/239Mmm9/R5eV15bposboYIhIXSK
         0giSD7+9TCTZfirNTXOUniuNpEAPQeA+IqAeHe4OkgNnoXfJyNppqW7VzoWjlzYrDGOR
         zZYucF9r1cMqumf6P8qXLGww97rR6Y3fsNZuQsx6LoA6ZtHWH0NyCFdZ4vTchvNAigAr
         NLpw==
In-Reply-To: <1444447781-16182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Relocate cgroup_get(), cgroup_tryget() and cgroup_put() upwards.  This
is pure code reorganization to prepare for future changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 855313d..ab5c9a5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -428,6 +428,22 @@ static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 	return !(cgrp->self.flags & CSS_ONLINE);
 }
 
+static void cgroup_get(struct cgroup *cgrp)
+{
+	WARN_ON_ONCE(cgroup_is_dead(cgrp));
+	css_get(&cgrp->self);
+}
+
+static bool cgroup_tryget(struct cgroup *cgrp)
+{
+	return css_tryget(&cgrp->self);
+}
+
+static void cgroup_put(struct cgroup *cgrp)
+{
+	css_put(&cgrp->self);
+}
+
 struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 {
 	struct cgroup *cgrp = of->kn->parent->priv;
@@ -1177,22 +1193,6 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	return mode;
 }
 
-static void cgroup_get(struct cgroup *cgrp)
-{
-	WARN_ON_ONCE(cgroup_is_dead(cgrp));
-	css_get(&cgrp->self);
-}
-
-static bool cgroup_tryget(struct cgroup *cgrp)
-{
-	return css_tryget(&cgrp->self);
-}
-
-static void cgroup_put(struct cgroup *cgrp)
-{
-	css_put(&cgrp->self);
-}
-
 /**
  * cgroup_calc_child_subsys_mask - calculate child_subsys_mask
  * @cgrp: the target cgroup
-- 
2.4.3
