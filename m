From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Wed, 6 May 2015 11:12:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505061100040.4225@nanos>
References: <5546F80B.3070802@huawei.com> <1430716247.3129.44.camel@gmail.com> <1430717964.3129.62.camel@gmail.com> <554737AE.5040402@huawei.com> <20150504123738.GZ21418@twins.programming.kicks-ass.net> <20150505144104.GS1971@htj.duckdns.org>
 <20150505151113.GP21418@twins.programming.kicks-ass.net> <20150505161335.GT1971@htj.duckdns.org> <20150505165006.GR21418@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1505052007140.4225@nanos> <20150505190048.GY1971@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150505190048.GY1971@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, 5 May 2015, Tejun Heo wrote:
> On Tue, May 05, 2015 at 08:29:28PM +0200, Thomas Gleixner wrote:
> > As Peter said several times: hard failure is good and desired. It's a
> > very clear information on which people can act on. If the failures
> > modes are nilly-willy today, as you wrote somewhere, then we need to
> > fix that and make them consistent and understandable and not replace
> > them by half baken heuristics which postpone the failure to some point
> > where it is even less understandable.
> 
> There are no such magic heuristics because controllers need well
> defined behaviors when current is above limit anyway and behave
> exactly the same way no matter how that state is reached.  For

How would something go above limit in the first place if your resource
management is done proper?

  If a group has a resource limit, then it is not allowed to exceed
  that resource. So any attempt to use more resources must fail,
  period. There is no way to go above the limit.

  If you try to lower the limits of an existing group below the level
  which is already used, then this limit restriction attempt must
  fail.

That's the basic principle of resource management. And if you try to
avoid them, then you have a massive design failure. It's that simple.

Thanks,

	tglx



