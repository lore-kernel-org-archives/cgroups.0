Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794219458;
	b=Sst38IoPvwiLBqPTnzzSjy3EW8KTcJog7HfKQqeYUOuiX7b3/D8hJ8ccXgmOUJA5sz7S
	 UwAd/KrZw+blA3mBaHYTY+rqzMCpWJQ+X4HNcUJwsQbHnHiXdoqn4WTp1Z7Za4Jr6P4dU
	 n7NJPToYZO0rKsHWKtR2x9WdJcu/zd/w9FVPCbrRhA3EqUmenaD6S4/G7tp2xki9ilxyS
	 /syNZAGQzp1k3Keduf4kxVMAVLizatx6pI3Jr/B44VjV58UYFVAJ+QvO0Q+3ZiYpo9Iow
	 N1UXLQskA7XGxEJ/u6poCUiONchUes++RKrwBJNprqPYhqMQ2SlSUQReSP1jai4RLQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794219458;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=qEpeXh4n+Ip6h8mQUL16hZLbonLzBsEE2lau1nHqEmo=;
	b=k6ez+GfTlY8AaIWYU23Y8Shu8wYDaHpCD9rVEykv561rr9b76F9VaB00jVAukTmyvDFu
	 cmWclEfJr5FuAQkCtK+JkPcBuGta2VZDl3s9RInZy1dPXBS7e9oGTyicqTKwSqufs6TGP
	 zqLluVrx36mLBCwrDWvK6XFXhZHNs74RQSTRdiTOaCBqqbnnwWVqRnetRmuGnIlyAmzYh
	 sbQS3MELarIKZOHhkmvs1zHJQuUaxgqquzI2YH2QLikrW8GGmwMQazcLcDxAXVXe10IDT
	 dWGAK1IRDO/78wF7qhmzb8wkY5RayGPr+LVdOKTvWZ9wTtdezgCa0mrRhoMERK6WxAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=crsYu80L;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AZFsxJji;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65EE606EE9D
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 10:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E65EE606EE9D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=crsYu80L;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AZFsxJji
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794219457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEpeXh4n+Ip6h8mQUL16hZLbonLzBsEE2lau1nHqEmo=;
	b=crsYu80L+O03Mdk9IyNt4g2TeVfc+AMEZ/+0vt95KmjScPbtqLmkUeLWUjjCKq1kmBEI04
	ijuNgzzI3Zlxp15o6HzIIratvD93WWfu0id+1wEjb1EHNsUoSbJzxvi1577XIEO5pY7Nuk
	1LPKIRcR881yL9fcesg8AzmVtkZd1Ro=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-eJCj9hHSOuKqwLfplJJqMA-1; Mon, 09 Nov 2026 05:17:35 -0500
X-MC-Unique: eJCj9hHSOuKqwLfplJJqMA-1
X-Mimecast-MFC-AGG-ID: eJCj9hHSOuKqwLfplJJqMA_1794219454
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a214a5f8a1so6709195e9.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 02:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794219454; x=1794824254; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qEpeXh4n+Ip6h8mQUL16hZLbonLzBsEE2lau1nHqEmo=;
        b=AZFsxJjiZqZrL72YI//l2f88S1Zo8AtzYrL3FMNrR379eUWzcnayOE/cfH5U18gqM0
         5VVr+x8YGYXw3RoHOvRXeb0wJruoSshj6G3yx9ycnng69Opfq3a3dnXTtrP1IceixiKM
         S4sdRiNe1b0gtheaY8NSLaxe96FuCBx0S6eFh1LllCYntmj2dkAFRBaTAmofb3P2cyZ9
         qRRb+E73H/aL1qoIDHnBHP/rHQTgZlS+iCsqhG/L3pffTnjLOD5CLOCyc+47UyV5X7EW
         X0CH1hv0FQlHM8KtCwJIZxetv31oO+PIlKYAG49ZDbZp54lOkMz5FhlxvgOqnWx65kzL
         64oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794219454; x=1794824254;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qEpeXh4n+Ip6h8mQUL16hZLbonLzBsEE2lau1nHqEmo=;
        b=0stH6abhi0mTip9zN8uhJ+5MmPB3p2v+3PBJtAfYyYyNSNEi5RKh3mq/ozXc1FVzQk
         Ell2yR4zouJ37fPSSI6++01wk/qN3prCg7LEOYCNuf4IM/QuQam5gjqs4APy2CAzZl8/
         /oSx4pj5/WAJSS6niYMJavwWmCT1TA9kyOShulJWlveVTNfGF/sEM2fY9LFPgp366w1Q
         +hLhOxl6DLbrPsETjMpnY7uM1yR5EgxdyH97nrK7D/NZYAIpR8sO4hd4WKIvTxbYbvFw
         7ULD5JxH0XMddzryGIWhoEin3qHLYTnsdxx96yZhkcGLraTO1WgNjh00h4xJHBj3TpX9
         TRiA==
