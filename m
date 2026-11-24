Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795516513;
	b=F4kQ7gHW4dHQGMdA9eQ6SsPL1Jn6ULOo86FXm/3KnPrC7iMSoMCEAJaHyWqyL20lJTPt
	 5srVtfD0d9sqRCBpwUAPJghNwuWGHhYSLgZosTt2DYajE8J43gkILFKU6DuJE4yLlh9AN
	 DG1DVgfV5v6dcXih4ZNsFmi3cL4W+/CBuURNhA6QYzpNkS9uRq6QiEaQ25lOTt0uWJf4e
	 WoEQdGubhNA/PwtF0tuHLvddd5znu6s1hYg1DuGv9Sf0cjt21Eatse9YZzOMJsEnpEvqN
	 B09XifxntTohe7hlE/Beoc4NBwTDar9tC5+HIO6wIT99HJD6QaKLRPN5FdMYZt/YF7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795516513;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=yv05lreakyU5Zw1UHDQ2CzNSi5TT2d/xJeOs5UM7o/w=;
	b=wtlQwW9HRMb+/DH9ow9exh7bb33wdvT3CAjDHNtKMqGfbvmmyAB6tY7kOGY4grJmnyhA
	 Jf6NmtWbpEkrb7gnZ9rF2JTgH09y//fL6OveUn7O97BqqKu0J1kzThOoBv4uY4J8zKWQ4
	 +qEoiwGl7XVREN9fGHTALZ3A2G0a4ETrtlBj/6q7Hp1kbFmMKX/iEOlpAUWenJL2PMTz3
	 bw3HVRQHxEUrRI7Y6hrcC1x+Rgm7bRvmTLGw+dYicpK3hU5RRUEnfFOIgZkD/Wuqep7vY
	 KsTMOi6BpljuVgNN2oID2OQIa02CZjGNNhqYTdKyklOVc80kZ5IhmpMyANaFYndNpCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=QQNodHch;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=IKRx4wbF;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2536A606A31E;
	Tue, 24 Nov 2026 10:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2536A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=QQNodHch;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=IKRx4wbF
Date: Tue, 24 Nov 2026 11:35:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795516510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yv05lreakyU5Zw1UHDQ2CzNSi5TT2d/xJeOs5UM7o/w=;
	b=QQNodHchhyX5xW2TbJwMMMneSDT2veM3lVNYotwlk+fOrqDHVnGmQLqNQYXbKpQpHqkWYt
	hmKDy5yLHJhi5eumhBW27QPPsPRvs1g9r1lI2zSkagge+gSZ71XUCEx2U4/cR6VKsgoYLd
	N04u5ORDfxciLV9fTUzcqaFfexZA0UIH1eYjroB1Yt9tITz68chKXfPUcRSnTpKbpwGsxW
	Jx2aeao14PQXET4a9uyYHVYwQC7wJVzAYWJTiiQF0RuOK8yDSmRhBQGIo4M8fnlvXrG+dh
	fSi06PmyG1a34MYcMHgfYaAxT+oNtqPMAGnGJzWBWeNzYvyK92bKQoXCqGn3og==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795516510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yv05lreakyU5Zw1UHDQ2CzNSi5TT2d/xJeOs5UM7o/w=;
	b=IKRx4wbFbw6QxGlL5tBNume37ux5OI7Jm46WVa/wkUV9eR+RfCJ61cCY6468pkcM3OGmZg
	+BN36z6Gp4bWAwAg==
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
Subject: Re: [PATCH v4 2/6] sched: Move DL's admission control to sysfs
Message-ID: <20261124103507.4u5Sz_bU@linutronix.de>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-2-d523e4d960d3@linutronix.de>
 <awU9KmFsbiyvbcOr@jlelli-thinkpadt14gen4.remote.csb>
 <20261124075332.nZysJRfS@linutronix.de>
 <awVfotZsGc8S_aB0@jlelli-thinkpadt14gen4.remote.csb>
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
In-Reply-To: <awVfotZsGc8S_aB0@jlelli-thinkpadt14gen4.remote.csb>

On 2026-11-24 10:57:54 [+0100], Juri Lelli wrote:
> > > Nothing updates sysctl_sched_rt_{period,runtime} when the sysfs files
> > > are written, but this always passes both, so a procfs write of one knob
> > > resets the other to its stale sysctl value? E.g. write 2000000 to
> > > dl_period_us, then -1 to sched_rt_runtime_us: admission control is
> > > disabled as expected, but sysctl_sched_rt_period is still 1000000 and
> > > the period is back to 1s.
> > 
> > You want this working both ways?
> 
> Want is definitely too strong of a word. :)
:)

> > I assumed you use the proc interface because you don't know better. The
> > warning makes you aware that the throttling knobs and DL knobs moved to
> > sysfs. The DL bits are mirror to the sysfs interface in case you ignore
> > the warning and keep using proc.
> > If you move to using sysfs then everything is fine. From here, going
> > back to proc looks odd.
> 
> Odd indeed, but I wondered if it might happen that a sysadmin configures
> things properly using the new interface and some time later, say, an old
> application that hasn't switched yet to the new interface resets/tweaks
> using the old interface?

Therefore I wanted to remove the old interface. The legitime users would
want to change the default DL attributes. I am more afraid of those that
intend to disable RT throttling and are failing to do so.

We could also make the proc interface return -EINVAL on read/ write once
the sysfs was used. What about it?

Sebastian
