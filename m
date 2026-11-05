Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876008;
	b=BNpk7ARgojFr6sqlPwVn1wC0eplVHz5+vEKLaDboPAZnyOeEpUuk1L2Xv5yxSdcDECxK
	 XswGGngty4NwSA8U64gKnPBdaxzB9PX3mUCXvFM2YrjYvDbSf35xNoCTE/i2pxgsHbiU6
	 VV+GWPEB7r00qnCU7HCJ30uplNYQrCdGcOXRotDNubm5bK2Mg2ZMGa3hpLfDmTK9+GsRw
	 0bcR4XlOAWXX+XitEgUpb0/bJ+UY1rU/Ppg1ayUsFLjLWs3DEj/OO4wRqHpIJ8Wl04D5I
	 8xn1XBkKd4Iy4LRLQPYyU/Knxdy1cWAl0NYdfWM2Ff9AldR0JbQz+CxD7WncrnX68zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876008;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=oydf0WShTzs9KXsUGEwBFf3FiP0jpqy13hriGlAhxmA=;
	b=W+aFP1woMwupr/SjLxW+eL337Ez+0sfJwCAT4OY7Pv+LPMZ891+eDENMJc7jDdcSPNND
	 Xq2i27bWuo+PBLhw9hou+dl6OCE+6a8W8bEmtZHagFQOuV4DoxDWLITVaurj0cvkM4iBQ
	 mGotFbAjHSEu4z8YGnvdE/ixYefuw++GKAqkXkup8bKthgO5pTpd5ZHRGOCkNTCdWNPSI
	 /GVcph3qYHgW99sL3e5CvFzd4eLbnt7h196vICvBZviEZ0EM7/pIRHrPsZZDDhnIf1xKJ
	 eTtHvjdg/88z+o4mILgeRAVqJ8gbTvmohT9M076NIgQpsiaV3h5doml+ydOmCWhCHzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SFQvjqLC;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=CrMWm3sf;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4466606A31B
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 10:53:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4466606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SFQvjqLC;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=CrMWm3sf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793876006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oydf0WShTzs9KXsUGEwBFf3FiP0jpqy13hriGlAhxmA=;
	b=SFQvjqLChm2Igrj8C82sLIgq02ZSKirrkfo0enUJ98hw2/2lqq4dTEIP9It3Tu5L+EK9Hz
	6Aixpqt/fy4bNYeWFJSDzEgUyFqny3WOo3FuZjLKUwTIdnQl/HvCc0pllMAdY9w/+eUypK
	1ouoC392fD5enYL7ZYrRuFJxledXD6Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-nJ-z6a9EOV654BGgZPlaPA-1; Thu, 05 Nov 2026 05:53:25 -0500
X-MC-Unique: nJ-z6a9EOV654BGgZPlaPA-1
X-Mimecast-MFC-AGG-ID: nJ-z6a9EOV654BGgZPlaPA_1793876004
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49febef74e3so3577405e9.0
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 02:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793876004; x=1794480804; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oydf0WShTzs9KXsUGEwBFf3FiP0jpqy13hriGlAhxmA=;
        b=CrMWm3sfjuH87v6iA2wlovtny4jGfObqRHzF1lEOcIIyQzRQQsVXW4PDxaJTzav7GR
         KwcEl1bA0irf7LimdtC5og6lxIo4QuGSIS0ajobh//4YK9ctX4LjxnIMFYG9Yk0PmR//
         9SJoFTXX4mmlRVUayKfOodSlK5P4sEmNG2Cx8+KY1dSXxSTtOXQZDT8wLBHmHXvY57VF
         x1KSYyvLg9jQrQlUVliPLkcjk0VM2rFM7qNsyl3ZNiROZ1n7fRvMRUZUi6xweD+ly6ki
         0pV6DnU34VTx0Fwa6/7myrW+ntEyedkKwJ5+f4sEMfb9t/ZD4Gop6FTuiXW0KPuD4ztC
         wWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793876004; x=1794480804;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oydf0WShTzs9KXsUGEwBFf3FiP0jpqy13hriGlAhxmA=;
        b=0DcrXKpKh2cdEj/DxEQPCbIW8/8LaQ20x0J4SPUlpoTxDtKq7/Du7rVYKAJn2rw6ul
         RcVeQPHqrT8t7sSDav4kSOOma3xkF3coYtXNnpgwPnoI6WWyZaMtWt7MgfMuPP3WrcU9
         Rh8pG2kEuoNT4/RwMUhc9qSIQ1v5rg+J05F26RS1GrG1dN4/tnKeFBkwvn4rqy+QfLVi
         H+KI6m/HO952L2wZTHDQgM7UgXpVuI3a8PE8UJNNESp5hyqA9mJQAJKxttdWxOFyp2Ze
         Jh/N/ZMT8uDHiZPVPRO+KgQI/H7t1uqx0Bn+6dHkwWuU0Q0hWniXJ6nEDCPf6j6FU1D/
         Ddpw==
X-Forwarded-Encrypted: i=1; AKwUvBwZePXT4UhvuqTmM6vTvk6VXiWRUfLjhm+nhrB5uWEs4vlPIk6yQXW0+d4FAmMOtXmBbKO+fnhB@vger.kernel.org
X-Gm-Message-State: APuU4Z/bVbE0vbacrhjki9HC+EZhGg40wz6cqhf+tBhh4HpAKOqCcOP2
	AxoWHzZ8B9sWyqeq3AqqR1+9UjqljqXT4/Eqa8lWukHiZ0NFBmI3z58mXCYtyS3gTuTY/pLbNCQ
	jGjDhCN+8Ed0suGDtJUCzJOs/2z0Uilflm1OrX2LKiUsplOHS8Ou3YOxTOVAiRqGHqlg=
