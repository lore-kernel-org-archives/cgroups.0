From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] mm/memcg: Cache vmstat data in percpu memcg_stock_pcp
Date: Mon, 12 Apr 2021 15:30:04 -0400
Message-ID: <16af80a2-30a0-06da-9fd1-8d5101398fb9@redhat.com>
References: <20210409231842.8840-1-longman@redhat.com>
 <20210409231842.8840-4-longman@redhat.com>
 <YHSP+U/I52zx/JWZ@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618255809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6Ynsmxxkwh+nxh0otIklQ6uU+PBKwuJrjfFSi5KMSM=;
        b=KWilL3yWeCvBqOmbXTFGWiSRgDFbDp+ebJPDQoZZPWhQLikyYlFwhnfN+G7BuFar5fltqk
        QsozqEKqNCL6Gl12JlwJxN7Y/G72CyHWAAaP1NCqf3lEdtpBlqDvpg3zcGgeyHsZV6+S+t
        Qn4YG0se5mDtnppw1/xfG9BZKstvpYQ=
In-Reply-To: <YHSP+U/I52zx/JWZ-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 4/12/21 2:22 PM, Roman Gushchin wrote:
> On Fri, Apr 09, 2021 at 07:18:40PM -0400, Waiman Long wrote:
>> Before the new slab memory controller with per object byte charging,
>> charging and vmstat data update happen only when new slab pages are
>> allocated or freed. Now they are done with every kmem_cache_alloc()
>> and kmem_cache_free(). This causes additional overhead for workloads
>> that generate a lot of alloc and free calls.
>>
>> The memcg_stock_pcp is used to cache byte charge for a specific
>> obj_cgroup to reduce that overhead. To further reducing it, this patch
>> makes the vmstat data cached in the memcg_stock_pcp structure as well
>> until it accumulates a page size worth of update or when other cached
>> data change.
> The idea makes total sense to me and also gives a hope to remove
> byte-sized vmstats in the long-term.
>
>> On a 2-socket Cascade Lake server with instrumentation enabled and this
>> patch applied, it was found that about 17% (946796 out of 5515184) of the
>> time when __mod_obj_stock_state() is called leads to an actual call to
>> mod_objcg_state() after initial boot. When doing parallel kernel build,
>> the figure was about 16% (21894614 out of 139780628). So caching the
>> vmstat data reduces the number of calls to mod_objcg_state() by more
>> than 80%.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   mm/memcontrol.c | 78 +++++++++++++++++++++++++++++++++++++++++++------
>>   mm/slab.h       | 26 +++++++----------
>>   2 files changed, 79 insertions(+), 25 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index b19100c68aa0..539c3b632e47 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2220,7 +2220,10 @@ struct memcg_stock_pcp {
>>   
>>   #ifdef CONFIG_MEMCG_KMEM
>>   	struct obj_cgroup *cached_objcg;
>> +	struct pglist_data *cached_pgdat;
>>   	unsigned int nr_bytes;
>> +	int vmstat_idx;
>> +	int vmstat_bytes;
>>   #endif
> Because vmstat_idx can realistically take only 3 values (slab_reclaimable,
> slab_unreclaimable and percpu), I wonder if it's better to have
> vmstat_bytes[3] and save a bit more on the reduced number of flushes?
> It must be an often case when a complex (reclaimable) kernel object has
> non-reclaimable parts (e.g. kmallocs) or percpu counters.
> If the difference will be too small, maybe the current form is better.

I have thought about that too. However, that will make the code more 
complex. So I decided to cache just one for now. We can certainly play 
around with caching more in a later patch.

Cheers,
Longman


