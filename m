From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] cgroup: unexport locking interface and cgroup_attach_task()
Date: Thu,  4 Apr 2013 16:36:27 -0700
Message-ID: <1365118589-10619-4-git-send-email-tj@kernel.org>
References: <1365118589-10619-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=GljUNdBnSKFqzwiq32mCK9ASyfeQU1aHgvyald3YvcI=;
        b=X8l6V5MwkjiYYoOlIlHyLeug9lCtZhac2jvC1olz0u5bjPf8gN8bw3Q/ikEZ5gGnVd
         xK6p72StPYFYItkq3T1f1JkDbJBQNbYBXcuyUMpXX1LI4OlAZziEF6H1CaiGLvb6+Crr
         0Q78tqhdlcKdoA/oactgMg/dWLlTK303RC2WcvtLrl2vHgQwHgp23FdpZOn+k9OjV+jc
         61QUGwS7Wx2aGCpbcY4nH6KOd6zOLBfpR7ZalnMyUDOU5LFOdfweCuJOXZWHscac+fAX
         9VTfMBt4x9Wn2AfFxOR8D/1Cd4zFdzmqGHfhRVo9WYtS5u7Fg9N0DtdbyY8PA3mlZuTo
         j0cA==
In-Reply-To: <1365118589-10619-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Now that all external cgroup_lock() users are gone, we can finally
unexport the locking interface and prevent future abuse of
cgroup_mutex.

Make cgroup_[un]lock() and cgroup_lock_live_group() static.  Also,
cgroup_attach_task() doesn't have any user left and can't be used
without locking interface anyway.  Make it static too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 5 -----
 kernel/cgroup.c        | 9 +++------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f8eb01d..63deb70 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -30,10 +30,7 @@ struct css_id;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
-extern void cgroup_lock(void);
 extern int cgroup_lock_is_held(void);
-extern bool cgroup_lock_live_group(struct cgroup *cgrp);
-extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
 extern void cgroup_post_fork(struct task_struct *p);
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
@@ -693,8 +690,6 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 					struct cgroup_iter *it);
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
-int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
-		       bool threadgroup);
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ae76170..32ca030 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -336,7 +336,7 @@ static inline struct cftype *__d_cft(struct dentry *dentry)
  * On success, returns true; the lock should be later released with
  * cgroup_unlock(). On failure returns false with no lock held.
  */
-bool cgroup_lock_live_group(struct cgroup *cgrp)
+static bool cgroup_lock_live_group(struct cgroup *cgrp)
 {
 	mutex_lock(&cgroup_mutex);
 	if (cgroup_is_removed(cgrp)) {
@@ -345,7 +345,6 @@ bool cgroup_lock_live_group(struct cgroup *cgrp)
 	}
 	return true;
 }
-EXPORT_SYMBOL_GPL(cgroup_lock_live_group);
 
 /* the list of cgroups eligible for automatic release. Protected by
  * release_list_lock */
@@ -824,22 +823,20 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
  * cgroup_lock - lock out any changes to cgroup structures
  *
  */
-void cgroup_lock(void)
+static void cgroup_lock(void)
 {
 	mutex_lock(&cgroup_mutex);
 }
-EXPORT_SYMBOL_GPL(cgroup_lock);
 
 /**
  * cgroup_unlock - release lock on cgroup changes
  *
  * Undo the lock taken in a previous cgroup_lock() call.
  */
-void cgroup_unlock(void)
+static void cgroup_unlock(void)
 {
 	mutex_unlock(&cgroup_mutex);
 }
-EXPORT_SYMBOL_GPL(cgroup_unlock);
 
 /*
  * A couple of forward declarations required, due to cyclic reference loop:
-- 
1.8.1.4
