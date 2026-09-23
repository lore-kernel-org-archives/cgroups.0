Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1DB355F5C
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 03:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790134867; cv=none; b=OhykmMtU6BNAsdAYkQy9vJRqClojlOsA23N3W92kOvIhXPqQGT7aOa72TNxRacRJC0bSIHaoI8Km3y/056/+9YDJPuuGGj0JKUfF0B9paWlugR3QP2E5J8DF3mblSfvh/cTgZfgvIoD38q2XmXAnsBaXRckrEEt/Wixx7csyZO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790134867; c=relaxed/simple;
	bh=g0/Z5c9aDwytCwk3EVHISBOUhMOmw+UqfCuabJU23Po=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Bkeccyju12vZaDySompl4ak0NdWxlB1naNFE16Tdxe0nkaKCNAoukGHkoS0+n95r5AsZV1zC3mXIEC3hZ2RVxfxTpSikGj478eEmucosHIZTaSqOS0Uq4hsswniC+JTLqD9S4yjp/iSbsRjEIz9w916KHfW646HoHz8/M9h/vFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t5KzfUbR; arc=none smtp.client-ip=95.215.58.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t5KzfUbR"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=g0/Z5c9aDwytCwk3EVHISBOUhMOmw+UqfCuabJU23Po=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790134863; v=1; x=1790739663;
 b=t5KzfUbRPgwv6bU849Gk4sjU/WqthHJxWnYgZ9CznQ3o4Ck0wIbxT85pCzznXxrcJtwcMKwQ
 DMe4S/Mui0Td3ETfzxqRd45JJF1Q+PDHNHQjSK/l7mYjRq3dJxcyFjZq6B5/J6f/2Xg9tiZtcQL
 33KAUZsseBYKCQ+GFiDjP/p4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6f051fd9b05117c8;
	Wed, 23 Sep 2026 03:41:03 +0000
X-Mizu-Trace-ID: 6f051fd9b05117c8
X-Migadu-Flow: FLOW_OUT
Message-ID: <1835413c-e2de-41b0-8225-161afa50676a@linux.dev>
Date: Wed, 23 Sep 2026 11:40:55 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Chris Down <chris@chrisdown.name>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
To: Muchun Song <muchun.song@linux.dev>, Hongfu Li <lihongfu@kylinos.cn>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
 <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
 <15ac7069-d687-4985-90bd-25bc900b4bdd@linux.dev>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <15ac7069-d687-4985-90bd-25bc900b4bdd@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/23/26 10:40 AM, Muchun Song wrote:
>
>
> On 2026/9/23 10:05, Hongfu Li wrote:
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
>> stats. These stats are accounted against folio_nid(): incremented on
>> the folio's node when handed to a user, decremented when the folio is
>> returned to the pool.
>>
>> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
>> to the new folio and drops the memcg data of the old one, so the free
>> of the old folio right after the migration skips the memcg per-node
>> lruvec decrement. The hugetlb count stays attributed to the old node
>> for the rest of the life of the charge, while the target folio gets no
>> increment on the new node; its later free decrements a counter that
>> was never incremented.
>>
>> Migrate the per-node lruvec accounting alongside migration. Global
>> memcg totals remain balanced because they track resource consumption,
>> not node placement.
>>
>> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>> ---
>>   include/linux/memcontrol.h |  8 ++++++++
>>   mm/hugetlb.c               | 25 +++++++++++++++++++++++++
>>   mm/memcontrol.c            |  5 ++---
>>   3 files changed, 35 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index a8358f297b65..74110a324f9e 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -984,6 +984,9 @@ unsigned long lruvec_page_state_monotonic(const 
>> struct lruvec *lruvec,
>>   unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>>                         enum node_stat_item idx);
>>   +void mod_memcg_lruvec_state(struct lruvec *lruvec,
>> +                enum node_stat_item idx, int val);
>> +
>>   void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>>   void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>>   @@ -1452,6 +1455,11 @@ static inline unsigned long 
>> lruvec_page_state_local(const struct lruvec *lruvec,
>>       return node_page_state(lruvec_pgdat(lruvec), idx);
>>   }
>>   +static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
>> +                      enum node_stat_item idx, int val)
>> +{
>> +}
>> +
>>   static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>>   {
>>   }
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 519c30b338a8..76d019594b39 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -23,6 +23,7 @@
>>   #include <linux/mmdebug.h>
>>   #include <linux/sched/signal.h>
>>   #include <linux/rmap.h>
>> +#include <linux/rcupdate.h>
>>   #include <linux/string_choices.h>
>>   #include <linux/string_helpers.h>
>>   #include <linux/swap.h>
>> @@ -7378,12 +7379,36 @@ void folio_putback_hugetlb(struct folio *folio)
>>       folio_put(folio);
>>   }
>>   +static void move_hugetlb_lruvec_stat(struct folio *old_folio,
>> +                     struct folio *new_folio)
>> +{
>> +    struct mem_cgroup *memcg;
>> +    long nr_pages = folio_nr_pages(old_folio);
>> +    int old_nid = folio_nid(old_folio);
>> +    int new_nid = folio_nid(new_folio);
>> +
>> +    if (old_nid == new_nid)
>> +        return;
>> +
>> +    guard(rcu)();
>> +
>> +    memcg = folio_memcg(new_folio);
>> +    if (!memcg)
>> +        return;
>> +
>> +    mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, 
>> NODE_DATA(old_nid)),
>> +                   NR_HUGETLB, -nr_pages);
>
> Why not use mod_lruvec_state? mod_memcg_lruvec_state is an internal
> API for memcg, I don't want it to be exported.

Thank you for the review.

mod_lruvec_state() would update the node counter a second time.  It calls
mod_node_page_state() as well, and the target's node counter is already
updated in alloc_hugetlb_folio_nodemask() (patch 1/2):

     lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));

For an uncharged folio lruvec_stat_mod_folio() only updates the node
counter.  The target folio is not charged to any memcg at that point; its
charge only appears later in mem_cgroup_migrate().  So the node side is
already covered and only the per-memcg attribution has to follow the
charge here.

>
> Thanks.
>
>> + mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
>> +                   NR_HUGETLB, nr_pages);
>> +}
>> +
>>   void move_hugetlb_state(struct folio *old_folio, struct folio 
>> *new_folio,
>>               enum migrate_reason reason)
>>   {
>>       struct hstate *h = folio_hstate(old_folio);
>>         hugetlb_cgroup_migrate(old_folio, new_folio);
>> +    move_hugetlb_lruvec_stat(old_folio, new_folio);
>>       folio_set_owner_migrate_reason(new_folio, reason);
>>         /*
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 88824f783571..a5335da5d425 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1015,9 +1015,8 @@ static void __mod_memcg_lruvec_state(struct 
>> mem_cgroup_per_node *pn,
>>       put_cpu();
>>   }
>>   -static void mod_memcg_lruvec_state(struct lruvec *lruvec,
>> -                     enum node_stat_item idx,
>> -                     int val)
>> +void mod_memcg_lruvec_state(struct lruvec *lruvec,
>> +                enum node_stat_item idx, int val)
>>   {
>>       struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>       struct mem_cgroup_per_node *pn;
>>
>
-- 
Best regards,
Hongfu

