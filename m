Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D833341D112
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 08:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787040744; cv=none; b=iT3APuxkZ45y1LVWpTVP9pje3VrUCSw/601H0YWwdN9PM0kIS9rObA/ovgD8JzsYCe1cbOfuywQUSLSYgjnHPU8BB0s0lLOw621jouVC1o/nrkgVB7zUlzNpf9TyvgUlz/zqzipiHmU0ak7yyU1/JwlTj612XjlyId0/5SX3Rpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787040744; c=relaxed/simple;
	bh=/O5o1FHjVH37EIJy88MmF697mrTbkLgyx5ASqlKRYB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EuJen5d0oDlFmNicnZeUW2EGYVaNsqtAZDs18Tz+pNbYLsGY7bBCC+FDiJqqNAFaNgSjRVweWEJw3sBC+woifcYy6Ct1yPPbyolKcy4HN6mwCliG82Ke72YHNCCI+ECn0qf9cex0q/Dy7GM7pDHUgc0ypdmXVUPteKUXx5dT56Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dI0XtZkC; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dI0XtZkC"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47fecbb7000so2314604f8f.2
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 01:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787040741; x=1787645541; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ut+xbTDj7ZhkvGJB+feKg7bYPoIX3tceZd+RikWwvEg=;
        b=dI0XtZkC+N2NEZ8HGRLM4oH5jVR+MxKMAfjrG4uzVEbZk+cBHgovLR9sJpXZ41+THh
         mpeNNcS9CQu4eb5OdtGRyOnZ8v8Zsx1nI3DXtvwCN+Sy2AepbIpVMyU6IArBM7I7LP6g
         L2AP2BpiM3Cs3FWsHvzuFtEttLGVPmGSgOkbFsU1mM2zKPyFscYX6Jmc2XAu7ZMEE6AL
         u+Y2/ariTJJ2b9I5JcA4EkT/bvp5WBuAvBXUYGW8sV8aDJ27NkG4bfu8xbKovK0JbQUr
         0mI9FdEnVL7FKxOiiTohDI9iIFS7YTjjsCy2QL0GEaUZOlTGIwrTofUEiFcofSltola7
         5LJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787040741; x=1787645541;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ut+xbTDj7ZhkvGJB+feKg7bYPoIX3tceZd+RikWwvEg=;
        b=n3CeJHhoO0G7JGiyb9C8nGT36ejKbtFWtcjtUvTPXcJca/TrmGcjrDIOjRsZP8YE54
         DO1xNfc6LNBtAkXs0AMnxeDI35eAh+Z8fo8U1+w0uxZ9DO/UbOa2pEit0C4/9On4M2nC
         UksjrDICqTUaw1Wl5tk8Whk9tAiNGApN6tP2YKvyq1QHG9gljvXrG15xUEaQX0N63J/E
         3IABI2pW3HOTTV1bbZfy5BeWdR4FQFtisuWJUCEJhltilacidkFJXdOo7yi236aW0EZZ
         AYB5j3G5Dzzt8ZSxmjJhxlwZIsYi/k/fO4W0qGKE9H4u8qiDe9mfPOO7sFk2CBnQDzKp
         ZfVg==
X-Forwarded-Encrypted: i=1; AHgh+RotMjc98Jm4wzVun0VwDrcWGHnhJ7ODZeZJh0BfyFYUufugma6PTSWFhfUlrQ1JcdhcUyMqpTGw@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4e15COOEum1Y0eoHAFHUY+w8SLTWbPn0WMyDXUUI8Wc5AuUNX
	OflB2MY+TVTYQkLLYerlmvV+3jhOY0nAZnggomdc7Ho5MhbdkvUAFYr+Mbil4T7jaho=
