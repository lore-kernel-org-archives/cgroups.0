From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 14:37:42 +0200
Message-ID: <20200521123742.GO6462@dhcp22.suse.cz>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
 <20200521120455.GM6462@dhcp22.suse.cz>
 <20200521122327.GB990580@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200521122327.GB990580@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu 21-05-20 13:23:27, Chris Down wrote:
> (I'll leave the dirty throttling discussion to Johannes, because I'm not so
> familiar with that code or its history.)
> 
> Michal Hocko writes:
> > > > The main problem I see with that approach is that the loop could easily
> > > > lead to reclaim unfairness when a heavy producer which doesn't leave the
> > > > kernel (e.g. a large read/write call) can keep a different task doing
> > > > all the reclaim work. The loop is effectivelly unbound when there is a
> > > > reclaim progress and so the return to the userspace is by no means
> > > > proportional to the requested memory/charge.
> > > 
> > > It's not unbound when there is reclaim progress, it stops when we are within
> > > the memory.high throttling grace period. Right after reclaim, we check if
> > > penalty_jiffies is less than 10ms, and abort and further reclaim or
> > > allocator throttling:
> > 
> > Just imagine that you have parallel producers increasing the high limit
> > excess while somebody reclaims those. Sure in practice the loop will be
> > bounded but the reclaimer might perform much more work on behalf of
> > other tasks.
> 
> A cgroup is a unit and breaking it down into "reclaim fairness" for
> individual tasks like this seems suspect to me. For example, if one task in
> a cgroup is leaking unreclaimable memory like crazy, everyone in that cgroup
> is going to be penalised by allocator throttling as a result, even if they
> aren't "responsible" for that reclaim.

You are right, but that doesn't mean that it is desirable that some
tasks would be throttled unexpectedly too long because of the other's activity.
We already have that behavior for the direct reclaim and I have to say I
really hate it and had to spend a lot of time debugging latency issues.
Our excuse has been that the system is struggling at that time so any
quality of service is simply out of picture. I do not think the same
argument can be applied to memory.high which doesn't really represent a
mark when the memcg is struggling so hard to drop any signs of fairness
on the floor.

> So the options here are as follows when a cgroup is over memory.high and a
> single reclaim isn't enough:
> 
> 1. Decline further reclaim. Instead, throttle for up to 2 seconds.
> 2. Keep on reclaiming. Only throttle if we can't get back under memory.high.
> 
> The outcome of your suggestion to decline further reclaim is case #1, which
> is significantly more practically "unfair" to that task. Throttling is
> extremely disruptive to tasks and should be a last resort when we've
> exhausted all other practical options. It shouldn't be something you get
> just because you didn't try to reclaim hard enough.

I believe I have asked in other email in this thread. Could you explain
why enforcint the requested target (memcg_nr_pages_over_high) is
insufficient for the problem you are dealing with? Because that would
make sense for large targets to me while it would keep relatively
reasonable semantic of the throttling - aka proportional to the memory
demand rather than the excess.
-- 
Michal Hocko
SUSE Labs
