Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F64184;
	Mon,  3 Aug 2026 01:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785719602; cv=none; b=JCblcy4nvepFmtagRqpuJy54u/59sVnPfZ7gHEsSGLOH14QrVDavILgiNI81SUuzBduzCBcqhe6c55K2tHTKfbQWPBL/ggVYo8H624+u0bDuLBnI9qg3MaRME2e0E7VTAte41wEFP1SQJ9s648N4BE8MPlovYkarkSghThMUDaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785719602; c=relaxed/simple;
	bh=vg8JIz2FEAiVeQO2eUWUDFjUWby98HyFvUx/oJKKMxk=;
	h=Date:Message-ID:From:To:Cc:Subject; b=oKuVMPekUD1+QttVoJBlTYJezHeoY5istZr0lDBr/xxOE3L6htGXyFrmHg3JHIfy68XbHPoD+WDJ3bz4WQS0eJM/l8P1LDkxQxTe8CLqtcsLmm/MOiir7xf9cke9ABcfDoZ0hxpMXb0tu7RuOG637GVPj8LMV/KKVIjog4IP9ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQq4qTYy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQq4qTYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D9E1F000E9;
	Mon,  3 Aug 2026 01:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785719601;
	bh=/IeGYJGYdqBd6oXQeiHMbEi7Syh6d9ihghlHYbIPu5M=;
	h=Date:From:To:Cc:Subject;
	b=oQq4qTYyZBmq9jeUrNOcZkCT7hGJwhRBtiWzmxNMhL4mQeuwsG2caXevZMYwYaQ/h
	 7yR1DaC4Ahb0ziHGK6bdCXHsErj6zWYLmlbuK1zWdRzHpcxGYq+J6/shqR8YCbk+yB
	 tkzSolNilxSpN9C0TT2ii1RcMNkYo7xk2NNqmuA0xYKR4lzhPYvkjGS6RnJmFVUb8p
	 gm7kz7Si95pbwFAIKI+ggMw+TePDl+I1nHI62T0UskhWBvdqp6Wv1wY/eZOAZu4s8Y
	 3cdwnXIGZauwS9zM0J7tPMRereXfit2hxsMTaWze36kWTRE70M8bzWPUtPvJ6cyG6z
	 9sKuveZd4xbkQ==
Date: Sun, 02 Aug 2026 15:13:20 -1000
Message-ID: <0f3381afd016a711c51e3c3b94a9eabb@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Fixes for v7.2-rc6
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

The following changes since commit 97fef602584458b100d383afed9d176c0bc689ab:

  Docs/admin-guide/cgroup-v2: note blkcg_debug_stats gates io.latency stats (2026-07-07 12:26:23 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.2-rc6-fixes

for you to fetch changes up to 2fd9b4cfcefe30cb506072f78f2cd3b6dc8a29b1:

  Docs/admin-guide/cgroup-v2: document io.latency rotational vs non-rotational behavior (2026-08-02 11:29:33 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.2-rc6

- A pressure trigger's poll timer could be re-armed while the last trigger
  was being torn down and then fire after the cgroup was freed. Tie the
  timer to the cgroup's lifetime and shut it down when the cgroup is freed.

- Writing to a pressure file forked a worker kthread while holding the
  cgroup mutex, creating lock dependencies from the mutex to the whole fork
  path. A pressure write racing a sched_ext scheduler enable, which blocks
  forks before grabbing the mutex, deadlocked. Fork the worker with the
  mutex dropped.

- Documentation fix for io.latency behavior on non-rotational devices.

----------------------------------------------------------------
Tao Cui (1):
      Docs/admin-guide/cgroup-v2: document io.latency rotational vs non-rotational behavior

Tejun Heo (2):
      sched/psi: Create the psimon kthread outside of cgroup_mutex
      sched/psi: Shut down rtpoll_timer in psi_cgroup_free()

 Documentation/admin-guide/cgroup-v2.rst | 50 ++++++++++++++++------
 include/linux/psi.h                     |  4 +-
 kernel/cgroup/cgroup.c                  | 23 +++++++++-
 kernel/sched/psi.c                      | 75 ++++++++++++++++++++++++++-------
 4 files changed, 120 insertions(+), 32 deletions(-)

--
tejun
