Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794309289;
	b=QoLAnSqp2e4nozVQQt1Rtyg5VgXHtEY9sG9Ft8cyHrWvKWIMTt8h+qLot3d29ALoQeZ/
	 gV6/6YsGz1bl3rWaDwmFCdrAPrEsmCAJQvm/fXkvqAPwtInKd4kEkmWgHjCpE6CR8vr41
	 mu/qYm+P0Fz2UuuU3yEUBwMSlmytoEAqakkJRjFqtQDxDcIBjnDdINKaFzjPqhl3dlAih
	 p1lDZ51FQ7nQ3jOto8BJOGJeCnvh1/zomiEwvFXGznPn/CyBLvIDB2Wcv9k2AoXOfZAVF
	 24pR2ZEQ8LvtSYENLjkrot50LtfJtE423RlD1oQv52oRRj5oxSZkchFMm2hszjUqtjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794309289;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qOR1to8DwDNMHvVPWKTNupvvaYNTxEjClRGA3vc5Xw0=;
	b=eTZ+OO7T1AB6MzyVGdlbhJ17MH0aw85v1KHBwD+IOJ+YSZWYnCNDd4CeWdZTQzoYlICh
	 9vacFG6vd89vWi9rplX35rsddjsj64gmsPsgkXqYsc+99VNY/r/jGGZmViUpOIBWXzxeO
	 bU4oFTYMdkcBUhpTlJGDlZZtuoOHmE0hry24xyuv7E5fLtYlOBhsN/XVpjrgCk/r7QLul
	 fWy4arzU/51O6UDijrW0sODsS220vvrxF1cj5KHZQNHx8s03CQOWty9JOKwNMnSDQKTOh
	 1i4WeEsXbX/qlU3FAuchHARj5cs73TA7FMsJEzbPKOJiL0OJs9y/r1xxUKVElmWqcbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eGX9K1Ri;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fue1uWIB;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B154606A334
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 11:14:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B154606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eGX9K1Ri;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fue1uWIB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794309288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qOR1to8DwDNMHvVPWKTNupvvaYNTxEjClRGA3vc5Xw0=;
	b=eGX9K1RiprlgDLcN03x69X8D8WVtOnwfkz5UhhlmqbVXEX2Vl42IV9Zn35l96PGnteFie3
	5w9h0ro5bvGflRQkZ5V9gme+R/AiDiwbCML1/WA6W4Y55CyNlf8Tp3R6Yca57GYVsPloQI
	ljAHtglsXE1zN5bvK5Cf2dg4yiISmmw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-Bs6jg62vNsqlXdf62rAqxg-1; Tue, 10 Nov 2026 06:14:46 -0500
X-MC-Unique: Bs6jg62vNsqlXdf62rAqxg-1
X-Mimecast-MFC-AGG-ID: Bs6jg62vNsqlXdf62rAqxg_1794309285
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e4d1e29f3so1804498f8f.3
        for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 03:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794309285; x=1794914085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qOR1to8DwDNMHvVPWKTNupvvaYNTxEjClRGA3vc5Xw0=;
        b=fue1uWIB/eOIEC6nITbNo0WpinwOJCTHvtyX9cgkZIGGR81840Ve0tmtEXGzWvZxN8
         5oT+VqUh4XCfLPtQjkOMnIaKc7eElRr5mK4nR9Cpl7JgoqDpwA4hPoQjBAYrK0pJh7vI
         pr5i3qV14ZYTz0CkLgIMvbii9isWK0o1QP3gtuEiOBtjgJxljsba6H1M2HgUycHcaYYt
         +bLbJeNx5dh16egiaGxdlgUxchbiJDcRhX48BiJXQLUu4fhJcHW2a5HBDrHnVJtiCTyX
         Z5DAbCYFt+jNC0vnY11c8TroCrqmy4MUIItjSSu0cM2QAxwrqW+b4hxxZGWtx16fvJkv
         G49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794309285; x=1794914085;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qOR1to8DwDNMHvVPWKTNupvvaYNTxEjClRGA3vc5Xw0=;
        b=pnOr1i3a7srw2EcBTvYTsO6vPvclTNmKbQoMpaKTxze3vBMy2/jwxVLTZ0IfKrJLiF
         E/vqs2WQ44vbLn9/qetEVlePdPK5nY6gfQa76t9h+BOqpQLOF5uyiza9DGEawnPFZGOa
         JZtdSyWQHn/tF1LKcGfqL1B+iAVmD9qhUebOOceUaKReCax5DpplYvK25PiXQ1EDC1hf
         MkF6aIxWy+YXXZyvSXGOgqKd04WqZVMN0NvQrvaDuiKmetQn+Uj+QFHgGwPmVTgUTZou
         vwdpj9fFqcdj/LQLyEU15IWyMZp11Odai4v/EucEVSxuCl6hMNpTlpHRMzMmN3Eplv4m
         WKGA==
