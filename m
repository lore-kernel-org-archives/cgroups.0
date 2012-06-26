From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
Date: Tue, 26 Jun 2012 13:17:37 +0400
Message-ID: <4FE97E31.3010201@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206260210200.16020@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1206260210200.16020-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On 06/26/2012 01:12 PM, David Rientjes wrote:
> On Mon, 25 Jun 2012, Glauber Costa wrote:
>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 83e7ba9..22479eb 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -21,6 +21,7 @@
>>   #define _LINUX_MEMCONTROL_H
>>   #include <linux/cgroup.h>
>>   #include <linux/vm_event_item.h>
>> +#include <linux/hardirq.h>
>>
>>   struct mem_cgroup;
>>   struct page_cgroup;
>> @@ -409,6 +410,12 @@ struct sock;
>>   #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>>   void sock_update_memcg(struct sock *sk);
>>   void sock_release_memcg(struct sock *sk);
>> +
>> +#define mem_cgroup_kmem_on 1
>> +bool __mem_cgroup_new_kmem_page(gfp_t gfp, void *handle, int order);
>> +void __mem_cgroup_commit_kmem_page(struct page *page, void *handle, int order);
>> +void __mem_cgroup_free_kmem_page(struct page *page, int order);
>> +#define is_kmem_tracked_alloc (gfp & __GFP_KMEMCG)
>>   #else
>>   static inline void sock_update_memcg(struct sock *sk)
>>   {
>> @@ -416,6 +423,43 @@ static inline void sock_update_memcg(struct sock *sk)
>>   static inline void sock_release_memcg(struct sock *sk)
>>   {
>>   }
>> +
>> +#define mem_cgroup_kmem_on 0
>> +#define __mem_cgroup_new_kmem_page(a, b, c) false
>> +#define __mem_cgroup_free_kmem_page(a,b )
>> +#define __mem_cgroup_commit_kmem_page(a, b, c)
>> +#define is_kmem_tracked_alloc (false)
>>   #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
>> +
>> +static __always_inline
>> +bool mem_cgroup_new_kmem_page(gfp_t gfp, void *handle, int order)
>> +{
>> +	if (!mem_cgroup_kmem_on)
>> +		return true;
>> +	if (!is_kmem_tracked_alloc)
>> +		return true;
>> +	if (!current->mm)
>> +		return true;
>> +	if (in_interrupt())
>> +		return true;
>
> You can't test for current->mm in irq context, so you need to check for
> in_interrupt() first.
 >
Right, thanks.

> Also, what prevents __mem_cgroup_new_kmem_page()
> from being called for a kthread that has called use_mm() before
> unuse_mm()?

Nothing, but I also don't see how to prevent that.
At a first glance, it seems fair to me to say that if a kernel thread 
uses the mm of a process, it poses as this process for any accounting 
purpose.
