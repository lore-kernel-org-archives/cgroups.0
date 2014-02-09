From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/16] cgroup: cosmetic updates to cgroup_attach_task()
Date: Sun,  9 Feb 2014 08:52:43 -0500
Message-ID: <1391953964-22088-16-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3QnS6leigibZ1s0GNPB6Ve1SHpGtz+Uv3yEMPVhOBGc=;
        b=cUR3gZgOmI2NwzP4/0kV7BiojcJhpDe/Q6PMy/7zK/VdW+UX+Zzf9kWoLa/+u3KeMu
         C+rrCE04iDQ/veBnMutkfH6MwIwhtnk4bDb3KUV4nSgy+v/6wKT3tyx0jQX5CW2WaeLx
         2vHe+QaYku6RC0sfGW+XD4X4NLAXoGnxP9k84x4qIV0IADwgZCmi/wTBFveVpuCM4hOF
         xBuTYfEvbLb4S1HbEDVw+sgQ2Mv8EaTRTXzaAb6vamXEoYyixlteM3fcGA5zybExU3V3
         8ZoEn/tUc6xFJiIIaW7vw9jIoPW0d/w5GnBdAObYDq5UGpHuA66ayHbQBn2JlHdXB7mp
         H4aA==
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_attach_task() is planned to go through restructuring.  Let's
tidy it up a bit in preparation.

* Update cgroup_attach_task() to receive the target task argument in
  @leader instead of @tsk.

* Rename @tsk to @task.

* Rename @retval to @ret.

This is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0108753..057ab96 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1727,20 +1727,20 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 /**
  * cgroup_attach_task - attach a task or a whole threadgroup to a cgroup
  * @cgrp: the cgroup to attach to
- * @tsk: the task or the leader of the threadgroup to be attached
+ * @leader: the task or the leader of the threadgroup to be attached
  * @threadgroup: attach the whole threadgroup?
  *
  * Call holding cgroup_mutex and the group_rwsem of the leader. Will take
  * task_lock of @tsk or each thread in the threadgroup individually in turn.
  */
-static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
+static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *leader,
 			      bool threadgroup)
 {
-	int retval, i, group_size;
+	int ret, i, group_size;
 	struct cgroupfs_root *root = cgrp->root;
 	struct cgroup_subsys_state *css, *failed_css = NULL;
 	/* threadgroup list cursor and array */
-	struct task_struct *leader = tsk;
+	struct task_struct *task;
 	struct task_and_cgroup *tc;
 	struct flex_array *group;
 	struct cgroup_taskset tset = { };
@@ -1753,7 +1753,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	 * threads exit, this will just be an over-estimate.
 	 */
 	if (threadgroup)
-		group_size = get_nr_threads(tsk);
+		group_size = get_nr_threads(task);
 	else
 		group_size = 1;
 	/* flex_array supports very large thread-groups better than kmalloc. */
@@ -1761,8 +1761,8 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	if (!group)
 		return -ENOMEM;
 	/* pre-allocate to guarantee space while iterating in rcu read-side. */
-	retval = flex_array_prealloc(group, 0, group_size, GFP_KERNEL);
-	if (retval)
+	ret = flex_array_prealloc(group, 0, group_size, GFP_KERNEL);
+	if (ret)
 		goto out_free_group_list;
 
 	i = 0;
@@ -1773,17 +1773,18 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	 */
 	down_read(&css_set_rwsem);
 	rcu_read_lock();
+	task = leader;
 	do {
 		struct task_and_cgroup ent;
 
-		/* @tsk either already exited or can't exit until the end */
-		if (tsk->flags & PF_EXITING)
+		/* @task either already exited or can't exit until the end */
+		if (task->flags & PF_EXITING)
 			goto next;
 
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
-		ent.task = tsk;
-		ent.cgrp = task_cgroup_from_root(tsk, root);
+		ent.task = task;
+		ent.cgrp = task_cgroup_from_root(task, root);
 		/* nothing to do if this task is already in the cgroup */
 		if (ent.cgrp == cgrp)
 			goto next;
@@ -1791,13 +1792,13 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
 		 */
-		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
-		BUG_ON(retval != 0);
+		ret = flex_array_put(group, i, &ent, GFP_ATOMIC);
+		BUG_ON(ret != 0);
 		i++;
 	next:
 		if (!threadgroup)
 			break;
-	} while_each_thread(leader, tsk);
+	} while_each_thread(leader, task);
 	rcu_read_unlock();
 	up_read(&css_set_rwsem);
 	/* remember the number of threads in the array for later. */
@@ -1806,7 +1807,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	tset.tc_array_len = group_size;
 
 	/* methods shouldn't be called if no task is actually migrating */
-	retval = 0;
+	ret = 0;
 	if (!group_size)
 		goto out_free_group_list;
 
@@ -1815,8 +1816,8 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	 */
 	for_each_css(css, i, cgrp) {
 		if (css->ss->can_attach) {
-			retval = css->ss->can_attach(css, &tset);
-			if (retval) {
+			ret = css->ss->can_attach(css, &tset);
+			if (ret) {
 				failed_css = css;
 				goto out_cancel_attach;
 			}
@@ -1834,7 +1835,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		old_cset = task_css_set(tc->task);
 		tc->cset = find_css_set(old_cset, cgrp);
 		if (!tc->cset) {
-			retval = -ENOMEM;
+			ret = -ENOMEM;
 			goto out_put_css_set_refs;
 		}
 	}
@@ -1862,9 +1863,9 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	/*
 	 * step 5: success! and cleanup
 	 */
-	retval = 0;
+	ret = 0;
 out_put_css_set_refs:
-	if (retval) {
+	if (ret) {
 		for (i = 0; i < group_size; i++) {
 			tc = flex_array_get(group, i);
 			if (!tc->cset)
@@ -1873,7 +1874,7 @@ out_put_css_set_refs:
 		}
 	}
 out_cancel_attach:
-	if (retval) {
+	if (ret) {
 		for_each_css(css, i, cgrp) {
 			if (css == failed_css)
 				break;
@@ -1883,7 +1884,7 @@ out_cancel_attach:
 	}
 out_free_group_list:
 	flex_array_free(group);
-	return retval;
+	return ret;
 }
 
 /*
-- 
1.8.5.3
