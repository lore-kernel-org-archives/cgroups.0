From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: rework inactive_ratio logic
Date: Thu, 16 Feb 2012 10:57:14 +0400
Message-ID: <4F3CA8CA.8020004@openvz.org>
References: <20120215162442.13588.21790.stgit@zurg> <20120216103842.0c3e9258.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=bZlg1J6P5vwdNkp0slFV6Go+gXVxY3VmCdw41YN6xb4=;
        b=cMVDpaghctIYZ7xNhty5nhUMd7Oo1J4o5D00zCtSJkfw8xBVHF728LDw0X0UzDaNUj
         Chut7C0bCS2Bpj1DZ+Mu52qwXqg29U0UWNjvYM+iI625xbSvSJzHZuoozdHCtJwGG/I8
         0aDEj8zcPuAKVV07oYJZdus1MMo5SDmF9qUgQ=
In-Reply-To: <20120216103842.0c3e9258.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

KAMEZAWA Hiroyuki wrote:
> On Wed, 15 Feb 2012 20:24:42 +0400
> Konstantin Khlebnikov<khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>  wrote:
>
>> This patch adds mem_cgroup->inactive_ratio calculated from hierarchical memory limit.
>> It updated at each limit change before shrinking cgroup to this new limit.
>> Ratios for all child cgroups are updated too, because parent limit can affect them.
>> Update precedure can be greatly optimized if its performance becomes the problem.
>> Inactive ratio for unlimited or huge limit does not matter, because we'll never hit it.
>>
>> At global reclaim always use global ratio from zone->inactive_ratio.
>> At mem-cgroup reclaim use inactive_ratio from target memory cgroup,
>> this is cgroup which hit its limit and cause this reclaimer invocation.
>>
>> Thus, global memory reclaimer will try to keep ratio for all lru lists in zone
>> above one mark, this guarantee that total ratio in this zone will be above too.
>> Meanwhile mem-cgroup will do the same thing for its lru lists in all zones, and
>> for all lru lists in all sub-cgroups in hierarchy.
>>
>> Also this patch removes some redundant code.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>
> Hmm, the main purpose of this patch is to remove calculation per get_scan_ratio() ?

Technically, it was preparation for "mm: unify inactive_list_is_low()" from "memory book keeping" patchset.
So, actually its main purpose is moving all active/inactive size calculation to mm/vmscan.c

Also I trying to figure out most sane logic for inactive_ratio calculation,
currently global memory reclaimer sometimes uses memcg-calculated ratio, it looks strange.

>> ---
>>   include/linux/memcontrol.h |   16 ++------
>>   mm/memcontrol.c            |   85 ++++++++++++++++++++++++--------------------
>>   mm/vmscan.c                |   82 +++++++++++++++++++++++-------------------
>>   3 files changed, 93 insertions(+), 90 deletions(-)
>>   static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>                                unsigned long long val)
>>   {

<cut>

>> @@ -3422,6 +3416,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>                        else
>>                                memcg->memsw_is_minimum = false;
>>                }
>> +             mem_cgroup_update_inactive_ratio(memcg, val);
>>                mutex_unlock(&set_limit_mutex);
>>
>>                if (!ret)
>> @@ -3439,6 +3434,12 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>        if (!ret&&  enlarge)
>>                memcg_oom_recover(memcg);
>>
>> +     if (ret) {
>> +             mutex_lock(&set_limit_mutex);
>> +             mem_cgroup_update_inactive_ratio(memcg, RESOURCE_MAX);
>> +             mutex_unlock(&set_limit_mutex);
>> +     }
>
> Why RESOUECE_MAX ?

resize was failed, so we return back normal value calculated from the current limit.
target == RESOURCE_MAX isn't clip limit: min(RESOURCE_MAX, limit) == limit

>
> Thanks,
> -Kame
>
