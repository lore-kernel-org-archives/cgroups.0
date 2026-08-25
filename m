Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F84488777
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671965; cv=none; b=emX3uCXdaH//0DyChO7aN1IstjGLk9NW3Rw856NkxQiXtJ87H7P06sAi58pBuvw7Dznyu6TMI33xu56Qi7mUW0iHB7p/ZhG5ME30lHQH9tEaLJ57EPi0IObywndkwfLrjnmvRtGLh2+oh3iF2Sta8Sr10mM/CPQI+rOTjv1mScw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671965; c=relaxed/simple;
	bh=RdVPGJkKcgK7hdNUTnWABVGsowQ5Oco49SkxjVsIvd0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tzJaPdVUodldShwBS7caj9tcAOqB7+ovmJj5DNGM1N7HRvdkivf6iXFZEXm+T7uAZxrdZ6Kf8r0JRtQB+zkHrVttTcbT95c1faUnWtS2nHXPt8ioJM5UlfsVer3SZ50Rl20fPP+CmfmmahrdeubdcPoZIOE8BQEyJdIGOjt+M/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=odFD/UM+; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="odFD/UM+"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-44cf70de986so3390982fac.0
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671960; x=1788276760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TWTPFXRnJO3wBcI8WMuuM4Fkhk9C3h07kfsXs96xXog=;
        b=odFD/UM+1j4XxLFbyPab62qVbZLBMiVsHjz0SeBPcCbKGjL0Dy91gWg3kZV1/B8dqr
         bCS3IXes1ED95LxGE/fKhhYDxWs88FUNwa/ynE81an400xSwvmXalJCTJ3UWrfzlKTjb
         JNOICMurqvVvlNUqJr9NTqwxGQEszYUyUItI0AUd3zUr189RJXZaxsalkcGsHq7+BgOT
         qdVp5EMQSPdiiNoWoa1p/R5WtcKCOpl8aLsOTt+24ek+9Vycxnc9REwPUpukgehhyCF+
         dSPIfCl/6u+ENm+CUIru7YtdpHL8iMjpBPOnPzbqqsGtC9nXwvSjETHR7u1ekdqGpoA4
         ZCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671960; x=1788276760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TWTPFXRnJO3wBcI8WMuuM4Fkhk9C3h07kfsXs96xXog=;
        b=pO8joheKHPkCbQLPPX/vUInhRPM9hTQwW4xpn9TFXq8vv8d2Asj+pBJytEiYssr283
         l+DDAjiP1r/h38FP7beIGy+6z6i5rXhB57ybRvhLw1y89oTM/aTzUakQ66LXmg0HrumF
         tqhqTD4Icd6y/khpbq2dR1e36kHEQXlqWMvu8G77xDYZdgVSxbjp6K8y5/zpyXjRusNe
         kA5ghqhgYafqbrCWCA0h14lTtdooaigl5yvX9GU3gdhQrsYoR2yqCHlC5DZiJ1Ym1DvZ
         mu5762yOL28HmobCZdw8CTBcKxSCYsL+cHafRVmaDQALxZZwIbYB3356WM9APj1AuaC2
         Pr5g==
X-Forwarded-Encrypted: i=1; AHgh+RpI/S8bE3qInnAmgvq2GYw2ZZFZFMarrkbtnfrtEuHEQfKnebfDL80Ng26ghsVFXMUc57ubIn2r@vger.kernel.org
X-Gm-Message-State: AFuF++lA8vEkrvYlLwr+NJNfBPvthiP6V9+eAwzezbTkekIWTfuZo0Hw
	0qBtVGIS1TsNSDxRf8VIY4TatigPNyeI009phwE/CL/3h0kFsy57K1U7
X-Gm-Gg: AR+sD110jp926RAWzWK9BcsJUlVrlLVmMbDrV8M15hi1hv8mgmraOsSYkhqcjQ+Nv8l
	Rj1jmLNO/T4yBf8/b17n8nEyy65/ZDp3Zs/N3WM8E4imTWTRCn+DDG2xjG2vpKfuPoVEcDEr2D0
	SH8heUeuJbVU4afdQMh3Eypg9QcMX7CpfnIHqr8uBYnoeDReL9MghFJEdcyjkbTaO09aTWzuHej
	WOfdBdQe9/mnZm4aJKh66ae+xrLNYgQHdFAk3QiMCgVVmEPN69yLF+k5MBwmqk8qnYoAUP/gUoU
	0kS8nSlv1O8jfgxlILIWEuv5XnhG8XpQZN87JD7HNTQJ9Bwchijk2RF7FA1+X9vj3KC/Pzr5xph
	SwkX2R0P41bx6JlbYxL+EGG4jbC63gYhwLbGJpFlQgyEYvAlpKHM5Cx/Bu0NaSy8PTkEPmN5iFG
	oG+ZtJPrCSjyH1CfA1Otf6F6ARdtLuWJYzOwdo6i+azO0EEBrgXVKu8ThSB8DPcgmQ01R275X7u
	QzFztqhPkA=
