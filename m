Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792427490;
	b=ZQzdlicqZN5k0zRpHlduplxjGpEbEi5MNJy/uiVO19mAbyEZ3SF9/ReIcNCwbZgifbYv
	 N8O7OZmJOA4uMoPKVcOlcZYai7SP9Tq44ZGThNVCCJ7tqdzNMgork1C9PzcxunuxOtRCI
	 BOqa/04edfPwkfTfx/aIzbPh8liTeM8WLsByp8rt9SLoo5oU+CubOcurSbN0sOTpuUHPy
	 WeQ5xy6bneWKeVMV9KgjTxCVkJXu2Vb4KX/nr3rSWw1Y7Tw9hNoKXr7EZkCYvnCzwRhNE
	 d30++q4FUPAR+/+RwTdNWXPVkjNvjTUgHzcOxrBkOlI+h3c5xgovBiZiGjQ9VWFgLWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792427490;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject;
	bh=BQkPCxRYiTAiL9B7JuC/MlADAPxMOkFS/2yakF4ZChw=;
	b=GI2Btkjb8vIqj/t0WajZ8mQuE79BdPy7U1u8ucNAJpbcJQY//KrihnLQi/lp16Z4O+y7
	 K9VOCuyml4cxn9MpaTLE4KD2wdZP4tqGLZSCrMTpkuOu98yS0iATbwoR9NMY4xwCqqgDs
	 +hDgLIs7j0YMEh42KP6+VjIw/GF4Lqty7V2hHCdYmVHWvkNihfOWIsDe5srWZVs3xa2VP
	 Lr7WbSxhJaxHY+g7vPjxE7eh46bPg9GekZwBZO6jqRvbRDAlUptrGQOrmz6m7t52agPE3
	 a1gfbLRMQYXgXKqfKMWhYOVF0bt/3bk0+VIDIIG7ZJveKUTIYPyq3mM3iS7v9trts5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ic3lOEBK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3339D606A31B;
	Mon, 19 Oct 2026 16:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ic3lOEBK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BDF1F000C4;
	Mon, 19 Oct 2026 16:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792427489;
	bh=BQkPCxRYiTAiL9B7JuC/MlADAPxMOkFS/2yakF4ZChw=;
	h=Date:From:To:Cc:Subject;
	b=ic3lOEBKFW8+8x9aXXtK2W8QGxpo8anNSSF6YEir9Q0JYW6txe0XRw+cwYf5l4S4E
	 84WB0LafN1mPVRCVntKvIzFBdlpPHqkqYRaouxvIUoqlHSl/SVJHEO0C+RMv5iSkCr
	 fSFChdvaB+QkNcWcyxsr21XLYNQRpRcfHw2ppmivyqA1nonyMoVTy/5z5KnoPHiBJR
	 cQ2UiMSJ/QU5cgQT1PyG6d5WLOGNPUbeFfmh2wMImxGmTNFvz0e77wXXg+tHpac5O5
	 PH4cFCkWEow+4ZM4GKTOgVPQWtwluIWi4tCpt8o1Jq2IJDfWxc6ncDojwJWvbA8mDo
	 HJmMDnVy2Nf4Q==
Date: Mon, 19 Oct 2026 06:31:28 -1000
Message-ID: <410cdfd35a22cb6eb13ea6324bad7eda@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Changes for v7.4
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Hello,

