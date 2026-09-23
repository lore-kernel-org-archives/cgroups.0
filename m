Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B77E455162
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790150210; cv=none; b=kAEt8mQiShux/GMYUzKKkGS95jo0Nri3X/035vLxpSFxp9NIqrK9PqxDD8NHv87ni0yxNKFePvwQkNxWuv4aTFJYxp2nvFbTQyMbWuTKf7LHmy7/6sP3jypGWHr6fqhys4MNx+fB5PBVxzeXpns3dN+kzhYK7qvXpQCwAVuEydk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790150210; c=relaxed/simple;
	bh=rE8fsKG8zQi5YMIob2vPd3riVn9pbnpmVF9Jdzvonhw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EnrqO2i4g//9Fikon/7SLh3ztfOhQ0EW8v833ESZs870ui9497z1ytnVR653H8vhksM7u8aUVPX0B+L7Xwmi4Of6JhHKPFo7Y8XGa9XolWNLpYFlGHoC21PcA4ZfXKFYYZ7iS1FoYiYiCQWVLsfievNevWfuNk0lTENhC2DstLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LqIUaMWM; arc=none smtp.client-ip=95.215.58.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LqIUaMWM"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rE8fsKG8zQi5YMIob2vPd3riVn9pbnpmVF9Jdzvonhw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790150206; v=1; x=1790755006;
 b=LqIUaMWMIBxqHNwZjPpHZNtm3U03pv/W5f6cBJYWp3ax1agxjZk7IeUoAnlUNWvjLVx5LC04
 fIfgCm+O0t5TNUrPtOY3nbPZlone5IxLiGE2nbJc0U9C/SJCynVZ+HwzpY9tg1MW9YHRXZqlAX1
 B0ClXtH+EkUfS0M1b2HueFCE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 505b1a229be1cec5;
	Wed, 23 Sep 2026 07:56:45 +0000
X-Mizu-Trace-ID: 505b1a229be1cec5
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <1835413c-e2de-41b0-8225-161afa50676a@linux.dev>
Date: Wed, 23 Sep 2026 15:56:23 +0800
Cc: Hongfu Li <lihongfu@kylinos.cn>,
 Chris Down <chris@chrisdown.name>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 stable@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <10149B0C-4108-4DB6-84B7-A301E8158CA4@linux.dev>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
 <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
 <15ac7069-d687-4985-90bd-25bc900b4bdd@linux.dev>
 <1835413c-e2de-41b0-8225-161afa50676a@linux.dev>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 23, 2026, at 11:40, Hongfu Li <hongfu.li@linux.dev> wrote:
>=20
>=20
> On 9/23/26 10:40 AM, Muchun Song wrote:
>>=20
>>=20
>> On 2026/9/23 10:05, Hongfu Li wrote:
>>> From: Hongfu Li <lihongfu@kylinos.cn>
>>>=20
>>> memory.numa_stat exposes per-node hugetlb counters from per-node =
lruvec
>>> stats. These stats are accounted against folio_nid(): incremented on
>>> the folio's node when handed to a user, decremented when the folio =
is
>>> returned to the pool.
>>>=20
>>> During hugetlb folio migration, mem_cgroup_migrate() moves the =
charge
>>> to the new folio and drops the memcg data of the old one, so the =
free
>>> of the old folio right after the migration skips the memcg per-node
>>> lruvec decrement. The hugetlb count stays attributed to the old node
>>> for the rest of the life of the charge, while the target folio gets =
no
>>> increment on the new node; its later free decrements a counter that
>>> was never incremented.
>>>=20
>>> Migrate the per-node lruvec accounting alongside migration. Global
>>> memcg totals remain balanced because they track resource =
consumption,
>>> not node placement.
>>>=20
>>> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>>> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>>> ---
>>>   include/linux/memcontrol.h |  8 ++++++++
>>>   mm/hugetlb.c               | 25 +++++++++++++++++++++++++
>>>   mm/memcontrol.c            |  5 ++---
>>>   3 files changed, 35 insertions(+), 3 deletions(-)
>>>=20
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index a8358f297b65..74110a324f9e 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -984,6 +984,9 @@ unsigned long lruvec_page_state_monotonic(const =
struct lruvec *lruvec,
>>>   unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>>>                         enum node_stat_item idx);
>>>   +void mod_memcg_lruvec_state(struct lruvec *lruvec,
>>> +                enum node_stat_item idx, int val);
>>> +
>>>   void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>>>   void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>>>   @@ -1452,6 +1455,11 @@ static inline unsigned long =
lruvec_page_state_local(const struct lruvec *lruvec,
>>>       return node_page_state(lruvec_pgdat(lruvec), idx);
>>>   }
>>>   +static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
>>> +                      enum node_stat_item idx, int val)
>>> +{
>>> +}
>>> +
>>>   static inline void mem_cgroup_flush_stats(struct mem_cgroup =
*memcg)
>>>   {
>>>   }
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 519c30b338a8..76d019594b39 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -23,6 +23,7 @@
>>>   #include <linux/mmdebug.h>
>>>   #include <linux/sched/signal.h>
>>>   #include <linux/rmap.h>
>>> +#include <linux/rcupdate.h>
>>>   #include <linux/string_choices.h>
>>>   #include <linux/string_helpers.h>
>>>   #include <linux/swap.h>
>>> @@ -7378,12 +7379,36 @@ void folio_putback_hugetlb(struct folio =
*folio)
>>>       folio_put(folio);
>>>   }
>>>   +static void move_hugetlb_lruvec_stat(struct folio *old_folio,
>>> +                     struct folio *new_folio)
>>> +{
>>> +    struct mem_cgroup *memcg;
>>> +    long nr_pages =3D folio_nr_pages(old_folio);
>>> +    int old_nid =3D folio_nid(old_folio);
>>> +    int new_nid =3D folio_nid(new_folio);
>>> +
>>> +    if (old_nid =3D=3D new_nid)
>>> +        return;
>>> +
>>> +    guard(rcu)();
>>> +
>>> +    memcg =3D folio_memcg(new_folio);
>>> +    if (!memcg)
>>> +        return;
>>> +
>>> +    mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, =
NODE_DATA(old_nid)),
>>> +                   NR_HUGETLB, -nr_pages);
>>=20
>> Why not use mod_lruvec_state? mod_memcg_lruvec_state is an internal
>> API for memcg, I don't want it to be exported.
>=20
> Thank you for the review.
>=20
> mod_lruvec_state() would update the node counter a second time.  It =
calls
> mod_node_page_state() as well, and the target's node counter is =
already
> updated in alloc_hugetlb_folio_nodemask() (patch 1/2):
>=20
>     lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
>=20
> For an uncharged folio lruvec_stat_mod_folio() only updates the node
> counter.  The target folio is not charged to any memcg at that point; =
its
> charge only appears later in mem_cgroup_migrate().  So the node side =
is
> already covered and only the per-memcg attribution has to follow the
> charge here.

