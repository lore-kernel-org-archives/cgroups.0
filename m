Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281377;
	b=HZN6B4WZBrU+imNNXP5xnsUrjYABk/lZgm9/WR+YZk9m5Ja7aqjq7HwJkfUxUgwCgJwN
	 TZqnej2+YAcDgKT551JeM/KmdgpLVIFP/y8Tu4GAQxyXROA9mkTW3HXbzuDjAPPYYhL05
	 h+qqotUqTy/9MoqCPVGeQ1b4ytLvQAIUAQAciNalP557C+L58OShA8Waeypvpgz4h5sZU
	 hHSX4Z5F3LA/OpeC2eJeQvPVNMkszasyS+ZQjZFmXZQ3C/UtSc8OgkHp5xX9BkvcB3pVZ
	 JijyUuoakJJwihs2JhrAx8qVPTyGNacVEX+gGRAN7ePfC53OICg3KfG9mCgiMwGWnzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281377;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EzW2wBxhFd3AZgIdQVNZpp+frtAfuu8T5OooRMQocqk=;
	b=oe/5Ew9AdXPUaVFG03/GsjOMYkE9NALyOaxS//0//PfXbxZZS82rZZs6aCIhJzwd4jZi
	 03oHHmzlmmxwsYeD2ViLZs9DYSLTm0VbpkJxMJfYxd8Uqso5wCwhtm0HN1T7CxbSNAxDH
	 g2XMGExegPyzINwlb/y3Mz+6UIEaTTu/IJ+b1L3lTIsD9vVWTy0hCMQ2Vrbvld64DM+7k
	 0Z994oZA2wizI2FF9BfTZjaK1C/V1izLP91YoDzOkEsjuvw+sFMT7thARyASjynJCKhWH
	 9q8maOs+zrypnAU+J8qOFQ1yFstmdc0YS0x5M04TvX3BZ3BRBj1E8uXjGsn0kYHAY+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IL9qculF;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37661606A321
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 03:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37661606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IL9qculF
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-886e61fa30fso653222b3a.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 19:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794281375; x=1794886175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EzW2wBxhFd3AZgIdQVNZpp+frtAfuu8T5OooRMQocqk=;
        b=IL9qculFz6WDOby3HNcHY701na5d3o23ITB+8IUhqC/UpHuWOyLMWbThTJ2+5bXih8
         93vDIlWgw7gVQUyC5qyTddkbvJB6/rzQq25tPhRnBkgDMH3xXo5ku+9taDtwGF6TrWSu
         TPCppNTtQZJTKBmXVTGPulINILQrmJsAiAOgFuVWPwqYwf3qy6lmCiseAyOightQHNZ3
         HuC6FqdqmUW54vK2k8ztiMR1c5wF9uKYh1yz4WGZIH/+sAklPD+XhokGxrH4cvk/N//6
         qxihoD0FEw1MUg49z0UWfcAdK9T9nyQ+bQVS9E/A+dXjulLtEmgCJgK5C0jMBfZLa5DP
         /CTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794281375; x=1794886175;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EzW2wBxhFd3AZgIdQVNZpp+frtAfuu8T5OooRMQocqk=;
        b=1faALTrZB1WUmk2fIV0G8o/pmtPZ07C4+7ZG5TxfEVt/QPjT96p++3pb0ktHqfv9kT
         yiKsY9r6lCh0ncFOlkdHwRp9q6FlG08aXiWAFPcwlxHw2lgN5tgW+clwDmGuGDwjjaLG
         Bs7r3fLIGz/9mPUmA/Q5gszPk+XOLxhnIRkeuOeKRfmTRndB7PBbUxUYk/ea5aDSQNfo
         09dPQOdaDwN8Wy69OZ3VhOTJje99cyahrypXbqp+xX7kak+yMO3QtxTQy4r+SCrv26cw
         cQjTo5gTM3/exAy/N24jw7JqXou/SSCwQdVbsMhFi37ZIc/p7hrvEylV/imz5ZA4IHzQ
         afkA==
X-Forwarded-Encrypted: i=1; AL+hErFlr82PpvcxpUZrForIx59B7deUdcDDGDjiDMynQo8AEloqYhB0pw5OnL4n0P6+goQ2wdYoFiC5@vger.kernel.org
X-Gm-Message-State: APuU4Z9nnbnRsL1A4f6JLQluDs3tG6WByC+CgTaQfGJvKxa4jsRlwUiS
	n7D6EnQhTdHdJ6bv6md8C3yvqcXbtyNjsANWWtEFq35Y2El72kwwzyN8
