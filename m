From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 15/16] cgroup: make cgroup_calc_subtree_ss_mask() take @this_ss_mask
Date: Wed, 24 Feb 2016 17:02:47 -0500
Message-ID: <1456351368-786-16-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vIRvaoNXCW+azYvs/GgReiaW0hpKPhbe+hPjqaNAs7I=;
        b=DQDOclU1/YMkyBH5qq6FY0J/NaxKcp0WwSe9bZkD/E12V6q3kd3drkiWpleh5O7bn6
         xN4tnNsWwqN5ZPjBW97YgRdqWk/ip4Zu1dFEQLztXWDDjzXGbMX64EEfS8JYHA4wG4NF
         Lxvkx4GaZEipxR9HCRa3TqUSHuu4iHGtHX4/CFZD21K1kD0Le42eIn90po8lDYjwSa/X
         7cH/rwSQWZcvsPz9Hh2s5ZyavoJ0qRGu3pC0sDvNtG6OgWT+wvBFdv5Z+/UxYIJGj/J5
         Vi3mCSEX+BY4N/99CtJ9KXQ4nvLK1YGe1oI1fGtGbMotNeDlWJQZooMf3/6oLfFEwjBG
         Uidg==
In-Reply-To: <1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup_calc_subtree_ss_mask() currently takes @cgrp and
@subtree_control.  @cgrp is used for two purposes - to decide whether
it's for default hierarchy and the mask of available subsystems.  The
former doesn't matter as the results are the same regardless.  The
latter can be specified directly through a subsystem mask.

This patch makes cgroup_calc_subtree_ss_mask() perform the same
calculations for both default and legacy hierarchies and take
@this_ss_mask for available subsystems.  @cgrp is no longer used and
dropped.  This is to allow using the function in contexts where
available controllers can't be decided from the cgroup.

v2: cgroup_refres_subtree_ss_mask() is removed by a previous patch.
    Updated accordingly.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 01792a5..744e1c6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1308,18 +1308,17 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 
 /**
  * cgroup_calc_subtree_ss_mask - calculate subtree_ss_mask
- * @cgrp: the target cgroup
  * @subtree_control: the new subtree_control mask to consider
+ * @this_ss_mask: available subsystems
  *
  * On the default hierarchy, a subsystem may request other subsystems to be
  * enabled together through its ->depends_on mask.  In such cases, more
  * subsystems than specified in "cgroup.subtree_control" may be enabled.
  *
  * This function calculates which subsystems need to be enabled if
- * @subtree_control is to be applied to @cgrp.  The returned mask is always
- * a superset of @subtree_control and follows the usual hierarchy rules.
+ * @subtree_control is to be applied while restricted to @this_ss_mask.
  */
-static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
+static u16 cgroup_calc_subtree_ss_mask(u16 subtree_control, u16 this_ss_mask)
 {
 	u16 cur_ss_mask = subtree_control;
 	struct cgroup_subsys *ss;
@@ -1327,9 +1326,6 @@ static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (!cgroup_on_dfl(cgrp))
-		return cur_ss_mask;
-
 	while (true) {
 		u16 new_ss_mask = cur_ss_mask;
 
@@ -1342,7 +1338,7 @@ static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 		 * happen only if some depended-upon subsystems were bound
 		 * to non-default hierarchies.
 		 */
-		new_ss_mask &= cgroup_ss_mask(cgrp);
+		new_ss_mask &= this_ss_mask;
 
 		if (new_ss_mask == cur_ss_mask)
 			break;
@@ -3011,8 +3007,9 @@ static void cgroup_propagate_control(struct cgroup *cgrp)
 
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
 		dsct->subtree_control &= cgroup_control(dsct);
-		dsct->subtree_ss_mask = cgroup_calc_subtree_ss_mask(dsct,
-							dsct->subtree_control);
+		dsct->subtree_ss_mask =
+			cgroup_calc_subtree_ss_mask(dsct->subtree_control,
+						    cgroup_ss_mask(dsct));
 	}
 }
 
-- 
2.5.0
