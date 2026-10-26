Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793001950;
	b=ScEkWzcY8OymHCcTY7VsG7M/vtDuFsx3DYUArVB3bbzbSYBY+X+hvtCqsST+EKmxEezz
	 Prhk7EEFg/2jELVj9WJsXoRB5Ulw8HWRf45Z8Qs6RThp/nw3or+7VzbaY11+qr1MhyqGC
	 NhCIpW/4rDM9GIJn3UsB+QkcIGNbLXwBPjUeQfgj9fxWHSwMxQZwxx4IjtwWFB+kFKF+x
	 mAsA4H3lggCWdHONYoAzqaGsRyz3DvKjrIuw4zssLjLGusTL5IlvC4rNh0SZCgRyb2gtt
	 LJ4D2jUV4IUFTW9UryUI8BeHoJXWsWIT9oghJxXvHH3kd+eBVmYDSjt+jaw6aq6SajQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793001950;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=D242ShT8h8RdqZ5L8WmZvCimBf9zTP6sn6+Cdrpwgt0=;
	b=ZTpYiXfSzLR0PH/0acIoNQ9bG4NLqLvgbP3pWEc3Ujq09f9Me34F10SAmfBXF/0fto40
	 6cfvzS8l74gAOI2reAa9rFJr3ERI57AMd8y7UihMO8fTNuLuzaQZmjdbCVkcRa6/0XBrH
	 5OaYYMsQhoQlsVQjB6ttMtKZZ7YQ+wcEZvKM2rKc48iI85traP9Yxx0u+ctL4Z8D50tlU
	 vEiscb94QpqrKDSlnGHW9HwrTnpxh+gIP6EXVupH3bnRSlxHn8gaUfh2M5I4VkPYr1gTL
	 r8kaeRbM7whUWxB3jObK465sIu02o4ai6V98EdDMOpAcVRXjRk8R5+B1ufhVBqyJpyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QdBTHeIk;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=pZn0c9x1;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1E9606A31F
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 08:05:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE1E9606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QdBTHeIk;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=pZn0c9x1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793001949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D242ShT8h8RdqZ5L8WmZvCimBf9zTP6sn6+Cdrpwgt0=;
	b=QdBTHeIkuf0gYe59x3g8uIlJRLV4Lj/15O4MyCWvAKRFcXorcEH70n5I4P0xnb0xieFYAc
	65SGAcbUsJpq4a/lkAf5gKP4RrjO4JVsqEVWjCUSmSpz954TfZ3bW+Wt+gdYd7svx7+V9e
	v+z8rMjVzoYdiZSgtVzvWrBfDPAo6eA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-bghAtvjyO9eVW-HlCXx8yQ-1; Mon, 26 Oct 2026 04:05:46 -0400
X-MC-Unique: bghAtvjyO9eVW-HlCXx8yQ-1
X-Mimecast-MFC-AGG-ID: bghAtvjyO9eVW-HlCXx8yQ_1793001946
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a4654add56so12777195e9.2
        for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 01:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793001946; x=1793606746; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D242ShT8h8RdqZ5L8WmZvCimBf9zTP6sn6+Cdrpwgt0=;
        b=pZn0c9x19i2Jzn6WpHDEv0w6vcP24mrCUqX9G42FaZKw5gDo0b4v39pFtLiJc4Wj6/
         eZPEDQGqyDX0JyhVROS9mUT9Qp1Y3uF4HVZMNqJVQZ1e2KOrCdXszX70uALz0fiS45dj
         lfUiSxWltXlNPLLKG5W/nPvzAOk9S/pi0DnoAAb2ddZuCRGBucr5ub9Q1BZ7atbrjTEv
         rpEikrtesRUQE69BDE0oESQxbHehoI4eFCWS3M8zdx95ypbYZtQxnKG05dpPotoUct4O
         m6gJh+od3OljhD74IEm4gyOxP3OUBTVMv85bqQ/X9jqJFr4AoOtHEQpIz1zlkzTVMskp
         UHaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793001946; x=1793606746;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=D242ShT8h8RdqZ5L8WmZvCimBf9zTP6sn6+Cdrpwgt0=;
        b=OYKB0CbDH32oJPpq+RHf3WnEnF4m2mFgN85yaMW5ksKnywyMa1OLsrdG+Slbxs6Gg4
         kufuE7qOK9wxj6hbDhuCOi1h/5PlcXNA5q8jzg5Nv1sep2ffkAtjaxPz96M8F8Ce56ah
         ZGceGgHua2FyJPP0+tpsS7D5vt12NC6V7vvV9UzNV3qPP0bIAbF3iKi9w/wZXPHd9hlA
         V/+IieEVAmTssdu0Tcse1aPkFXifY+lUDA+dLt6wNikh9tq2tTKoP8ur/QHOaezjVxic
         EYbWqe4zXnjjh2wMQDcZDLHx1wH7cy9jBxlaMbNSfrzVE9/h2Pu/3XvPMRB7baWXuNEO
         zuMg==