X-Gm-Gg: AYBFou0Azwa116ltYdciHtLH0yj5PpED3ODDfwZEa8RmZ/iHwgyNI+fUDZS+Q6PA6SX
	1pMJXQ+SIeY7xYPp2BnfREVugYHyzWRBK2KNCZWrpdFJwjQE/x8NnKiP6ZPWdvycYtf15gc6Tw+
	r87zfbMbdgnUZoJ3qCuoXTHUTt3OP+bApngFlguw1X79yPc8O7zfS0GH9trpUrd62D7VJykm5iO
	FwDFd8OfuRLxp4MTIMlQTU0fW3K46gblruIYIWjIAO/lcEuxS4uIsCR/kKm5XIKrflzzw+JJ9gr
	YeJRSMi1watqO2JxMzivhzWsyoS0Dh7j27/Pw0xsMxn45tb+I5ZGEwIPBet2SW6sFRKRcv3VYaS
	tvYQ4IdPyAniyiMdhWlNdxx+mn800SFvJMG3jrYf8wIoWKCi1VxKm2tf4uBHWPm8lJ7MB5E/Q/9
	buzIjiShGd8pLf4FZQp3hwtTmwJnIZ8Kn6VbqtK/tsceNcqjYbNZzMPRfH+eQ/NWgJHJSzJpnhj
	EwlK/uUQ/6hqD63zT5PVF6LAJC2bQQtXii5DZnei+XO6VoSAC7Oty0AB1HaTX0NvkQ/VHpyrV2T
	vnVZFGIXubGhXisYTBiLSL0KU6tlfm8IuDIfNQTUhee971ObXFBx24bUmhP9rf0YO6mKstCUxdx
	TwhphRwqTxul7Mfs5zkHEkIo7
X-Received: by 2002:a05:6a21:3a94:b0:3e2:aa13:2e4f with SMTP id adf61e73a8af0-3f190281bbamr1075007637.56.1794281375265;
        Mon, 09 Nov 2026 19:29:35 -0800 (PST)
