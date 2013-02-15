From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/7] vmscan: also shrink slab in memcg pressure
Date: Fri, 15 Feb 2013 14:30:14 +0400
Message-ID: <511E0E36.3060206@parallels.com>
References: <1360328857-28070-1-git-send-email-glommer@parallels.com> <1360328857-28070-2-git-send-email-glommer@parallels.com> <511DF3CB.7020206@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511DF3CB.7020206-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Shrinnker <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

>> @@ -45,6 +48,7 @@ struct shrinker {
>>   
>>   	int seeks;	/* seeks to recreate an obj */
>>   	long batch;	/* reclaim batch size, 0 = default */
>> +	bool memcg_shrinker;
>>   
> 
> What is this boolean for ? When is this set ?
It is set when a subsystem declares that its shrinker is memcg capable.
Therefore, it won't be done until all infrastructure is in place. Take a
look at the super.c patches at the end of the series.


>>   static bool global_reclaim(struct scan_control *sc)
>>   {
>>   	return true;
>>   }
>> +
>> +static bool has_kmem_reclaim(struct scan_control *sc)
>> +{
>> +	return true;
>> +}
>> +
>> +static unsigned long
>> +zone_nr_reclaimable_pages(struct scan_control *sc, struct zone *zone)
>> +{
>> +	return zone_reclaimable_pages(zone);
>> +}
>>   #endif
> 
> Can't be in a devided patch ?
> 
if you prefer this way, sure, I can separate it.

>>   static unsigned long get_lru_size(struct lruvec *lruvec, enum lru_list lru)
>> @@ -221,6 +252,9 @@ unsigned long shrink_slab(struct shrink_control *sc,
>>   		long batch_size = shrinker->batch ? shrinker->batch
>>   						  : SHRINK_BATCH;
>>   
>> +		if (!shrinker->memcg_shrinker && sc->target_mem_cgroup)
>> +			continue;
>> +
> 
> What does this mean ?

It means that if target_mem_cgroup is set, we should skip all the
shrinkers that are not memcg capable. Maybe if I invert the order it
will be clearer?
