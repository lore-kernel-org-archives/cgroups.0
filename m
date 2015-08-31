From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] memcg: fix over-high reclaim amount
Date: Mon, 31 Aug 2015 09:51:33 +0200
Message-ID: <20150831075133.GA29723@dhcp22.suse.cz>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-2-git-send-email-tj@kernel.org>
 <20150828170612.GA21463@dhcp22.suse.cz>
 <20150828183209.GA9423@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150828183209.GA9423-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri 28-08-15 14:32:09, Tejun Heo wrote:
> Hello,
> 
> On Fri, Aug 28, 2015 at 07:06:13PM +0200, Michal Hocko wrote:
> > I do not think this a better behavior. If you have parallel charges to
> > the same memcg then you can easilly over-reclaim  because everybody
> > will reclaim the maximum rather than its contribution.
> > 
> > Sure we can fail to reclaim the target and slowly grow over high limit
> > but that is to be expected. This is not the max limit which cannot be
> > breached and external memory pressure/reclaim is there to mitigate that.
> 
> Ah, I see, yeah, over-reclaim can happen.  How about just wrapping the
> over-high reclaim with a per-memcg mutex?  Do we gain anything by
> putting multiple tasks into the reclaim path?

The overall reclaim throughput will be higher with the parallel reclaim.
Threads might still get synchronized on the zone lru lock but this is only
for isolating them from the LRU. In a larger hierarchies this even might
not be the case because the hierarchy iterator tries to spread the reclaim
over different memcgs.

So the per-memcg mutex would solve the potential over-reclaim but it
will restrain the reclaim activity unnecessarily. Why is per-contribution
reclaim such a big deal in the first place? If there are runaways
allocation requests like GFP_NOWAIT then we should look after those. And
I would argue that your delayed reclaim idea is a great fit for that. We
just should track how many pages were charged over high limit in the
process context and reclaim that amount on the way out from the kernel.

-- 
Michal Hocko
SUSE Labs
