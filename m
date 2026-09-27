Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0109538F639;
	Sun, 27 Sep 2026 08:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790498948; cv=none; b=NysuxIPfsd+eE+mSCdZj+wsKnyAtROHVx7NS0Poftx60eEt7XaLIbGeNDDjvYVPYr8W1civlep40/2wg6RxN9VRuAfTIZhk3PNGIwtE9NMSrBuAd8cbYvu18Ng1yFWWQoE+Zp1Z8qAAoi1HvjJM0eX5PoTL7IPpxIJDvDTPOtmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790498948; c=relaxed/simple;
	bh=HRgGskKMmCG0v857MsKoSPJAOpcxBAxh6zkx8Cdoyi4=;
	h=Date:Message-ID:From:To:Cc:Subject; b=ssp0863mtKNyn4ZXrprndR8FSWqir/sU/vACdTqAryiXFRVI7LEhnPxms6eoOQLPTiwEMZ0WSlCzI/IbsAzfSPuN4tWherRACF/N82BQSjK2rIO7mQGD/RMxJLeA0sDdhsJTD//OZj8Lw+RxEC9HUjkhm5oTsNUrunzdf2dFAQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Em2rplKr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Em2rplKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678D81F00893;
	Sun, 27 Sep 2026 08:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790498946;
	bh=TMd63lj7OYc1KqQDFRigEPTcVflm5zOH5yBPp3cev4o=;
	h=Date:From:To:Cc:Subject;
	b=Em2rplKrD2SHoIS+/Q2FpWNvaA36mJS/ygBVQ/wiGQAYEjkWv9GENg2Yc4iuLsMDd
	 vGFOazUrZfVujOfR/pYWrE2wBebUsfKwnCmp5CQT7ZweAkkT9c+PQ9BffWgfTqPI11
	 emLSS+exGMTt8cFn1M0jGmzjrbvH6sr9+vf/KjJfVCrNXouuMWJR+PaFpctX+3lorr
	 mc7TG249qHqI2FCQc3aDbSqZutEPznAtZqQlF6fJM7rSyBT7pBhnBnfd0kaZy/GwBg
	 m3+P4csvV+ZWB6gZOUD8sS7cdLfkKaK9ND7xmovHvqxS53An6EmoOdvGDQW0NoFxs9
	 vNfDvGFHZVLXg==
Date: Sat, 26 Sep 2026 22:49:05 -1000
Message-ID: <ce6ce5c6c2072b5f38afe4f0121a8542@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Another fix for v7.3-rc4
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

The following changes since commit 1765a153d985c231357145e26798f9408db10e42:

  cgroup/pids: Restore pids.events notifications in local mode (2026-09-24 06:22:11 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc4-fixes-2

for you to fetch changes up to 31c88350b7dd1522792f726f79607f31bb55c50f:

  cgroup/cpuset: Return PERR_NOCPUS in remote_partition_enable() on subpartitions_cpus conflict (2026-09-26 08:07:26 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.3-rc4

- A cpuset partition could claim CPUs an ancestor partition already held
  exclusively. Restore the rejection an earlier change had turned into a
  warning.

----------------------------------------------------------------
Hui Peng (1):
      cgroup/cpuset: Return PERR_NOCPUS in remote_partition_enable() on subpartitions_cpus conflict

 kernel/cgroup/cpuset.c                            | 3 ++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
tejun
