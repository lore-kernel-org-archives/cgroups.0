Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793130370;
	b=adQVQmKCrU5AAIO6pTRlNWpCV5F8fUVkdySJvW3QYSgHgt4UUSp3k6RStc0YpvtsjvjO
	 yzGzAe/RSHCtYM0aP5DJ55WnL2BKGQQdpkDYzLxyhebd465UrRWkoqEGxgoGF6yN4sWvx
	 MZPal9DLrVzmuFsyWvOrs0b0IDGsa0UgfhfmVeeXDDWu47MxGYukCu9pZo6T3xxpO90te
	 +CLhRIXtSTgm0otBZGV+O/OxnvoCQ3aKXudUKTnACnClQ4zF8kRgDJwx0qAWTKOEERTS7
	 pEamBY7XPtyi0c/fwfLGL+GdMdSZdUlOMFZg9t5wVpHj0tuYrKSpgW9ywEsA3N2KdOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793130370;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject;
	bh=y9zesWRNIpPzsx/0tL1PLhlHzMGCdhSTE+soVlAoOw0=;
	b=ka3KuZndQmBnlWUleCg1a95QkJGR3c6yuilL8/zOQemohrHjYFkrOohqNxqeP0Huj5lZ
	 tqWol+9Xejdx+nbSPQ6MlQtCWYeFc/3yDexGOkTzUqbpfjYxnQLo+LQZJ/gqTxjLWoTAR
	 pzPS18eDtKrrQhs9Uj9Xlp1DF0DpcscvQgQgHrppfMUUP8lAso8cU02NNBc0teZtn97pv
	 Ahklp54h+bvlAUsPxv3sk1N4h9gk1t9KVhEeI15MxR5vs0vExKUI0Q9B1rzUmjrZbB0wt
	 9MrTaV8zOlMC/Lgr2U9JbIIRtBG7nsKsNInbfO9wv+NKDmdOK7soAmlNQ4Nhi9njKSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G8JSIEAk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F77606A31D;
	Tue, 27 Oct 2026 19:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G8JSIEAk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B631F01825;
	Tue, 27 Oct 2026 19:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793130369;
	bh=y9zesWRNIpPzsx/0tL1PLhlHzMGCdhSTE+soVlAoOw0=;
	h=Date:From:To:Cc:Subject;
	b=G8JSIEAkOtjmGRamZA+MMA24zOFST+LD3/MFeopaPIkPlQgo2V3PhGXJFHAdjBi1E
	 1uTe6HN+iHO4omhfSicB2lUYOsUOdj0v2XfPWffnWzfuYHZ2zlrpFCkgJ83r5T1UX8
	 E8nVHG9Rr8GjZVSU/moZV+sGSHF9MZe7g0ApDp0GWBhzZPcN+ug1pbgWbb3AJw88ge
	 Di+37VKokE3lY/jK8+LPjY41+An1HZMof9IjcRNFl9nD0c0zCiCs4tcAbfpk7IvxKK
	 SCkaBpfmjEBTOXpHywb8jlXfJoA0/2TnW7A0XSbgEP2jdqOQQwzu9IKxhdbKd9cmwt
	 14g50/iZyXplQ==
Date: Tue, 27 Oct 2026 09:46:08 -1000
Message-ID: <728f269e1bd680a3d18d3b7c826fe864@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Fixes for v7.4
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Hello,

The following changes since commit 1850c669516cb8568150937497a9a16a7bfa1582:

  selftests/cgroup: test pids.events notification (2026-10-16 09:52:06 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4-fixes

for you to fetch changes up to 518cec2def9992192291f5028edc077fb2e475e9:

  cgroup/cpuset: Integrate compute_partition_effective_cpumask() into compute_effective_cpumask() (2026-10-26 07:44:43 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.4

- cgroup.kill did not kill a process whose thread group leader had exited
  while other threads still ran, nor those threads once moved to another
  cgroup, letting a process survive its container being killed.

- A cgroup.procs write under favordynmods could migrate a newly forked
  process before fork linked it to its cgroup, corrupting cgroup task lists.

- cpuset partition fixes for nested hierarchies: invalidation, revival,
  shrinking and switches between root and isolated could leak isolated CPUs,
  skip or miscompute the housekeeping check, or leave wrong effective CPUs.

  - A root partition can no longer be created under an isolated parent or
    stay valid under one, as disabling it could leave no housekeeping CPUs.

  - Enabling a partition failed when a grandchild held tasks, although the
    parent had none of its own.

  - Separately, an allocation racing with a cpuset.mems update could drop
    its mempolicy nodemask and land on the wrong node, and a memoryless node
    in cpuset.mems triggered a spurious "movable nodes only" warning.

  - Two no-functional-change cleanups of the effective CPU computation.

----------------------------------------------------------------
Daehyeon Ko (1):
      cgroup: serialize migrations of newly forked processes

Gregory Price (Meta) (2):
      cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
      cgroup/cpuset: check effective mems for a movable-only configuration

Guopeng Zhang (1):
      cgroup/cpuset: Fix task checking when enabling a partition

Kir Kolyshkin (2):
      cgroup: fix cgroup.kill for exited thread group leader
      selftests/cgroup: test cgroup.kill with an exited thread group leader

Sasha Levin (1):
      cgroup: don't kill migrated processes through their exiting threads

Waiman Long (20):
      cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()
      cgroup/cpuset: Consolidate isolated_cpus_can_update() into prstate_housekeeping_conflict()
      cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check
      cgroup/cpuset: Do housekeeping check before converting invalid partition to valid
      cgroup/cpuset: Properly disabling partition when partition state switching fails
      cgroup/cpuset: Don't allow a child root partition under an isolated parent
      selftests/cgroup: Add tests for isolcpus housekeeping check
      selftests/cgroup: Add tests for nohz_full housekeeping check
      selftests/cgroup: Skip test_cpuset_prs.sh test if some required CPUs are offline
      cgroup/cpuset: Find furthest isolated ancestor for invalidated isolated partition
      cgroup/cpuset: Properly compute effective xcpus in update_parent_effective_cpumask()
      cgroup/cpuset: Fix incorrect effective_cpus bug in update_cpumasks_hier()
      cgroup/cpuset: Minor fixes to prstate_housekeeping_conflict()
      selftests/cgroup: Check for a single range nohz_full CPUs before running test matrix
      cgroup/cpuset: Prevent recursive call of remote_cpus_update() via update_cpumasks_hier()
      cgroup/cpuset: Make sure compute_partition_effective_cpumask() is only called for valid partition
      cgroup/cpuset: Release invalid isolated CPUs in compute_partition_effective_cpumask()
      cgroup/cpuset: Release invalid isolated CPUs with a shrunk root partition parent
      cgroup/cpuset: Relocate compute_*effective_cpumask() and compute_effective_nodemask()
      cgroup/cpuset: Integrate compute_partition_effective_cpumask() into compute_effective_cpumask()

 Documentation/admin-guide/cgroup-v2.rst           |   4 +-
 kernel/cgroup/cgroup.c                            |  30 +-
 kernel/cgroup/cpuset-internal.h                   |   6 +
 kernel/cgroup/cpuset.c                            | 678 +++++++++++++---------
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 276 +++++++--
 tools/testing/selftests/cgroup/test_kill.c        | 158 +++++
 6 files changed, 823 insertions(+), 329 deletions(-)

-- 
tejun
