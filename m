Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366B047ECD9;
	Wed, 14 Oct 2026 19:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006666; cv=none; b=S+bd3KqCZvQXQsPRI5P0Vm5BhchEB7gDaCpnOw60cEv0hb4OSCkROjuWKTAF1lAtFWPvl1tTCyza1JNKSa7d8WoQPoXDDAZVyRE1hmIudVTR9oycU0lgPrs5xVMtSrVlNDi7Kv/nuyGqtTsX+Kh85UuUem+MVjhmxdHvmpRiP9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006666; c=relaxed/simple;
	bh=6vcGsFszctS9m9nsD0mOVzuEILOA7N26665fwBfdGY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovG8RI5oRJyM5olJgV6AzGxaEbEACIy82KADqb+78dGK/9Vd190k0+ThSeTy9PhMfsYV0oQV6SL1Tr2TlIwKVrKokeX/sRqnwdkAYQJImb7W+2ewpPK8PsVvvVhv0LguUsgGUIoggpgeU4DeOzwf7Rbq/M31IZVjFDl/uyFFJ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMN2SlCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMN2SlCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E281F000C4;
	Wed, 14 Oct 2026 19:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792006664;
	bh=4rfIbNYBKKPaATYal5MTgIu4vhjjemHhAOt2kKu8E1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AMN2SlCoIeaXXJKripQizdLkMzs3fQrZhGME6+qWNnVIDBQCIVRu9YKOV21I3XPDK
	 ffUJSk1N0G/WHn+MOo0gX29pby+3Yow52x0JFkI+6mmgjcUZMgqglVu28VGGTBIkTT
	 3cxElftJEiVrpBO/ROAMevWkJTbBjx2dyiGTZ7+h4D+TNcHD+AhzZwBl1X274XgjN9
	 ZsSUF8rAQ43DX158VH1+4uNpcirWYR2mV6mImZXjmYEi20IPjIEbeBexs0mByU7+21
	 1+oWiSDp1mB0AGxZ8+gaClthwFOzz59g28q8EpA6I9pStEN6eBU+Au0JXDqLcbJl+b
	 u6k6OT+jOSohg==
Date: Wed, 14 Oct 2026 09:37:43 -1000
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/psi: Remove the RCU wait from trigger destruction
Message-ID: <as_aB-eIeU16h_JN@slm.duckdns.org>
References: <20261010191500.3895736-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010191500.3895736-1-shakeel.butt@linux.dev>

On Sat, Oct 10, 2026 at 12:15:00PM -0700, Shakeel Butt wrote:
> In the Meta fleet, we found PSI trigger destruction waiting for an RCU
> grace period while holding kernfs node_mutex, blocking other users [1].
> File close and node drain hold this mutex while calling the release
> callback. Cgroup removal and disabling cgroup.pressure also hold
> cgroup_mutex during the drain.
> 
> The wait was added by commit 0e94682b73bf ("psi: introduce psi monitor")
> to protect worker and trigger lookups. Commit 461daba06bdc
> ("psi: eliminate kthread_worker from psi trigger scheduling mechanism")
> replaced the worker queue with a group timer. The scheduler now only
> checks whether rtpoll_task is NULL; it uses neither the task nor the
> trigger. Commit a06247c6804f ("psi: Fix uaf issue when psi trigger is
> destroyed while being polled") removed trigger replacement and polling's
> RCU lookup.
> 
> Trigger lists are protected by mutexes. Proc poll/select entries are
> removed before their file references are dropped. eventpoll_release()
> removes epoll entries before the file release callback.
> Commit aff037078eca ("sched/psi: use kernfs polling functions for PSI
> trigger polling") moved cgroup polling to a kernfs waitqueue whose
> lifetime follows the file.
> 
> A late timer firing only wakes the group waitqueue. The system group is
> static, and commit 5457025fa8ca ("sched/psi: Shut down rtpoll_timer in
> psi_cgroup_free()") shuts down the cgroup timer before freeing the group.
> Cgroup reclamation already waits for scheduler readers.
> 
> Remove synchronize_rcu() from psi_trigger_destroy() and use
> rcu_access_pointer() for the worker NULL check. Keep kthread_stop()
> outside the trigger mutex.
> 
> Tested trigger churn, notifications and cgroup removal in an 8-CPU VM
> with KASAN, lockdep, and full and lazy preemption. No warnings were found.
> 
> Link: https://github.com/bpftrace/user-tools/tree/master/runnablelockmonitor [1]
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
