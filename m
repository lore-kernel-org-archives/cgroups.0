Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD450479882;
	Thu,  1 Oct 2026 18:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790881178; cv=none; b=dwluiJtP22t58PHTqij7dmn5tIh4s69YVvItyKueRK5AM3ZpXtrtmUZrsENSYsstACr84/H/N8KTSIdmfgqFb9zuCGU0szFouSfJEQ0rh1DY3Otd22m79b/mclTSNzT0FtrYGXVKSpc1hAbEU/1lCmab1S6xQlg6bILhsirheKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790881178; c=relaxed/simple;
	bh=dbqpPhdVg+JjB04z8Xrp7o2CiVP31iN8OSuqPExIta4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KivgHsEaVpwKsQaaL+cdEeqjK9jwkfRleZSnfXnU75JOy/GKFQHy9JdsaTzK1wabQqa9boBejb7GeHhOsIGIgLGuCMPPgWP23IfGg2gLdsS5hNTP1TVSdoDKB9LTuN/ThUqOk1PrrDWJQMI9tLok3lurPUsLkbm2EoHx8GookA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OqmkmC+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqmkmC+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547CB1F000FF;
	Thu,  1 Oct 2026 18:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790881177;
	bh=dbqpPhdVg+JjB04z8Xrp7o2CiVP31iN8OSuqPExIta4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OqmkmC+Ba6BnMRAC8P/rjHkzAwaaowPo5wlSsyTYeNoXx77Gdgz1fAznYvNzNJCr3
	 fdxcp+352A26HkH9iW5RwIUvEzNH555zBtM5tkW35ULQWFKqz+nfvl6Pg+7QUocZbz
	 IXz1Hv+KmDuEgeLFHh39ze2SZ9daSCUthTAEWRbGTYjIvHaxYPhylfXkXu5bs+eT4W
	 Rrub4xGtfhMMTgb4RbUi5JnmTEQKpY+U2pOXEdne0addK0xQVq6NpQ8ErLdOzmSFKj
	 tnP2H8TKpVMuCDOltGWIZFWu4/pPc6PtFUhr4hTAAZCCKC5UxR8mRkn64waBdzs7r8
	 DF4bfCPwjmANw==
Date: Thu, 01 Oct 2026 08:59:36 -1000
Message-ID: <4a8e64483eae4a8b7524650c7d54453f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 David Dai <david.dai@linux.dev>,
 JP Kobryn <jp.kobryn@linux.dev>,
 Frederic Weisbecker <frederic@kernel.org>,
 Aaron Lu <ziqianlu@bytedance.com>,
 Daniel Jordan <daniel.m.jordan@oracle.com>,
 Hao Lee <haolee.swjtu@gmail.com>,
 kernel-team@meta.com,
 cgroups@vger.kernel.org,
 bpf@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
In-Reply-To: <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Peter.

On Thu, Oct 01, 2026 at 12:59:09PM +0200, Peter Zijlstra wrote:
> Ideally RX would be split for each network queue, rather than lumped
> into the one giant softirq that nobody owns.

Rx can be split per queue but the granularity doesn't match. There can be
way more cgroups than the hardware can split queues for.

> Furthermore, without ingress throttling, your RX back charge could
> completely deplete the actual cgroup time quota.

If rx processing slows down, the rx traffic slows down with it. We'd
likely still want to allot some minimum amount of time to non-rx work
while making sure the debt doesn't spiral out of control. If a dedicated
kthread were handling rx for the cgroup, rx would be sharing CPU time with
the rest of the cgroup without choking it completely. The back charging
can follow the same corollary.

> Anyway, if you get per queue RX processing threads, then you can move
> them into cgroups where so desired.

Same limit here. There are setups with a lot more cgroups than CPUs.

Thanks.

--
tejun
