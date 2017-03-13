From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Mon, 13 Mar 2017 15:26:21 -0400
Message-ID: <20170313192621.GD15709@htj.duckdns.org>
References: <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
 <20170208230819.GD25826@htj.duckdns.org>
 <20170209102909.GC6515@twins.programming.kicks-ass.net>
 <20170210154508.GA16097@mtj.duckdns.org>
 <20170210175145.GJ6515@twins.programming.kicks-ass.net>
 <20170212050544.GJ29323@mtj.duckdns.org>
 <1486882799.24462.25.camel@gmx.de>
 <1486964707.5912.93.camel@gmx.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A858m5CkQbNJa5f/6O6Hi2TjefSfhztvBu51rPf1CpU=;
        b=omj7P9i/Q1F/Shxl8zYARGBypVd4Kuh5mehpY9Swai6NVkhzADh2C2NqpajgjFu7Co
         pX/03yCudF5eWVgGY7t3H4EJJ8jwfoVMlSUMb+5SJDXrjVdi3DAakbAxU/3TAhFLGjiz
         MrgMg3V2HcEkXcevPW20pBAZJwHawJjuzdVSGYGiF95pwWRUs0TNwojwYgIIEYWXk35i
         YqBvkfLTAU0y2oByGuoxFNTVwFHjU5cYSCquIatd4kqeKJ3DUqU/LZSqF7VQqLLqwIsO
         nV8YcrgE1FoN6Qps/UTXFhU28BwCVOZN/phk/L+Yd9mrL1yMWUoNLo0KquEuYrmF9+2/
         2wow==
Content-Disposition: inline
In-Reply-To: <1486964707.5912.93.camel-Mmb7MZpHnFY@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Mike.

Sorry about the long delay.

On Mon, Feb 13, 2017 at 06:45:07AM +0100, Mike Galbraith wrote:
> > > So, as long as the depth stays reasonable (single digit or lower),
> > > what we try to do is keeping tree traversal operations aggregated or
> > > located on slow paths.  There still are places that this overhead
> > > shows up (e.g. the block controllers aren't too optimized) but it
> > > isn't particularly difficult to make a handful of layers not matter at
> > > all.
> > 
> > A handful of cpu bean counting layers stings considerably.

Hmm... yeah, I was trying to think about ways to avoid full scheduling
overhead at each layer (the scheduler does a lot per each layer of
scheduling) but don't think it's possible to circumvent that without
introducing a whole lot of scheduling artifacts.

In a lot of workloads, the added overhead from several layers of CPU
controllers doesn't seem to get in the way too much (most threads do
something other than scheduling after all).  The only major issue that
we're seeing in the fleet is the cgroup iteration in idle rebalancing
code pushing up the scheduling latency too much but that's a different
issue.

Anyways, I understand that there are cases where people would want to
avoid any extra layers.  I'll continue on PeterZ's message.

> BTW, that overhead is also why merging cpu/cpuacct is not really as
> wonderful as it may seem on paper.  If you only want to account, you
> may not have anything to gain from group scheduling (in fact it may
> wreck performance), but you'll pay for it.

There's another reason why we would want accounting separate - because
weight based controllers, cpu and io currently, can't be enabled
without affecting the scheduling behavior.  However, they're different
from CPU controllers in that all the heavy part of operations can be
shifted to the readers (we just need to do per-cpu updates from hot
paths), so we might as well publish those stats by default on the v2
hierarchy.  We couldn't do the same in v1 because the number of
hierarchies were not limited.

Thanks.

-- 
tejun