X-Forwarded-Encrypted: i=1; AKwUvBzT2hnrOx7BZPclV2L9Zaimo46SODRCdIxEZs4ExqFd+y0cgg3NqKzFsASXUS/1enbvBMs6DyjL@vger.kernel.org
X-Gm-Message-State: AFq9FYITvtl8V+3JkuWdGUROCNokEoKoskXLm9vy6bZPsaIUbrfiE/zn
	jHCITga0n5c+NsHC6tidbnO/o2METU1fykR0BUCgvUimunssCpluZknBe3rvCt+cnFfj9OEAjxY
	YcsSa/euEMyv9UH3DOaiBM0poPB4MZJCDCZRFLYnlG1on3n2VtW5d3I04+CA=
X-Gm-Gg: AYBFou3kQE1h+PE1a+ib0MLeJwtOoxvzDDPbTaBbkncqc13HQTMvXSIIKCwJs6WNDdZ
	MHWiHP7lVnUCAd745kY9MBUjwg6P0bxETAHlPvnwRX2uTgVS3jnCvKbM3jZv2s93SX6RccDaZk/
	PtStgyJOiqZo+/2Yf7e66xrfU4IcRY07UEnaD1sD0/zehYUojI/6E5Ibszmc8sg6bczkdlmjcN/
	mPMZj52Uo8b2QstpEwPkQWXyrtOzhgSsYjxjC4EtklE0D2mgLt0l8V4GQ2iHvl4Ar8GKi3wSgfI
	28h1XP4/cya16sNUbly5bIArrGaQWoQ1Gz6Sc4BFMSHK9f81SeIIMFdrEMHHqzmc2Kxc/++prku
	YCP/UGdx/EJAy6hN2rzE09lWKmT4XOMg=
X-Received: by 2002:a05:600c:190b:b0:4a5:cfc:1e95 with SMTP id 5b1f17b1804b1-4a50d0b6418mr72058025e9.33.1793001945647;
        Mon, 26 Oct 2026 01:05:45 -0700 (PDT)
X-Received: by 2002:a05:600c:190b:b0:4a5:cfc:1e95 with SMTP id 5b1f17b1804b1-4a50d0b6418mr72057595e9.33.1793001945189;
        Mon, 26 Oct 2026 01:05:45 -0700 (PDT)
