From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v10 28/35] list_lru: per-memcg walks
Date: Thu, 6 Jun 2013 12:37:26 +0400
Message-ID: <51B04A46.3010204@parallels.com>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org> <1370287804-3481-29-git-send-email-glommer@openvz.org> <20130605160837.0d0a35fbd4b32d7ad02f7136@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130605160837.0d0a35fbd4b32d7ad02f7136-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

>>  	/*
>> -	 * The array exist, but the particular memcg does not. That is an
>> -	 * impossible situation: it would mean we are trying to add to a list
>> -	 * belonging to a memcg that does not exist. Either wasn't created or
>> -	 * has been already freed. In both cases it should no longer have
>> -	 * objects. BUG_ON to avoid a NULL dereference.
>> +	 * The array exist, but the particular memcg does not. This cannot
>> +	 * happen when we are called from memcg_kmem_lru_of_page with a
>> +	 * definite memcg, but it can happen when we are iterating over all
>> +	 * memcgs (for instance, when disposing all lists.
>>  	 */
>> -	BUG_ON(!lru->memcg_lrus[index]);
>> +	if (!lru->memcg_lrus[index]) {
>> +		rcu_read_unlock();
>> +		return NULL;
>> +	}
> 
> It took 28 patches, but my head is now spinning and my vision is fading
> in and out.
> 
You're a hero.

>>  	nlru = &lru->memcg_lrus[index]->node[nid];
>>  	rcu_read_unlock();
>>  	return nlru;
>> @@ -80,6 +83,23 @@ memcg_kmem_lru_of_page(struct list_lru *lru, struct page *page)
>>  	return lru_node_of_index(lru, memcg_id, nid);
>>  }
>>  
>> +/*
>> + * This helper will loop through all node-data in the LRU, either global or
>> + * per-memcg.  If memcg is either not present or not used,
>> + * memcg_limited_groups_array_size will be 0. _idx starts at -1, and it will
>> + * still be allowed to execute once.
>> + *
>> + * We convention that for _idx = -1, the global node info should be used.
> 
> I don't think that "convention" is a verb, but I rather like the way
> it is used here.
> 
We can convention to do it this way from now on.

>> + * After that, we will go through each of the memcgs, starting at 0.
>> + *
>> + * We don't need any kind of locking for the loop because
>> + * memcg_limited_groups_array_size can only grow, gaining new fields at the
>> + * end. The old ones are just copied, and any interesting manipulation happen
>> + * in the node list itself, and we already lock the list.
> 
> Might be worth mentioning what type _idx should have.  Although I suspect
> the code will work OK if _idx has unsigned type.
> 

We convention -1 to be "no memcg", so it has to be an int.

>> + */
>> +#define for_each_memcg_lru_index(_idx)	\
>> +	for ((_idx) = -1; ((_idx) < memcg_limited_groups_array_size); (_idx)++)
>> +
>>  int
>>  list_lru_add(
>>  	struct list_lru	*lru,
>> @@ -139,10 +159,19 @@ list_lru_del(
>>  EXPORT_SYMBOL_GPL(list_lru_del);
>>  
>>  
>>  unsigned long
>> -list_lru_walk_node(
>> +list_lru_walk_node_memcg(
>>  	struct list_lru		*lru,
>>  	int			nid,
>>  	list_lru_walk_cb	isolate,
>>  	void			*cb_arg,
>> -	unsigned long		*nr_to_walk)
>> +	unsigned long		*nr_to_walk,
>> +	struct mem_cgroup	*memcg)
>>  {
>> -	struct list_lru_node	*nlru = &lru->node[nid];
>>  	struct list_head *item, *n;
>>  	unsigned long isolated = 0;
>> +	struct list_lru_node *nlru;
>> +	int memcg_id = -1;
>> +
>> +	if (memcg && memcg_kmem_is_active(memcg))
>> +		memcg_id = memcg_cache_id(memcg);
> 
> Could use a helper function for this I guess.  The nice thing about
> this is that it gives one a logical place at which to describe what's
> going on.
> 
Ok.
