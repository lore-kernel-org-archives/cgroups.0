From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] cgroup: protect cgroup_root->cgroup_idr with a spinlock
Date: Thu, 24 Apr 2014 17:02:10 -0400
Message-ID: <1398373333-1521-4-git-send-email-tj@kernel.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZTRQUJ0Gf10FSDE2wVV30s6pdQOv3SYI6SB8nU5mjjE=;
        b=isgmuXImzZ1XGy647cAwkdaYYO3HSqCz4ibEq9zj12KwdMmfnX+CZ0D+4U9N2wjYYr
         Pc6nc69p+3ZOrL7Pz/T7CHpjeeGbydI8QL8l71v2rwx9nmqHdyW910Zw/njbeDHGFHSz
         zhhKwFCmID1WABIrjc6iq+J+4/4V9uQS6fno2UxRWXUlMZh8lumFTvg5OZKAQ88RvjXs
         PRQuH8SmNl3IhWBaBx11Y2+Y7kPRm3feQVPINBe9XzokNBWlNH7PWnI74TwfB9IqHFiE
         30wCXMzVXdeEvxcNB7hmqUDG5XEf5Nt/XLh981aplOxlaZnV94pny+dqbOHrMKdID4i0
         omjQ==
In-Reply-To: <1398373333-1521-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, nasa4836@gmail.com, Tejun Heo <tj@kernel.org>

Currently, cgroup_root->cgroup_idr is protected by cgroup_mutex, which
ends up requiring cgroup_put() to be invoked under sleepable context.
This is okay for now but is an unusual requirement and we'll soon add
css->id which will have the same problem but won't be able to simply
grab cgroup_mutex as removal will have to happen from css_release()
which can't sleep.

Introduce cgroup_idr_lock and idr_alloc/replace/remove() wrappers
which protects the idr operations with the lock and use them for
cgroup_root->cgroup_idr.  cgroup_put() no longer needs to grab
cgroup_mutex and css_from_id() is updated to always require RCU read
lock instead of either RCU read lock or cgroup_mutex, which doesn't
affect the existing users.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 51 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3fa0463..7cb9c08 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -100,6 +100,12 @@ static DECLARE_RWSEM(css_set_rwsem);
 #endif
 
 /*
+ * Protects cgroup_idr so that IDs can be released without grabbing
+ * cgroup_mutex.
+ */
+static DEFINE_SPINLOCK(cgroup_idr_lock);
+
+/*
  * Protects cgroup_subsys->release_agent_path.  Modifying it also requires
  * cgroup_mutex.  Reading requires either cgroup_mutex or this spinlock.
  */
@@ -190,6 +196,37 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
 static void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
 
+/* IDR wrappers which synchronize using cgroup_idr_lock */
+static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
+			    gfp_t gfp_mask)
+{
+	int ret;
+
+	idr_preload(gfp_mask);
+	spin_lock(&cgroup_idr_lock);
+	ret = idr_alloc(idr, ptr, start, end, gfp_mask);
+	spin_unlock(&cgroup_idr_lock);
+	idr_preload_end();
+	return ret;
+}
+
+static void *cgroup_idr_replace(struct idr *idr, void *ptr, int id)
+{
+	void *ret;
+
+	spin_lock(&cgroup_idr_lock);
+	ret = idr_replace(idr, ptr, id);
+	spin_unlock(&cgroup_idr_lock);
+	return ret;
+}
+
+static void cgroup_idr_remove(struct idr *idr, int id)
+{
+	spin_lock(&cgroup_idr_lock);
+	idr_remove(idr, id);
+	spin_unlock(&cgroup_idr_lock);
+}
+
 /**
  * cgroup_css - obtain a cgroup's css for the specified subsystem
  * @cgrp: the cgroup of interest
@@ -1058,9 +1095,7 @@ static void cgroup_put(struct cgroup *cgrp)
 	 * per-subsystem and moved to css->id so that lookups are
 	 * successful until the target css is released.
 	 */
-	mutex_lock(&cgroup_mutex);
-	idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 	cgrp->id = -1;
 
 	call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
@@ -1531,7 +1566,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
-	ret = idr_alloc(&root->cgroup_idr, root_cgrp, 1, 2, GFP_KERNEL);
+	ret = cgroup_idr_alloc(&root->cgroup_idr, root_cgrp, 1, 2, GFP_NOWAIT);
 	if (ret < 0)
 		goto out;
 	root_cgrp->id = ret;
@@ -4225,7 +4260,7 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 * Temporarily set the pointer to NULL, so idr_find() won't return
 	 * a half-baked cgroup.
 	 */
-	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_KERNEL);
+	cgrp->id = cgroup_idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_NOWAIT);
 	if (cgrp->id < 0) {
 		err = -ENOMEM;
 		goto err_unlock;
@@ -4268,7 +4303,7 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 * @cgrp is now fully operational.  If something fails after this
 	 * point, it'll be released via the normal destruction path.
 	 */
-	idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
+	cgroup_idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
 	err = cgroup_kn_set_ugid(kn);
 	if (err)
@@ -4302,7 +4337,7 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	return 0;
 
 err_free_id:
-	idr_remove(&root->cgroup_idr, cgrp->id);
+	cgroup_idr_remove(&root->cgroup_idr, cgrp->id);
 err_unlock:
 	mutex_unlock(&cgroup_mutex);
 err_unlock_tree:
@@ -5162,7 +5197,7 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	struct cgroup *cgrp;
 
-	cgroup_assert_mutexes_or_rcu_locked();
+	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	cgrp = idr_find(&ss->root->cgroup_idr, id);
 	if (cgrp)
-- 
1.9.0