X-Received: by 2002:a05:6870:720a:b0:448:7667:2e96 with SMTP id 586e51a60fabf-4637fa4d63dmr26462204fac.9.1787671959594;
        Tue, 25 Aug 2026 08:32:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463831397f0sm8191635fac.3.2026.08.25.08.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:38 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 00/11] Virtual Swap Space (Swap Table Edition)
Date: Tue, 25 Aug 2026 08:32:26 -0700
Message-ID: <20260825153238.2695446-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changelog:
* v3 [v3] -> v4
    * Replaced the runtime sysctl with a cmdline param, and remove
      CONFIG_VSWAP (suggested by Johannes Weiner). CONFIG_VSWAP_DEFAULT_ON
      now only gives the default value of the vswap cmdline parameter.
    * Refactor swap-related memcg operations into composable building
      blocks: reference acquisitions, charging, etc. (patch 8,
      suggested by Johannes Weiner).
    * Fixed vtable UAF bug reported by syzbot and Kunwu.
    * Rebased onto mm-unstable (minimal merge conflicts).
    * Re-run benchmarks (no signal change).
* v2 [v2] -> v3:
    * Rebased onto current mm-unstable.
    * Add a runtime vm.vswap_enabled sysctl and CONFIG_VSWAP_DEFAULT_ON
      to gate vswap allocation.
    * More cleanups and small bug fixes.
    * Split THP swapin enablement into its own patch (patch 5).
    * Add production workload benchmark results, and drop RFC tag.
* v1 [v1] -> v2:
    * Rebased to a newer mm-unstable tip.
    * Fix a bunch of assorted issues (incorrect zswap store failure
      rollback, vswap_init() failure handling, rmap-encoding collision,
      etc.) and clean up the code (rename a bunch of functions to
      more closely follow existing patterns, etc.).
    * Some more code clean up and simplification: some renamings to more
      closely follow existing patterns, move vswap backing check to
      __swap_cache_add_check, store zero state in the swap_table for
      vswap entries, etc.. Many of these are proposed by Kairui Song
      in [1].
    * Defer memcg_table allocation on physical clusters until the first
      vswap-backing slot installs. Saves ~512 bytes per physical cluster
      that only serves vswap-backing slots (this is the new patch 8).
    * Widen swap_info_struct->max and ->pages (and the swapoff unuse-path
      index) so vswap supports ~8 PB of swap space (this is the new
      patch 9).
    * Split the physical-swap-backend patch into three for reviewability:
      the core backend (patch 3), zswap writeback to physical swap
      (patch 4), and reclaim of cache-only physical slots (patch 5). No
      functional change.
    * Add kerneldoc for the vswap API.
    * Add some benchmark numbers for zswap case.


I. Context and Motivation
=========================

Currently, when an anon page is swapped out, a slot in a backing swap
device is allocated and stored in the page table entries that refer to
the original page. This slot is also used as the "key" to find the
swapped out content, as well as the index to swap data structures, such
as the swap cache, or the swap cgroup mapping. Tying a swap entry to its
backing slot in this way is performant and efficient when swap is purely
just disk space, and swapoff is rare.

However, the advent of many swap optimizations has exposed major
drawbacks of this design. The first problem is that we occupy a physical
slot in the swap space, even for pages that are NEVER expected to hit
the disk: pages compressed and stored in the zswap pool, zero-filled
pages, or pages rejected by both of these optimizations when zswap
writeback is disabled. This is arguably the central shortcoming of
zswap:
* Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
  we size swapfile in the order of 25-50% of host RAM, depending on flash
  availaiblity. This is a lot of flash for a fleet of our size, and
  with universal zswap enablement, most of this is wasted for zswap
  entries.

* In deployments when no disk space can be afforded for swap (such as
  mobile and embedded devices), users cannot adopt zswap, and are forced
  to use zram. This is confusing for users, and creates extra burdens
  for developers, having to develop and maintain similar features for
  two separate swap backends (writeback, cgroup charging, THP support,
  etc.). For instance, see the discussion in [2].

