From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Mon, 6 Aug 2018 11:05:50 -0400
Message-ID: <20180806150550.GA9888@cmpxchg.org>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
 <20180803165641.GA2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7V1k6BlkbmNKBZ4B3DkV2Ovr5y1z+K5wWW7b4exCTs8=;
        b=MDL75QOWdH9GrcyzrTvuoawBcB/oxBsPhXwRgQ/A7+XGXDH3xL9KkAPucMXtovme5H
         z+MIPevgnD405M4vL3NKje22y+rd5V4+OgmMEV7qQKV3CD/wQy7sxfRDc7POalV8RrhM
         rZ7vpjotbdYs6xyaP4EZQ/OYSLFihd4Pr/nE0PxSLYlz57LyVxs2K+PVxtH08IbA43b9
         6HOlsoskGHcYOplGEa86ZfKDUkhDObwFEM3xQdZU+JuxsrGjIALTsqvUxP+1In89gGdS
         oknOvgJJ01jEqlOn5X81ZifZPacoyuQ3BNn3/qSKUOjvumMJm8L6PgwXSTOjOldQuDZM
         1Oog==
Content-Disposition: inline
In-Reply-To: <20180803165641.GA2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Aug 03, 2018 at 06:56:41PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 01, 2018 at 11:19:57AM -0400, Johannes Weiner wrote:
> > +static bool test_state(unsigned int *tasks, int cpu, enum psi_states state)
> > +{
> > +	switch (state) {
> > +	case PSI_IO_SOME:
> > +		return tasks[NR_IOWAIT];
> > +	case PSI_IO_FULL:
> > +		return tasks[NR_IOWAIT] && !tasks[NR_RUNNING];
> > +	case PSI_MEM_SOME:
> > +		return tasks[NR_MEMSTALL];
> > +	case PSI_MEM_FULL:
> > +		/*
> > +		 * Since we care about lost potential, things are
> > +		 * fully blocked on memory when there are no other
> > +		 * working tasks, but also when the CPU is actively
> > +		 * being used by a reclaimer and nothing productive
> > +		 * could run even if it were runnable.
> > +		 */
> > +		return tasks[NR_MEMSTALL] &&
> > +			(!tasks[NR_RUNNING] ||
> > +			 cpu_curr(cpu)->flags & PF_MEMSTALL);
> 
> I don't think you can do this, there is nothing that guarantees
> cpu_curr() still exists.

Argh, that's right. This needs an explicit count if we want to access
it locklessly. And you already said you didn't like that this is the
only state not derived purely from the task counters, so maybe this is
the way to go after all.

How about something like this (untested)?

diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index b6ff46362eb3..afc39fbbf9dd 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -10,6 +10,7 @@ enum psi_task_count {
 	NR_IOWAIT,
 	NR_MEMSTALL,
 	NR_RUNNING,
+	NR_RECLAIMING,
 	NR_PSI_TASK_COUNTS,
 };
 
@@ -17,6 +18,7 @@ enum psi_task_count {
 #define TSK_IOWAIT	(1 << NR_IOWAIT)
 #define TSK_MEMSTALL	(1 << NR_MEMSTALL)
 #define TSK_RUNNING	(1 << NR_RUNNING)
+#define TSK_RECLAIMING	(1 << NR_RECLAIMING)
 
 /* Resources that workloads could be stalled on */
 enum psi_res {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e53137df405b..90fd813dd7c2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3517,6 +3517,7 @@ static void __sched notrace __schedule(bool preempt)
 		 */
 		++*switch_count;
 
+		psi_switch(rq, prev, next);
 		trace_sched_switch(preempt, prev, next);
 
 		/* Also unlocks the rq: */
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index a20f885da66f..352c3a032ff0 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -209,8 +209,7 @@ static bool test_state(unsigned int *tasks, int cpu, enum psi_states state)
 		 * could run even if it were runnable.
 		 */
 		return tasks[NR_MEMSTALL] &&
-			(!tasks[NR_RUNNING] ||
-			 cpu_curr(cpu)->flags & PF_MEMSTALL);
+			(!tasks[NR_RUNNING] || tasks[NR_RECLAIMING]);
 	case PSI_CPU_SOME:
 		return tasks[NR_RUNNING] > 1;
 	case PSI_NONIDLE:
@@ -530,7 +529,7 @@ void psi_memstall_enter(unsigned long *flags)
 	update_rq_clock(rq);
 
 	current->flags |= PF_MEMSTALL;
-	psi_task_change(current, rq_clock(rq), 0, TSK_MEMSTALL);
+	psi_task_change(current, rq_clock(rq), 0, TSK_MEMSTALL|TSK_RECLAIMING);
 
 	rq_unlock_irq(rq, &rf);
 }
@@ -561,7 +560,7 @@ void psi_memstall_leave(unsigned long *flags)
 	update_rq_clock(rq);
 
 	current->flags &= ~PF_MEMSTALL;
-	psi_task_change(current, rq_clock(rq), TSK_MEMSTALL, 0);
+	psi_task_change(current, rq_clock(rq), TSK_MEMSTALL|TSK_RECLAIMING, 0);
 
 	rq_unlock_irq(rq, &rf);
 }
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index f3e0267eb47d..2babdd53715d 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -127,12 +127,26 @@ static inline void psi_ttwu_dequeue(struct task_struct *p)
 		__task_rq_unlock(rq, &rf);
 	}
 }
+
+static inline void psi_switch(struct rq *rq, struct task_struct *prev,
+			      struct task_struct *next)
+{
+	if (psi_disabled)
+		return;
+
+	if (unlikely(prev->flags & PF_MEMSTALL))
+		psi_task_change(prev, rq_clock(rq), TSK_RECLAIMING, 0);
+	if (unlikely(next->flags & PF_MEMSTALL))
+		psi_task_change(next, rq_clock(rq), 0, TSK_RECLAIMING);
+}
 #else /* CONFIG_PSI */
 static inline void psi_enqueue(struct rq *rq, struct task_struct *p,
 			       bool wakeup) {}
 static inline void psi_dequeue(struct rq *rq, struct task_struct *p,
 			       bool sleep) {}
 static inline void psi_ttwu_dequeue(struct task_struct *p) {}
+static inline void psi_switch(struct rq *rq, struct task_struct *prev,
+			      struct task_struct *next) {}
 #endif /* CONFIG_PSI */
 
 #ifdef CONFIG_SCHED_INFO
