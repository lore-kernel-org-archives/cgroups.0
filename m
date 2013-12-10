From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v13 11/16] mm: list_lru: add per-memcg lists
Date: Tue, 10 Dec 2013 16:00:05 +1100
Message-ID: <20131210050005.GC31386@dastard>
References: <cover.1386571280.git.vdavydov@parallels.com>
 <0ca62dbfbf545edb22b86bd11c50e9017a3dc4db.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0ca62dbfbf545edb22b86bd11c50e9017a3dc4db.1386571280.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Mon, Dec 09, 2013 at 12:05:52PM +0400, Vladimir Davydov wrote:
> There are several FS shrinkers, including super_block::s_shrink, that
> keep reclaimable objects in the list_lru structure. That said, to turn
> them to memcg-aware shrinkers, it is enough to make list_lru per-memcg.
> 
> This patch does the trick. It adds an array of LRU lists to the list_lru
> structure, one for each kmem-active memcg, and dispatches every item
> addition or removal operation to the list corresponding to the memcg the
> item is accounted to.
> 
> Since we already pass a shrink_control object to count and walk list_lru
> functions to specify the NUMA node to scan, and the target memcg is held
> in this structure, there is no need in changing the list_lru interface.
> 
> The idea lying behind the patch as well as the initial implementation
> belong to Glauber Costa.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  include/linux/list_lru.h   |   44 +++++++-
>  include/linux/memcontrol.h |   13 +++
>  mm/list_lru.c              |  242 ++++++++++++++++++++++++++++++++++++++------
>  mm/memcontrol.c            |  158 ++++++++++++++++++++++++++++-
>  4 files changed, 416 insertions(+), 41 deletions(-)
> 
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index 34e57af..e8add3d 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -28,11 +28,47 @@ struct list_lru_node {
>  	long			nr_items;
>  } ____cacheline_aligned_in_smp;
>  
> +struct list_lru_one {
> +	struct list_lru_node *node;
> +	nodemask_t active_nodes;
> +};
> +
>  struct list_lru {
> -	struct list_lru_node	*node;
> -	nodemask_t		active_nodes;
> +	struct list_lru_one	global;
> +#ifdef CONFIG_MEMCG_KMEM
> +	/*
> +	 * In order to provide ability of scanning objects from different
> +	 * memory cgroups independently, we keep a separate LRU list for each
> +	 * kmem-active memcg in this array. The array is RCU-protected and
> +	 * indexed by memcg_cache_id().
> +	 */
> +	struct list_lru_one	**memcg;

OK, as far as I can tell, this is introducing a per-node, per-memcg
LRU lists. Is that correct?

If so, then that is not what Glauber and I originally intended for
memcg LRUs. per-node LRUs are expensive in terms of memory and cross
multiplying them by the number of memcgs in a system was not a good
use of memory.

According to Glauber, most memcgs are small and typically confined
to a single node or two by external means and therefore don't need the
scalability numa aware LRUs provide. Hence the idea was that the
memcg LRUs would just be a single LRU list, just like a non-numa
aware list_lru instantiation. IOWs, this is the structure that we
had decided on as the best compromise between memory usage,
complexity and memcg awareness:

	global list --- node 0 lru
			node 1 lru
			.....
			node nr_nodes lru
	memcg lists	memcg 0 lru
			memcg 1 lru
			.....
			memcg nr_memcgs lru

and the LRU code internally would select either a node or memcg LRU
to iterated based on the scan information coming in from the
shrinker. i.e.:


struct list_lru {
	struct list_lru_node	*node;
	nodemask_t		active_nodes;
#ifdef MEMCG
	struct list_lru_node	**memcg;
	....


>  bool list_lru_add(struct list_lru *lru, struct list_head *item)
>  {
> -	int nid = page_to_nid(virt_to_page(item));
> -	struct list_lru_node *nlru = &lru->node[nid];
> +	struct page *page = virt_to_page(item);
> +	int nid = page_to_nid(page);
> +	struct list_lru_one *olru = lru_of_page(lru, page);
> +	struct list_lru_node *nlru = &olru->node[nid];

Yeah, that's per-memcg, per-node dereferencing. And, FWIW, olru/nlru
are bad names - that's the convention typically used for "old <foo>"
and "new <foo>" pointers....

As it is, it shouldn't be necessary - lru_of_page() should just
return a struct list_lru_node....

> +int list_lru_init(struct list_lru *lru)
> +{
> +	int err;
> +
> +	err = list_lru_init_one(&lru->global);
> +	if (err)
> +		goto fail;
> +
> +	err = memcg_list_lru_init(lru);
> +	if (err)
> +		goto fail;
> +
> +	return 0;
> +fail:
> +	list_lru_destroy_one(&lru->global);
> +	lru->global.node = NULL; /* see list_lru_destroy() */
> +	return err;
> +}

I suspect we have users of list_lru that don't want memcg bits added
to them. Hence I think we want to leave list_lru_init() alone and
add a list_lru_init_memcg() variant that makes the LRU memcg aware.
i.e. if the shrinker is not going to be memcg aware, then we don't
want the LRU to be memcg aware, either....

>  EXPORT_SYMBOL_GPL(list_lru_init);
>  
>  void list_lru_destroy(struct list_lru *lru)
>  {
> -	kfree(lru->node);
> +	/*
> +	 * It is common throughout the kernel source tree to call the
> +	 * destructor on a zeroed out object that has not been initialized or
> +	 * whose initialization failed, because it greatly simplifies fail
> +	 * paths. Once the list_lru structure was implemented, its destructor
> +	 * consisted of the only call to kfree() and thus conformed to the
> +	 * rule, but as it growed, it became more complex so that calling
> +	 * destructor on an uninitialized object would be a bug. To preserve
> +	 * backward compatibility, we explicitly exit the destructor if the
> +	 * object seems to be uninitialized.
> +	 */

We don't need an essay here. somethign a simple as:

	/*
	 * We might be called after partial initialisation (e.g. due to
	 * ENOMEM error) so handle that appropriately.
	 */
> +	if (!lru->global.node)
> +		return;
> +
> +	list_lru_destroy_one(&lru->global);
> +	memcg_list_lru_destroy(lru);
>  }
>  EXPORT_SYMBOL_GPL(list_lru_destroy);
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +int list_lru_memcg_alloc(struct list_lru *lru, int memcg_id)
> +{
> +	int err;
> +	struct list_lru_one *olru;
> +
> +	olru = kmalloc(sizeof(*olru), GFP_KERNEL);
> +	if (!olru)
> +		return -ENOMEM;
> +
> +	err = list_lru_init_one(olru);
> +	if (err) {
> +		kfree(olru);
> +		return err;
> +	}
> +
> +	VM_BUG_ON(lru->memcg[memcg_id]);
> +	lru->memcg[memcg_id] = olru;
> +	return 0;
> +}
> +
> +void list_lru_memcg_free(struct list_lru *lru, int memcg_id)
> +{
> +	struct list_lru_one *olru;
> +
> +	olru = lru->memcg[memcg_id];
> +	if (olru) {
> +		list_lru_destroy_one(olru);
> +		kfree(olru);
> +		lru->memcg[memcg_id] = NULL;
> +	}
> +}
> +
> +int list_lru_grow_memcg(struct list_lru *lru, size_t new_array_size)
> +{
> +	int i;
> +	struct list_lru_one **memcg_lrus;
> +
> +	memcg_lrus = kcalloc(new_array_size, sizeof(*memcg_lrus), GFP_KERNEL);
> +	if (!memcg_lrus)
> +		return -ENOMEM;
> +
> +	if (lru->memcg) {
> +		for_each_memcg_cache_index(i) {
> +			if (lru->memcg[i])
> +				memcg_lrus[i] = lru->memcg[i];
> +		}
> +	}

Um, krealloc()?


> +/*
> + * This function allocates LRUs for a memcg in all list_lru structures. It is
> + * called under memcg_create_mutex when a new kmem-active memcg is added.
> + */
> +static int memcg_init_all_lrus(int new_memcg_id)
> +{
> +	int err = 0;
> +	int num_memcgs = new_memcg_id + 1;
> +	int grow = (num_memcgs > memcg_limited_groups_array_size);
> +	size_t new_array_size = memcg_caches_array_size(num_memcgs);
> +	struct list_lru *lru;
> +
> +	if (grow) {
> +		list_for_each_entry(lru, &all_memcg_lrus, list) {
> +			err = list_lru_grow_memcg(lru, new_array_size);
> +			if (err)
> +				goto out;
> +		}
> +	}
> +
> +	list_for_each_entry(lru, &all_memcg_lrus, list) {
> +		err = list_lru_memcg_alloc(lru, new_memcg_id);
> +		if (err) {
> +			__memcg_destroy_all_lrus(new_memcg_id);
> +			break;
> +		}
> +	}
> +out:
> +	if (grow) {
> +		synchronize_rcu();
> +		list_for_each_entry(lru, &all_memcg_lrus, list) {
> +			kfree(lru->memcg_old);
> +			lru->memcg_old = NULL;
> +		}
> +	}
> +	return err;
> +}

Urk. That won't scale very well.

> +
> +int memcg_list_lru_init(struct list_lru *lru)
> +{
> +	int err = 0;
> +	int i;
> +	struct mem_cgroup *memcg;
> +
> +	lru->memcg = NULL;
> +	lru->memcg_old = NULL;
> +
> +	mutex_lock(&memcg_create_mutex);
> +	if (!memcg_kmem_enabled())
> +		goto out_list_add;
> +
> +	lru->memcg = kcalloc(memcg_limited_groups_array_size,
> +			     sizeof(*lru->memcg), GFP_KERNEL);
> +	if (!lru->memcg) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	for_each_mem_cgroup(memcg) {
> +		int memcg_id;
> +
> +		memcg_id = memcg_cache_id(memcg);
> +		if (memcg_id < 0)
> +			continue;
> +
> +		err = list_lru_memcg_alloc(lru, memcg_id);
> +		if (err) {
> +			mem_cgroup_iter_break(NULL, memcg);
> +			goto out_free_lru_memcg;
> +		}
> +	}
> +out_list_add:
> +	list_add(&lru->list, &all_memcg_lrus);
> +out:
> +	mutex_unlock(&memcg_create_mutex);
> +	return err;
> +
> +out_free_lru_memcg:
> +	for (i = 0; i < memcg_limited_groups_array_size; i++)
> +		list_lru_memcg_free(lru, i);
> +	kfree(lru->memcg);
> +	goto out;
> +}

That will probably scale even worse. Think about what happens when we
try to mount a bunch of filesystems in parallel - they will now
serialise completely on this memcg_create_mutex instantiating memcg
lists inside list_lru_init().

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
