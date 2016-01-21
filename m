From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: make sure a parent css isn't offlined before
 its children
Date: Thu, 21 Jan 2016 22:24:16 +0100
Message-ID: <20160121212416.GL6357@twins.programming.kicks-ass.net>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org>
 <5698A023.9070703@de.ibm.com>
 <20160121203111.GF5157@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160121203111.GF5157-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Jan 21, 2016 at 03:31:11PM -0500, Tejun Heo wrote:
> There are three subsystem callbacks in css shutdown path -
> css_offline(), css_released() and css_free().  Except for
> css_released(), cgroup core didn't use to guarantee the order of
> invocation.  css_offline() or css_free() could be called on a parent
> css before its children.  This behavior is unexpected and led to
> use-after-free in cpu controller.
> 
> This patch updates offline path so that a parent css is never offlined
> before its children.  Each css keeps online_cnt which reaches zero iff
> itself and all its children are offline and offline_css() is invoked
> only after online_cnt reaches zero.
> 
> This fixes the reported cpu controller malfunction.  The next patch
> will update css_free() handling.

No, I need to fix the cpu controller too, because the offending code
sits off of css_free() (the next patch), but also does a call_rcu() in
between, which also doesn't guarantee order.

So your patch and the below would be required to fix this I think.

And then I should look at removing the call_rcu() from the css_free() at
a later date, I think its superfluous but need to double check that.


---
Subject: sched: Fix cgroup entity load tracking tear-down

When a cgroup's cpu runqueue is destroyed, it should remove its
remaining load accounting from its parent cgroup.

The current site for doing so it unsuited because its far too late and
unordered against other cgroup removal (css_free will be, but we're also
in an RCU callback).

Put it in the css_offline callback, which is the start of cgroup
destruction, right after the group has been made unavailable to
userspace. The css_offline callbacks are called in hierarchical order.

Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 kernel/sched/core.c  |  4 +---
 kernel/sched/fair.c  | 35 ++++++++++++++++++++---------------
 kernel/sched/sched.h |  2 +-
 3 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b8bd352dc63f..d589a140fe0e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7865,11 +7865,9 @@ void sched_destroy_group(struct task_group *tg)
 void sched_offline_group(struct task_group *tg)
 {
 	unsigned long flags;
-	int i;
 
 	/* end participation in shares distribution */
-	for_each_possible_cpu(i)
-		unregister_fair_sched_group(tg, i);
+	unregister_fair_sched_group(tg);
 
 	spin_lock_irqsave(&task_group_lock, flags);
 	list_del_rcu(&tg->list);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7f60da0f0fd7..aff660b70bf5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8244,11 +8244,8 @@ void free_fair_sched_group(struct task_group *tg)
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
-		if (tg->se) {
-			if (tg->se[i])
-				remove_entity_load_avg(tg->se[i]);
+		if (tg->se)
 			kfree(tg->se[i]);
-		}
 	}
 
 	kfree(tg->cfs_rq);
@@ -8296,21 +8293,29 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	return 0;
 }
 
-void unregister_fair_sched_group(struct task_group *tg, int cpu)
+void unregister_fair_sched_group(struct task_group *tg)
 {
-	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
+	struct rq *rq;
+	int cpu;
 
-	/*
-	* Only empty task groups can be destroyed; so we can speculatively
-	* check on_list without danger of it being re-added.
-	*/
-	if (!tg->cfs_rq[cpu]->on_list)
-		return;
+	for_each_possible_cpu(cpu) {
+		if (tg->se[cpu])
+			remove_entity_load_avg(tg->se[cpu]);
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+		/*
+		 * Only empty task groups can be destroyed; so we can speculatively
+		 * check on_list without danger of it being re-added.
+		 */
+		if (!tg->cfs_rq[cpu]->on_list)
+			continue;
+
+		rq = cpu_rq(cpu);
+
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
+	}
 }
 
 void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 837bcd383cda..492478bb717c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -313,7 +313,7 @@ extern int tg_nop(struct task_group *tg, void *data);
 
 extern void free_fair_sched_group(struct task_group *tg);
 extern int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent);
-extern void unregister_fair_sched_group(struct task_group *tg, int cpu);
+extern void unregister_fair_sched_group(struct task_group *tg);
 extern void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 			struct sched_entity *se, int cpu,
 			struct sched_entity *parent);
