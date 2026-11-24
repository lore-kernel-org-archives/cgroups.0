Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506817;
	b=tsHzUJxNoOvoeOdDaENWUUT/hHCTm2to6vzv87/i4QTeYLmaoR0Sgu4pyZyjyaW4UVyO
	 gPkxhe528ZvNyg497iTQX1s0rjcwNAoi58KaKhbBH90z2FU1YYMsGWzJsC8rk55oyrNRv
	 lbOqjqN6gMp8m+at9htnpdGxBdXdtVvOKKsKjqC3qMgC1BedCbIXteHiwQk9yCRtUCil2
	 Zc+5T/rdyV8AgtDLWrJXHJfYckJ7lAdVTTZDWcbHFVLEV+W+PzbMSaybaySvgOCJso9SK
	 G3hvey4Xr2jAvY4lf3RRuqVGS/3I/L7ms4Eyy/d/GTEYpI93sVAqC48epuWATxe71Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506817;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=jAesKLv4/3xomZvEVrTSXRWApRf79/r+9dEkzyHqbc8=;
	b=ds314TH9PC4qzljLWJ2SuM52BByJ/AXWH+Zz2FOtP2/QTJW6ZgNw042gXgsyfkGVwfle
	 pg08I2eca+aAKhPS9Gu/dEsuuHqiUMvCJetIHlrJkC0tNVX4xifaLm9905rUbbRugsUrL
	 jAAxKLByoBRpkkWonrEoWpc+T1aZoPb5Ox1Ib6+IvQ1NBDT1ZS1MB8gdyT4ykbzWGY7BQ
	 gceYSFHDDqa1dcswlObOsfMI7w2l4ye5IDGyLIF3LfPY9oWgcRjG0/ZxECcuyQmvSAjNG
	 BYtlGy36OnwhOlKQ8YUywOeZiMAhHqeBoZKXOZN++geqO/JzRRabPbBnUhtI+J0fi2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=s7ROgEgX;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=gqvAJSAA;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD524606A31E;
	Tue, 24 Nov 2026 07:53:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD524606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=s7ROgEgX;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=gqvAJSAA
Date: Tue, 24 Nov 2026 08:53:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795506814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jAesKLv4/3xomZvEVrTSXRWApRf79/r+9dEkzyHqbc8=;
	b=s7ROgEgXIPMe9DcgbKO3JL1/Igr6ZFdIKvQ5iv/dhAU91+7NoSBH7ywM+du3vQn5NESEJE
	Q+c1gG8J7Mtetq8ez5LinVvU6QYmFBu2YwRu5Pks2OwNXmXfh/lsqiZmWDZnzeMNno3pJb
	/PuWj6X4ccyCq5G+VH8K2Q5Oepc3uONfWxMDo4Y6SqVgwoh10mF0wyMovEYPBE0zeJastj
	fAkvxJltZsYfOnjAjvZTVS82WRmU76cw/zVn5xwrUdl3BjVjTdSwcC6Q3ygl5FNTwPkdl5
	gRAOhdQE/BzNajIkZmduN3usLJOS8UOhjpF1P7+FsyHbR+hDGsd5ybeKBfaNIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795506814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jAesKLv4/3xomZvEVrTSXRWApRf79/r+9dEkzyHqbc8=;
	b=gqvAJSAAITUd+T/jmFY6dLV3g853e391FpyE8jcBNEAFwChs5tedhkvkTWvm2DYegC9VQa
	Fkdq2JcGKn6RPWAw==
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
Message-ID: <20261124075332.nZysJRfS@linutronix.de>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-2-d523e4d960d3@linutronix.de>
 <awU9KmFsbiyvbcOr@jlelli-thinkpadt14gen4.remote.csb>
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
In-Reply-To: <awU9KmFsbiyvbcOr@jlelli-thinkpadt14gen4.remote.csb>

On 2026-11-24 08:30:50 [+0100], Juri Lelli wrote:
> Hello,

Hi,

> On 23/11/26 14:41, Sebastian Andrzej Siewior wrote:
> 
> ...
> 
> > @@ -2882,26 +2881,18 @@ static int sched_rt_handler(const struct ctl_table *table, int write, void *buff
> >  		if (ret)
> >  			goto undo;
> >  
> > -		ret = sched_dl_global_validate();
> > +		ret = sched_dl_try_boundary(sysctl_sched_rt_runtime,
> > +					    sysctl_sched_rt_period);
> >  		if (ret)
> >  			goto undo;
> > -
> > -		sched_dl_do_global();
> 
> Nothing updates sysctl_sched_rt_{period,runtime} when the sysfs files
> are written, but this always passes both, so a procfs write of one knob
> resets the other to its stale sysctl value? E.g. write 2000000 to
> dl_period_us, then -1 to sched_rt_runtime_us: admission control is
> disabled as expected, but sysctl_sched_rt_period is still 1000000 and
> the period is back to 1s.

You want this working both ways?
I assumed you use the proc interface because you don't know better. The
warning makes you aware that the throttling knobs and DL knobs moved to
sysfs. The DL bits are mirror to the sysfs interface in case you ignore
the warning and keep using proc.
If you move to using sysfs then everything is fine. From here, going
back to proc looks odd.
I could look into making the sysfs values appear in proc, too.

> Thanks,
> Juri

Sebastian
