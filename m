From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Tue, 2 Jan 2018 09:44:08 -0800
Message-ID: <20180102174408.GM7829@linux.vnet.ibm.com>
References: <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180102161656.GD3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On Tue, Jan 02, 2018 at 08:16:56AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Fri, Dec 29, 2017 at 02:07:16AM +0530, Prateek Sood wrote:
> > task T is waiting for cpuset_mutex acquired
> > by kworker/2:1
> > 
> > sh ==> cpuhp/2 ==> kworker/2:1 ==> sh 
> > 
> > kworker/2:3 ==> kthreadd ==> Task T ==> kworker/2:1
> > 
> > It seems that my earlier patch set should fix this scenario:
> > 1) Inverting locking order of cpuset_mutex and cpu_hotplug_lock.
> > 2) Make cpuset hotplug work synchronous.
> >
> > Could you please share your feedback.
> 
> Hmm... this can also be resolved by adding WQ_MEM_RECLAIM to the
> synchronize rcu workqueue, right?  Given the wide-spread usages of
> synchronize_rcu and friends, maybe that's the right solution, or at
> least something we also need to do, for this particular deadlock?

To make WQ_MEM_RECLAIM work, I need to dynamically allocate RCU's
workqueues, correct?  Or is there some way to mark a statically
allocated workqueue as WQ_MEM_RECLAIM after the fact?

I can dynamically allocate them, but I need to carefully investigate
boot-time use.  So if it is possible to be lazy, I do want to take
the easy way out.  ;-)

							Thanx, Paul

> Again, I don't have anything against making the domain rebuliding part
> of cpuset operations synchronous and these tricky deadlock scenarios
> do indicate that doing so would probably be beneficial.  That said,
> tho, these scenarios seem more of manifestations of other problems
> exposed through kthreadd dependency than anything else.
> 
> Thanks.
> 
> -- 
> tejun
> 
