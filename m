Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717950;
	b=vKIUKUu8f6EKJ6cqpDqlqStOQld6hOzzIoFA8LNOH1hTgJedP/TNY5E54F9JgWU0G/B+
	 x7mqyRXeXr9xq330TDSlcWBv9yPb2I1g2vOdO6fyClvXWGHf67Dsq6MAA7ag8G678VAY2
	 n7mb6hbOkkko6PF2RtVqSBM2zs7nNV/lNpnsmLGkYtfyxSnVPpOY+b1Na+gPT4xvs/1xn
	 SziDpceHT0QA1i6wMvxL7UMivA1UkWBJwRGEVAvMpjGXyL3AlII43elqUay3COZ9nh3bN
	 KybKMvv+lVIkJtdV9ylZJ1YrZIkobCP2aEgXQkxkS4Jy9jZjY6ja0ROrHQrbzx30fmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717950;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xTaO+IpTNWTE3CNFVHX0P2a4foAlotO2i/j+8kuODPc=;
	b=rLL/qgZmIVYsPHrmXKs3ZFino5/x7JVsJ5gYYVmjVah6l97HdLPWbpgD49/5Z+KeljPj
	 K0ZYHYiYNNifnCUxmJaZLTaAnMWUHK81OuYUns8yt/yFbjUwo4/vVIvXzAcnOKlUyi62r
	 IpUwoZQeCuZ/VO9+1dSy9ag6CnW/GSR0H5FCeHgdOSrT1dhrZi2PodPYvgxOt82xrdihT
	 OrU6S0KJW8cCk6+YFkscJBDz3CO8bQcGr+tu5NxEAaKlWTCIfKjlOw8LU404wYtGg9SES
	 71O4v8m+YF9UsD9qx+w54tS3Covm03XsqVRXM8x+qW7RhS2DToXNViqDMKHzWF2HJYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oEbqHgIE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45046606C867;
	Tue,  3 Nov 2026 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oEbqHgIE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA0B1F00919;
	Tue,  3 Nov 2026 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717949;
	bh=xTaO+IpTNWTE3CNFVHX0P2a4foAlotO2i/j+8kuODPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oEbqHgIE+lY1Hs45AftM4rckAxM0DUPGsSUAtVRRHsLlCWFfg/veggpDHx7lSfgRv
	 ibzBHmChGFeeUx2SP8E1zUBkySc9PwAFVUIn62YQlpimDIta3QR35XHjkbcYNhi2BP
	 wa5a1j1zb+NN9BiCdbdo4lSvj/oJnzVDxiLtUzOZoXLffAYC3emYdylnhzQAsFQTHB
	 MIsduntKoVn+y2w6wh8viyDeUGIUXaVSs+MsCwmDnde1ZryBcvS0rGAjKFJa4nyqG4
	 eOwC9caU3Ww1Mvk8kYxmni0poKc1wvsFuKHnE3Rp1RRiZjxtRv2zHsYytALtoux6LT
	 2A8C9VrUM5m9Q==
Date: Tue, 3 Nov 2026 04:59:09 -1000
From: Tejun Heo <tj@kernel.org>
To: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 5/6] cgroup/cpuset: Don't wait for memory migration when
 cpuset.mems is written with O_NONBLOCK
Message-ID: <aun2vUjloJjH3Hpb@slm.duckdns.org>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-6-matthew.ruffell@canonical.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103075940.110308-6-matthew.ruffell@canonical.com>

On Tue, Nov 03, 2026 at 08:59:39PM +1300, Matthew Ruffell wrote:
> From: Caron Wills <caron.wills@pulsar.com>
> 
> Writing cpuset.mems migrates the memory of every task in the cpuset on
> the ordered cpuset_migrate_mm_wq, and since commit 3514309e0322
> ("cpuset: Defer flushing of the cpuset_migrate_mm_wq to task_work") the
> writer flushes that workqueue from task_work before returning to
> userspace, so that the write appears synchronous (the design of commit
> e93ad19d0564 ("cpuset: make mm migration asynchronous")). The writer
> therefore sleeps in TASK_UNINTERRUPTIBLE for as long as all queued
> migrations take. On a system with isolated CPUs running SCHED_FIFO tasks
> that was measured at 2 to 10 minutes (LP: #2165410), and it is unbounded
> in principle: a migration blocked behind a starved kworker or a slow
> expedited grace period holds up every migration queued after it.
> 
> The writer is usually systemd. It applies AllowedMemoryNodes= from PID 1
> itself, and since v259 it opens every cgroup v2 attribute file with
> O_NONBLOCK precisely to opt into asynchronous semantics wherever the
> kernel offers them (src/basic/cgroup-util.c, cg_set_attribute(), citing
> the memory.max/memory.high behaviour of commit c8e6002bd611 ("memcg:
> introduce non-blocking limit setting option")). While PID 1 is stuck in
> the flush, logind cannot create sessions and SSH logins fail.
> 
> Honour O_NONBLOCK the same way memcg does: skip the task_work flush when
> the file was opened non-blocking and let the migration complete in the
> background. Blocking writers keep the synchronous behaviour and the
> cgroup.procs attach path is unchanged.
> 
> This does not make the migration any faster; it only stops the writer,
> in practice init, from being held hostage by it.
> 
> Link: https://bugs.launchpad.net/bugs/2165410
> Signed-off-by: Caron Wills <caron.wills@pulsar.com>
> Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>

This makes sense to me. Waiman?

Thanks.

-- 
tejun
