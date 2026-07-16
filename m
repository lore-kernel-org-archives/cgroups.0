Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB681389115
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182030; cv=none; b=jpKn7Y5e/zes6hYZlK6RgWnuhG6YT7FRhx/bJbyJ5FWDJ04FjPL1CSB4VXqsd7u922tv1fTHpoDYxo5n8iVGVa7b+mPQYRYzqUkmYT5NjkLJGlr3vekfuISyxJXwkfRTHSOli7SanVz9J7t5aa73sa2geV6f1cJ8dlkLHaHojv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182030; c=relaxed/simple;
	bh=gdoFLsig6j4EFae6D9gJqSqmuDlEvqM1nvk/C9roJoI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z2AG7Ie/Y4oXDVYX7rIsqq+kPiEWUfH8bXXGFWmf69tjmTnPIWRy4aggtatkOv6Dno/pXXgSlBU3+zNzJJAmO1//vrH928WmwF5PO+IFF4TMpVLu9ByEB/LMAupBV3FOOVPklx863B+VjZIuFQU4IWLnoD3PbZWwFRGQDYzNt50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uAX/WdVg; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uAX/WdVg"
Message-ID: <c500efef-93d2-481d-8193-44b2822f76e2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784182025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P/P4Th/0tUd4b2Kq0qhZuqkwJXjiWeWYKkS1TJBpFWE=;
	b=uAX/WdVgvqTN7dCCpUlZVP6groObBfXT8bUANKnMUOvi3WPzfcGXEYwXWk0KlbO6Z7ylSh
	GzbW6Kjef7N1m9ceQFhd/pQKPc98hjYbzN+dW1/1gBH8Odi7QfDssgQNvIXMY8nW845r1n
	INVudtNmyWmS7lt5weK6O2vK2m2W838=
Date: Thu, 16 Jul 2026 14:06:58 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 1/2] memcg: move mem_cgroup_swappiness and
 vm_swappiness to mm/swap.h
To: Ridong <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-2-ridong.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260716031729.1064007-2-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


Reviewed-by: Song Hu <husong@kylinos.cn>
在 2026/7/16 11:17, Ridong 写道:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The per-memcg swappiness knob is v1-only; v2 always uses global
> vm_swappiness and ignores the per-cgroup field.
> 
> Both mem_cgroup_swappiness() and vm_swappiness are only used within
> mm/ (memcontrol.c, memcontrol-v1.c, vmscan.c), so move them out of the
> public include/linux/swap.h into the mm-private mm/swap.h. This keeps
> unrelated declarations out of include/linux/swap.h.
> 
> Guard memcg->swappiness with CONFIG_MEMCG_V1 as well, so v2-only
> kernels drop the unused field.
> 
> No functional change for v1; v2-only kernels drop the unused field.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/linux/memcontrol.h |  4 ++--
>  include/linux/swap.h       | 19 -------------------
>  mm/memcontrol.c            |  4 ++--
>  mm/swap.h                  | 20 ++++++++++++++++++++
>  4 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 957260677678..e7a794dfb40e 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -239,8 +239,6 @@ struct mem_cgroup {
>  	 */
>  	bool oom_group;
>  
> -	int swappiness;
> -
>  	/* memory.events and memory.events.local */
>  	struct cgroup_file events_file;
>  	struct cgroup_file events_local_file;
> @@ -318,6 +316,8 @@ struct mem_cgroup {
>  	/* List of events which userspace want to receive */
>  	struct list_head event_list;
>  	spinlock_t event_list_lock;
> +
> +	int swappiness;
>  #endif /* CONFIG_MEMCG_V1 */
>  
>  	struct mem_cgroup_per_node *nodeinfo[];
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 696ed01709c2..330a420fd6de 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -309,7 +309,6 @@ static inline bool lru_cache_disabled(void)
>  }
>  
>  extern unsigned long shrink_all_memory(unsigned long nr_pages);
> -extern int vm_swappiness;
>  long remove_mapping(struct address_space *mapping, struct folio *folio);
>  
>  #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
> @@ -468,25 +467,7 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
>  }
>  #endif /* CONFIG_SWAP */
>  #ifdef CONFIG_MEMCG
> -static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> -{
> -	/* Cgroup2 doesn't have per-cgroup swappiness */
> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> -		return READ_ONCE(vm_swappiness);
> -
> -	/* root ? */
> -	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> -		return READ_ONCE(vm_swappiness);
> -
> -	return READ_ONCE(memcg->swappiness);
> -}
> -
>  void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
> -#else
> -static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> -{
> -	return READ_ONCE(vm_swappiness);
> -}
>  #endif
>  
>  #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22f55aeb94f3..d6ba276740ea 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -63,6 +63,7 @@
>  #include <linux/sched/isolation.h>
>  #include <linux/kmemleak.h>
>  #include "internal.h"
> +#include "swap.h"
>  #include "swap_table.h"
>  #include <net/sock.h>
>  #include <net/ip.h>
> @@ -4174,11 +4175,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  #endif
>  	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
>  	if (parent) {
> -		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
> -
>  		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
>  		page_counter_init(&memcg->swap, &parent->swap, false);
>  #ifdef CONFIG_MEMCG_V1
> +		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
>  		memcg->memory.track_failcnt = !memcg_on_dfl;
>  		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
>  		page_counter_init(&memcg->kmem, &parent->kmem, false);
> diff --git a/mm/swap.h b/mm/swap.h
> index b51ad3071a73..a0e04b97a466 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/atomic.h> /* for atomic_long_t */
>  #include <linux/mm.h> /* for PAGE_SHIFT */
> +#include <linux/memcontrol.h> /* for mem_cgroup_swappiness() */
>  struct mempolicy;
>  struct swap_iocb;
>  struct swap_memcg_table;
> @@ -76,6 +77,25 @@ enum swap_cluster_flags {
>  	CLUSTER_FLAG_MAX,
>  };
>  
> +extern int vm_swappiness;
> +
> +static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> +{
> +#ifdef CONFIG_MEMCG_V1
> +	/* Cgroup2 doesn't have per-cgroup swappiness */
> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return READ_ONCE(vm_swappiness);
> +
> +	/* root ? */
> +	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> +		return READ_ONCE(vm_swappiness);
> +
> +	return READ_ONCE(memcg->swappiness);
> +#else
> +	return READ_ONCE(vm_swappiness);
> +#endif
> +}
> +
>  #ifdef CONFIG_SWAP
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */

