Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792567150;
	b=BO420OcIgK/p2X3EbF+ohmTRWXPdEO1JFIRllUIV/pZozyLM8EOcx3NxKqqEM0ZhJX2R
	 ULD522qKpbm7CaJGSYAiCOMQTeJsnc+7vYqAFPDxWaZVc67A+V4KpL7/3mnj1mOWUkqnU
	 Nu0XzqCF1Fy7/Jgky38kFCgddsrQA3H2w454JFH036DY91Nnu3TMtnz2islPSa2sFkzL1
	 i36N4TNoI1iROdl/VRegKudGYxAhYpZLxbznU0WdNTqm3MGvQOy8+sukxzZRmshGs+B6o
	 ZhVqZu9tk6xO5rblJyJ4kKA05MTjaSCtPtU0WwKO4qG/ZwqgQB9hXNPDUbfnPDFDLvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792567150;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=lZp92o2ypA6mUomnWY8/aTISVyqFvde5Tqae7zZYQp8=;
	b=XeHY3x/mjgR5GUpaEYWdMW2XbZDB+e7SOnoyu5FXa+Zv8TvIGi+Ubx4/DpGVNqeoadVX
	 i17vAxAoV9F5Mb9KuV3HczJ6l58S7qU51DO80ZiRBtMZU7bITX+cj0YzIvcG2CuvIlfcp
	 6Ina2YVpJaSt4pdT9tXRp7qj97GhUqmr8uqo0gK2QXJlGma/nhoH6p7kYoMrZAggmGxY0
	 LQ4baf4NHSkrZE4u7AOs8ke5eQrQ/RH+nAGng/9TP1SRZxYGnfSzJJKUnKmarFeK9TW4W
	 ZuPJ5zSwLBvH9x1GTj9zVqsXcljvXBwe5VT1dFWBogcG7FPN2BKs5qYZNAOHBDLtMjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=T27bLdqm;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EC2606A319
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 07:19:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00EC2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=T27bLdqm
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48bbb06f29bso8948f8f.3
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 00:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792567148; x=1793171948; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lZp92o2ypA6mUomnWY8/aTISVyqFvde5Tqae7zZYQp8=;
        b=T27bLdqmIG5OoMtqxzRK7XQelB13l+qAZbEz86BaLPglRfGRQtnafKS11gDv/5llOO
         MPR1n8LaO0yQsmsZc389tz2pzOUW10zBtkt6mUYWDeTIJ7+3nzVvKKjIWC01CZ/NOLjA
         addkf6PCZWaajuQHLHUaqinPOOUyGLYBle8MKQMkXJqazEG/oa7p79xKuK624vlm1do/
         WWDreLZ8o+ndZCSWr/3WiK3/pFGSG3EXW3dlNd5X3C8vLJF1ErphZjkNZPIRC3GTb14s
         b036IC0n+ecv65vFyKeqChULoVKR5m2FgZfPcCWoF99228CqkLUWXi5vWYmJvGqTSODM
         P52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792567148; x=1793171948;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lZp92o2ypA6mUomnWY8/aTISVyqFvde5Tqae7zZYQp8=;
        b=dgXqR88rhGEQCvGMSt/hOIXTco6939OAO7VTBJ1uKeD/GxHXOytePRiL2VZKHpmYsR
         SnrWUEUxstfR7kVf8VwbA9NPXT5IYTJoASIG9+xTf3bjK6vnAODiu9jZVV5IfbGHOS7I
         zDmFd+EdzgsnllJnTTIgFP4BbSdYNTsxShmwD/ihOeOR4sqTXzlpEb1VowYsPmqEOJYA
         wA5VbiqKF5qiag8fWJM2GwAmD2hKuJcHyA9Qr16MsWQCv65D4yAgFpwNuIfoffagjbz8
         dTEkt0xcA5xz6i53z+BjKYtmnTWBy0JIzqh06EeTHf6eUN9+TuF9vsx3m2fBhs5lpeel
         kdKw==
