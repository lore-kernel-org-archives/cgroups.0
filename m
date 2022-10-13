From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: use mem_cgroup_is_root() helper
Date: Thu, 13 Oct 2022 12:14:10 +0530
Message-ID: <4ed23d48-6c83-d703-57a4-24cf9cc34eb9@oracle.com>
References: <20220930134433.338103-1-kamalesh.babulal@oracle.com>
 <YzqWJ8D1rabeZ6TL@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=b85Bu+3p4+PkQd29v4zkvox2djnPtcsaA5vvIwcI/F4=;
 b=JRFHQXVSKVi25aJXOdqCaHLsWS3jl6WsjIcYGixBHDHch2zgYiRMPaHAcBCt8JJRY9Vs
 8953Rr/q1gci+pG1MfDJWiehxOF5tAp2/327oQtf9rZS5CA5r+tDdOPglgY+SBpnYFVK
 RcfVOXPPz17EcchZey/ztJko3HGCBeQwNvhvSmjntgXksTiTD9fefi868Bn+fllgO6ZE
 tq2oKEUGc6E3P15mnf4x+k5yGVMOfq9GJRckrQqzpKXz7PussFfnPYXZF3HViMccInd3
 aW03rjdOK9XhAend8Gg3kvpOsvIsV6k9U2YVQraHnd80e5bby04hN+8ucso4FGzHV03D Gw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b85Bu+3p4+PkQd29v4zkvox2djnPtcsaA5vvIwcI/F4=;
 b=JQyFymcuUuFe/ggTl8wS9Cbs3zPurKMOygBqpjHIqHfmpXISY8tXZ54aJ+WPv2LVlDFTpI1lq+LpI5eTZHorqHBNCGqR8DQaOz0s1HHIBbS7iZhGL1OIXmDHIgsMUXCa1v5dzKGi706sXIVMKU7Gs1b2r2iv4R92+FwIDEMWStE=
Content-Language: en-US
In-Reply-To: <YzqWJ8D1rabeZ6TL-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

+cc: Andrew Morton
Sorry, had missed akpm in the original patch.

On 10/3/22 13:28, Michal Hocko wrote:
> On Fri 30-09-22 19:14:33, Kamalesh Babulal wrote:
>> Replace the checks for memcg is root memcg, with mem_cgroup_is_root()
>> helper.
>>
>> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Thanks!
> 

Michal Hocko/Muchun Song,

Thank you so much for the review.

>> ---
>>  mm/memcontrol.c | 20 ++++++++++----------
>>  1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index b69979c9ced5..99b3d0cbd426 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1148,7 +1148,7 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
>>  	 * cgroup root (root_mem_cgroup). So we have to handle
>>  	 * dead_memcg from cgroup root separately.
>>  	 */
>> -	if (last != root_mem_cgroup)
>> +	if (!mem_cgroup_is_root(last))
>>  		__invalidate_reclaim_iterators(root_mem_cgroup,
>>  						dead_memcg);
>>  }
>> @@ -1172,7 +1172,7 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>>  	struct mem_cgroup *iter;
>>  	int ret = 0;
>>  
>> -	BUG_ON(memcg == root_mem_cgroup);
>> +	BUG_ON(mem_cgroup_is_root(memcg));
>>  
>>  	for_each_mem_cgroup_tree(iter, memcg) {
>>  		struct css_task_iter it;
>> @@ -1201,7 +1201,7 @@ void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
>>  	memcg = folio_memcg(folio);
>>  
>>  	if (!memcg)
>> -		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != root_mem_cgroup, folio);
>> +		VM_BUG_ON_FOLIO(!mem_cgroup_is_root(lruvec_memcg(lruvec)), folio);
>>  	else
>>  		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != memcg, folio);
>>  }
>> @@ -1982,7 +1982,7 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
>>  	rcu_read_lock();
>>  
>>  	memcg = mem_cgroup_from_task(victim);
>> -	if (memcg == root_mem_cgroup)
>> +	if (mem_cgroup_is_root(memcg))
>>  		goto out;
>>  
>>  	/*
>> @@ -2940,7 +2940,7 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
>>  {
>>  	struct obj_cgroup *objcg = NULL;
>>  
>> -	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
>> +	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
>>  		objcg = rcu_dereference(memcg->objcg);
>>  		if (objcg && obj_cgroup_tryget(objcg))
>>  			break;
>> @@ -7073,7 +7073,7 @@ void mem_cgroup_sk_alloc(struct sock *sk)
>>  
>>  	rcu_read_lock();
>>  	memcg = mem_cgroup_from_task(current);
>> -	if (memcg == root_mem_cgroup)
>> +	if (mem_cgroup_is_root(memcg))
>>  		goto out;
>>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
>>  		goto out;
>> @@ -7208,7 +7208,7 @@ static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
>>  		 * The root cgroup cannot be destroyed, so it's refcount must
>>  		 * always be >= 1.
>>  		 */
>> -		if (WARN_ON_ONCE(memcg == root_mem_cgroup)) {
>> +		if (WARN_ON_ONCE(mem_cgroup_is_root(memcg))) {
>>  			VM_BUG_ON(1);
>>  			break;
>>  		}
>> @@ -7369,7 +7369,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>>  
>>  	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>  		return nr_swap_pages;
>> -	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
>> +	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
>>  		nr_swap_pages = min_t(long, nr_swap_pages,
>>  				      READ_ONCE(memcg->swap.max) -
>>  				      page_counter_read(&memcg->swap));
>> @@ -7391,7 +7391,7 @@ bool mem_cgroup_swap_full(struct page *page)
>>  	if (!memcg)
>>  		return false;
>>  
>> -	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
>> +	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
>>  		unsigned long usage = page_counter_read(&memcg->swap);
>>  
>>  		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
>> @@ -7556,7 +7556,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
>>  		return true;
>>  
>>  	original_memcg = get_mem_cgroup_from_objcg(objcg);
>> -	for (memcg = original_memcg; memcg != root_mem_cgroup;
>> +	for (memcg = original_memcg; !mem_cgroup_is_root(memcg);
>>  	     memcg = parent_mem_cgroup(memcg)) {
>>  		unsigned long max = READ_ONCE(memcg->zswap_max);
>>  		unsigned long pages;
>>
>> base-commit: 987a926c1d8a40e4256953b04771fbdb63bc7938
>> -- 
>> 2.34.3
> 

-- 
Thanks,
Kamalesh
