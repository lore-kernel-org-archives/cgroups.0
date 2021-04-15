From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/5] mm/memcg: Cache vmstat data in percpu
 memcg_stock_pcp
Date: Thu, 15 Apr 2021 13:08:29 -0400
Message-ID: <5abe499a-b1ad-fa22-3487-1a6e00e30e17@redhat.com>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-4-longman@redhat.com> <YHhu1BOMj1Ip+sb3@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618506514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c4bUwdWqx5JUrWJYR1rKkQlIPcDgNW5mI87L7J9m2Ko=;
        b=HMlDzOBsO9FtPKidhpmYUZVrSl40bs1GxJV36AqBOOk1V+tZclNUIKHHg/j0h4lIGZYKtI
        khLfF1o2cguWp2JLcYC1YoW+kB+nkw8T24toNmVkF1zlz6qwdFgCeqZPmDyOaeI8R8J0U6
        DKv2MCqXegXcxLO1SBtZW6FteAQOvTI=
In-Reply-To: <YHhu1BOMj1Ip+sb3-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 4/15/21 12:50 PM, Johannes Weiner wrote:
> On Tue, Apr 13, 2021 at 09:20:25PM -0400, Waiman Long wrote:
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
>>
>> On a 2-socket Cascade Lake server with instrumentation enabled and this
>> patch applied, it was found that about 17% (946796 out of 5515184) of the
>> time when __mod_obj_stock_state() is called leads to an actual call to
>> mod_objcg_state() after initial boot. When doing parallel kernel build,
>> the figure was about 16% (21894614 out of 139780628). So caching the
>> vmstat data reduces the number of calls to mod_objcg_state() by more
>> than 80%.
> Right, but mod_objcg_state() is itself already percpu-cached. What's
> the benefit of avoiding calls to it with another percpu cache?
>
There are actually 2 set of vmstat data that have to be updated. One is 
associated with the memcg and other one is for each lruvec within the 
cgroup. Caching it in obj_stock, we replace 2 writes to two colder 
cachelines with one write to a hot cacheline. If you look at patch 5, I 
break obj_stock into two - one for task context and one for irq context. 
Interrupt disable is no longer needed in task context, but that is not 
possible when writing to the actual vmstat data arrays.

Cheers,
Longman

