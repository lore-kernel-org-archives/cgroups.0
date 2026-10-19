Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D7C20459A
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 01:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372495; cv=none; b=Ft4l4Hi83JNk5oiOBxLw3NJXJdIKNyj4EXbF3DFgnKJKUZQsUu//oCVHDYH3hGFMTGE/K8pqSVx0GBDKDIxaMR4x+cogMWFcyDucL6Xrs00Dxz49ejOUSFnfRreGPFvrJZtl4Tj4pgc195FpzGn2MryOtpEbl4knOeD6Gh8d/9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372495; c=relaxed/simple;
	bh=GVrniHfbj620VlGwg67HtAuPIXlYHbjZgK6GDnyOXDQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dBYIGy3oKaQT7PZWVYIopv3OoTu3R5cb6TfRrNvOKd546u3p23QmMjE/zbE96Cb8lyztWnH21NeJo45irOQ+fkuY1Eu4ZvnIDSeFgoS92NUUn0a/YQ5/je7JyC8TH9Iajgn8p7yHmV4TcIFQWSyQrxp8BcrZMVVNg/QagtWPjXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=YcQi1C4P; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="YcQi1C4P"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eac9db5905so149788e0c.0
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 18:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372492; x=1792977292; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J29y68RABBwtPItFwE/Tw/yYInAbTL5GAQo5LD76s4c=;
        b=YcQi1C4P3eVVvckvf3RBOxeXqIzv5ZG2o1AAXhpKJNfyWcEidvS4qlP+WBcGMfeIHp
         1TFMLVLu9PnuDcI64jyTpkKm/2poJ8YCzowYv0SborqmSIYpqIxqk4/O0+7YFvV4y5F/
         /PcUKRtotupbE7vhY6PSBriwwP5xChIl5tDm9Y+EKCTo71ljDkOe9CRamc9IjURcYzFc
         j5vwybMLcOZFzFt8Xw++61wNPT5p4ePG6INCuiGDyJ9NG0LImz5qGl93g00Ng4EZbckX
         SRGmXJK3ydYzm+/VXPhPxtflKvY5aj/mDej1NFfBMDGY4s51ExgB5CDADOM6woooAnoZ
         QLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372492; x=1792977292;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J29y68RABBwtPItFwE/Tw/yYInAbTL5GAQo5LD76s4c=;
        b=qqgWIRSYGKX8FKlrkVvpYS+gXLhzkqHZMt/qQ55NvoO7fgHc/XEHAjQmF1eAP7gV3M
         n1iNlisKutxi0rbUxA1Nz5Mh9Cgi5KbAuH00BRiE6vleJImln/EEWkgG0SEi+O2hAjx3
         dVrYFSVLH2nkkzpCVwl7+Qh8tqxoiYlzcZDtZEJREw7RTAjY/rVOvhny8+iwCK3NL8Xh
         72A53I4IBB7M8BRHTsBydSHwSKFsLSTnbjMA8DzzI36aPknL9AH98RBNpj3wdV/KfGpR
         PGvOysgBzBoKLncPuWwbMsWHvGHNXUqTb82af5S5p84f/G45Oy4BGTkzXMIE0k43+BXT
         i21g==
X-Forwarded-Encrypted: i=1; AKwUvBx45539gCaDzeQnD7q3qR231MJEhGX29Pf62WpExPcOjOdnBCaadDjFVM3fMP9DpJmV8N2HLVvn@vger.kernel.org
X-Gm-Message-State: AFq9FYJHwnOD0hRQ/8M0GvlClG14BacpjRLlZyIMfiQ2dJGi7OzMbgEP
	/pAu36qG1hi03xGsNsFlqu8yjA9Wvib6Grx0JxbbySq1OYwCTLHeRd1bHD8KKYzlbR0=
