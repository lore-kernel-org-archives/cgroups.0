Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794497092;
	b=wbSqDihNvO06KZt2gqOQWrQsldsO2sIxu5JpcKsRUlwubQbP0qN8wuJo3GZG9eztFnLk
	 7cEXxGSYc1nOgGvufpOhSfdm6ouQV5bT0b3+Zti0cmwl7zz+pWEP2C9XKI5Xv9fBm8Mhg
	 GgyyoQcgWnteSMpOFOXkE5JL2JsGm1qcyqAzebFEP03Ksyfy0VxnzzPbEWLMrnH0Xh0zg
	 HixJiZ5E0OgBDUXKHQRmtD1aCRapxFXyDr5LJYr1SeiWb8mFV0ojs5wE7TzZXRYriMJSm
	 EKs9K61lSINpAjHAZGrGuJq1Sq3XvSIUy6sKuRCVk8buXhOnk2Kwq+9zBslLDQmpw0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794497092;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=juYtRRHMjWPIclkbiXs3Tnl2bycAjKMpFCBpuknhHPI=;
	b=ORpBhs+VNFPwTAQhVoETIOsy+/r/1bcd3dK2zldBlZs4UbHRuTx6kgzAXXRlg1DDDhP/
	 ueTrnxkgnrgAS2Zt97z/V7fByF9Y1ktSJWaMIR99Y1kcDybZ6bT49imyC9rtwMpE1deok
	 yY1D32P34LOuyijrK+ni7wXUdQJJLGaxwLeL41/stk8NFyE8FMjj328jr2jkkaSMCIY/d
	 CrdqWEMTTzJK9CiQhSNRN8Ig56bi/UbP8lykoYVMCfs6u3cXdg0oxeNxycYiFTwsk/We0
	 ERPyB/U8Ze6wWOgJ9s/JsYzEeX+9YA3kQOVijJFGFqb4w+0EbrmBafnthKcU44oTNcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b="Qi/grySZ";
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=SH5FMWEk;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF94D60A2607;
	Thu, 12 Nov 2026 15:24:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF94D60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=Qi/grySZ;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=SH5FMWEk
Date: Thu, 12 Nov 2026 16:24:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794497089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=juYtRRHMjWPIclkbiXs3Tnl2bycAjKMpFCBpuknhHPI=;
	b=Qi/grySZIrRaJ93RA5uI25BI6KfrQnUqAtF6Rf7+aMLx4D00SHjpJbLmo+BctsMkzDKGgL
	hDMTia9tb7LorDmWBS4gloetNGV4wW7/uDabrX4VEPJnKzynlAYptW/7ZxvA/ygwiFmdDz
	cSyvas609NCTBG4GZz3i8gafGomgy1iRG87rsG2GeTNwqC6H5zQqCc7XurQ5MUeM8pc8xE
	NtD6HCFPbdmnqWKXPf9YciRRZAW/1ap1CgsUjkeEe67YhAv6F7tADD3NUhvKf5nNUr3/5V
	IkRTw1aZxjFvN37fpJrqLxZWHqogT+IuG6DFgT9C1BY1LWTw3mylQ5IjSzfLig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794497089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=juYtRRHMjWPIclkbiXs3Tnl2bycAjKMpFCBpuknhHPI=;
	b=SH5FMWEkY6wITOgzqZep0yejRfNPKqDYkaqq1NL0VbdxIhYTQWxNJRVzf7bmTACRuyINwU
	Y1YAjO4K7KsRRxCw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, rcu@vger.kernel.org,
	linux-doc@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
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
	Qais Yousef <qyousef@layalina.io>
Subject: Re: [PATCH v2 0/7] sched: RT throttling cleanup and a bit of
 documentation
Message-ID: <20261112152446.r1FzXVCR@linutronix.de>
References: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
 <c2bf89ce-b9de-43cf-839b-395d28b2275c@paulmck-laptop>
 <avXUstjABxdTZaxM@jlelli-thinkpadt14gen4.remote.csb>
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
In-Reply-To: <avXUstjABxdTZaxM@jlelli-thinkpadt14gen4.remote.csb>

On 2026-11-12 16:01:06 [+0100], Juri Lelli wrote:
> Hello,
Hi,

> I wonder if this fixes is
> 
> https://lore.kernel.org/lkml/20261108185406.1549770-6-mathieu.desnoyers@efficios.com/

Looks like it.
I delayed the update to the thread which runs on the CPU and replaced
the cpu_online() check with cpu_active(). It still aborts if it is not
up. The other alternative is to skip sched_init_dl_servers() with
RCU_TORTURE built-in.

Side note: If you boot a 4 CPU system with maxcpus=2 then CPU 2+3 is
offline. You can online them manually. sched_init_dl_servers() will not
initialise them.

> Thanks,
> Juri

Sebastian
