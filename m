From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] mm/memcontrol: update lruvec counters in
 mem_cgroup_move_account
Date: Wed, 16 Oct 2019 11:25:12 +0300
Message-ID: <7ef1ec83-02f7-0268-0a25-6f4dd90efaa7@yandex-team.ru>
References: <157112699975.7360.1062614888388489788.stgit@buzz>
 <20191015082048.GU317@dhcp22.suse.cz>
 <3b73e301-ea4a-5edb-9360-2ae9b4ad9f69@yandex-team.ru>
 <20191015103623.GX317@dhcp22.suse.cz>
 <31cab57d-6e79-33cb-1a58-99065c6e7b82@yandex-team.ru>
 <20191015110401.GZ317@dhcp22.suse.cz> <20191015143142.GB139269@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1571214314; bh=UdSNIKY6jmgqYMAhLPd60GKlUdZSEA9EsaTjEPZVOkI=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=0qUmj9hmwuvLmJTZUHzVACiTWo/KUjVNyhj2wVOMk1lIj1geSU98hvnFjUliLHNHc
         x1VX/79spCt8BSv454toxCJ1Of1FnpXzf+n9o4Nm2f835zr4ob0f/ZWsQ9zFJiCy5A
         MsIjAb/obmshDq2U07EJAdjKqWXmqCue09h/37Qk=
In-Reply-To: <20191015143142.GB139269@cmpxchg.org>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>

On 15/10/2019 17.31, Johannes Weiner wrote:
> On Tue, Oct 15, 2019 at 01:04:01PM +0200, Michal Hocko wrote:
>> On Tue 15-10-19 13:49:14, Konstantin Khlebnikov wrote:
>>> On 15/10/2019 13.36, Michal Hocko wrote:
>>>> On Tue 15-10-19 11:44:22, Konstantin Khlebnikov wrote:
>>>>> On 15/10/2019 11.20, Michal Hocko wrote:
>>>>>> On Tue 15-10-19 11:09:59, Konstantin Khlebnikov wrote:
>>>>>>> Mapped, dirty and writeback pages are also counted in per-lruvec stats.
>>>>>>> These counters needs update when page is moved between cgroups.
>>>>>>
>>>>>> Please describe the user visible effect.
>>>>>
>>>>> Surprisingly I don't see any users at this moment.
>>>>> So, there is no effect in mainline kernel.
>>>>
>>>> Those counters are exported right? Or do we exclude them for v1?
>>>
>>> It seems per-lruvec statistics is not exposed anywhere.
>>> And per-lruvec NR_FILE_MAPPED, NR_FILE_DIRTY, NR_WRITEBACK never had users.
>>
>> So why do we have it in the first place? I have to say that counters
>> as we have them now are really clear as mud. This is really begging for
>> a clean up.
> 
> IMO This is going in the right direction. The goal is to have all
> vmstat items accounted per lruvec - the intersection of the node and
> the memcg - to further integrate memcg into the traditional VM code
> and eliminate differences between them. We use the lruvec counters
> quite extensively in reclaim already, since the lruvec is the primary
> context for page reclaim. More consumers will follow in pending
> patches. This patch cleans up some stragglers.
> 
> The only counters we can't have in the lruvec are the legacy memcg
> ones that are accounted to the memcg without a node context:
> MEMCG_RSS, MEMCG_CACHE etc. We should eventually replace them with
> per-lruvec accounted NR_ANON_PAGES, NR_FILE_PAGES etc - tracked by
> generic VM code, not inside memcg, further reducing the size of the
> memory controller. But it'll require some work in the page creation
> path, as that accounting happens before the memcg commit right now.
> 
> Then we can get rid of memcg_stat_item and the_memcg_page_state
> API. And we should be able to do for_each_node() summing of the lruvec
> counters to produce memory.stat output, and drop memcg->vmstats_local,
> memcg->vmstats_percpu, memcg->vmstats and memcg->vmevents altogether.
> 

Ok, I see where it goes.
Some years ago I've worked on something similar.
Including linking page directly with its lruvec and moving lru_lock into lruvec.

Indeed VM code must be split per-node except accounting matters.
But summing per-node counters might be costly for balance_dirty_pages.
Probably memcg needs own dirty pages counter with per-cpu batching.
