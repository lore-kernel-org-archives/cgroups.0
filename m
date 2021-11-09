From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] sched/fair: Prevent dead task groups from regaining
 cfs_rq's
Date: Tue, 9 Nov 2021 19:47:44 +0100
Message-ID: <20211109184744.GA31882@blackbody.suse.cz>
References: <CAKfTPtBm4vHr=svju=Qg6eZmcv8YDghtM2r_pOahZ2gC3tzTxg@mail.gmail.com>
 <a6a3c6c9-d5ea-59b6-8871-0f72bff38833@grsecurity.net>
 <CAKfTPtBxoKBRWs4Z3Pxsk8==Ka9SG7NS3LzfOV33-2UXfhSM=g@mail.gmail.com>
 <cd3778d3-6980-a804-47e3-82b09dc960a4@grsecurity.net>
 <CAKfTPtDthksitm02sLowDMKbWZ29efth-YcPi0zVSFqbaZfiMA@mail.gmail.com>
 <8f4ed996-e6e5-75f4-b5fa-dffb7b7da05b@grsecurity.net>
 <20211105162914.215420-1-minipli@grsecurity.net>
 <20211106104854.GU174703@worktop.programming.kicks-ass.net>
 <9e8b2c49-2a10-2b34-e644-2b99708080bc@grsecurity.net>
 <YYkMoxLPgMt4uV/g@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636483666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tl20pYAY9isTiU5ioe6IbRR2SERdyiWxrZWCK2XNM5Q=;
        b=eIyPIbdHtYfPRDMSWXGRcNKFDQ9FTUyaN/6DhhBxe+wncacdegTRk++rjT+PgCPiGDawbv
        ffxKE/FVGfiiULupJO6aeksqEVpVD8G0zhsdgx+EBjGwFX2JD/SGz6NtwlQiQybRBdHjhO
        jSFcOVFpG0jljkxrLYdAb1Ow4Frq3bg=
Content-Disposition: inline
In-Reply-To: <YYkMoxLPgMt4uV/g@hirez.programming.kicks-ass.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mathias Krause <minipli-JNS0hek0TMl4qEwOxq4T+Q@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <Valentin.Schneider-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Kevin Tanguy <kevin.tanguy-Rm6v+N6rxxBWk0Htik3J/w@public.gmane.org>, Brad Spengler <spender-JNS0hek0TMl4qEwOxq4T+Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

