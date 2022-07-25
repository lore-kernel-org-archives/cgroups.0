From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 9/9] sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
Date: Mon, 25 Jul 2022 14:26:02 -0400
Message-ID: <Yt7gOhbqYzIKyhfv@cmpxchg.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-10-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SJ5ATteDCNi/4BY4PNgsMgCW15cD92wrz0tkARQ7vKY=;
        b=5Il4a5zJ8mZ7Jsn+zAu4/T22MYYX/u7qfLg1Hhhzz0CR+QXMWP33kGSYR882OgzOpj
         OVKFcnRluW7I3M2Boby0n7KYmrHRJY9hbe2IthGoVb8QE8dqPRn0yL2jlgwpnww/JzAi
         9ZCF4+UJ4cKy5QQNJTPy8INVEWIGwPK9fti7YVVatWk2z38K0SHkYiN6o8odYEpivsuC
         46zLsxTLQaeMxELrYNDQviXs4I482h4Abw+SPw4NfqjinXzzGFF49XmksFoLrWWwfJqz
         GPIouRxslZ70CAnHJKQRcyU5sQztNc/x4Uc3Ji0+iaFoOXtPdUwJO6PVQ43mUJ1f+Qgu
         Dc4g==
Content-Disposition: inline
In-Reply-To: <20220721040439.2651-10-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On Thu, Jul 21, 2022 at 12:04:39PM +0800, Chengming Zhou wrote:
> Now PSI already tracked workload pressure stall information for
> CPU, memory and IO. Apart from these, IRQ/SOFTIRQ could have
> obvious impact on some workload productivity, such as web service
> workload.
> 
> When CONFIG_IRQ_TIME_ACCOUNTING, we can get IRQ/SOFTIRQ delta time
> from update_rq_clock_task(), in which we can record that delta
> to CPU curr task's cgroups as PSI_IRQ_FULL status.
>
> Note we don't use PSI_IRQ_SOME since IRQ/SOFTIRQ always happen in
> the current task on the CPU, make nothing productive could run
> even if it were runnable, so we only use PSI_IRQ_FULL.

That sounds reasonable.

> For performance impact consideration, this is enabled by default when
> CONFIG_IRQ_TIME_ACCOUNTING, but can be disabled by kernel cmdline
> parameter "psi_irq=".

If there isn't a concrete usecase already, let's not add another
commandline parameter for now.

> @@ -63,9 +64,11 @@ enum psi_states {
>  	PSI_MEM_FULL,
>  	PSI_CPU_SOME,
>  	PSI_CPU_FULL,
> +	PSI_IRQ_SOME,
> +	PSI_IRQ_FULL,
>  	/* Only per-CPU, to weigh the CPU in the global average: */
>  	PSI_NONIDLE,
> -	NR_PSI_STATES = 7,
> +	NR_PSI_STATES = 9,
>  };

