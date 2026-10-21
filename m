Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588411;
	b=J4MGSjnAexm8PZKr76BRviloCmKxz08FW28ncbiAV0UcWbQ9d0L1hy4JKgoCbGS2oR5q
	 jaB4GdO0nxS/HxupD0LYIaKvrXmWhFp0UXfEniwAJFyo8zbtd53LHNrlalcMCjSIg2/mC
	 TtkZsKn3LoPkfJ8jQWliBsFto/5RNxWYrYXE7udkumQBWdaZKQo5f0d53xQZqi5Swt9YW
	 3P1K1Z0KKNDwoFsQDUiZwzXuI8A6jKW7XF66mUHfVu8rDeUZyIAg+HrF7CIS0UCSjpY3m
	 +ZnxzX0VnvxrzAkh/93E8wxgDfdChC83JUdwnJK2ro4dMIK2mgJdehpwTW6Le4F6m/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588411;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=fQVxdpjVQsSEW62gRWdnoI61AHhe+xkzfdDCbZF3RUE=;
	b=U0Vf103If8TTG0Syas4WdHJepJ0tYGPTzd7FI1lNFCDCj1npBt+UgouYFcC7eVoHyzTv
	 +L32QWBinnKLx5imc/7M7va4kVJKNJMwvB+T8h+Inmc3/pNmsDr6GJ05kiJNcnamc22E0
	 9mSsYM3+f0Lu6oBCslsJJ460k+QiZBaRSlrHaTojPyrX9MBF9ovMS5UaTmTpD5IhQJxTS
	 e9MC0yLX0y8sClDCt9SUjbQLcd9uRghgw2xrg+zaZ3LzBWn/inj0WXG1zmQNlaZCOJWOl
	 PMCad+Qi40FoDOm7H2ptegg/kgxVGKMPCQTlsFuuQ2tWq3C0fLuKcghhWLnTcIjz0hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=vTQV2A5a;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AA8606A33A;
	Wed, 21 Oct 2026 13:13:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2AA8606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=vTQV2A5a
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fQVxdpjVQsSEW62gRWdnoI61AHhe+xkzfdDCbZF3RUE=; b=vTQV2A5aLCEygETIJBxyowuz4T
	K+AiL6WskAnXCAnyalz2SIjrDDLm/4QUZzgXyqnd0Bz0O4DAqe5YTkaeiZmAr+QK0ugpYvfalfG6B
	ofZROCWz2zPBeGAlOoe6nc0roVku+X0GhR0Kgq5yrpEAz0DdyfXbVIOVEs/I1z84AwvRDBZ7PAuEw
	Pl2rEpFtGFvjeGrrojhUqxEwtkXx0sC+upXNpFcKw3p871rG94PXzknkrMumzmIlORLZKU3pdYip+
	qE6IqkX3cyT8vkfmoJaRmiGEYRfa4wGzRXWBHvfNRpGyPiyK/JXMZQm+N7UZL1Yqo7rGwZ0N3iU0k
	sG3RoYoA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xJW81-00000009P00-3lpG;
	Wed, 21 Oct 2026 13:13:13 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0EA2A3008E2; Wed, 21 Oct 2026 15:13:13 +0200 (CEST)
Date: Wed, 21 Oct 2026 15:13:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@redhat.com, juri.lelli@redhat.com, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org, jakub@okonski.org, longman@redhat.com,
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
	cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
Message-ID: <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
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
In-Reply-To: <20261019182622.1584454-1-vincent.guittot@linaro.org>

On Mon, Oct 19, 2026 at 08:26:22PM +0200, Vincent Guittot wrote:
> Even with flat hierarchy which puts all runnable tasks in the same cfs rq,
> we need to parse the hierarchy to check for sched_idle task group.

I F'ing hate cgroups :-(


