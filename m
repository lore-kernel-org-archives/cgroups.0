Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792786072;
	b=2pn7LK1ObNpo4rmPJRb8q7DJHtBdQKvnu9gFLz54S6FTp4D2B9JN9mBb8abl12rnsp0h
	 F7nXfuxVccGv0aI82/4dB3ChfMxcpk521ofjtSJ7zt8/DHH84rLFc1yTwC1sNAqxRt1hp
	 s2lPkGjuccyxJOquGk4hjHTy0BSdMCqnBmiF3A/OyLVdFMl/VTq8A1Px14pspH3X5tRhr
	 O93wDbS6LayNoKej89Px87Aje9Jlez3YqUcdt7uHvzTjcr0p/WuRgXMEbKwVr7lik4ppr
	 /mp6hyZkmzXtvCdU9JCs9vXZPg6RSoJqAoZ0eRo96hoi15EE8DZVcam3LH7HjpIXICw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792786072;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=EuB51aRYMoB3ieHrj2HnljEvnH4sVtaaiFVu6E2r2rI=;
	b=qDXB3hEOSx+RmZzJZyPIKFPc5Gw8FGLanv9rPwkhzBUR37G/DHML+O2hGb73JV2TIq55
	 1WYV/6SrlxzYhpam4Ok8MbMr+9oDKGkMs8JqpwDGQHSnJMMIVhzu6520rKY/XsFFFpSCp
	 8lp9e71xOaZsHoFU+eyvNnLjOErYjVMVThc6PKI/Q70SGKw4nX9DAJ7W/bchXKQDQ6iDy
	 atkZ8JofX31dMTiKCpJA3jrfMNeTpXrSqAFGPKHbmqWZMtfIK4ea/bkN4n5zazQ6LiM0b
	 QsvS0aVRRfb7oX7zqBlca+Jegj4tx8iB1JxjgR9z6241XT3dHLU2MFfm+LV7sihjZsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=HkSUsKbf;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b="/YMLS10H";
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B8A606A31A;
	Fri, 23 Oct 2026 20:07:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56B8A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=HkSUsKbf;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=/YMLS10H
Date: Fri, 23 Oct 2026 22:07:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792786070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EuB51aRYMoB3ieHrj2HnljEvnH4sVtaaiFVu6E2r2rI=;
	b=HkSUsKbfuJQTn0aaj9vXHYfaR5vi75/PcqdXUYMySN2iIr91wW/mztEkKebDB94J+iA2fF
	LsA5wpYac5ZQRJm4Z1pMVNcUOabu1pjkSlgN4joSCQ2gv4ukBXb1t3kTibZKKvBnBzJHdW
	xMBRrUjYkBdL52PcIp3nFncCUPxd+5BFwbUXZLTDb3xbYw5KMpNBoAW6RQHt2TgH5sSnZ/
	y7l8kT7Ct9Emgmeq58s5vJ+0OKVBbzTUqoa92hmVQSpHMvnuqWv+e2bk/qx3wFJFTajzpx
	IyKukRtXvCX23Le7W14HD3tpuiQLsWsuV2BOt5tXnA3+Q0bcL7fglkU4hXCMRw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792786070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EuB51aRYMoB3ieHrj2HnljEvnH4sVtaaiFVu6E2r2rI=;
	b=/YMLS10HHiqlizs6HC1SdrWf4xHEd3TT3+P+2jr2SjCad/8NNgyMe33Ga74Py6hP5yeGhy
	0ilMSvQDMfQPVcAQ==
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
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
	Luca Abeni <luca.abeni@santannapisa.it>
Subject: Re: [RFC] RT throttling, DL/ fair server, RT_GROUP_SCHED and
 everything
Message-ID: <20261023200748.YZjSwZ48@linutronix.de>
References: <20261023161348.t3lpPLQZ@linutronix.de>
 <f29f77edb2776b734306fd482b47a64f@kernel.org>
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
In-Reply-To: <f29f77edb2776b734306fd482b47a64f@kernel.org>

On 2026-10-23 07:16:10 [-1000], Tejun Heo wrote:
> Hello, Sebastian.
Hi Tejun,

> On Fri, Oct 23, 2026 at 06:13:48PM +0200, Sebastian Andrzej Siewior wrote:
> > - Remove CONFIG_RT_GROUP_SCHED
> >   [ ] Yes [ ] No, because
> >               _____________________
> 
> RT_GROUP_SCHED in its current form isn't widely useful. No major distro
> kernel enables it (Fedora, RHEL/CentOS Stream, Debian, Ubuntu, openSUSE,
> Arch and the Android GKI defconfig, PREEMPT_RT flavors included). I have
> no objection to removing it.

Perfect.

> There was an attempt to make it more useful: the Hierarchical Constant
> Bandwidth Server (HCBS) patchset from Yuri Andriaccio and Luca Abeni. It
> replaces RT_GROUP_SCHED with per-cgroup deadline servers and a cgroup2
> interface. The last posting was RFC v6 in June:
> 
> https://lore.kernel.org/all/20260608121546.69910-1-yurand2000@gmail.com/

Yes, I am aware of this. It replaces RT_GROUP_SCHED and does not rely on
it (as far as I remember).

> The effort seems to have stalled.
> 
> Thanks.

Sebastian
