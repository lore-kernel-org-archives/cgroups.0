From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/3] page cgroup diet
Date: Wed, 21 Mar 2012 10:13:34 +0400
Message-ID: <4F69718E.8010603@openvz.org>
References: <4F66E6A5.10804@jp.fujitsu.com> <4F679039.6070609@openvz.org> <4F692895.8020908@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=QalCnShzCyqRsHoyahvZomBfqtcSqaw50MmHpMhTa+g=;
        b=uVJvtzswGJFUPhq2kB2T+nNL89n8pAGDKk3aqY+DbQrd2678aFJvherwpX0GxU+4iW
         b0q5GLZirlj1rNpu/6vxwmJd0UARWlsvbRQzghPeDiNZkKXp4bApHXr6fZ/+VSs11/iO
         A2eE7cGZwSEhiJWzNnD10icxrR29NnHwinl9ml3zdHnyTHoUbH6AiFs8YcXQe3l0nz5E
         6t+Bf0nKqkYAV48Psb2RcmZK23U2bC+Z4xq2lL2da6eJ6yg0YWKxp7H5Sr/LLk6McCwQ
         OoHMLaxr5XUzeIyfdqCgKfHljHngnbTbXc/wGhmVeeh7s6jSzzUfmCKXux1l3fq1uho0
         zv4g==
In-Reply-To: <4F692895.8020908-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org" <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

KAMEZAWA Hiroyuki wrote:
> (2012/03/20 4:59), Konstantin Khlebnikov wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> This is just an RFC...test is not enough yet.
>>>
>>> I know it's merge window..this post is just for sharing idea.
>>>
>>> This patch merges pc->flags and pc->mem_cgroup into a word. Then,
>>> memcg's overhead will be 8bytes per page(4096bytes?).
>>>
>>> Because this patch will affect all memory cgroup developers, I'd like to
>>> show patches before MM Summit. I think we can agree the direction to
>>> reduce size of page_cgroup..and finally integrate into 'struct page'
>>> (and remove cgroup_disable= boot option...)
>>>
>>> Patch 1/3 - introduce pc_to_mem_cgroup and hide pc->mem_cgroup
>>> Patch 2/3 - remove pc->mem_cgroup
>>> Patch 3/3 - remove memory barriers.
>>>
>>> I'm now wondering when this change should be merged....
>>>
>>
>> This is cool, but maybe we should skip this temporary step and merge all this stuff into page->flags.
> 
> 
> Why we should skip and delay reduction of size of page_cgroup
> which is considered as very big problem ?

I think it would be better to solve problem completely and kill page_cgroup in one step.

> 
>> I think we can replace zone-id and node-id in page->flags with cumulative dynamically allocated lruvec-id,
>> so there will be enough space for hundred cgroups even on 32-bit systems.
> 
> 
> Where section-id  is ?
> IIUC, now, page->section->zone/node is calculated if CONFIG_SPARSEMEM.

Yeah, sections are biggest problem there. I hope we can unravel this knot.
In the worst case we can extend page->flags upto 64-bits.

> 
> BTW, I doubt that we can modify page->flags dynamically with multi-bit operations...using
> cmpxchg per each page when it's charged/uncharged/other ?

we can do atomic_xor(&page->flags, new-lruvec-id ^ old-lruvec-id) or
atomic_add(&page->flags, new-lruvec-id - old-lruvec-id) they should work faster than cmpxchg

> 
>>
>> After lru_lock splitting page to lruvec translation will be much frequently used than page to zone,
>> so page->zone and page->node translations can be implemented as page->lruvec->zone and page->lruvec->node.
>>
> 
> And need to take rcu_read_lock() around page_zone() ?

Hmm, it depends. For kernel-pages there will be pointer to root-lruvec, so no protection required.
If we hold lru_lock we also don't need this rcu_read_lock.

> 
> Thanks,
> -Kame
> 
> 
> 
