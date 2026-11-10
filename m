Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794340042;
	b=ScJQ2KLgL8VEa0re1WxFjXdcFT0s3BL321aqy7wAmUCcCR1koev6y6DK64hewZy7NTXi
	 BYT3PSg6BFX1GpHjWZRLdmTJd520LGzJ5X03zJdCe9ysQJ34yPyGSbm11Lv1SflAOeVpH
	 czcmdc415vK3ajZfkFHmkff55xQmg0qsm75Is6JS8Ceb3VRBkYEy+RKvB0QRFurfiT2rP
	 RvPFaTtE00L+CC9HVb+BNt6uMAWe+cANh3ogyTrnPrlxgKT/+R1T3XwPijgfD5yZZQPE5
	 iQzXsPOpAagh5VwAHyqoiyrP7fUqif01atDtXO0gmdK6OQfA7VfpFkbPmoVsWJIBKdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794340042;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dqGz2Ceiqh+ClSBXpHsYkjX+5pBbS+WZ/wLFaJOG/RQ=;
	b=x6H4bWng8aNO87Oy4gc0amyKMJssNilx2qHoJ9stRFcFZRb5ufoztK4dJnMT4iBla40s
	 S6k2o7ok6rMhgQwT2R8kJE8Jpj5NFGMGzEoFS71WKw1zx4SqKTSA22v843sUP9ZaVMNgI
	 B+OZBXrUMQB7EdifnHqOzG8Uct01BNSbvmJs18HmT1YffqHCDsgaD+ZpO9U6GyeG2a6Dt
	 UJ6k+cZpI8UaiGq0prWs60UUsg/PqQcCn73vb7veSgEdIl03f8XXLItCXsnN24lMEirj9
	 XwXGmO9q75s6l5e6HEfazK0FBhTKveW4yreconX8aLxTK3JcXOX9qwNNm+zGYNyKd0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AFsQoIbT;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=LlbC0SDd;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE2D606A327
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 19:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BE2D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AFsQoIbT;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=LlbC0SDd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794340041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqGz2Ceiqh+ClSBXpHsYkjX+5pBbS+WZ/wLFaJOG/RQ=;
	b=AFsQoIbToRtVBfKbZYZXx6UY5SQePeCRt2uY2xa1EoWVQ2yKRXfeuU6zzufjtiIE9GpHsM
	y6DTlzGJpUNFQXGIrxV4rwl6DMFrVj5+RYx1WwmB6i/N6947NDuolrVCavhhstCQZBah18
	sWjXPjt0OpivTzcU/geJCwD9aOknlxA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-DIkUmMrYOEORF5rvWX-jYw-1; Tue, 10 Nov 2026 14:47:19 -0500
X-MC-Unique: DIkUmMrYOEORF5rvWX-jYw-1
X-Mimecast-MFC-AGG-ID: DIkUmMrYOEORF5rvWX-jYw_1794340038
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4916bd6e3baso1968278f8f.0
        for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 11:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794340038; x=1794944838; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dqGz2Ceiqh+ClSBXpHsYkjX+5pBbS+WZ/wLFaJOG/RQ=;
        b=LlbC0SDdRVWh4mfVKJGcz5b2K1ftvVEwGYBArWTbuHzMzf/WlvIaTFqn3TBV0fMdHW
         IUtbcJZSynNEkxstfl9y8Xw9FB6x8XZy3ZL4ueoM+AOvSiPzyJw2AyaQ53hiXbSwjO5n
         DfF/YJJej+qDZYCASm9EKgkM/rEC6Q6FKfh1wb8FKCMHL8MlPNlXOoH0DKCapBIxUN8c
         PxtPyNUHRKaSNw8eocImUNNnqMgAMkw6iZYVKWAgi+V6ihSZ8wKg6kMeALRagobSk7wE
         XrgBjXNXzgRTleufl4Xyrl3ORlMUmgkXwSwrQb+Amt1D9BGvERr+shOhs6oBi1X0wSlr
         g0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794340038; x=1794944838;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dqGz2Ceiqh+ClSBXpHsYkjX+5pBbS+WZ/wLFaJOG/RQ=;
        b=ff7YklfOUPQ/MxZW0WobIqwUT27DiaxVtoBwvUWiesxMfmMqqdI7G1NO/oG3Ap3Qvp
         HqtzuFdwuco8FoVKeiKQkchADmggBLmPWeyp9BjhO7vYMNq+GnmHmZQ9+s7xxSTfUcM4
         Dry5Xv3Skoro+uKg/loEMyvfT4y9SObK/BKwc0X8uW7HunVZeKt+Tf2C7wztEcs73Hb4
         0/D2Qc5Km2O9iD5f5oZYv433LNr9PyUhYylO3qX19yKPIlUhydhp6HHmvRmLCxDBiP7J
         CoAkwQ4okaxxzm0Z9WUiqzeWMKODeQsB7rM+Av8+FkxBj/8w1pzGk+OBn9QPJaBHI0wC
         7jzw==
