From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v4 4/5] mm/memcg: Save both reclaimable & unreclaimable
 bytes in object stock
Date: Tue, 20 Apr 2021 15:09:01 -0400
Message-ID: <73992e36-376f-b7d3-dde5-d287c7696e72@redhat.com>
References: <20210419000032.5432-1-longman@redhat.com>
 <20210419000032.5432-5-longman@redhat.com> <YH216/wnyEOcxATl@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618945752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ADqf//8Mzh80P94odXSMaff1QLcxK4pUkpeVBlMf/kw=;
        b=WysXm/9f0aeGVTfFbauL5BgspuGT3dyb44SkU/Mv1wQeJGVXCCNun1YQlJTsAtN11ZUh8I
        2vKkYGFbK/Wh1cF2h4L1HxP6+K4Hn5zn42WKmGAi7Yrw821EuEaySpCXVaLtXV2BNuUbxx
        5xN+yYAic52kMA63utfuD1n37mK64+k=
In-Reply-To: <YH216/wnyEOcxATl@cmpxchg.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Masayoshi Mizuma <msys.mizuma@gmail.com>, Xing Zhengjun <zhengjun.xing@linux.intel.com>, Matthew Wilcox <>

On 4/19/21 12:55 PM, Johannes Weiner wrote:
> On Sun, Apr 18, 2021 at 08:00:31PM -0400, Waiman Long wrote:
>> Currently, the object stock structure caches either reclaimable vmstat
>> bytes or unreclaimable vmstat bytes in its object stock structure. The
>> hit rate can be improved if both types of vmstat data can be cached
>> especially for single-node system.
>>
>> This patch supports the cacheing of both type of vmstat data, though
>> at the expense of a slightly increased complexity in the caching code.
>> For large object (>=3D PAGE_SIZE), vmstat array is done directly without
>> going through the stock caching step.
>>
>> On a 2-socket Cascade Lake server with instrumentation enabled, the
>> miss rates are shown in the table below.
>>
>>    Initial bootup:
>>
>>    Kernel       __mod_objcg_state    mod_objcg_state    %age
>>    ------       -----------------    ---------------    ----
>>    Before patch      634400              3243830        19.6%
>>    After patch       419810              3182424        13.2%
>>
>>    Parallel kernel build:
>>
>>    Kernel       __mod_objcg_state    mod_objcg_state    %age
>>    ------       -----------------    ---------------    ----
>>    Before patch      24329265           142512465       17.1%
>>    After patch       24051721           142445825       16.9%
>>
>> There was a decrease of miss rate after initial system bootup. However,
>> the miss rate for parallel kernel build remained about the same probably
>> because most of the touched kmemcache objects were reclaimable inodes
>> and dentries.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   mm/memcontrol.c | 79 +++++++++++++++++++++++++++++++------------------
>>   1 file changed, 51 insertions(+), 28 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index c13502eab282..a6dd18f6d8a8 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2212,8 +2212,8 @@ struct obj_stock {
>>   	struct obj_cgroup *cached_objcg;
>>   	struct pglist_data *cached_pgdat;
>>   	unsigned int nr_bytes;
>> -	int vmstat_idx;
>> -	int vmstat_bytes;
>> +	int reclaimable_bytes;		/* NR_SLAB_RECLAIMABLE_B */
>> +	int unreclaimable_bytes;	/* NR_SLAB_UNRECLAIMABLE_B */
> How about
>
> 	int nr_slab_reclaimable_b;
> 	int nr_slab_unreclaimable_b;
>
> so you don't need the comments?

Sure, will make the change.


>>   #else
>>   	int dummy[0];
>>   #endif
>> @@ -3217,40 +3217,56 @@ void mod_objcg_state(struct obj_cgroup *objcg, s=
truct pglist_data *pgdat,
>>   		     enum node_stat_item idx, int nr)
>>   {
>>   	unsigned long flags;
>> -	struct obj_stock *stock =3D get_obj_stock(&flags);
>> +	struct obj_stock *stock;
>> +	int *bytes, *alt_bytes, alt_idx;
>> +
>> +	/*
>> +	 * Directly update vmstat array for big object.
>> +	 */
>> +	if (unlikely(abs(nr) >=3D PAGE_SIZE))
>> +		goto update_vmstat;
> This looks like an optimization independent of the vmstat item split?
It may not be that helpful. I am going to take it out in the next version.
>
>> +	stock =3D get_obj_stock(&flags);
>> +	if (idx =3D=3D NR_SLAB_RECLAIMABLE_B) {
>> +		bytes =3D &stock->reclaimable_bytes;
>> +		alt_bytes =3D &stock->unreclaimable_bytes;
>> +		alt_idx =3D NR_SLAB_UNRECLAIMABLE_B;
>> +	} else {
>> +		bytes =3D &stock->unreclaimable_bytes;
>> +		alt_bytes =3D &stock->reclaimable_bytes;
>> +		alt_idx =3D NR_SLAB_RECLAIMABLE_B;
>> +	}
>>  =20
>>   	/*
>> -	 * Save vmstat data in stock and skip vmstat array update unless
>> -	 * accumulating over a page of vmstat data or when pgdat or idx
>> +	 * Try to save vmstat data in stock and skip vmstat array update
>> +	 * unless accumulating over a page of vmstat data or when pgdat
>>   	 * changes.
>>   	 */
>>   	if (stock->cached_objcg !=3D objcg) {
>>   		/* Output the current data as is */
>> -	} else if (!stock->vmstat_bytes) {
>> -		/* Save the current data */
>> -		stock->vmstat_bytes =3D nr;
>> -		stock->vmstat_idx =3D idx;
>> -		stock->cached_pgdat =3D pgdat;
>> -		nr =3D 0;
>> -	} else if ((stock->cached_pgdat !=3D pgdat) ||
>> -		   (stock->vmstat_idx !=3D idx)) {
>> -		/* Output the cached data & save the current data */
>> -		swap(nr, stock->vmstat_bytes);
>> -		swap(idx, stock->vmstat_idx);
>> +	} else if (stock->cached_pgdat !=3D pgdat) {
>> +		/* Save the current data and output cached data, if any */
>> +		swap(nr, *bytes);
>>   		swap(pgdat, stock->cached_pgdat);
>> +		if (*alt_bytes) {
>> +			__mod_objcg_state(objcg, pgdat, alt_idx,
>> +					  *alt_bytes);
>> +			*alt_bytes =3D 0;
>> +		}
> As per the other email, I really don't think optimizing the pgdat
> switch (in a percpu cache) is worth this level of complexity.

I am going to simplify it in the next version.


>
>>   	} else {
>> -		stock->vmstat_bytes +=3D nr;
>> -		if (abs(stock->vmstat_bytes) > PAGE_SIZE) {
>> -			nr =3D stock->vmstat_bytes;
>> -			stock->vmstat_bytes =3D 0;
>> +		*bytes +=3D nr;
>> +		if (abs(*bytes) > PAGE_SIZE) {
>> +			nr =3D *bytes;
>> +			*bytes =3D 0;
>>   		} else {
>>   			nr =3D 0;
>>   		}
>>   	}
>> -	if (nr)
>> -		__mod_objcg_state(objcg, pgdat, idx, nr);
>> -
>>   	put_obj_stock(flags);
>> +	if (!nr)
>> +		return;
>> +update_vmstat:
>> +	__mod_objcg_state(objcg, pgdat, idx, nr);
>>   }
>>  =20
>>   static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int n=
r_bytes)
>> @@ -3303,12 +3319,19 @@ static void drain_obj_stock(struct obj_stock *st=
ock)
>>   	/*
>>   	 * Flush the vmstat data in current stock
>>   	 */
>> -	if (stock->vmstat_bytes) {
>> -		__mod_objcg_state(old, stock->cached_pgdat, stock->vmstat_idx,
>> -				  stock->vmstat_bytes);
>> +	if (stock->reclaimable_bytes || stock->unreclaimable_bytes) {
>> +		int bytes;
>> +
>> +		if ((bytes =3D stock->reclaimable_bytes))
>> +			__mod_objcg_state(old, stock->cached_pgdat,
>> +					  NR_SLAB_RECLAIMABLE_B, bytes);
>> +		if ((bytes =3D stock->unreclaimable_bytes))
>> +			__mod_objcg_state(old, stock->cached_pgdat,
>> +					  NR_SLAB_UNRECLAIMABLE_B, bytes);
> The int bytes indirection isn't necessary. It's easier to read even
> with the extra lines required to repeat the long stock member names,
> because that is quite a common pattern (if (stuff) frob(stuff)).
OK, I will eliminate the bytes variable.
>
> __mod_objcg_state() also each time does rcu_read_lock() toggling and a
> memcg lookup that could be batched, which I think is further proof
> that it should just be inlined here.
>
I am also thinking that eliminate unnecessary=20
rcu_read_lock/rcu_read_unlock may help performance a bit. However, that=20
will be done in another patch after I have done more performance=20
testing. I am=C2=A0 not going to bother with that in this series.

Cheers,
Longman