X-Gm-Gg: AR+sD10uEwO7R7SX0GVqOxlylIV5ma9v1Uh2mjfkDfGDQeHtJMJwBy5SlHr3EJL9N3q
	X8oPw+y6bIVSpziXxo8i54EtweFJYXi9F2V3mRKDXb0IqXjizwiavTmErrh50piq8ex1ltLjUof
	x2MExHjJiA/+x7OyxSZyAvbPCDXMMHSKVegr/HVsaAKrbM+ymhOxzMYfBD+LzFKSnOe3IV77bSw
	SsVyPaEbFasWdD29eL1kUjupGhnmBvENoBjcHf4Vvn6OkLftKTcMqnsdox4K4K6Z/j4a1l8yVQk
	4F+wZcIhSROqBETNJPU52HFpqXfhRXHLKgpOW1wAgqMub2vX8APrjqees9B/XvL6MSoudhtesKu
	qJel/7kz/mNH+t/htF/HGWCQhpgRXu057gDRrG5KpXhdkd0OT6mbmkJQzkF6RcRR4U6CDF2In4+
	DJJZG9zIG76nKTo5pnMgVJhB1XrkjW/Hs8FiR2BY/cgBu9i4692AIVQgYrS6bORAQj7EJ+/qs=
X-Received: by 2002:adf:f708:0:b0:47f:aead:f81b with SMTP id ffacd0b85a97d-48160756569mr38056944f8f.21.1787040740958;
        Tue, 18 Aug 2026 01:12:20 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b77fa3sm9726073f8f.26.2026.08.18.01.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 01:12:20 -0700 (PDT)
Date: Tue, 18 Aug 2026 10:12:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: liuqiqi@kylinos.cn, Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory
 accounting and control
Message-ID: <aoQT45_Vu8KZ9rjk@tiehlicka>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>

Are you aware of a similar work in this area by Joshua
https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/T/#u?
We owe Joshua review feedback for quite some time but if I have to be
honest the most impeding factor on my end is that I am not really
convinced tier aware controlling is the right direction. I have
expressed some concerns on one of the earlier proposal by Joshua
https://lore.kernel.org/all/aZ2LC0KPF0xsAwAL@tiehlicka/T/#u

In any way it would be great to talk and compare your approaches see
where they align and the discuss further.

