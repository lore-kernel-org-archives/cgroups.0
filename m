From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 8 Jan 2018 14:52:38 -0800
Message-ID: <20180108225238.GN9671@linux.vnet.ibm.com>
References: <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
 <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180108122823.GL3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On Mon, Jan 08, 2018 at 04:28:23AM -0800, Tejun Heo wrote:
> Hello, Paul.
> 
> Sorry about the delay.  Travel followed by cold. :(
> 
> On Tue, Jan 02, 2018 at 10:01:19AM -0800, Paul E. McKenney wrote:
> > Actually, after taking a quick look, could you please supply me with
> > a way of mark a statically allocated workqueue as WQ_MEM_RECLAIM after
> > the fact?  Otherwise, I end up having to check for the workqueue having
> 
> Hmmm... there is no statically allocated workqueue tho.  If you're
> referring to the system-wide workqueues (system*_wq), they're just
> created dynamically early during boot.

Good point, I was confused.  But yes, they are conveniently allocated
just before the call to rcu_init(), which does work out well.  ;-)

> > been allocated pretty much each time I use it, which is going to be an
> > open invitation for bugs.  Plus it looks like there are ways that RCU's
> > workqueue wakeups can be executed during very early boot, which can be
> > handled, but again in a rather messy fashion.
> > 
> > In contrast, given a way of mark a statically allocated workqueue
> > as WQ_MEM_RECLAIM after the fact, I simply continue initializing the
> > workqueue at early boot, and then add the WQ_MEM_RECLAIM marking some
> > arbitrarily chosen time after the scheduler has been initialized.
> > 
> > The required change to workqueues looks easy, just move the body of
> > the "if (flags & WQ_MEM_RECLAIM) {" statement in __alloc_workqueue_key()
> > to a separate function, right?
> 
> Ah, okay, yes, currently, workqueue init is kinda silly in that while
> it allows init of non-mem-reclaiming workqueues way before workqueue
> is actually online, it doesn't allow the same for mem-reclaiming ones.
> As you pointed out, it's just an oversight on my part as the init path
> split was done initially to accomodate early init of system
> workqueues.
> 
> I'll update the code so that rescuers can be added later too; however,
> please note that while the work items may be queued, they won't be
> executed until workqueue_init() is run (the same as now) as there
> can't be worker threads anyway before that point.

Thank you!  I added the following patch to allow RCU access to the
init_rescuer() function.  Does that work for you, or did you have some
other arrangement in mind?

							Thanx, Paul

------------------------------------------------------------------------

commit 66683a07503d71e5d5cceac72caf772e6e59c787
Author: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Mon Jan 8 14:27:46 2018 -0800

    workqueue: Allow init_rescuer() to be invoked from other files
    
    This commit exports init_rescuer() so that RCU can invoke it.
    
    Signed-off-by: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
    Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
    Cc: Lai Jiangshan <jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 4a54ef96aff5..31ce9343b4a9 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -433,6 +433,8 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 #define create_singlethread_workqueue(name)				\
 	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
 
+int init_rescuer(struct workqueue_struct *wq);
+
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c86cc1ed678b..7440c61c6213 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3943,7 +3943,7 @@ static int wq_clamp_max_active(int max_active, unsigned int flags,
  * Workqueues which may be used during memory reclaim should have a rescuer
  * to guarantee forward progress.
  */
-static int init_rescuer(struct workqueue_struct *wq)
+int init_rescuer(struct workqueue_struct *wq)
 {
 	struct worker *rescuer;
 	int ret;