X-Forwarded-Encrypted: i=1; AL+hErGvAlmScfjda/sxVO+CZ8GTD5zT54yiacEqDEdBz4lO52/IDyv+Zi1FyrPtd5QmNgtsY9w5/R5W@vger.kernel.org
X-Gm-Message-State: APuU4Z+tt2he/Ep2mUiSF5AFvDFOae+CuYghQaci5N9K+XN3HU0Ddg54
	fiFlSE3KGWE9ileBj9EW1wsxHAH31L3o9r5DhYaxh7vQZwMbau0wUPCp2LKxflQaFx6XzRJlfn7
	khHqm5e81z3bVQKsuiZi3Vt/lf/6lfOg1zlUy/kliNhMTihkd9tgCiTimM6U=
X-Gm-Gg: AYBFou2nTj7hySUYWloXf1R2ZB0KXGDTQv0pvjsAl0XsMAzViy32i9hu8gZcSK6oR2G
	KsB4sB8PNggq68mEPeCteihSIRoCFCQ2DmiioJk3UJxJBwK/FCorLAdkB8XOFK0uF4yTGN8f6MA
	Hrz9mSEJH4i7n38lZQ/Oo21HNRjzQ0b0XqctNk18oMkLzcuG2xVLDQrQZp7udedqMd0qo2Zbv7j
	tlD6om/fKSvsQrEl7BQH5+jOxBcCywQ3B3wcTtd7KmP6/KQyhL5hTedz+DqKZQQpZ/1InaybBpL
	3MuY3ky8Ur0Le4Lt2XW30qavF2YXPcd/yK6LoOYBuTTPerhUccs/1sNjPrLaipEvKz5SIif4M4N
	dg/uQZmnAHKI4HNY4DPq5urlV1hS8xWuHw9NrJEjjfB1+7E/0H9crZsidUxhE3f/W7Ra7tJ+yXP
	PXWQ==
X-Received: by 2002:a05:600c:4e4e:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4b94d763141mr64174595e9.2.1794219454187;
        Mon, 09 Nov 2026 02:17:34 -0800 (PST)
X-Received: by 2002:a05:600c:4e4e:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4b94d763141mr64174325e9.2.1794219453808;
        Mon, 09 Nov 2026 02:17:33 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b9f93c04afsm71663785e9.3.2026.11.09.02.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 02:17:32 -0800 (PST)
Date: Mon, 9 Nov 2026 11:17:29 +0100
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
Message-ID: <avGduY8yVmZSfpMf@jlelli-thinkpadt14gen4.remote.csb>
References: <20261023161348.t3lpPLQZ@linutronix.de>
 <at8J1mimeQ2oPZDE@jlelli-thinkpadt14gen4.remote.csb>
 <20261105120932.lSBBenqn@linutronix.de>
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
In-Reply-To: <20261105120932.lSBBenqn@linutronix.de>

