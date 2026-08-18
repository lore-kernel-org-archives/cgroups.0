Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BC13793C3
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 15:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787068200; cv=none; b=kFIBOM/YwuNTui3bx9a5dxEFm6E+M+MxzR4NrUqKEo3PHREcX/Jg3VEonLbez6tDdCmnCYOzQrq/w1aykjThhiKIaQ2UowEm4PBXaEiHtVSiPC6Fz4nm+6KkAyFHLLf1yXg0fmztt9czT2lsJXTZ3ItSwPAi9V59EfuL7I5DtNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787068200; c=relaxed/simple;
	bh=MpF1sz2FMhtGhLzFkleD2772OFA9lXn3c/fOv6rXd2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZO/cPw9jKHD6TTz77KZ0dRUqoTtjxCxbe76/yWsupyFZGhTfWx6Eutb/RcoYYDCen5CRbmLcKF+tGe9rKXokCD8V3zfSTq6pOF2H8JT+cbZJ//kAIO3ywm+gFnZ+GXSqC8XJcAmo+A6sizjSNJaLe7Ws/vZl7RqQgIog/ZoSXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1GhNczD; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1GhNczD"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6b12942ed04so15688eaf.1
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 08:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787068197; x=1787672997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O29WTaUjniaazmvc0G9Gs9N2gTRaT/iDFSjz7U1NMko=;
        b=F1GhNczDd5n3PIfeGtRPgYa7+zs7yrXWkUD8os31b4U82AWXT7afnNCCyBf+qPHYi2
         tcZSBt+ryQdM+xKAGRMG16w89+a4wHI9fqPKf7qsiBgxTp0+nqFwmZn4eIFaxMXuJqLS
         qj1eW6BW30Zz6JFZbdhrj/vumT74ryLQhytKIukFB1eWxFlZXtItpnkVlWrGROQCs2xs
         2nxoys4bbQZlKu7f/L0CPpx7six4BH0MSxWJRl+WUBB2tVkzz1HqMERxOfonEwpdbWQ+
         q3YEVc2DEBgnF5hKf0Ypxx6f66/amUyFnfA57U/Yuvi9GEXcga9Xh2cn/2PFo2jNv1XE
         UhUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787068197; x=1787672997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O29WTaUjniaazmvc0G9Gs9N2gTRaT/iDFSjz7U1NMko=;
        b=fwqzFWTRKmKI2BuIYAM7sa93+pxempIPQY6xiU2Xjyc8IgMqiTcYQMv/rp7UCS6fj7
         TjhCXDAPK2pJo7sJZX3XjLWvV0jGDFm+zO/HFOCB1bOWnYBBsRGMQ908OZk1oFbb5JgR
         bEt6SD3UM/0YCE229Cm0T3wrzcZKvYWvevQl+uLhp9mNAa0Dw/KK4aJ5d1Iz7guFm9Nn
         RYU9jEm6C8zkgJe1ZsT1JmpanmV6wa4NlG4cMlLRblYBLGnXltgy1oGTvUSCCwqknYfb
         XsSyEh7n9kauasVLHCrRDOD+spmIVdZuGs+o3py3Wh/TOqkL5P1xfA4p60RyYRN2TEmY
         RRTg==
X-Forwarded-Encrypted: i=1; AHgh+RqNMY8EiwT4qih0q6oB8qRKWmv5LfpAjMsJtRGt7Z1etIAbodGiVWq2OX9CIUZO7jERAxeVUXn0@vger.kernel.org
X-Gm-Message-State: AOJu0YxMfWIgn0d8aZMh1Opv6fg8bAjlXhCX/XWTtCCK8Jce5m79fIWo
	kPEfCk24E5UQ5iXCew4nIcvrdRqYxLcdZiCRqXYCSrxHDYs119NllSQoBYdFmg==
X-Gm-Gg: AR+sD12/wSuWzmILpbXS4bryQPF5pliAfu0EXxBhLA40ApYlVd6Fgdwkg/1+pipn16V
	g54ZaKANa6bMjY5ooOhDEMeD3jHY54VSSLAI8kSPs6vU149MkLki0Z7uEn2mmDoKzOXz+UblNM3
	tU/74LuAZ2r2/i53BXcMLrNFcc2QjKQQ7JtpPBgKX9dzfuoNCmG0FNjoADXaexa/0fi+kATcONY
	qxyOYZ7R5xzLVhWPQekjbyEPBGHLdj+6VMOvCheY2cUZXJSB1bqP6sLjvuJu1/M3i5hoB2MnT5n
	vk/tzWcX2he/Gi/aaAF+X6HONbhXNYPUiCluY6IWsnTaxfJJoJsrdNAnONQP8ZPTqSEg4xRnGhx
	j3t4ke4djlASQrS651ZRP5rzoTD9IQ5/gBDwJes6owCAbVsDJ13Qklxbe+ZLyOlhOG/OzT8X+Xv
	R0apyosZwqG+bLtRKjRUtndHt4g7FVZVMNGD9QUbmVU9bAtmnWhcCMzu4sGbjidZi4IwS1Gkesa
	l0W9kOnrXppCDi6l8I=
X-Received: by 2002:a05:6820:1795:b0:6a3:bdc5:591a with SMTP id 006d021491bc7-6b0d6919fd2mr29904034eaf.32.1787068196884;
        Tue, 18 Aug 2026 08:49:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:17::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b1166bc727sm5033553eaf.11.2026.08.18.08.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 08:49:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: liuqiqi@kylinos.cn
Cc: linux-mm@kvack.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory accounting and control
Date: Tue, 18 Aug 2026 08:49:53 -0700
Message-ID: <20260818154954.805958-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 18 Aug 2026 10:31:13 +0800 liuqiqi@kylinos.cn wrote:

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

Hi Qiqi,

Thanks for sending the series. I'm glad that there is additional interest
in making tiered limits in the system. In this series, I do see a lot
of duplicate work with my work here [2]. It looks like you cited [1]
which is an older version of the series that I sent out. Notably the
new version has N-tier support and a cgroup mount option.

Also consider my series in [3] where I am moving stock to the
page_counter level. It's been a while, but I'm hoping to send out a new
version of that series next week.

With all of that considered, I wanted to know what differences your RFC
here has with my series. From where I stand, the only difference I can
see was making the limits exposed / writable, which was an explicit
design decision that I made to de-clutter the memcg tuning space and
try to make the mechanism as transparent to the user as possible.

The other parts of the series (per-tier reclaim, per-tier-memcg
page_counter accounting, auto-scaling high/max from memory.high/max)
seems to be the same as my series.

Rather than duplicate our effort I think it would be best to foucs all
of our effort and the maintainers' effort into discussing the design
decisions for the series.

Joshua

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

[2] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/
[3] https://lore.kernel.org/all/20260623180124.868655-1-joshua.hahnjy@gmail.com/
