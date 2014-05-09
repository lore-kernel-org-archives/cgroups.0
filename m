From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/9] cgroup: move cgroup->sibling unlinking to cgroup_put()
Date: Fri,  9 May 2014 17:13:31 -0400
Message-ID: <1399670015-23463-6-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cff60gbw+V2tuCPLOCQicHXGrcjg4XL2tonScR03Fls=;
        b=mScnanZTOwrsnNgKWK/lXkJsjuidZdUrOKtfW7sqf3BOxKb5ZXgV3UU3ezZn3bxTRz
         orISn11rFQxkk0GfkroSSOVwSoaRTnxE3j7eaGjkzMipY9m/c+PNzea9e1YOXnpGZmtn
         zo2fSexHXe7GJtHV5AcstDkJUDgBBMa309eM9xr5OXUW2OO6HKs46oTbQZ6Y+AIoWxGm
         kt9xanUK7NlhzUvxpFiuuSN9fN6MEVoLNjuP3aYUC98uC4Z+JDSxPxl+gZgtBMXFvUQm
         rCllymRrO+tYbboE6cZyj2Gl1M4bIeoJYmBPpw5xTIRhWffbQ2CB1fm1e25tkHfm5+wY
         CvHA==
In-Reply-To: <1399670015-23463-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Move cgroup->sibling unlinking from cgroup_destroy_css_killed() to
cgroup_put().  This is later but still before the RCU grace period, so
it doesn't break css_next_child() although there now is a larger
window in which a dead cgroup is visible during css iteration.  As css
iteration always could have included offline csses, this doesn't
affect correctness; however, it does make css_next_child() fall back
to reiterting mode more often.  This also makes cgroup_put() directly
take cgroup_mutex, which limits where it can be called from.  These
are not immediately problematic and will be dealt with later.

This change enables simplification of cgroup destruction path.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 45149b7..87ea2ce 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1056,6 +1056,11 @@ static void cgroup_put(struct cgroup *cgrp)
 	if (WARN_ON_ONCE(cgrp->parent && !cgroup_is_dead(cgrp)))
 		return;
 
+	/* delete this cgroup from parent->children */
+	mutex_lock(&cgroup_mutex);
+	list_del_rcu(&cgrp->sibling);
+	mutex_unlock(&cgroup_mutex);
+
 	cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 	cgrp->id = -1;
 
@@ -4560,9 +4565,6 @@ static void cgroup_destroy_css_killed(struct cgroup *cgrp)
 {
 	lockdep_assert_held(&cgroup_mutex);
 
-	/* delete this cgroup from parent->children */
-	list_del_rcu(&cgrp->sibling);
-
 	cgroup_put(cgrp);
 }
 
-- 
1.9.0
