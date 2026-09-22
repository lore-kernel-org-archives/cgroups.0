Received: from mta1.migadu.com (out-234.mta1.migadu.com [95.215.58.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCA23876B3
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 02:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790043867; cv=none; b=fmdvKEe35MaBNwOctndOyHX4flQCEgv3mfGoAcBvgQxnPekhKAzi+KNG3lOY08uXfCZ3ELF6yr3+qlXDLDEkHHpcaZ+Q+/CEcy+ewoNsJ52ddb1eK8ebSd8AmaNVuNwPIBCZltvH08qE5emY3310tbyhtnl06L6OiYPnjd4lRdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790043867; c=relaxed/simple;
	bh=DWZKjp4sCqIk8e08lozR04iXNlC3I5VUKgCLN8uovio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApG5oudBj9ZP/9ANOQCOhqx4r+nd5eXC2UW0+lRktruTtrGg6IJqPHCvJ/74wNklQoO+7dh/UhiUcuDvkQw08K/OB93POOreqVKPXotFq2hpro9p8QYvVezJHPUxSjr+CGg++vuAg0bI5Fc95OWhE3OT3XnbIO46w+FAdHhEoh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t4IaOsFw; arc=none smtp.client-ip=95.215.58.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t4IaOsFw"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DWZKjp4sCqIk8e08lozR04iXNlC3I5VUKgCLN8uovio=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790043863; v=1; x=1790648663;
 b=t4IaOsFwT42y5LoTk6Wi5j+VZ7kgkjZsD6fKr/vhVV70mVtBlmonjRMmEX9KKXcnn85wDr0Y
 BUuQhtngeKVwdzpnsv6eQN1y6agd3i3Jm00bSNwUC8QiVHAQifwxHRdN6L4gWbJLji/RhzZ1f7C
 aXZnBDSXmMH8y4BFZ5uI0+ok=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id e4324fc653d572c0;
	Tue, 22 Sep 2026 02:24:23 +0000
X-Mizu-Trace-ID: e4324fc653d572c0
X-Migadu-Flow: FLOW_OUT
Date: Tue, 22 Sep 2026 10:24:16 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH RFC 3/4] mm/vmscan: move struct scan_control to the local
 trace header
Message-ID: <arHm0PVMaG08bq-Z@fedora>
References: <20260921114606.3871820-1-ridong.chen@linux.dev>
 <20260921114606.3871820-4-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921114606.3871820-4-ridong.chen@linux.dev>

On 09/21/26 at 07:46pm, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Now that the vmscan tracepoints live in mm/trace_vmscan.h, move
> struct scan_control there as well so the trace events can reference
> reclaim-internal state directly. The definition is wrapped in its own
> include guard because the trace header is re-read under
> TRACE_HEADER_MULTI_READ, while a C struct may only be defined once.
> 
> No functional change.
> 
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/trace_vmscan.h | 115 ++++++++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c       | 108 -------------------------------------------
>  2 files changed, 115 insertions(+), 108 deletions(-)
> 
> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index c5d824fef554..c8ac5d4e4043 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h

This looks not good, I would rather see it's added in mm/internal.h, or
a new mm/vmscan.h. Putting scan_control in mm/trace_vmscan.h is too weird.

> @@ -9,8 +9,123 @@
>  #include <linux/tracepoint.h>
>  #include <linux/mm.h>
>  #include <linux/memcontrol.h>
> +#include <linux/swap.h>
>  #include <trace/events/mmflags.h>
>  
> +/* Guard the struct against define_trace.h's repeated inclusion. */
> +#ifndef _MM_VMSCAN_INTERNAL_H
> +#define _MM_VMSCAN_INTERNAL_H
> +
> +struct scan_control {
> +	/* How many pages shrink_list() should reclaim */
> +	unsigned long nr_to_reclaim;
> +
> +	/*
> +	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
> +	 * are scanned.
> +	 */
> +	const nodemask_t *nodemask;
> +
> +	/*
> +	 * The memory cgroup that hit its limit and as a result is the
> +	 * primary target of this reclaim invocation.
> +	 */
> +	struct mem_cgroup *target_mem_cgroup;
> +
> +	/*
> +	 * Scan pressure balancing between anon and file LRUs
> +	 */
> +	unsigned long	anon_cost;
> +	unsigned long	file_cost;
> +
> +	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
> +	int *proactive_swappiness;
> +
> +	/* Can active folios be deactivated as part of reclaim? */
> +#define DEACTIVATE_ANON 1
> +#define DEACTIVATE_FILE 2
> +	unsigned int may_deactivate:2;
> +	unsigned int force_deactivate:1;
> +	unsigned int skipped_deactivate:1;
> +
> +	/* zone_reclaim_mode, boost reclaim */
> +	unsigned int may_writepage:1;
> +
> +	/* zone_reclaim_mode */
> +	unsigned int may_unmap:1;
> +
> +	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
> +	unsigned int may_swap:1;
> +
> +	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
> +	unsigned int no_cache_trim_mode:1;
> +
> +	/* Has cache_trim_mode failed at least once? */
> +	unsigned int cache_trim_mode_failed:1;
> +
> +	/* Proactive reclaim invoked by userspace */
> +	unsigned int proactive:1;
> +
> +	/*
> +	 * Cgroup memory below memory.low is protected as long as we
> +	 * don't threaten to OOM. If any cgroup is reclaimed at
> +	 * reduced force or passed over entirely due to its memory.low
> +	 * setting (memcg_low_skipped), and nothing is reclaimed as a
> +	 * result, then go back for one more cycle that reclaims the protected
> +	 * memory (memcg_low_reclaim) to avert OOM.
> +	 */
> +	unsigned int memcg_low_reclaim:1;
> +	unsigned int memcg_low_skipped:1;
> +
> +	/* Shared cgroup tree walk failed, rescan the whole tree */
> +	unsigned int memcg_full_walk:1;
> +
> +	unsigned int hibernation_mode:1;
> +
> +	/* One of the zones is ready for compaction */
> +	unsigned int compaction_ready:1;
> +
> +	/* There is easily reclaimable cold cache in the current node */
> +	unsigned int cache_trim_mode:1;
> +
> +	/* The file folios on the current node are dangerously low */
> +	unsigned int file_is_tiny:1;
> +
> +	/* Always discard instead of demoting to lower tier memory */
> +	unsigned int no_demotion:1;
> +
> +	/* Allocation order */
> +	s8 order;
> +
> +	/* Scan (total_size >> priority) pages at once */
> +	s8 priority;
> +
> +	/* The highest zone to isolate folios for reclaim from */
> +	s8 reclaim_idx;
> +
> +	/* This context's GFP mask */
> +	gfp_t gfp_mask;
> +
> +	/* Incremented by the number of inactive pages that were scanned */
> +	unsigned long nr_scanned;
> +
> +	/* Number of pages freed so far during a call to shrink_zones() */
> +	unsigned long nr_reclaimed;
> +
> +	struct {
> +		unsigned int dirty;
> +		unsigned int congested;
> +		unsigned int writeback;
> +		unsigned int immediate;
> +		unsigned int taken;
> +	} nr;
> +
> +	/* for recording the reclaimed slab by now */
> +	struct reclaim_state reclaim_state;
> +};
> +
> +#endif /* _MM_VMSCAN_INTERNAL_H */
> +
>  #define RECLAIM_WB_ANON		0x0001u
>  #define RECLAIM_WB_FILE		0x0002u
>  #define RECLAIM_WB_MIXED	0x0010u
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0eb7fa8e1d43..2fd9b42f89d8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -73,114 +73,6 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace_vmscan.h"
>  
> -struct scan_control {
> -	/* How many pages shrink_list() should reclaim */
> -	unsigned long nr_to_reclaim;
> -
> -	/*
> -	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
> -	 * are scanned.
> -	 */
> -	const nodemask_t *nodemask;
> -
> -	/*
> -	 * The memory cgroup that hit its limit and as a result is the
> -	 * primary target of this reclaim invocation.
> -	 */
> -	struct mem_cgroup *target_mem_cgroup;
> -
> -	/*
> -	 * Scan pressure balancing between anon and file LRUs
> -	 */
> -	unsigned long	anon_cost;
> -	unsigned long	file_cost;
> -
> -	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
> -	int *proactive_swappiness;
> -
> -	/* Can active folios be deactivated as part of reclaim? */
> -#define DEACTIVATE_ANON 1
> -#define DEACTIVATE_FILE 2
> -	unsigned int may_deactivate:2;
> -	unsigned int force_deactivate:1;
> -	unsigned int skipped_deactivate:1;
> -
> -	/* zone_reclaim_mode, boost reclaim */
> -	unsigned int may_writepage:1;
> -
> -	/* zone_reclaim_mode */
> -	unsigned int may_unmap:1;
> -
> -	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
> -	unsigned int may_swap:1;
> -
> -	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
> -	unsigned int no_cache_trim_mode:1;
> -
> -	/* Has cache_trim_mode failed at least once? */
> -	unsigned int cache_trim_mode_failed:1;
> -
> -	/* Proactive reclaim invoked by userspace */
> -	unsigned int proactive:1;
> -
> -	/*
> -	 * Cgroup memory below memory.low is protected as long as we
> -	 * don't threaten to OOM. If any cgroup is reclaimed at
> -	 * reduced force or passed over entirely due to its memory.low
> -	 * setting (memcg_low_skipped), and nothing is reclaimed as a
> -	 * result, then go back for one more cycle that reclaims the protected
> -	 * memory (memcg_low_reclaim) to avert OOM.
> -	 */
> -	unsigned int memcg_low_reclaim:1;
> -	unsigned int memcg_low_skipped:1;
> -
> -	/* Shared cgroup tree walk failed, rescan the whole tree */
> -	unsigned int memcg_full_walk:1;
> -
> -	unsigned int hibernation_mode:1;
> -
> -	/* One of the zones is ready for compaction */
> -	unsigned int compaction_ready:1;
> -
> -	/* There is easily reclaimable cold cache in the current node */
> -	unsigned int cache_trim_mode:1;
> -
> -	/* The file folios on the current node are dangerously low */
> -	unsigned int file_is_tiny:1;
> -
> -	/* Always discard instead of demoting to lower tier memory */
> -	unsigned int no_demotion:1;
> -
> -	/* Allocation order */
> -	s8 order;
> -
> -	/* Scan (total_size >> priority) pages at once */
> -	s8 priority;
> -
> -	/* The highest zone to isolate folios for reclaim from */
> -	s8 reclaim_idx;
> -
> -	/* This context's GFP mask */
> -	gfp_t gfp_mask;
> -
> -	/* Incremented by the number of inactive pages that were scanned */
> -	unsigned long nr_scanned;
> -
> -	/* Number of pages freed so far during a call to shrink_zones() */
> -	unsigned long nr_reclaimed;
> -
> -	struct {
> -		unsigned int dirty;
> -		unsigned int congested;
> -		unsigned int writeback;
> -		unsigned int immediate;
> -		unsigned int taken;
> -	} nr;
> -
> -	/* for recording the reclaimed slab by now */
> -	struct reclaim_state reclaim_state;
> -};
> -
>  #ifdef ARCH_HAS_PREFETCHW
>  static inline void prefetchw_prev_lru_folio(struct folio *folio,
>  		struct list_head *base)
> -- 
> 2.34.1
> 
