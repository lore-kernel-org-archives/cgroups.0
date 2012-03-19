From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC][PATCH 1/3] memcg: add methods to access pc->mem_cgroup
Date: Mon, 19 Mar 2012 21:11:07 +0900
Message-ID: <4F67225B.9010002@jp.fujitsu.com>
References: <4F66E6A5.10804@jp.fujitsu.com> <4F66E773.4000807@jp.fujitsu.com> <4F671138.3000508@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F671138.3000508-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

(2012/03/19 19:58), Glauber Costa wrote:

> On 03/19/2012 11:59 AM, KAMEZAWA Hiroyuki wrote:
>> In order to encode pc->mem_cgroup and pc->flags to be in a word,
>> access function to pc->mem_cgroup is required.
>>
>> This patch replaces access to pc->mem_cgroup with
>>   pc_to_mem_cgroup(pc)          : pc->mem_cgroup
>>   pc_set_mem_cgroup(pc, memcg)  : pc->mem_cgroup = memcg
>>
>> Following patch will remove pc->mem_cgroup.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Kame,
> 
> I can't see a reason not to merge this patch right now, regardless of
> the other ones.
> 

Ok, if names of functions seems good, I'll post again.

Thanks,
-Kame 