On 05/11/26 13:09, Sebastian Andrzej Siewior wrote:
> On 2026-10-26 09:05:42 [+0100], Juri Lelli wrote:
> > Hi Sebastian,
> Hi Juri,
> 
> > On 23/10/26 18:13, Sebastian Andrzej Siewior wrote:
> > > Hi,
> > > 
> > > this is about the old RT throttling mechanism, the DL/fair server around
> > > the RT tasks, the /proc/sys/kernel/sched_rt_* mechanism to control the
> > > former and CONFIG_RT_GROUP_SCHED which never worked as it supposed to.
> > > The current status looks like a mess and I'm not sure if there is a bug
> > > somewhere leading to my headaches or if this is just not meant to be
> > > working together. If so out with it.
> > > 
> > > tl;dr /proc/…/sched_rt_*, sched_rt_runtime_exceeded() probably
> > > CONFIG_RT_GROUP_SCHED should be removed. A bit of docs should be added
> > > for the fair server (or the right place).
> > 
> > Thanks for putting this recap together!
> > 
> > > Now. Details.
> > 
> > ...
> > 
> > > Without enabled RT_GROUP_SCHED the files can be set. Are they useful?
> > > According to Documentation/scheduler/sched-deadline.rst it used for
> > > "admission control" whatever that means. Anyway the fair server still
> > > kicks if it is disabled. So I *think* this is just something else and
> > > not part for the docs there.
> > 
> > Right, confusing, but for a root_domain comprising M CPUs, -deadline tasks can
> > be created while the sum of their bandwidths stays below
> > 
> >   M * (sched_rt_runtime_us / sched_rt_period_us)
> 
> My understanding is that this is the runtime available to a DL task and
> the length of a DL period (after the accounted runtime is reset). The
> left over runtime (of runtime is less than period) is either buffer
> (idle) or SCHED_OTHER runtime.
> This defines how much runtime a DL task gets from the system, correct?

How much bandwidth (runtime/period) DL tasks get from the system
(comprised of M CPUs). And a corresponding cap (no more than that will
be allowed to enter the system) - admission control.

> > and writing -1 disables the check altogether. That's the "admission control"
> > the docs hand-wave about, and it's also why the knobs can't simply be deleted.
> > As you noticed already, the servers are completely independent of these knobs:
> > writing -1 does not disable the fair server, it only lifts the DL admission
> > cap. In principle we could move this to a different interface that reads closer
> > to the underlying purpose, but I'm not sure how much breakage it could cause.
> 
> That is my point. The rt_ runtime/ period is about DL properties and not
> RT as in SCHED_FIFO/ RR as it once was. Both are set to one second as of
> today and can not be changed with enabled CONFIG_RT_GROUP_SCHED.
> 
> Could we please move it to /sys/kernel/sched/ and rename it as dl
> something? Is there any reason to keep as-is? There is
> 	Documentation/scheduler/sched-deadline.rst
> 	Documentation/arch/arm64/asymmetric-32bit.rst
> 
> referring to it in DL context. There is "ftracetest" writing
> unconditionally -1 as a workaround, see commit 57c4cfd4a2eef
> ("ftrace/selftests: workaround cgroup RT scheduling issues").
> 
> If the runtime/ period arguments are fine then we could keep
> it and make them only apply for the DL period.
> 
> Two files have been repurposed and if your intention as to disable the
> RT throttler then you will be surprised.

Right, it's indeed confusing. I believe the intent for keeping as it is
today was that in the future, if we get to 'fix' RT_GROUP_SCHED with
HCBS, the existing knobs will be control both group and simple DL tasks
bandwidth (they share the same bandwidth). I'm not against making things
clearer. Maybe let's hear from others what they think as well?

...

> > With 820725b0eb59f ("sched: Add deadline tracepoints") we already have
> > some of that: sched_dl_{throttle,replenish,update,server_start,server_stop},
> > which fire for fair/ext servers too (there's a type field, DL_SERVER_FAIR
> > and friends). They of course require something like this [1] to be
> > activated. We could add more if they are still not enough to get a clear
> > picture about what's going on.
> 
> Hmm. You may want to merge Qais's current master to get it compiled
> again ;) But then nothing hooks it up, so I just replaced with with
> trace_printk() just to see what happens and got:

Ack, yeah, I didn't use them recently and they rotted. :/

I will try to find some time soon to refresh and check what's missing
from the information they provide (from a debugging point of view).

Thanks,
Juri