* Tying zswap (and more generally, other in-memory swap backends) to
  the current physical swapfile infrastructure makes zswap implicitly
  statically sized. This does not make sense, as unlike disk swap, in
  which we consume a limited resource (disk space or swapfile space) to
  save another resource (memory), zswap consumes the same resource it is
  saving (memory). The more we zswap, the more memory we have available,
  not less. We are not rationing a limited resource when we limit
  the size of the zswap pool, but rather we are capping the resource
  (memory) saving potential of zswap. Under memory pressure, using
  more zswap is almost always better than the alternative (disk IOs, or
  even worse, OOMs), and dynamically sizing the zswap pool on demand
  allows the system to flexibly respond to these precarious scenarios.

* Operationally, static provisioning the swapfile for zswap poses
  significant challenges, because the sysadmin has to prescribe how
  much swap is needed a priori, for each combination of
  (memory size x disk space x workload usage). It is even more
  complicated when we take into account the variance of memory
  compression, which changes the reclaim dynamics (and as a result,
  swap space size requirement). The problem is further exacerbated for
  users who rely on swap utilization (and exhaustion) as an OOM signal.

  All of these factors make it very difficult to configure the swapfile
  for zswap: too small of a swapfile and we risk preventable OOMs and
  limit the memory saving potentials of zswap; too big of a swapfile
  and we waste disk space and memory due to swap metadata overhead.
  This dilemma becomes more drastic in high memory systems, which can
  have up to TBs worth of memory.

Swap virtualization is the answer to these issues, with three properties:

1. Decoupled backends. For zswap in particular, this means we eliminate
   the unused storage space, and allows zswap to be used in systems that
   do not have enough storage capacity for physical swap (without having
   to resort to silly hacks). Zero-filled swap pages and swap-cache-only
   folios also benefit here.

2. Dynamic swap space. Since virtual swap is not tied to any physical
   resource, we can make it infinite and dynamically grow it on demand.
   This massively simplifies operational provisioning, and increases the
   utilization of compressed swap backends (zswap). Dynamicity also
   reduces overhead on unused swap capacity.

3. Efficient backend transfer. The virtualization scheme should not
   introduce PTE/rmap walking overhead for backend transfer. This
   is crucial for systems that want to support multiple swap backends
   in a tiering fashion (for e.g zswap -> disk swap).

For more historical contexts and references, please take a look at
the cover letter of the older vswap submissions ([3] and [v2]).

II. Design
==========

When vswap is enabled (via vswap=on cmdline parameter), a special vswap
device is allocated at boot time. Anon pages that can be zswapped will
obtain a vswap slot at swap allocation time.

These swap entries can subsequently acquire backend on-demand, such as
a zswap entry, or a slot on a physical swap device (as a fallback option
or at zswap writeback time).

We repurpose much of the existing swap_table infrastructure and
swapfile allocator for this new vswap device, with two notable
differences:
* Clusters are dynamically allocated on demand and managed through
  an xarray. This in turn allows us to avoid static provisioning and
  let swap space grow dynamically.

* Each cluster of this new vswap device has a virtual_table that stores
  the backend information of the entries in the cluster (see below).

Diagrams:

  Case 1: vswap entry (virtualized)

  PTE                  swap_cluster_info_dynamic
  vswap_entry          +---------------------------------+
  (swp_entry_t) ------>| swap_cluster_info (ci)          |
                       | +----------------------------+  |
                       | | swap_table                 |  |
                       | |   PFN / Shadow             |  |
                       | | memcg_table                |  |
                       | | count,flags,order          |  |
                       | | lock, list                 |  |
                       | +----------------------------+  |
                       |                                 |
                       | virtual_table                   |
                       | +----------------------------+  |
                       | | NONE                       |  |
                       | | SWAPFILE(swp_entry_t)      |  |
                       | | ZSWAP(struct zswap_entry*) |  |
                       | +----------------------------+  |
                       +---------------------------------+
                              |
                              | SWAPFILE resolves to
                              v
                       PHYSICAL CLUSTER (swap_cluster_info)
                       +--------------------------+
                       | swap_table per-slot:     |
                       |   NULL   - free          |
                       |   PFN    - cached folio  |
                       |   Shadow - swapped out   |
                       |   Pointer- vswap rmap    |
                       |   Bad    - unusable      |
                       |                          |
                       | Vswap-backing slot:      |
                       |   Pointer(C|swp_entry_t) |
                       |     rmap back to vswap   |
                       +--------------------------+

  Case 2: direct-mapped physical entry (no vswap)

  PTE                  PHYSICAL CLUSTER (swap_cluster_info)
  phys_entry           +--------------------------+
  (swp_entry_t) ------>| swap_table per-slot:     |
                       |   NULL   - free          |
                       |   PFN    - cached folio  |
                       |   Shadow - swapped out   |
                       |   Bad    - unusable      |
                       +--------------------------+

