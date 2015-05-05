From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 12:31:12 -0400
Message-ID: <20150505163112.GU1971@htj.duckdns.org>
References: <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <55483EF7.7070905@huawei.com>
 <20150505141049.GN21418@twins.programming.kicks-ass.net>
 <20150505141838.GR1971@htj.duckdns.org>
 <20150505151949.GQ21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=C1XIIVoZqiZR14HwjjLXIT3t+5qUIQmMpQ8U6KlctpI=;
        b=AkHtZI5HLiHFMtJhFadQUSe9KLsJCsQoQT/Ml9cnQUXXA/WdVit/pWineKQB5xWD+6
         Dd+wRBhoRKYt41V0/LyG/tntkEyeKXE/2JJafAAzxs0YFqLbASxSvRwHtBw64/PxlodK
         K0IwKobsPzondA8Bb+GTRrBYWlgAW119GJoPCW1FQx6Hvq3WOPTPUReQshARkR6x0K4q
         uFhbKElSI5oYzVYVXiS5JilSpczb+sduzQbhiA3SAmYeRCrtlKzG+yU8Q4lots/Z3Zcn
         oRKJGXtKxaleMp97r+hOMuct46gFaEyur4m1Y+tzb3LQCXdn2Pmcc2e1xf9RPqVk2kBA
         8hsw==
Content-Disposition: inline
In-Reply-To: <20150505151949.GQ21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hello, Peter.

On Tue, May 05, 2015 at 05:19:49PM +0200, Peter Zijlstra wrote:
> > I don't think we can kludge this.  For all other resources, we're
> > defining the limits that can't be crossed so nesting them w/ -1 by
> > default is fine.  RR slices are different it that we're really slicing
> > up and guaranteeing a portion of something finite, so unlimited by
> > default thing doesn't really work here.
> 
> Note that you _could_ do the same thing with IO bandwidth; esp. with
> these modern no-seek-penalty devices this could make sense.

Yeah, maybe.  It currently is too unpredictable to do that (at least
from OS side w/ all the layering) but that is a possibility.

> > The problem is that this is tied to the normal cpu controller.  Users
> > who don't have any intention of mucking with RT scheduling end up
> > being dragged into it.  Given the strict nature of RR slicing, I'm
> > don't even think it's actually useful to make the slicing
> > hierarchical.  From cgroup's POV, it'd be best if RR slicing can be
> > detached.
> 
> Like in the other mail; hierarchy still makes perfect sense for the
> container case.

We'd still need an on-demand arbitration mechanism across containers
no matter what we do which might as well take care of everything.  But
please see below.

> > > The whole RR/FIFO thing is so enormously broken (by definition; this
> > > truly is unfixable) that you simply _cannot_ automate it.
> > 
> > Yeah, exactly.
> 
> I don't think you're quite agreeing to the same reasons I am. My main
> objection to the whole SCHED_RR/FIFO thing as defined by POSIX is that
> it does not in fact allow the OS to do what an OS _should_ do, namely
> resource arbitration and control.
> 
> The whole rt-cgroup controller tries to somewhat contain that, but
> fundamentally once you use RR/FIFO you've given up your system to
> userspace control -- which btw is why its usually limited to root.
> 
> SCHED_DEADLINE avoids all these problems, at the cost of a more complex
> setup.
> 
> But the fact that both need fixed portions of a limited total does not
> in fact mean they're broken.

But that does make them pretty different from others.  What bothers me
the most about RR slices right now is that it's tightly coupled with
the rest of cpu controller while having a very different set of
characteristics.  Maybe this is something mandated by the underlying
structure and we have to live with it but it definitely isn't an ideal
situation.

What I don't want to happen is controllers failing migrations
willy-nilly for random reasons leaving users baffled, which we've
actually been doing unfortunately.  Maybe we need to deal with this
fixed resource arbitration as a separate class and allow them to fail
migration w/ -EBUSY.

Thanks.

-- 
tejun
