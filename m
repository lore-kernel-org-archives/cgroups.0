From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v5 2/3] mm: memcg/slab: Create a new set of kmalloc-cg-<n>
 caches
Date: Thu, 13 May 2021 10:40:08 +0200
Message-ID: <40fd10f4-b011-605a-9c0b-6d7ce17837f9@suse.cz>
References: <20210505200610.13943-1-longman@redhat.com>
 <20210512145107.6208-1-longman@redhat.com>
 <0919aaab-cc08-f86d-1f9a-8ddfeed7bb31@redhat.com>
 <20210512173212.738f592c36bf0e4c205f628e@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210512173212.738f592c36bf0e4c205f628e-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/13/21 2:32 AM, Andrew Morton wrote:
> On Wed, 12 May 2021 10:54:19 -0400 Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
>> >   include/linux/slab.h | 42 +++++++++++++++++++++++++++++++++---------
>> >   mm/slab_common.c     | 25 +++++++++++++++++--------
>> >   2 files changed, 50 insertions(+), 17 deletions(-)
>> 
>> The following are the diff's from previous version. It turns out that 
>> the previous patch doesn't work if CONFIG_ZONE_DMA isn't defined.
>> 
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index a51cad5f561c..aa7f6c222a60 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -312,16 +312,17 @@ static inline void __check_heap_object(const void 
>> *ptr, un
>> signed long n,
>>    */
>>   enum kmalloc_cache_type {
>>       KMALLOC_NORMAL = 0,
>> -#ifdef CONFIG_MEMCG_KMEM
>> -    KMALLOC_CGROUP,
>> -#else
>> +#ifndef CONFIG_ZONE_DMA
>> +    KMALLOC_DMA = KMALLOC_NORMAL,
>> +#endif
>> +#ifndef CONFIG_MEMCG_KMEM
>>       KMALLOC_CGROUP = KMALLOC_NORMAL,
>> +#else
>> +    KMALLOC_CGROUP,
>>   #endif
>>       KMALLOC_RECLAIM,
>>   #ifdef CONFIG_ZONE_DMA
>>       KMALLOC_DMA,
>> -#else
>> -    KMALLOC_DMA = KMALLOC_NORMAL,
>>   #endif
>>       NR_KMALLOC_TYPES
>>   };
> 
> I assume this fixes
> https://lkml.kernel.org/r/20210512152806.2492ca42-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org?

Yeah it should.
