From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 16:10:49 +0200
Message-ID: <20150505141049.GN21418@twins.programming.kicks-ass.net>
References: <5546C34C.7050202@huawei.com>
 <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <55483EF7.7070905@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55483EF7.7070905@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, May 05, 2015 at 11:54:31AM +0800, Zefan Li wrote:

> But I was wondering if we can change the default value of cpu.rt_runtime_us
> from 0 to -1? So by default the RT tasks can be attached to a newly-created
> cgroup without users having to make any configuration, and those tasks are
> confined by the parent cgroup, which is what we have with cfs bw control.
> This require some changes to the code, but I guess it's do-able?

Its tricky.

Imagine:

	  root
	 /    \
	A      B
       / \    / \
      a1 a2  b1 b2

Now if they all have -1, I cannot set a bw on any except the leaf nodes
([ab][12]). Because the sum of child bw must strictly be smaller or
equal to the parent bandwidth, and -1 if effective inf.

Similarly, if A has bw enabled I cannot create a new child with -1.
Because above.

Now you can kludge around some of this, for example you can make the
default depend on the parent setting etc.. But that's horribly
inconsistent.

So I really prefer not to go that way; if people use RR/FIFO they had
better bloody know what they're doing; which includes setting up the
system.

The whole RR/FIFO thing is so enormously broken (by definition; this
truly is unfixable) that you simply _cannot_ automate it.
