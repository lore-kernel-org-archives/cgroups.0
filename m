From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 8 Jan 2018 20:20:16 -0800
Message-ID: <20180109042016.GR9671@linux.vnet.ibm.com>
References: <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
 <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
 <20180108225238.GN9671@linux.vnet.ibm.com>
 <20180109003127.GA30224@linux.vnet.ibm.com>
 <20180109034211.GC3668920@devbig577.frc2.facebook.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109034211.GC3668920@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Prateek Sood <prsood@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

On Mon, Jan 08, 2018 at 07:42:11PM -0800, Tejun Heo wrote:
> Hello, Paul.
> 
> On Mon, Jan 08, 2018 at 04:31:27PM -0800, Paul E. McKenney wrote:
> > +static int __init rcu_init_wq_rescuer(void)
> > +{
> > +	WARN_ON(init_rescuer(rcu_gp_workqueue));
> > +	return 0;
> > +}
> > +core_initcall(rcu_init_wq_rescuer);
> 
> So, what I don't get is why RCU needs to call this explicitly.
> core_initcall() is after workqueue_init() anyway.  Why am I missing?

Me being stupid, I guess.

OK, so I can put WQ_MEM_RECLAIM on the early boot creation of RCU's
workqueue_struct as shown below, right?

							Thanx, Paul

------------------------------------------------------------------------

commit 9884a945a65837cda6de2ff621d47c59a6ca3e28
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Jan 8 14:35:52 2018 -0800

    rcu: Create RCU-specific workqueues with rescuers
    
    RCU's expedited grace periods can participate in out-of-memory deadlocks
    due to all available system_wq kthreads being blocked and there not being
    memory available to create more.  This commit prevents such deadlocks
    by allocating an RCU-specific workqueue_struct at early boot time, and
    providing it with a rescuer to ensure forward progress.  This uses the
    shiny new init_rescuer() function provided by Tejun (but indirectly).
    
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
index f9c0ca2ccf0c..d658538e6f7d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4272,6 +4272,8 @@ static void __init rcu_dump_rcu_node_tree(struct rcu_state *rsp)
 	pr_cont("\n");
 }
 
+struct workqueue_struct *rcu_gp_workqueue;
+
 void __init rcu_init(void)
 {
 	int cpu;
@@ -4298,6 +4300,10 @@ void __init rcu_init(void)
 		rcu_cpu_starting(cpu);
 		rcutree_online_cpu(cpu);
 	}
+
+	/* Create workqueue for expedited GPs and for Tree SRCU. */
+	rcu_gp_workqueue = alloc_workqueue("rcu_gp", WQ_MEM_RECLAIM, 0);
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

