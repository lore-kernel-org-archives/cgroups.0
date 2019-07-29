From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC] mm/memcontrol: reclaim severe usage over high limit
 in get_user_pages loop
Date: Mon, 29 Jul 2019 14:24:35 +0300
Message-ID: <5002e67b-b87f-d753-0f9c-6e732b8e7a80@yandex-team.ru>
References: <156431697805.3170.6377599347542228221.stgit@buzz>
 <20190729091738.GF9330@dhcp22.suse.cz>
 <3d6fc779-2081-ba4b-22cf-be701d617bb4@yandex-team.ru>
 <20190729103307.GG9330@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1564399475; bh=0rOY1hf/vJwvLzCfaIpmU6fmgpWmli7XV2Wh26/reCw=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=nByOcS2558rwwbSDAEFX2ECRH9cbBKFJaqHwq5HMsvxsD7/jzng5DQod4BtWEnb02
         nZJtRjZ8Zv2vy73Awdgp0hBWRsof8qOxZYo+VXuBmFOCl89Fox23CMoLSgOX4cRU6Z
         yHZqAu8Cmmg5ZnLDYFt0xwqNaLD3D6ptE3l9l5p4=
In-Reply-To: <20190729103307.GG9330@dhcp22.suse.cz>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>

On 29.07.2019 13:33, Michal Hocko wrote:
> On Mon 29-07-19 12:40:29, Konstantin Khlebnikov wrote:
>> On 29.07.2019 12:17, Michal Hocko wrote:
>>> On Sun 28-07-19 15:29:38, Konstantin Khlebnikov wrote:
>>>> High memory limit in memory cgroup allows to batch memory reclaiming and
>>>> defer it until returning into userland. This moves it out of any locks.
>>>>
>>>> Fixed gap between high and max limit works pretty well (we are using
>>>> 64 * NR_CPUS pages) except cases when one syscall allocates tons of
>>>> memory. This affects all other tasks in cgroup because they might hit
>>>> max memory limit in unhandy places and\or under hot locks.
>>>>
>>>> For example mmap with MAP_POPULATE or MAP_LOCKED might allocate a lot
>>>> of pages and push memory cgroup usage far ahead high memory limit.
>>>>
>>>> This patch uses halfway between high and max limits as threshold and
>>>> in this case starts memory reclaiming if mem_cgroup_handle_over_high()
>>>> called with argument only_severe = true, otherwise reclaim is deferred
>>>> till returning into userland. If high limits isn't set nothing changes.
>>>>
>>>> Now long running get_user_pages will periodically reclaim cgroup memory.
>>>> Other possible targets are generic file read/write iter loops.
>>>
>>> I do see how gup can lead to a large high limit excess, but could you be
>>> more specific why is that a problem? We should be reclaiming the similar
>>> number of pages cumulatively.
>>>
>>
>> Large gup might push usage close to limit and keep it here for a some time.
>> As a result concurrent allocations will enter direct reclaim right at
>> charging much more frequently.
> 
> Yes, this is indeed prossible. On the other hand even the reclaim from
> the charge path doesn't really prevent from that happening because the
> context might get preempted or blocked on locks. So I guess we need a
> more detailed information of an actual world visible problem here.
>   
>> Right now deferred recalaim after passing high limit works like distributed
>> memcg kswapd which reclaims memory in "background" and prevents completely
>> synchronous direct reclaim.
>>
>> Maybe somebody have any plans for real kswapd for memcg?
> 
> I am not aware of that. The primary problem back then was that we simply
> cannot have a kernel thread per each memcg because that doesn't scale.
> Using kthreads and a dynamic pool of threads tends to be quite tricky -
> e.g. a proper accounting, scaling again.

Yep, for containers proper accounting is important, especially cpu usage.

We're using manual kwapd-style reclaim in userspace by MADV_STOCKPILE
within container where memory allocation latency is critical.

This patch is about less extreme cases which would be nice to handle
automatically, without custom tuning.

>   
>> I've put mem_cgroup_handle_over_high in gup next to cond_resched() and
>> later that gave me idea that this is good place for running any
>> deferred works, like bottom half for tasks. Right now this happens
>> only at switching into userspace.
> 
> I am not against pushing high memory reclaim into the charge path in
> principle. I just want to hear how big of a problem this really is in
> practice. If this is mostly a theoretical problem that might hit then I
> would rather stick with the existing code though.
> 

Besides latency which might be not so important for everybody I see these:

First problem is a fairness within cgroup - task that generates allocation
flow isn't throttled after passing high limits as documentation states.
It will feel memory pressure only after hitting max limit while other
tasks with smaller allocations will go into direct reclaim right away.

Second is an accumulating too much deferred reclaim - after large gup task
might call direct reclaim with target amount much larger than gap between
high and max limits, or even larger than max limit itself.
