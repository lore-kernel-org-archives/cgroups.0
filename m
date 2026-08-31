Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ACD449ED7
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 16:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194276; cv=none; b=i27tYjaxXAbpuPLGIqre5GXJBUxFDehff4VWx1wc3HHaakBHSxE729Da7cnL6Af7thNQx6B4QLYUOMwajpg+na0pWzMb1/vLnJVtdsgrY1KAmBe5/7Q4g013eToV0aMRB+5SOhBr+LhIW1xh2lLmYw0+o2NJY65pGI68ShrnYt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194276; c=relaxed/simple;
	bh=2Amgsqpgsx7PlZQDAm/FD23kxr8Yl8KnC8gzujy5Bfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YQdrRGTNoyAoOnuyGzjx9XAOWUojNOe3EUGc4ZnAwV9/X45DqUHrG6aMNXPc+JmCjXr6SSTdDvWab+k6fwNEshmdq9T0Jbv+4fYKqtRGAbslaQccIX5f8NymSfuIh+NS1h3UdH5320K5kuDzhEN0svkB9G8DY1MiVvQKcNdb9ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vj2QBSlP; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vj2QBSlP"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6b0fd2ddea2so1403185eaf.3
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 09:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194274; x=1788799074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jHXBYg66UBEqhTnn/X5o4cskQbf8hKecJ7lklGtPMOg=;
        b=Vj2QBSlPwZyIB93Q8WpMvElkiwv5NaQIO1IqthTHs4QkalUsvA4leDAs5CYumOB/3b
         /rt/Fq+fwpuwW2IJZOuklHhv1oRdMXaLHXemVZJ6IY9MzHwxbJGfkL/9z9ItVxAhV0Fj
         Gx7zThT78DLbQj64X2k2U89CChLsB9i1zCu1ZMCK5Dm6QW9aCv8j1Y6XykRa8PlxCYUq
         Dly60blkwdDZl4KaBcBDDFu5tiB0MuFoYspTeuVhTiPUG1fclENmHexmxE8FKo/Qkfo6
         pT6GKgF0dMwKew3CacIJDR2zAMksKRsGOGTymnS5HjAikmfixoAroZIFVTBktXD+a12L
         IoWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194274; x=1788799074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jHXBYg66UBEqhTnn/X5o4cskQbf8hKecJ7lklGtPMOg=;
        b=YorLnkJVbx1X5QP6OAsuehUKQWhhY3HQddJkXAWGF46pzDxuPfu99CzSnHbQBXhWl/
         0J6QzL8KGEig095/uWGq5EBrw1Phs+fVYHIQgSXp+W1flXAcQT1sDaYyGGkzBvdCabAF
         gKvy1WwS9mv25DWSHPrWyokac/tSzhUWhGPhE5FpppxK2aGZb3Xco+4xzSXtsP7NF3gt
         bfbBkUIlOddo6lOiRV5B7BD5176h7j1129VB8rxAFGbMPphe0yyBzA4GfJes+3VBYoVO
         rtnSzPTsvlwQV/Uh280R9pW74tE9SSy+nHVul8y2lMFfa1lVt+erC3mAzfeVkLDwr7re
         2cMw==
X-Forwarded-Encrypted: i=1; AHgh+RpuR7Hleb82OpKyBHvq6WlAIX0KyJ6z0DzrIOOxvIcOTW9/JEW2yP98XwK6C6HO0++xe9GYTIAw@vger.kernel.org
X-Gm-Message-State: AFuF++mKD2tXNyfI7OK3BcxSptk32wFv2i5P8OpW/cEL736PIAUoCOyv
	p0HnUR5fU8u8GIL0ltUBzb4opc9AKMr1fZ6fVMPBiOQ4hINIRwSvO6lu