Received: from jlelli-thinkpadt14gen4.remote.csb ([176.206.35.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3cfasm14911211f8f.17.2026.10.26.01.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 01:05:44 -0700 (PDT)
Date: Mon, 26 Oct 2026 09:05:42 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [RFC] RT throttling, DL/ fair server, RT_GROUP_SCHED and
 everything
Message-ID: <at8J1mimeQ2oPZDE@jlelli-thinkpadt14gen4.remote.csb>
References: <20261023161348.t3lpPLQZ@linutronix.de>
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
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261023161348.t3lpPLQZ@linutronix.de>

Hi Sebastian,

On 23/10/26 18:13, Sebastian Andrzej Siewior wrote:
> Hi,
> 
> this is about the old RT throttling mechanism, the DL/fair server around
> the RT tasks, the /proc/sys/kernel/sched_rt_* mechanism to control the
> former and CONFIG_RT_GROUP_SCHED which never worked as it supposed to.
> The current status looks like a mess and I'm not sure if there is a bug
> somewhere leading to my headaches or if this is just not meant to be
> working together. If so out with it.
> 
> tl;dr /proc/…/sched_rt_*, sched_rt_runtime_exceeded() probably
> CONFIG_RT_GROUP_SCHED should be removed. A bit of docs should be added
> for the fair server (or the right place).

Thanks for putting this recap together!

> Now. Details.

...

> Without enabled RT_GROUP_SCHED the files can be set. Are they useful?
> According to Documentation/scheduler/sched-deadline.rst it used for
> "admission control" whatever that means. Anyway the fair server still
> kicks if it is disabled. So I *think* this is just something else and
> not part for the docs there.

Right, confusing, but for a root_domain comprising M CPUs, -deadline tasks can
be created while the sum of their bandwidths stays below

  M * (sched_rt_runtime_us / sched_rt_period_us)

and writing -1 disables the check altogether. That's the "admission control"
the docs hand-wave about, and it's also why the knobs can't simply be deleted.
As you noticed already, the servers are completely independent of these knobs:
writing -1 does not disable the fair server, it only lifts the DL admission
cap. In principle we could move this to a different interface that reads closer
to the underlying purpose, but I'm not sure how much breakage it could cause.

...

> Anyway. Could this interface be moved to /sys/kernel/sched/fair_server
> away from the debugfs part? debugfs is not for stable kernels/ ABI. Is
> there a reason why this might be considered debugging and not final or
> restricted from productive?

I think this was raised already in the past, but at the time maybe it
was still to early to say if dl-servers will stick around. They now have
got more users (sched-ext), so it might be a time we discuss a stable
(non-debug) interface for it. Your suggestion doesn't look bad to me.

> Just to summarize:
> - Remove /proc/sys/kernel/sched_rt_*
>   [ ] Yes [ ] No, because
>               _____________________

Yes and no :). We need an interface to tweak admission control, but we
could find a better/different one.

> - Remove CONFIG_RT_GROUP_SCHED
>   [ ] Yes [ ] No, because
>               _____________________

Luca already commented on this. I believe the plan is still to come up
with a DEADLINE backed RT_GROUP_SCHED for Cgroups v2. If cleaner, an
approach could be to first merge the removal of RT_GROUP_SCHED and then
reimplement the whole lot as Yuri and Luca are proposing to do. The
series is already somewhat doing that, but it could be made more
explicit/clean I guess.

> - An additional trace sched event for fair server preemption
>   [ ] Yes   [ ] No, it is silly to have

With 820725b0eb59f ("sched: Add deadline tracepoints") we already have
some of that: sched_dl_{throttle,replenish,update,server_start,server_stop},
which fire for fair/ext servers too (there's a type field, DL_SERVER_FAIR
and friends). They of course require something like this [1] to be
activated. We could add more if they are still not enough to get a clear
picture about what's going on.

> - Fair server documentation needs to go to
>   [ ] It is fine where it is
>   [ ] To ____________________

Not fine where it is: the servers (fair & ext) work independently of
RT_GROUP_SCHED and deserve their own description (defaults 50ms/1s per
CPU, what they guarantee for fair tasks under RT pressure, how to tune
or disable them). Either a new section in sched-deadline.rst (they are
DL servers after all) or a small standalone file works for me.

Thanks!
Juri

1 - https://github.com/jlelli/sched_tp/commits/deadline-tp/
    from Qais' https://github.com/qais-yousef/sched_tp

