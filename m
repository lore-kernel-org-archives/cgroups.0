From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch 2/5] mm, oom: introduce helper function to process threads
 during scan
Date: Fri, 29 Jun 2012 14:06:53 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206291405360.6040@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=cAXJG0AcIoeTxidZj8I3oGhPrOA2bZgQJSlD8lchcD4=;
        b=pS5uoEfFn8wxG6/DPCOXvUx7UFpeLEicejH/jopCuIbTgWp0FmoM3AwBaAO+jAnbVZ
         9gJvCmn4CS8F2z92C+IU+58X2mDKTV6eeU1odYslM00+rA6DUUekYEZ/wBTAoWdzarRd
         Lqcz9fa1PcnID6NQA8NbMk1LRTXC1MTywWXm0cM+lu8HZ0ZOEhjxWEAGl6cw/uBOcBR5
         +ETWSivrsh/WsYv+AU3OL/j/h2I2UU/OTjKTuu941L5dP5ixeT7sdRS9X7f70Hv3iMTY
         Qodm7bjRgl7zfsCzV4b9v1OVe6HNKEv640txJbmEw9O7Ucb3/ySzYP1X8BY13sjtlvjP
         60ew==
In-Reply-To: <alpine.DEB.2.00.1206291404530.6040-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch introduces a helper function to process each thread during the
iteration over the tasklist.  A new return type, enum oom_scan_t, is
defined to determine the future behavior of the iteration:

 - OOM_SCAN_OK: continue scanning the thread and find its badness,

 - OOM_SCAN_CONTINUE: do not consider this thread for oom kill, it's
   ineligible,

 - OOM_SCAN_ABORT: abort the iteration and return, or

 - OOM_SCAN_SELECT: always select this thread with the highest badness
   possible.

There is no functional change with this patch.  This new helper function
will be used in the next patch in the memory controller.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/oom_kill.c |  111 +++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 65 insertions(+), 46 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -288,6 +288,59 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
 }
 #endif
 
+enum oom_scan_t {
+	OOM_SCAN_OK,		/* scan thread and find its badness */
+	OOM_SCAN_CONTINUE,	/* do not consider thread for oom kill */
+	OOM_SCAN_ABORT,		/* abort the iteration and return */
+	OOM_SCAN_SELECT,	/* always select this thread first */
+};
+
+static enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
+		struct mem_cgroup *memcg, unsigned long totalpages,
+		const nodemask_t *nodemask, bool force_kill)
+{
+	if (task->exit_state)
+		return OOM_SCAN_CONTINUE;
+	if (oom_unkillable_task(task, memcg, nodemask))
+		return OOM_SCAN_CONTINUE;
+
+	/*
+	 * This task already has access to memory reserves and is being killed.
+	 * Don't allow any other task to have access to the reserves.
+	 */
+	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
+		if (unlikely(frozen(task)))
+			__thaw_task(task);
+		if (!force_kill)
+			return OOM_SCAN_ABORT;
+	}
+	if (!task->mm)
+		return OOM_SCAN_CONTINUE;
+
+	if (task->flags & PF_EXITING) {
+		/*
+		 * If task is current and is in the process of releasing memory,
+		 * allow the "kill" to set TIF_MEMDIE, which will allow it to
+		 * access memory reserves.  Otherwise, it may stall forever.
+		 *
+		 * The iteration isn't broken here, however, in case other
+		 * threads are found to have already been oom killed.
+		 */
+		if (task == current)
+			return OOM_SCAN_SELECT;
+		else if (!force_kill) {
+			/*
+			 * If this task is not being ptraced on exit, then wait
+			 * for it to finish before killing some other task
+			 * unnecessarily.
+			 */
+			if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
+				return OOM_SCAN_ABORT;
+		}
+	}
+	return OOM_SCAN_OK;
+}
+
 /*
  * Simple selection loop. We chose the process with the highest
  * number of 'points'. We expect the caller will lock the tasklist.
@@ -305,53 +358,19 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 	do_each_thread(g, p) {
 		unsigned int points;
 
-		if (p->exit_state)
-			continue;
-		if (oom_unkillable_task(p, memcg, nodemask))
-			continue;
-
-		/*
-		 * This task already has access to memory reserves and is
-		 * being killed. Don't allow any other task access to the
-		 * memory reserve.
-		 *
-		 * Note: this may have a chance of deadlock if it gets
-		 * blocked waiting for another task which itself is waiting
-		 * for memory. Is there a better alternative?
-		 */
-		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
-			if (unlikely(frozen(p)))
-				__thaw_task(p);
-			if (!force_kill)
-				return ERR_PTR(-1UL);
-		}
-		if (!p->mm)
+		switch (oom_scan_process_thread(p, memcg, totalpages, nodemask,
+						force_kill)) {
+		case OOM_SCAN_SELECT:
+			chosen = p;
+			chosen_points = ULONG_MAX;
+			/* fall through */
+		case OOM_SCAN_CONTINUE:
 			continue;
-
-		if (p->flags & PF_EXITING) {
-			/*
-			 * If p is the current task and is in the process of
-			 * releasing memory, we allow the "kill" to set
-			 * TIF_MEMDIE, which will allow it to gain access to
-			 * memory reserves.  Otherwise, it may stall forever.
-			 *
-			 * The loop isn't broken here, however, in case other
-			 * threads are found to have already been oom killed.
-			 */
-			if (p == current) {
-				chosen = p;
-				chosen_points = ULONG_MAX;
-			} else if (!force_kill) {
-				/*
-				 * If this task is not being ptraced on exit,
-				 * then wait for it to finish before killing
-				 * some other task unnecessarily.
-				 */
-				if (!(p->group_leader->ptrace & PT_TRACE_EXIT))
-					return ERR_PTR(-1UL);
-			}
-		}
-
+		case OOM_SCAN_ABORT:
+			return ERR_PTR(-1UL);
+		case OOM_SCAN_OK:
+			break;
+		};
 		points = oom_badness(p, memcg, nodemask, totalpages);
 		if (points > chosen_points) {
 			chosen = p;
