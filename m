From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm] slab: fix cpuset check in fallback_alloc
Date: Mon, 11 Aug 2014 11:13:15 +0400
Message-ID: <20140811071315.GA18709@esperanza>
References: <1407692891-24312-1-git-send-email-vdavydov@parallels.com>
 <alpine.DEB.2.02.1408101512500.706@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408101512500.706-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Sun, Aug 10, 2014 at 03:43:21PM -0700, David Rientjes wrote:
> On Sun, 10 Aug 2014, Vladimir Davydov wrote:
> 
> > fallback_alloc is called on kmalloc if the preferred node doesn't have
> > free or partial slabs and there's no pages on the node's free list
> > (GFP_THISNODE allocations fail). Before invoking the reclaimer it tries
> > to locate a free or partial slab on other allowed nodes' lists. While
> > iterating over the preferred node's zonelist it skips those zones which
> > cpuset_zone_allowed_hardwall returns false for. That means that for a
> > task bound to a specific node using cpusets fallback_alloc will always
> > ignore free slabs on other nodes and go directly to the reclaimer,
> > which, however, may allocate from other nodes if cpuset.mem_hardwall is
> > unset (default). As a result, we may get lists of free slabs grow
> > without bounds on other nodes, which is bad, because inactive slabs are
> > only evicted by cache_reap at a very slow rate and cannot be dropped
> > forcefully.
> > 
> > To reproduce the issue, run a process that will walk over a directory
> > tree with lots of files inside a cpuset bound to a node that constantly
> > experiences memory pressure. Look at num_slabs vs active_slabs growth as
> > reported by /proc/slabinfo.
> > 
> > We should use cpuset_zone_allowed_softwall in fallback_alloc. Since it
> > can sleep, we only call it on __GFP_WAIT allocations. For atomic
> > allocations we simply ignore cpusets, which is in agreement with the
> > cpuset documenation (see the comment to __cpuset_node_allowed_softwall).
> > 
> 
> If that rule were ever changed, nobody would think to modify the 
> fallback_alloc() behavior in the slab allocator.  Why can't 
> cpuset_zone_allowed_hardwall() just return 1 for !__GFP_WAIT?
> 
> I don't think this issue is restricted only to slab, it's for all callers 
> of cpuset_zone_allowed_softwall() that could possibly be atomic.  I think 
> it would be better to determine if cpuset_zone_allowed() should be 
> hardwall or softwall depending on the gfp flags.
> 
> Let's add Li, the cpuset maintainer.  Any reason we can't do this?
> ---
[...]
> diff --git a/mm/slab.c b/mm/slab.c
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3047,16 +3047,19 @@ retry:
>  	 * from existing per node queues.
>  	 */
>  	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
> -		nid = zone_to_nid(zone);
> +		struct kmem_cache_node *n;
>  
> -		if (cpuset_zone_allowed_hardwall(zone, flags) &&
> -			get_node(cache, nid) &&
> -			get_node(cache, nid)->free_objects) {
> -				obj = ____cache_alloc_node(cache,
> -					flags | GFP_THISNODE, nid);
> -				if (obj)
> -					break;
> -		}
> +		nid = zone_to_nid(zone);
> +		if (!cpuset_zone_allowed(zone, flags | __GFP_HARDWALL))

We must use softwall check here, otherwise we will proceed to
alloc_pages even if there are lots of free slabs on other nodes.
alloc_pages, in turn, may allocate from other nodes in case
cpuset.mem_hardwall=0, because it uses softwall check, so it may add yet
another free slab to another node's list even if it isn't empty. As a
result, we may get free list bloating on other nodes. I've seen a
machine with one of its nodes almost completely filled with inactive
slabs for buffer_heads (dozens of GBs) w/o any chance to drop them. So,
this is a bug that must be fixed.

Note, for SLUB using hardwall check in get_any_partial won't lead to
such a problem, because once added a new slab is loaded to a per cpu
list forcing any further user to allocate from it. Strictly speaking, we
should use softwall check there either though.

> +			continue;
> +		n = get_node(cache, nid);
> +		if (!n)
> +			continue;
> +		if (!n->free_objects)
> +			continue;
> +		obj = ____cache_alloc_node(cache, flags | GFP_THISNODE, nid);
> +		if (obj)
> +			break;
>  	}
>  
>  	if (!obj) {
> diff --git a/mm/slub.c b/mm/slub.c
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1671,20 +1671,22 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
>  			struct kmem_cache_node *n;
>  
>  			n = get_node(s, zone_to_nid(zone));
> +			if (!n)
> +				continue;
> +			if (!cpuset_zone_allowed(zone, flags | __GFP_HARDWALL))
> +				continue;
> +			if (n->nr_parial <= s->min_partial)
> +				continue;
>  
> -			if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
> -					n->nr_partial > s->min_partial) {
> -				object = get_partial_node(s, n, c, flags);
> -				if (object) {
> -					/*
> -					 * Don't check read_mems_allowed_retry()
> -					 * here - if mems_allowed was updated in
> -					 * parallel, that was a harmless race
> -					 * between allocation and the cpuset
> -					 * update
> -					 */
> -					return object;
> -				}
> +			object = get_partial_node(s, n, c, flags);
> +			if (object) {
> +				/*
> +				 * Don't check read_mems_allowed_retry() here -
> +				 * if mems_allowed was updated in parallel,
> +				 * that was a harmless race between allocation
> +				 * and the cpuset update.
> +				 */
> +				return object;
>  			}
>  		}
>  	} while (read_mems_allowed_retry(cpuset_mems_cookie));
[...]
