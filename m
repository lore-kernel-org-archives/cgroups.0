From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Fix incorrect flushing of lruvec data in
 obj_stock
Date: Mon, 2 Aug 2021 09:32:16 -0400
Message-ID: <771539d4-765c-05c7-ab19-d4cae3d29efd@redhat.com>
References: <20210802022827.10192-1-longman@redhat.com>
 <YQeQfX3t8k+U3MIL@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627911139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YxGDLCphK9pn216lXXkSKE8Ac13snf8eRBNigOGCfQY=;
        b=LwUA1poXBpKV5QefIG2TN9hKlLe03q+vRp+SMoqwJRK87wR4unpUGWvtxpD8PmzlnkYA/G
        i5n7li/pxZqCxay3kjzyfS3d75wSVqCYPYqgeZszgTfjXftJBqJCQvuS24Vw9qu9ZOUNX0
        aWr3Q+YaRfiBmAWFix+73S/4P7oOvhQ=
In-Reply-To: <YQeQfX3t8k+U3MIL-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew

On 8/2/21 2:28 AM, Michal Hocko wrote:
> On Sun 01-08-21 22:28:27, Waiman Long wrote:
>> When mod_objcg_state() is called with a pgdat that is different from
>> that in the obj_stock, the old lruvec data cached in obj_stock are
>> flushed out. Unfortunately, they were flushed to the new pgdat and
>> hence the wrong node, not the one cached in obj_stock.
> It would be great to explicitly mention user observable problems here. I
> do assume this will make slab stats skewed but the effect wouldn't be
> very big, right?
It is the /sys/devices/system/node/node*/meminfo that will get skewed. 
Not /proc/meminfo. So it is a relatively minor issue. Will update the 
patch to mention that.
>> Fix that by flushing the data to the cached pgdat instead.
>>
>> Fixes: 68ac5b3c8db2 ("mm/memcg: cache vmstat data in percpu memcg_stock_pcp")
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>
>> ---
>>   mm/memcontrol.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index ae1f5d0cb581..881ec4ddddcd 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3106,17 +3106,19 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>>   		stock->cached_pgdat = pgdat;
>>   	} else if (stock->cached_pgdat != pgdat) {
>>   		/* Flush the existing cached vmstat data */
>> +		struct pglist_data *oldpg = stock->cached_pgdat;
>> +
>> +		stock->cached_pgdat = pgdat;
>>   		if (stock->nr_slab_reclaimable_b) {
>> -			mod_objcg_mlstate(objcg, pgdat, NR_SLAB_RECLAIMABLE_B,
>> +			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
>>   					  stock->nr_slab_reclaimable_b);
>>   			stock->nr_slab_reclaimable_b = 0;
>>   		}
>>   		if (stock->nr_slab_unreclaimable_b) {
>> -			mod_objcg_mlstate(objcg, pgdat, NR_SLAB_UNRECLAIMABLE_B,
>> +			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_UNRECLAIMABLE_B,
>>   					  stock->nr_slab_unreclaimable_b);
>>   			stock->nr_slab_unreclaimable_b = 0;
>>   		}
>> -		stock->cached_pgdat = pgdat;
> Minor nit. Is there any reason to move the cached_pgdat? TBH I found the
> original way better from the readability POV.

Right. Will move it back to its original place.

Cheers,
Longman


