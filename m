From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 0/5] mm/memcg: Reduce kmemcache memory accounting overhead
Date: Mon, 12 Apr 2021 10:03:13 -0400
Message-ID: <51ea6b09-b7ee-36e9-a500-b7141bd3a42b@redhat.com>
References: <20210409231842.8840-1-longman@redhat.com>
 <YHEEmGSVy3nl0obM@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618236200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUFKvDRszZ9E49AwoslD+yXNYOfmw6oJnUv4+bKBZOM=;
        b=W45c4zAXXx1GatkmynpAcbZadOeg6cHV6Hlkm54yZzNJYupu2J/pCb+hF/B0JOK13f9FlN
        3bBpQwJ2JOP/TXWHLCAwRldft+tERJqT9kLi91BRkXOaBddi+gws/OuF7VFwq5gCN5bL9t
        4b+oqWspzUd+RNf0oJJ42+GVCMMOIaQ=
In-Reply-To: <YHEEmGSVy3nl0obM@carbon.dhcp.thefacebook.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Wei Yang <richard.weiyang@gmail.com>, Masayoshi Mizuma <msys.mizuma@gmail.com>

On 4/9/21 9:51 PM, Roman Gushchin wrote:
> On Fri, Apr 09, 2021 at 07:18:37PM -0400, Waiman Long wrote:
>> With the recent introduction of the new slab memory controller, we
>> eliminate the need for having separate kmemcaches for each memory
>> cgroup and reduce overall kernel memory usage. However, we also add
>> additional memory accounting overhead to each call of kmem_cache_alloc()
>> and kmem_cache_free().
>>
>> For workloads that require a lot of kmemcache allocations and
>> de-allocations, they may experience performance regression as illustrated
>> in [1].
>>
>> With a simple kernel module that performs repeated loop of 100,000,000
>> kmem_cache_alloc() and kmem_cache_free() of 64-byte object at module
>> init. The execution time to load the kernel module with and without
>> memory accounting were:
>>
>>    with accounting = 6.798s
>>    w/o  accounting = 1.758s
>>
>> That is an increase of 5.04s (287%). With this patchset applied, the
>> execution time became 4.254s. So the memory accounting overhead is now
>> 2.496s which is a 50% reduction.
> Hi Waiman!
>
> Thank you for working on it, it's indeed very useful!
> A couple of questions:
> 1) did your config included lockdep or not?
The test kernel is based on a production kernel config and so lockdep 
isn't enabled.
> 2) do you have a (rough) estimation how much each change contributes
>     to the overall reduction?

I should have a better breakdown of the effect of individual patches. I 
rerun the benchmarking module with turbo-boosting disabled to reduce 
run-to-run variation. The execution times were:

Before patch: time = 10.800s (with memory accounting), 2.848s (w/o 
accounting), overhead = 7.952s
After patch 2: time = 9.140s, overhead = 6.292s
After patch 3: time = 7.641s, overhead = 4.793s
After patch 5: time = 6.801s, overhead = 3.953s

Patches 1 & 4 are preparatory patches that should affect performance.

So the memory accounting overhead was reduced by about half.

Cheers,
Longman

