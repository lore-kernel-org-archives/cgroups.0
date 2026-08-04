Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7520F481241;
	Tue,  4 Aug 2026 17:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785863845; cv=none; b=EC15MW1hOKN+hXWpSeL5mduavQJbNQO3pMniwqvdp02mmq1qApW2Pu4B7UZRQjFMDfjqqtcGeKGLEOymFIVwAeyi60z2668XDN7M0OB1ZE1zhPTpCnujn3xTK7k8qABMhDo1WAWr5vlIF9Hf9i3LET0e4i+6pi+QDysNiR9a5nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785863845; c=relaxed/simple;
	bh=c2Jx0jK9GHxlZxEEFjwuvHIuqw/Osa5R7BEFv8oO/78=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L81ZoEk8UI5R9zW8MZtSd4VAI71tuSSWRzduKg6W7/QjQ76kjv8K/6HOvma5gllaw/RfovExcjAc3B0HKZJiHrfak7yttrRpvO+DYQ9H+3nFSA7ARcreBeS/aHZu8S4mxfDur9x91xcn7gDwYCVnd9rG11N8lcx89McJCVrI6CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwBfps2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwBfps2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D601F000E9;
	Tue,  4 Aug 2026 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785863831;
	bh=J19P9P6+ypat/OvYRKtICP+Obahh1CzQhSviP26PwVM=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=AwBfps2xwIykpE1Z2NV6S4OZDKZOxIC4vaRgBzCHqVlRGKyU2UJHFFDDTNZ7o2sza
	 frhAZK+MTE0MsyGoY1llOM3iJWO527/XtMoo0HE0HkjGpAiBtpNaex5sz8AAg0kkeT
	 SbepXc+0fw4p/vKTGYKwhHKayur0/FR+SO5skpa9HMNomgQUakdNWDpId3HaZyRc0e
	 ACHKKHrxYd5+IXQRT8DYBLlgIUgydvZ4byJHJEkTPlTCXtjqCpl3tRXxeHyja3PpQY
	 dXqCxEFlHQvdPQPRRw66sj6V6Tqw+za0zoN1znkD+myqYRSnKpSs/JsHPSYzTO4vHG
	 OR5N0J8xIV2ow==
Message-ID: <f2820a92-a694-4dbb-90b3-503a83b7eb4c@kernel.org>
Date: Tue, 4 Aug 2026 19:17:04 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Content-Language: en-US
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, hannes@cmpxchg.org, roman.gushchin@linux.dev,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, rientjes@google.com, kernel-team@meta.com
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-4-usama.arif@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260727162550.2032-4-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/27/26 18:23, Usama Arif wrote:
> The anon/file scan balance in get_scan_count() is driven by two scalars
> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
> producer under lruvec->lru_lock. The acquisition sites for cost work
> specifically are:
> 
>   - shrink_inactive_list() re-takes lru_lock at function exit purely
>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
>     nr_reclaimed). One acquisition per inactive shrink.
>   - shrink_active_list() does the same with (0, nr_rotated). One
>     acquisition per active shrink.
>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
>     purely to record the refault cost. One acquisition per refault.
>   - prepare_scan_control() takes lru_lock just to snapshot the two
>     scalars into sc->{anon,file}_cost.
>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
>     re-acquires lru_lock on each ancestor to propagate the update,
>     adding O(memcg-depth) acquisitions per producer call.
> 
> This hurts because lru_lock is already a heavy contention point on
> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
> and folio_add_lru() takes it. The cost work itself is trivial (two
> scalar bumps and one comparison), but it contends with and causes
> contention for actual LRU manipulation. The parent_lruvec() walk also
> multiplies cost-update overhead by memcg hierarchy depth.
> 
> The balance formula for anon and file, respectively, is this:
> 
>     cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> 
> Instead of recording cost and running averaging logic directly when
> these events occur, snapshot running vmstat counters once per reclaim
> cycle and derive the balance from event deltas since the last run.
> 
> Use PGROTATE_* from the preceding patch for the rotation input.
> WORKINGSET_RESTORE_* and NR_VMSCAN_WRITE provide the remaining event
> counters. Charge NR_VMSCAN_WRITE through lruvec stats so all inputs can
> be sampled per lruvec and aggregated through the memcg hierarchy. This
> is overall cheaper and has fewer lock acquisition sites.
> 
> Moving accumulation and decay to the reclaim side also improves the cost
> model across reclaim gaps. With producer-side decay, events that happen
> while reclaim is idle still age each other before reclaim ever samples
> the costs. If a workload refaults a large anon set and then a smaller
> file set before reclaim runs again, the later file activity can age the
> earlier anon activity out of the cost model. The new scheme observes the
> whole between-reclaim delta and decays anon and file proportionally, so
> the scan-balance history better represents what happened since the last
> reclaim pass.
> 
> A dedicated per-lruvec spinlock, cost_lock, serialises the delta
> extraction, the cost->count update and the halving loop against
> concurrent reclaimers in the same memcg+node.
> 
> NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
> no longer needed and is removed.
> 
> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> cost[].count instead of the removed lruvec anon_cost/file_cost fields.
> The reported values only refresh when prepare_scan_control() runs and
> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> they express is unchanged.
> 
> Under pure MGLRU the scan-balance signal itself is not consumed (both
> prepare_scan_control() and get_scan_count() are short-circuited on the
> MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
> on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
> anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
> either reclaim implementation. The preceding patch also bumps
> PGROTATE_{ANON,FILE} from evict_folios(), so rotation-driven reclaim
> work is accounted consistently across both implementations.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

