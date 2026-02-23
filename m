Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAF3369984;
	Mon, 23 Feb 2026 20:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771880246; cv=none; b=pXnCwP1cxOWes78M4Bta9vcvCu61EAG13bWBPEUH4ytz/zbOD/pW0stV+4+PgGDqK2Qz0zJbWepY/S92za0SdPUNV+Dhgr+GrHm6eoznUXIkDHwkx1bnI9b4Ia52xYWaL2DhXIMc+vJDwR0e3DOvM7Bo4N/g3/oj6hMNJgflCCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771880246; c=relaxed/simple;
	bh=inoIZdNuHbSRzVDVc72NG8TR/m8kk/DIfYd0g1QefBo=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=m7cb2bV7JnhkFaFwqfJe+78RP+4fZiyJaeIBnNyKNhA6eJPhAIKfhN9CnAVKSAdyD5h5nqZGc6OgCC0xSyMhBPX3iynfjn+WT+62Si5JFaAuFCxKjEubuBlFpXXyzXySqcELKC/vbxpK7UcZFggn54psj4KlOvIMm/znoAHiz1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vDuURTdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDuURTdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAD0C116C6;
	Mon, 23 Feb 2026 20:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771880245;
	bh=inoIZdNuHbSRzVDVc72NG8TR/m8kk/DIfYd0g1QefBo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vDuURTdRjQyGkuH0p6oGKtGuaURt1B7N47SUWSriuMf8N3+UYhGlb42k5SrTUdfRa
	 Z6RUc0YDPKpcgZYSW337efDuzCeEJ5k4nQSCKdofZeyJA5cbeJylvY6L4WUxcqOUph
	 z06F+j/DMkWLQhzXN+nY8G5LTru6SrvZPdVTdmWo2qpSfEXOmxhLbTEKzKy5/LXuCw
	 QvQZ3U9MLaVS/U2BXX0itG3VrFg0AoWL0MtTzg5nYvyPdRsXngNBvRNDqVlCKNag99
	 PnuwzY8S9jXMEOAx59LFt3NU2LcUXAsZxBGaOrPoB4Vtdv8aXYZdXIxtpz5buGm6R6
	 31cjkBJxllakg==
Date: Mon, 23 Feb 2026 10:57:24 -1000
Message-ID: <9cc7401e7137e27cd2f02625aab23330@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>,
 Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 0/8] cgroup/cpuset: Fix partition related locking
 issues
In-Reply-To: <20260221185418.29319-1-longman@redhat.com>
References: <20260221185418.29319-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

> Waiman Long (8):
>   cgroup/cpuset: Fix incorrect change to effective_xcpus in partition_xcpus_del()
>   cgroup/cpuset: Fix incorrect use of cpuset_update_tasks_cpumask() in update_cpumasks_hier()
>   cgroup/cpuset: Clarify exclusion rules for cpuset internal variables
>   cgroup/cpuset: Set isolated_cpus_updating only if isolated_cpus is changed
>   kselftest/cgroup: Simplify test_cpuset_prs.sh by removing "S+" command
>   cgroup/cpuset: Move housekeeping_update()/rebuild_sched_domains() together
>   cgroup/cpuset: Defer housekeeping_update() calls from CPU hotplug to workqueue
>   cgroup/cpuset: Call housekeeping_update() without holding cpus_read_lock

Applied 1-8 to cgroup/for-7.0-fixes with the following minor fixups:

- 5/8: Removed a duplicate test entry that resulted from the "S+"
  removal (two previously-different lines becoming identical).

- 8/8: Fixed typos in commit message ("essentally" -> "essentially",
  "beforce" -> "before") and code comment ("top_cpuset_mutex" ->
  "cpuset_top_mutex").

This has gone through more than enough iterations. We can resolve further
issues if there's any incrementally.

Thanks.

--
tejun
