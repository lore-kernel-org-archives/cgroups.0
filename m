From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] cgroup: deactivate CSS's and mark cgroup dead before invoking ->pre_destroy()
Date: Wed, 31 Oct 2012 12:44:06 -0700
Message-ID: <1351712650-23709-5-git-send-email-tj@kernel.org>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=2DRQZarZMXPwbdJi76XN0ECdRbY3cXEzEc6umsMsqYM=;
        b=tKiO3uBxZGKrWueSFOSwoPGT21/z+JjdBX5Wo0O63XlCj7yjSWoyzgKCagGLWAwe3N
         PGtJxxPQMNaMQX7D6MEuS/2jahWY3Cutp2nFp+0p49Ln75JcdcK3Oo62EGMW/HMWJO6s
         JBjFfbajiRUuudzpGVtTPQy8XZOicwt2VYMOEEf4ZBZZBJ9sM6ONjFJpdggKdFDOjkGi
         oMQkuBpFFt873cHu0bX+HCcjUb6u+/DlJ+SN22+0Hku9g/tI6meQcPM7+cu8hn/WyLVg
         emA0BJJ22f40WIleWUJco7uoN80nP2pxt7n+kJB4Z/U9IteKVQoHl0TdJpeytMNZGqNX
         GOmQ==
In-Reply-To: <1351712650-23709-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>

Because ->pre_destroy() could fail and can't be called under
cgroup_mutex, cgroup destruction did something very ugly.

  1. Grab cgroup_mutex and verify it can be destroyed; fail otherwise.

  2. Release cgroup_mutex and call ->pre_destroy().

  3. Re-grab cgroup_mutex and verify it can still be destroyed; fail
     otherwise.

  4. Continue destroying.

In addition to being ugly, it has been always broken in various ways.
For example, memcg ->pre_destroy() expects the cgroup to be inactive
after it's done but tasks can be attached and detached between #2 and
#3 and the conditions that memcg verified in ->pre_destroy() might no
longer hold by the time control reaches #3.

Now that ->pre_destroy() is no longer allowed to fail.  We can switch
to the following.

  1. Grab cgroup_mutex and verify it can be destroyed; fail otherwise.

  2. Deactivate CSS's and mark the cgroup removed thus preventing any
     further operations which can invalidate the verification from #1.

  3. Release cgroup_mutex and call ->pre_destroy().

  4. Re-grab cgroup_mutex and continue destroying.

After this change, controllers can safely assume that ->pre_destroy()
will only be called only once for a given cgroup and, once
->pre_destroy() is called, the cgroup will stay dormant till it's
destroyed.

This removes the only reason ->pre_destroy() can fail - new task being
attached or child cgroup being created inbetween.  Error out path is
removed and ->pre_destroy() invocation is open coded in
cgroup_rmdir().

v2: cgroup_call_pre_destroy() removal moved to this patch per Michal.
    Commit message updated per Glauber.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
---
 kernel/cgroup.c | 65 +++++++++++++++++----------------------------------------
 1 file changed, 19 insertions(+), 46 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f22e3cd..66204a6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -851,27 +851,6 @@ static struct inode *cgroup_new_inode(umode_t mode, struct super_block *sb)
 	return inode;
 }
 
-/*
- * Call subsys's pre_destroy handler.
- * This is called before css refcnt check.
- */
-static int cgroup_call_pre_destroy(struct cgroup *cgrp)
-{
-	struct cgroup_subsys *ss;
-	int ret = 0;
-
-	for_each_subsys(cgrp->root, ss) {
-		if (!ss->pre_destroy)
-			continue;
-
-		ret = ss->pre_destroy(cgrp);
-		if (WARN_ON_ONCE(ret))
-			break;
-	}
-
-	return ret;
-}
-
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
@@ -4078,19 +4057,6 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	DEFINE_WAIT(wait);
 	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
-	int ret;
-
-	/* the vfs holds both inode->i_mutex already */
-	mutex_lock(&cgroup_mutex);
-	if (atomic_read(&cgrp->count) != 0) {
-		mutex_unlock(&cgroup_mutex);
-		return -EBUSY;
-	}
-	if (!list_empty(&cgrp->children)) {
-		mutex_unlock(&cgroup_mutex);
-		return -EBUSY;
-	}
-	mutex_unlock(&cgroup_mutex);
 
 	/*
 	 * In general, subsystem has no css->refcnt after pre_destroy(). But
@@ -4103,16 +4069,7 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	 */
 	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 
-	/*
-	 * Call pre_destroy handlers of subsys. Notify subsystems
-	 * that rmdir() request comes.
-	 */
-	ret = cgroup_call_pre_destroy(cgrp);
-	if (ret) {
-		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
-		return ret;
-	}
-
+	/* the vfs holds both inode->i_mutex already */
 	mutex_lock(&cgroup_mutex);
 	parent = cgrp->parent;
 	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
@@ -4122,13 +4079,30 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	}
 	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
 
-	/* block new css_tryget() by deactivating refcnt */
+	/*
+	 * Block new css_tryget() by deactivating refcnt and mark @cgrp
+	 * removed.  This makes future css_tryget() and child creation
+	 * attempts fail thus maintaining the removal conditions verified
+	 * above.
+	 */
 	for_each_subsys(cgrp->root, ss) {
 		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
 
 		WARN_ON(atomic_read(&css->refcnt) < 0);
 		atomic_add(CSS_DEACT_BIAS, &css->refcnt);
 	}
+	set_bit(CGRP_REMOVED, &cgrp->flags);
+
+	/*
+	 * Tell subsystems to initate destruction.  pre_destroy() should be
+	 * called with cgroup_mutex unlocked.  See 3fa59dfbc3 ("cgroup: fix
+	 * potential deadlock in pre_destroy") for details.
+	 */
+	mutex_unlock(&cgroup_mutex);
+	for_each_subsys(cgrp->root, ss)
+		if (ss->pre_destroy)
+			WARN_ON_ONCE(ss->pre_destroy(cgrp));
+	mutex_lock(&cgroup_mutex);
 
 	/*
 	 * Put all the base refs.  Each css holds an extra reference to the
@@ -4144,7 +4118,6 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 
 	raw_spin_lock(&release_list_lock);
-	set_bit(CGRP_REMOVED, &cgrp->flags);
 	if (!list_empty(&cgrp->release_list))
 		list_del_init(&cgrp->release_list);
 	raw_spin_unlock(&release_list_lock);
-- 
1.7.11.7