> +static void
> +find_matching_se(struct sched_entity **se, struct sched_entity **pse)
> +{
> +	int se_depth, pse_depth;
> +
> +	/*
> +	 * preemption test can be made between sibling entities who are in the
> +	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
> +	 * both tasks until we find their ancestors who are siblings of common
> +	 * parent.
> +	 */
> +
> +	/* First walk up until both entities are at same depth */
> +	se_depth = (*se)->depth;
> +	pse_depth = (*pse)->depth;
> +
> +	while (se_depth > pse_depth) {
> +		se_depth--;
> +		*se = parent_entity(*se);
> +	}
> +
> +	while (pse_depth > se_depth) {
> +		pse_depth--;
> +		*pse = parent_entity(*pse);
> +	}
> +
> +	while (!is_same_group(*se, *pse)) {
> +		*se = parent_entity(*se);
> +		*pse = parent_entity(*pse);
> +	}
> +}
> +
>  static int tg_is_idle(struct task_group *tg)
>  {
>  	return tg->idle > 0;
> @@ -476,6 +508,11 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
>  	return NULL;
>  }
>  
> +static inline void
> +find_matching_se(struct sched_entity **se, struct sched_entity **pse)
> +{
> +}
> +
>  static inline int tg_is_idle(struct task_group *tg)
>  {
>  	return 0;
> @@ -10129,7 +10166,35 @@ preempt_sync(struct rq *rq, int wake_flags,
>  }
>  
>  /*
> - * Preempt the current task with a newly woken task if needed:
> + * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> + * in the inverse case).
> + */
> +static inline enum preempt_wakeup_action
> +wakeup_preempt_sched_idle(struct sched_entity *cse, struct sched_entity *pse)
> +{
> +	int cse_is_idle, pse_is_idle;
> +
> +	find_matching_se(&cse, &pse);
> +	WARN_ON_ONCE(!pse);
> +
> +	cse_is_idle = se_is_idle(cse);
> +	pse_is_idle = se_is_idle(pse);
> +
> +	/*
> +	 * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> +	 * in the inverse case).
> +	 */
> +	if (cse_is_idle && !pse_is_idle)
> +		return PREEMPT_WAKEUP_RESCHED;
> +
> +	if (cse_is_idle != pse_is_idle)
> +		return PREEMPT_WAKEUP_NONE;
> +
> +	return PREEMPT_WAKEUP_PICK;
> +}
> +
> +/*
> + * Preempt the current task with a newly woken task if needed.
>   */
>  static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_flags)
>  {
> @@ -10137,7 +10202,6 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
>  	struct task_struct *donor = rq->donor;
>  	struct sched_entity *nse, *se = &donor->se, *pse = &p->se;
>  	struct cfs_rq *cfs_rq = &rq->cfs;
> -	int cse_is_idle, pse_is_idle;
>  
>  	/*
>  	 * XXX Getting preempted by higher class, try and find idle CPU?
> @@ -10174,22 +10238,14 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
>  	if (!sched_feat(WAKEUP_PREEMPTION))
>  		return;
>  
> -	WARN_ON_ONCE(!pse);
> -
> -	cse_is_idle = se_is_idle(se);
> -	pse_is_idle = se_is_idle(pse);
> +	preempt_action = wakeup_preempt_sched_idle(se, pse);
>  
> -	nse = se;
> -	/*
> -	 * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> -	 * in the inverse case).
> -	 */
> -	if (cse_is_idle && !pse_is_idle)
> +	if (preempt_action == PREEMPT_WAKEUP_RESCHED)
>  		goto preempt;
>  
>  	update_curr_fair(rq);
>  
> -	if (cse_is_idle != pse_is_idle)
> +	if (preempt_action == PREEMPT_WAKEUP_NONE)
>  		goto update;
>  
>  	/*

What is the actual semantics of cpu.idle nonsense? Why do we care about
this common ancestor?

Can't we do any of:

 - propagate cfs_rq->idle to all child groups in sched_group_set_idle(); or

 - have se_is_idle() walk up and report true if any of the ancestors is
   idle?

I despise this find_matching_se() thing and was so very glad to have
deleted it.

