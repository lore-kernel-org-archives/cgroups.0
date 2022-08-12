From: Waiman Long <longman@redhat.com>
Subject: [PATCH v3 3/3] cgroup/cpuset: Keep user set cpus affinity
Date: Fri, 12 Aug 2022 16:39:29 -0400
Message-ID: <20220812203929.364341-4-longman@redhat.com>
References: <20220812203929.364341-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660336804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8DDEyD7Oc6PgrEZHkHqv7mnoGrf2YiFnazEzhrXs74I=;
        b=T/rxbaAwCPpUjrgpU6BSgvLdEChAnKs/uqyPAEb3P4FYUjFAeNfz+1A52fivNLkGgKnKpA
        7eWn/BqlfGWXpSldBbMXhmck0XZIVcH9MfnAGSKR7ZXm3TCO2rhvGQyWOUb0/mhcDzx69e
        jqEJ3L6NmUg1XGdC1KfoqAeWuRwHrBw=
In-Reply-To: <20220812203929.364341-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Will Deacon <will@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Waiman Long <longman@redhat.com>

It was found that any change to the current cpuset hierarchy may reset
the cpumask of the tasks in the affected cpusets to the default cpuset
value even if those tasks have cpus affinity explicitly set by the users
before. That is especially easy to trigger under a cgroup v2 environment
where writing "+cpuset" to the root cgroup's cgroup.subtree_control
file will reset the cpus affinity of all the processes in the system.

That is problematic in a nohz_full environment where the tasks running
in the nohz_full CPUs usually have their cpus affinity explicitly set
and will behave incorrectly if cpus affinity changes.

Fix this problem by looking at user_cpus_ptr which will be set if
cpus affinity have been explicitly set before and use it to restrcit
the given cpumask unless there is no overlap. In that case, it will
fallback to the given one.

With that change in place, it was verified that tasks that have its
cpus affinity explicitly set will not be affected by changes made to
the v2 cgroup.subtree_control files.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58aadfda9b8b..cabfac540fd8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -704,6 +704,30 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	return ret;
 }
 
+/*
+ * Preserve user provided cpumask (if set) as much as possible unless there
+ * is no overlap with the given mask.
+ */
+static int cpuset_set_cpus_allowed_ptr(struct task_struct *p,
+				       const struct cpumask *mask)
+{
+	if (p->user_cpus_ptr) {
+		cpumask_var_t new_mask;
+
+		if (alloc_cpumask_var(&new_mask, GFP_KERNEL) &&
+		    copy_user_cpus_mask(p, new_mask) &&
+		    cpumask_and(new_mask, new_mask, mask)) {
+			int ret = set_cpus_allowed_ptr(p, new_mask);
+
+			free_cpumask_var(new_mask);
+			return ret;
+		}
+		free_cpumask_var(new_mask);
+	}
+
+	return set_cpus_allowed_ptr(p, mask);
+}
+
 #ifdef CONFIG_SMP
 /*
  * Helper routine for generate_sched_domains().
@@ -1130,7 +1154,7 @@ static void update_tasks_cpumask(struct cpuset *cs)
 
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
-		set_cpus_allowed_ptr(task, cs->effective_cpus);
+		cpuset_set_cpus_allowed_ptr(task, cs->effective_cpus);
 	css_task_iter_end(&it);
 }
 
@@ -2303,7 +2327,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		 * can_attach beforehand should guarantee that this doesn't
 		 * fail.  TODO: have a better way to handle failure here
 		 */
-		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+		WARN_ON_ONCE(cpuset_set_cpus_allowed_ptr(task, cpus_attach));
 
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
-- 
2.31.1

