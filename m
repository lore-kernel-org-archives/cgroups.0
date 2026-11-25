Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795599061;
	b=ZTvpe1+s2frIstNYVQEg/hzY+wHhQ9MD9l5EvlZ4yJvO5cltOwg3sTURzikw44lYpdZH
	 obG58hPjjcE2Qy6VM+2Vphfxe8dXPOZlFxRJ4vew+zRwelq9L25WMANxdvAwjqqDsFOgj
	 exsMMwaFB4zTmceD0ymBvyVJB7rotl/hf7Fxx14uxCaVGwgEJN68WeDkOUEhmArAQnjmE
	 lsl0VBi10LqvqIK8FoNwFGm37mV8WmGV7Sz8/8TZ3UFBbOhOTddG+AdKTc31vutoGuAxK
	 B5oNgSDlSUFQ4xbxaTvEUV/S2R8LFODa4BTGZ6aTv4/qRJ5NnfO+qMEBsMEw+0TwVrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795599061;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject;
	bh=JQlKAEjqIcBBJEVbWpsSok9+7pJSA8OprI+hbBiMIKo=;
	b=wh8Se/7tCcn/5EkUlCf/bsYLVTsDiA4dqRyKPXx7niYcfxFuD96HHY4hYw3BWSPtPpph
	 n+Rx8NBHSxl0orAP/dSxqUyvRlxGzi8upX81jPBiqUsxE6liCXTfvABYGriz425apRBjG
	 h34polpaermKjvY2JAqTg0YR6SgKcxVIKuM1gwYYlMJQxJXsRW2sNRlHqUECzMq4yiRuM
	 aDXyRMnPN5zzSfj7ZCe1fqGpxJzH0Er+N7sy4mI3I04UjlmxXpNUB/i1tpTF0RbM+mwQd
	 d9ZzmlbyEwviSz7vvCcGlaPnNCvd0JZLyVCk2st2wH4EaJX1ZLQk+EagqD1jgDoP8bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Csx/xmSe";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC7F606A327;
	Wed, 25 Nov 2026 09:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Csx/xmSe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6889F1F000C4;
	Wed, 25 Nov 2026 09:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795599060;
	bh=JQlKAEjqIcBBJEVbWpsSok9+7pJSA8OprI+hbBiMIKo=;
	h=Date:From:To:Cc:Subject;
	b=Csx/xmSe0gwGhmWFLs8NvdTzaP5/OTeXZ90ooR+1DVXEHsHaZZTmES+VWBt+z2aa2
	 cbXAu/PZHCFU3SKM3Dnz74PLzbGPUJDZ/SHtR422DdSF8DhhH2QVGkIZ/hRPifd5P/
	 bjQDECd0ZE0ZBzLcdbTZnK1DvpI6m7XkH0VAoRHwyQ89oIKbdP0RNduytmuTJd5wpM
	 2XDG2oIm2g7YJNfI76UIh1AE3piF3PO5zczSS9/vDbNShm4kBmLmxpXge/V6NEQyzk
	 bZd4Qj8zIwM6lgkMlTdb24gCg8+DdksiWuvz/L76CRUmkVqGl8yH5zw6wLJfD/9uKN
	 z3VhAVC1ZAthw==
Date: Tue, 24 Nov 2026 23:30:59 -1000
Message-ID: <6a805a6f23f76761c1efac4817ea1510@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Fixes for v7.4-rc4
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Hello,

The following changes since commit acec9637e03ca54bd3c3a0c1a6ad5c6dfa07c0df:

  cgroup/cpuset: Don't revive invalid partition without active CPU on hotplug (2026-11-15 10:15:12 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4-rc4-fixes

for you to fetch changes up to c99f50e4acf86bfbbe313d79f281d83be1763260:

  cgroup/rstat: disable preemption in css_rstat_updated() (2026-11-23 20:07:41 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.4-rc4

- A BPF program could queue a cgroup stat update with preemption enabled,
  tripping a lockdep assertion.

- When nohz_full= included the boot CPU, the tick code took the CPU back out
  of the nohz_full set but the housekeeping cpumask still excluded it. The
  fix is in the CPU isolation code. It comes through cgroup with Frederic's
  review as further cpuset changes build on it.

----------------------------------------------------------------
Karl Mehltretter (1):
      cgroup/rstat: disable preemption in css_rstat_updated()

Waiman Long (1):
      tick/sched: Make tick_nohz_full_mask and HK_TYPE_KERNEL_NOISE cpumask consistent

 include/linux/sched/isolation.h |  2 ++
 kernel/cgroup/rstat.c           |  1 +
 kernel/sched/isolation.c        | 11 +++++++++++
 kernel/time/tick-sched.c        |  6 ++++++
 4 files changed, 20 insertions(+)

-- 
tejun
