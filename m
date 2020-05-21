From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 15:28:26 +0200
Message-ID: <20200521132826.GS6462@dhcp22.suse.cz>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
 <20200521120455.GM6462@dhcp22.suse.cz>
 <20200521122327.GB990580@chrisdown.name>
 <20200521123742.GO6462@dhcp22.suse.cz>
 <20200521125759.GD990580@chrisdown.name>
 <20200521130530.GE990580@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200521130530.GE990580-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 21-05-20 14:05:30, Chris Down wrote:
> Chris Down writes:
> > > I believe I have asked in other email in this thread. Could you explain
> > > why enforcint the requested target (memcg_nr_pages_over_high) is
> > > insufficient for the problem you are dealing with? Because that would
> > > make sense for large targets to me while it would keep relatively
> > > reasonable semantic of the throttling - aka proportional to the memory
> > > demand rather than the excess.
> > 
> > memcg_nr_pages_over_high is related to the charge size. As such, if
> > you're way over memory.high as a result of transient reclaim failures,
> > but the majority of your charges are small, it's going to hard to make
> > meaningful progress:
> > 
> > 1. Most nr_pages will be MEMCG_CHARGE_BATCH, which is not enough to help;
> > 2. Large allocations will only get a single reclaim attempt to succeed.
> > 
> > As such, in many cases we're either doomed to successfully reclaim a
> > paltry amount of pages, or fail to reclaim a lot of pages. Asking
> > try_to_free_pages() to deal with those huge allocations is generally not
> > reasonable, regardless of the specifics of why it doesn't work in this
> > case.
> 
> Oh, I somehow elided the "enforcing" part of your proposal. Still, there's
> no guarantee even if large allocations are reclaimed fully that we will end
> up going back below memory.high, because even a single other large
> allocation which fails to reclaim can knock us out of whack again.

Yeah, there is no guarantee and that is fine. Because memory.high is not
about guarantee. It is about a best effort and slowing down the
allocation pace so that the userspace has time to do something about
that.

That being said I would be really curious about how enforcing the
memcg_nr_pages_over_high target works in your setups where you see the
problem. If that doesn't work for some reason and the reclaim should be
more pro-active then I would suggest to scale it via memcg_nr_pages_over_high
rather than essentially keep it around and ignore it. Preserving at
least some form of fairness and predictable behavior is important IMHO
but if there is no way to achieve that then there should be a very good
explanation for that.

I hope that we it is more clear what is our thinking now. I will be FTO
for upcoming days trying to get some rest from email so my response time
will be longer. Will be back on Thursday.
-- 
Michal Hocko
SUSE Labs