X-Gm-Gg: AYBFou1bBFLlI8kb+EB70WvodYPyHw4AD6IPgGmqS0M6HkyK8sybfSOAQBVqK+6opNb
	7XN06q+FOWdFWh4bKzUo1b32/UmmnRBKAY/JLOqoQ5IHp31CUAUHOPpVU5Ah/rbPkGLx4h6OGpn
	2ckLDPjWtSxxaRJXzN4zDdfP/OCiAU8TpCwxIjwJdTOyUbC26hryU3YkiQJRcrlGSuq+DOuIyWD
	mzJlC8HQVeWy06I+MKutX/0aY6YWpEWGjTSoYaKw0rd3AYKDpZTQJFOS2cET0cioyqMKA4brQsw
	10d9LCMcGoKevsKEF2NDeY+pAO/evxzW+iQPOPtRA5Ed/X6DPE1/zYcXKVYQodMAiY9tQjok2zv
	DlzXCfNKTlAD0mocQ96NlMfpxQz+SVsA1xzDJByieSJHFYjTk2SNhl8ahd7axqFpGRhOw942kDR
	5zPXvdLToo2cT+3OeJ0Pzol2OgIVKspIsq6wcoMQJzpuWN6RPamsIwNQTa7Dp3a1kuXos/w1MKt
	p6KGw8WaJfGoVvn9f9KiTpB+ojgz7qYP4NIM6kM2jd7t7kkzmBiZujSt6Nuf6GmU71N4eyLG27N
	Tje13udOyeyO4KbcoB8=
X-Received: by 2002:a05:6122:6d10:b0:5cd:575f:9396 with SMTP id 71dfb90a1353d-5eaaa51809bmr2046551e0c.12.1792372491910;
        Sun, 18 Oct 2026 18:14:51 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:14:50 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large systems
Date: Sun, 18 Oct 2026 21:14:38 -0400
Message-ID: <20261019011446.834487-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For live update we require a fast CPU online and offline capability.
However, sequentially offlining and onlining all application processors
on modern high-core-count x86 servers exposes a series of hardware and
algorithmic bottlenecks across arch/x86, the scheduler topology builder,
deadline bandwidth accounting, and vmstat.

This series addresses these bottlenecks, reducing the time to offline and
online all AP CPUs by 95.2% (21.0x faster) on a 2-socket, 480-CPU Intel
Xeon 6985P-C and by 59.8% (2.5x faster) on a 2-socket, 512-CPU AMD EPYC
9B45.

Benchmark workload (mean of 10 runs per step):

  # echo 1 > /sys/kernel/rcu_expedited
  # for i in {1..N}; do echo 0 > /sys/devices/system/cpu/cpu$i/online; done
  # for i in {1..N}; do echo 1 > /sys/devices/system/cpu/cpu$i/online; done
  # echo 0 > /sys/kernel/rcu_expedited

  2-socket, 480-CPU Intel Xeon 6985P-C (N=479):
    Offline:  40.40 s ->  3.09 s  (-92.4%, 13.1x faster)
    Online:   65.83 s ->  1.98 s  (-97.0%, 33.2x faster)
    Total:   106.23 s ->  5.07 s  (-95.2%, 21.0x faster)

  2-socket, 512-CPU AMD EPYC 9B45 (N=511):
    Offline:   4.53 s ->  2.30 s  (-49.2%,  2.0x faster)
    Online:    3.88 s ->  1.08 s  (-72.2%,  3.6x faster)
    Total:     8.41 s ->  3.38 s  (-59.8%,  2.5x faster)

  (On AMD EPYC 9B45, each 8-core CCD has a 32 MB L3 where WBINVD takes
   < 0.5 ms, offline uses acpi_idle rather than mwait_play_dead(), and
   Intel CMCI is unused, so Patches 1-3 do not affect AMD, which enters
   Patch 4 at 4.53 s offline / 3.92 s online / 8.45 s total. Without
   rcu_expedited=1, final 10-run mean total time with all 8 patches
   applied is 12.04 s on Intel and 15.99 s on AMD.)

