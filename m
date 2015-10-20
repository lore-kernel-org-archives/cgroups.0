From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: vmscan: count slab shrinking results after each
 shrink_slab()
Date: Tue, 20 Oct 2015 09:56:06 -0400
Message-ID: <20151020135606.GB22383@cmpxchg.org>
References: <1445278415-21138-1-git-send-email-hannes@cmpxchg.org>
 <20151020121920.GE18351@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151020121920.GE18351@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Oct 20, 2015 at 03:19:20PM +0300, Vladimir Davydov wrote:
> On Mon, Oct 19, 2015 at 02:13:35PM -0400, Johannes Weiner wrote:
> > cb731d6 ("vmscan: per memory cgroup slab shrinkers") sought to
> > optimize accumulating slab reclaim results in sc->nr_reclaimed only
> > once per zone, but the memcg hierarchy walk itself uses
> > sc->nr_reclaimed as an exit condition. This can lead to overreclaim.
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > ---
> >  mm/vmscan.c | 19 ++++++++++++++-----
> >  1 file changed, 14 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 27d580b..a02654e 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2441,11 +2441,18 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
> >  			shrink_lruvec(lruvec, swappiness, sc, &lru_pages);
> >  			zone_lru_pages += lru_pages;
> >  
> > -			if (memcg && is_classzone)
> > +			if (memcg && is_classzone) {
> >  				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
> >  					    memcg, sc->nr_scanned - scanned,
> >  					    lru_pages);
> >  
> > +				if (reclaim_state) {
> 
> current->reclaim_state is only set on global reclaim, so when performing
> memcg reclaim we'll never get here. Hence, since we check nr_reclaimed
> in the loop only on memcg reclaim, this patch doesn't change anything.
> 
> Setting current->reclaim_state on memcg reclaim doesn't seem to be an
> option, because it accounts objects freed by any cgroup (e.g. via RCU
> callback) - see https://lkml.org/lkml/2015/1/20/91

Ah, I was not aware of that. Thanks for clarifying. Scratch this patch
then.

Do you think it would make sense to take the shrink_slab() return
value into account? Or are most objects expected to be RCU-freed
anyway so it wouldn't make a difference?

> About overreclaim that might happen due to the current behavior. Inodes
> and dentries are small and usually freed by RCU so not accounting them
> to nr_reclaimed shouldn't make much difference. The only reason I see
> why overreclaim can happen is ignoring eviction of an inode full of page
> cache, speaking of which makes me wonder if it'd be better to refrain
> from dropping inodes which have page cache left, at least unless the
> scan priority is low?

Unless we have evidence that it drops cache pages prematurely, I think
it should be okay to leave it as is.
