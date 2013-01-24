From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: reduce the size of struct memcg 244-fold.
Date: Thu, 24 Jan 2013 10:28:21 +0400
Message-ID: <5100D485.4020302@parallels.com>
References: <1358962426-8738-1-git-send-email-glommer@parallels.com> <20130123161810.73e4ca58.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130123161810.73e4ca58.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


>>  	struct mem_cgroup *memcg;
>> -	int size = sizeof(struct mem_cgroup);
>> +	int size = memcg_size();
>>  
>> -	/* Can be very big if MAX_NUMNODES is very big */
>> +	/* Can be very big if nr_node_ids is very big */
>>  	if (size < PAGE_SIZE)
>>  		memcg = kzalloc(size, GFP_KERNEL);
>>  	else
>> @@ -5933,7 +5943,7 @@ out_free:
>>  static void __mem_cgroup_free(struct mem_cgroup *memcg)
>>  {
>>  	int node;
>> -	int size = sizeof(struct mem_cgroup);
>> +	int size = memcg_size();
>>  
>>  	mem_cgroup_remove_from_trees(memcg);
>>  	free_css_id(&mem_cgroup_subsys, &memcg->css);
> 
> Really everything here should be using size_t - a minor
> cosmetic/readability thing.
> 
I agree
