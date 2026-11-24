Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529522;
	b=sPq3XgIbepaENGXtUH7RcQdm0X4dDppOOlzM8yiAbOR8t/n+GCgN6evNAortwDKDDVDB
	 N3yOFTHnL9xsaNQYl6nQlCNZQvp4S0MKXYBV3FghS0IV2m3AdapilhDo22deNLB7J9yeO
	 wwv9k0965MhfY/H43bqXtptCe6rdiubMxn8AP1Z+gi4SfPE5YyD8BH7ktDrjNmbbkBrOr
	 m4tiX6WY9eAA+ZRYX8CWtt+fqW9Ft5Tyh762lu/pCoBm0HiUCqhqX5GiKT/IRjrHOV/2H
	 zsImxuWNESnSDcmYEzNHj0agVQv20CHRWFQVg0GhDRSCKSEJA56bivQwJuhZzptD5mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529522;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=tJJp+wTEESYMnBdhPtsKMyvziahdjErDNrFw491aIX4=;
	b=1J21ZsyftUotWfVfhnlG++xB2/bDYcqpKp+QL/SxEOM45qDCBScyHbTp+2raCRrC00uF
	 ib71XrfB9vjAW8+JBHJhLSfPscRwzbvHcYDIJM394GDeJOObG0IpChwIUPkHgopJpUyRE
	 MEpq5+ut5SvxHBW7faNNKJpE9B/6wbXljX9g8OtPGEAfCL2VBkRFTHVFf0UUZwPKxedMv
	 18QweqjqgYN+YE5FgtGK4Y5Vd0fUWZVIyc3vfWkq0CdGom3CnJlmYsVzkj1rHamwx66Ng
	 hz4E2XAUjf6Q+vGJEtPsF2MhN+cnDP8yTQXX7YewNGNPubX0OO1D2zUeQb6npKHRrug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ACsCMCtx;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=U1jh94Lw;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208A4606A321;
	Tue, 24 Nov 2026 14:12:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 208A4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ACsCMCtx;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=U1jh94Lw
Date: Tue, 24 Nov 2026 15:11:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795529519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tJJp+wTEESYMnBdhPtsKMyvziahdjErDNrFw491aIX4=;
	b=ACsCMCtxOydODNn5FZROBsJD1ZDk07LKP9kdzEOaida/QFAuYeng1hDAK7TTcxgiQu/56l
	eGIkw46XpvPT1O8nQVID3N/cvkpcVK/xz8G76rbcRm6kdmOrmSABbic8dDmWhfyvRsjeCE
	M973P3vHcvsNPUTSe+++JxP1Sp2O0AesyPo/YpdolYKaWqGBwkutgkaM62eNKEB+xgN79m
	VFJH14YiTA/BwlFFqiWmTN/J2l1eGxxoeq9cASb2t/xVT3FpU1phy199YXYzW4ghEcyC+A
	4vxW3sqhce7M/81y1bvjGT/PgV3k4CHYPsd0Wu5guJw1+OEZy0FB4p2rY+ToYg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795529519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tJJp+wTEESYMnBdhPtsKMyvziahdjErDNrFw491aIX4=;
	b=U1jh94Lwb/orErcFqAZZ9OhCeCqf8cjJPw6eJuihJqMtlvt0qDn2Q54hf6chNoF4N3oqP7
	9cF7fldICb3bqkBw==
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
Message-ID: <20261124141157.Vf15QS4p@linutronix.de>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-2-d523e4d960d3@linutronix.de>
 <awU9KmFsbiyvbcOr@jlelli-thinkpadt14gen4.remote.csb>
 <20261124075332.nZysJRfS@linutronix.de>
 <awVfotZsGc8S_aB0@jlelli-thinkpadt14gen4.remote.csb>
 <20261124103507.4u5Sz_bU@linutronix.de>
 <awVvOGe-RwmLCqDv@jlelli-thinkpadt14gen4.remote.csb>
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
In-Reply-To: <awVvOGe-RwmLCqDv@jlelli-thinkpadt14gen4.remote.csb>

On 2026-11-24 12:04:24 [+0100], Juri Lelli wrote:
> On 24/11/26 11:35, Sebastian Andrzej Siewior wrote:
> ...
> 
> > We could also make the proc interface return -EINVAL on read/ write once
> > the sysfs was used. What about it?
> 
> Hummm, I'm not convinced. Whether old tools work would then depend on whether
> somebody wrote to sysfs since boot, which isn't visible anywhere: LTP's
> proc_sched_rt01 would fail again, just only sometimes?

LTP's proc_sched_rt01 (should) fail once you touch sysfs. But we would
have to make sure it is something != EINVAL or else it won't fail.

But yes, if you use the new knob, don't fallback to the old habits.

> Earlier you actually offered:
> 
> > I could look into making the sysfs values appear in proc, too.
> 
> This might be simpler. For !RT_GROUP_SCHED, procfs could become a view
> of the sysfs_dl_* state, with no second copy. sysctl_sched_rt_* would
> only be needed for RT_GROUP_SCHED (which is marked BROKEN anyway, and
> what we end up with depends on the HCBS discussion).

Yes. I would hope that once we have RT_GROUP_SCHED broken for a year, it
could be removed.
Anyway, if you think it makes it easier to have it mirrored both way,
let me look into it.

Sebastian
