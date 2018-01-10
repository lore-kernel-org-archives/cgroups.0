From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Wed, 10 Jan 2018 12:08:21 -0800
Message-ID: <20180110200821.GA22541@linux.vnet.ibm.com>
References: <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
 <20180108225238.GN9671@linux.vnet.ibm.com>
 <20180109003127.GA30224@linux.vnet.ibm.com>
 <20180109034211.GC3668920@devbig577.frc2.facebook.com>
 <20180109042016.GR9671@linux.vnet.ibm.com>
 <20180109134448.GE3668920@devbig577.frc2.facebook.com>
 <20180109152112.GT9671@linux.vnet.ibm.com>
 <20180109153752.GI3668920@devbig577.frc2.facebook.com>
 <20180109160022.GW9671@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109160022.GW9671@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Prateek Sood <prsood@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

On Tue, Jan 09, 2018 at 08:00:22AM -0800, Paul E. McKenney wrote:
> On Tue, Jan 09, 2018 at 07:37:52AM -0800, Tejun Heo wrote:
> > Hello, Paul.
> > 
> > On Tue, Jan 09, 2018 at 07:21:12AM -0800, Paul E. McKenney wrote:
> > > > The code was previously using both system_power_efficient_wq and
> > > > system_workqueue (for the expedited path).  I guess the options were
> > > > either using two workqueues or dropping POWER_EFFICIENT.  I have no
> > > > idea how big an impact this will make or whether it'd even be
> > > > noticeable but maybe it'd be worthwhile to mention that in the
> > > > description?
> > > 
> > > Good point!  How about if I change the last paragraph of the commit
> > > log to read as follows?
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > > This commit also causes SRCU to use this new RCU-specific
> > > workqueue_struct.  Note that SRCU's use of workqueues never blocks them
> > > waiting for readers, so this should be safe from a forward-progress
> > > viewpoint.  Note that this moves SRCU from system_power_efficient_wq
> > > to a normal workqueue.  In the unlikely event that this results in 
> > > measurable degradation, a separate power-efficient workqueue will be
> > > creates for SRCU.
> > 
> > Sounds good.  Please feel free to add
> > 
> >  Acked-by: Tejun Heo <tj@kernel.org>
> 
> Done, thank you!

And one additional question...  How are we pushing this upstream?  By
default, I would push things starting this late into the merge window
following the next one (v4.17), but would be more than willing to make
an exception given that this fixes a valid real-world complaint.

For that matter, if you would rather push my commit along with your pair
of commits, that works for me!  Either way, please just let me know.

							Thanx, Paul

