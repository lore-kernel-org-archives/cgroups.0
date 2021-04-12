From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] mm/memcg: Reduce kmemcache memory accounting overhead
Date: Mon, 12 Apr 2021 15:20:48 -0400
Message-ID: <339bd1b0-681c-61fa-210b-59f1542431e2@redhat.com>
References: <20210409231842.8840-1-longman@redhat.com>
 <YHEEmGSVy3nl0obM@carbon.dhcp.thefacebook.com>
 <51ea6b09-b7ee-36e9-a500-b7141bd3a42b@redhat.com>
 <YHSHqmxyu1DkAMYR@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618255253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oFjHc+GCztqPmJltFlAlQEb4vymDlpph7ymGuFpnTz8=;
        b=cUU0C334tXxqNdBDs4vJ+4JayPJujnKNRSzU0gLmm2WQ0Av4ztmej+av9zVOqxir+Wyc/2
        bbuMAf8kgwvvkkxNWycVkMAMPTgbIy/VCtNV/XOkNIHn/JuwnX1HtQD57OZRe20aMEQmRq
        yXlJHspNypfE/tlJOHmZzd8dEvxGpLU=
In-Reply-To: <YHSHqmxyu1DkAMYR-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 4/12/21 1:47 PM, Roman Gushchin wrote:
> On Mon, Apr 12, 2021 at 10:03:13AM -0400, Waiman Long wrote:
>> On 4/9/21 9:51 PM, Roman Gushchin wrote:
>>> On Fri, Apr 09, 2021 at 07:18:37PM -0400, Waiman Long wrote:
>>>> With the recent introduction of the new slab memory controller, we
>>>> eliminate the need for having separate kmemcaches for each memory
>>>> cgroup and reduce overall kernel memory usage. However, we also add
>>>> additional memory accounting overhead to each call of kmem_cache_alloc()
>>>> and kmem_cache_free().
>>>>
>>>> For workloads that require a lot of kmemcache allocations and
>>>> de-allocations, they may experience performance regression as illustrated
>>>> in [1].
>>>>
>>>> With a simple kernel module that performs repeated loop of 100,000,000
>>>> kmem_cache_alloc() and kmem_cache_free() of 64-byte object at module
>>>> init. The execution time to load the kernel module with and without
>>>> memory accounting were:
>>>>
>>>>     with accounting = 6.798s
>>>>     w/o  accounting = 1.758s
>>>>
>>>> That is an increase of 5.04s (287%). With this patchset applied, the
>>>> execution time became 4.254s. So the memory accounting overhead is now
>>>> 2.496s which is a 50% reduction.
>>> Hi Waiman!
>>>
>>> Thank you for working on it, it's indeed very useful!
>>> A couple of questions:
>>> 1) did your config included lockdep or not?
>> The test kernel is based on a production kernel config and so lockdep isn't
>> enabled.
>>> 2) do you have a (rough) estimation how much each change contributes
>>>      to the overall reduction?
>> I should have a better breakdown of the effect of individual patches. I
>> rerun the benchmarking module with turbo-boosting disabled to reduce
>> run-to-run variation. The execution times were:
>>
>> Before patch: time = 10.800s (with memory accounting), 2.848s (w/o
>> accounting), overhead = 7.952s
>> After patch 2: time = 9.140s, overhead = 6.292s
>> After patch 3: time = 7.641s, overhead = 4.793s
>> After patch 5: time = 6.801s, overhead = 3.953s
> Thank you! If there will be v2, I'd include this information into commit logs.

Yes, I am planning to send out v2 with these information in the 
cover-letter. I am just waiting a bit to see if there are more feedback.

-Longman

>
>> Patches 1 & 4 are preparatory patches that should affect performance.
>>
>> So the memory accounting overhead was reduced by about half.

BTW, the benchmark that I used is kind of the best case behavior as it 
as all updates are to the percpu stocks. Real workloads will likely to 
have a certain amount of update to the memcg charges and vmstats. So the 
performance benefit will be less.

Cheers,
Longman


