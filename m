Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793890151;
	b=M2EkOQ4lhK5OZvWrpmYOS/7/nnwkSQn7WuFVOFSk9n5tDLDMDkcXp5nnEq0IygP1geQl
	 Lrd1fOqIKWQ3iw3Up9bOizCqVK01+BMde8ySv6CVzNmOrMJra89wlObzMbZx1ukE36u0S
	 czBuMXABdZDB64m5q/k+M8/0PLAGt8IVMalBqhGe6EeaI5mXEmu2xgcK4A3JU0BzvXFPi
	 aPWcBqNHLjpfDDGoIkG9JjWL2k1XL3gpONRQ/PyEoCDAthl14SO8pdEFkNrO4+2ryNDYp
	 3LVTTBvQzx9ZPvRavB1p6poPlbbZLHP4M7zstHidIHLrsE6LGLKLwyRZeuleS+Io67g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890151;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0oZXaqilvDmJS1hNMgdeAwWlpvrdojNG02VoZz9o0R0=;
	b=RPyusLn4La15kwi1ah8+ShrGCK1nKn90yfvI6az32KVACfKtJbDMNMjqVT6ZHeWKBaJU
	 6xVzyjfHEqAvDeWjm86GTOqsGnCoBFXpyWbDfmio4aio19dEnu/WClJ8t8+J+RVy1iOPj
	 WoYSgYK8SxrE/DVlm8wKPdxyutTe1+ad8m6JBgcqeshLICW82BtITgBCtOQyeNbLDNm19
	 5gLZKjjeiabwVkt/HN6Btnv1Y/FFvLzj4rc8AQJam0n5poKLmsyKL+8Kfv2BvK+PWClqS
	 4W2NaHHfOVUmmgkGjoaF7xOHe7i6PV8eOhgC3xKOSgWBYiaDJIRwpbn7ZOgtksHx/1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dkq0QiMr;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=pcORwHkx;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881A9606A32C
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 14:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 881A9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dkq0QiMr;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=pcORwHkx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793890144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0oZXaqilvDmJS1hNMgdeAwWlpvrdojNG02VoZz9o0R0=;
	b=dkq0QiMrECsJKdQe3voh/qleY5HlHBx8Y1/14T65hTY2mJbfv+OFnfQWSpjsIRWz/Y/4pT
	UPqyS/hoXTF+dX7Bt+N9Lj7jjs3Ar++C4EvB27O5s0kkehaNo4MADSETY1Eotz8rJeulsz
	efzOBABpXj4ROEd4SCHHsVuQDFdCo3Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-sKwM-GnUOLCtwmT2_bikPQ-1; Thu, 05 Nov 2026 09:49:03 -0500
X-MC-Unique: sKwM-GnUOLCtwmT2_bikPQ-1
X-Mimecast-MFC-AGG-ID: sKwM-GnUOLCtwmT2_bikPQ_1793890142
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a4654add56so18198555e9.2
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 06:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793890142; x=1794494942; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0oZXaqilvDmJS1hNMgdeAwWlpvrdojNG02VoZz9o0R0=;
        b=pcORwHkx8ESY7disZ1BO7voLsR2k6eWKMwao+wjRO9/6DnGPJKl0JPlhiMY7WQusKb
         6cP5KAqeH71olbmhp86RYTkMfGZAyks5eyjntU8ODRLuHJ4RlH/J1VsCbrMNf4mqME/a
         D0QK5VIQTr/CSeN23lyN85om9W91nAVOyJPDY6ePxh0nfB1BTu9FEGVv6n265R4Qrr7x
         0Egh5xeXqjjxsFm3vUoF4Q/+TO+u//625zxy3SGkuN3zWK8SN/PKGdzFcW0rcOSvHx+j
         ZEhLoNqCVZiG6f15q/iujZZVXwZkMrdgoxH+HjZB9MENSVUWUMgniHG5IPeHCyGhcp5w
         jLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793890142; x=1794494942;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0oZXaqilvDmJS1hNMgdeAwWlpvrdojNG02VoZz9o0R0=;
        b=mS6xaeumJaC6F9fG6gwxsluJHJdwG4A3d26KKP1e09VreX1DAsJwIQyJ51XMe11/Ud
         Mi6+zE2t/4ijryVq5Vcl8QpvIF0dt1W29E6XEgaFjTCr0HUTHVmVhyn/IMc2RutbIlXn
         7IrZDhsfo/Bwo/uvFXab1zOHVraCtZq7qjCRldI1TepcgZsJwdOfFh3rzO4AgUsDFSD/
         dbWTn8jJ6JI8uOpGbkT6pppqmIPgEb2Ip9Q0ah3uGZ3J7iw5pIeXcgRnbNgcqJZuibtR
         UPMp73JlWF8IkxpLQs49TAqxDf8j9DYrSMFJ+8gjJe1ZVgQm9YJYK9kOYWvWNYqHN+hk
         wbgg==
