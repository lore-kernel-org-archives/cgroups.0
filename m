Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.61
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793319564;
	b=KTTm8QZDwX0E9LTuDmEbvaUjztEyyb7YzAcxG0J1SRg9aAAnAb4Jq2xs3x6dR1GEwN0a
	 ZSNl71D0lEy6lyYQf5uCy82f1Mldh1B8KJ+QjlEjk4z5iGK0FjTVAq5y6muw6CPNxA7K0
	 EpEAWri9CGPIaQZ/Zx0hpZcPFOjHHwljpsWmWLg0ficsCjdNL7L2JYbPs4eqq13ubF/p6
	 S7tW6WDdPP6LLqGdbbQNkAIMWlMSjZJ3sx+aP8kfBm8vSNLsJJNvb8zPAWhBHym+SGxUs
	 9pSg0jTraBZGyV3WyOWAppPCXFI3Yqoj0IiPSfR15xSToUpK7D9jnjmTlWHUwQX8BmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793319564;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=EvTEWT4tzbsI9cJ16jquNJfiv3JAh46yKR+2DLJfzKk=;
	b=bND+KJ+LK02TYoVkxd28PxenEgm8Fx8h+oPPEMABt7QV+aMb1KDsLeOnsNSJv0kQqxKw
	 Z9QaSE2lOr3ukTgXv+JiICvznf69fNmpZkLsTJZiIpB2vNoX1c2TwHT+OTG8phYgB8wSO
	 wSKe0venGd+KKK9iDZz0sPanSB86Nm24gsUHB0nKSxvb6shwyozdJwEDfk57vplLwaBJP
	 h/lw9pg2RzbUcYHTucUITof/QfxI6b5jldjKrzDodb3uhU1uJ8lIts2pHBmmXMDjzQ0os
	 bZERRlwfDfyDTgIB4qh1OxAsU+ZS1uTTCSUNZWolCnTpVL2M8ZpKijp+MvKVuOWPeoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KDUPZmYP;
	arc=none smtp.remote-ip=95.215.58.61
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A91D606A31A
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 00:19:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A91D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KDUPZmYP
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Z5Bh+KyvVIFM4C1bFYYm95MahEVzuEtoL1Ii4Fx+x8w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793319560; v=1; x=1793924360;
 b=KDUPZmYPkk0etsF5vk9qRRVxKTYD8EzUIKCdPb6EubtP3Cl09P3Imioey7zbHsKEtg7YAhqQ
 gPS4J9eJ5znUjmyWVwmm+XBiHnp8fTmUG6FhZ+Gnxd6k8Tsms2Fw7dqtbbpeRkJu7XWJgg+vw/7
 W6Bt3AbPP/qQucrT7q9Azels=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 174ca938c3421467;
	Fri, 30 Oct 2026 00:19:20 +0000
X-Mizu-Trace-ID: 174ca938c3421467
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 17:19:15 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
Message-ID: <auPhT70GU-Zqe9Qy@linux.dev>
References: <20261029204157.117879-1-joannelkoong@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029204157.117879-1-joannelkoong@gmail.com>

On Thu, Oct 29, 2026 at 01:41:57PM -0700, Joanne Koong wrote:
> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
> once per batch, but they update the node and memcg lruvec stats for
> every folio in the batch while holding the lock. Only the LRU lists and
> the memcg lru_zone_size need lru_lock. Updating the stats while holding
> the lru_lock is unnecessary, and they make up a large part of the
> critical section, as seen in [1] where a change that added just a few
> instructions to the memcg stat update path cost about 2% throughput
> because the LRU stat updates run under lru_lock, and the overhead went
> away once they were moved outside of the lock.
> 
> With many threads faulting and freeing memory in a single memcg, about
> half of all cycles are spent waiting for lru_lock, and the hold time of
> the lru_lock directly limits throughput. A perf profile with 80 threads
> faulting in and freeing shmem in a single memcg shows 52.8% of all
> cycles spent spinning on lru_lock, split evenly between
> folio_batch_move_lru() and folios_put_refs(). About 25% of the time
> spent holding lru_lock in those two paths goes to the LRU stat updates,
> mostly cache misses loading pn->memcg, pn->lruvec_stats_percpu and the
> per-cpu counters. The stat updates are only 0.7% of all cycles, but they
> lengthen the critical section that the other threads are waiting on.
> 
> Accumulate the stat changes per LRU list while holding the lock instead,
> and only apply them after dropping the lock (while still inside
> the RCU read section that keeps the lruvec's memcg alive). This moves
> the stat updates out of the lru_lock critical section and turns the
> per-folio updates into at most one update per LRU list per batch.

This updating of stats after dropping the lru lock does introduce one behavior
change i.e. race between reparenting on offlining and stats update. I think it
is safe and correct though. Better to document it.

> 
> The batch is attached to the lruvec while lru_lock is held so that the
> LRU add/del helpers don't need to pass it down. To keep struct lruvec
> from growing, cost_lock is moved into the hole after lru_lock, which
> leaves room for the batch pointer in the same cacheline as lru_lock.
> 
> The stats can now lag behind the LRU lists by one batch, which is well
> within the per-cpu batching they already have.
> 
> On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
> CPUs repeatedly faulting in and freeing memory in a single memcg,
> average pages per second over 7 freshly created memcgs per run, 2 boots
> each:
> 
>                      before    after
>   shmem, 20 threads  4.74M     5.47M   (+15%)
>   shmem, 80 threads  7.94M    10.33M   (+30%)
>   anon,  20 threads  3.04M     3.35M   (+10%)
>   anon,  80 threads  3.23M     3.41M   (+5%)
> 
> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

