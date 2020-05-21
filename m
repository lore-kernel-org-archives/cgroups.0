From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 15:58:38 +0200
Message-ID: <20200521135838.GT6462@dhcp22.suse.cz>
References: <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
 <20200521120455.GM6462@dhcp22.suse.cz>
 <20200521122327.GB990580@chrisdown.name>
 <20200521123742.GO6462@dhcp22.suse.cz>
 <20200521125759.GD990580@chrisdown.name>
 <20200521132120.GR6462@dhcp22.suse.cz>
 <20200521133324.GF990580@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200521133324.GF990580-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 21-05-20 14:41:47, Chris Down wrote:
> Michal Hocko writes:
> > On Thu 21-05-20 13:57:59, Chris Down wrote:
[...]
> > > If you're talking about reclaim, trying to reason about whether the overage
> > > is the result of some other task in this cgroup or the task that's
> > > allocating right now is something that we already know doesn't work well
> > > (eg. global OOM).
> > 
> > I am not sure I follow you here.
> 
> Let me rephrase: your statement is that it's not desirable "that some task
> would be throttled unexpectedly too long because of [the activity of another
> task also within that cgroup]" (let me know if that's not what you meant).
> But trying to avoid that requires knowing which activity abstractly
> instigates this entire mess in the first place, which we have nowhere near
> enough context to determine.

Yeah, if we want to be really precise then you are right, nothing like
that is really feasible for the reclaim. Reclaiming 1 page might be much
more expensive than 100 pages because LRU order doesn't reflect the
cost of the reclaim at all. What, I believe, we want is a best effort,
really. If the reclaim target is somehow bound to the requested amount
of memory then we can at least say that more memory hungry consumers are
reclaiming more. Which is something people can wrap their head around
much easier than a free competition on the reclaim with some hard to
predict losers who do all the work and some lucky ones which just happen
to avoid throttling by a better timing. Really think of the direct
reclaim and how the unfairness suck there.

-- 
Michal Hocko
SUSE Labs
