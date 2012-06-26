From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 10/11] memcg: allow a memcg with kmem charges to be destructed.
Date: Tue, 26 Jun 2012 11:21:22 +0400
Message-ID: <4FE962F2.2050701@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-11-git-send-email-glommer@parallels.com> <4FE94FDC.7070105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FE94FDC.7070105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 06/26/2012 09:59 AM, Kamezawa Hiroyuki wrote:
> (2012/06/25 23:15), Glauber Costa wrote:
>> Because the ultimate goal of the kmem tracking in memcg is to
>> track slab pages as well, we can't guarantee that we'll always
>> be able to point a page to a particular process, and migrate
>> the charges along with it - since in the common case, a page
>> will contain data belonging to multiple processes.
>>
>> Because of that, when we destroy a memcg, we only make sure
>> the destruction will succeed by discounting the kmem charges
>> from the user charges when we try to empty the cgroup.
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
>> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>>    mm/memcontrol.c |   10 +++++++++-
>>    1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index a6a440b..bb9b6fe 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -598,6 +598,11 @@ static void disarm_kmem_keys(struct mem_cgroup *memcg)
>>    {
>>    	if (test_bit(KMEM_ACCOUNTED_THIS, &memcg->kmem_accounted))
>>    		static_key_slow_dec(&mem_cgroup_kmem_enabled_key);
>> +	/*
>> +	 * This check can't live in kmem destruction function,
>> +	 * since the charges will outlive the cgroup
>> +	 */
>> +	BUG_ON(res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0);
>>    }
>>    #else
>>    static void disarm_kmem_keys(struct mem_cgroup *memcg)
>> @@ -3838,6 +3843,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg, bool free_all)
>>    	int node, zid, shrink;
>>    	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>>    	struct cgroup *cgrp = memcg->css.cgroup;
>> +	u64 usage;
>>    
>>    	css_get(&memcg->css);
>>    
>> @@ -3877,8 +3883,10 @@ move_account:
>>    		if (ret == -ENOMEM)
>>    			goto try_to_free;
>>    		cond_resched();
>> +		usage = res_counter_read_u64(&memcg->res, RES_USAGE) -
>> +			res_counter_read_u64(&memcg->kmem, RES_USAGE);
>>    	/* "ret" should also be checked to ensure all lists are empty. */
>> -	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
>> +	} while (usage > 0 || ret);
>>    out:
>>    	css_put(&memcg->css);
>>    	return ret;
>>
> Hm....maybe work enough. Could you add more comments on the code ?
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> 

I always can.

