Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794582703;
	b=DMFf9fwPujMs9aAxH8DZoMJMWuWDDVqx7AGj0yvndFkr2iFMYyaivReF49WGInHvArzy
	 hdY5iJiHMyrgb/oVFtlQQFgvvIVNB4ZpVNuYhO1dWhHBNKAogxlx+Ia9isSssHT0gZoMw
	 eZXOhIaGR2Ejf65t5sC/T7JL4L0lmdJN9T1Bn+WDf+WfE6piz0yMf/IGcrTPZzNWy2c0c
	 SXjxee6daz2ls8zJhDDcsdVH4XXJW3KBZ86Kblhcfk1ow8ODSTYttn7H6feQWGW2mh4KD
	 Fifflyuu1Q/1QQGkU5zXH3hRXp/M4qN03fJBfsLOEwEhb9lhauyPL3MARalIj2dNiaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582703;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=zpKzZMLZvo+ZN8WTIJeGkISnYHTZ26QRKQ/OOgDz+pE=;
	b=PxZ1PiC5XDTYYhfkgjGp7WeGDOfS146whjB5GBkbem/AJ7Mb7TLh6oq7OEgqWZKZo5+K
	 kIUQutg1WnmGvzpv4UREP0LiLuDr76kF0X40N2+E0PYlTMtZ7oHGz9Hzuua0IYoixxEA1
	 uszn7BqLs/KKk25bJh7Xlo+p7kc7588wFThiB+dxlkPYEr02T2drvTdmmU0VH1W9iRrS0
	 n1uUQLJp+1n3e5kzCtbctf8EwbJIO23hQvNqIJ5ZocmFdGSkxRwbaCMQyBOJ/xzsv5d0p
	 aUmwdAuRngIfud0ns6meVe0zKhefkdNNr+Eepi6nP9DItdMVr4CWhNDRBknRdyLMcSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=gpnFN32x;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b="noVGVDY/";
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CB1606A323;
	Fri, 13 Nov 2026 15:11:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6CB1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=gpnFN32x;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=noVGVDY/
Date: Fri, 13 Nov 2026 16:11:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794582699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zpKzZMLZvo+ZN8WTIJeGkISnYHTZ26QRKQ/OOgDz+pE=;
	b=gpnFN32x+Ihdmj2mY9lPq7eES7du1+qVkvmWmY+obfl5Lzle7HJBJAZ9OCUmKoPtyvNdwl
	7WR8kRIsJ6Fi79nNMxyFoa0+EA5KCo4lSbg8O/3TwR4wM2rri4FSVVj3ngN9Zfv0+8kr9x
	9drZzCd8GxyWIVVY7Srvhg1ie6hp8ZtWS/A76OkcQA1y28i50BsadJI5mW0LCZt1QA8Kjy
	hqFIuLmvLQ6mz9+xG1bSZeOtZR/onO8lORuu/L6mCRu8TfeqmRZNNg74c6l93eqvb5areG
	gOt/5fsLtFyBGgdOSHNLWgrE/KUaszzYe6KptMhrAtXbvvdCELhprSIVWOaJTQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794582699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zpKzZMLZvo+ZN8WTIJeGkISnYHTZ26QRKQ/OOgDz+pE=;
	b=noVGVDY/N66pB5YBRfX9UPJNmb7M5sxRVKGR1FuyawjVQtKLtOmJxi8QMlbdwImx/95hws
	dfXtFj+6IAxC8ZDQ==
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
Subject: Re: [PATCH v3 1/8] sched/deadline: Reject debugfs dl_server writes
 for not-active CPUs.
Message-ID: <20261113151137.Skd8_m_D@linutronix.de>
References: <20261113-sched_dl-v3-0-a76ffa1cdeee@linutronix.de>
 <20261113-sched_dl-v3-1-a76ffa1cdeee@linutronix.de>
 <avcjQMlVELcauQld@jlelli-thinkpadt14gen4.remote.csb>
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
In-Reply-To: <avcjQMlVELcauQld@jlelli-thinkpadt14gen4.remote.csb>

On 2026-11-13 15:48:32 [+0100], Juri Lelli wrote:
> Hello,
Hi,

> > --- a/kernel/sched/debug.c
> > +++ b/kernel/sched/debug.c
> > @@ -410,7 +410,7 @@ static ssize_t sched_server_write_common(struct file *filp, const char __user *u
> >  			return  -EINVAL;
> >  		}
> >  
> > -		if (!cpu_online(cpu_of(rq)))
> > +		if (!cpu_active(cpu_of(rq)))
> >  			return -EBUSY;
> 
> Mathieu's approach [1] looks safer to me. sched_cpu_deactivate() calls
> set_cpu_active(false) without rq->lock, so a write that passed the
> cpu_active() check can still be in flight until sched_set_rq_offline()
> (which the !cpus check then has to cover). On the online side,
> set_cpu_active(true) runs before the domains rebuild, so the check lets
> the write through against the def rd's accounting. rq->online is only
> changed under the rq->lock this write already holds.

Okay. In that case let me drop this bit.

> Thanks,
> Juri

Sebastian