Received: from localhost.localdomain ([240e:46d:1d00:5ed4:58d0:d294:d44c:6ae8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm336973b3a.42.2026.11.09.19.29.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:29:34 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com,
	ziy@nvidia.com,
	mgorman@suse.de
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next v4 0/4] BPF-based per-cgroup NUMA balancing mode selection
Date: Tue, 10 Nov 2026 11:29:09 +0800
Message-ID: <20261110032913.71974-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Problem
=======

In our large fleet of Kubernetes-managed servers, NUMA balancing has
historically been disabled globally on each server. With the growing
deployment of multi-socket AMD EPYC servers, cross-NUMA access has become
a critical performance issue, which led us to reconsider enabling NUMA
balancing.

kernel.numa_balancing is a single system-wide sysctl. Latency-sensitive
workloads want NUMA balancing disabled, while NUMA-aware workloads want it
enabled. No single global setting serves both.

Design
======

Core structure
~~~~~~~~~~~~~~

This series follows Tejun's suggestion to store the existing NUMA
balancing mode bits in the cgroup's memcg and expose them through BPF
kfuncs.

A new field, mem_cgroup::numab_mode, holds the per-cgroup NUMA balancing
setting. Two kfuncs are added to set and read it:

  bpf_numab_set_mode(): set the mode for a specific memory cgroup. The
                        update is rejected with -EOPNOTSUPP if the cgroup
                        has no visible, online memcg. Valid
                        values are the NUMAB_* mode enum and
                        NUMAB_FOLLOW_SYSTEM (-1); NUMAB_FOLLOW_SYSTEM
                        uses the global sysctl state.

  bpf_numab_get_mode(): return the combined task-side request of the
                        cgroup's effective memcg and of all its ancestors.
                        NUMAB_FOLLOW_SYSTEM is returned when no request is
                        present. A cgroup without a memcg resolves to its
                        nearest ancestor memcg. The following section
                        describes how the request is combined across the
                        hierarchy.

Both kfuncs are registered for BPF_PROG_TYPE_SYSCALL. bpf_numab_set_mode()
is KF_SLEEPABLE because it takes the mode mutex and the jump-label locks;
bpf_numab_get_mode() does not sleep. The mode values are exposed as a BTF
enum, so a BPF program can use NUMAB_FOLLOW_SYSTEM and the NUMAB_* mode
names without hardcoding private integers.

Effective mode semantics
~~~~~~~~~~~~~~~~~~~~~~~~

In the current implementation, a memory cgroup can be set to the
following modes:

  NUMAB_FOLLOW_SYSTEM (-1):   use the global sysctl state
  NUMAB_DISABLED (0):         disabled
  NUMAB_NORMAL (0x1):         normal mode
  NUMAB_TIERING (0x2):        tiering mode
  NUMAB_NORMAL_TIERING (0x3): normal mode plus memory tiering

The diagrams below assume that each cgroup shown has its own memcg. A
cgroup without one resolves to its nearest ancestor memcg, as described
in Storage of numab_mode.

Except for the sentinel and the opt-out described below, the effective
mode is the OR of this memcg's mode and that of all its ancestors.

- An opt-out wins for the task side and binds the subtree

  A DISABLED mode anywhere in the cgroup's ancestry opts the cgroup's
  tasks out entirely. Given:
                     Pods (normal)
                     /
          Pod-A (disabled)
          /           \
   cgroup-A1(normal)   cgroup-A2(tiering)

  The effective task-side mode for tasks(*) in cgroup-A1 and cgroup-A2
  is:

                     Pods (normal)
                     /
          Pod-A (disabled)
          /           \
   cgroup-A1(disabled)   cgroup-A2(disabled)

  (*) The folio side is described below.

- NUMAB_FOLLOW_SYSTEM is skipped

  Given:

                     Pods (normal)
                     /
          Pod-A (-1)
          /           \
   cgroup-A1(none)   cgroup-A2(none)

  The effective mode for tasks in cgroup-A1 and cgroup-A2 is:

                     Pods (normal)
                     /
          Pod-A (normal)
          /           \
   cgroup-A1(normal)   cgroup-A2(normal)

- For all other modes, the effective value is the OR of this memcg's
  mode and that of its ancestors

  Given:

                     Pods (normal)
                     /
          Pod-A (-1)
          /           \
   cgroup-A1(none)   cgroup-A2(tiering)

  The effective mode for tasks in cgroup-A1 and cgroup-A2 is:

                     Pods (normal)
                     /
          Pod-A (-1)
          /           \
   cgroup-A1(normal)   cgroup-A2(normal|tiering)

- The rationale behind these semantics

  The cgroup hierarchy semantics invoked here are those of resource
  limits: an ancestor's limit binds every descendant. That is the right
  semantics for limits: a limit partitions a shared, finite resource,
  and what a descendant consumes comes out of its ancestors' pool, so an
  ancestor's limit must bind every level below it.

  A policy request is a different kind of control: it is a preference
  about how the kernel should treat the workload, not a quantity drawn
  from a parent's pool. Expressing it consumes nothing, so the limit
  semantics does not carry over; the question is only how the preferences
  of several levels should combine.

  We chose the additive interpretation: a descendant may ask for more on
  top of what its ancestors asked for, while an opt-out at any level
  still wins: DISABLED anywhere in the ancestry caps the whole subtree.

Task and folio keying
~~~~~~~~~~~~~~~~~~~~~

The NUMA balancing knob is consulted at some callsites with only a folio
and no task, and at others with only a task and no folio.

- Task only

  kernel/sched/fair.c: task_numa_fault()
  kernel/sched/fair.c: update_scan_period()
  kernel/sched/fair.c: migrate_degrades_locality()
  kernel/sched/fair.c: exceed_llc_capacity()
  kernel/sched/fair.c: get_pref_llc()
  kernel/sched/fair.c: get_scan_cpumasks()

- Task and folio

  kernel/sched/fair.c: should_numa_migrate_memory()

- Folio only

  mm/memory-tiers.c: folio_use_access_time()
  mm/mempolicy.c: folio_can_map_prot_numa()
  mm/migrate.c: folio_migrate_flags()
  mm/migrate.c: migrate_misplaced_folio_prepare()
  mm/migrate.c: migrate_misplaced_folio()

Therefore, the helpers are split by side:

  folio_numab_effective_mode()
  folio_numab_in_*_mode()
  task_numab_enabled()
  task_numab_get_modes()

Another concern is how to handle callsites that have both a task and a
folio. The following anchor resolves it. Both the user fault path and the
kswapd demotion path reach folio_migrate_flags():

kswapd demotion (no task):

  kswapd
  + shrink_folio_list
    + demote_folio_list
      + migrate_pages
        + folio_migrate_flags
          + folio_numab_in_tiering_mode

Fault path (user task):

  do_numa_page
  + mpol_misplaced
    + should_numa_migrate_memory(task-m, folio-n) (A)
      + task or folio?
  + migrate_misplaced_folio_prepare(folio-n)
  + migrate_misplaced_folio(folio-n)
    + migrate_pages
      + folio_migrate_flags(folio-n) (B)
        + folio_numab_in_tiering_mode

folio_migrate_flags() must key on the folio, since kswapd has no task to
consult. In the user fault path, both should_numa_migrate_memory() and
folio_numab_in_tiering_mode() are called. Since both refer to the same
folio in this context, keying on the folio at B but not at A would be
inconsistent. The rule is therefore simple: if a folio is available, key
on the folio; otherwise, key on the task. This also keeps the keying
robust to future refactoring: if either folio-keyed function is ever
reached by a kernel thread, the answer does not change.

Storage of numab_mode
~~~~~~~~~~~~~~~~~~~~~

Some cgroups do not have the memory controller enabled:

Given:
          Pods (+memory)
          /
       Pod-A ()
        /
      cgroup-A1 ()

cgroup-A1 has no memcg. Given the task/folio split, where should the
mode for such a cgroup live?

- If the mode were stored in struct cgroup and setting it on cgroup-A1
  were allowed, tasks in cgroup-A1 would use cgroup-A1's request while
  its folios would use Pod-A's memcg request, which is inconsistent.

- Storing the mode in struct mem_cgroup avoids that: cgroup-A1 cannot be
  set, and both its tasks and its folios resolve to the same ancestor
  memcg (Pod-A).

For consistency, the mode is stored in mem_cgroup, setting it on a
cgroup without the memory controller enabled is rejected with
-EOPNOTSUPP, and both task and folio lookups resolve a cgroup without a
memcg to its nearest ancestor memcg. A request is effective only while
its memcg is visible and online. Disabling the memory controller or
offlining the memcg clears the request, and lookups skip such a memcg, so
a pinned memcg cannot keep applying a stale request. A re-enabled memcg
starts transparent.

Shared memory semantics
~~~~~~~~~~~~~~~~~~~~~~~

With the mode stored in the memcg, the longstanding shared-memory
problem in memcg has to be addressed for per-memcg NUMA balancing as
well.

Given:

    cgroup-A     cgroup-B
           \       | (charge)
           Memory_shared_by_cgroup-A_and_cgroup-B

A choice is required when the NUMA modes of cgroup-A and cgroup-B
differ. Since the folio-side lookup starts at the folio's memcg, a task
in cgroup-A operating on this shared memory uses cgroup-B's folio-side
mode. If DISABLED were applied to memory, cgroup-B's DISABLED would
prevent cgroup-A from promoting the shared page. We avoid that by making
DISABLED task-side only.

In our experience, NUMA balancing is mostly disabled to avoid the
potential latency spikes it can cause. The intent of disabling it for
cgroup-B is to avoid latency spikes for tasks in cgroup-B; it does not
matter whether tasks in other cgroups perform NUMA balancing. We
therefore disable the task side only, not the memory side: DISABLED
applies to tasks, not to memory.

Demotion is global reclaim, not a per-cgroup balancing request.
DISABLED only opts the cgroup's tasks out of NUMA balancing; it must
not become a memory-side reclaim veto, or a cgroup could keep cold
pages in the fast tier, leaving less fast-tier capacity for other
cgroups' hot pages and defeating promotion for those pages.

So, in the end, DISABLED is a task-side property and does not gate
memory-side operations.

Shared fast tier
~~~~~~~~~~~~~~~~

A promotion competes for capacity in the shared fast tier, but it
cannot consume more memory than the cgroup may already consume: it moves
the cgroup's own folios, within its own memory limit, from the slow tier
to the fast tier. Each contributor's own limit bounds its footprint,
but the fast tier is still a shared resource; demotion is the global
release valve that keeps cold pages from occupying it indefinitely.

So a child can still enable tiering mode if its ancestor has only set
normal.

Given:

                     Pod (normal)
                     /        \
          cgroup-A (none)  cgroup-B (tiering)

the effective mode is:

                      Pod (normal)
                     /        \
          cgroup-A (normal)  cgroup-B (normal|tiering)

What an ancestor cannot do now is cap only tiering while leaving normal
balancing available below. If that targeted cap is wanted, the natural
extension is a negative request: NO_TIERING would propagate down the
tree like the positive requests and mask TIERING out of the effective
mode. It would cap promotion, not demotion; demotion remains global
reclaim. With:

                  Pod (normal | no_tiering)
                     /            \
            cgroup-A (none)   cgroup-B (tiering)

the effective modes would be:

                      Pod (normal)
                     /            \
            cgroup-A (normal)  cgroup-B (normal)

For this version, I would keep the modes minimal and add NO_TIERING as a
follow-up once there is a real user for it.

Cost
====

On the task side, an ancestor can opt out the whole subtree with
DISABLED, but cannot cap only tiering while leaving normal balancing
available below. On the memory side there is no opt-out at all:
DISABLED is task-side only, so a descendant's TIERING request is enough
to enable promotion for its own memory, and promotion is the mode that
consumes the shared fast tier.

The per-cgroup override was measured with schbench, 384 workers, on a
two-node 384-core machine. In that configuration, a cgroup mode put the
cgroup at the throughput of the equivalent system-wide setting, within a
fraction of a percent. This is a throughput measurement, not a
microbenchmark of the scan path: while the static key is on, a folio
lookup is O(cgroup depth), and callers that need more than one bit now
share a single lookup. An effective-mode cache may be worthwhile for
very deep hierarchies; that is left for follow-up measurements.

Limitations
===========

The mode is per-memcg, not per-task. A cgroup without its own memcg
cannot be set; its tasks and folios resolve to the nearest ancestor
memcg. If multiple tasks in a single cgroup need different modes, place
them in separate child cgroups with the memory controller enabled.

For threaded cgroups, the mode must be set on the nearest domain
ancestor that has the memory controller enabled, because the memory
controller is not threaded.

Changelog
=========

RFC v3 -> RFC v4:
- Store numab_mode in mem_cgroup instead of struct cgroup
- Refine the commit log

RFC v3: https://lwn.net/Articles/1101442/

RFC v2 -> RFC v3:
- Replace the struct_ops interface with two kfuncs, following Tejun's
  suggestion.
- Improve function naming and simplify the code (David)

RFC v2: https://lwn.net/Articles/1099962/

RFC v1 -> RFC v2:
- v1 keyed the hook on the memory cgroup and temporarily embedded the
  cgroup id into the struct_ops value, because cgroup struct_ops support
  was still under development.
- v2 attaches through the cgroup struct_ops support that has since landed
  in bpf-next, keys the task side on the task's cgroup and the memory side
  on the folio's memcg, and adds the memory-tiering mode alongside enable
  and disable.

RFC v1: https://lwn.net/Articles/1054030/

Yafang Shao (4):
  sched: add helpers for numa balancing
  sched: sample NUMA balancing mode once per path
  sched: add BPF-based per-cgroup NUMA balancing mode selection
  selftests/bpf: add tests for the numab kfuncs

 include/linux/memcontrol.h                    |   6 +
 include/linux/sched/numa_balancing.h          | 144 +++++++++
 init/Kconfig                                  |  23 ++
 kernel/sched/bpf_numab.c                      | 261 +++++++++++++++++
 kernel/sched/build_policy.c                   |   4 +
 kernel/sched/fair.c                           |  99 +++++--
 kernel/sched/sched.h                          |   1 -
 mm/memcontrol.c                               |  14 +
 mm/memory-tiers.c                             |   9 +-
 mm/mempolicy.c                                |   9 +-
 mm/migrate.c                                  |   9 +-
 mm/vmscan.c                                   |   6 +-
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/bpf_numab.c      | 273 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_numab.c |  32 ++
 15 files changed, 844 insertions(+), 48 deletions(-)
 create mode 100644 kernel/sched/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab.c

-- 
2.52.0

