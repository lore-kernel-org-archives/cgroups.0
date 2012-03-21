From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/3] page cgroup diet
Date: Wed, 21 Mar 2012 15:30:22 +0900
Message-ID: <4F69757E.5030103@jp.fujitsu.com>
References: <4F66E6A5.10804@jp.fujitsu.com> <4F679039.6070609@openvz.org> <4F692895.8020908@jp.fujitsu.com> <4F69718E.8010603@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F69718E.8010603-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org" <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

(2012/03/21 15:13), Konstantin Khlebnikov wrote:

> KAMEZAWA Hiroyuki wrote:
>> (2012/03/20 4:59), Konstantin Khlebnikov wrote:
>>
>>> KAMEZAWA Hiroyuki wrote:
>>>> This is just an RFC...test is not enough yet.
>>>>
>>>> I know it's merge window..this post is just for sharing idea.
>>>>
>>>> This patch merges pc->flags and pc->mem_cgroup into a word. Then,
>>>> memcg's overhead will be 8bytes per page(4096bytes?).
>>>>
>>>> Because this patch will affect all memory cgroup developers, I'd like to
>>>> show patches before MM Summit. I think we can agree the direction to
>>>> reduce size of page_cgroup..and finally integrate into 'struct page'
>>>> (and remove cgroup_disable= boot option...)
>>>>
>>>> Patch 1/3 - introduce pc_to_mem_cgroup and hide pc->mem_cgroup
>>>> Patch 2/3 - remove pc->mem_cgroup
>>>> Patch 3/3 - remove memory barriers.
>>>>
>>>> I'm now wondering when this change should be merged....
>>>>
>>>
>>> This is cool, but maybe we should skip this temporary step and merge all this stuff into page->flags.
>>
>>
>> Why we should skip and delay reduction of size of page_cgroup
>> which is considered as very big problem ?
> 
> I think it would be better to solve problem completely and kill page_cgroup in one step.
> 


I like step-by-step rather than a big step. I devided this page_cgroup diet patch set
into 3 steps (2012-Jan, 2012-Feb, and the next one is the last.)

This change may introduce new races as step1 and step2 did (Thanks to Hugh Dickins!).

Finally, IIUC, 'struct page' has 8bytes of padding now. I think we can use that space
if we can be agreed.

Hm. BTW, using lruvec in page->flags implies you add a dynamic table lookup in
free_page() and you need to reset page->flags to point a valid
lruvec at page allocation. Please take care of performance.

Thanks,
-Kame