X-Forwarded-Encrypted: i=1; AL+hErEgCTA3DzOoWhj26zcFB8w3opxBawEVBaJ2YYE03FGDBdIxsNP9qQS19lurttzLfeJNlkdEbk1B@vger.kernel.org
X-Gm-Message-State: APuU4Z9zXxijjw5Dte11vTSJr+dhUYJS1wtiygSTt0jVXoHW/Z1zza0G
	n8CNQmWJbtHQFNRKp+YAm1T2iI8FEfb4JKWWCYPB9Lq55zkHiN5t8ysCcKDXZHax2rrdsEh4VV/
	rI7kJTd34TP+Zu/rx8OHvfEm7VYvXtoSM71stgiKrAOiapN+YKgXQOb/Ts78=
X-Gm-Gg: AYBFou1rxZ+NkfKItbODNo3fJrRkQ9OjWghGepZ30faonfA+oKsghM5D5Mpzj0P/b2K
	BPJ33C/JQFQBlNmsIIrOU4hw3kH0LuiQMDQTWKrgtfgUPUSIrg/o0Bo/hzX2y0joUOpuLU1CKW/
	aqCCp7UxQ4NFSSwCLHzf1dp7Wh1c+vk2pI0PD8As1VNbp+qs5EzBBNYXv7ckh76jZsJPzZjG6pv
	LKPMqobJ7nx8oEoTZpdHMCj2JHoya8Sqva7b+ESs9ouL53TYixUAuPUSlNkOJXsWM79BXqICyw3
	NVpaVEY30kRVcE9oS92Rk162m7CqQmoz+ap5biC83XZNMlmwA7q2rLxH6in3v0xA1XABZXPf/09
	G8ICRbEQE98vuWPiF4K6lkdcTkHkO3Yjd2acsvaWGjMDF5Dxs7nfWoCDmRsAIiX0jMNF2/aCb11
	+P54k=
X-Received: by 2002:a05:6000:2dc1:b0:497:bd30:8e39 with SMTP id ffacd0b85a97d-498304e5dd4mr6728819f8f.44.1794340038297;
        Tue, 10 Nov 2026 11:47:18 -0800 (PST)
X-Received: by 2002:a05:6000:2dc1:b0:497:bd30:8e39 with SMTP id ffacd0b85a97d-498304e5dd4mr6728770f8f.44.1794340037803;
        Tue, 10 Nov 2026 11:47:17 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49836a9951csm6505110f8f.56.2026.11.10.11.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 11:47:17 -0800 (PST)
Date: Tue, 10 Nov 2026 20:47:14 +0100
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
Subject: Re: [PATCH v5 11/29] sched/deadline: Release the bandwidth of a task
 that leaves the class asleep
