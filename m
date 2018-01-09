From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Tue, 9 Jan 2018 07:21:12 -0800
Message-ID: <20180109152112.GT9671@linux.vnet.ibm.com>
References: <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
 <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
 <20180108225238.GN9671@linux.vnet.ibm.com>
 <20180109003127.GA30224@linux.vnet.ibm.com>
 <20180109034211.GC3668920@devbig577.frc2.facebook.com>
 <20180109042016.GR9671@linux.vnet.ibm.com>
 <20180109134448.GE3668920@devbig577.frc2.facebook.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180109134448.GE3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On Tue, Jan 09, 2018 at 05:44:48AM -0800, Tejun Heo wrote:
> Hello, Paul.
> 
> On Mon, Jan 08, 2018 at 08:20:16PM -0800, Paul E. McKenney wrote:
> > OK, so I can put WQ_MEM_RECLAIM on the early boot creation of RCU's
> > workqueue_struct as shown below, right?
> 
> Yes, this looks good to me.  Just one question.
> 
> > +struct workqueue_struct *rcu_gp_workqueue;
> > +
> >  void __init rcu_init(void)
> >  {
> >  	int cpu;
> > @@ -4298,6 +4300,10 @@ void __init rcu_init(void)
> >  		rcu_cpu_starting(cpu);
> >  		rcutree_online_cpu(cpu);
> >  	}
> > +
> > +	/* Create workqueue for expedited GPs and for Tree SRCU. */
> > +	rcu_gp_workqueue = alloc_workqueue("rcu_gp", WQ_MEM_RECLAIM, 0);
> > +	WARN_ON(!rcu_gp_workqueue);
> 
> The code was previously using both system_power_efficient_wq and
> system_workqueue (for the expedited path).  I guess the options were
> either using two workqueues or dropping POWER_EFFICIENT.  I have no
> idea how big an impact this will make or whether it'd even be
> noticeable but maybe it'd be worthwhile to mention that in the
> description?

Good point!  How about if I change the last paragraph of the commit
log to read as follows?

							Thanx, Paul

------------------------------------------------------------------------

This commit also causes SRCU to use this new RCU-specific
workqueue_struct.  Note that SRCU's use of workqueues never blocks them
waiting for readers, so this should be safe from a forward-progress
viewpoint.  Note that this moves SRCU from system_power_efficient_wq
to a normal workqueue.  In the unlikely event that this results in 
measurable degradation, a separate power-efficient workqueue will be
creates for SRCU.
