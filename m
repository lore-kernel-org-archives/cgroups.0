Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0604533A014;
	Mon, 13 Jul 2026 21:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783978153; cv=none; b=oOKLc9TbliIaUjTBB9HtZzUHDnDyQieQQdJHNZMXRtX/yFlpW9NYuJEPizabyZw2U1wHfvJ1nV1X5i4iPqOWFJY5c2sJVs5VIqoHsT6SBajTjF1bLkf+drRxdjL5NKZL1/HWNNJIie2ynRUUVhxSBHvlQtkOob2LVPEceLPUoWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783978153; c=relaxed/simple;
	bh=j3d4cX8JIuQWaEIVaWXAmaK1H9qxgv0hzhQhA3RaqEY=;
	h=Date:Message-ID:From:To:Cc:Subject; b=Q1P4L0HwtzMrLgHa3qyz+ADb6L2Z4klNizSC/erfxdYisnNRTejg2i6KiYpF+VLe501tJhTcGPLBOoJxbt7DwphvZpjLWilLQqYWEgZ3+9+04uRHdVKKJNa6Rm91B6DVOuJ0qusQsPSHo/KxFlJuwDpQI7EZBAnbqpqMxzVsCsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TF7EuoE+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TF7EuoE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5341F000E9;
	Mon, 13 Jul 2026 21:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783978151;
	bh=SbkrMH02T1vZtxsoRDtUjdNgFlPortPpeX6onzm/ojM=;
	h=Date:From:To:Cc:Subject;
	b=TF7EuoE+DBPNQAqKJgrNnoQN5XCOGiYu5raxKa09ISt6Wrhgn6R72U+QBLKxOql22
	 1b+zPu4ywEUZ93/1BDPSweme4hMA648cY3+TNW0fhtrbZLtZ2P6aipt9FruNnr92Df
	 VaL3F+UKdXeNf9iWagrfxpuFmgziDqnEkFQE12ul0StkqAoIzons6O0z2rkI3461iK
	 94yHA1hLMt8xT+UbhRQ54lRzt5sp8BpjlKdEUhxbToZMYxTFqk3GPdsVC0PBm+3MfD
	 BycEeDkjBH59Qqh1WsYeCGZh6fJQ69vhH1STYQgQstUoMZatljw80g5g37Fybbcm11
	 cyK30ZF7GrcJg==
Date: Mon, 13 Jul 2026 11:29:11 -1000
Message-ID: <75e18325175b5439095c4248e0aa802d@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutný <mkoutny@suse.com>,
	Waiman Long <longman@redhat.com>
Subject: [GIT PULL] cgroup: Fixes for v7.2-rc3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hi Linus,

The following changes since commit f0e6f20cb52b14c2c441f04e21cef0c95d498cac:

  Merge tag 'ntfs3_for_7.2' of https://github.com/Paragon-Software-Group/linux-ntfs3 (2026-06-24 10:05:53 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.2-rc3-fixes

for you to fetch changes up to 97fef602584458b100d383afed9d176c0bc689ab:

  Docs/admin-guide/cgroup-v2: note blkcg_debug_stats gates io.latency stats (2026-07-07 12:26:23 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.2-rc3

- A cpuset that never set its memory nodes could divide by zero when a
  task's mempolicy rebinds on CPU hotplug. Rebind against the effective
  nodes, which are always populated.

- Documentation fixes for memory.stat, io.stat, and the misc and v1 RDMA
  controllers.

----------------------------------------------------------------
Doehyun Baek (1):
      Docs/admin-guide/cgroup-v2: fix memory.stat doc details

Farhad Alemi (1):
      cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed

Guopeng Zhang (3):
      Docs/admin-guide/cgroup-v2: drop stale misc interface file count
      Docs/admin-guide/cgroup-v1: document rdma.peak, rdma.events and rdma.events.local
      Docs/admin-guide/cgroup-v2: note blkcg_debug_stats gates io.latency stats

 Documentation/admin-guide/cgroup-v1/rdma.rst | 66 ++++++++++++++++++++++++++++
 Documentation/admin-guide/cgroup-v2.rst      | 20 +++++----
 kernel/cgroup/cpuset.c                       |  7 ++-
 3 files changed, 84 insertions(+), 9 deletions(-)

Thanks.

--
tejun