Message-ID: <avN0wpOY2zoRnK8q@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-12-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261108185406.1549770-12-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:53, Mathieu Desnoyers wrote:
> A task that leaves SCHED_DEADLINE while it is not queued can keep its
> bandwidth in total_bw until the next rebuild of the root domains.
> Repeated, this fills total_bw up to the admission limit. Then
> sched_setattr(SCHED_DEADLINE) and CPU offlining fail with EBUSY.
> 
> A task that leaves the class keeps its bandwidth until its 0-lag time.
> Releasing it earlier would allow temporary overloads. For a queued task,
> switched_from_dl() calls task_non_contending(). It releases the
> bandwidth if the 0-lag time is past. Otherwise it arms the inactive
> timer, which releases it then. For a task that is not queued,
> switched_from_dl() relies on the timer armed when the task blocked.
> 
> But that timer is not always armed. The task may have blocked after its
> 0-lag time. Or the timer fired while the task was still in the class,
> and only removed running_bw. Then nothing releases total_bw. The timer
> is also cancelled before the 0-lag time when the task wakes up on
> another CPU, or comes back to the class asleep.
> 
> Fix this in switched_from_dl(), for a task that is not queued and has no
> timer pending. If the 0-lag time is ahead, arm the timer. If it is past,
> release the bandwidth now. Then clear the parameters, as
> inactive_task_timer() does, so that no later path releases the bandwidth
> again. A timer handler that already started finds a dl_bw of 0. The
> deboost of a later priority inheritance boost finds no parameters. Since
> "sched/deadline: Take a deadline boost from the waiter's rt_mutex node",
> a boost that the task gives as a waiter does not read them.
> 
> Juri Lelli's first fix, since dropped from tip, released the bandwidth
> here without clearing dl_bw. The bandwidth of a boosted task was then
> released twice.
> 
> The Sashiko AI review of the third posting found the two cases with the
> 0-lag time ahead. deadline_bw_test, added later in this series, tests
> this in pi_former_owner_asleep and deboost_released_resets_period.
> 
> Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-2-dd761fe005b4@redhat.com/
> Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
> Reported-by: Tejun Heo <tj@kernel.org>
> Closes: https://lore.kernel.org/all/2b5fb3f22bca6aa383be8f4781923392@kernel.org/
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/sched/deadline.c | 98 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 81 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index e6c55afcfd01..d5d0f87d3a94 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -403,6 +403,23 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
>  
>  static void __dl_clear_params(struct sched_dl_entity *dl_se);
>  
> +/*
> + * Return the 0-lag time of @dl_se, relative to the clock of its runqueue.
> + * After @dl_se blocks or leaves the class, its utilization counts until
> + * that time.
> + */
> +static s64 dl_zero_lag(struct sched_dl_entity *dl_se)
> +{
> +	struct rq *rq = rq_of_dl_se(dl_se);
> +
> +	/*
> +	 * Using relative times instead of the absolute "0-lag time"
> +	 * allows to simplify the code
> +	 */
> +	return dl_se->deadline - rq_clock(rq) -
> +	       div64_long((dl_se->runtime * dl_se->dl_period), dl_se->dl_runtime);
> +}
> +
>  /*
>   * The utilization of a task cannot be immediately removed from
>   * the rq active utilization (running_bw) when the task blocks.
> @@ -476,15 +493,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
>  
>  	WARN_ON(dl_se->dl_non_contending);
>  
> -	zerolag_time = dl_se->deadline -
> -		 div64_long((dl_se->runtime * dl_se->dl_period),
> -			dl_se->dl_runtime);
> -
> -	/*
> -	 * Using relative times instead of the absolute "0-lag time"
> -	 * allows to simplify the code
> -	 */
> -	zerolag_time -= rq_clock(rq);
> +	zerolag_time = dl_zero_lag(dl_se);
>  
>  	/*
>  	 * If the "0-lag time" already passed, decrease the active
> @@ -3606,15 +3615,69 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
>  	dec_dl_tasks_cs(p);
>  
>  	if (!task_on_rq_queued(p)) {
> -		/*
> -		 * Inactive timer is armed. However, p is leaving DEADLINE and
> -		 * might migrate away from this rq while continuing to run on
> -		 * some other class. We need to remove its contribution from
> -		 * this rq running_bw now, or sub_rq_bw (below) will complain.
> -		 */
> -		if (p->dl.dl_non_contending)
> +		bool released = false;
> +
> +		if (p->dl.dl_non_contending) {
> +			/*
> +			 * Inactive timer is armed. However, p is leaving
> +			 * DEADLINE and might migrate away from this rq while
> +			 * continuing to run on some other class. We need to
> +			 * remove its contribution from this rq running_bw now,
> +			 * or sub_rq_bw (below) will complain.
> +			 *
> +			 * inactive_task_timer() will find !dl_task(p) and
> +			 * release total_bw via __dl_sub().
> +			 */
>  			sub_running_bw(&p->dl, &rq->dl);
> +		} else if (p->dl.dl_runtime && !dl_entity_is_special(&p->dl) &&
> +			   dl_zero_lag(&p->dl) >= 0 &&
> +			   !hrtimer_active(&p->dl.inactive_timer)) {
> +			/*
> +			 * No inactive timer is armed, but the 0-lag time is
> +			 * ahead. Either the task is waking up on another CPU,
> +			 * and migrate_task_rq_dl() cancelled the timer. Or it
> +			 * came back to the class asleep, and switched_to_dl()
> +			 * cancelled it. Arm the timer, as for a queued task.
> +			 * Its handler finds the task out of the class and
> +			 * releases total_bw. running_bw is already off this
> +			 * runqueue, or was never on it.
> +			 */
> +			task_non_contending(&p->dl, false);
> +		} else if (p->dl.dl_runtime && !dl_entity_is_special(&p->dl)) {
> +			/*
> +			 * No inactive timer is armed, and the 0-lag time is
> +			 * past. Either the task never ran in the class, or it
> +			 * blocked after its 0-lag time. Or the timer fired
> +			 * while the task was still in the class. Nothing else
> +			 * releases total_bw, so release it now.
> +			 *
> +			 * A timer whose handler already runs also leads here,
> +			 * since hrtimer_active() is true. The handler waits
> +			 * for the runqueue lock, then finds a dl_bw of 0,
> +			 * cleared below.
> +			 *
> +			 * A task deboosted from priority inheritance, with no
> +			 * parameters of its own, has no bandwidth in total_bw.
> +			 * Neither has a special task.
> +			 */
> +			struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
> +
> +			raw_spin_lock(&dl_b->lock);
> +			__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
> +			raw_spin_unlock(&dl_b->lock);
> +			released = true;
> +		}
>  		sub_rq_bw(&p->dl, &rq->dl);
> +		/*
> +		 * Clear the parameters too, as inactive_task_timer() does at
> +		 * the 0-lag time. Then no later path releases the bandwidth
> +		 * again. A later priority inheritance boost sees a task with no
> +		 * parameters of its own. task_contending() and
> +		 * task_non_contending() skip it, and its deboost releases
> +		 * nothing.
> +		 */
> +		if (released)
> +			__dl_clear_params(&p->dl);

The fix looks right, but I wondered if we can condense a bit the above
if-else tree. It's essantially doing what task_non_contending() does
already (special and non-DL tasks checks included)?

What about something like

     if (!task_on_rq_queued(p)) {
         if (p->dl.dl_non_contending)
           sub_running_bw(&p->dl, &rq->dl);
         sub_rq_bw(&p->dl, &rq->dl);

         if (!p->dl.dl_non_contending)
           task_non_contending(&p->dl, false);
    }

I ran the same collapse on top of the series and it passed the selftests
with LOCKDEP w/o warnings.

Thanks,
Juri

