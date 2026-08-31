Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3C838331C;
	Mon, 31 Aug 2026 20:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788208997; cv=none; b=VLAQXI3/reNuexctl2X4uJmgA8cT1HQfxvVyB3eW+2hqMLfOapp2TrXdyD1tCobBnDMPxzCb+UUNHgeYZoQLtkjuHSUZZ5kAd2o3rF2oWdEzfpOsqZOswOE4LpP7aY2Wnwg5+PoV2vEqKE0D2C4jEqnOAFoLqfREO6VrNzxYxmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788208997; c=relaxed/simple;
	bh=pzglFtoMJd1tD3qI+ZwyGHnLJf1bLNgRYsjSVWn5V5g=;
	h=Date:Message-ID:From:To:Cc:Subject; b=BFsI7rabsoN/sEMwxiPTHgANqyyMU3pD8j2c4AkLsRhcr7FGNujjRKNw3VGMxyXT4ReBqmCjOSBYsEiXbv3TTroqYeDRN+FNVYw30LfjbvWPMTW8ynGWYL8oF6rfLCYUF4Oywh3wAawCxClQIruQB+iTIEJw5PmS3V2nb+R/tQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4nmBc1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4nmBc1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E991F000E9;
	Mon, 31 Aug 2026 20:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788208995;
	bh=FQs3kWAIR3XsNONBEC89mzbEzMzRluLlBjXxJVRJ2uk=;
	h=Date:From:To:Cc:Subject;
	b=P4nmBc1p3qn2/L8a+4lOJnQmGIBeHe/QQgnajiWbxtrUG9/tkXM/tbsS//GYXsQKW
	 q/Su/xjunD99taWI7iGn9mafojcldPAKjjsQR66I5jsBctE1al+l6I/GgCh8JB1czJ
	 oVq3PLNOvnrFxOmklW1Dh/VzNOlwQgmusVuung5DZv5Wccc4XwgRzDPfu5DhqtU9i0
	 s8CBZZ0IQe1zbVTqr7VOOYsFSrg86NgLjJYffAtHY2ulS75S/PNzS9CG4kl0tlQRkt
	 WzDLicoTIQk+VMA/lnF6R5f7I1F7IT1zfPUE/LZxzsSZT9EDi2TUmpd7vXT/0RsAaX
	 i+wWcr0YNOclg==
Date: Mon, 31 Aug 2026 10:43:14 -1000
Message-ID: <946c7fbb6329562f80c4900716aaf1a6@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Waiman Long <longman@redhat.com>
Subject: [GIT PULL] cgroup: Fixes for v7.3-rc1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Linus.

The following changes since commit 2d19207f3fc8e08bab3270af2e3835358ab1473a:

  selftests/cgroup: Remove redundant chown in test_cgcore_lesser_ns_open (2026-08-14 08:32:58 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc1-fixes

for you to fetch changes up to 3f4b7d1a49c5c826f3be9b684313eea5b83ac232:

  selftests/cgroup: test clone3() into a previously killed cgroup (2026-08-31 06:19:53 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.3-rc1

- After cgroup.kill was written to a cgroup, every child cloned into it
  with CLONE_INTO_CGROUP was spuriously killed because the fork path
  snapshotted the kill counter before resolving the target cgroup.

- Releasing an isolated cpuset partition dropped the isolation of CPUs
  isolated on the kernel command line.

- Selftest and documentation fixes.

----------------------------------------------------------------
Cheng Lingfei (1):
      docs: cgroup-v2: fix misc.events key format description

Etienne Perot (2):
      cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP children
      selftests/cgroup: test clone3() into a previously killed cgroup

Guopeng Zhang (3):
      selftests/cgroup: Drop invalid boot isolation comparison
      cgroup/cpuset: Preserve boot-isolated CPUs on partition release
      selftests/cgroup: Add test for preserving boot-isolated CPUs

Hemanth Selam (1):
      selftests/cgroup: set the test plan after the setup checks

Hongfu Li (1):
      selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter

 Documentation/admin-guide/cgroup-v2.rst           |  2 +-
 include/linux/cgroup-defs.h                       |  5 +-
 kernel/cgroup/cgroup.c                            |  6 +--
 kernel/cgroup/cpuset.c                            | 39 ++++++++++----
 tools/testing/selftests/cgroup/test_core.c        |  2 +-
 tools/testing/selftests/cgroup/test_cpu.c         |  2 +-
 tools/testing/selftests/cgroup/test_cpuset.c      |  2 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 64 ++++++++++++++++++++---
 tools/testing/selftests/cgroup/test_freezer.c     |  2 +-
 tools/testing/selftests/cgroup/test_kill.c        | 57 +++++++++++++++++++-
 tools/testing/selftests/cgroup/test_kmem.c        |  4 +-
 tools/testing/selftests/cgroup/test_memcontrol.c  |  2 +-
 tools/testing/selftests/cgroup/test_pids.c        |  2 +-
 tools/testing/selftests/cgroup/test_zswap.c       |  2 +-
 14 files changed, 159 insertions(+), 32 deletions(-)

Thanks.

-- 
tejun