X-Gm-Gg: AR+sD12gs8lgP+5uMlIS5m2FE/udlyb4bV4G3QVYYNkehOCvAh3H5gINMRUc7EMjkAm
	w8m/vS1nLwVLk+Uk5cyM62/TYmwURkL3E0T81j7T0N/w7iY5Wdlfbc2KfeRjYo8NrOBusdcG5W0
	YJKlKuzL4105d/s5epkaCHIjH8LGbpAqQtu3M4HKixmb+Vqy+6BiOIyFlHLmZ8IQ7gMamASwmjg
	G8NM/J2qwGXMW8/DqjJFiTgHasGmY9O2be3DXauWAYJySp3gvsCWFHOz1jAqTcrN7+Mr4VWGzmG
	4krb+JEzs5WHQtwc/Y46LcQc8wKRwquclhG3mdlkbkKvlHviR9pHgObzd7J4wAWiIv0S1nlVN7L
	jnqupbSjaNunGsXg9iphPJ3ZuLXW20G2tgrKh7Q5hjQsujpUVOLML+Tuzg1myZFANk71LIdQebm
	3iZziZm1PxMm/YFd0kpnq/1hkQiQjObpszUdlZkq3EeHASun++lImasw3yX7eRohnpqjSMfirY3
	PqyiE30+J5hOXrsFnY=
X-Received: by 2002:a05:6820:f02d:b0:6a1:77ce:1b09 with SMTP id 006d021491bc7-6b372ca85d5mr1858404eaf.6.1788194273632;
        Mon, 31 Aug 2026 09:37:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a3535e25sm10291971fac.5.2026.08.31.09.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 0/7] move stock from mem_cgroup to page_counter
Date: Mon, 31 Aug 2026 09:37:44 -0700
Message-ID: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4 --> v5
=========
- The stock is now a raw_spinlock_t and an unsigned long to more closely
  match the original semantics of the stock code.
- Draining is asynchronous again, we add a work_struct per-page_counter
  (not percpu) that walks every cpu. This eliminates the concerns
  of doing a synchronous drain.
- page_counter_try_charge transparently handles stock.
- Addressed the netperf regression by reworking the refill path to match
  the vanilla uncharge path more closely.
- Correctness fixes for the percpu pointer access usage
- More testing to demonstrate that this series achieves its goal.
- Included Shakeel's stock watermarks from [1].
- Wordsmithing

INTRO
=====
Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
allocations, allowing small and frequent allocations to avoid walking
the expensive mem_cgroup hierarchy traversal each time. This fastpath
offers real improvements, but there is room for improvement:
1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
   more than 7 mem_cgroups have stock present on a single CPU, a random
   victim is evicted and its associated stock is drained.
2. When one cgroup runs out of memory and needs to drain stock across
   all CPUs it has stock cached in, those CPUs will drain all other
   memcgs' stock present in that CPU. This leads to inefficient stock
   caching and cross-memcg interference under memory pressure.
3. Stock management is tightly coupled to struct mem_cgroup, which makes
   it difficult to add a new page_counter to mem_cgroup and have
   multiple sources of stock management.

This series moves the per-cpu stock down into page_counter, so that
page_counter_try_charge() transparently serves a charge from the stock
and refills it, and each counter owns and drains its own cache. This
eliminates the 7 memcg-per-cpu slot limit, the random cross-memcg stock
drains, and the slot traversal.

In turn, we can add independent stock management for additional
page_counters in each memcg, which is used in my tiered memory limits
series to add a new page_counter to track toptier usage [2]. Patch 7
uses it to give memsw its own stock.

Because the stock is now a property of the counter rather than of the
cpu, it is also reachable remotely, so draining no longer has to run on
the cpu that owns the cache.

This series preserves as much of the old semantics as possible,
including non-spinning safety by using trylocks for stock access.
The old !allow_spinning semantics in try_charge_memcg are slightly
different now though; outside NMI, page_counter_try_charge may perform
a speculative batch charge and a refill.

TRADEOFFS
=========
These are disclosed in the individual changelogs, I've also accumulated
them here so we can discuss them in one place.
1. The bound on pre-charged-but-unused memory is raised, from
   NR_MEMCG_STOCK * 64 * nr_cpus pages system-wide to
   nr_memcgs * 64 * nr_cpus. Because a child's stock is charged all the
   way up the hierarchy, an ancestor's memory.current -- and therefore
   its limit enforcement -- includes whatever its descendants cached.
   These are not "real" allocated pages and are returned under pressure,
   but the ceiling the old 7-slot design provided is gone.
2. struct page_counter grows from 192 to 256 bytes to accommodate the
   new struct work_struct.
3. cgroup v1 only: memsw.usage - memory.usage is no longer exactly swap
   usage, since the batch charges may go out of sync.
4. The stock lock is a raw_spinlock_t taken with trylock, where the memcg
   stock used local_trylock_t. Two cpus can now contend for the same
   counter's stock.
