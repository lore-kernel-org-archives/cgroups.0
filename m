From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: remove definition of MEM_CGROUP_ID_MAX when
 !CONFIG_MEMCG
Date: Fri, 7 Jul 2023 10:06:49 +0800
Message-ID: <61ce2910-f3de-cfb7-bdd3-546ade0cb6f3@huawei.com>
References: <20230706112820.2393447-1-linmiaohe@huawei.com>
 <892B507C-CFE8-4792-BA5F-3C698290A8EE@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <892B507C-CFE8-4792-BA5F-3C698290A8EE-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On 2023/7/7 9:47, Muchun Song wrote:
> 
> 
>> On Jul 6, 2023, at 19:28, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>
>> MEM_CGROUP_ID_MAX is only used when CONFIG_MEMCG is configured. Remove
>> unneeded !CONFIG_MEMCG variant.
>>
>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> MEM_CGROUP_ID_MAX is also only used in mem_cgroup_alloc(), maybe you also
> could move it from memcontrol.h to memcontrol.c. And define it as:
> 
> #define MEM_CGROUP_ID_MAX ((1U << MEM_CGROUP_ID_SHIFT) - 1)
> 
> I am not suggesting defining it as USHRT_MAX, because if someone changes
> MEM_CGROUP_ID_SHIFT in the future, then MEM_CGROUP_ID_MAX will not updated
> accordingly.

Looks sensible to me. Do you suggest squashing above changes into the current patch
or a separate patch is preferred?

> 
> For this patch, LGTM.
> 
> Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks for review and suggestion.


