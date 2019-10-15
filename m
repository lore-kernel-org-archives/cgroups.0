From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] mm/memcontrol: update lruvec counters in
 mem_cgroup_move_account
Date: Tue, 15 Oct 2019 13:49:14 +0300
Message-ID: <31cab57d-6e79-33cb-1a58-99065c6e7b82@yandex-team.ru>
References: <157112699975.7360.1062614888388489788.stgit@buzz>
 <20191015082048.GU317@dhcp22.suse.cz>
 <3b73e301-ea4a-5edb-9360-2ae9b4ad9f69@yandex-team.ru>
 <20191015103623.GX317@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1571136556; bh=kAMGDxkAbOPo3YYQfmMwLm3qVE+lcF5C9p9mjMh3EfA=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=rQw+KLl4HkAqtmwhezss/Z53Dxs7y2+bj/AoPhBWVauUKB4M0XyZWTOlyM1sV6kfO
         u2G0uWq5uOz9iVde1iKyTrtI3zgvE3QzuUkrwlYkIi0uL+/HQGVeuAZkBmr2A7BX9j
         GHxfA+S3RCAXieYfCJFzif4whnfoVGqMxtZBg86o=
In-Reply-To: <20191015103623.GX317@dhcp22.suse.cz>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>

On 15/10/2019 13.36, Michal Hocko wrote:
> On Tue 15-10-19 11:44:22, Konstantin Khlebnikov wrote:
>> On 15/10/2019 11.20, Michal Hocko wrote:
>>> On Tue 15-10-19 11:09:59, Konstantin Khlebnikov wrote:
>>>> Mapped, dirty and writeback pages are also counted in per-lruvec stats.
>>>> These counters needs update when page is moved between cgroups.
>>>
>>> Please describe the user visible effect.
>>
>> Surprisingly I don't see any users at this moment.
>> So, there is no effect in mainline kernel.
> 
> Those counters are exported right? Or do we exclude them for v1?

It seems per-lruvec statistics is not exposed anywhere.
And per-lruvec NR_FILE_MAPPED, NR_FILE_DIRTY, NR_WRITEBACK never had users.

I've found this because I'm using mem_cgroup_move_account for recharging
pages at mlock and playing right now with debug for memory cgroup which
validates statistics and counters when cgroup dies.

> 
>>>> Fixes: 00f3ca2c2d66 ("mm: memcontrol: per-lruvec stats infrastructure")
>>>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>>>
>>> We want Cc: stable I suspect because broken stats might be really
>>> misleading.
>>>
>>> The patch looks ok to me otherwise
>>> Acked-by: Michal Hocko <mhocko@suse.com>
>>>
>>>> ---
>>>>    mm/memcontrol.c |   18 ++++++++++++------
>>>>    1 file changed, 12 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index bdac56009a38..363106578876 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -5420,6 +5420,8 @@ static int mem_cgroup_move_account(struct page *page,
>>>>    				   struct mem_cgroup *from,
>>>>    				   struct mem_cgroup *to)
>>>>    {
>>>> +	struct lruvec *from_vec, *to_vec;
>>>> +	struct pglist_data *pgdat;
>>>>    	unsigned long flags;
>>>>    	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
>>>>    	int ret;
>>>> @@ -5443,11 +5445,15 @@ static int mem_cgroup_move_account(struct page *page,
>>>>    	anon = PageAnon(page);
>>>> +	pgdat = page_pgdat(page);
>>>> +	from_vec = mem_cgroup_lruvec(pgdat, from);
>>>> +	to_vec = mem_cgroup_lruvec(pgdat, to);
>>>> +
>>>>    	spin_lock_irqsave(&from->move_lock, flags);
>>>>    	if (!anon && page_mapped(page)) {
>>>> -		__mod_memcg_state(from, NR_FILE_MAPPED, -nr_pages);
>>>> -		__mod_memcg_state(to, NR_FILE_MAPPED, nr_pages);
>>>> +		__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
>>>> +		__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
>>>>    	}
>>>>    	/*
>>>> @@ -5459,14 +5465,14 @@ static int mem_cgroup_move_account(struct page *page,
>>>>    		struct address_space *mapping = page_mapping(page);
>>>>    		if (mapping_cap_account_dirty(mapping)) {
>>>> -			__mod_memcg_state(from, NR_FILE_DIRTY, -nr_pages);
>>>> -			__mod_memcg_state(to, NR_FILE_DIRTY, nr_pages);
>>>> +			__mod_lruvec_state(from_vec, NR_FILE_DIRTY, -nr_pages);
>>>> +			__mod_lruvec_state(to_vec, NR_FILE_DIRTY, nr_pages);
>>>>    		}
>>>>    	}
>>>>    	if (PageWriteback(page)) {
>>>> -		__mod_memcg_state(from, NR_WRITEBACK, -nr_pages);
>>>> -		__mod_memcg_state(to, NR_WRITEBACK, nr_pages);
>>>> +		__mod_lruvec_state(from_vec, NR_WRITEBACK, -nr_pages);
>>>> +		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
>>>>    	}
>>>>    #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>
> 
