Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514282;
	b=nmUQ5hJ6R6g8LJHrfvdJfI+pw5QXa//oJG5kUsI1DYA83LADpOWN7WhMnwN0aFVAnDqq
	 Bye0PJdyCcUvyS2wcNrmh0AGStyKJ1Z3TLKjsVlojjvj33iaXxDEKTvIwYgkVv0psUyJA
	 tunB64/mslhaEV6WBGfPM1jNui+tOpdn1vieQA4TWhayiN5hjWRWrwfLNco+DmstQA1UJ
	 LEBTBfsACYqibZQVl+Y1knCVTGjgZKb0oF4Q5Mdq5OoquD65PVAFpIi4EUO8supLaI4td
	 2wOHqbsqhJeKT+zB6GwsW58OZAyJH/REQsgnVUptEDjHhD05AhNCEs/0J/zKilPQUrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514282;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=O7+zzAT/4xNi4DFU6pAU7iVms8gCVVFUE+GIPCzfB70=;
	b=ADS9prIMxAc/eZQBoWagqs4VxAi+JyvGEl6hxY+okl5bLFi6K/92VI+Y8QRjvMMImx7O
	 SQ/TK4DwXJ/diFz/z28dHyVxq/5v5ynSMEpQMQ5gC+6VCDOrtrdWPN5ChonJjZBQ2DAyX
	 VRVHUbDszTZRkkmEsubD6tmTMAEK40yVTkxfp0ZuubVLkO58G0P1k9mAZ6PsW2KyadtFr
	 mlbCDpn4hUC8bHlNS76bqOu13CcdwrhtDMCcqxOTdOcbH0unfupkUpYQSwl+ychipT70K
	 Mu3R9adc23Q5rNH0w++wm33KfY/YHr7HedNPB9TPGsmLYDJ+Exi4+jj+S0mYLXEIkhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MxPWA0Q9;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=pnfssEWE;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2887D606A32D
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 09:58:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2887D606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MxPWA0Q9;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=pnfssEWE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795514281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O7+zzAT/4xNi4DFU6pAU7iVms8gCVVFUE+GIPCzfB70=;
	b=MxPWA0Q9SwYqIAPgyCGt4m+ljZ/BXaFkaHz8o8jxhh+kIlIqPi5A0P8fbx9AIy8O8i+ru0
	d34N45aOy5bVYjKR1hNCQy5/YPRWYuANATyhfBWndyzQ2A71ClqHswYMiUOxZxs3rxEEsg
	XvNGv918LSaR8kM1t3MSZINlNPuBspc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-QTaw9WiaMA6-XF5IcG0lIQ-1; Tue, 24 Nov 2026 09:57:59 +0000
X-MC-Unique: QTaw9WiaMA6-XF5IcG0lIQ-1
X-Mimecast-MFC-AGG-ID: QTaw9WiaMA6-XF5IcG0lIQ_1795514278
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4901562b819so3126137f8f.3
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 01:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795514278; x=1796119078; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O7+zzAT/4xNi4DFU6pAU7iVms8gCVVFUE+GIPCzfB70=;
        b=pnfssEWEpZCgwzgeD54MxECzqUXeEltWQ5WLO9R/ICS3R3mTXVEtiximiqpXXjjdEq
         DRGo4AdE/KKU6TWcL5d1GzuWIILUOZkPUVvD9WwtSFWU9QwSAtpTDubLU8xNs9oAf4Gh
         4GEm3+U/sl4DFhkT9Ylh8mkMkWORyxl8043aPCyNjp3pE+12zS2OVIDorWx6awltCJmL
         Y+E8ELAna8eF1otXS0WeYkWbi4UNjhVvrxo5Z6CANDqhNmXOoKhHmjb9Y/5mzLMfDSto
         Ey6f5iCp565xW7Ew+adKSGo9p0vdfJz3ZfPZL0ZF1RQCDD7kYTon66YLHAqkO8LxCBZ7
         Mfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795514278; x=1796119078;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O7+zzAT/4xNi4DFU6pAU7iVms8gCVVFUE+GIPCzfB70=;
        b=myqlrG2Fmcw3wME58eRD9slHEeey1rSjorDGSvnh+W68piI548B9SFNUbeD8Y71EWc
         t+JPnWn/iGIirHd3wbDDX1UXFc4O2HtEIPXNv43loryCjKWnhp2/uDeknMHsa6r3vI+O
         ephp7549wNjDB51BJRIOKu1+dLQ2HsBsKRjaoau0YpSRp6/x7ItrQ8+AJaPfARN1DK+k
         8VXjrSObpP5zfDUY65bIqW5unDsr7kGytZkmMK1Mjtm3WUGpDmC04dbCmnlvPBoFaR0B
         SFyXQhVR0O0zcZFYpe1sAIWGIqNrQFbUPtdZj/LedRyceiFfWcDLH/RJdeKwojdrFC7q
         N6og==