X-Forwarded-Encrypted: i=1; AKwUvBwcZICmGUfLAQQyMgtYEPQ2haKZ4qELlHGi05syBfxUOKp9anEChB/XMF8AeNAxH3ppfyMFUlFz@vger.kernel.org
X-Gm-Message-State: APuU4Z/5T0xjRv9j+hTC5Sj3MpkaU3vmYd4UcsNNkKMBN9/XyvL3iu6X
	am7XYLMIPDWEI6tAVGjtU6STgkVATi7JkXxVZMhNdswP2Q0Fou9PQGWcan76V6QgvXqE5KalqkV
	L/p8YzCdXqxAzo1MrIKR+tFAiTy7LsOmJONz66PHKuY1kFxr3lXY4r4tFVMw=
X-Gm-Gg: AYBFou1nlvZup/CmfXG6qMGxA+IWdxP0CrWlJIq+Wb0pHJHOZIu1QkkD4ZSxgiTH7Uh
	KfLsfw9i0AddmStcALpBnM0F1D5IDLLWHAKgz2/TLsJZBFV4fa/8Yhq+EG6ruVFXNyHdNCEcWSL
	LT8b76mpsOijItAfTG2vC0/6lToMNkzCZImy40RC0Q1Ml6bkILuXiuPnAKFoR035HP2cd3JBhg1
	U/JpdGlW2PtVtJK6oiVpYsfyOCeDJkD7g8CUvRQSFKh2tH/fCAsdr5bJiBBmF0wYUaioNAQVNkc
	Bo1liLjhgYUnECteok9fKUhML3S3JfFsBugZUhW3pZYFTqMjL5resSvDTJ1bMRd1BUfq96Wxuse
	DctpucwLzs6JuWb8VRaWDGW+B2CQ7oulcXCUrgxLdMSjpiGPpYq+WNGU8m7oXnVft2yxiUyI9hT
	j97w==
X-Received: by 2002:a05:600c:1f93:b0:49f:ce78:356d with SMTP id 5b1f17b1804b1-4ac180f2fd3mr448854095e9.30.1793890141844;
        Thu, 05 Nov 2026 06:49:01 -0800 (PST)
X-Received: by 2002:a05:600c:1f93:b0:49f:ce78:356d with SMTP id 5b1f17b1804b1-4ac180f2fd3mr448853555e9.30.1793890141421;
        Thu, 05 Nov 2026 06:49:01 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56f5e65b0sm79732955e9.11.2026.11.05.06.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:49:00 -0800 (PST)
Date: Thu, 5 Nov 2026 15:48:57 +0100
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
Subject: Re: [PATCH v2 06/21] sched/deadline: Do not lose a throttled task
 switched out and back
Message-ID: <auyXWR01Lqb_yam3@jlelli-thinkpadt14gen4.remote.csb>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
 <20261104211207.1392343-7-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261104211207.1392343-7-mathieu.desnoyers@efficios.com>

Hello,

