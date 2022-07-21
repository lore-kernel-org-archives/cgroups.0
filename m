From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 7/9] sched/psi: cache parent psi_group to speed up groups iterate
Date: Thu, 21 Jul 2022 12:04:37 +0800
Message-ID: <20220721040439.2651-8-zhouchengming@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nv+1NkEw7UxRZmLxeUo4cV9wyQ4QwqO39uBVndf0jCc=;
        b=bjY6/TWcojIR7yKS1J162GCjohPw3F5UgNwyHYopIXrwMDDhzYOMpRFhjZVlve2jnH
         kwdjjXY0qDCbrgsz9WqbVpRuWZ/Nk7Cif76tkZSmkDPqpohm0J91WwUChBE04lhb8UU6
         bMa1rinjFXXBuHRFDZOwH0rNyd98UByXccx+txf36+XCjX5EV3NqhMqC3PlNEnfNZQy4
         sHCEu0mXQGJwGoB3sYRlhw6YgYO8xUYWKpfM52re2Nmhn49YQgpmwu1sxezhoEs33P10
         4N27susZxutNT6NYKpZM7N3Cvs6ft7Km3OvrjajXEjV79pIlZYZeeEzOl/rfVJwGi1Mp
         499g==
In-Reply-To: <20220721040439.2651-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

We use iterate_groups() to iterate each level psi_group to update
PSI stats, which is a very hot path.

In current code, iterate_groups() have to use multiple branches and
cgroup_parent() to get parent psi_group for each level, which is not
very efficient.

This patch cache parent psi_group, only need to get psi_group of task
itself first, then just use group->parent to iterate.

And this patch is preparation for the following patch, in which we can
configure PSI to only account for leaf cgroups and system-wide.

Performance test on Intel Xeon Platinum with 3 levels of cgroup:

1. before the patch:

$ perf bench sched all
 # Running sched/messaging benchmark...
 # 20 sender and receiver processes per group
 # 10 groups == 400 processes run

     Total time: 0.032 [sec]

 # Running sched/pipe benchmark...
 # Executed 1000000 pipe operations between two processes

     Total time: 8.077 [sec]

       8.077648 usecs/op
         123798 ops/sec

2. after the patch:

$ perf bench sched all
 # Running sched/messaging benchmark...
 # 20 sender and receiver processes per group
 # 10 groups == 400 processes run

     Total time: 0.032 [sec]

 # Running sched/pipe benchmark...
 # Executed 1000000 pipe operations between two processes

     Total time: 7.758 [sec]

       7.758354 usecs/op
         128893 ops/sec

Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/psi_types.h |  2 ++
 kernel/sched/psi.c        | 48 ++++++++++++++++++++-------------------
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index c7fe7c089718..c124f7d186d0 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -147,6 +147,8 @@ struct psi_trigger {
 };
 
 struct psi_group {
+	struct psi_group *parent;
+
 	/* Protects data used by the aggregator */
 	struct mutex avgs_lock;
 
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index aa40bf888102..2228cbf3bdd3 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -758,30 +758,22 @@ static void psi_group_change(struct psi_group *group, int cpu,
 		schedule_delayed_work(&group->avgs_work, PSI_FREQ);
 }
 
-static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
+static inline struct psi_group *task_psi_group(struct task_struct *task)
 {
-	if (*iter == &psi_system)
-		return NULL;
-
 #ifdef CONFIG_CGROUPS
 	if (static_branch_likely(&psi_cgroups_enabled)) {
-		struct cgroup *cgroup = NULL;
-
-		if (!*iter)
-			cgroup = task->cgroups->dfl_cgrp;
-		else
-			cgroup = cgroup_parent(*iter);
+		struct cgroup *cgroup = task_dfl_cgroup(task);
 
-		if (cgroup && cgroup_parent(cgroup)) {
-			*iter = cgroup;
+		if (cgroup && cgroup_parent(cgroup))
 			return cgroup_psi(cgroup);
-		}
 	}
 #endif
-	*iter = &psi_system;
 	return &psi_system;
 }
 
+#define for_each_psi_group(group) \
+	for (; group; group = group->parent)
+
 static void psi_flags_change(struct task_struct *task, int clear, int set)
 {
 	if (((task->psi_flags & set) ||
@@ -799,12 +791,11 @@ static void psi_flags_change(struct task_struct *task, int clear, int set)
 
 void psi_change_groups(struct task_struct *task, int clear, int set)
 {
+	struct psi_group *group = task_psi_group(task);
 	int cpu = task_cpu(task);
-	struct psi_group *group;
-	void *iter = NULL;
 	u64 now = cpu_clock(cpu);
 
-	while ((group = iterate_groups(task, &iter)))
+	for_each_psi_group(group)
 		psi_group_change(group, cpu, clear, set, now, true);
 }
 
@@ -822,7 +813,6 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 {
 	struct psi_group *group, *common = NULL;
 	int cpu = task_cpu(prev);
-	void *iter;
 	u64 now = cpu_clock(cpu);
 
 	if (next->pid) {
@@ -833,8 +823,8 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		 * we reach the first common ancestor. Iterate @next's
 		 * ancestors only until we encounter @prev's ONCPU.
 		 */
-		iter = NULL;
-		while ((group = iterate_groups(next, &iter))) {
+		group = task_psi_group(next);
+		for_each_psi_group(group) {
 			if (per_cpu_ptr(group->pcpu, cpu)->tasks[NR_ONCPU]) {
 				common = group;
 				break;
@@ -874,9 +864,12 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 
 		psi_flags_change(prev, clear, set);
 
-		iter = NULL;
-		while ((group = iterate_groups(prev, &iter)) && group != common)
+		group = task_psi_group(prev);
+		for_each_psi_group(group) {
+			if (group == common)
+				break;
 			psi_group_change(group, cpu, clear, set, now, wake_clock);
+		}
 
 		/*
 		 * TSK_ONCPU is handled up to the common ancestor. If we're tasked
@@ -884,7 +877,8 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		 */
 		if (sleep || unlikely(prev->in_memstall != next->in_memstall)) {
 			clear &= ~TSK_ONCPU;
-			for (; group; group = iterate_groups(prev, &iter))
+
+			for_each_psi_group(group)
 				psi_group_change(group, cpu, clear, set, now, true);
 		}
 	}
@@ -953,6 +947,8 @@ void psi_memstall_leave(unsigned long *flags)
 #ifdef CONFIG_CGROUPS
 int psi_cgroup_alloc(struct cgroup *cgroup)
 {
+	struct cgroup *parent;
+
 	if (!static_branch_likely(&psi_cgroups_enabled))
 		return 0;
 
@@ -960,6 +956,12 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 	if (!cgroup->psi.pcpu)
 		return -ENOMEM;
 	group_init(&cgroup->psi);
+
+	parent = cgroup_parent(cgroup);
+	if (parent && cgroup_parent(parent))
+		cgroup->psi.parent = cgroup_psi(parent);
+	else
+		cgroup->psi.parent = &psi_system;
 	return 0;
 }
 
-- 
2.36.1