X-Forwarded-Encrypted: i=1; AL+hErFi2uUfC2TgXqUfy24xk7h0Bhi5v7CvKE9/aGpi0mY1XqxDns4xX+YW3ZR0/hR8NU8W8P2gLwuE@vger.kernel.org
X-Gm-Message-State: APuU4Z+GLje7uauuRBcnvRd24Ts8rmLK7hkEA2DedNM+tAPDY260DZM1
	/kf75J0ix4FtsfnXcWxBF+/ARn47+4/j4WTJCCzTrcGFKnttyCg2+0EhXUjm4istZQ7yrDuFS26
	stjye7Iq4kRR0lii3Nyi6A9IF+2/Mi+lQLeGC4DydWK80GUB8n/+v9mrqPcI=
X-Gm-Gg: AYBFou3bGX4NpjOjwuBoVBkMvR9LT7VFYIz/BV7n/Ml6avXWvq88jxwJ2dI75F9LMdO
	NnoVZrn0LHgV60cAaFoTmHmxzeyrCp1CzMoOpVYPQ3qjbYv5akate2j3Ddd85CGOQi4QHqzwZ9q
	eoEhU9LRPuz/uBcryRnLhrUi6FdN9JVPQRgqS9H/ba/TPlF1zmLFECWoH5lYwxrqsrH5beSu2LF
	0/7qp5hdyH3+80OqyVJqVwDrkNfx24Twyo7kQZJTNIYRwUcJsMs2EOGiV3nd5auuEw9PYEwjvYe
	zRJg3qM2EpBHIr32AweWz9SbT1Dxrd681om2RzpLv7ILb3QZI94/FsHN2jUlvom4nde4jgNBifD
	7kFzf8ZSbx7xdBuAwvIxa+kYfWKyFV9eX4T6njMEttHcKptg7EF6HVVWTKQhgtBsBIyxD6cEhCv
	PRavs=
X-Received: by 2002:a05:6000:2010:b0:490:50c1:f359 with SMTP id ffacd0b85a97d-498305da0dfmr4850221f8f.39.1794309285046;
        Tue, 10 Nov 2026 03:14:45 -0800 (PST)
X-Received: by 2002:a05:6000:2010:b0:490:50c1:f359 with SMTP id ffacd0b85a97d-498305da0dfmr4850140f8f.39.1794309284563;
        Tue, 10 Nov 2026 03:14:44 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4988f5b1ce3sm2904341f8f.14.2026.11.10.03.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 03:14:43 -0800 (PST)
Date: Tue, 10 Nov 2026 12:14:40 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
	boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, shuah@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 08/29] sched/deadline: Take a deadline boost from the
 waiter's rt_mutex node
Message-ID: <avL8oOtjKqVNR7-l@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-9-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261108185406.1549770-9-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:53, Mathieu Desnoyers wrote:
> When a SCHED_DEADLINE waiter boosts the owner of an rt_mutex, the owner
> runs on the waiter's live parameters, through dl.pi_se. The waiter can
> leave SCHED_DEADLINE, and have them cleared, before the owner is
> deboosted. When the owner's runtime runs out, replenish_dl_entity()
> loops forever on a dl_runtime of 0. It holds the rq lock, with
> interrupts off. The owner's CPU warns there and locks up.
> 
> rt_mutex_setprio() also reads the waiter's live priority, not the one in
> its rt_mutex node. Commit acd58620e415 ("sched/rtmutex: Refactor
> rt_mutex_setprio()") found this fine: if they differ, a PI chain update
> is imminent.
> 
> But the update can come too late. Leaving SCHED_DEADLINE clears the
> parameters, so that admission control counts the task again when it
> comes back. __sched_setscheduler() walks the chain only after it drops
> the waiter's rq lock. In the change itself, task_non_contending() clears
> the parameters of a waiter woken past its 0-lag time.
> inactive_task_timer() clears them later, when a sleeping waiter reaches
> that time.
> 
> O is a SCHED_OTHER task that holds the rt_mutex L. W is a SCHED_DEADLINE
> task. T is any other task:
> 
>   CPU 0 (O)                         CPU 1 (W)                     CPU 2 (T)
> 
>   locks L
>                                     blocks on L
>                                       rt_mutex_setprio(O, W)
>                                         O->dl.pi_se = &W->dl
>                                     sleeps
>                                       task_non_contending()
>                                         arms W's inactive timer
                                               ^^^
We know that PI is broken with DEADLINE and this adds to the count of
broken points. :)

