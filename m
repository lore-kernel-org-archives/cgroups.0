Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907014;
	b=Ro0qCVcpXVd9WCyD9GMQJzua9hw75gHre+VM32jOAuVNXJchJodWFUDD8EvNmtbgu4rO
	 W+dWYpIXISvKSJL9h1R2KU2cHqu+m4OQiKNFQacgb/9GrTe7kyoZyqF3QjlIPA0y5AGT6
	 dMs80Dhr06Akd9gEUo8poZEK/667wqRGrYdTgvw6bl8Fm0VpUQgHuI6IMIrf4J+RlxeoG
	 9hbBllHADULa8dOfHMy03L3CYTY5Mt7xVcq6+QnQUO8LHuvHHYpa+bN/a46yDZGjUuLro
	 DM+paSZILxauB1R9cYuRQti9A43xIwky3huNFBQvPGlHPKcANprDRtIR0qQypN6l5mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907014;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=hBiMPC/mSRFQIthZJMHQ6VsuWvW84Hflt7MDyKrRRhE=;
	b=A2wnZQ93neSM2VcuVvn4ze8ftQ/fghJcQ0B4ygxAdH6GFP8Xt658XtbBU1GVsWslMJu/
	 /SKiHYYr3ptTRiW/vVyqGkoaPlCbrFUsKlIEsG3k1lQbs2GChtxBbPmcWaq3fdaUDTj2y
	 Yo0yoFTpUB1SNwmb6CJBARJUzoYTT/OrrCSbRCWgQ+emqwdzpIKhGW1rEfsWuPJ/XemMl
	 PJChJ2uHGbjMjsv4ZuSEVjRgo98VlQIfT+t24WbMXL9V7DaJUP/Ko78v7ckwuk/0WLrGm
	 mDhA1WY1CraztKx/vIQgDWZjFlmeR8D1S2u22Nq1CkK/y1lyxe375aNYfpc/8SrEGhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ONzyxZ09;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b="q/7HWdtA";
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FAC606A6EE;
	Thu,  5 Nov 2026 19:30:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53FAC606A6EE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ONzyxZ09;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=q/7HWdtA
Date: Thu, 5 Nov 2026 20:30:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1793907012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBiMPC/mSRFQIthZJMHQ6VsuWvW84Hflt7MDyKrRRhE=;
	b=ONzyxZ09QiqxpgqKgkhY8CcKeGquIrSofRjgsorpQfVlVsIu+2bx4JA9aPix/aklhiwYNI
	NtrpnYDNDMoc3g79qGlohNhpS7TtZdw8bFDmSDkjDEj58o2dJA43aES2tdctXdDvGueGwN
	14q4oarYSEWkYznum0vCnKhzyc14yI2Y2LNRwtp/J2Jj7RsDjrVIsundKyVDEKPl6zlcT/
	uzc1UXtj7/31BZBx/3fZyhizPNl0tANNetAxsiR8JQhvmHCc4g5BCdti2RObgCvgq8db+X
	9s2wGtXUWd1F17oUB7fg+Ix10AvHZm/FiqjL7JmOt7Q5nz6BJi533VUBQaUgRQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1793907012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBiMPC/mSRFQIthZJMHQ6VsuWvW84Hflt7MDyKrRRhE=;
	b=q/7HWdtAJhzMMCC8FYyQrmjg3F9P1Q8m/5sbtDH5MXzrNIYZB76HbsTvd7nfWL9xxJKrM8
	ueNzLPNDTkTmw/Cg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: Re: [PATCH] sched: Remove CONFIG_RT_GROUP_SCHED
Message-ID: <20261105193010.tXUDDu2w@linutronix.de>
References: <20261105164724.yxONBd03@linutronix.de>
 <auy6nyTUuHBlgrV_@slm.duckdns.org>
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
In-Reply-To: <auy6nyTUuHBlgrV_@slm.duckdns.org>

On 2026-11-05 07:19:27 [-1000], Tejun Heo wrote:
> Hello, Sebastian.
Hi Tejun,

> 
> I'm not against it but wonder whether it'd be useful to do it more gradually
> so that people can pipe up if they depend on it. ie. Mark it deprecated and
> put it behind EXPORT for a bit and then BROKEN before actual removal.

I would be surprised if this is actually used especially since it is
cg-v1 and v2 is the default/ used by everyone (?). 

This depended on !PREEMPT_RT in the RT queue. People asked if this can
be enabled because it looked useful/ for their use case. I researched
why it was like this and dropped that restriction. People then asked if
it is broken on RT because it is now working properly. I have never been
told _what_ is broken or *why* because nobody came back.
Later I've been told (there was an attempt to explain it to me, it was
late in the morning) and if I piece it properly together then, it could
work in UP environment but on SMP the accounting is wrong and therefore
the runtime/ preemption is not working as it should.

I didn't add this to the commit description because I would classify
this as hearsay and we do facts here. PeterZ might know more.
From what I know, people who asked for it either have a different
solution or eyeball HCBS.

> Thanks.

Sebastian
