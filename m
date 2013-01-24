From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2] memcg: reduce the size of struct memcg 244-fold.
Date: Thu, 24 Jan 2013 15:51:05 -0800
Message-ID: <20130124155105.85dae9d9.akpm@linux-foundation.org>
References: <1359009996-5350-1-git-send-email-glommer@parallels.com>
	<xr93r4lbrpdk.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr93r4lbrpdk.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, 23 Jan 2013 23:50:31 -0800
Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -172,7 +172,7 @@ struct mem_cgroup_per_node {
> >  };
> >  
> >  struct mem_cgroup_lru_info {
> > -	struct mem_cgroup_per_node *nodeinfo[MAX_NUMNODES];
> > +	struct mem_cgroup_per_node *nodeinfo[0];
> 
> It seems like a VM_BUG_ON() in mem_cgroup_zoneinfo() asserting that the
> nid index is less than nr_node_ids would be good at catching illegal
> indexes.  I don't see any illegal indexes in your patch, but I fear that
> someday a MAX_NUMNODES based for() loop might sneak in.

Can't hurt ;)

> Tangential question: why use inline here?  I figure that modern
> compilers are good at making inlining decisions.

And that'll save some disk space.

This?

--- a/mm/memcontrol.c~memcg-reduce-the-size-of-struct-memcg-244-fold-fix
+++ a/mm/memcontrol.c
@@ -381,7 +381,7 @@ enum {
 		((1 << KMEM_ACCOUNTED_ACTIVE) | (1 << KMEM_ACCOUNTED_ACTIVATED))
 
 #ifdef CONFIG_MEMCG_KMEM
-static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
+static void memcg_kmem_set_active(struct mem_cgroup *memcg)
 {
 	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
@@ -645,6 +645,7 @@ static void drain_all_stock_async(struct
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *memcg, int nid, int zid)
 {
+	VM_BUG_ON((unsigned)nid >= nr_node_ids);
 	return &memcg->info.nodeinfo[nid]->zoneinfo[zid];
 }
 
_

Glauber, could you please cc me on patches more often?  It's a bit of a
pita having to go back to the mailing list to see if there has been
more dicussion and I may end up missing late review comments and acks.
