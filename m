Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E86418A59
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 13:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785160636; cv=none; b=F7RFT8d9OmzGr9pOXonp8en/nN4oeeaG7/W8MHbVzG+5X0I2p6V9NIl5pn6sdxOrimZzwzJKtBNehyOeaFuJwG+wOI9F8eqUzMVrQWErfTKX04KcNjmfNOjTQU5ZGtyuZfDqqo0UGzzao56lvxthn1LOj+XuwqUa/kmCyWuRHFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785160636; c=relaxed/simple;
	bh=T4ShyHHSh+hbiimhZBM8iqSVCDmJs1eSqB4zGzZjn5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9QUuNktIFVNvNeYAOfKTFg5iahlGMX3F+1SglUKk6be8+8fJwC4htXBj2cSCDB0F7d31F+7FS2xhs6pPbqecbHKjeh4FN/YVUA2WXfyIcNl/CCobynO7dAkd8vgEu6bSeR3PPruAt4Tx94CBldIlgEm+aCL0CiPMYjdXwWLkC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=cJKbAgH6; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="cJKbAgH6"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-902f92b8504so19567006d6.2
        for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 06:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785160631; x=1785765431; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dv5JiNRF60oQDhK8RjpXqzwpwgZnaK0KnGMf0oeIKbw=;
        b=cJKbAgH6mAJuyb5RtKrHFVAFrKEGbzF3IdiO58DEzDfcJsAhZjeGeosFoN+5BeIVS/
         OOW2SVMJKVIkarUWFzLN2LPIrLNGCpr1iJtGNM+qFMhuV/eIJU1IDkvlHWu2Kg1sIOzu
         nVSKYk18L3koHSVrZPB+hfJ1V2Q3/94f9rFsGOOoqGwRApyXMNm4d9SJcZFLzgr9FHIS
         rJniS3cMO5WV4cOKAHaU0mymB/qKKYWsbDuHl9FRIuNm+ejMhRFwGQxJdueFHU29co7i
         cOwfdj4YGX884G0MyuWRgNvWNCm9LfToarNFP3hRp1WFvcu9BHsiTjKrejvuMFcoei/6
         1Uhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785160631; x=1785765431;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dv5JiNRF60oQDhK8RjpXqzwpwgZnaK0KnGMf0oeIKbw=;
        b=Lyt7aUmHvK14uJqE7Yi8cY7FFNjzX2cxaTqHdH7gE5jAkEfehkfq02s4O8raIoQavO
         lVcis3YSkj7VWTxVpriti1s87Pl8GaTn1UYnN6KHDxLukgi4g6Ad6Oolx0PlQd+sM7S6
         VQG/LK3ShgpECpsVOFGXrkg0e7qFDkC32LXyaPea1ILyNrjEqhWK9nWfLE1cyP8R3M4X
         ijWGYxmE+PD/kEJlV4YkSvh7hNiPLRs9CVz2wZrsVAKg1Uh+UKQ0yj0aPCZmlscfBCFj
         D0m5DSItIcM5Fg229OpMjPiSuiWlw6zAwQblzqahCWtAkwzfdJh05jaoet/I4YViU64j
         WdGQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq1LnSNU9sfnq8FTEDWNZ3KSuSann9O6xGXbo61BrBTDMVGh3nNdlNUkTkUWo0HdWpBhFWf0P9X@vger.kernel.org
X-Gm-Message-State: AOJu0YwckNY+s5dQMOQ5yRjEdVvPGSHStdDvnjfxYI5DOwuWYDS9Whkg
	St0iAcYHwr4rIY9IMKaq3uvowsGQtXnc1jcli9Vg4oXEDnz5VjOeDmZf1wZAEGCtc10=
X-Gm-Gg: AR+sD11r1DRqxxD2qnHmhdSvliYpIu0+UrirpxcNABVzrAWQ11Q7kFJpTBj0664bhJH
	ADjxl2m1TFcfJjGvNC0G5+Knpe3HtcRMT2+CUq94AMPDVEBMCFKmqnZx5oLt7Qw9Ie7sctGKFld
	dwUVVQljQEII4t+v+qKC3rxy66aIpCRl6wLpT+78gmKivW+cWNxJoM/Y5fSXq0+gK5vlFIoEmmx
	l4A50UUM+2nGyoFpOvD+S8xEW6upfk6nvmIBgT7s+5BrT2RNEI0u0lsd0gypmlURJrBgimum8+1
	KTNujmAaHo4GRPsQncjuJUwcWeBnphTPWvpjORWPU98lMa6ZIaLKSyVnJ9NV+JC+i+FuoVWomV/
	QkvbLUKYg96sWaOaLVEUKtFEiLna56X27n3JxfUb/bIfXFT9fXgcTZd3zPBMOtgSpsUwoWG6lGS
	+A
