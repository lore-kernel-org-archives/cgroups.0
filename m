Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9152438758A;
	Wed, 13 May 2026 20:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778705986; cv=none; b=K1DSweO5hz+LPoGD8BrMnzB/+TndhzVgjkznKJOgAScTpbz2x/PNjxx6TZgANf6+g4e48WKbYWQwPib0N1QqOZBEswVfhBXfApIGYVZ2ke2GmjfgasNMFr8JIZLu9azpKNEChWzyTQq5FKOa+3YLr6uH94Z1sGDbK3N/lHavcKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778705986; c=relaxed/simple;
	bh=LhMIh5nc6qtE34cxe8KrPpZuUuguzIdvPjKnK642xDw=;
	h=Date:Message-ID:From:To:Cc:Subject; b=J1cgM9rCs+ONn8V4q9kiizEsSLY1UkxsLqNeucnCPqW09hTDrQRwfARn8frIMQFeM7x1ZXpnNCg15RWLjsOl4ZgLhay66J4827F8gZyjE2sq0cMTgYUBR70vK5Lc3q/nPm5Rb5DRvtK6CrtvNtvm0gRHRw2BOGmp5ayk2T+v7y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGJI7uaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGJI7uaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB65AC2BCB7;
	Wed, 13 May 2026 20:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778705985;
	bh=LhMIh5nc6qtE34cxe8KrPpZuUuguzIdvPjKnK642xDw=;
	h=Date:From:To:Cc:Subject:From;
	b=EGJI7uazHHNd6OuBoOw997n+JALoSvQm1RAcoQLttId5OxRDYo5lZ26hZHrtRlDlI
	 n6DFzM4pb9cRrAE6Zr5eyYiSOp/qKryTTCi4vKwtr8bPuEmOPdv5wwTnNGhFtcKAca
	 8Y5t90VoKhFGLMyR5GSpcTkSrTQKzqNpl/o6EBmT357vzA2JIOhJXirdRB/LNKDzhP
	 Ai7zuN9MzSJ8IXQBYqvNzPbPnhsbED85OTTmz1wUzpvEhqH8f0TlJbzbwCe9YnATgF
	 MFFoh5zLnQQzhNcnJA6qXtU6hoRvpDWcsFHUaDQLK/KNndsoq5uiFbengTo96oTIWm
	 QRyAQu6tbI2NA==
Date: Wed, 13 May 2026 10:59:45 -1000
Message-ID: <6038eeed9424f26cc6bec8c0a01c8e43@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Fixes for v7.1-rc3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Linus.

The following changes since commit d8769544bde51b0ac980d10f8fe9f9fed6c95995:

  docs: cgroup-v1: Update charge-commit section (2026-05-04 11:02:12 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.1-rc3-fixes

for you to fetch changes up to 345f40166694e60db6d5cf02233814bb27ac5dec:

  cgroup/cpuset: Return only actually allocated CPUs during partition invalidation (2026-05-13 08:54:53 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.1-rc3

- cpuset fixes:
  - Partition invalidation could return CPUs still in use by sibling
    partitions, producing overlapping effective_cpus.
  - cpuset_can_attach() over-reserved DL bandwidth on moves that stayed
    within the same root domain.
  - Pending DL migration state leaked into later attaches when a later
    can_attach() check failed.
  - Reorder PF_EXITING and __GFP_HARDWALL checks so dying tasks can
    allocate from any node and exit quickly.

- dmem: propagate -ENOMEM instead of spinning forever when the fallback
  pool allocation also fails.

- selftests/cgroup: percpu test error-path leak, bogus numeric
  comparison of cpuset strings, and a zero-length read() that silently
  passed OOM-kill tests.

----------------------------------------------------------------
Chen Wandun (1):
      cgroup/cpuset: move PF_EXITING check before __GFP_HARDWALL in cpuset_current_node_allowed()

Guopeng Zhang (3):
      cgroup/dmem: Return -ENOMEM on failed pool preallocation
      cgroup/cpuset: Reset DL migration state on can_attach() failure
      cgroup/cpuset: Reserve DL bandwidth only for root-domain moves

Hongfu Li (2):
      selftests/cgroup: Fix cg_read_strcmp() empty string comparison
      selftests/cgroup: Fix string comparison in write_test

Yu Miao (1):
      selftests/cgroup: Fix error path leaks in test_percpu_basic

sunshaojie (1):
      cgroup/cpuset: Return only actually allocated CPUs during partition invalidation

 include/linux/sched/deadline.h                     |  9 ++++
 kernel/cgroup/cpuset-internal.h                    |  1 +
 kernel/cgroup/cpuset.c                             | 56 ++++++++++++----------
 kernel/cgroup/dmem.c                               |  1 +
 kernel/sched/deadline.c                            | 13 +++--
 tools/testing/selftests/cgroup/lib/cgroup_util.c   |  5 +-
 .../selftests/cgroup/test_cpuset_v1_base.sh        |  2 +-
 tools/testing/selftests/cgroup/test_kmem.c         | 10 ++--
 8 files changed, 63 insertions(+), 34 deletions(-)

Thanks.

--
tejun