>                                                                   sched_setscheduler(W)
>                                                                     W leaves SCHED_DEADLINE
>                                                                     task_rq_unlock(W)
>                                     <W's inactive timer>
>                                     inactive_task_timer()
>                                       __dl_clear_params()
>                                         W->dl.dl_runtime = 0
>   <tick>
>   update_curr_dl_se()
>     replenish_dl_entity()
>       runtime += W->dl.dl_runtime
>       loops forever
>                                                                     rt_mutex_adjust_pi(W)
>                                                                       rt_mutex_setprio(O, W)
>                                                                         spins on O's rq lock

The hang of course is real though.

> A copy of the parameters at the boost is not enough. rt_mutex_setprio()
> would read the waiter's priority, then its parameters. A change of the
> waiter can clear them in between. A stress test switches the waiter in
> and out of SCHED_DEADLINE. With such a copy, the owner's CPU locked up
> within a second. With this patch, the test runs for 600 seconds.
> 
> The rt_mutex node records the waiter's priority and deadline under the
> waiter's pi_lock, which every change of its parameters holds. Fix this
> by recording the reservation there too. A deadline boost then takes the
> priority, the deadline and a copy of the reservation from the node of
> the top pi waiter. rt_effective_prio() now reads that node too. It used
> p->pi_top_task, which try_to_take_rt_mutex() does not update. The chain
> walk and rt_mutex_adjust_pi() also compare the reservation, so that a
> change of it alone reaches the owner.
> 
> This needs "locking/rtmutex: Clone the sort keys in
> rt_mutex_enqueue_pi()". struct rt_mutex_waiter grows from 112 to 160
> bytes on 64-bit. With PREEMPT_RT, every sleeping lock waiter has one on
> its stack.
> 
> A 300ms debug delay before rt_mutex_adjust_pi() locks up v7.4-rc1 in
> 8-CPU VMs, but not a kernel with this patch. The locking API, ww_mutex,
> locktorture and futex tests still pass with and without PREEMPT_RT.
> 
> Found by the Sashiko AI review of v3. Before v4, a second model found
> the window of a copy, and the stale node of a waiter that becomes the
> top waiter.
> 
> Fixes: a5e7be3b28a2 ("sched/deadline: Clear dl_entity params when setscheduling to different class")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

I am not completely sure that we want the additinal machinery below
though, if we can find a simpler stop-gap solution until proxy execution
makes things right.

I was thinking 2 alternative potential bandaids:

 1. Don't clear the parameters of a blocked waiter. Every live donor is,
 by construction, a task blocked on an rt_mutex. Guard the
 __dl_clear_params() calls in task_non_contending() and
 inactive_task_timer() with p->pi_blocked_on (both sites hold pi_lock,
 which is also what pi_blocked_on is written under). The bandwidth
 release still happens at the 0-lag time; only the parameter wipe waits
 until the task is no longer blocked. 
 
 2. Even simpler, considering that the above is of course still far from
 ideal: replenish_dl_entity() already WARNs on pi_of(dl_se)->dl_runtime
 <= 0, and then hangs. Make the condition bail instead. The deboost is
 already in flight: the sched_setscheduler() that clears the donor's
 parameters ends with rt_mutex_adjust_pi(), which walks the chain and
 deboosts the owner through rt_mutex_setprio() and needs the owner's rq
 lock to do so, which is exactly what the infinite loop holds. Bailing
 releases it; the owner then sits throttled until the walk lands
 (dl_task_timer() is a no-op for boosted entities) and moves it back to
 fair. The stall is bounded by the walk's latency. 

Don't get me wrong, the proposed fix looks OK to me, but it also looks
more complex to backport to stable, it will be anyway ripped apart by
proxy exec and doesn't unfortunately make DEADLINE PI less broken (yes
of course the system won't hang, which is very desirable :).

Thoughts?

Thanks,
Juri