Unfortunately, this grows the psi state touched by the scheduler into
a second cacheline. :( Please reclaim space first.

I think we can remove the NR_CPU task count, which frees up one
u32. Something like the below diff should work (untested!)

And you should be able to remove PSI_IRQ_SOME, since it's not used
anyway. Then we'd be good to go.

diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index c7fe7c089718..31dc76e2d8ea 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -15,13 +15,6 @@ enum psi_task_count {
 	NR_IOWAIT,
 	NR_MEMSTALL,
 	NR_RUNNING,
-	/*
-	 * This can't have values other than 0 or 1 and could be
-	 * implemented as a bit flag. But for now we still have room
-	 * in the first cacheline of psi_group_cpu, and this way we
-	 * don't have to special case any state tracking for it.
-	 */
-	NR_ONCPU,
 	/*
 	 * For IO and CPU stalls the presence of running/oncpu tasks
 	 * in the domain means a partial rather than a full stall.
@@ -39,9 +32,11 @@ enum psi_task_count {
 #define TSK_IOWAIT	(1 << NR_IOWAIT)
 #define TSK_MEMSTALL	(1 << NR_MEMSTALL)
 #define TSK_RUNNING	(1 << NR_RUNNING)
-#define TSK_ONCPU	(1 << NR_ONCPU)
 #define TSK_MEMSTALL_RUNNING	(1 << NR_MEMSTALL_RUNNING)
 
+/* Only one task can be scheduled, no corresponding task count */
+#define TSK_ONCPU	(1 << NR_PSI_TASK_COUNTS)
+
 /* Resources that workloads could be stalled on */
 enum psi_res {
 	PSI_IO,
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index a4fa3aadfcba..232e1dbfad46 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -215,7 +215,7 @@ void __init psi_init(void)
 	group_init(&psi_system);
 }
 
-static bool test_state(unsigned int *tasks, enum psi_states state)
+static bool test_state(unsigned int *tasks, enum psi_states state, bool oncpu)
 {
 	switch (state) {
 	case PSI_IO_SOME:
@@ -228,9 +228,9 @@ static bool test_state(unsigned int *tasks, enum psi_states state)
 		return unlikely(tasks[NR_MEMSTALL] &&
 			tasks[NR_RUNNING] == tasks[NR_MEMSTALL_RUNNING]);
 	case PSI_CPU_SOME:
-		return unlikely(tasks[NR_RUNNING] > tasks[NR_ONCPU]);
+		return unlikely(tasks[NR_RUNNING] > oncpu);
 	case PSI_CPU_FULL:
-		return unlikely(tasks[NR_RUNNING] && !tasks[NR_ONCPU]);
+		return unlikely(tasks[NR_RUNNING] && !oncpu);
 	case PSI_NONIDLE:
 		return tasks[NR_IOWAIT] || tasks[NR_MEMSTALL] ||
 			tasks[NR_RUNNING];
@@ -692,9 +692,9 @@ static void psi_group_change(struct psi_group *group, int cpu,
 			     bool wake_clock)
 {
 	struct psi_group_cpu *groupc;
-	u32 state_mask = 0;
 	unsigned int t, m;
 	enum psi_states s;
+	u32 state_mask;
 
 	groupc = per_cpu_ptr(group->pcpu, cpu);
 
@@ -710,6 +710,26 @@ static void psi_group_change(struct psi_group *group, int cpu,
 
 	record_times(groupc, now);
 
+	/*
+	 * Start with TSK_ONCPU, which doesn't have a corresponding
+	 * task count - it's just a boolean flag directly encoded in
+	 * the state mask. Clear, set, or carry the current state if
+	 * no changes are requested.
+	 */
+	if (clear & TSK_ONCPU) {
+		state_mask = 0;
+		clear &= ~TSK_ONCPU;
+	} else if (set & TSK_ONCPU) {
+		state_mask = TSK_ONCPU;
+		set &= ~TSK_ONCPU;
+	} else {
+		state_mask = groupc->state_mask & TSK_ONCPU;
+	}
+
+	/*
+	 * The rest of the state mask is calculated based on the task
+	 * counts. Update those first, then construct the mask.
+	 */
 	for (t = 0, m = clear; m; m &= ~(1 << t), t++) {
 		if (!(m & (1 << t)))
 			continue;
@@ -729,9 +749,8 @@ static void psi_group_change(struct psi_group *group, int cpu,
 		if (set & (1 << t))
 			groupc->tasks[t]++;
 
-	/* Calculate state mask representing active states */
 	for (s = 0; s < NR_PSI_STATES; s++) {
-		if (test_state(groupc->tasks, s))
+		if (test_state(groupc->tasks, s, state_mask & TSK_ONCPU))
 			state_mask |= (1 << s);
 	}
 
@@ -743,7 +762,7 @@ static void psi_group_change(struct psi_group *group, int cpu,
 	 * task in a cgroup is in_memstall, the corresponding groupc
 	 * on that cpu is in PSI_MEM_FULL state.
 	 */
-	if (unlikely(groupc->tasks[NR_ONCPU] && cpu_curr(cpu)->in_memstall))
+	if (unlikely((state_mask & TSK_ONCPU) && cpu_curr(cpu)->in_memstall))
 		state_mask |= (1 << PSI_MEM_FULL);
 
 	groupc->state_mask = state_mask;
@@ -847,7 +866,8 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		iter = NULL;
 		while ((group = iterate_groups(next, &iter))) {
 			if (identical_state &&
-			    per_cpu_ptr(group->pcpu, cpu)->tasks[NR_ONCPU]) {
+			    (per_cpu_ptr(group->pcpu, cpu)->state_mask &
+			     TSK_ONCPU)) {
 				common = group;
 				break;
 			}
