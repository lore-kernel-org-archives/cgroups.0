Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404253;
	b=AIckC/+1tghZYJJzTNtUAnuvSVspi8lovAYamPogwIiu1AIiq81FMHuBH2oqz+u1XYBw
	 0d5pOPEtToSE4ZTfZ8obomDURCT20uMGUax2ZwgXggn1oueG2LD6F10WwIL7Ed6rCmdj7
	 j+fP2337k0YJ75Csb3sJV7AHaQtth6ysp2AiZeBvaJdoDc5zp9TPNtZ08ZWebdLA5+t5L
	 6yZoTlAE9Sfu7mavA3Sy+XF6Zf/Si/PqwOCB4ENxHqDj9lI+e5nBrhJYXaXeZr1pT3Tce
	 8cxG4cdLFdmyrCkSbSUlPtL44jJ6/W2bpZ4snCMg3iVPHxMJFAjmaWbioAsLpmYbUxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404253;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=v/XnkVND7TsTxq/odAIiRN0hPdLg6CJMukesjiTzxG0=;
	b=oBc43BA8CRvcb+zsP2i6P/jcVXZYgkIvcdUI7x03eqpb31mO0TtcXVV31Jmqs8CWf6x6
	 zf9clETbnOtXMpdgLTVVIrv96nBUFr/CGZdhCzkK7PihS2YdJId9tAFW3CDOhkMIHCvkk
	 9ym/FbnYbpkzu8c7jNppggdo71dxuDrTNlCsBf4nsQHFGfi2ni/JQ/H34H1Qt9x2cCYj/
	 Z7N0sMdL/xJNacY2iZJmQL8Um7KvYBWOCFilsK2IPIXSVQdORBgeGY0qchcUqTzgya6Y/
	 YNHwAlD0J0bHb1d+V7AvXL/D3rATEJlQ5QDH19lJjR6BdoPJoAhoUiJAl28N3IFs/Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=VDRY8Wi5;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=nRWpizR8;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30E4606A324;
	Wed, 11 Nov 2026 13:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A30E4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=VDRY8Wi5;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=nRWpizR8
Date: Wed, 11 Nov 2026 14:37:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794404249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v/XnkVND7TsTxq/odAIiRN0hPdLg6CJMukesjiTzxG0=;
	b=VDRY8Wi5Fq1KdkSK3JL+gYw/U7wHX8s34x4I28496P/84nz5jFPEWovH4HvFRE4K431Yqb
	WUhJ18r+bUzDm3YgLQCzIqkLflkzv918A7op8hiiE4fJuIW+OcCZP1sEE+bGScVYl9GlIS
	K8eQoF5O02skIuiGebVG1imDL/awdmxv/Atg/FilfE8Y/63sGQ9MjGrhB2VJHgi3V4n41D
	D4l/4yLspxcxG6uSA2PT88EOLlCo2HeObO6smMmFzmMgYvr1GNdu2mspt6T3abx8jgszn4
	WbZUyA9AWCfLlCmTwpsjpS4m/AYArEHVk9Eh5rjmMQxHQcRReoYgVV4jFbRu3Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794404249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v/XnkVND7TsTxq/odAIiRN0hPdLg6CJMukesjiTzxG0=;
	b=nRWpizR8cBGGwsexVShuXZ3RUsYyFkRJXV0Wkw3czjei+tSbqeK4CWUpLZKRgxJfk6c9rk
	w1G639mgNacYXVDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rcu@vger.kernel.org, linux-doc@vger.kernel.org,
	John Ogness <john.ogness@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
	Qais Yousef <qyousef@layalina.io>
Subject: Re: [PATCH v2 1/7] sched: Mark RT_GROUP_SCHED broken
Message-ID: <20261111133728.6RfqZWwx@linutronix.de>
References: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
 <20261110-sched_dl-v2-1-cc9399f7aeb1@linutronix.de>
 <1927ace7-86f4-463e-bdda-b3a5bc300eb2@infradead.org>
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
In-Reply-To: <1927ace7-86f4-463e-bdda-b3a5bc300eb2@infradead.org>

On 2026-11-10 09:42:00 [-0800], Randy Dunlap wrote:
> > --- a/Documentation/scheduler/sched-rt-group.rst
> > +++ b/Documentation/scheduler/sched-rt-group.rst
> > @@ -18,6 +18,11 @@ Real-Time group scheduling
> >  0. WARNING
> >  ==========
> >  
> > + This document applies to RT group scheduling provided by CONFIG_RT_GROUP_SCHED.
> > + If you don't use, schedule real-time tasks and experience throttling issues
> 
> -ENOPARSE.  Is that:
>     If you don't use or schedule real-time tasks and experience throttling issues,
> 
> 
> 
> > + please look into Documentation/scheduler/sched-deadline.rst and there for the
> 
>                                                                 for the
> 
> > + fair_server.

Thank you. I have now:

  If you don't use RT-group scheduling, schedule real-time tasks and experience
  throttling issues please look into Documentation/scheduler/sched-deadline.rst
  for the fair_server.

Sebastian
