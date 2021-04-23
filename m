From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH-next v5 2/4] mm/memcg: Cache vmstat data in percpu
 memcg_stock_pcp
Date: Fri, 23 Apr 2021 12:52:29 -0400
Message-ID: <6a261f7f-a127-a757-9f4c-4231823911c1@redhat.com>
References: <20210420192907.30880-1-longman@redhat.com>
 <20210420192907.30880-3-longman@redhat.com>
 <YIC1HEKF8SQQdnxa@carbon.dhcp.thefacebook.com>
 <ded96eba-8c0c-1822-61b5-de0577b7ebab@redhat.com> <YIIpSvs09GhDN+gb@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619196753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=enManHEzv32cqVRF46CePltyDkAaNIcE1LHVBh9NKfk=;
        b=cN95ag1KU0DekGdbbouEnDyAhDBvvOIABqLS21gxxEMiaTHuUUq3xzZCBJ4qVjZtFPzKtV
        NWErz/HO7IP+Pzy3lS+ZEnag24hmps3Y18JAWdeAyXgZLJ94XAvCp4rEdEhiN14HBnLVEc
        fFP0sN5ZL0BPG4bAvv7PkOpf4zMXR+w=
In-Reply-To: <YIIpSvs09GhDN+gb@carbon>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro@fb.com>, Waiman Long <llong@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Masayoshi Mizuma <msys.mizuma@gmail.com>, Xing Zhengjun <zhengjun.xing@linux.intel.com>

On 4/22/21 9:56 PM, Roman Gushchin wrote:
> On Thu, Apr 22, 2021 at 12:58:52PM -0400, Waiman Long wrote:
>> On 4/21/21 7:28 PM, Roman Gushchin wrote:
>>> On Tue, Apr 20, 2021 at 03:29:05PM -0400, Waiman Long wrote:
>>>> Before the new slab memory controller with per object byte charging,
>>>> charging and vmstat data update happen only when new slab pages are
>>>> allocated or freed. Now they are done with every kmem_cache_alloc()
>>>> and kmem_cache_free(). This causes additional overhead for workloads
>>>> that generate a lot of alloc and free calls.
>>>>
>>>> The memcg_stock_pcp is used to cache byte charge for a specific
>>>> obj_cgroup to reduce that overhead. To further reducing it, this patch
>>>> makes the vmstat data cached in the memcg_stock_pcp structure as well
>>>> until it accumulates a page size worth of update or when other cached
>>>> data change. Caching the vmstat data in the per-cpu stock eliminates two
>>>> writes to non-hot cachelines for memcg specific as well as memcg-lruvecs
>>>> specific vmstat data by a write to a hot local stock cacheline.
>>>>
>>>> On a 2-socket Cascade Lake server with instrumentation enabled and this
>>>> patch applied, it was found that about 20% (634400 out of 3243830)
>>>> of the time when mod_objcg_state() is called leads to an actual call
>>>> to __mod_objcg_state() after initial boot. When doing parallel kernel
>>>> build, the figure was about 17% (24329265 out of 142512465). So caching
>>>> the vmstat data reduces the number of calls to __mod_objcg_state()
>>>> by more than 80%.
>>>>
>>>> Signed-off-by: Waiman Long <longman@redhat.com>
>>>> Reviewed-by: Shakeel Butt <shakeelb@google.com>
>>>> ---
>>>>    mm/memcontrol.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++--
>>>>    1 file changed, 83 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index 7cd7187a017c..292b4783b1a7 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -782,8 +782,9 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
>>>>    	rcu_read_unlock();
>>>>    }
>>>> -void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>>>> -		     enum node_stat_item idx, int nr)
>>>> +static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
>>>> +				     struct pglist_data *pgdat,
>>>> +				     enum node_stat_item idx, int nr)
>>>>    {
>>>>    	struct mem_cgroup *memcg;
>>>>    	struct lruvec *lruvec;
>>>> @@ -791,7 +792,7 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>>>>    	rcu_read_lock();
>>>>    	memcg = obj_cgroup_memcg(objcg);
>>>>    	lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>> -	mod_memcg_lruvec_state(lruvec, idx, nr);
>>>> +	__mod_memcg_lruvec_state(lruvec, idx, nr);
>>>>    	rcu_read_unlock();
>>>>    }
>>>> @@ -2059,7 +2060,10 @@ struct memcg_stock_pcp {
>>>>    #ifdef CONFIG_MEMCG_KMEM
>>>>    	struct obj_cgroup *cached_objcg;
>>>> +	struct pglist_data *cached_pgdat;
>>> I wonder if we want to have per-node counters instead?
>>> That would complicate the initialization of pcp stocks a bit,
>>> but might shave off some additional cpu time.
>>> But we can do it later too.
>>>
>> A per node counter will certainly complicate the code and reduce the
>> performance benefit too.
> Hm, why? We wouldn't need to flush the stock if the release happens
> on some other cpu not matching the current pgdat.

I had actually experimented with just caching vmstat data for the local 
node only. It turned out the hit rate was a bit lower. That is why I 
keep the current approach and I need to do further investigation on a 
better approach.

Cheers,
Longman


