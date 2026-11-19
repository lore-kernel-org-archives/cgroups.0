Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795098232;
	b=jpb7bzYeI4UAh4BQKVaGAcxXDInoSTL4Z+XcEwIkkszBkg8rQistT9DZjlR6RS8mmTwb
	 RPTboXSMl6V98135WHaJUA+l6RUC7G4WC0g1Cmx11L358UwbWArb7oMPT81OkjtAHV2Qk
	 C6HVz2uqTKdwurlaylKWw5nnuJdwb8iGbsoyY+hrq3iKiEkixX8KJVo6qldnPgtlDGduG
	 Ws3DwGs4uDQ03XhsvOzHmaAIdEGg7UAez9LTprIMZf/OKfNuZpgThKeNFOjnZzJ5/2Y4i
	 D0ErPKFRS9we+Pia+mGUDZCmbD0ilmGKEcC6BY00UnV2Uv5Nrwn9gNoIiMxpmBsOl9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795098232;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=sFju/1HR8D4dGfEsV9o9IsWma24lYxtJ3WMUExZI3CM=;
	b=j39ezA1qU+qNWO7ML54TItLltjRaCSDNnJb+580kXdiM0k2A5fHV64TYFRCqOdoFzQKj
	 b6yQ5ftozVg/w7v2sZ9R3dVZbGT6sp1ROf8HZ/yqeuCsVqU0m91AIIqwzwwI9pgfvlxW5
	 rnqbGC6z2xboBcPGsReImxvKjF6KTdC3pnV3SvgCtEO2rmVr0mf1zV6BhGHjqf/1tLgW2
	 t6REczHXtGQQNjwhtjf4HbKAM7xodPFxTVbNH3F5CCRYWd02CnCPWLn4Z3YqIh2Ff6HQe
	 an04X02lHzPDHd9s4JV6X1kgZomT14xcOOc4OvqgZEJ6nEOHzqtkdlEdkX0IK1tjCBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=T0xL47Vb;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=hB3TSCjH;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585E1606A331;
	Thu, 19 Nov 2026 14:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 585E1606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=T0xL47Vb;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=hB3TSCjH
Date: Thu, 19 Nov 2026 15:23:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795098230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFju/1HR8D4dGfEsV9o9IsWma24lYxtJ3WMUExZI3CM=;
	b=T0xL47VbEsUbhj2RinyONMU2/ofHZXyc9bMcofgkQ2RiSxRzL9YUli0b3MjC3CRLdSjWw+
	CdTbMmcisggITNMMGvaXS4U1Dg0QTcPO31+bqYELe6RpbrdSF53b9Ybrly8r8PWqUjZxQ3
	BnRGIvZBg/kBFeFy5bCbMCdmblcEGCwyAmr4G2B0Oi/u6T4glU5b+0nyXUtAS+2kcfPaKE
	a1kusWTLGmSwgCtcNcd42yv3sy7G0H8bZGiBm2oUDRlpE5yO3vNMeQbm/Kxe+ptTXdpiu6
	UT1FlePKgJvTeweokPV2JjSGn8nn+SS4pj6iSD6YvPc8AHJBojMsHVs7ZJzdRQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795098230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFju/1HR8D4dGfEsV9o9IsWma24lYxtJ3WMUExZI3CM=;
	b=hB3TSCjHaJc0Tb+O4RfNg+PzzpZkdB6FNKDa3Y8i52g+wfjZ2gSZH3CSN9c8sBBjo/O0cw
	5oEHHy4C+qexRpCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: kernel test robot <yi1.lai@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	aubrey.li@linux.intel.com, yu.c.chen@intel.com, ltp@lists.linux.it,
	cgroups@vger.kernel.org, rcu@vger.kernel.org,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH v3 6/8] sched: Limit sysctl sched_rt_{period|runtime}_us
 to RT_GROUP_SCHED
Message-ID: <20261119142348.MkPQ2Fby@linutronix.de>
References: <20261113-sched_dl-v3-6-a76ffa1cdeee@linutronix.de>
 <202611192004.cca8bf73-lkp@intel.com>
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
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <202611192004.cca8bf73-lkp@intel.com>

On 2026-11-19 22:11:10 [+0800], kernel test robot wrote:
>  [1;31mBroken: [0m
>     =E2=80=A2 proc_sched_rt01
>=20
>  [1;31mFailures: [0m
>     =E2=80=A2 proc_sched_rt01
>=20
> Session stopped
> LTP test details
> ----------------
> starvation: starvation.c:115: TCONF: Skip test due to slow kernel configu=
ration
> proc_sched_rt01: proc_sched_rt01.c:45: TFAIL: echo 0 > /proc/sys/kernel/s=
ched_rt_period_us expected EINVAL: EBADF (9)
> proc_sched_rt01: proc_sched_rt01.c:47: TFAIL: echo -1 > /proc/sys/kernel/=
sched_rt_period_us expected EINVAL: EBADF (9)
> proc_sched_rt01: proc_sched_rt01.c:53: TFAIL: echo -2 > /proc/sys/kernel/=
sched_rt_runtime_us expected EINVAL: EBADF (9)
> proc_sched_rt01: proc_sched_rt01.c:62: TBROK: Failed to open FILE '/proc/=
sys/kernel/sched_rt_period_us' for reading: ENOENT (2)

The test writes to those fies and now complains because the files don't
exist. My intention was to remove those files because writing to them
serves no purpose and people don't know this and _assume_ they disable
RT throttling.

Sebastian