Let me add a little summary (and I'm CCing cgroups ML too).

The cgroup API allows following callbacks (simplified explanation):

- .css_offline           called after killing main reference 
- .css_released          called when css.refcnt hits zero 
- .css_free              called after css_released and RCU GP 

(The hidden catch is that they're not called directly but through workqueues,
see css_free_work_fn() for details. .css_free() is queued after RCU GP though.)

How is this currently used in the cpu controller:

- .css_offline           not used
- .css_released          sched_offline_group / unregister_fair_sched_group
- .css_free              sched_free_group / free_fair_sched_group


On Mon, Nov 08, 2021 at 12:40:19PM +0100, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> Something like so good?

Thanks for putting this together, in short I understand it reshuffles as follows:

.css_offline    not used
.css_released   cpu_cgroup_css_released
                  sched_released_group(tg)
                    // unlinking from tg tree
.css_free       cpu_cgroup_css_free
                  sched_unregister_group(tg)
                    unregister_fair_sched_group(tg)
                      for_each(cpu)
                        remove_entity_load_avg(cfs_rq)
                        list_del_leaf_cfs_rq(cfs_rq)    (1)
                      destroy_cfs_bandwidth(tg)         (2)
                    call_rcu(sched_free_group_rcu)      (3)
                      [rcu] sched_free_group

I see two following issues with this:

The cfs_bandwidth.period_timer is still active between (1) and (2) and can be
fired and tg_unthrottle_up() may add a cfs_rq back to the leaf list (subsequent
GP won't help).
(Admittedly, this window is shorter than the original window between
cpu_cgroup_css_released() and cpu_cgroup_css_released().)

Having another call_rcu() at (3) seems overly complex given the cgroup API
provides a grace period for free (pun intended :-).


Therefore, symbolically, the symbolic ordering should be:

.css_offline    not used
.css_released   cpu_cgroup_css_released
                  sched_unregister_group(tg)
                    unregister_fair_sched_group(tg)
                      destroy_cfs_bandwidth(tg)
                      for_each(cpu)
                        remove_entity_load_avg(cfs_rq)
                        list_del_leaf_cfs_rq(cfs_rq)
                  sched_released_group(tg)
                    // unlinking from tg tree

.css_free       cpu_cgroup_css_free
                  sched_free_group

That is, the destroy_cfs_bandwidth() is called first to make sure the
tg_unthrottle_up() won't undo some of the cleanups and the respective
structures are only freed after RCU grace period.

(Considering Vincent's remark, remove_entity_load_avg() and
list_del_leaf_cfs_rq() should be swapped but I'd keep that for a different
patch.)

To continue the discussion, the suggestion above in a form of diff (I stripped
the commit message for now).

--8<--
diff --git a/kernel/sched/autogroup.c b/kernel/sched/autogroup.c
index 2067080bb235..8629b37d118e 100644
--- a/kernel/sched/autogroup.c
+++ b/kernel/sched/autogroup.c
@@ -31,7 +31,7 @@ static inline void autogroup_destroy(struct kref *kref)
 	ag->tg->rt_se = NULL;
 	ag->tg->rt_rq = NULL;
 #endif
-	sched_offline_group(ag->tg);
+	sched_release_group(ag->tg);
 	sched_destroy_group(ag->tg);
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 523fd602ea90..a5ca3ae6837b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9771,12 +9771,12 @@ void sched_destroy_group(struct task_group *tg)
 	call_rcu(&tg->rcu, sched_free_group_rcu);
 }
 
-void sched_offline_group(struct task_group *tg)
+void sched_release_group(struct task_group *tg)
 {
 	unsigned long flags;
 
-	/* End participation in shares distribution: */
 	unregister_fair_sched_group(tg);
+	unregister_rt_sched_group(tg);
 
 	spin_lock_irqsave(&task_group_lock, flags);
 	list_del_rcu(&tg->list);
@@ -9896,7 +9896,7 @@ static void cpu_cgroup_css_released(struct cgroup_subsys_state *css)
 {
 	struct task_group *tg = css_tg(css);
 
-	sched_offline_group(tg);
+	sched_release_group(tg);
 }
 
 static void cpu_cgroup_css_free(struct cgroup_subsys_state *css)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 13950beb01a2..6e476f6d9435 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11456,8 +11456,6 @@ void free_fair_sched_group(struct task_group *tg)
 {
 	int i;
 
-	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
-
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
@@ -11534,6 +11532,8 @@ void unregister_fair_sched_group(struct task_group *tg)
 	struct rq *rq;
 	int cpu;
 
+	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
 	for_each_possible_cpu(cpu) {
 		if (tg->se[cpu])
 			remove_entity_load_avg(tg->se[cpu]);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index bb945f8faeca..b48baaba2fc2 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -137,13 +137,17 @@ static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
 	return rt_rq->rq;
 }
 
-void free_rt_sched_group(struct task_group *tg)
+void unregister_rt_sched_group(struct task_group *tg)
 {
-	int i;
-
 	if (tg->rt_se)
 		destroy_rt_bandwidth(&tg->rt_bandwidth);
 
+}
+
+void free_rt_sched_group(struct task_group *tg)
+{
+	int i;
+
 	for_each_possible_cpu(i) {
 		if (tg->rt_rq)
 			kfree(tg->rt_rq[i]);
@@ -250,6 +254,8 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 	return &rq->rt;
 }
 
+void unregister_rt_sched_group(struct task_group *tg) { }
+
 void free_rt_sched_group(struct task_group *tg) { }
 
 int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7f1612d26c18..0e66749486e7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -488,6 +488,7 @@ extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
 extern void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 
+extern void unregister_rt_sched_group(struct task_group *tg);
 extern void free_rt_sched_group(struct task_group *tg);
 extern int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent);
 extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
@@ -503,7 +504,7 @@ extern struct task_group *sched_create_group(struct task_group *parent);
 extern void sched_online_group(struct task_group *tg,
 			       struct task_group *parent);
 extern void sched_destroy_group(struct task_group *tg);
-extern void sched_offline_group(struct task_group *tg);
+extern void sched_release_group(struct task_group *tg);
 
 extern void sched_move_task(struct task_struct *tsk);
 