5. drain_all_stock() now queues work per-memcg, instead of per-CPU.

TESTING
=======
We can demonstrate the effects of the finer-grained stock draining by
creating a synthetic workload which allocates a batch of pages, then
yields. This is meant to demonstrate that prior to this series, a 4 page
charge could refill 64 pages worth of stock, but have it stolen away
if it didn't use all of it before yielding.

In the table below, the "batch" parameter is how many pages a workload
allocates before yielding. The measured metric shows how many refills
are needed to fault 64 pages. A higher number indicates more work needs
to be done to fault (charge) the same number of pages.

	+-------------------+
	| refills/64 faults |
+-------+----------+--------+
| batch | baseline | series |
+-------+----------+--------+
|     4 |    14.34 |      1 |
|     8 |     7.12 |      1 |
|    16 |     3.56 |      1 |
|    32 |     1.78 |      1 |
|    64 |        1 |      1 |
+-------+----------+--------+

This is reflected in throughput in this microbenchmark:

        +---------------------+
	|      faults/s       |
+-------+----------+----------+-------+
| batch | baseline |  series  | delta |
+-------+----------+----------+-------+
|     4 | 11487696 | 23825483 | +107% |
|     8 | 18408472 | 25869537 | +41%  |
|    16 | 24882465 | 26915403 | +8.2% |
|    32 | 27987869 | 27912912 | -0.3% |
|    64 | 29096451 | 28853936 | -0.8% |
+-------+----------+----------+-------+

Throughout testing outside this edge case across 4 to 64 memcgs per-cpu
led to negligible (within 1%) performance deltas. The microbenchmarks
above are just to demonstrate that refills become more efficient as we
do round-robin evictions less often.

CHANGELOG
=========
v3 --> v4:
- Reduced memory footprint by 4x, from 16 bytes per-(cpu x memcg) to
  4 bytes per-(cpu x memcg). Each page_counter_stock is a thin wrapper
  around an atomic_t.
- Removed locking completely and uses atomic operations to use stock.
- Removed synchronous work_on_cpu. All work is done via remote
  atomic_xchgs.
- Added a patch to flatten page_counter charging in try_charge_memcg
- Split page_counter_try_charge into stocked and non-stocked variants.

v2 --> v3:
- Dropped the cgroup v2 optimization, since it could indeed lead to too
  much time held with the cgroup_mutex. Instead we let the stock
  accumulate in the parent cgroups, which is not so bad; charges can
  still land on these cgroups, and if we ever reach the mem_cgroup
  limit, we can easily return those charges.
- page_counter_disable_stock no longer drains, just prevents
  accumulating stock. The actual draining is done in the free_stock
  variant, where we know for sure there are no in-flight charges.
- Reordering the page_counter_disable_stock path to disable before
  draining as to prevent accumulating stock first.
- Skip isolated CPUs when draining synchronously
- Rebase on newest mm-new
- Wordsmithing

v1 --> v2:
- Dropped stock returning on uncharge to preserve same behavior as memcg
  stock. This resolves some race conditions present in v1.
- Fixed many race conditions between disabling page_counter_stock and
  in-flight charges
- Restructured drain_all_stock to iterate over all CPUs first before
  memcgs, to reduce the number of synchronous CPU work scheduling
- Optimized cgroup v2 further to drain only on the first child and skip
  the root mem_cgroup
- Dropped RFC
- Wordsmithing cover letter

Based on latest mm-new as of August 31, 2026: "da6c37ed8beb2
mm/swap, PM: hibernate: atomically replace hibernation pin"

[1] https://lore.kernel.org/linux-mm/20260820012010.2016086-1-shakeel.butt@linux.dev/
[2] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/

Joshua Hahn (7):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: report the number of pages charged
  mm/page_counter: introduce per-page_counter stock
  mm/page_counter: use stock in page_counter_try_charge
  mm/page_counter: introduce an asynchronous drainer
  mm/memcontrol: convert memcg to use page_counter_stock
  mm/memcontrol: add stock to the memsw page_counter

 include/linux/page_counter.h |  23 ++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |   2 +-
 mm/memcontrol.c              | 308 ++++++-----------------------------
 mm/page_counter.c            | 272 +++++++++++++++++++++++++++++--
 6 files changed, 334 insertions(+), 275 deletions(-)

-- 
2.53.0-Meta
