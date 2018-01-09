From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 8 Jan 2018 16:31:27 -0800
Message-ID: <20180109003127.GA30224@linux.vnet.ibm.com>
References: <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
 <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
 <20180108225238.GN9671@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180108225238.GN9671@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Prateek Sood <prsood@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

On Mon, Jan 08, 2018 at 02:52:38PM -0800, Paul E. McKenney wrote:
> On Mon, Jan 08, 2018 at 04:28:23AM -0800, Tejun Heo wrote:
> > Hello, Paul.
> > 
> > Sorry about the delay.  Travel followed by cold. :(
> > 
> > On Tue, Jan 02, 2018 at 10:01:19AM -0800, Paul E. McKenney wrote:
> > > Actually, after taking a quick look, could you please supply me with
> > > a way of mark a statically allocated workqueue as WQ_MEM_RECLAIM after
> > > the fact?  Otherwise, I end up having to check for the workqueue having
> > 
> > Hmmm... there is no statically allocated workqueue tho.  If you're
> > referring to the system-wide workqueues (system*_wq), they're just
> > created dynamically early during boot.
> 
> Good point, I was confused.  But yes, they are conveniently allocated
> just before the call to rcu_init(), which does work out well.  ;-)
> 
> > > been allocated pretty much each time I use it, which is going to be an
> > > open invitation for bugs.  Plus it looks like there are ways that RCU's
> > > workqueue wakeups can be executed during very early boot, which can be
> > > handled, but again in a rather messy fashion.
> > > 
> > > In contrast, given a way of mark a statically allocated workqueue
> > > as WQ_MEM_RECLAIM after the fact, I simply continue initializing the
> > > workqueue at early boot, and then add the WQ_MEM_RECLAIM marking some
> > > arbitrarily chosen time after the scheduler has been initialized.
> > > 
> > > The required change to workqueues looks easy, just move the body of
> > > the "if (flags & WQ_MEM_RECLAIM) {" statement in __alloc_workqueue_key()
> > > to a separate function, right?
> > 
> > Ah, okay, yes, currently, workqueue init is kinda silly in that while
> > it allows init of non-mem-reclaiming workqueues way before workqueue
> > is actually online, it doesn't allow the same for mem-reclaiming ones.
> > As you pointed out, it's just an oversight on my part as the init path
> > split was done initially to accomodate early init of system
> > workqueues.
> > 
> > I'll update the code so that rescuers can be added later too; however,
> > please note that while the work items may be queued, they won't be
> > executed until workqueue_init() is run (the same as now) as there
> > can't be worker threads anyway before that point.
> 
> Thank you!  I added the following patch to allow RCU access to the
> init_rescuer() function.  Does that work for you, or did you have some
> other arrangement in mind?

And here are the corresponding changes to RCU, which pass light rcutorture
testing.

							Thanx, Paul

------------------------------------------------------------------------

commit d0d6626927faf3421df6a1db875ad7099f7d49cd
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Jan 8 14:35:52 2018 -0800

    rcu: Create RCU-specific workqueues with rescuers
    
    RCU's expedited grace periods can participate in out-of-memory deadlocks
    due to all available system_wq kthreads being blocked and there not being
    memory available to create more.  This commit prevents such deadlocks
    by allocating an RCU-specific workqueue_struct at early boot time, and
    providing it with a rescuer to ensure forward progress.  This uses the
    shiny new init_rescuer() function provided by Tejun.
    
    This commit also causes SRCU to use this new RCU-specific
    workqueue_struct.  Note that SRCU's use of workqueues never blocks them
    waiting for readers, so this should be safe from a forward-progress
    viewpoint.
    
    Reported-by: Prateek Sood <prsood@codeaurora.org>
    Reported-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 59c471de342a..acabc4781b08 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -493,6 +493,7 @@ void show_rcu_gp_kthreads(void);
 void rcu_force_quiescent_state(void);
 void rcu_bh_force_quiescent_state(void);
 void rcu_sched_force_quiescent_state(void);
+extern struct workqueue_struct *rcu_gp_workqueue;
 #endif /* #else #ifdef CONFIG_TINY_RCU */
 
 #ifdef CONFIG_RCU_NOCB_CPU
diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index 6d5880089ff6..89f0f6b3ce9a 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -465,7 +465,7 @@ static bool srcu_queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
  */
 static void srcu_schedule_cbs_sdp(struct srcu_data *sdp, unsigned long delay)
 {
-	srcu_queue_delayed_work_on(sdp->cpu, system_power_efficient_wq,
+	srcu_queue_delayed_work_on(sdp->cpu, rcu_gp_workqueue,
 				   &sdp->work, delay);
 }
 
@@ -664,7 +664,7 @@ static void srcu_funnel_gp_start(struct srcu_struct *sp, struct srcu_data *sdp,
 	    rcu_seq_state(sp->srcu_gp_seq) == SRCU_STATE_IDLE) {
 		WARN_ON_ONCE(ULONG_CMP_GE(sp->srcu_gp_seq, sp->srcu_gp_seq_needed));
 		srcu_gp_start(sp);
-		queue_delayed_work(system_power_efficient_wq, &sp->work,
+		queue_delayed_work(rcu_gp_workqueue, &sp->work,
 				   srcu_get_delay(sp));
 	}
 	raw_spin_unlock_irqrestore_rcu_node(sp, flags);
@@ -1198,7 +1198,7 @@ static void srcu_reschedule(struct srcu_struct *sp, unsigned long delay)
 	raw_spin_unlock_irq_rcu_node(sp);
 
 	if (pushgp)
-		queue_delayed_work(system_power_efficient_wq, &sp->work, delay);
+		queue_delayed_work(rcu_gp_workqueue, &sp->work, delay);
 }
 
 /*
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f9c0ca2ccf0c..99c12650b9db 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4272,6 +4272,15 @@ static void __init rcu_dump_rcu_node_tree(struct rcu_state *rsp)
 	pr_cont("\n");
 }
 
+struct workqueue_struct *rcu_gp_workqueue;
+
+static int __init rcu_init_wq_rescuer(void)
+{
+	WARN_ON(init_rescuer(rcu_gp_workqueue));
+	return 0;
+}
+core_initcall(rcu_init_wq_rescuer);
+
 void __init rcu_init(void)
 {
 	int cpu;
@@ -4298,6 +4307,10 @@ void __init rcu_init(void)
 		rcu_cpu_starting(cpu);
 		rcutree_online_cpu(cpu);
 	}
+
+	/* Create workqueue for expedited GPs and for Tree SRCU. */
+	rcu_gp_workqueue = alloc_workqueue("rcu_gp", 0, 0);
+	WARN_ON(!rcu_gp_workqueue);
 }
 
 #include "tree_exp.h"
diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index 46d61b597731..3ba3ef4d4796 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -606,7 +606,7 @@ static void _synchronize_rcu_expedited(struct rcu_state *rsp,
 		rew.rew_rsp = rsp;
 		rew.rew_s = s;
 		INIT_WORK_ONSTACK(&rew.rew_work, wait_rcu_exp_gp);
-		schedule_work(&rew.rew_work);
+		queue_work(rcu_gp_workqueue, &rew.rew_work);
 	}
 
 	/* Wait for expedited grace period to complete. */

