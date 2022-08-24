From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v3 09/10] sched/psi: cache parent psi_group to speed up groups iterate
Date: Wed, 24 Aug 2022 16:18:28 +0800
Message-ID: <20220824081829.33748-10-zhouchengming@bytedance.com>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=kvXw0ka1ZDD0lFwIGZxik+dCkFG4/lruKQeSxN5T30s=;
        b=nkGT4TyusGK+mWMOOY7Xm3rXsH00GUhDlwqaTv7vf3U9tOqYCUzuAqPS43Ktm7YyNh
         id2VfvdP2ZUXqnnyt7ongxGCdKo3Ar4OlPb/Y18JYXSe+794stCN5JFluaz2xFFNt1zB
         l2utc1YLnYAT6BVvoYvfm3upjnONzJOrtTwN9bGZXk2ENHrtXhlE9xB0Sn81McrAmZEc
         4V3JruzuwcJb6VqFS28Zc3S3kBwk5S1yGcEU06DwsfVyRQ6Spc8JSuVTPFzoBOpwZaOV
         LRSG09bUlYZjKp7rYgmHRCq7/BIzZIn27vPeMdod8FhjgFD3jd0znTejuWRrnIKYDmSo
         1Hxg==
In-Reply-To: <20220824081829.33748-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, surenb@google.com
Cc: gregkh@linuxfoundation.org, corbet@lwn.net, mingo@redhat.com, peterz@infradead.org, songmuchun@bytedance.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

We use iterate_groups() to iterate each level psi_group to update
PSI stats, which is a very hot path.

In current code, iterate_groups() have to use multiple branches and
cgroup_parent() to get parent psi_group for each level, which is not
very efficient.

This patch cache parent psi_group in struct psi_group, only need to get
psi_group of task itself first, then just use group->parent to iterate.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 include/linux/psi_types.h |  2 ++
 kernel/sched/psi.c        | 47 ++++++++++++++++-----------------------
 2 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 40c28171cd91..a0b746258c68 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -151,6 +151,8 @@ struct psi_trigger {
 };
 
 struct psi_group {
+	struct psi_group *parent;
+
 	/* Protects data used by the aggregator */
 	struct mutex avgs_lock;
 
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 7aab6f13ed12..814e99b1fed3 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -772,30 +772,18 @@ static void psi_group_change(struct psi_group *group, int cpu,
 		schedule_delayed_work(&group->avgs_work, PSI_FREQ);
 }
 
-static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
+static inline struct psi_group *task_psi_group(struct task_struct *task)
 {
-	if (*iter == &psi_system)
-		return NULL;
-
 #ifdef CONFIG_CGROUPS
-	if (static_branch_likely(&psi_cgroups_enabled)) {
-		struct cgroup *cgroup = NULL;
-
-		if (!*iter)
-			cgroup = task->cgroups->dfl_cgrp;
-		else
-			cgroup = cgroup_parent(*iter);
-
-		if (cgroup && cgroup_parent(cgroup)) {
-			*iter = cgroup;
-			return cgroup_psi(cgroup);
-		}
-	}
+	if (static_branch_likely(&psi_cgroups_enabled))
+		return cgroup_psi(task_dfl_cgroup(task));
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
@@ -815,7 +803,6 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 {
 	int cpu = task_cpu(task);
 	struct psi_group *group;
-	void *iter = NULL;
 	u64 now;
 
 	if (!task->pid)
@@ -825,7 +812,8 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 
 	now = cpu_clock(cpu);
 
-	while ((group = iterate_groups(task, &iter)))
+	group = task_psi_group(task);
+	for_each_psi_group(group)
 		psi_group_change(group, cpu, clear, set, now, true);
 }
 
@@ -834,7 +822,6 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 {
 	struct psi_group *group, *common = NULL;
 	int cpu = task_cpu(prev);
-	void *iter;
 	u64 now = cpu_clock(cpu);
 
 	if (next->pid) {
@@ -845,8 +832,8 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		 * we reach the first common ancestor. Iterate @next's
 		 * ancestors only until we encounter @prev's ONCPU.
 		 */
-		iter = NULL;
-		while ((group = iterate_groups(next, &iter))) {
+		group = task_psi_group(next);
+		for_each_psi_group(group) {
 			if (per_cpu_ptr(group->pcpu, cpu)->state_mask &
 			    PSI_ONCPU) {
 				common = group;
@@ -887,9 +874,12 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 
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
@@ -897,7 +887,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		 */
 		if (sleep || unlikely(prev->in_memstall != next->in_memstall)) {
 			clear &= ~TSK_ONCPU;
-			for (; group; group = iterate_groups(prev, &iter))
+			for_each_psi_group(group)
 				psi_group_change(group, cpu, clear, set, now, wake_clock);
 		}
 	}
@@ -907,7 +897,6 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 void psi_account_irqtime(struct task_struct *task, u32 delta)
 {
 	int cpu = task_cpu(task);
-	void *iter = NULL;
 	struct psi_group *group;
 	struct psi_group_cpu *groupc;
 	u64 now;
@@ -917,7 +906,8 @@ void psi_account_irqtime(struct task_struct *task, u32 delta)
 
 	now = cpu_clock(cpu);
 
-	while ((group = iterate_groups(task, &iter))) {
+	group = task_psi_group(task);
+	for_each_psi_group(group) {
 		groupc = per_cpu_ptr(group->pcpu, cpu);
 
 		write_seqcount_begin(&groupc->seq);
@@ -1009,6 +999,7 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 		return -ENOMEM;
 	}
 	group_init(cgroup->psi);
+	cgroup->psi->parent = cgroup_psi(cgroup_parent(cgroup));
 	return 0;
 }
 
-- 
2.37.2

