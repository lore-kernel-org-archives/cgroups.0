From: Waiman Long <longman@redhat.com>
Subject: [PATCH 2/5] cgroup/cpuset: Include offline CPUs when tasks' cpumasks in top_cpuset are updated
Date: Mon,  6 Mar 2023 15:08:46 -0500
Message-ID: <20230306200849.376804-3-longman@redhat.com>
References: <20230306200849.376804-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678133370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMpGzFxDVrhKLpAq2mb4oo3DA00+S6OlDRBjGlenDeM=;
        b=P0Py6VEag06c8j/FtieA8fOuQ4IryLTGa0zjr61JFxCE0ZhHHSIozCYmlz1kHuO5zup+mx
        uw0bmEsw2UDeDrTVEuJi6aauzWcyCrGl8QcSHYd9SviDVK6eAeESY6s6BJysUNjkVA1kJy
        jSgNpFTFsblDnIPxE+WVyrgd/osIyzY=
In-Reply-To: <20230306200849.376804-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Waiman Long <longman@redhat.com>

Similar to commit 3fb906e7fabb ("group/cpuset: Don't filter offline
CPUs in cpuset_cpus_allowed() for top cpuset tasks"), the whole set of
possible CPUs including offline ones should be used for setting cpumasks
for tasks in the top cpuset when a cpuset partition is modified.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a801abad3bac..bbf57dcb2f68 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1209,7 +1209,8 @@ void rebuild_sched_domains(void)
  *
  * Iterate through each task of @cs updating its cpus_allowed to the
  * effective cpuset's.  As this function is called with cpuset_rwsem held,
- * cpuset membership stays stable.
+ * cpuset membership stays stable. For top_cpuset, task_cpu_possible_mask()
+ * is used instead of effective_cpus.
  */
 static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 {
@@ -1219,15 +1220,18 @@ static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 
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
+			cpumask_and(new_cpus, cs->effective_cpus, possible_mask);
+		}
 		set_cpus_allowed_ptr(task, new_cpus);
 	}
 	css_task_iter_end(&it);
-- 
2.31.1

