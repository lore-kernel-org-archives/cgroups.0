Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED5138737E;
	Fri, 13 Mar 2026 20:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773433723; cv=none; b=b8AiubMifgN7RFsG3i1ZtWCFV3cmEDuh8NCDNil0FKa2sMesbSMUHoJcI/IISC19B9oLSnXEtM4UMnhV8nP5sNicGb3z3r4oKW8w3FEec+KRCpnyxLzThdUoyJdqXS6JgmRmDvILfuI1YVG5RNRcyAJkEre5meNMikhaUA0JQp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773433723; c=relaxed/simple;
	bh=4CxQS1xFdi5X8fdTBOGLQwCS3T4yj6Ky5udoOs3A7Vc=;
	h=Date:Message-ID:From:To:Cc:Subject; b=GkGZjv2fYjcGc9cQuSdJ02HGDbpFvRKRmaXcV6WsSe07U0oIwJ6fQjFfUPAu7hBryIezcwzHeTcIHSLNwG1Y9meueNVW+XwD15P/Lrqfp4/taqAp4hfQhNBhjdncKbj0Z6HNaxkiZJ+99fuk6tLKs4+M3/Xz81ieFC2uGo0BfJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tOgytqqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tOgytqqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A58BC19421;
	Fri, 13 Mar 2026 20:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773433723;
	bh=4CxQS1xFdi5X8fdTBOGLQwCS3T4yj6Ky5udoOs3A7Vc=;
	h=Date:From:To:Cc:Subject:From;
	b=tOgytqqANy4gdRfOeGJAnxONSmFGD71i6XBHOSd0zpVHp3DkKRjZHedDXhau6o5qo
	 T/ebBXGIgwoss5ONxiKqK3mDx7RaAtLTO7Jo1inkymZeI28YjzQFALS6gIJ6iFIcN1
	 Wk2d/+to43ZbSFNWlGYuGEFeT/iBVcb/BALUuivxKT2DjIt0XTXgYfC20RreQJuGgs
	 1EhssOFtwzEibyFaKVK3dGb01PD4xUk61O1Lzd2XR6s30qae2BdytlM3q3wHCKPCs/
	 Di0aKTx0et+8gNVZp+mt8ozzKhAun2ve65S/seqlEpKoM4hlh6mGDL2jyI6hi8hnki
	 q/qmGy6pDUXsQ==
Date: Fri, 13 Mar 2026 10:28:42 -1000
Message-ID: <bec9d24e3542e85a4bdb229dee142b19@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Fixes for v7.0-rc3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

The following changes since commit 5ee8dbf54602dc340d6235b1d6aa17c0f283f48c:

  Merge tag 'fsverity-for-linus' of git://git.kernel.org/pub/scm/fs/fsverity/linux (2026-03-05 11:52:03 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.0-rc3-fixes

for you to fetch changes up to a72f73c4dd9b209c53cf8b03b6e97fcefad4262c:

  cgroup: Don't expose dead tasks in cgroup (2026-03-06 12:43:25 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.0-rc3

- Hide PF_EXITING tasks from cgroup.procs to avoid exposing dead tasks
  that haven't been removed yet, fixing a systemd timeout issue on
  PREEMPT_RT.

- Call rebuild_sched_domains() directly in CPU hotplug instead of
  deferring to a workqueue, fixing a race where online/offline CPUs
  could briefly appear in stale sched domains.

----------------------------------------------------------------
Sebastian Andrzej Siewior (1):
      cgroup: Don't expose dead tasks in cgroup

Waiman Long (1):
      cgroup/cpuset: Call rebuild_sched_domains() directly in hotplug

 kernel/cgroup/cgroup.c |  6 +++++
 kernel/cgroup/cpuset.c | 59 ++++++++++++++++++++++++++------------------------
 2 files changed, 37 insertions(+), 28 deletions(-)

Thanks.

--
tejun
