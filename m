From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcontrol: default hierarchy interface for
 memory
Date: Wed, 14 Jan 2015 12:19:44 -0500
Message-ID: <20150114171944.GB32040__41625.7064360709$1421256003$gmane$org@phnom.home.cmpxchg.org>
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
 <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
 <20150114153425.GF4706@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150114153425.GF4706-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 14, 2015 at 04:34:25PM +0100, Michal Hocko wrote:
> On Thu 08-01-15 23:15:04, Johannes Weiner wrote:
> [...]
> > @@ -2353,6 +2353,22 @@ done_restock:
> >  	css_get_many(&memcg->css, batch);
> >  	if (batch > nr_pages)
> >  		refill_stock(memcg, batch - nr_pages);
> > +	/*
> > +	 * If the hierarchy is above the normal consumption range,
> > +	 * make the charging task trim the excess.
> > +	 */
> > +	do {
> > +		unsigned long nr_pages = page_counter_read(&memcg->memory);
> > +		unsigned long high = ACCESS_ONCE(memcg->high);
> > +
> > +		if (nr_pages > high) {
> > +			mem_cgroup_events(memcg, MEMCG_HIGH, 1);
> > +
> > +			try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> > +						     gfp_mask, true);
> > +		}
> 
> As I've said before I am not happy about this. Heavy parallel load
> hitting on the limit can generate really high reclaim targets causing
> over reclaim and long stalls. Moreover portions of the excess would be
> reclaimed multiple times which is not necessary.
>
> I am not entirely happy about reclaiming nr_pages for THP_PAGES already
> and this might be much worse, more probable and less predictable.
> 
> I believe the target should be capped somehow. nr_pages sounds like a
> compromise. It would still throttle the charger and scale much better.

That's fair enough, I'll experiment with this.

> > +static int memory_events_show(struct seq_file *m, void *v)
> > +{
> > +	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
> > +
> > +	seq_printf(m, "low %lu\n", mem_cgroup_read_events(memcg, MEMCG_LOW));
> > +	seq_printf(m, "high %lu\n", mem_cgroup_read_events(memcg, MEMCG_HIGH));
> > +	seq_printf(m, "max %lu\n", mem_cgroup_read_events(memcg, MEMCG_MAX));
> > +	seq_printf(m, "oom %lu\n", mem_cgroup_read_events(memcg, MEMCG_OOM));
> > +
> > +	return 0;
> > +}
> 
> OK, but I really think we need a way of OOM notification for user space
> OOM handling as well - including blocking the OOM killer as we have
> now.  This is not directly related to this patch so it doesn't have to
> happen right now, we should just think about the proper interface if
> oom_control is consider not suitable.

Yes, I think OOM control should be a separate discussion.

> > @@ -2322,6 +2325,12 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
> >  			struct lruvec *lruvec;
> >  			int swappiness;
> >  
> > +			if (mem_cgroup_low(root, memcg)) {
> > +				if (!sc->may_thrash)
> > +					continue;
> > +				mem_cgroup_events(memcg, MEMCG_LOW, 1);
> > +			}
> > +
> >  			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
> >  			swappiness = mem_cgroup_swappiness(memcg);
> >  
> > @@ -2343,8 +2352,7 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
> >  				mem_cgroup_iter_break(root, memcg);
> >  				break;
> >  			}
> > -			memcg = mem_cgroup_iter(root, memcg, &reclaim);
> > -		} while (memcg);
> > +		} while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));
> 
> I had a similar code but then I could trigger quick priority drop downs
> during parallel reclaim with multiple low limited groups. I've tried to
> address that by retrying shrink_zone if it hasn't called shrink_lruvec
> at all. Still not ideal because it can livelock theoretically, but I
> haven't seen that in my testing.

Do you remember the circumstances and the exact configuration?

I tested this with around 30 containerized kernel build jobs whose low
boundaries pretty much added up to the available physical memory and
never observed this.  That being said, thrashing is an emergency path
and users should really watch the memory.events low counter.  After
all, if global reclaim frequently has to ignore the reserve settings,
what's the point of having them in the first place?

So while I see that this might burn some cpu cycles when the system is
misconfigured, and that we could definitely be smarter about this, I'm
not convinced we have to rush a workaround before moving ahead with
this patch, especially not one that is prone to livelock the system.

> Other than that the patch looks OK and I am happy this has moved
> forward finally.

Thanks! I'm glad we're getting somewhere as well.