Looking at the first patch again, I do not think the
overall accounting is incorrect. My concern is where NR_HUGETLB
accounting is performed.

The low-level allocation helpers only take a folio from the
hugetlb pool. They do not have enough context to decide how
the folio should be accounted. That decision should be left
to their callers, once the folio enters the relevant usage
lifecycle.

hugetlb_alloc_folio() is a good example. It first obtains a
folio, then calls mem_cgroup_charge_hugetlb(), and only
afterwards calls lruvec_stat_mod_folio(). At that point,
the folio has the correct memcg and lruvec, so all relevant
counters can be updated together.

After this series, alloc_hugetlb_folio_reserve() and
alloc_hugetlb_folio_nodemask() account NR_HUGETLB before
returning the folio. This makes them unsuitable for callers
that need to charge the folio afterwards. Before the charge,
lruvec_stat_mod_folio() can update only the node counter.
The later charge does not associate that earlier update with
the new memcg.

If a caller accounts again after charging, the node counter is
updated twice. If it does not, the memcg and per-node lruvec
counters remain missing. The caller then needs a memcg-only
correction, creating a special accounting protocol between
the helper and its callers.

Migration exposes the same issue. The target gets node
accounting before it inherits the source memcg. The second patch
must update the lruvec state and then cancel its node changes,
because the target allocation already updated the node counter.
This works, but makes the accounting lifecycle harder to follow.

Would it be cleaner to keep these helpers focused on allocation
and let each caller account at the correct lifecycle point?
Normal allocation can account after a successful memcg charge.
Migration can move the complete lruvec state after it succeeds.
An uncharged path can explicitly update only the node counter
if global accounting is still required.

This would keep policy out of the low-level allocator and make
the accounting lifecycle easier to follow.

Thanks.

>=20
>>=20
>> Thanks.
>>=20
>>> + mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, =
NODE_DATA(new_nid)),
>>> +                   NR_HUGETLB, nr_pages);
>>> +}
>>> +
>>>   void move_hugetlb_state(struct folio *old_folio, struct folio =
*new_folio,
>>>               enum migrate_reason reason)
>>>   {
>>>       struct hstate *h =3D folio_hstate(old_folio);
>>>         hugetlb_cgroup_migrate(old_folio, new_folio);
>>> +    move_hugetlb_lruvec_stat(old_folio, new_folio);
>>>       folio_set_owner_migrate_reason(new_folio, reason);
>>>         /*
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 88824f783571..a5335da5d425 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -1015,9 +1015,8 @@ static void __mod_memcg_lruvec_state(struct =
mem_cgroup_per_node *pn,
>>>       put_cpu();
>>>   }
>>>   -static void mod_memcg_lruvec_state(struct lruvec *lruvec,
>>> -                     enum node_stat_item idx,
>>> -                     int val)
>>> +void mod_memcg_lruvec_state(struct lruvec *lruvec,
>>> +                enum node_stat_item idx, int val)
>>>   {
>>>       struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>>>       struct mem_cgroup_per_node *pn;
>>>=20
>>=20
> --=20
> Best regards,
> Hongfu


