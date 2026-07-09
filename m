Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CA41C84CB
	for <cgroups@vger.kernel.org>; Thu,  9 Jul 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607076; cv=none; b=Bxsunok0u3hiD0g8GkJM4Np1NyR7WaKZk+V1DdeTwsQPeCJJrPE1OHg7+eQ7BsVHzA1Lj4n2KC0NdTJ8kYM/udHPl53HWB65H2IuIN8EwWrA5hJMHyVBikghICgPpykZThWu2fvP0hORjKgQe+vqFGx83ffxZNkP3bHutZHAaFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607076; c=relaxed/simple;
	bh=tIHEGyT5ldvtsed8frzfaU4agFhwf0M8sm55kkXf0oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPKIRlPV3mL6XSRrOJnudua98rTqy3YwWIjQ356YENirLpvzqLGZKh98Gl8vu1uM5hiOb/nMpFI9uSU2SltnScqe23kS5eDbgP8747qO6Cz27nyWE71aUNQ7ivOm2V/vEdeIk5sNdcjP93ANdW5ZcXGuZkMsS5iKp8CcatHNGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Btk+aZVn; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Btk+aZVn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783607062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EUy+Ri2pT7wvVY/ajX0BV3e3H7R/seUWuMeezghtcHk=;
	b=Btk+aZVnVrfetD0/oZcoqxzqskUtquanN86nBAQQy2GMIakYKxG6K18qS76Eb9X434e39/
	TvJH+sZo7/dtDfDgg+nTqQa5FHgW7AALn/bO2K+ZBt7ZDy5exPzUJd+zdv2IRElB9yMvXd
	Q9FVDnwysjJC2HD9vFL2xq2PDCIZK9k=
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Subject: Re: [PATCH 0/1] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Thu,  9 Jul 2026 07:24:11 -0700
Message-ID: <20260709142412.91707-1-usama.arif@linux.dev>
In-Reply-To: <20260706122954.3552990-1-usama.arif@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon,  6 Jul 2026 05:28:25 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> The anon/file scan balance heuristic in get_scan_count() is fed by two
> scalars in struct lruvec (anon_cost, file_cost) that every reclaim
> producer updates under lruvec->lru_lock. The cost-recording work
> itself is trivial, but it both contends for and contributes to
> contention on lru_lock - which is often a contention point on
> memory-pressured workloads. Specifically:
> 
> - shrink_inactive_list() re-acquires lru_lock at function exit just
>   to call lru_note_cost_unlock_irq().
> - shrink_active_list() does the same after rotation accounting.
> - workingset_refault() takes folio_lruvec_lock_irq() purely to
>   record the refault cost.
> - prepare_scan_control() snapshots anon_cost/file_cost under
>   lru_lock.
> - lru_note_cost_unlock_irq() itself walks parent_lruvec() and
>   re-acquires lru_lock on every ancestor, multiplying the cost
>   of every update by memcg-hierarchy depth.
> 
> This patch removes those producer-side acquisitions entirely. The
> producer-local inputs (PGROTATE_*, PGRECLAIM_PAGEOUT_*) become
> per-LRU vmstat counters; WORKINGSET_RESTORE_* already captures the
> refault input. prepare_scan_control() reads the raw cost signal
> lock-free from those vmstats and folds the delta into a per-lruvec
> accumulator. A dedicated per-lruvec cost_lock, not touched by
> isolate_lru_folios(), move_folios_to_lru(), or folio_add_lru(),
> serialises the accumulator RMW and the lrusize/4 halving check.
> Hierarchy aggregation is implicit in rstat propagation, so the
> parent_lruvec() walk and the lru_reparent_memcg() cost-splice both
> disappear.

Another update on this, I was profiling another Meta workload that suffers
from very heavy reclaim and has a lot of cgroups. I ran:

bpftrace -q -e 'profile:hz:99 { @[kstack, comm] = count(); }'

The biggest entry was below:
@[
        lru_note_cost_unlock_irq+146
        shrink_lruvec+1913
        shrink_node+869
        do_try_to_free_pages+197
        try_to_free_mem_cgroup_pages+311
        __mem_cgroup_charge+1832
        filemap_add_folio+127
        page_cache_ra_unbounded+347
        filemap_fault+956
        __do_fault+40
        handle_mm_fault+4034
        do_user_addr_fault+406
        exc_page_fault+105
        asm_exc_page_fault+34
, Func___]: 5354

5354 represents 51.42% of all kernel samples collected.

A very signifcant amount of time was being spent just in lru_note_cost_unlock_irq
