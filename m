Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794340605;
	b=dKxJ2WLNx+SijmprHu80cDFcuUe4oxUE2Rvl7oT0fQO2nnl+Q/ZPpZpKI9Ec9y3vDe4+
	 mrRwYAb07XVlBp0XywCc72hPTvezMaa7uMP+QLCIs1W+EYdOZpR1NDa4KNHWihcLIsRT8
	 M+ZrS1FEsheazW62P3CSWdLl6FJLkQbaodo1a2WFd0/8ZepXUI9r+Uhu1lTHV9GKjYif7
	 J39+3fHLnpeN77OcBLOgzAFldihnfcpqkKBkd4j+SmxnTcGNWfzyN30YeHVtkXwT+5QKW
	 lAs4kxIpEVSdpkcBo4Di+XX5ldjmM92mXnxi1udZfcXG/RzA2fAY1FvyMV5D9x3zsQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794340605;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=X0P1xn7DMOwro4V4hfNIR9IZH4WRiTAHbOHV5MPmvj8=;
	b=lLmeaF5K7Y2BJ25jPYJzv9tlxsUZUgdrtpIweuzxiKvhXMrFwEg+M4fu0mEFns/CplSU
	 tQ1+tdzFfYB88uuxXBMG/O9ZdljEA0kd8QZm2zBf/lI9tEG3MsSFHLfYa3IMvE4CQTB4l
	 jXjt6/srSATihzErG6Q72wDIiGKP4aSCpidhmAJ2AoPorMG0Fu2mJDlzXNpt1skdH+QU3
	 LAdVBzFViIOZklucxryARsWYZumwAA7dkXeOfWsZ2Dd1S8b81FWE9bCc60TLSl8/q/jV+
	 xgQ3KmqUo03ldXAHYkBz2atjoBGF4/a9PcK4bKVJlKCX3WEMZ1CzSyMCbfMd1uDDa1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MSWBwruB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCCB606A326;
	Tue, 10 Nov 2026 19:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MSWBwruB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EF31F0089F;
	Tue, 10 Nov 2026 19:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794340604;
	bh=X0P1xn7DMOwro4V4hfNIR9IZH4WRiTAHbOHV5MPmvj8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=MSWBwruBUwX1RFyh5/WNLBZ1zTHwWKVzlH4BzIEmxirvu2ExjyCQVncKoL0+jQd9o
	 ShWrZjkqNuBfHzZXLFt1TnHByiozoCE2DNLL8ALLtf8xSQkwJeh1e9ne8TRZeSa9qa
	 3+UYyT4DcHl/q/NzIxmE1s9uMVRYD7wsSsHA74Nx6l7nVFZwvDMUljqp8maIV241Tu
	 WZh2W1ypx4wHX8ZKhuHrSMA5RwPChgVDDMoa0fyzoFmtC9gcJoJ+fru+3p+YgOPkEL
	 J+yxrkeY8brOsY7KypjsZWnfqzSNLhI+AV8U504NTDg63GgC+FNF5L6pcy981vRV0m
	 HTX/xjFvpYEmA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 4F13ECE0AD8; Tue, 10 Nov 2026 11:56:44 -0800 (PST)
Date: Tue, 10 Nov 2026 11:56:44 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rcu@vger.kernel.org, linux-doc@vger.kernel.org,
	John Ogness <john.ogness@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>
Subject: Re: [PATCH v2 0/7] sched: RT throttling cleanup and a bit of
 documentation
Message-ID: <c2bf89ce-b9de-43cf-839b-395d28b2275c@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>

On Tue, Nov 10, 2026 at 06:34:42PM +0100, Sebastian Andrzej Siewior wrote:
> People used to disable the RT throttling mechanism by writing -1 to
> /proc/sys/kernel/sched_rt_runtime_us. Since v6.12 they can still do this
> but they don't disable RT throttling anymore. Instead this throttling
> mechanism has been taken over by the fair_server which can be configured
> via debugfs.
> This is not really documented by a hint appeared a few cycles later in
> Documentation/scheduler/sched-rt-group.rst. This can be found once you
> know what you are looking for because this document describes the RT
> group scheduling (CONFIG_RT_GROUP_SCHED). The fair_server is used even
> without it.
> The then there is global DL resource control which also shares this
> file proc file (which is stuck if CONFIG_RT_GROUP_SCHED is enabled).

Nice, thank you!

Unfortunately but unsurprisingly, this gets the same divide-by-zero
issue reported (belatedly) on the earlier series:

https://lore.kernel.org/all/e58e48c3-ac62-40cd-b5d3-2de87db12496@paulmck-laptop/

							Thanx, Paul

> This little series:
> - Marks CONFIG_RT_GROUP_SCHED as broken because I was not allowed to
>   remove it.
> 
> - Untangles DL usage of sched_rt_runtime_us and moves it to
>     /sys/kernel/sched/dl_period_us
>     /sys/kernel/sched/dl_runtime_us
> 
>   This keeps the _us sematic that we used to have /proc. It _could_ be
>   changed to ns instead.
> 
> - Moves rcutorture away from the procfs interface since it tries to
>   shutdown the fair_server for its testing.
> 
> - Adds sysfs interface under /sys/kernel/sched/cpuX to represent the
>   runqueues. The only knob for now is fair_server_{period|runtime}
>   representing the fair_server parameters. If all goes well, debugfs
>   could be removed. The ext server could be moved, too.
> 
> - I tried to correct/ update documentation while at it. I added the -doc
>   folks on Cc so they are aware. I can drop them in the next posting, I
>   expect that this gets routed via the sched/-tip.
> 
> v1…v2: https://lore.kernel.org/all/20261105164724.yxONBd03@linutronix.de/
>   - Tejun and PeterZ asked for marking CONFIG_RT_GROUP_SCHED broken
>     first.
>   - Everything after patch #1 that got queued up.
> 
> RFC…v1: https://lore.kernel.org/all/20261023161348.t3lpPLQZ@linutronix.de/
>   - Try to remove RT-GROUP-sched after figuring out that it is useless.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> Sebastian Andrzej Siewior (7):
>       sched: Mark RT_GROUP_SCHED broken
>       rcutorture: Don't try to disable to RT throttling.
>       sched: rcutorture: Allow to disable DL fair_server
>       sched: Move DL's admission control to sysfs
>       sched: Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED
>       sched: Add sysfs files for the per-CPU fair_server knobs
>       Documentation/sched: Add fairserver to sched-deadline
> 
>  Documentation/arch/arm64/asymmetric-32bit.rst |   2 +-
>  Documentation/scheduler/sched-deadline.rst    |  36 ++-
>  Documentation/scheduler/sched-rt-group.rst    |   7 +-
>  init/Kconfig                                  |   2 +-
>  kernel/rcu/rcu.h                              |   2 -
>  kernel/rcu/rcutorture.c                       |  37 +--
>  kernel/sched/deadline.c                       | 338 +++++++++++++++++++++++++-
>  kernel/sched/debug.c                          |  56 +----
>  kernel/sched/features.h                       |   2 +
>  kernel/sched/rt.c                             |  61 ++---
>  kernel/sched/sched.h                          |  55 +++--
>  11 files changed, 423 insertions(+), 175 deletions(-)
> ---
> base-commit: fd9230005e85472b81c1c7c16afe93dd878996b1
> change-id: 20261110-sched_dl-a9727787112f
> 
> Best regards,
> --  
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