On 04/11/26 16:11, Mathieu Desnoyers wrote:
> A SCHED_DEADLINE task that is throttled, switched to another policy and
> switched back before its 0-lag time can be left throttled with nothing
> to replenish it: runnable, queued as far as the core is concerned, but
> on no dl_rq and with no timer pending. It never runs again, and a fatal
> signal cannot make it run; only another switch out of SCHED_DEADLINE
> requeues it.
> 
>  1. the task exhausts its runtime: dl_throttled is set, and the
>     replenishment timer armed for the start of its next period;
>  2. sched_setscheduler() switches it to SCHED_OTHER: switched_from_dl()
>     calls task_non_contending(), which arms the inactive timer for the
>     0-lag time; the parameters are kept until then, so that leaving and
>     reentering SCHED_DEADLINE gains no bandwidth;
>  3. the replenishment timer fires: dl_task_timer() finds a task that is
>     not a deadline task and returns, dl_throttled still set;
>  4. sched_setattr() switches it back before the 0-lag time:
>     switched_to_dl() cancels the inactive timer, and enqueue_dl_entity()
>     leaves a throttled task to its replenishment timer, which has fired
>     already.
> 
> The window between the deadline and the 0-lag time is the overrun
> scaled by period/runtime: about 100us for an overrun of 20us at 20%
> bandwidth. The replenishment timer cleared the parameters, dl_throttled
> included, of a task it found out of SCHED_DEADLINE until
> commit 209a0cbda7a0 ("sched/deadline: Improve the tracking of active
> utilization") moved that reset to the inactive timer, at the 0-lag
> time.
> 
> Give the task the replenishment the timer owes it, as the timer already
> does for one that is throttled and not queued: the overrun comes off the
> periods that follow, the deadline moves past it, and dl_throttled and
> dl_yielded are cleared. A return before the 0-lag time then finds an
> entity it can run on, and a return after it finds the parameters reset
> by the inactive timer, as before.
> 
> Clearing dl_throttled alone would leave the overrun in the runtime, for
> the new period of the enqueue to forgive, the deadline behind, for
> dl_check_constrained_dl() to throttle the task on again, and a yield of
> that period set, for update_curr_dl_se() to throttle it at once. The
> first version of this patch did, and the Sashiko AI review of the first
> posting of this series pointed the three out.
> 
> The selftest added two patches later fails its throttled_round_trip
> case 8 times out of 8, on v7.3 as on v7.4-rc1 with the four deadline
> fixes of sched/urgent, and passes it 8 times out of 8 with this change.
> It was found by a cgroup selftest under development,
> test_concurrency_deadline, which hung about once in 1350 runs.
> 
> Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/sched/deadline.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 30a52e42c26d..b646063a7b0d 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1232,10 +1232,23 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>  
>  	/*
>  	 * The task might have changed its scheduling policy to something
> -	 * different than SCHED_DEADLINE (through switched_from_dl()).
> +	 * different than SCHED_DEADLINE (through switched_from_dl()). It
> +	 * keeps its parameters until its 0-lag time and may come back to
> +	 * SCHED_DEADLINE before then, switched_to_dl() cancelling the
> +	 * inactive timer: give it the replenishment this timer owes it, as
> +	 * the !queued case below does, and leave the enqueue to its return.
> +	 * A throttle left behind would never be lifted; an overrun left in
> +	 * its runtime would be forgiven by the new period its enqueue
> +	 * starts; and a yield left set would throttle it again at once.
>  	 */
> -	if (!dl_task(p))
> +	if (!dl_task(p)) {
> +		if (dl_se->dl_throttled && !is_dl_boosted(dl_se)) {
> +			sched_clock_tick();
> +			update_rq_clock(rq);
> +			replenish_dl_entity(dl_se);
> +		}
>  		goto unlock;
> +	}

This should fix the subject issue. Sashiko points out a follow-up
re-entry case that looks problematic (and I think I'm now seeing more),
but that should all only concern limited bandwidth overruns. This change
fix an actual hang, so we might want to take it and work on the
remaining issues separately.

Thanks,
Juri