struct swap_cluster_info_dynamic {
    struct swap_cluster_info ci;       /* swap_table, lock, etc. */
    unsigned int index;                /* position in xarray */
    struct rcu_head rcu;               /* kfree_rcu deferred free */
    atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
};

Each vswap cluster (swap_cluster_info_dynamic) extends the classic
swap_cluster_info struct with a virtual_table array that stores the
backend information for each virtual swap entry in the cluster. Each
entry is tag-encoded in the low 3 bits to indicate the backend type:

  NONE:     |----- 0000 ------|000|  free / unbacked
  ZSWAP:    |--- zswap_entry* |001|  compressed in zswap
  SWAPFILE: |- type:5,off:56 -|010|  on a physical swapfile

Other design highlights:

* Note that for the vswap device, we have merged the zswap xarray tree
  with the swapfile-level clusters. This means that for zswap only users,
  we have negligible extra space overhead.

* Both vswap entries (Case 1) and directly-mapped physical entries
  (Case 2) coexist as first-class citizens.

* Backend transitions in the virtual_table are synchronized through the
  swap cache and the folio lock - the same mechanism that already
  serializes ordinary swap operations (swapin, swapout, zswap
  writeback, swap cache reclaim). IOW, we can only assume that the
  backend of a vswap entry is stable through swap cache/folio lock.
  Looking at the backend without this should be done at best for
  optimization purposes, as there is no guarantee that the backend
  will not change under the observer.

* Pointer-tagged swap_table entries on physical clusters provide the
  rmap (physical -> virtual) lookup.

* Virtual swap slots not backed by physical swap are not charged to
  memcg swap counters - only physical backing is charged (I made the
  case for this in [4]).


III. Benchmarks
===============

Note that the goal is not to match vswap performance with baseline on
every single case yet - running with vswap off is still supported. We
can optimize further once we have landed this new feature.

A. Production Workload: Instagram
=================================

To test vswap's stability and performance, I ran an A/B experiment on
Instagram (django) workload, with zswap as the swap backend. On these
hosts, the swapfiles' size is 50% of RAM.

Compared to baseline, vswap gives:

* On par request throughput.
* Lower request serving latency (by about 1-3%).
* Lower memory pressure in the system service cgroups running alongside
  the workload. PSI-based proactive reclaimer can therefore recover more
  from them, lowering their overall memory footprint, allowing the main
  workload to expand.
* Elimination of swapfile footprint for all zswap users in the host.

B. Semi-synthetic Workloads (memhog, usemem, kernel build)
==========================================================

All values are mean +/- standard deviation across rounds.

Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
focus on zswap here because it is the motivating use case for vswap.

For each benchmark, we test 3 kernels:
* Baseline: mm-unstable, no vswap patches.
* VSS off: vswap series applied, vswap=off, to verify that there is no
  regression to existing swap paths when we disable vswap.
* VSS on: vswap series applied, vswap=on.

1. Memhog: single-threaded, 48GB allocation on a host with 16GB RAM,
   20 rounds.

                    Baseline           VSS off            VSS on
   real (s)        124.05 +/- 11.64   122.31 +/- 10.29   118.57 +/- 15.68
   sys (s)         106.75 +/- 10.86   105.01 +/- 9.64    101.34 +/- 13.97
   user (s)        10.81 +/- 0.11     10.85 +/- 0.09     10.79 +/- 0.09
   delta real              -              -1.4%              -4.4%
   delta sys               -              -1.6%              -5.1%

Dropping the best and the worst round to reduce variance:

   memhog              Baseline           VSS off            VSS on
   real (s)        123.75 +/- 10.39   122.04 +/- 9.10    116.06 +/- 8.22
   sys (s)         106.80 +/- 10.21   104.99 +/- 8.86    99.29 +/- 8.27
   user (s)        10.82 +/- 0.11     10.85 +/- 0.08     10.79 +/- 0.10
   delta real              -              -1.4%              -6.2%
   delta sys               -              -1.7%              -7.0%