The following changes since commit b8eb5fd5bdb4c03758b056c70e5e1d962ca89757:

  cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug() (2026-10-06 06:36:51 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4

for you to fetch changes up to 1850c669516cb8568150937497a9a16a7bfa1582:

  selftests/cgroup: test pids.events notification (2026-10-16 09:52:06 -1000)

----------------------------------------------------------------
cgroup: Changes for v7.4

- A write to cgroup.subtree_control or cgroup.type could hang in D state for
  as long as a task pinning a dying controller took to exit, as syzbot
  reported. The wait is now interruptible.

- cpuset: the deadline bandwidth check ran on cpusets that weren't valid
  partition roots, failing cpuset writes with -EBUSY while deadline tasks
  existed. The CPU count the fair class takes from cpuset assumed a shared
  hierarchy that cgroup1 may not have.

- Finding a cgroup's effective controller state no longer walks up the
  hierarchy, for per-I/O users such as nvmet. io.stat reads of cgroups
  without block devices skip the stat flush.

- cpuset v1-only code moved to the v1 file and the exclusive flag dropped
  from v2, with documentation corrections for partition roots and
  boot-isolated CPUs.

- Dead cgroups fail writes with -ENODEV consistently, plus small cleanups.

- Selftest fixes, most visibly for tests that skipped on machines with many
  mounts, and a new pids.events notification test.

----------------------------------------------------------------
Guopeng Zhang (3):
      cgroup/cpuset: Remove redundant sched domain rebuild from update_prstate()
      docs: cgroup-v2: Describe boot-isolated CPUs in cpuset.cpus.isolated
      docs: cgroup-v2: Describe effective CPUs of partition roots

Karl Mehltretter (1):
      cgroup/dmem: Fix eviction helper reference in dmem_cgroup_try_charge()

Konstantin Khorenko (2):
      selftests: cgroup: skip test_memcg_sock under cgroup.memory=nosocket
      selftests: cgroup: make test_memcg_sock check flushed sock stats

Peng Fan (1):
      cgroup: use assign_bit() where applicable

Peng Yu (1):
      cgroup: Track the effective css in each cgroup

Ren Tamura (2):
      selftests: cgroup: Enable the cpu controller in test_cpu
      selftests: cgroup: Preserve command arguments in with_stress.sh

Ridong Chen (1):
      cgroup/cpuset: Move cpuset_update_flag() to cpuset-v1.c

Sahaj Chaudhari (1):
      selftests/cgroup: test pids.events notification

Sasha Levin (2):
      selftests: memcg: Don't close an uninitialized fd
      selftests/cgroup: Free the paths returned by cg_control()

Sebastian Andrzej Siewior (2):
      cgroup: Move cgrp_dead_ task+iwork into its own struct
      cgroup: Use %p for pointer formatting

Shaojie Sun (3):
      cgroup: namespace: Drop BUG_ON() in copy_cgroup_ns()
      selftests/cgroup: read the entire file in read_text()
      selftests/cgroup: don't crash on a truncated mount entry in cg_find_root()

Tejun Heo (4):
      cgroup: Return -ENODEV consistently for a dead cgroup
      cgroup: Return ERR_PTR from cgroup_kn_lock_live()
      cgroup: Make the offline drain interruptible
      cgroup: Merge branch 'for-7.3-fixes' into for-7.4

Usama Arif (1):
      blk-cgroup: skip rstat flush for cgroups without blkgs

Vishal Chourasia (1):
      selftests/cgroup: add settings file with a longer timeout

Waiman Long (3):
      cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root only
      cgroup/cpuset: Remove CS_CPU_EXCLUSIVE handling code from v2
      cgroup/cpuset: Use cpuset_v2() in cpuset_num_cpus()

 Documentation/admin-guide/cgroup-v2.rst            |  62 +++++--
 block/blk-cgroup.c                                 |  11 +-
 include/linux/cgroup-defs.h                        |   8 +
 kernel/cgroup/cgroup-internal.h                    |   2 +-
 kernel/cgroup/cgroup-v1.c                          |  26 ++-
 kernel/cgroup/cgroup.c                             | 181 +++++++++++++--------
 kernel/cgroup/cpuset-internal.h                    |   8 +-
 kernel/cgroup/cpuset-v1.c                          |  59 ++++++-
 kernel/cgroup/cpuset.c                             | 145 ++---------------
 kernel/cgroup/debug.c                              |  18 +-
 kernel/cgroup/dmem.c                               |   4 +-
 kernel/cgroup/freezer.c                            |   5 +-
 kernel/cgroup/namespace.c                          |   2 -
 tools/testing/selftests/cgroup/lib/cgroup_util.c   |  58 ++++++-
 .../selftests/cgroup/lib/include/cgroup_util.h     |   3 +
 tools/testing/selftests/cgroup/settings            |   1 +
 tools/testing/selftests/cgroup/test_cpu.c          |   5 +-
 tools/testing/selftests/cgroup/test_kmem.c         |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |  81 ++++++---
 tools/testing/selftests/cgroup/test_pids.c         |  73 +++++++++
 tools/testing/selftests/cgroup/with_stress.sh      |   2 +-
 21 files changed, 471 insertions(+), 285 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/settings

-- 
tejun
