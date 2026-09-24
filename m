Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F477440637;
	Thu, 24 Sep 2026 21:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790284773; cv=none; b=podG5jIq/H/OQUMChwwFvCN6DhIggGAxDaiJkewV6waRjeyqmuM2DnFcVhwAEVchHdgWS1EIuscB/e/Mxm3Y9K/bSuAZPkR+2Evuy1scHvE42QJOarJPaddI6JX4BcdggzqAfe8Opsomj3xLjuYag0O/sGBSPGeddkyiuxF10rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790284773; c=relaxed/simple;
	bh=ll7mi4oZG3RHlIUy2JPL9G20gIn6ASi9ZJwhA743bc0=;
	h=Date:Message-ID:From:To:Cc:Subject; b=PD54nC1B9fgOmUtAE50rzPZMCniqIXPdw9NmW3We0O/211hJC87VAZTM/98W2ZZxlH3dw+1SH6KAXvfFrJTLmiac9dw7RN/3TATan8TEi/djJ/qWyqKt7RBPCQGssFm5H6pApcNPguqQGC99tYnJQp8H++gwFIjv7gGixMwyOSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dnYuG6PZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dnYuG6PZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B08B1F000FF;
	Thu, 24 Sep 2026 21:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790284768;
	bh=E2O8i9zrBD+K4mqMf5jnmaH3EQ3DGVqWMI+ouf6y/Hc=;
	h=Date:From:To:Cc:Subject;
	b=dnYuG6PZqtsRQbHSdCUDSPRom8X0f3NN03zJnYUBF/nkTD04khUT1Nmh9grUfJV4U
	 s3XLXLe7SYA/ZvmYzWhfRDRESUO3XC4FG74tPv2ZPzKXyQFgmxYapQBhE1q3v5YsAw
	 HbsFxjNPVkKPbC4zzyWWkQlGa8F9jvGczTAtdhc/iHdEFR4+JR7DjWxdCqVOO8iZCE
	 VX2GMdm0SuOfcoL9Zc/n7NEZXUu6kAYdGdC81r96qZPTKYwADBTlUP2nx/HncfFcLr
	 n+isYM1XuB8FI3Vm/BD4qXQR9laGNnjn0Qo2/EmEMdSqnXCn1yaJiiLQ9orCaVsGq7
	 hxJ3QWbon5bVA==
Date: Thu, 24 Sep 2026 11:19:27 -1000
Message-ID: <1e7eeebbabc3a9404fbea6928722474a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Fixes for v7.3-rc4
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

The following changes since commit 057dac23d329d5c5ed62352f2659a39fd46c6d4a:

  cgroup: Avoid iteration of dying tasks with zero refcount (2026-09-14 12:43:50 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc4-fixes

for you to fetch changes up to 1765a153d985c231357145e26798f9408db10e42:

  cgroup/pids: Restore pids.events notifications in local mode (2026-09-24 06:22:11 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.3-rc4

- With local event accounting, a fork rejected by the pids controller
  updated pids.events without notifying its pollers.

- A cgroup selftest failed to compile with fortification enabled because
  an O_TMPFILE open lacked its mode argument.

----------------------------------------------------------------
Eva Kurchatova (1):
      selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode

Guopeng Zhang (1):
      cgroup/pids: Restore pids.events notifications in local mode

 kernel/cgroup/pids.c                             | 5 +++++
 tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
tejun