On Tue 18-08-26 10:31:13, liuqiqi@kylinos.cn wrote:
> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> This RFC introduces per-tier memory cgroup accounting. Each cgroup
> tracks its memory usage per memory tier (e.g. DRAM, CXL), exposed
> through a new memory.tier control file that reports per-tier usage
> and accepts independent high (soft) and max (hard) limits per tier.
> By default these limits are auto-derived from memory.high / memory.max
> based on per-tier capacity ratios, and can be manually overridden.
> 
> The implementation integrates with the existing memory tiering and
> demotion infrastructure. Per-tier usage (anonymous and file) is tracked
> via dedicated page counters, and cross-tier migrations (e.g. demotion
> from DRAM to CXL) correctly re-account charges. When a tier hits its
> high limit, async reclaim is triggered within that tier's NUMA nodes;
> exceeding max enforces reclaim scoped to the tier's own nodes, or OOM.
> 
> The feature is fully opt-in. When disabled, no extra counters or
> charge/uncharge paths are created, memory.tier reads empty, and there
> is no measurable overhead.
> 
> Why per-tier limits?
> -------------------
> 
> On tiered memory systems, memory.max constrains total usage but cannot
> express "keep fast-tier usage under X". Without per-tier limits, a
> workload can monopolise DRAM, pushing other cgroups onto slower tiers.
> This series gives each cgroup independent high (soft) and max (hard)
> limits per tier, exposed and set through a new memory.tier file.
> 
> By default those limits auto-derive from memory.high / memory.max by
> capacity ratio; writing memory.tier pins a tier.
> 
> This series takes a different approach from Joshua Hahn's toptier RFC [1],
> tracking a separate page_counter per (memcg, tier) for N-tier support and
> exposing writable per-tier limits under a cgroup mount option.
> 
> Patch structure
> ---------------
> 
>   1/8  mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
>   2/8  mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
>   3/8  mm/memcontrol: add per-tier page counter infrastructure and lifecycle
>   4/8  mm/memcontrol: add per-tier charge and uncharge
>   5/8  mm/memcontrol: add per-cpu stock for tier charge/uncharge
>   6/8  mm/memcontrol: add memory.tier control file
>   7/8  mm/memcontrol: auto-derive tier high/max from memory.high/max
>   8/8  cgroup: add memory_tiered_limits cgroup mount option
> 
> Patches 1-2 are infrastructure (helpers in memory-tiers and vmscan).
> Patches 3-5 add the core accounting: counter lifecycle (3),
> per-page charge/uncharge (4), and stock batching (5).
> Patch 6 adds the userspace file. Patch 7 adds auto-derivation. Patch 8
> gates everything behind a mount option + kernel cmdline, so the feature
> adds no measurable overhead when not opted in.
> 
> Usage
> -----
> 
> Boot with:
> 
>   cgroup_memory_tiered_limits=1
> 
> Or remount at runtime (affects newly created cgroups only):
> 
>   mount -o remount,memory_tiered_limits /sys/fs/cgroup
> 
> Per-tier limits and usage can then be read from and written to
> memory.tier.
> 
> Scope and limitations
> ---------------------
> 
> - Only LRU folios (anonymous and file pages) are tier-accounted. Kernel
>   memory and socket buffers are not yet accounted per tier; support for
>   these is planned as follow-up work.
> - Per-tier memory.min and memory.low protections are not implemented.
>   These can be added later by extending the per-tier interface to
>   expose and enforce min/low protection.
> - The command-line parameter mirrors cgroup_favordynmods; automatic
>   enablement via the cgroup mount path is left to userspace.
> 
> Testing
> -------
> 
> Tested on QEMU with fake NUMA (DRAM tier 4 + CXL tier 22), with
> cgroup_memory_tiered_limits=1 on the kernel command line and demotion
> enabled.
> 
> Set up a cgroup, apply per-tier limits, and run a memory-intensive
> workload:
> 
>   $ mkdir /sys/fs/cgroup/mycgroup
>   $ cd /sys/fs/cgroup/mycgroup
>   $ echo "tier4.high=200000000" > memory.tier
>   $ echo "tier4.max=300000000" > memory.tier
>   $ echo 1 > /sys/kernel/mm/numa/demotion_enabled
>   $ cgexec -g memory:/mycgroup ~/stream --ntimes 5 --malloc &
>   $ cat memory.tier
>   tier4.current=296488960
>   tier4.high=199999488
>   tier4.max=299999232
>   tier22.current=1625464832
>   tier22.high=max
>   tier22.max=max
> 
> DRAM (tier4) usage stays under tier4.max (hard limit, no OOM) but exceeds
> tier4.high (soft limit, suggesting that async reclaim is in progress);
> CXL (tier22) absorbs the overflow via demotion.
> 
> Also verified:
>   - tierN.current tracks per-tier usage (anon + file).
>   - Cross-tier migration (demotion) correctly re-accounts.
>   - memory.high / memory.max auto-derives tierN.high / tierN.max.
>   - Manual override (writing a number to memory.tier) pins the limit.
>   - Tier max enforcement triggers reclaim scoped to the tier's nodes.
>   - Feature fully off (no mount option): no counters, no charge/uncharge,
>     memory.tier exists but reads empty.
> 
> Open questions
> --------------
> 
> - Should kmem/slab tier accounting be included in this series or deferred
>   to a follow-up?
> - Should per-tier memory.min and memory.low protection be part of this
>   series or left for later?
> 
> [1] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/
> 
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> Qiqi Liu (8):
>   mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
>   mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
>   mm/memcontrol: add per-tier page counter infrastructure and lifecycle
>   mm/memcontrol: add per-tier charge and uncharge
>   mm/memcontrol: add per-cpu stock for tier charge/uncharge
>   mm/memcontrol: add memory.tier control file
>   mm/memcontrol: auto-derive tier high/max from memory.high/max
>   cgroup: add memory_tiered_limits cgroup mount option
> 
>  include/linux/cgroup-defs.h  |   5 +
>  include/linux/memcontrol.h   |  26 ++
>  include/linux/memory-tiers.h |  12 +
>  include/linux/swap.h         |   6 +
>  kernel/cgroup/cgroup.c       |  21 +
>  mm/memcontrol.c              | 786 ++++++++++++++++++++++++++++++++++-
>  mm/memory-tiers.c            |  58 +++
>  mm/vmscan.c                  |  26 +-
>  8 files changed, 936 insertions(+), 4 deletions(-)
> 
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs
