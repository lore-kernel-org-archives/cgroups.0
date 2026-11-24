Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795535054;
	b=ipDqwf+pzWzf7fu/kGw8ybd6gkzCvR6zkB2HcYUjU51oD/1oFqFbXRqMfdub0KzfyzkX
	 xXJEV4mShY6MTUuvp3JWBw508YLa6MzskyT+3cf1SN63Hqdd8qjIJzGRQO59+55XuJtyJ
	 slXSo9tx/YPiYZlfBzskVRT3rgBzxcOe7FAVpvdcaE+7yCGM9BLwuEEm3F7CNL5n9Nu3x
	 AZhUmrjiIlwM4rPQaQXQc4SWVvOFU3NPfBaCKo5sFc8cVlBIj2jCirPaHF8xtix/tSn8/
	 ad3aBFVqswSRu86N4MbQGx+vJnwXPhbhiJW4YJ0N6RRfqQ7ytiNq2wNeRgNP3Qh9FQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535054;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8Wh2J5LCLeX/St1gCrsUVWC0JxeZaZODNNMq16jMKlM=;
	b=E1GaOKGDYbQCVoNFSDVzsMvnKPW07LstkUdfHdmUwrNt5oK5nj6ReBQBkLKx8BadlgzX
	 YBiJ47ozOv5iOKfMM0XD5C8LYeB1HbP52uvMdbDgrBnVrH75lBLL+aqbPsyA1AwPT9G0J
	 ijcMdNJjy34OwlVYbqSEdoKGo475/xDRimOtiCnLkUgQIrh/G0aPG4CuDWePBTseoO/8N
	 XAhfQ2NAv4GJ4qC5ms1YYyySlsSmPDbOjQHitXzhLIRpXDyMuwxN3RLtl4zXhArhiJfvq
	 IdCDxZkMf+o0Z+9IRCqWcJtBI/usDixyJi7aliJzPqmEqKtc7Iwk1U3cMGQvFdn0Mrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bi9WMrhW;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=PXqolqyV;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973F0606A31E
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 15:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 973F0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bi9WMrhW;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=PXqolqyV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795535052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8Wh2J5LCLeX/St1gCrsUVWC0JxeZaZODNNMq16jMKlM=;
	b=bi9WMrhW3hDIiKzsVOAI0Wo/L2dQTzfS2iJoWqFh6XwMHHTUCybZupgY3XF4N7DNq0oQEm
	79EEnCjuBRl5D3oOIjhISWgbViZpXTMHnA58Q9a16P8Q+HM23zroheYAjl5U9paUIwC6Fx
	945xzYAa11pXR3kPPO6WgdYI6M80Yts=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-78fcXzXlMdSaIsoVacXZTg-1; Tue, 24 Nov 2026 15:44:10 +0000
X-MC-Unique: 78fcXzXlMdSaIsoVacXZTg-1
X-Mimecast-MFC-AGG-ID: 78fcXzXlMdSaIsoVacXZTg_1795535047
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4ba01393800so30470785e9.1
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 07:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795535047; x=1796139847; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8Wh2J5LCLeX/St1gCrsUVWC0JxeZaZODNNMq16jMKlM=;
        b=PXqolqyVxLtS9Y3Kdn50iNcuOkpgeNkxuNF0RhvBc+fb5oLj22JDF1P+gRBUy3NqmL
         7FNFDdq/5Yzr1nxilngcU56x3j7/P6YoSQ1yZHUGrrY6ilJXPn9iXlR/5p48kjqY40c8
         h9BJ7/zs3qoxP3h1eGGErwV+PBrh5WfhsAV6W3RqXn6BE801z+NKWmixGToSYpSW6HJL
         Z1XJwaRHQC+EO7B0Qb8LDLzaEdfpM9saXXFiFAvcaqxuju2TnZdKHU6CrIa7MKDyM/wG
         y6F2tpPy21RSNO5U05ILiH0NExZTTuh7EAC2fIbPSeoRRXAd6FpyRcwfYbLdtzXiw/Et
         BaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795535047; x=1796139847;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Wh2J5LCLeX/St1gCrsUVWC0JxeZaZODNNMq16jMKlM=;
        b=rmc1jdoB1C0k7AObnD31nWt1OmqbczGpXeBa/dWKLyLYXcfkuJZeN3uGYwGEapXGvf
         Ft+aJtL07w2z8KNKBvXr9Hz8mB3TPvN4IpZ1+AqMcRE23tMzSD3s8GWCaC0me5F9pfOl
         fHy5ShV0ZLM0Y9m/ZwyiGt9xFHifRYLhoTGuO7CJioO+JmjypElSxkOND+cqcLxsHcDa
         FtG4fnp6L1lMM07yb8yekGqicCZ5e8SD2Ec6To61xaryCkWlcITCDVUB14+BMKEsZmvA
         tI7V+qLAFga6KTA2nL3rktWNOo1qCX28kO1/+JnOe98EyI4lHyaxz/83jySUEa1z04U/
         L4sg==
X-Forwarded-Encrypted: i=1; AL+hErGssh0ucq3XWJgkmJaG+hDSqv9lEl6ZqiqGffTOLE/4ofLI3sZGTpFskpfes2KDwaOpdG+TptGD@vger.kernel.org
X-Gm-Message-State: APuU4Z95ewA7/9e76+h+ZV2rsZk0CzrW7wlVjVsb3+tpNk41+PVV/o6f
	8LY/37wED0oGa9qeWdHeoo6ZH64nVuCfIR6cN/VMTqlUZnh+3TGHvZSUiUUxek75MKUPTKwYceV
	ZG/0ov83j6q2OuQjaxMHjGmayeUIFxLTZWp2EG7yzKxumV6y1lwyDK9sdLFM=
X-Gm-Gg: AZFdTZd6WN02NR6Syqg3GJOxv2o/OHvQfdwjMqjP47XH+GRqSWLiRdAo9W+Se+ZbLjs
	sdLZvpWE+yJTrUedt0YBrs0mHU7QXg7nSn+RzUMa2sYUkANX4PiqZMRKn9eyyxr6QvW5gJzuZS8
	pm/YWOiMtBsZc4n/Ppgw2X2cASHVwutNDbHOlFWcbSgWR1232fXE5JlrH2NG/9RhjFcCG1EnmM/
	t3755N+HifCDce2xqTI1f+AeaQduqgkRDoB0ni8y3Q39PAUGdguiqi1vMJgQycoyFTuXeWM9Aao
	WFDxf6PzQK+er4iknTUPtq7MlgK1c+8aRyT3P70JmLwO5cEM1ZhnoNl+ebUBn585hAybbPIooSs
	Qh6le/G6/0QB0moXuPROKf/hcyXuKf6v5d/7N/Nu4bGWH6w4Gs1b6V9GNZdi96SEYQaJMeeZW/z
	9578E=
X-Received: by 2002:a05:600c:3555:b0:4a1:9663:7639 with SMTP id 5b1f17b1804b1-4bb8882907fmr313576255e9.34.1795535047100;
        Tue, 24 Nov 2026 07:44:07 -0800 (PST)
X-Received: by 2002:a05:600c:3555:b0:4a1:9663:7639 with SMTP id 5b1f17b1804b1-4bb8882907fmr313575655e9.34.1795535046648;
        Tue, 24 Nov 2026 07:44:06 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb90660cb4sm381716475e9.2.2026.11.24.07.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 07:44:06 -0800 (PST)
Date: Tue, 24 Nov 2026 16:44:03 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Phil Auld <pauld@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
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
Subject: Re: [PATCH v4 3/6] sched: Add sysfs files for the per-CPU
 fair_server knobs
Message-ID: <awWww6oWUrvRDjOV@jlelli-thinkpadt14gen4.remote.csb>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-3-d523e4d960d3@linutronix.de>
 <awVDG-ABOvj7zGRg@jlelli-thinkpadt14gen4.remote.csb>
 <20261124080833.0I9HFgtf@linutronix.de>
 <awVgALGuilf2FMsT@jlelli-thinkpadt14gen4.remote.csb>
 <20261124151955.GA1855213@pauld.westford.csb>
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
In-Reply-To: <20261124151955.GA1855213@pauld.westford.csb>

On 24/11/26 10:19, Phil Auld wrote:
> On Tue, Nov 24, 2026 at 10:59:28AM +0100 Juri Lelli wrote:
> > On 24/11/26 09:08, Sebastian Andrzej Siewior wrote:
> > > On 2026-11-24 08:56:11 [+0100], Juri Lelli wrote:
> > > > Hello,
> > > > 
> > > > On 23/11/26 14:41, Sebastian Andrzej Siewior wrote:
> > > > > The fair_server exposes the runtime and period knobs per-CPU in the
> > > > > debugfs folder. The debugfs interface is not a stable ABI.
> > > > > Make the /sys/kernel/debug/sched/fair_server/cpu*/{period|runtime} knobs
> > > > > available as /sys/kernel/sched/cpuX/{fair_server_period|fair_server_runtime}.
> > > > > 
> > > > > It adds a struct kobject to the rq and exposes only those two. The
> > > > > per-runqueue folder is named `cpu' rather than `rq' since it might be
> > > > > more intuitive to the user than `rq' or `runqueue'.
> > > > > 
> > > > > The set logic is pulled from the debugfs folder but it is still shared.
> > > > > That debugfs logic could be removed (after providing the same for
> > > > > ext-server) or symlinked for a while.
> > > > 
> > > > ...
> > > > 
> > > > > +static ssize_t rq_fair_server_runtime_show(struct kobject *kobj, struct kobj_attribute *attr,
> > > > > +					   char *buf)
> > > > > +{
> > > > > +	struct rq *rq = kobj_to_rq(kobj);
> > > > > +	struct sched_dl_entity *dl_se;
> > > > > +
> > > > > +	dl_se = &rq->fair_server;
> > > > > +
> > > > > +	return sysfs_emit(buf, "%llu\n", dl_se->dl_runtime);
> > > > > +}
> > > > 
> > > > Since these files are new and meant to replace debugfs, how about using
> > > > ns everywhere (you partly commented about it in the cover letter), as
> > > > sched_attr and the dl_server parameters already do, with the unit in the
> > > > name? I.e. fair_server_{runtime,period}_ns here and
> > > > dl_{runtime,period}_ns in 2/6, with only the procfs compatibility path
> > > > converting from us. Right now /sys/kernel/sched/ has dl_*_us in us next
> > > > to cpuX/fair_server_* in ns without a suffix.
> > > 
> > > I can do both in ns (or us depending what is easier/ more useful). Let
> > > me update that then.
> > 
> > Mind that it would be nice to hear from others in this thread before I
> > make you do changes that others might not agree with. :)
> >
> 
> I did notice the lack of units on the fair files.  I'd certainly go along
> with adding the _ns to those at least. I don't have a strong preference
> about them both being the same unit if they are properly named.
> 
> It probably makes sense but I leave it to people who know dl better to
> say if sub-us configuration makes sense.

On second thought, not in practice. DEADLINE rejects runtimes below
1024ns and periods (of tasks and dl-servers) below 100us; above that ns
values are taken as is, but enforcement (tick, or hrtick plus overheads)
isn't precise enough (today, at least) for sub-us differences to matter.

So it's mostly about consistency. For the fair_server files ns keeps
the values unchanged for whoever migrates from the debugfs ones, and
matches sched_attr. For dl_{runtime,period} us would match the procfs
files and the sched_deadline_period_{min,max}_us sysctls, while ns
would give a single unit under /sys/kernel/sched/. I'd lean towards ns
everywhere, but either works for me as long as the unit is in the name
(as you say).

