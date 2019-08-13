From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: vmscan: do not share cgroup iteration between
 reclaimers
Date: Tue, 13 Aug 2019 13:12:37 -0400
Message-ID: <20190813171237.GA21743@cmpxchg.org>
References: <20190812192316.13615-1-hannes@cmpxchg.org>
 <20190813132938.GJ17933@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t4C71UdUds8mfeMVRJziN4Jin8vpYyBJxbMwjur/Fro=;
        b=E1iZdgGcDwOWZSz781OrghxIVDmdCFm/suaSubJzTX/RHIbSaauz/rqQaBTA0IIlsL
         ydLOykhXrF+BbCHfIKE5mcgxzUEXo+PkcOgawkYtiX3+3AN4lhBdptyVnBxbBpA5SQXJ
         GMaBMMmi0Aalp71NI78fm9cmBwwalj4xPOlkmfYte/mAgArodwEk1IQ2PMUv/ieeXbqD
         sHI2Xz5mXapGE7E2yjTie/8Ppgw6QPrH6kJ/xwPFrT1AJpfKQfkFoti660ZyDwnXdNWw
         agLiZdR0qMRFDwIIW6+vs4K8D76uIqsU0rr5ImMJwWYfvhXTkyxLF49I7mCMwdUZ/wNa
         sWDQ==
Content-Disposition: inline
In-Reply-To: <20190813132938.GJ17933@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Aug 13, 2019 at 03:29:38PM +0200, Michal Hocko wrote:
> On Mon 12-08-19 15:23:16, Johannes Weiner wrote:
> > One of our services observed a high rate of cgroup OOM kills in the
> > presence of large amounts of clean cache. Debugging showed that the
> > culprit is the shared cgroup iteration in page reclaim.
> > 
> > Under high allocation concurrency, multiple threads enter reclaim at
> > the same time. Fearing overreclaim when we first switched from the
> > single global LRU to cgrouped LRU lists, we introduced a shared
> > iteration state for reclaim invocations - whether 1 or 20 reclaimers
> > are active concurrently, we only walk the cgroup tree once: the 1st
> > reclaimer reclaims the first cgroup, the second the second one etc.
> > With more reclaimers than cgroups, we start another walk from the top.
> > 
> > This sounded reasonable at the time, but the problem is that reclaim
> > concurrency doesn't scale with allocation concurrency. As reclaim
> > concurrency increases, the amount of memory individual reclaimers get
> > to scan gets smaller and smaller. Individual reclaimers may only see
> > one cgroup per cycle, and that may not have much reclaimable
> > memory. We see individual reclaimers declare OOM when there is plenty
> > of reclaimable memory available in cgroups they didn't visit.
> > 
> > This patch does away with the shared iterator, and every reclaimer is
> > allowed to scan the full cgroup tree and see all of reclaimable
> > memory, just like it would on a non-cgrouped system. This way, when
> > OOM is declared, we know that the reclaimer actually had a chance.
> > 
> > To still maintain fairness in reclaim pressure, disallow cgroup
> > reclaim from bailing out of the tree walk early. Kswapd and regular
> > direct reclaim already don't bail, so it's not clear why limit reclaim
> > would have to, especially since it only walks subtrees to begin with.
> 
> The code does bail out on any direct reclaim - be it limit or page
> allocator triggered. Check the !current_is_kswapd part of the condition.

Ah you're right. In practice I doubt it makes much of a difference,
though, because...

> > This change completely eliminates the OOM kills on our service, while
> > showing no signs of overreclaim - no increased scan rates, %sys time,
> > or abrupt free memory spikes. I tested across 100 machines that have
> > 64G of RAM and host about 300 cgroups each.
> 
> What is the usual direct reclaim involvement on those machines?

80-200 kb/s. In general we try to keep this low to non-existent on our
hosts due to the latency implications. So it's fair to say that kswapd
does page reclaim, and direct reclaim is a sign of overload.

> That being said, I do agree that the oom side of the coin is causing
> real troubles and it is a real problem to be addressed first. Especially with
> cgroup v2 where we have likely more memcgs without any pages because
> inner nodes do not have any tasks and direct charges which makes some
> reclaimers hit memcgs without pages more likely.
> 
> Let's see whether we see regression due to over-reclaim. 
> 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> With the direct reclaim bail out reference fixed - unless I am wrong
> there of course
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks! I'll send an updated changelog.

> It is sad to see this piece of fun not being used after that many years
> of bugs here and there and all the lockless fun but this is the life

Haha, agreed.