2. Usemem single-threaded: 56GB allocation on a host with 32GB RAM,
   16 rounds.

                    Baseline           VSS off            VSS on
   real (s)        178.75 +/- 6.47    178.95 +/- 6.56    175.97 +/- 7.74
   sys (s)         127.03 +/- 6.56    128.08 +/- 6.59    124.71 +/- 7.90
   tput (KB/s)     386662 +/- 14648   386264 +/- 15150   390443 +/- 17532
   free (ms)       7669 +/- 146       7678 +/- 136       6439 +/- 111
   delta real              -              +0.1%              -1.6%
   delta sys               -              +0.8%              -1.8%
   delta tput              -              -0.1%              +1.0%
   delta free              -              +0.1%             -16.0%

3. Kernel build: 52 workers (one per processor), memory.max=3GB, 10 rounds.

                    Baseline           VSS off            VSS on
   real (s)        165.58 +/- 0.45    165.83 +/- 0.49    166.01 +/- 0.58
   sys (s)         694.24 +/- 26.13   710.76 +/- 19.83   705.06 +/- 21.40
   user (s)       5132.62 +/- 1.12   5133.69 +/- 1.57   5134.68 +/- 1.68
   delta real              -              +0.2%              +0.3%
   delta sys               -              +2.4%              +1.6%
   delta user              -              +0.0%              +0.0%


For zswap backend, vswap outperforms baseline on usemem freeing, and is
on par with baseline on the rest.

IV. References
==============

[v1]: https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/
[v2]: https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.com/
[v3]: https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com/
[1]: https://lore.kernel.org/all/CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com/
[2]: https://lore.kernel.org/all/Zqe_Nab-Df1CN7iW@infradead.org/
[3]: https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com/
[4]: https://lore.kernel.org/linux-mm/CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com/


Nhat Pham (11):
  mm, swap: add virtual swap device infrastructure
  mm, swap: support zswap and zero-filled swap pages as vswap backends
  mm, swap: prepare the swap IO path for vswap
  mm, swap: support physical swap as a vswap backend
  mm, swap: enable THP swapin for vswap entries
  mm, swap: write back vswap zswap entries to physical swap
  mm, swap: reclaim physical slots backing cache-only vswap entries
  mm, swap: only charge physical swap entries
  mm, swap: add debugfs counters for vswap
  mm, swap: defer memcg_table allocation for physical swap clusters
  mm, swap: widen swap_info_struct max/pages to unsigned long

Nhat Pham (11):
  mm, swap: add virtual swap device infrastructure
  mm, swap: support zswap and zero-filled swap pages as vswap backends
  mm, swap: prepare the swap IO path for vswap
  mm, swap: support physical swap as a vswap backend
  mm, swap: enable THP swapin for vswap entries
  mm, swap: write back vswap zswap entries to physical swap
  mm, swap: reclaim physical slots backing cache-only vswap entries
  mm, swap: only charge physical swap entries
  mm, swap: add debugfs counters for vswap
  mm, swap: defer memcg_table allocation for physical swap clusters
  mm, swap: widen swap_info_struct max/pages to unsigned long

 .../admin-guide/cgroup-v1/memcg_test.rst      |    2 +-
 .../admin-guide/kernel-parameters.txt         |    7 +
 MAINTAINERS                                   |    1 +
 include/linux/memcontrol.h                    |    6 +
 include/linux/swap.h                          |   76 +-
 include/linux/swap_ops.h                      |    9 +-
 include/linux/zswap.h                         |    3 +
 mm/Kconfig                                    |   20 +
 mm/memcontrol-v1.c                            |   10 +-
 mm/memcontrol.c                               |  148 ++-
 mm/memory.c                                   |   21 +-
 mm/page_io.c                                  |  106 +-
 mm/shmem.c                                    |    4 +-
 mm/swap.h                                     |   71 +-
 mm/swap_state.c                               |   60 +-
 mm/swap_table.h                               |   50 +-
 mm/swapfile.c                                 | 1182 +++++++++++++++--
 mm/vmscan.c                                   |    9 +-
 mm/vswap.h                                    |  440 ++++++
 mm/zswap.c                                    |  129 +-
 20 files changed, 2100 insertions(+), 254 deletions(-)
 create mode 100644 mm/vswap.h


base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
-- 
2.53.0-Meta

