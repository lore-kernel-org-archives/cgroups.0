From: riel@redhat.com
Subject: [PATCH 1/4] sched,isolcpu: make cpu_isolated_map visible outside scheduler
Date: Mon,  9 Mar 2015 12:12:07 -0400
Message-ID: <1425917530-1771-2-git-send-email-riel@redhat.com>
References: <1425917530-1771-1-git-send-email-riel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425917530-1771-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, David Rientjes <rientjes@google.com>, Mike Galbraith <umgwanakikbuti@gmail.com>

From: Rik van Riel <riel@redhat.com>

Needed by the next patch. Also makes cpu_isolated_map present
when compiled without SMP and/or with CONFIG_NR_CPUS=1, like
the other cpu masks.

At some point we may want to clean things up so cpumasks do
not exist in UP kernels. Maybe something for the CONFIG_TINY
crowd.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: cgroups@vger.kernel.org
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/sched.h | 2 ++
 kernel/sched/core.c   | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6d77432e14ff..ca365d79480c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -329,6 +329,8 @@ extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
 extern void init_idle_bootup_task(struct task_struct *idle);
 
+extern cpumask_var_t cpu_isolated_map;
+
 extern int runqueue_is_locked(int cpu);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f0f831e8a345..b578bb23410b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -306,6 +306,9 @@ __read_mostly int scheduler_running;
  */
 int sysctl_sched_rt_runtime = 950000;
 
+/* cpus with isolated domains */
+cpumask_var_t cpu_isolated_map;
+
 /*
  * this_rq_lock - lock this runqueue and disable interrupts.
  */
@@ -5811,9 +5814,6 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	update_top_cache_domain(cpu);
 }
 
-/* cpus with isolated domains */
-static cpumask_var_t cpu_isolated_map;
-
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
-- 
2.1.0
