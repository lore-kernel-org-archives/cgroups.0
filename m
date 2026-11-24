Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795528789;
	b=Ly+w5GqdgIaCxE+4Mf02ZgEGMXs88hEh1J7SPjMxbSX1LG3zeMDa6L1wGaZld9vzhNpx
	 024M940I8nnrGSNAXck0l+2vZgp/hLLWSW9QBPWHHBdr0L0R9ennIGnzvdGDvHkrBUm2N
	 9qclEGbxzDIAXuAgKugv4RFWeZBE7tfAQFolg5qQZeMOnAur1dESdVFLKr2/8YsFFlvB1
	 MHuT2wysXpZd1tr7kq7CbppgGS//iE73PoE7NUZxbGD1E89HdHbUhoKkTKgLUEUhe99p2
	 hGb+Ijf17NhEnKPtCYeG3FGa0Bnc8h3QA5CKREtPQ24H6wM+eNYtDym/HJErBMw6IvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795528789;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=WqOCSpfhRpfrcDKrgHuNviXW0yZq+NMD1bfim2qiamo=;
	b=jNJZXqybnwLL2TqXx8TGZDcbWMExKtxhVmPJv3mZNQQiqSIfcF7RD7EcdGe7oPKc56ZJ
	 /hcpVkWbpm7yk+xlMrQ8ro/ANnNyTFD+txcA/QHgIX4gf0AGvgCsZhc8qWZOPNYZKsaY/
	 vRdJ8yvSAic7Rf+1Ig6UPH2swUCT+CFBJh2mh3Nf1Gun39j4UQD7ul1H4c1dSD77k0exZ
	 2Ae688J/2Le2kUHUsvDBaHJZoXs/4MDbz+1sxGOmAUfyndPz8K/lE8CPcfjhUekI3VvfG
	 qwmd7R1/Z3Yg/Oxp2cTQ9bc9BftRYIRpXlI6rqtYqbAURnimHtilMxZXTxFZug5bjsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=OY1QJ+xs;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=uuogxUnW;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99FD606A31E;
	Tue, 24 Nov 2026 13:59:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B99FD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=OY1QJ+xs;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=uuogxUnW
Date: Tue, 24 Nov 2026 14:59:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795528786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WqOCSpfhRpfrcDKrgHuNviXW0yZq+NMD1bfim2qiamo=;
	b=OY1QJ+xsSMAeWL0nvkyFs5MphIDdK1xPv+lgUVqMIqSesNji9sr4swYSXJF29vQiZIWi7N
	BTBg+8ndYK7LMybD9He0rfBIvwmcDvWDge65KnIx1sAkZx6/BPK8vojELdoDRTQUiGzAkb
	UIrDK4P3LRGM/FMK0Qen5I0m6h32YQkXoHFG1m4JwAGpAvmuTe94eBPFDsp+V9RtE/8/Yo
	/2+vBbc8fNd+A8yT22bSiKbV3/WrftIafDci4BpfvqXIVBiksTU29BSpEjSt97CHA7mOBK
	fBhMU8t6kQg6R2nK69oddTAnTqYjssq6hzpdGWwusldiGePMMQXtdFSs6sVqvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795528786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WqOCSpfhRpfrcDKrgHuNviXW0yZq+NMD1bfim2qiamo=;
	b=uuogxUnWw0+F9dwOGlBmLU11KNq5qd1/+4wQJVCPqbo7cSj+xIq+saL8J+LZRgxMmwV4cY
	qPVftjI9N2b+iSAg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rcu@vger.kernel.org, linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>,
	John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v4 4/6] sched: Limit sysctl sched_rt_{period|runtime}_us
 to RT_GROUP_SCHED
Message-ID: <20261124135944.VIRpdBBG@linutronix.de>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-4-d523e4d960d3@linutronix.de>
 <awVi0VQJCBNYc8u9@jlelli-thinkpadt14gen4.remote.csb>
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
In-Reply-To: <awVi0VQJCBNYc8u9@jlelli-thinkpadt14gen4.remote.csb>

On 2026-11-24 11:11:29 [+0100], Juri Lelli wrote:
> Hello,
Hi,

> It looks like subject and changelog still describe the previous version,
> as we are not removing the interface anymore?

Updated:

|sched: Issue a warning for sysctl sched_rt_{period|runtime}_us on !RT_GROUP_SCHED

|The admission control for SCHED_DL has been moved to sysfs and updates
|via proc are mirrored to the sysfs interface. The sysctl knob controls
|RT throttling within a RT group if RT_GROUP_SCHED is enabled. Without
|RT_GROUP_SCHED it serves no further purpose.

|Add a warning in the !RT_GROUP_SCHED case to encourage people to move to
|the new interface.
|Move the declaration of sysctl_sched_rt_{period|runtime} to
|RT_GROUP_SCHED because it is not accessed outside this define.

> >  kernel/sched/rt.c    | 8 ++++++++
> >  kernel/sched/sched.h | 5 +++--
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> > index bd37dbf2bebbe..258b187459bb9 100644
> > --- a/kernel/sched/rt.c
> > +++ b/kernel/sched/rt.c
> > @@ -2877,6 +2877,14 @@ static int sched_rt_handler(const struct ctl_table *table, int write, void *buff
> >  	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> >  
> >  	if (!ret && write) {
> > +		if (!IS_ENABLED(CONFIG_RT_GROUP_SCHED)) {
> > +			const char *msg =
> > +			"Please note that DL admission control (via sched_rt_period_us, sched_rt_runtime_us) moved to sysfs.\n"
> > +			"This update will be mirrored. Controls for RT throttling moved to the fair_server.\n"
> > +			"This will not be mirrored. The fair_server settings are under /sys/kernel/sched/cpuX/.\n";
> 
> I am not sure a user who hasn't followed this thread will understand
> what "mirrored" means in this context. What about something like (names
> depending on the unit discussion):
> 
>  sched_rt_{period,runtime}_us only control SCHED_DEADLINE admission control,
>  now also available in /sys/kernel/sched/dl_{period,runtime}_us.
>  RT throttling is done by the fair server, see /sys/kernel/sched/cpuX/fair_server_{period,runtime}.

Updated.

> Thanks,
> Juri

Sebastian
