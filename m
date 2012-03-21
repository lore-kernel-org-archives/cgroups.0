From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC][PATCH 2/3] memcg: reduce size of struct page_cgroup.
Date: Wed, 21 Mar 2012 09:47:29 +0900
Message-ID: <4F692521.8010607@jp.fujitsu.com>
References: <4F66E6A5.10804@jp.fujitsu.com> <4F66E7D7.4040406@jp.fujitsu.com> <CABCjUKAr+F=Pz-JCWfjGfyL4AcHt6m97p13=0VdwjeVm5SKW7w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKAr+F=Pz-JCWfjGfyL4AcHt6m97p13=0VdwjeVm5SKW7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

(2012/03/20 7:20), Suleiman Souhlal wrote:

> 2012/3/19 KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>:
>> Now, page_cgroup->flags has only 3bits. Considering alignment of
>> struct mem_cgroup, which is allocated by kmalloc(), we can encode
>> pointer to mem_cgroup and flags into a word.
>>
>> After this patch, pc->flags is encoded as
>>
>>  63                           2     0
>>  | pointer to memcg..........|flags|
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> ---
>>  include/linux/page_cgroup.h |   15 ++++++++++++---
>>  1 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
>> index 92768cb..bca5447 100644
>> --- a/include/linux/page_cgroup.h
>> +++ b/include/linux/page_cgroup.h
>> @@ -1,6 +1,10 @@
>>  #ifndef __LINUX_PAGE_CGROUP_H
>>  #define __LINUX_PAGE_CGROUP_H
>>
>> +/*
>> + * Because these flags are encoded into ->flags with a pointer,
>> + * we cannot have too much flags.
>> + */
>>  enum {
>>        /* flags for mem_cgroup */
>>        PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
>> @@ -9,6 +13,8 @@ enum {
>>        __NR_PCG_FLAGS,
>>  };
>>
>> +#define PCG_FLAGS_MASK ((1 << __NR_PCG_FLAGS) - 1)
>> +
>>  #ifndef __GENERATING_BOUNDS_H
>>  #include <generated/bounds.h>
>>
>> @@ -21,10 +27,12 @@ enum {
>>  * page_cgroup helps us identify information about the cgroup
>>  * All page cgroups are allocated at boot or memory hotplug event,
>>  * then the page cgroup for pfn always exists.
>> + *
>> + * flags and a pointer to memory cgroup are encoded into ->flags.
>> + * Lower 3bits are used for flags and others are used for a pointer to memcg.
> 
> Would it be worth adding a BUILD_BUG_ON(__NR_PCG_FLAGS > 3) ?
> 


Ok, I'll add that.

Thanks,
-Kame