X-Gm-Gg: AYBFou3QsCUUPnLG/xxjaF75XAJIii+wITvzQtxGoyHCYwoOd+mrCRdHnwDaC0Od5w+
	Er2oGPJc+2refS2PqX+daYx2YGh8CZoU+DX9gDITa5Z9dkhtaWVYQqK0HeHRU3114xUZqveKU0j
	z7OaG+0jItyWARWxdEngrKwGBUhT3RUO+IaDI0sicQb889Y1vIjn/uoNa7Z+i5SNWAy0dNHVPOv
	Ex2ExgvZcXD3U0T6Lc4IlcppCer//vbBgM2fgeDH50EnAu2R0+5c0lpyJZm5D3eDJIwZ5w4whA/
	T3sXaBbgETZq0RvEfEaAPgySV/EEqurWjiLWf9XRZ1xaqQwjxEEVCTcvJ7GGTz4kriKfPLuZBPl
	dR9e3O+wCXNC+mFK2PZJ+SgMm/QAXoYkvuqPGEnZA/0Vh5XKr3nrs8mCXqrKgf70lcv3q1tVHp/
	P/+A==
X-Received: by 2002:a05:600c:1989:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4b55dbb09dfmr39300285e9.13.1793876001310;
        Thu, 05 Nov 2026 02:53:21 -0800 (PST)
X-Received: by 2002:a05:600c:1989:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4b55dbb09dfmr39281275e9.13.1793875986470;
        Thu, 05 Nov 2026 02:53:06 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56eb4da1esm94641375e9.6.2026.11.05.02.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 02:53:05 -0800 (PST)
Date: Thu, 5 Nov 2026 11:53:02 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	linux-kernel@vger.kernel.org,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 04/21] sched/deadline: Do not divide by zero active
 CPUs of a root domain
Message-ID: <auxgDv4hE-MLnM4b@jlelli-thinkpadt14gen4.remote.csb>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
 <20261104211207.1392343-5-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261104211207.1392343-5-mathieu.desnoyers@efficios.com>

Hello,

On 04/11/26 16:11, Mathieu Desnoyers wrote:
> __dl_sub() and __dl_add() spread a change of a root domain's total_bw
> over the extra_bw of its active CPUs, dividing it by their number, which
> their callers take from dl_bw_cpus(). That number is 0 for a root domain
> whose CPUs all went offline, such as the default root domain, which
> holds the offline CPUs: the division then traps.
> 
> A debugfs write of a fair server's runtime or period reaches it while
> its CPU goes offline or comes online. From the rebuild of the root
> domains in sched_cpu_deactivate() until the CPU is offline, and from the
> CPU online until sched_cpu_activate(), the CPU sits in the default root
> domain, with no active CPU. A write that leaves the server's bandwidth
> as it is passes admission there, __dl_overflow() comparing that root
> domain's capacity, 0, with total_bw less the old bandwidth plus the new,
> 0 as well, and dl_server_apply_params() divides. Any other value is
> refused with EBUSY, higher directly, lower through the unsigned
> subtraction. Once the CPU is offline the write is refused, since
> commit 4043f5498416 ("sched/deadline: Reject debugfs dl_server writes
> for offline CPUs").
> 
> Writing a fair server's own runtime back in a loop while its CPU goes
> offline and online oopses on the first round, in 8-CPU VMs of v7.4-rc1
> with the four deadline fixes of sched/urgent:
> 
>   Oops: divide error: 0000 [#1] SMP NOPTI
>   CPU: 6 UID: 0 PID: 110 Comm: dl_server_div0
>   RIP: 0010:dl_server_apply_params+0x335/0x380
>   Call Trace:
>    <TASK>
>    sched_server_write_common.isra.0+0x1c0/0x260
>    full_proxy_write+0x58/0x90
>    vfs_write+0xcb/0x550
>    ksys_write+0x6c/0xe0
>    do_syscall_64+0x109/0x5d0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> inactive_task_timer() can reach it too, found by reading: it releases
> the bandwidth of a task that left SCHED_DEADLINE, or died, before its
> 0-lag time from the root domain of the CPU the task is on, and that CPU
> may go offline before the timer fires. With admission control off, so
> may sched_setattr() to SCHED_DEADLINE of a task asleep on an offline
> CPU.
> 
> With no active CPU there is no extra_bw to update: change total_bw
> alone. 20 rounds of the reproducer leave no warning then.
> 
> Fixes: daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl tasks")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/sched/deadline.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 963fda6ddb7f..dadda1a528ec 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -189,18 +189,25 @@ void __dl_update(struct dl_bw *dl_b, s64 bw)
>  	}
>  }
>  
> +/*
> + * @cpus is the number of active CPUs of the root domain, whose extra_bw
> + * shares the change: none once they all went offline, and total_bw alone
> + * changes then.
> + */
>  static inline
>  void __dl_sub(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
>  {
>  	dl_b->total_bw -= tsk_bw;
> -	__dl_update(dl_b, (s32)tsk_bw / cpus);
> +	if (cpus)
> +		__dl_update(dl_b, (s32)tsk_bw / cpus);
>  }
>  
>  static inline
>  void __dl_add(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
>  {
>  	dl_b->total_bw += tsk_bw;
> -	__dl_update(dl_b, -((s32)tsk_bw / cpus));
> +	if (cpus)
> +		__dl_update(dl_b, -((s32)tsk_bw / cpus));
>  }

I wonder if it makes sense to add/sub from total_bw when cpus == 0.

Wouldn't be better, if possible, to avoid calls with 0 cpus?

Thanks,
Juri

