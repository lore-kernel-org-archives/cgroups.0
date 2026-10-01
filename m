Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A6744E046;
	Thu,  1 Oct 2026 10:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852095; cv=none; b=XRmN8G+w2sN5ylXiUr9URx2ifukDeRL+odwycYKtTioKWK9JrRItMMQk3sfZ7e0SWO/gVJLx0GHlP/Za0sjujZhp1HZDZIZCwOLGAiK/fRHL4Fo1npLdxpJbuLwi6UqMcJClZA+LjRS/yn15XNpMNG1MPzHBOPLnYKJb57bcZoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852095; c=relaxed/simple;
	bh=wTx6Mvyr5xDbxsqv9Qcf07k2wHNrFdQv99ODg9frgbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2wjqrGVyneVcQZiJwlvd3JpI33+4FqqhV0JfC2mhmc67Nzzeg9UNKl5sK5W86SX1lNp7q4B1Wri4VXOFmhrR2ylcmFMchxD6nWxxpZcYVH9yrEAYEJpK7Zfkx5WNIk+q+1jU3kNSnColYPdMpLOSMHf/DlJiiS7zzPgWd0by8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=la9C++oV; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="la9C++oV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QMQi3pfWB0wiaCHgvp5eiKUKLsxkaOq5Mv0PAKIuKqE=; b=la9C++oVmy91EssZzyrMx0EQyi
	2Z2A4CAKhpig2EEh/JoYbzxfMSZdRpsk75dwabdgBm56msfF9NGMtsXwNLbBo5Je5P38DpMMQVbCS
	vPOQF2ukfYIISDmrJWMkKKLolN2Ksu2QsR4MXoql+tu63gXEHZcDYh8ym3Urr+98GbbbFciqI3JN7
	V22+O8+OfAj/JqLQj40+ts5CdvGafHKZUpHuWcPStSH2DJ5+dNhaCr+MU881mU5yPCtF3H1Kuq50A
	Ikj+NcN24Kdhfox9zWY/yzhIdsxCiCjFFP8rJVG/sMqP2K89HbjXcxOeLBcG28E4ZBuBTFpInoyq4
	khXNRqow==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1xCEQk-00000004rjo-0GEu;
	Thu, 01 Oct 2026 10:54:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B11FD3001FD; Thu, 01 Oct 2026 12:54:24 +0200 (CEST)
Date: Thu, 1 Oct 2026 12:54:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com,
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <20261001105424.GK4121339@noisy.programming.kicks-ass.net>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>

On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:

> Options we looked at
> ====================
> 
> A. Keep the shared kworker, and only charge the cgroup.
> 
>   A1. Measure how long the reclaim ran, then charge that time to the
>       memcg's cgroup.
> 
>   A2. Let the kworker say "charge this cgroup" while it works, the
>       same way set_active_memcg() works for memory.
> 
> B. Also make the cgroup's CPU limits apply.
> 
>   B1. Run the kworker in the cgroup's scheduling group while it works,
>       so cpu.weight and cpu.max apply to it.
> 
>   B2. Run the reclaim at full speed, then take its CPU time out of the
>       cgroup's cpu.max quota afterwards (back-charging).
> 
> C. Do the reclaim inside the cgroup.
> 
>   C1. Record the overage as a debt on the memcg, and let the memcg's
>       own tasks pay it the next time they charge memory or return to
>       user space.
> 
>   C2. Give each memcg its own reclaim thread that lives in the cgroup.
> 
>   C3. Use a cgroup-aware workqueue, as in [1], or per-cgroup worker
>       pools.

> What we chose and why
> =====================
> 
> We chose A2, together with B2 for cpu.max.
> 
> We do not throttle the reclaim itself. Adding limits to it is more
> complicated and most probably unneeded, as we envision that we will
> need concurrent background reclaimers instead of throttling in a
> real-world environment. We are working on developing a system to
> balance the rate of allocations/charges with the rate of reclaim, to
> keep the system always running effectively.
> 
> In addition, reclaim takes sleeping locks, like i_mmap_rwsem and the
> anon_vma lock in rmap walks, and fs locks in shrinkers. With a low
> cgroup weight, the kworker can be preempted while it holds them, and
> then tasks in other cgroups wait on it. It also hurts the workqueue. A
> kworker that is runnable but not running still counts as running, and
> the workqueue only spots CPU hogs by the CPU time they use. So other
> work queued on that CPU's system_wq waits too.

With proxy execution, this should be alleviated. Then all tasks waiting
on a lock acquisition will contribute to the runnability of the lock
holder.

> Still, the reclaim should not be free CPU time on top of the cgroup's
> limit. With A2 alone, the reclaim shows up in cpu.stat, but the
> cgroup's own tasks still get their full cpu.max quota. B2 fixes that
> without slowing the reclaim down. The kworker runs at full speed, and
> afterwards its time is taken out of the cgroup's cpu.max quota, so the
> cgroup's own tasks get less CPU time instead. This is the
> back-charging Tejun described [2]. It only covers cpu.max.
> Back-charging cpu.weight is future work.

Fiddling with weight sounds like horrible garbage. If you find you need
that, I would really rather you went C[23].

> We did not take C2 or C3. A high_work run asks for only 64 pages,
> which is far too little to pay for moving a thread into a cgroup
> through the global cgroup locks. A thread per memcg means thousands of
> threads. cgroup v2 does not allow tasks in a non-leaf domain cgroup.
> And a kernel thread in a cgroup shows up in cgroup.procs and blocks
> rmdir.

You don't move the threads, you spawn them on group creation and leave
them there. I'm sure you can fudge the rmdir thing with less ugly than
you're proposing here and in the other series.


