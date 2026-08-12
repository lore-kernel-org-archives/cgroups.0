Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5FF3101A2;
	Wed, 12 Aug 2026 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786541474; cv=none; b=e15pbuj6Br3vuqGATNFPu6CtdHHMEKN43ASqzdGsmJWi6AwQJkRG78X6OhHKM4202kj/10PnixamOyec3eE7O5pvKifVoNWe0eCez9f5nYXOoDelxrU/lIpQb7H17rz8ocALV8ExhYiTPMbnwLiGxEdx2GIdJUSjIjbGWc1eyyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786541474; c=relaxed/simple;
	bh=bVTeeLdlPguoHzAex8PzDY+Kj2oTk1+7BbW5uMLf2ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fL+0muPlpDheN6Z/3q2EBsrh9yxQt7CTRi46YILam2DefogCImhjH9ybRADsfW2oNZjweSFI9dMytSQALE9ZRn5FUzoWqhyVk+p+R27Sr0HZ8QaTGVTd64IQHzwSU+9FL++/OB7Klw3HJYpU7zpnrmJUknitJqK9ypBPvzTPSqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BaSuBiuk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BaSuBiuk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6nJTH52gwMT1OzAJGmwX3x01ddsSLslou0JS60sTZVA=; b=BaSuBiukJkGliGKpSlCxWLjMgE
	rblYAha6hMD3H4l4aXyyXWbBxM2OQ1VjZ5upj3uQ4jV2yWA1g9EmclqdWrPg8IADcvpPf8WR4OCoB
	dVp0+Fg1Agsy7PUW8hbNSwgKebmc/GxHfWMTVAzibYm4wZqR1EZneTFV0A5bVd3MzrhCTkAdMEX+n
	POaDC+38JFJCNXSqOca2zihHJ+sDTWRTQKEyDbfZ3WiAUNxtjbe8aDTBEbIO/L6TF/EEYK2mPV+R5
	hkL55uV3Xo8/7yFPriZ82MuhLGe5DZaHt+DzdNXAaHH1Cf9VMz9aN/uEUxgCFUoSdv+H8EjPpemI9
	R1W0/GeQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wu92m-000000022FB-3smL;
	Wed, 12 Aug 2026 13:30:57 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 02065300382; Wed, 12 Aug 2026 15:30:56 +0200 (CEST)
Date: Wed, 12 Aug 2026 15:30:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: shisiyuan <shisiyuan19870131@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	shisiyuan <shisiyuan@lixiang.com>
Subject: Re: [PATCH] sched/psi: add cpu_prio pressure metric for
 high-priority task stalls
Message-ID: <20260812133055.GM776954@noisy.programming.kicks-ass.net>
References: <20260811104610.100617-1-shisiyuan19870131@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811104610.100617-1-shisiyuan19870131@gmail.com>

On Tue, Aug 11, 2026 at 06:46:10PM +0800, shisiyuan wrote:
> From: shisiyuan <shisiyuan@lixiang.com>
> 
> Introduce a new PSI (Pressure Stall Information) indicator that
> measures how much walltime priority-sensitive tasks spend waiting
> for CPU, exposed as /proc/pressure/cpu_prio alongside the existing
> io/memory/cpu/irq metrics.
> 
> A task is considered "high priority" when its static priority is
> at or below CONFIG_PSI_TASK_PRIO_THLD (default 118). The scheduler
> tracks a dedicated task count and state bit for such tasks,
> mirroring the existing CPU SOME/FULL accounting, so CPU contention
> affecting latency-sensitive workloads can be observed independently
> of overall CPU pressure. Both 'some' and 'full' states are tracked;
> 'full' is undefined at the system level (always reported as zero),
> same as regular CPU pressure, but is meaningful at the cgroup level,
> where it reflects the share of time no high-priority task in that
> cgroup is able to run.
> 
> To keep the metric accurate across priority changes, ENQUEUE_PSI/
> DEQUEUE_PSI flags are added and set by set_user_nice(),
> sched_setscheduler() and rt_mutex_setprio(), forcing PSI state to
> be re-evaluated whenever a task's priority is adjusted rather than
> only on enqueue/dequeue.
> 
> The priority threshold is exported as a Kconfig knob
> (CONFIG_PSI_TASK_PRIO_THLD) so it can be tuned per platform without
> touching source code.

Yeah, I think not.
