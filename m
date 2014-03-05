From: David Rientjes <rientjes@google.com>
Subject: [patch 07/11] mm, memcg: allow processes handling oom notifications
 to access reserves
Date: Tue, 4 Mar 2014 19:59:29 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403041956040.8067@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=3NqhKvOMZros0gPrhiV43+c57M4+5r6rQe4vIH+lQaM=;
        b=kcovhZjN1X3239rjV0bAKcGeDs6Sz43AS03GX257CS53EHZr2H4egQLytXDh26Eg05
         FaPBKgpBYw47frDn5JmuyfFFDEHhSruCXZolX+4lC6/OKZ2AvsKQxFyxhMoHx0Ncff6w
         QbSyLKARGPOAmRlL1hP/kBhVPUYDCCtSX7LIOl0TclN4J1l+TDomgUODxxg+6kvqPL0P
         F4/PnjS3/RlnSEEqgCYGy1waxApFtVhHrtkVSzcdxu4iyNUjgb+VDsTbviypm4k36Vc8
         hBbAv2gjTIAkxAPaQJmLggh2R7D6EqLoxaLKvjXSv9dm5gAdRnPdrbFikFu4znXqIqWn
         ozAA==
In-Reply-To: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

Now that a per-process flag is available, define it for processes that
handle userspace oom notifications.  This is an optimization to avoid
mantaining a list of such processes attached to a memcg at any given time
and iterating it at charge time.

This flag gets set whenever a process has registered for an oom
notification and is cleared whenever it unregisters.

When memcg reclaim has failed to free any memory, it is necessary for
userspace oom handlers to be able to dip into reserves to pagefault text,
allocate kernel memory to read the "tasks" file, allocate heap, etc.

System oom conditions are not addressed at this time, but the same per-
process flag can be used in the page allocator to determine if access
should be given to userspace oom handlers to per-zone memory reserves at
a later time once there is consensus.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/sched.h |  1 +
 mm/memcontrol.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1821,6 +1821,7 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
+#define PF_OOM_HANDLER	0x10000000	/* Userspace process handling oom conditions */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK 0x80000000      /* this thread called freeze_processes and should not be frozen */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2633,6 +2633,33 @@ enum {
 	CHARGE_WOULDBLOCK,	/* GFP_WAIT wasn't set and no enough res. */
 };
 
+/*
+ * Processes handling oom conditions are allowed to utilize memory reserves so
+ * that they may handle the condition.
+ */
+static int mem_cgroup_oom_handler_charge(struct mem_cgroup *memcg,
+					 unsigned long csize,
+					 struct mem_cgroup **mem_over_limit)
+{
+	struct res_counter *fail_res;
+	int ret;
+
+	ret = res_counter_charge_nofail_max(&memcg->res, csize, &fail_res,
+					    memcg->oom_reserve);
+	if (!ret && do_swap_account) {
+		ret = res_counter_charge_nofail_max(&memcg->memsw, csize,
+						    &fail_res,
+						    memcg->oom_reserve);
+		if (ret) {
+			res_counter_uncharge(&memcg->res, csize);
+			*mem_over_limit = mem_cgroup_from_res_counter(fail_res,
+								      memsw);
+
+		}
+	}
+	return !ret ? CHARGE_OK : CHARGE_NOMEM;
+}
+
 static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				unsigned int nr_pages, unsigned int min_pages,
 				bool invoke_oom)
@@ -2692,6 +2719,13 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (mem_cgroup_wait_acct_move(mem_over_limit))
 		return CHARGE_RETRY;
 
+	if (current->flags & PF_OOM_HANDLER) {
+		ret = mem_cgroup_oom_handler_charge(memcg, csize,
+						    &mem_over_limit);
+		if (ret == CHARGE_OK)
+			return CHARGE_OK;
+	}
+
 	if (invoke_oom)
 		mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(csize));
 
@@ -2739,7 +2773,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 		     || fatal_signal_pending(current)))
 		goto bypass;
 
-	if (unlikely(task_in_memcg_oom(current)))
+	if (unlikely(task_in_memcg_oom(current)) &&
+	    !(current->flags & PF_OOM_HANDLER))
 		goto nomem;
 
 	if (gfp_mask & __GFP_NOFAIL)
@@ -5877,6 +5912,11 @@ static int mem_cgroup_oom_register_event(struct mem_cgroup *memcg,
 	if (!event)
 		return -ENOMEM;
 
+	/*
+	 * Setting PF_OOM_HANDLER before taking memcg_oom_lock ensures it is
+	 * set before getting added to memcg->oom_notify.
+	 */
+	current->flags |= PF_OOM_HANDLER;
 	spin_lock(&memcg_oom_lock);
 
 	event->eventfd = eventfd;
@@ -5904,6 +5944,11 @@ static void mem_cgroup_oom_unregister_event(struct mem_cgroup *memcg,
 		}
 	}
 
+	/*
+	 * Clearing PF_OOM_HANDLER before dropping memcg_oom_lock ensures it is
+	 * cleared before receiving another notification.
+	 */
+	current->flags &= ~PF_OOM_HANDLER;
 	spin_unlock(&memcg_oom_lock);
 }
 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
