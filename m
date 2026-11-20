Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188986;
	b=0td//rXV5deJ9gMrqOWsbvlV65oWMHXbqgm0/bfI+wuCa64WlBavknmBLIfVl62BCQ0f
	 6uuZE66oWwX5wU1aqoFIU+Aj9EGSlbazd+4CES0DnbOn3/9rdQtaNys997hcfU0GTpbG6
	 uCoCuRotsmoEWcgiIf2mDi1KTiHgSwZvAMsx9txHZDEyFU0NsOuDyRHN7BvMp3nMVvvPV
	 flW8tYNzT/NQD4WM3UTc2Qeu+2Z/EUzrGQe0SXfjOfG/UtoXH5m/6A0cqQtvg0lxc2Pvz
	 yaJpLm6qIMQFnDoD8IJsOise+oOqqeemohcFT30youAzniHSXP27t41xxu0cBcNRPNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188986;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=0v8j2lBvxHjXaH9n0pHRtDOnUfQzBe+8Nl6XwJcdi84=;
	b=H14G0SkIhUvbsBzMJli9JcIFiXW7ElX0qsfVLdOwpDa8EPm6cIMc9oH4JApoldpzr6cl
	 pRY/TTLe1eqKF8ztJm15XArlQUd80rc2PgbPM58XTvZnurMYwMKeKDa/oNnGPzpmr8sJ2
	 lll/OKtYzS6BxN2YD8m/0/bKVnoNTt0RE5kx0gvufIZfGwhMp1qyWKlxG92LQiUi7nvyt
	 wEJZuShDTSaSToptC6YaDEv43MR9nSZKpkceYVlizwnlwedfhr4nwI6e9JRsLPSDceNsr
	 /vnC/mgvvdZqZupajBhOU3xGui0rgXzpGpV41NZVzpdLvI2CZQgys5mdakjtN3QvHLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ocKZwuHr;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b="/3UWy6bd";
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F7A606A336;
	Fri, 20 Nov 2026 15:36:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90F7A606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ocKZwuHr;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=/3UWy6bd
Date: Fri, 20 Nov 2026 16:36:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795188982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v8j2lBvxHjXaH9n0pHRtDOnUfQzBe+8Nl6XwJcdi84=;
	b=ocKZwuHrzuSS5ct2BH9+QHW61CP+dOVKPTj6OnEL5JRcOuENkj0NL0skilIvwRsvY8R/4d
	CLIEdNZEGWZ2+GWNRnttwKPWCQR99CItKiWt7sPu3FVy6wjwmSwNrGuA4vnLpx8j1aV4KN
	oucdLvD2xawYd7/siHeOJkUWKmh9rEdf18jCqNzAbDKDhNZxIeRPBGBfXmtckHgfJaDYM3
	HyHUcuzXU18kwelECl+BVuwFH5XSoHKvLoAwDSqQePK4qcrHGtHd1lh/ALmZSc+ILWYJSt
	G0R9OpDpF46Mpq0CKPoZ+vSMMP4Bfw80YQ2jR05qhh7pPFKC1Uw9FCHQ11/rLA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795188982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v8j2lBvxHjXaH9n0pHRtDOnUfQzBe+8Nl6XwJcdi84=;
	b=/3UWy6bdseM8Bvl3FVKoUU8HTCV8bfiOwegV1SE7IS2/xYsJtTfC9IiB5w7SmqUznWC2HV
	P5ol4oPM0GV6hXDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: kernel test robot <yi1.lai@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	aubrey.li@linux.intel.com, yu.c.chen@intel.com, ltp@lists.linux.it,
	cgroups@vger.kernel.org, rcu@vger.kernel.org,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH v3 6/8] sched: Limit sysctl sched_rt_{period|runtime}_us
 to RT_GROUP_SCHED
Message-ID: <20261120153619.gkOojPT4@linutronix.de>
References: <20261113-sched_dl-v3-6-a76ffa1cdeee@linutronix.de>
 <202611192004.cca8bf73-lkp@intel.com>
 <20261119142348.MkPQ2Fby@linutronix.de>
 <awBiDzEvUch_5ZJn@jlelli-thinkpadt14gen4.remote.csb>
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
In-Reply-To: <awBiDzEvUch_5ZJn@jlelli-thinkpadt14gen4.remote.csb>

On 2026-11-20 16:06:55 [+0100], Juri Lelli wrote:
> Hello,
Hi,

> I agree on the RT throttling part. Before this series, writing to them
> does serve a purpose, though. 5/8 moves that functionality to sysfs,
> which leaves the files without a purpose, and 6/8 then removes them. So
> existing users don't lose a useless knob; they lose the working one,
> which has moved somewhere else. LTP is not the only one that will
> notice, I'm afraid.
> 
> This is what I meant with "yes and no" in the RFC thread: we need an
> interface for admission control, and I wasn't sure how much breakage
> moving it would cause. Now we have a first data point. :)
> 
> You suggested yourself back then to keep the files and make them apply
> to DL only. I think that's something like:
> 
>  - keep sched_rt_{period,runtime}_us for !RT_GROUP_SCHED, backed by the
>    same code as the new dl_{period,runtime}_us (sched_dl_try_boundary()),
>    keeping the current validation semantics (the LTP test checks the
>    EINVAL cases, and 0 is a valid runtime today)
>  - pr_warn_once() on write saying they only control DEADLINE admission
>    control and that RT throttling is handled by the fair_server,
>    pointing to where its knobs are
>  - fix the documentation as you are doing already
> 
> That way nobody gets surprised anymore, which was your point, and we
> don't break anyone? We can still discuss deprecating the procfs names
> later, once the new interface has been around for a while maybe?

Doesn't sound bad. Let me respin it with these changes.
Thanks.

> Thanks,
> Juri

Sebastian