X-Received: by 2002:a05:6214:4108:b0:8f0:367c:eb80 with SMTP id 6a1803df08f44-907ec7898b2mr107227636d6.25.1785160630232;
        Mon, 27 Jul 2026 06:57:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e85275a6sm65855326d6.3.2026.07.27.06.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 06:57:09 -0700 (PDT)
Date: Mon, 27 Jul 2026 09:57:05 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amdjsVuNYW98Q--Z@cmpxchg.org>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
 <amK-ApfqfwkPheC5@linux.dev>
 <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
 <amOv0MlF1S-oFZHX@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amOv0MlF1S-oFZHX@cmpxchg.org>

On Fri, Jul 24, 2026 at 02:32:52PM -0400, Johannes Weiner wrote:
> On Fri, Jul 24, 2026 at 02:29:23PM +0100, Usama Arif wrote:
> > 
> > 
> > On 24/07/2026 02:53, Shakeel Butt wrote:
> > > On Mon, Jul 20, 2026 at 09:41:23AM -0700, Usama Arif wrote:
> > >> The anon/file scan balance in get_scan_count() is driven by two scalars
> > >> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
> > >> producer under lruvec->lru_lock. The acquisition sites for cost work
> > >> specifically are:
> > >>
> > >>   - shrink_inactive_list() re-takes lru_lock at function exit purely
> > >>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
> > >>     nr_reclaimed). One acquisition per inactive shrink.
> > >>   - shrink_active_list() does the same with (0, nr_rotated). One
> > >>     acquisition per active shrink.
> > >>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
> > >>     purely to record the refault cost. One acquisition per refault.
> > >>   - prepare_scan_control() takes lru_lock just to snapshot the two
> > >>     scalars into sc->{anon,file}_cost.
> > >>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
> > >>     re-acquires lru_lock on each ancestor to propagate the update,
> > >>     adding O(memcg-depth) acquisitions per producer call.
> > >>
> > >> This hurts because lru_lock is already a heavy contention point on
> > >> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
> > >> and folio_add_lru() takes it. The cost work itself is trivial (two
> > >> scalar bumps and one comparison), but it contends with and causes
> > >> contention for actual LRU manipulation. The parent_lruvec() walk also
> > >> multiplies cost-update overhead by memcg hierarchy depth.
> > >>
> > >> Replace the producer-side accumulators with a read-side accumulator fed
> > >> from per-LRU vmstat counters. The old producer formula was:
> > >>
> > >>   cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> > >>
> > >> Reuse NR_VMSCAN_WRITE for reclaim-driven anon pageout submissions. It is
> > >> already bumped by writeout() for the same successful outcome that fed
> > >> reclaim_stat.nr_pageout. Reclaim does not submit filesystem folios from
> > >> this path, so there is no file pageout term. Charge NR_VMSCAN_WRITE via
> > >> lruvec_stat_mod_folio() and include it in memcg_node_stat_items so it can
> > >> be sampled per lruvec and aggregated through the memcg hierarchy.
> > >>
> > >> Add explicit PGROTATE_{ANON,FILE} node_stat counters for the remaining
> > >> producer-local input. They are bumped from shrink_inactive_list() by
> > >> nr_scanned - nr_reclaimed and from shrink_active_list() by nr_rotated.
> > >> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
> > >> lru_note_cost_refault() used to bill.
> > >>
> > >> Add a per-side struct lru_cost { count, last_rotated, last_io } to
> > >> struct lruvec. In prepare_scan_control() the two monotonic inputs are
> > >> sampled separately - rotated from PGROTATE_ANON/FILE, io from
> > >> WORKINGSET_RESTORE_BASE + f plus (for anon) NR_VMSCAN_WRITE - and the
> > >> raw per-side deltas are computed against cost->last_rotated and
> > >> cost->last_io before the SWAP_CLUSTER_MAX IO weighting is applied.
> > >> Extracting the deltas from the individual counters (rather than from a
> > >> pre-weighted sum) keeps the unsigned modular subtraction bounded by the
> > >> true per-counter growth, so a signed-long wraparound of any underlying
> > >> vmstat still yields the correct delta on 32-bit. The weighted delta is
> > >> folded into cost->count. Since one vmstat delta can cover many producer
> > >> events between reclaim passes, halve cost->count on both sides until
> > >> their sum is back within the lrusize/4 bound instead of halving only
> > >> once.
> > >>
> > >> Moving accumulation and decay to the reclaim side also improves the cost
> > >> model across reclaim gaps. With producer-side decay, events that happen
> > >> while reclaim is idle still age each other before reclaim ever samples
> > >> the costs. If a workload refaults a large anon set and then a smaller
> > >> file set before reclaim runs again, the later file activity can age the
> > >> earlier anon activity out of the cost model. The new scheme observes the
> > >> whole between-reclaim delta and decays anon and file proportionally, so
> > >> the scan-balance history better represents what happened since the last
> > >> reclaim pass.
> > >>
> > >> A dedicated per-lruvec spinlock, cost_lock, serialises the delta
> > >> extraction, the cost->count update and the halving loop against
> > >> concurrent reclaimers in the same memcg+node.
> > >>
> > >> Hierarchy aggregation is now implicit in the vmstat accounting. The
> > >> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
> > >> existed only because anon_cost/file_cost were private lruvec fields. With
> > >> the cost expressed as lruvec vmstats, rstat propagates the underlying
> > >> counters through the memcg hierarchy and prepare_scan_control() consumes
> > >> the same ratelimited rstat view as the surrounding reclaim heuristics.
> > >>
> > >> NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
> > >> no longer needed and is removed.
> > >>
> > >> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> > >> cost[].count instead of the removed lruvec anon_cost/file_cost fields.
> > >> The reported values only refresh when prepare_scan_control() runs and
> > >> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> > >> they express is unchanged.
> > >>
> > >> Under pure MGLRU the scan-balance signal itself is not consumed (both
> > >> prepare_scan_control() and get_scan_count() are short-circuited on the
> > >> MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
> > >> on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
> > >> anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
> > >> either reclaim implementation, and PGROTATE_{ANON,FILE} are bumped from
> > >> evict_folios() so per-memcg observability of rotation-driven reclaim work
> > >> stays consistent across both implementations.
> > >>
> > >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > > 
> > > Oh man too long commit message, please follow Johannes's suggestion.
> > 
> > Will do!
> > > 
> > > The patch looks good but I have one question. We already have concept of
> > > pgrotated through /proc/vmstat which represents number of pages we have moved to
> > > the tail of inactive LRU to make them next reclaim candidates. This patch is
> > > exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
> > > the number of pages we scanned but didn't reclaim plus number of pages given one
> > > more trip in the active LRU.
> > > 
> > > Older and newer pgrotate metrics kind of represent something different. It may
> > > cause confusion. Now before suggesting to change the name, let me ask do we
> > > really need to expose these to the userspace? How exactly users can use these
> > > new metrics? I think you can use them here without exposing to userspace. So,
> > > does it makes sense to delay userspace exposure later when we have a more solid
> > > usecase for that unless you have it already.
> > > 
> > 
> > I do think the userspace counters have diagnostic value. They can be another metric
> > to show how much anon/file reclaim work is spent on pages that are not immediately
> > reclaimed, including pages retained on actie LRU. It could help explain if there
> > is elevated reclaim CPU usage.
> 
> Hm, this is an interesting discussion.
> 
> The existing PGROTATED is kind of useless. When it's bumped:
> 
> - truncation fails and moves folios to the LRU tail for faster reclaim
> - writeback ends on folio that was tried to reclaim, moves to LRU tail for fast retry
> 
> Ok, who needs to know this? The new counters you're adding, on the
> other hand, they capture the information you frequently need for
> understanding reclaim behavior.
> 
> That said, looking closer at this one more time, you can already
> (almost) derive them fully from existing counters:
> 
> drotated = (dPGSCAN_ANON - dPGSTEAL_ANON) + dPGDEACTIVATE_ANON

Talking with Usama offlist, there are two problems with this:

- PGDEACTIVATE is obviously wrong. We want the the pages we don't
  deactivate (hot file executables)

- PGSCAN includes things that didn't work out due to caller
  restrictions (reclaim_idx) and race conditions (tryget, !lru) that
  shouldn't contribute to the balance.

So let's go with PGROTATE as Usama proposed.

But I'm against hiding them from the vmstats.

I'd rather remove or rename the existing one if we're worried about
confusion. We've historically applied a much lower bar to vmstat
stability. It's geared towards understanding detailed MM behavior
behavior, which undergoes constant changes.
