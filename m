From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 3/4] cgroup/cpuset: Include offline CPUs when tasks' cpumasks in top_cpuset are updated
Date: Fri, 17 Mar 2023 11:15:07 -0400
Message-ID: <20230317151508.1225282-4-longman@redhat.com>
References: <20230317151508.1225282-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679066135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xGXOF5DEcP6pwvx1eYY/0gGWQNDYbTOSJx5veuAvjus=;
        b=c1RRVw1pITr3l1jTRSK/jsvuWpTOtgk78Ei7Ggt0lzo9rvbZ+bHGoU94KcG+l8hIjP1/9M
        VyHwL6idgAvk4rKkvq/ZZPmeEhOHe6VJYFPWc/rnvQG9tqJTfEv/0DtaRqW65MMWMEaB1n
        y7h+xx8UOmsY02tg8Fctl17S25apBM0=
In-Reply-To: <20230317151508.1225282-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

Similar to commit 3fb906e7fabb ("group/cpuset: Don't filter offline
CPUs in cpuset_cpus_allowed() for top cpuset tasks"), the whole set of
possible CPUs including offline ones should be used for setting cpumasks
for tasks in the top cpuset when a cpuset partition is modified as the
hotplug code won't update cpumasks for tasks in the top cpuset when
CPUs become online or offline.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5b8d763555b0..db8793a2082f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1209,7 +1209,9 @@ void rebuild_sched_domains(void)
  *
  * Iterate through each task of @cs updating its cpus_allowed to the
  * effective cpuset's.  As this function is called with cpuset_rwsem held,
- * cpuset membership stays stable.
+ * cpuset membership stays stable. For top_cpuset, task_cpu_possible_mask()
+ * is used instead of effective_cpus to make sure all offline CPUs are also
+ * included as hotplug code won't update cpumasks for tasks in top_cpuset.
  */
 static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 {
@@ -1219,15 +1221,18 @@ static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it))) {
-		/*
-		 * Percpu kthreads in top_cpuset are ignored
-		 */
-		if (top_cs && (task->flags & PF_KTHREAD) &&
-		    kthread_is_per_cpu(task))
-			continue;
+		const struct cpumask *possible_mask = task_cpu_possible_mask(task);
 
-		cpumask_and(new_cpus, cs->effective_cpus,
-			    task_cpu_possible_mask(task));
+		if (top_cs) {
+			/*
+			 * Percpu kthreads in top_cpuset are ignored
+			 */
+			if ((task->flags & PF_KTHREAD) && kthread_is_per_cpu(task))
+				continue;
+			cpumask_andnot(new_cpus, possible_mask, cs->subparts_cpus);
+		} else {
+			cpumask_and(new_cpus, possible_mask, cs->effective_cpus);
+		}
 		set_cpus_allowed_ptr(task, new_cpus);
 	}
 	css_task_iter_end(&it);
-- 
2.31.1

