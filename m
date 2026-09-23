Received: from mta1.migadu.com (out-93.mta1.migadu.com [95.215.58.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2A5266581
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 02:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790131238; cv=none; b=i2MYZvcBC6VjCzB2vJNaN9MgpimMxWi3RMg98WAKh3TXE6NYgqbnvVfxEshqae26zlnE4wLGGtwAYYfLbO7a/1GLg2LWf5EQyp6BPwvgnTn+WqSKj/YcRDDFfJzS8d4DcSwl/za9uI1hqmXao+NKhJN7kuZtvjwSjBBkpjCPKtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790131238; c=relaxed/simple;
	bh=j+Y4V2mMNGYI+hceNSPMN7m7nsV8dKsfzNn4H+9807E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ENRPqm2YdoVfb+mpQ22WnOIvRQVMM26DqUwG5LDdWvHvDUS0wNZrLjqG+5GSJ8nJNO7cbi9yC1Py66RwDk3TQc//Q1hbbGyl+54TdsGUMHqPEqfzPhMa/v+ZUDODZnXVgICA59MYARcR/973S7FptYyVdTZ8KMru/9oh570AbEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CfpXMI5a; arc=none smtp.client-ip=95.215.58.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CfpXMI5a"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j+Y4V2mMNGYI+hceNSPMN7m7nsV8dKsfzNn4H+9807E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790131230; v=1; x=1790736030;
 b=CfpXMI5aTccg0TDiztH2M7y0sI8ldiU1pQ5qll35wjmNGh/C9kJ77aqN/x5dEDCfKsTDyfXE
 0IgqoO6zHiiVemsWUYQaNf78HpvdzZoJhCagQR9jEgnMFfRvT+GAyhF0A8Joo4Aa7kX+whzGgsT
 5zLmtkMOTdtHHMpAYyYRZ6fc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 41c7d1fbf26606a1;
	Wed, 23 Sep 2026 02:40:30 +0000
X-Mizu-Trace-ID: 41c7d1fbf26606a1
X-Migadu-Flow: FLOW_OUT
Message-ID: <15ac7069-d687-4985-90bd-25bc900b4bdd@linux.dev>
Date: Wed, 23 Sep 2026 10:40:22 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: Chris Down <chris@chrisdown.name>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org, Hongfu Li <hongfu.li@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
 <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/9/23 10:05, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
> stats. These stats are accounted against folio_nid(): incremented on
> the folio's node when handed to a user, decremented when the folio is
> returned to the pool.
>
> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> to the new folio and drops the memcg data of the old one, so the free
> of the old folio right after the migration skips the memcg per-node
> lruvec decrement. The hugetlb count stays attributed to the old node
> for the rest of the life of the charge, while the target folio gets no
> increment on the new node; its later free decrements a counter that
> was never incremented.
>
> Migrate the per-node lruvec accounting alongside migration. Global
> memcg totals remain balanced because they track resource consumption,
> not node placement.
>
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> ---
>   include/linux/memcontrol.h |  8 ++++++++
>   mm/hugetlb.c               | 25 +++++++++++++++++++++++++
>   mm/memcontrol.c            |  5 ++---
>   3 files changed, 35 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index a8358f297b65..74110a324f9e 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -984,6 +984,9 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
>   unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>   				      enum node_stat_item idx);
>   
> +void mod_memcg_lruvec_state(struct lruvec *lruvec,
> +			    enum node_stat_item idx, int val);
> +
>   void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>   void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>   
> @@ -1452,6 +1455,11 @@ static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>   	return node_page_state(lruvec_pgdat(lruvec), idx);
>   }
>   
> +static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
> +					  enum node_stat_item idx, int val)
> +{
> +}
> +
>   static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>   {
>   }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 519c30b338a8..76d019594b39 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -23,6 +23,7 @@
>   #include <linux/mmdebug.h>
>   #include <linux/sched/signal.h>
>   #include <linux/rmap.h>
> +#include <linux/rcupdate.h>
>   #include <linux/string_choices.h>
>   #include <linux/string_helpers.h>
>   #include <linux/swap.h>
> @@ -7378,12 +7379,36 @@ void folio_putback_hugetlb(struct folio *folio)
>   	folio_put(folio);
>   }
>   
> +static void move_hugetlb_lruvec_stat(struct folio *old_folio,
> +				     struct folio *new_folio)
> +{
> +	struct mem_cgroup *memcg;
> +	long nr_pages = folio_nr_pages(old_folio);
> +	int old_nid = folio_nid(old_folio);
> +	int new_nid = folio_nid(new_folio);
> +
> +	if (old_nid == new_nid)
> +		return;
> +
> +	guard(rcu)();
> +
> +	memcg = folio_memcg(new_folio);
> +	if (!memcg)
> +		return;
> +
> +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
> +			       NR_HUGETLB, -nr_pages);

Why not use mod_lruvec_state? mod_memcg_lruvec_state is an internal
API for memcg, I don't want it to be exported.

Thanks.

> +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
> +			       NR_HUGETLB, nr_pages);
> +}
> +
>   void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
>   			enum migrate_reason reason)
>   {
>   	struct hstate *h = folio_hstate(old_folio);
>   
>   	hugetlb_cgroup_migrate(old_folio, new_folio);
> +	move_hugetlb_lruvec_stat(old_folio, new_folio);
>   	folio_set_owner_migrate_reason(new_folio, reason);
>   
>   	/*
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 88824f783571..a5335da5d425 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1015,9 +1015,8 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>   	put_cpu();
>   }
>   
> -static void mod_memcg_lruvec_state(struct lruvec *lruvec,
> -				     enum node_stat_item idx,
> -				     int val)
> +void mod_memcg_lruvec_state(struct lruvec *lruvec,
> +			    enum node_stat_item idx, int val)
>   {
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   	struct mem_cgroup_per_node *pn;
>

