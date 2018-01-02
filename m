From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Tue, 2 Jan 2018 10:01:19 -0800
Message-ID: <20180102180119.GA1355@linux.vnet.ibm.com>
References: <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180102174408.GM7829@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Prateek Sood <prsood@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

On Tue, Jan 02, 2018 at 09:44:08AM -0800, Paul E. McKenney wrote:
> On Tue, Jan 02, 2018 at 08:16:56AM -0800, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Dec 29, 2017 at 02:07:16AM +0530, Prateek Sood wrote:
> > > task T is waiting for cpuset_mutex acquired
> > > by kworker/2:1
> > > 
> > > sh ==> cpuhp/2 ==> kworker/2:1 ==> sh 
> > > 
> > > kworker/2:3 ==> kthreadd ==> Task T ==> kworker/2:1
> > > 
> > > It seems that my earlier patch set should fix this scenario:
> > > 1) Inverting locking order of cpuset_mutex and cpu_hotplug_lock.
> > > 2) Make cpuset hotplug work synchronous.
> > >
> > > Could you please share your feedback.
> > 
> > Hmm... this can also be resolved by adding WQ_MEM_RECLAIM to the
> > synchronize rcu workqueue, right?  Given the wide-spread usages of
> > synchronize_rcu and friends, maybe that's the right solution, or at
> > least something we also need to do, for this particular deadlock?
> 
> To make WQ_MEM_RECLAIM work, I need to dynamically allocate RCU's
> workqueues, correct?  Or is there some way to mark a statically
> allocated workqueue as WQ_MEM_RECLAIM after the fact?
> 
> I can dynamically allocate them, but I need to carefully investigate
> boot-time use.  So if it is possible to be lazy, I do want to take
> the easy way out.  ;-)

Actually, after taking a quick look, could you please supply me with
a way of mark a statically allocated workqueue as WQ_MEM_RECLAIM after
the fact?  Otherwise, I end up having to check for the workqueue having
been allocated pretty much each time I use it, which is going to be an
open invitation for bugs.  Plus it looks like there are ways that RCU's
workqueue wakeups can be executed during very early boot, which can be
handled, but again in a rather messy fashion.

In contrast, given a way of mark a statically allocated workqueue
as WQ_MEM_RECLAIM after the fact, I simply continue initializing the
workqueue at early boot, and then add the WQ_MEM_RECLAIM marking some
arbitrarily chosen time after the scheduler has been initialized.

The required change to workqueues looks easy, just move the body of
the "if (flags & WQ_MEM_RECLAIM) {" statement in __alloc_workqueue_key()
to a separate function, right?

							Thanx, Paul