X-Forwarded-Encrypted: i=1; AKwUvBwjw3xYxFbDpKuBUTPvvqlFZq0zeaIJ96E4G76TF/iuYaqCQWDvd/4hYeH9WdPV5WJ0u8XVlrJp@vger.kernel.org
X-Gm-Message-State: AFq9FYIUh7xwP3cKHgAgDV7KuECTyaIcqdVK7aYQXpHaabdwHs1j/eO8
	TdPTJ7+q9SYlYCvOuEVvYyA/VJ0rXr7G+VQ68M+OTFSc4b66TXyoT49B
X-Gm-Gg: AYBFou1trZBXsbaUV6p3hRmIHpD+nReLdKOSZZkYUY1RO3Ysb/LBmsDAgsNOXD+VQP+
	0eDxae/CHsDHKrMgGNxtDw6VgLNS8oy/tFhyJj3aZ2rBbZEEKy3svkJswjRP+fwlKcYhx//L6tG
	p8qSMHjqFTWiGCGRravNYfDAzFDrMdk1CixNWDoM0BAF1h9WgPDiGK3b+4RyCnj4QcC/OMv/b99
	hbb8diT+buqDFRCnxkUWIYT3ya1Yum2AxEmVZRPZUErAx4y0qAydSc0aoNX5ik7f4Fn4rvEPKML
	Objl08Iub0A+CDMST6ESdlVCwK/sNeHLKc5Q/O8owkhs+DVqaIsO1z2aagqTSOMN1qDxMP/n7Bw
	VEpPCXvCA9k//uV6uCivNV1zWaDQKvaLwWWnksXr1a1q+KKX2NhWHic7S6EAouRtYxFyOzFOpcz
	KxeqFExcztCYTAjaRR1lOHWdUfKL+lcD3l7Ga2rzcLPwyBvcVIjsTdH3MDlwvwcLcS5cB7QUE5u
	fBxcnHtMcCg3/i3xyoLMM7nnu9LhZtD8vIM05UwujQNcj9kyRQ1y/ECjyvP9OHauykdwEdFM7N/
	CbRnvxo=
X-Received: by 2002:a05:6000:4a08:b0:48a:f4c1:4301 with SMTP id ffacd0b85a97d-48e264df908mr1913032f8f.6.1792567148094;
        Wed, 21 Oct 2026 00:19:08 -0700 (PDT)
Received: from scheduler.schedules ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2581f15esm3985576f8f.20.2026.10.21.00.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 00:19:07 -0700 (PDT)
Date: Wed, 21 Oct 2026 10:19:04 +0300
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, 
	jakub@okonski.org, longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
Message-ID: <athWto0oZJvFzJ-w@scheduler.schedules>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261019182622.1584454-1-vincent.guittot@linaro.org>

On Mon, Oct 19, 2026 at 08:26:22PM +0200, Vincent Guittot wrote:
> Even with flat hierarchy which puts all runnable tasks in the same cfs rq,
> we need to parse the hierarchy to check for sched_idle task group.
> 
> Reported-by: Jakub Okoński <jakub@okonski.org>
> Link: https://lore.kernel.org/all/58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org/
> Fixes: 85570f10a4c6 ("sched/eevdf: Move to a single runqueue")
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
> 
> Changes since v1:
> - fix prototype and cleanup unsued variable
> 
>  kernel/sched/fair.c | 82 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 69 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0f2364479f9d..27ce3eb467a0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -433,6 +433,38 @@ static inline struct sched_entity *parent_entity(const struct sched_entity *se)
>  	return se->parent;
>  }
>  
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

So in a hierarchy like:

    ROOT
     /\
    /  \
   /    \
  GA    GB
   |    /\
   V   /  \
  TA  GC   GD
      |    |
      V    V
      TB   TC

Where GA is idle, GB is not, GC is idle and GD is not.

1. TA == se & TB == pse:
pse_depth > se_depth is true, so we goto GC. Now pse = GC.
Then we enter !is_same_group() block where we go up one more
time, so now se is GA, and pse is GB.


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


2. In here, cse_is_idle is true, while pse_is_idle is false.
So we return PREEMPT_WAKEUP_RESCHED. If these are inversed,
we return PREEMPT_WAKEUP_NONE. If they are equal, we return
PREEMPT_WAKEUP_PICK.


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
> -- 
> 2.53.0
> 

This only changes where we look, not what we do
with the results. AFAICT. I added my review notes too. They are not
essential but I still did wanted to add them IDK why tho.

Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>

Thanks,

Kayra
