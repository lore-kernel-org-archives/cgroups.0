From: Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: [PATCH] cgroup: Relax restrictions on kernel threads moving out of root cpu cgroup
Date: Tue,  6 Apr 2021 18:34:21 +0530
Message-ID: <1617714261-18111-1-git-send-email-pkondeti@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617714279; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=rCDKaPHDQvX5uyzx5udCPYExGBhOBNh2+q0ngF9qAZE=; b=lNHr4+GqoLuXlzX286ZUv+W/kTRjHliBRXcBESOdXSR4uAQANDTXQPu3zuTEAPbQzVDqTUB3
 p4sBxOim5nd8s7HBbHxDvAAErAz3bASjGPp4oSeeDgcPG6L9Yl4km5ZOSi1RCmPGtzAcKdAz
 Qye7q3+/8LQ7Jx/cdRARUbx1v4o=
Sender: pkondeti=codeaurora.org@mg.codeaurora.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Quentin Perret <qperret@google.com>, Wei Wang <wvw@google.com>, Pavankumar Kondeti <pkondeti@codeaurora.org>

In Android GKI, CONFIG_FAIR_GROUP_SCHED is enabled [1] to help prioritize
important work. Given that CPU shares of root cgroup can't be changed,
leaving the tasks inside root cgroup will give them higher share
compared to the other tasks inside important cgroups. This is mitigated
by moving all tasks inside root cgroup to a different cgroup after
Android is booted. However, there are many kernel tasks stuck in the
root cgroup after the boot.

We see all kworker threads are in the root cpu cgroup. This is because,
tasks with PF_NO_SETAFFINITY flag set are forbidden from cgroup migration.
This restriction is in place to avoid kworkers getting moved to a cpuset
which conflicts with kworker affinity. Relax this restriction by explicitly
checking if the task is moving out of a cpuset cgroup. This allows kworkers
to be moved out root cpu cgroup when cpu and cpuset cgroup controllers
are mounted on different hierarchies.

We also see kthreadd_task and any kernel thread created after the Android boot
also stuck in the root cgroup. The current code prevents kthreadd_task moving
out root cgroup to avoid the possibility of creating new RT kernel threads
inside a cgroup with no RT runtime allocated. Apply this restriction when tasks
are moving out of cpu cgroup under CONFIG_RT_GROUP_SCHED. This allows all
kernel threads to be moved out of root cpu cgroup if the kernel does not
enable RT group scheduling.

[1] https://android.googlesource.com/kernel/common/+/f08f049de11c15a4251cb1db08cf0bee20bd9b59

Signed-off-by: Pavankumar Kondeti <pkondeti@codeaurora.org>
---
v2:
- Added cgroup_task_migration_allowed() wrapper function

 kernel/cgroup/cgroup-internal.h | 28 +++++++++++++++++++++++++++-
 kernel/cgroup/cgroup-v1.c       |  2 +-
 kernel/cgroup/cgroup.c          | 13 ++++---------
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index bfbeabc..cd69302 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -202,6 +202,31 @@ static inline void get_css_set(struct css_set *cset)
 	refcount_inc(&cset->refcount);
 }
 
+static inline bool cgroup_task_migration_allowed(struct task_struct *tsk,
+						 struct cgroup *dst_cgrp)
+{
+	/*
+	 * RT kthreads may be born in a cgroup with no rt_runtime allocated.
+	 * Just say no.
+	 */
+#ifdef CONFIG_RT_GROUP_SCHED
+	if (tsk->no_cgroup_migration && (dst_cgrp->root->subsys_mask & (1U << cpu_cgrp_id)))
+		return false;
+#endif
+
+	/*
+	 * kthreads may acquire PF_NO_SETAFFINITY during initialization.
+	 * If userland migrates such a kthread to a non-root cgroup, it can
+	 * become trapped in a cpuset. Just say no.
+	 */
+#ifdef CONFIG_CPUSETS
+	if ((tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) &&
+			(dst_cgrp->root->subsys_mask & (1U << cpuset_cgrp_id)))
+		return false;
+#endif
+	return true;
+}
+
 bool cgroup_ssid_enabled(int ssid);
 bool cgroup_on_dfl(const struct cgroup *cgrp);
 bool cgroup_is_thread_root(struct cgroup *cgrp);
@@ -232,7 +257,8 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 		       bool threadgroup);
 struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
-					     bool *locked)
+					     bool *locked,
+					     struct cgroup *dst_cgrp)
 	__acquires(&cgroup_threadgroup_rwsem);
 void cgroup_procs_write_finish(struct task_struct *task, bool locked)
 	__releases(&cgroup_threadgroup_rwsem);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index a575178..d674a6c 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -497,7 +497,7 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
 	if (!cgrp)
 		return -ENODEV;
 
-	task = cgroup_procs_write_start(buf, threadgroup, &locked);
+	task = cgroup_procs_write_start(buf, threadgroup, &locked, cgrp);
 	ret = PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9153b20..44cc653 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2744,7 +2744,8 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 }
 
 struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
-					     bool *locked)
+					     bool *locked,
+					     struct cgroup *dst_cgrp)
 	__acquires(&cgroup_threadgroup_rwsem)
 {
 	struct task_struct *tsk;
@@ -2783,13 +2784,7 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
 	if (threadgroup)
 		tsk = tsk->group_leader;
 
-	/*
-	 * kthreads may acquire PF_NO_SETAFFINITY during initialization.
-	 * If userland migrates such a kthread to a non-root cgroup, it can
-	 * become trapped in a cpuset, or RT kthread may be born in a
-	 * cgroup with no rt_runtime allocated.  Just say no.
-	 */
-	if (tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) {
+	if (!cgroup_task_migration_allowed(tsk, dst_cgrp)) {
 		tsk = ERR_PTR(-EINVAL);
 		goto out_unlock_threadgroup;
 	}
@@ -4740,7 +4735,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	if (!dst_cgrp)
 		return -ENODEV;
 
-	task = cgroup_procs_write_start(buf, threadgroup, &locked);
+	task = cgroup_procs_write_start(buf, threadgroup, &locked, dst_cgrp);
 	ret = PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

