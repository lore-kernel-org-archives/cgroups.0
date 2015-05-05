From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 17:19:49 +0200
Message-ID: <20150505151949.GQ21418@twins.programming.kicks-ass.net>
References: <5546C34C.7050202@huawei.com>
 <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <55483EF7.7070905@huawei.com>
 <20150505141049.GN21418@twins.programming.kicks-ass.net>
 <20150505141838.GR1971@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150505141838.GR1971@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, May 05, 2015 at 10:18:38AM -0400, Tejun Heo wrote:
> > Now you can kludge around some of this, for example you can make the
> > default depend on the parent setting etc.. But that's horribly
> > inconsistent.
> 
> I don't think we can kludge this.  For all other resources, we're
> defining the limits that can't be crossed so nesting them w/ -1 by
> default is fine.  RR slices are different it that we're really slicing
> up and guaranteeing a portion of something finite, so unlimited by
> default thing doesn't really work here.

Note that you _could_ do the same thing with IO bandwidth; esp. with
these modern no-seek-penalty devices this could make sense.


> > So I really prefer not to go that way; if people use RR/FIFO they had
> > better bloody know what they're doing; which includes setting up the
> > system.
> 
> The problem is that this is tied to the normal cpu controller.  Users
> who don't have any intention of mucking with RT scheduling end up
> being dragged into it.  Given the strict nature of RR slicing, I'm
> don't even think it's actually useful to make the slicing
> hierarchical.  From cgroup's POV, it'd be best if RR slicing can be
> detached.

Like in the other mail; hierarchy still makes perfect sense for the
container case.

> > The whole RR/FIFO thing is so enormously broken (by definition; this
> > truly is unfixable) that you simply _cannot_ automate it.
> 
> Yeah, exactly.

I don't think you're quite agreeing to the same reasons I am. My main
objection to the whole SCHED_RR/FIFO thing as defined by POSIX is that
it does not in fact allow the OS to do what an OS _should_ do, namely
resource arbitration and control.

The whole rt-cgroup controller tries to somewhat contain that, but
fundamentally once you use RR/FIFO you've given up your system to
userspace control -- which btw is why its usually limited to root.

SCHED_DEADLINE avoids all these problems, at the cost of a more complex
setup.

But the fact that both need fixed portions of a limited total does not
in fact mean they're broken.
