Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795507718;
	b=u+rFx3X5IVUI/G5EyzKPzn6fdzC0RxC9vNBwOrcRnZgUztbqKy7yukK/aJUPCCsS5hTH
	 gEReVLXZO97tuqYOcGfbqjk84p4MiVpKK+JgFHDvFEPU8SZ2hFT5ITMPSDlUdVyvFaCai
	 514QEvBtmjucSB02zk92/ZwusM3PjH9yqgnLO9GiI5yNv6BlTXgWBx29UCPZmd8ISZvNt
	 FwKMP7DZ2fRy9YXvfbN7AFI0mS9pSQ5TYiejU8CfVvblUiZjHuFPXs+o8pg/EXfCvuol+
	 yQF0gsWZ0POoVuMg/y+CPNVQADTIz7wzV5MRAgvKgk9uoeQkIjxyc+eOTh3Cjfp0ARw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795507718;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=Rui415BXN6LQDJtlDxX2N/m8ikGKOPR/KXiSQWGrwO8=;
	b=OJL8WgKrrcYD9srT9EHMdIRVkqrKa8QFoiGqoT2JaPFAsnvkx4zHEhlE+j2QF4M1BD7I
	 wUIibnAb1dNZrimlX8FtFJoikyPKh3MCny0cE5DdcKbFdErsoc9ZJgDKRC6NwFCnCU8TY
	 1gbzTorvzVy7hDstpgOZpgMuNoP+bjM9Am9KgeoOIe2F03CFqQ6SH5NMMj6ul6vvLyUVM
	 //4BmCHcsMb/CRRdGgsBHTQ1Ydj6Tino1gpcD4R3xcz213wAnH0cLWgA0Xnh/X+t0Tt7S
	 W6Vg1Jhz2PzJn7jvGSVidDGQcghOpcNmeORFTsNclKoPV/olkuR+RmTAyvHBKaDbwRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=Ob+kzqBO;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b="IYM/Ts+c";
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F18F606A31E;
	Tue, 24 Nov 2026 08:08:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F18F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=Ob+kzqBO;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=IYM/Ts+c
Date: Tue, 24 Nov 2026 09:08:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795507715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rui415BXN6LQDJtlDxX2N/m8ikGKOPR/KXiSQWGrwO8=;
	b=Ob+kzqBOIdWlT+kWzEkrKu3xbz1ZDVnKHLF8tV6OF+/ElE4cX4ltP5jtXrSp01MCLI4dIJ
	7B/Z76zWO8flDXxBetTgZIfWQbO6iK8n9EwwkSpahQ0F34X+sEbRba5BTn0OfsBcP71EOX
	ATk3ZFAqG4w04LpAOWL+vIVaFv21hxEm2RFC5ZLhIojxuyxnkDgduJQynXWHp3Ay0bg63S
	J0KCe//a2PuOelf2cHPjYsWAlQH4lpB813W7hbkGjymshP3zQ346LnYK/j3fXzWCzNwjNl
	Z7fsIzx1hdwqJKnC0qK+hEehaCA1WUeZSOw9ZRoYgR9qmcU7G3Ubb1BxmuxbbQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795507715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rui415BXN6LQDJtlDxX2N/m8ikGKOPR/KXiSQWGrwO8=;
	b=IYM/Ts+cU5pFIDw1VQn7XIr6H/Bc08V2WzL/ps98TC0upmKHPp1OZCYmoOKvydvtj0zRiN
	cEauxIaU3yxbDSBg==
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
Subject: Re: [PATCH v4 3/6] sched: Add sysfs files for the per-CPU
 fair_server knobs
Message-ID: <20261124080833.0I9HFgtf@linutronix.de>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-3-d523e4d960d3@linutronix.de>
 <awVDG-ABOvj7zGRg@jlelli-thinkpadt14gen4.remote.csb>
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
In-Reply-To: <awVDG-ABOvj7zGRg@jlelli-thinkpadt14gen4.remote.csb>

On 2026-11-24 08:56:11 [+0100], Juri Lelli wrote:
> Hello,
> 
> On 23/11/26 14:41, Sebastian Andrzej Siewior wrote:
> > The fair_server exposes the runtime and period knobs per-CPU in the
> > debugfs folder. The debugfs interface is not a stable ABI.
> > Make the /sys/kernel/debug/sched/fair_server/cpu*/{period|runtime} knobs
> > available as /sys/kernel/sched/cpuX/{fair_server_period|fair_server_runtime}.
> > 
> > It adds a struct kobject to the rq and exposes only those two. The
> > per-runqueue folder is named `cpu' rather than `rq' since it might be
> > more intuitive to the user than `rq' or `runqueue'.
> > 
> > The set logic is pulled from the debugfs folder but it is still shared.
> > That debugfs logic could be removed (after providing the same for
> > ext-server) or symlinked for a while.
> 
> ...
> 
> > +static ssize_t rq_fair_server_runtime_show(struct kobject *kobj, struct kobj_attribute *attr,
> > +					   char *buf)
> > +{
> > +	struct rq *rq = kobj_to_rq(kobj);
> > +	struct sched_dl_entity *dl_se;
> > +
> > +	dl_se = &rq->fair_server;
> > +
> > +	return sysfs_emit(buf, "%llu\n", dl_se->dl_runtime);
> > +}
> 
> Since these files are new and meant to replace debugfs, how about using
> ns everywhere (you partly commented about it in the cover letter), as
> sched_attr and the dl_server parameters already do, with the unit in the
> name? I.e. fair_server_{runtime,period}_ns here and
> dl_{runtime,period}_ns in 2/6, with only the procfs compatibility path
> converting from us. Right now /sys/kernel/sched/ has dl_*_us in us next
> to cpuX/fair_server_* in ns without a suffix.

I can do both in ns (or us depending what is easier/ more useful). Let
me update that then.

> Related, do we need to add Documentation/ABI/testing/sysfs-kernel-sched
> entries for these and for the 2/6 files (units, defaults, limits,
> what 0 / -1 mean, -EBUSY on admission failure)?

Oh. That is a good one. Yes.

> Thanks,
> Juri

Sebastian