1. x86 WBINVD, CMCI rediscovery, and MTRR rendezvous (Patches 1-4):

   On processors with large shared last-level caches (such as the 504 MB
   L3 per socket on Xeon 6985P-C), CPU hotplug is initially dominated by
   full coherence-domain cache flushes (WBINVD), each taking ~85-115 ms
   per CPU while stalling active cores:

   - Patch 1 removes the obsolete WBINVD from trampoline_start, which was
     added in the 1990s for Sequent NUMA-Q hardware (removed in commit
     b5660ba76b41 ("x86, platforms: Remove NUMAQ")). Per the Intel SDM
     and AMD APM, INIT preserves cache contents and leaves CR0.CD and
     CR0.NW unchanged. Removing it cuts 479-CPU online time on Intel from
     65.83 s to 11.14 s (-83.1%) and total time from 106.23 s to 51.60 s
     (-51.4%).

   - Patch 2 skips the redundant WBINVD before MWAIT in mwait_play_dead()
     during runtime CPU offline when entering a C-state deeper than
     C1/C1E/C2 while another CPU sharing the same package and LLC remains
     online (unless cache_state_incoherent is set). Architectural MWAIT
     C-states deeper than C1/C1E/C2 flush core-private L1/L2 caches to the
     LLC on C-state entry and maintain cache coherency while the package
     remains powered, just like normal idle in intel_idle. Skipping it
     except on the last online CPU of an LLC cuts 479-CPU offline time on
     Intel from 40.46 s to 11.42 s (-71.8%) and total time from 51.60 s to
     22.50 s (-56.4%).

   - Patch 3 bounds cmci_rediscover() on CPU teardown. Currently,
     cmci_rediscover() broadcasts an IPI via on_each_cpu() to all online
     CPUs, serializing them on cmci_discover_lock while reading up to 32
     MCA MSRs. Because any disabled MCA bank is shared at most with an
     SMT sibling, L2 cluster peer, or die/package peer, probing a single
     online topology peer via smp_call_function_single() (or returning
     immediately when no shared banks were orphaned) reduces 479-CPU
     offline time on Intel from 11.42 s to 9.63 s (-15.7%) and total time
     from 22.50 s to 20.74 s (-7.8%).

   - Patch 4 skips the stop_machine_from_inactive_cpu() all-CPU
     rendezvous (and the AP's cache disable/flush and MTRR reprogramming
     in cache_cpu_init()) in cache_ap_online() when the AP's hardware
     MTRR MSRs already match mtrr_state (which cache_aps_init() already
     programmed during initial boot and warm reset preserves). This cuts
     online time on Intel from 11.11 s to 8.69 s (-21.8%; total 20.74 s
     -> 18.54 s, -10.6%) and on AMD from 3.92 s to 3.15 s (-19.6%; total
     8.45 s -> 7.66 s, -9.3%).

2. Scheduler domains, deadline accounting, and vmstat (Patches 5-8):

   Once the x86 hardware bottlenecks are removed, CPU hotplug on both
   Intel and AMD is dominated by O(N^2) and O(N^3) work inside
   partition_sched_domains_locked(), build_sched_domains(), and
   refresh_zone_stat_thresholds():

   - Patch 5 avoids redundant O(N^3) group weight, SMT core-mask, and
     asym_prefer_cpu recomputations in init_sched_groups_capacity() by
     caching those fields on struct sched_group_capacity, reuses
     already-initialized sgc instances in init_overlap_sched_group(), and
     allocates sdd->sg, sdd->sgc, and d->sds lazily on demand. This cuts
     total hotplug time on Intel from 18.54 s to 9.20 s (-50.4%) and on
     AMD from 7.66 s to 5.29 s (-30.9%).

   - Patch 6 eliminates three O(N^2) dl_server bandwidth walks per
     hotplug step. Because fair_server is enabled on every runqueue by
     default, rq_attach_root() performs O(N^2) remote extra_bw updates
     when attaching def_root_domain during teardown and again when
     attaching the new root_domain during build, followed by a nested
     O(N^2) loop in dl_clear_root_domain(). Dropping the redundant
     __dl_server_attach_root() calls in rq_attach_root() and converting
     dl_clear_root_domain() to two linear O(N) passes cuts
     dl_clear_root_domain() at ~500 CPUs from 1.8-5.5 ms to < 65 us,
     reducing total hotplug time by 30.5% on Intel (9.20 s -> 6.39 s)
     and 18.7% on AMD (5.29 s -> 4.30 s).

   - Patch 7 eliminates per-CPU bitmap scans over already-covered groups
     in build_sched_groups(), reuses temporary per-CPU domain pointer
     arrays across rebuilds instead of calling alloc_percpu() and
     free_percpu() on every hotplug step, reuses precomputed domain/child
     span weights, and hoists LLC size calculations. This cuts total
     hotplug time by 15.0% on Intel (6.39 s -> 5.43 s) and 19.5% on AMD
     (4.30 s -> 3.46 s).

   - Patch 8 avoids unconditionally zeroing and rewriting every online
     CPU's per-CPU stat_threshold in refresh_zone_stat_thresholds() on
     every hotplug step (since calculate_normal_threshold() only changes
     at powers of two and is clamped once num_online_cpus() >= 64),
     reducing refresh_zone_stat_thresholds() by ~88-91% on Intel and ~51%
     on AMD, and bringing total hotplug time down to 5.07 s on Intel
     (-6.6%) and 3.38 s on AMD (-2.3%).

