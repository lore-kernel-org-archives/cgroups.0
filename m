From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Fri, 29 May 2020 12:14:12 +0200
Message-ID: <20200529101412.GJ4406@dhcp22.suse.cz>
References: <20200521073245.GI6462@dhcp22.suse.cz>
 <20200521135152.GA810429@cmpxchg.org>
 <20200521143515.GU6462@dhcp22.suse.cz>
 <20200521163833.GA813446@cmpxchg.org>
 <20200521173701.GX6462@dhcp22.suse.cz>
 <20200521184505.GA815980@cmpxchg.org>
 <20200528163101.GJ27484@dhcp22.suse.cz>
 <20200528164848.GB839178@chrisdown.name>
 <20200529073118.GE4406@dhcp22.suse.cz>
 <20200529100858.GA98458@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200529100858.GA98458-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri 29-05-20 11:08:58, Chris Down wrote:
> Michal Hocko writes:
> > > > > task->memcg_nr_pages_over_high is not vague, it's a best-effort
> > > > > mechanism to distribute fairness. It's the current task's share of the
> > > > > cgroup's overage, and it allows us in the majority of situations to
> > > > > distribute reclaim work and sleeps in proportion to how much the task
> > > > > is actually at fault.
> > > >
> > > > Agreed. But this stops being the case as soon as the reclaim target has
> > > > been reached and new reclaim attempts are enforced because the memcg is
> > > > still above the high limit. Because then you have a completely different
> > > > reclaim target - get down to the limit. This would be especially visible
> > > > with a large memcg_nr_pages_over_high which could even lead to an over
> > > > reclaim.
> > > 
> > > We actually over reclaim even before this patch -- this patch doesn't bring
> > > much new in that regard.
> > > 
> > > Tracing try_to_free_pages for a cgroup at the memory.high threshold shows
> > > that before this change, we sometimes even reclaim on the order of twice the
> > > number of pages requested. For example, I see cases where we requested 1000
> > > pages to be reclaimed, but end up reclaiming 2000 in a single reclaim
> > > attempt.
> > 
> > This is interesting and worth looking into. I am aware that we can
> > reclaim potentially much more pages during the icache reclaim and that
> > there was a heated discussion without any fix merged in the end IIRC.
> > Do you have any details?
> 
> Sure, we can look into this more, but let's do it separately from this patch
> -- I don't see that its merging should be contingent on that discussion :-)

Yes that is a separate issue.
-- 
Michal Hocko
SUSE Labs
