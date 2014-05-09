From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/9] cgroup: move check_for_release(parent) call to the end of cgroup_destroy_locked()
Date: Fri,  9 May 2014 17:13:30 -0400
Message-ID: <1399670015-23463-5-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pftK/LeTPlpFXkocsBHTbFrLXpMOpw/jrCVB3toJ3+4=;
        b=qm4CTUQEAUz/WbStIjkzRo+TJnFr/RHtHdbuHlvrLMbSpmbCOI9ytjGAOGbc3y2vhO
         epNh0Q07DW05wH3P+Wi3YJkdOIkBleIffpsdeTmeBbutVoZb208KikJCiYZBIl04O2op
         5UwoEFq78K4mTiKog7Mf2yl0XKzwLqFD4Vpgy14pQTcrPQlvlkG3GSZcjJ27E3I1Cho0
         T3Q5uXjfy6+FGJq63yivdpaXdSw7PQ+TDd5rAX/713dRjmfzfDEjODhO+jMdBY6DmeTc
         y/3NflSWKroXyR0P1b0XvaeU3kQlnBi7THxDwvhgUvApwGMnHYmt7uVCiHuieEzA4s7g
         M69g==
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Currently, check_for_release() on the parent of a destroyed cgroup is
invoked from cgroup_destroy_css_killed().  This is because this is
where the destroyed cgroup can be removed from the parent's children
list.  check_for_release() tests the emptiness of the list directly,
so invoking it before removing the cgroup from the list makes it think
that the parent still has children even when it no longer does.

This patch updates check_for_release() to use
cgroup_has_live_children() instead of directly testing ->children
emptiness and moves check_for_release(parent) earlier to the end of
cgroup_destroy_locked().  As cgroup_has_live_children() ignores
cgroups marked DEAD, check_for_release() functions correctly as long
as it's called after asserting DEAD.

This makes release notification slightly more timely and more
importantly enables further simplification of cgroup destruction path.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d369f19..45149b7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4541,6 +4541,9 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 */
 	kernfs_remove(cgrp->kn);
 
+	set_bit(CGRP_RELEASABLE, &cgrp->parent->flags);
+	check_for_release(cgrp->parent);
+
 	return 0;
 };
 
@@ -4555,17 +4558,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
  */
 static void cgroup_destroy_css_killed(struct cgroup *cgrp)
 {
-	struct cgroup *parent = cgrp->parent;
-
 	lockdep_assert_held(&cgroup_mutex);
 
 	/* delete this cgroup from parent->children */
 	list_del_rcu(&cgrp->sibling);
 
 	cgroup_put(cgrp);
-
-	set_bit(CGRP_RELEASABLE, &parent->flags);
-	check_for_release(parent);
 }
 
 static int cgroup_rmdir(struct kernfs_node *kn)
@@ -5005,7 +5003,7 @@ void cgroup_exit(struct task_struct *tsk)
 static void check_for_release(struct cgroup *cgrp)
 {
 	if (cgroup_is_releasable(cgrp) &&
-	    list_empty(&cgrp->cset_links) && list_empty(&cgrp->children)) {
+	    list_empty(&cgrp->cset_links) && !cgroup_has_live_children(cgrp)) {
 		/*
 		 * Control Group is currently removeable. If it's not
 		 * already queued for a userspace notification, queue
-- 
1.9.0