Changelog:
v2:
- Rebased onto tip/master.
- Patch 2:
  - In addition to cpuhp_tasks_frozen, also flush in mwait_play_dead()
    when the target MWAIT state is C1/C1E/C2, when no online CPU remains
    in the same package and LLC, or when cache_state_incoherent is set, so
    shallow C-states and packages offlined at runtime do not retain dirty
    cache lines across wbinvd_on_all_cpus(), subsequent S3/S4 sleep, or
    kexec.
- Patch 5 (Suggested by K Prateek Nayak):
  - Key sdd->sgc lookup in init_overlap_sched_group() by group_balance_cpu
    via a new find_group_balance_cpu() helper instead of
    cpumask_first(sg_span) with a child-span equality check, allowing
    overlap groups to reuse sched_group_capacity even when the group span
    differs from the child domain span.
  - Pass group_balance_cpu into build_balance_mask() and iterate via
    for_each_cpu_from().
  - Use atomic_set(&sgc->ref, 1) directly on the init_overlap_sched_group()
    allocation slow path.
- Patch 6:
  - Wire !CONFIG_CPUSETS cpuset_lock(), cpuset_unlock(), and
    lockdep_assert_cpuset_lock_held() to sched_domains_mutex so concurrent
    SCHED_DEADLINE sched_setattr() calls are serialized against
    dl_rebuild_rd_accounting().
  - Skip TASK_DEAD tasks on inactive CPUs in dl_add_task_root_domain() so
    their pending 0-lag bandwidth is not leaked on the active root domain
    when inactive_task_timer() fires on def_root_domain.
  - Combine the two writes to rq->dl.extra_bw in dl_clear_root_domain()
    into a single WRITE_ONCE() assignment.
- Patch 7 (Suggested by Tim Chen):
  - Add lockdep_assert_cpus_held() to __sdt_free_percpu() and clarify in
    the commit log that sched_init_numa() / sched_reset_numa() are
    serialized against domain rebuilds by the CPU hotplug lock.
  - Add a comment and WARN_ON_ONCE() checks in __sdt_alloc() and
    __sds_alloc() verifying that reused per-CPU pointer slots in cpu_map
    are NULL at the start of a domain build.
Link: https://lore.kernel.org/all/20261015153331.1872641-1-pasha.tatashin@soleen.com/ # v1

Pasha Tatashin (8):
  x86/realmode: Remove unnecessary WBINVD from AP startup trampoline
  x86/smp: Remove unnecessary WBINVD from mwait_play_dead()
  x86/mce/intel: Bound cmci_rediscover() to a single topology peer
  x86/cacheinfo, mtrr: Skip stop_machine rendezvous in cache_ap_online()
    when MTRRs match
  sched/topology: Avoid redundant O(N^3) group capacity walks and unused
    allocations in build_sched_domains()
  sched/deadline, topology: Avoid O(N^2) dl_server bandwidth walks
    during root_domain rebuilds
  sched/topology: Avoid redundant percpu allocations and bitmap walks in
    build_sched_domains()
  mm/vmstat: Avoid redundant per-CPU stat_threshold writes in
    refresh_zone_stat_thresholds()

 arch/x86/include/asm/mtrr.h          |   2 +
 arch/x86/kernel/cpu/cacheinfo.c      |   7 +
 arch/x86/kernel/cpu/mce/intel.c      |  57 +++-
 arch/x86/kernel/cpu/mtrr/generic.c   |  49 ++++
 arch/x86/kernel/smpboot.c            |  46 +++-
 arch/x86/realmode/rm/trampoline_32.S |   2 -
 arch/x86/realmode/rm/trampoline_64.S |   1 -
 include/linux/cpuset.h               |  23 +-
 include/linux/sched/deadline.h       |   1 -
 kernel/sched/deadline.c              |  93 ++++---
 kernel/sched/sched.h                 |  10 +-
 kernel/sched/topology.c              | 394 ++++++++++++++++++---------
 mm/vmstat.c                          |  58 ++--
 13 files changed, 524 insertions(+), 219 deletions(-)


base-commit: aacd2a9507b9fad8eb505c0e493b88779fe35d74
-- 
2.56.0.176.g3575e65682-goog

