Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A880C1DED42;
	Wed, 23 Sep 2026 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790177256; cv=none; b=OYAv4YjFZxm2E9+VS7Ux/CrBEHJT4Jxa/XFgs6O6f2YpyB4HTdp2b/jEuCt3oTUzE6ewkYkFtb/fYSs3EL4Vs6BoOQ37YoJYdCk9NhA0AdWqFIB+2y8PNi1nJXwRSJGj0kMg35FKIXUtGFcmE9VEfqqgqhxEelZTK93ww/KnXvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790177256; c=relaxed/simple;
	bh=ZmeWKlO1uWXNiNx33YICOyZm9UbJ6iEopwmUDEtFAN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jiKUBBZluNM2PYF99XyWqD+ZqfNsj24rBbG1NAxCQzohXd4t/Ta7samPSgjw2/m9R6KvOHchX1d3Pfr6lIP3IU+4k9t7m5QsAYmkqz8xPVRbd2PhAJbOzzDA7+QtKNXuzIa78WwXaLCC4Bd+74pXdwh5Z8lkeePls/GX8oi0Tj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jD6dvp/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jD6dvp/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0101F000FF;
	Wed, 23 Sep 2026 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790177249;
	bh=gKsiXERWQlR6rp9onnZUafQe9FGJ1g3zTuAUGmAFbnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jD6dvp/C6uPldzGalEI3E4WS2qhrxlqI6O4ZPYpP+Cu1fEJIXwq2aVH56QlV/0Jme
	 7sVMJfV7GmC0UaYErRA3Ug9AttKuZvYvlsQY17faNDwX/lkhou7dZb9WozungbiWDz
	 c6Ln4RVr1ZImU4ftMon4mL0cu2+sNuR5+WGrZbDxIne8ftEPl0rWNQNoESD17gNn5x
	 rSw6+gklNudhQnayOR555AQLV/CIXpkwV80n5Da0lFN8nG6/pGbnsGF9ypbaLyW4TI
	 mrNmts/WGWeqxESg7mwl57+hGxfZtUaYc/zmkVJBi7RGZE8+FW8Fy4YO1YhhcAoiO8
	 BkxGgyOWPBHSQ==
Date: Wed, 23 Sep 2026 17:27:26 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Jing Wu <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v4 00/11] Dynamic Housekeeping Management (DHM) via
 CPUSets
Message-ID: <arPv3qvVi6ioCNe3@localhost.localdomain>
References: <20260710-wujing-dhm-v4-0-2e912e5d9645@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710-wujing-dhm-v4-0-2e912e5d9645@gmail.com>

Le Fri, Jul 10, 2026 at 11:28:11AM +0800, Jing Wu a écrit :
> This series introduces Dynamic Housekeeping Management (DHM) to the Linux
> kernel, enabling runtime reconfiguration of kernel-noise housekeeping
> (nohz_full tick suppression, RCU NOCB offloading, and managed IRQ
> migration) through the existing cgroup v2 cpuset isolated partition
> mechanism — no new kernel ABI required.
> 
> When a cpuset partition is set to isolated mode, DHM cycles each CPU in
> that partition offline, reconfigures the housekeeping masks (removing the
> CPU from HK_TYPE_KERNEL_NOISE and related types), and brings it back
> online.  The subsystems (tick/nohz, RCU NOCB, genirq) pick up the new
> masks through their existing CPU hotplug callbacks.  Destroying the
> partition reverses the cycle: each CPU is taken offline, restored to all
> housekeeping masks, and brought back online.
> 
> Housekeeping cpumask pointers are RCU-protected to allow lock-free readers
> during updates.  A global dhm_cycling_cpus mask suppresses transient
> cpuset partition invalidation while CPUs are being cycled.
> 
> This work is related to Waiman Long's [PATCH-next 00/23] series
> (20260421030351.281436-1-longman@redhat.com), which also targets runtime
> cpuset housekeeping control.  DHM's distinguishing feature is zero-boot-
> parameter activation: nohz_full+nocb isolation can be achieved at runtime
> without any boot-time nohz_full= or rcu_nocbs= parameters.
> 
> Signed-off-by: Jing Wu <realwujing@gmail.com>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>

Sorry for the delay, I'm finally on it.

One thing I would like to have is to make HK_TYPE_KERNEL_NOISE to always
be a superset of HK_TYPE_DOMAIN. Ie: Cpuset's nohz_full should imply
isolated domain partition. Or to put it another way: a nohz_full CPU should
always run on isolated domains. If I could do it again, I would enforce
the boot nohz_full= to always be a subset of isolcpus=domain. But we
didn't know the possible usecase of it at the time.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