X-Forwarded-Encrypted: i=1; AL+hErFYBkz1PmZdIl7T1yKxHZtzkudhhbzSVBsSvuPzckqJ16IjRr3cdi74KPpBU24+mw6gvYzzipI2@vger.kernel.org
X-Gm-Message-State: APuU4Z/fss0ziT4cPnU51eA+/JDJUAGgSeRoIeLO396+hsdv6LB90LEe
	ETyyK9YMPYG1r8nYt4jvqVWF7FitTwm+XqldErhh3kZIamIC+HUKSESWdhpW/1M+t9RTg5erGAh
	IEWgaRlHvHBU0iU1HIniBpaA+nBa5UvTlfvjryWyvQuh/kG/W5iLcD3UGtc8=
X-Gm-Gg: AZFdTZf5KmdSG2SUiQ2PxRdv1Kfdmcw/IW3QNMl7LKnEVAWUN1VJ//jy7sUrDxxErEI
	FSTJ2zB6wIpA+3N+Ac9zzyDfkY325IpexOMMdl1TIJxyPgVXr4cRoZxoT5NgrXACy33PzLVValh
	+jnV8U0p275AIZYOH7PICkPRWf0yCGpWmVWl59sDJMRDjVPXireasQdHbI43/vV38HYDffcnzHZ
	aFFJO2BMdNiV6zqa7QdnAfWsAWyvNJQJRGusy7yuX1i3d3HSdDG6GKf5RAtjQJEhKWTSDF9T8uL
	g5GFvIRxmD3kTMBwbUKjKGmO4IRC450jw6o1TjHfh8rUxOyhr6up7pN3chIQWqCuSiZ+RFuISfb
	lIOnMf2XltWrKKRmrJ6ZxJ47GgbdrfqgTwK2+0rtnshMcIhcjK5KlMMWX1QGPy7qM2Qs8m99aq1
	Gmehs=
X-Received: by 2002:a05:6000:2887:b0:4b3:e5d7:215a with SMTP id ffacd0b85a97d-4b3e5d72317mr9981406f8f.24.1795514278133;
        Tue, 24 Nov 2026 01:57:58 -0800 (PST)
X-Received: by 2002:a05:6000:2887:b0:4b3:e5d7:215a with SMTP id ffacd0b85a97d-4b3e5d72317mr9981344f8f.24.1795514277737;
        Tue, 24 Nov 2026 01:57:57 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6ae2dcf9sm26865584f8f.32.2026.11.24.01.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 01:57:57 -0800 (PST)
Date: Tue, 24 Nov 2026 10:57:54 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>,
	John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v4 2/6] sched: Move DL's admission control to sysfs
Message-ID: <awVfotZsGc8S_aB0@jlelli-thinkpadt14gen4.remote.csb>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-2-d523e4d960d3@linutronix.de>
 <awU9KmFsbiyvbcOr@jlelli-thinkpadt14gen4.remote.csb>
 <20261124075332.nZysJRfS@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124075332.nZysJRfS@linutronix.de>

On 24/11/26 08:53, Sebastian Andrzej Siewior wrote:
> On 2026-11-24 08:30:50 [+0100], Juri Lelli wrote:
> > Hello,
> 
> Hi,
> 
> > On 23/11/26 14:41, Sebastian Andrzej Siewior wrote:
> > 
> > ...
> > 
> > > @@ -2882,26 +2881,18 @@ static int sched_rt_handler(const struct ctl_table *table, int write, void *buff
> > >  		if (ret)
> > >  			goto undo;
> > >  
> > > -		ret = sched_dl_global_validate();
> > > +		ret = sched_dl_try_boundary(sysctl_sched_rt_runtime,
> > > +					    sysctl_sched_rt_period);
> > >  		if (ret)
> > >  			goto undo;
> > > -
> > > -		sched_dl_do_global();
> > 
> > Nothing updates sysctl_sched_rt_{period,runtime} when the sysfs files
> > are written, but this always passes both, so a procfs write of one knob
> > resets the other to its stale sysctl value? E.g. write 2000000 to
> > dl_period_us, then -1 to sched_rt_runtime_us: admission control is
> > disabled as expected, but sysctl_sched_rt_period is still 1000000 and
> > the period is back to 1s.
> 
> You want this working both ways?

Want is definitely too strong of a word. :)

> I assumed you use the proc interface because you don't know better. The
> warning makes you aware that the throttling knobs and DL knobs moved to
> sysfs. The DL bits are mirror to the sysfs interface in case you ignore
> the warning and keep using proc.
> If you move to using sysfs then everything is fine. From here, going
> back to proc looks odd.

Odd indeed, but I wondered if it might happen that a sysadmin configures
things properly using the new interface and some time later, say, an old
application that hasn't switched yet to the new interface resets/tweaks
using the old interface?

