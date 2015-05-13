From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] cgroup: simplify threadgroup locking
Date: Wed, 13 May 2015 16:35:18 -0400
Message-ID: <1431549318-16756-4-git-send-email-tj@kernel.org>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RsE28yPE2Es6iC5xhYysSXPryxdnwO7b18h/L9LpxHA=;
        b=Gt4KE/urEad4jnwn4tbRepgZ8KryNJu9P+rtMXXWWBh0KVMub12Gw1RLA/6324evF/
         LPp9WoWMmoV+/vOnUq8+ldhaqTjbkG98jDh4BPcxUI47wzNPCsmWjISYRmUfS8RCVLSn
         QMeYVg0W/c28nZVHxPgK+mo3GHk5iB3aJEvXDA0guLPuKvlz7QxE5xJfFTIAzNy20WAn
         8KAe38staz0GGV1Haaw/HjfF1x6sKYSD9hd09iTfULPv76G8EztwjYh+QBnXAGaojCnM
         sm4rpwSgLmHPb+m/d82x14DHnacQH3+YMqQCXNFnbiSiF8R0GQ3r3ZVKjqZfDIeTRVMe
         DgQw==
In-Reply-To: <1431549318-16756-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Now that threadgroup locking is made global, code paths around it can
be simplified.

* lock-verify-unlock-retry dancing removed from __cgroup_procs_write().

* Race protection against de_thread() removed from
  cgroup_update_dfl_csses().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 48 +++++++++++++-----------------------------------
 1 file changed, 13 insertions(+), 35 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5435b9d..afe9a7e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2401,14 +2401,13 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	if (!cgrp)
 		return -ENODEV;
 
-retry_find_task:
+	percpu_down_write(&cgroup_threadgroup_rwsem);
 	rcu_read_lock();
 	if (pid) {
 		tsk = find_task_by_vpid(pid);
 		if (!tsk) {
-			rcu_read_unlock();
 			ret = -ESRCH;
-			goto out_unlock_cgroup;
+			goto out_unlock_rcu;
 		}
 		/*
 		 * even if we're attaching all tasks in the thread group, we
@@ -2418,9 +2417,8 @@ retry_find_task:
 		if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
 		    !uid_eq(cred->euid, tcred->uid) &&
 		    !uid_eq(cred->euid, tcred->suid)) {
-			rcu_read_unlock();
 			ret = -EACCES;
-			goto out_unlock_cgroup;
+			goto out_unlock_rcu;
 		}
 	} else
 		tsk = current;
@@ -2435,35 +2433,21 @@ retry_find_task:
 	 */
 	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY)) {
 		ret = -EINVAL;
-		rcu_read_unlock();
-		goto out_unlock_cgroup;
+		goto out_unlock_rcu;
 	}
 
 	get_task_struct(tsk);
 	rcu_read_unlock();
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
-	if (threadgroup) {
-		if (!thread_group_leader(tsk)) {
-			/*
-			 * a race with de_thread from another thread's exec()
-			 * may strip us of our leadership, if this happens,
-			 * there is no choice but to throw this task away and
-			 * try again; this is
-			 * "double-double-toil-and-trouble-check locking".
-			 */
-			percpu_up_write(&cgroup_threadgroup_rwsem);
-			put_task_struct(tsk);
-			goto retry_find_task;
-		}
-	}
-
 	ret = cgroup_attach_task(cgrp, tsk, threadgroup);
 
-	percpu_up_write(&cgroup_threadgroup_rwsem);
-
 	put_task_struct(tsk);
-out_unlock_cgroup:
+	goto out_unlock_threadgroup;
+
+out_unlock_rcu:
+	rcu_read_unlock();
+out_unlock_threadgroup:
+	percpu_up_write(&cgroup_threadgroup_rwsem);
 	cgroup_kn_unlock(of->kn);
 	return ret ?: nbytes;
 }
@@ -2610,6 +2594,8 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 
 	lockdep_assert_held(&cgroup_mutex);
 
+	percpu_down_write(&cgroup_threadgroup_rwsem);
+
 	/* look up all csses currently attached to @cgrp's subtree */
 	down_read(&css_set_rwsem);
 	css_for_each_descendant_pre(css, cgroup_css(cgrp, NULL)) {
@@ -2665,17 +2651,8 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 				goto out_finish;
 			last_task = task;
 
-			percpu_down_write(&cgroup_threadgroup_rwsem);
-			/* raced against de_thread() from another thread? */
-			if (!thread_group_leader(task)) {
-				percpu_up_write(&cgroup_threadgroup_rwsem);
-				put_task_struct(task);
-				continue;
-			}
-
 			ret = cgroup_migrate(src_cset->dfl_cgrp, task, true);
 
-			percpu_up_write(&cgroup_threadgroup_rwsem);
 			put_task_struct(task);
 
 			if (WARN(ret, "cgroup: failed to update controllers for the default hierarchy (%d), further operations may crash or hang\n", ret))
@@ -2685,6 +2662,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 
 out_finish:
 	cgroup_migrate_finish(&preloaded_csets);
+	percpu_up_write(&cgroup_threadgroup_rwsem);
 	return ret;
 }
 
-- 
2.1.0
