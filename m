Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792589593;
	b=ek1yHH2yqecl2KErlK18yOD8nBOK7AG4hLQwFT3LhL9UvHf6PFvIBaSt52sJyXKsKioI
	 3qjDQiSvQnIFJbayJHjzGKvI5Zt6+JigTowrI5ztR2JhkqMQwUbxLp+DJ3RSOpJljDr0l
	 5yBxaCKYtJ2lbu0uz8nfXItNmS5RaKjwH3IM8hSGakkMKJBVVE1fHq3J/IauI9oerzsWF
	 DZM0s3BxD1Y0c7hClC0H5UWgPlCML9+qFEgja+XOkPmdc3zREWkMIjh7xWZcqtqyMOICl
	 Uam5hVcI3alpocCFvQK5qHrmD5YlIJE6Ez43Pe5jsXrI4B5Fxli2/gts/GebpM+2E+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792589593;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=mzhN59aUdpFqksyzkN0log26xHQWNSCFpleWOq4jTQY=;
	b=mtAPEV5RRrFWN/8Zi1nhhwy6lLWgPD669R7UKPdKpy5xi7WBRnc4XKaw5IJ7KPTQaRdK
	 MTldBtt52TFgEBJ8r+JC/aFk/bYESFN++LV8v/oazcPlJ/pnhroxC1DSAei6b14JKpqx2
	 NBnH8aAvkD+uzbO8bGqtF1CjD1WIlKUhrWMcWTY+iZD4dtBiEIQ8ZmlM76Q/rtkzBsauT
	 jiq684+gr6c9MK5NH7t/L+/rY2TcxWd5Tok0ozUqqpzCDfYvrjEtzXMq8HA2JUeU0xhIM
	 oEpPgwy/dHzMRSOh1FlYPGYi0t2zORU90JmzYphmvlt6XBzlB6km91RGFoXz78ksFsw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=pgnaMBle;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E686A606A31B
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 13:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E686A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=pgnaMBle
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso953468a12.3
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 06:33:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792589591; cv=none;
        d=google.com; s=arc-20260327;
        b=Ea3DdDDCr6SC77hivpVO2RkraJzBo+EkI3NRPfy3fbqOfIf+2dLKFG378Zzeg4fVki
         kI0bj7rwbK+uj9F8uWU7nVC3tdpcNG5KVqtfUyN7wUiibiVKBbNR/+DHmAYHR3W2Px4p
         bbSWVbaoNDsemCV19kZ9crnc89N3Sl0466W8FISR/JdriXoncyer7HrALMSgVSiaGbjE
         GEEUw32om7u01rw8G87Fm1j0S+GG2GKUoOLBD9jXCSMbTnAf6/Spna1tBoUT28n8ppTG
         dOmaTKMYD+ZdnNS7tLyxXcLriQGryJDOgZXckJTka0jKZmgE+mPKQDhWOnpYXLuOwlib
         sVfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mzhN59aUdpFqksyzkN0log26xHQWNSCFpleWOq4jTQY=;
        fh=qAUAFzKqHv7QGg2rcEaXJ73F3LL4vURSTP1PpnUkYWs=;
        b=ZYi/Wbqf/+ixzKwyXGs9UGLqIzA1YC7Sh3SLCOQTSCUoQANBC5rqapNxuALst3ijn/
         grTrpXi+uPkJrekzwfZtr5R2RMeIuux0GO89cpT2z+tUiS/ud71tcDoncqhDx2eCl/D+
         Ob6qHTbaoth0ocKR/Gn7n3iGM/e+smR7aS+EunICaPbfwDn8/bVC3ULw2jPlO92Ur/y0
         0Dxoqm0sBCgXEWMswpUFnCLJMFsXCOyxwhZUyp6YL1QY/uq+mDqQM8ecHwaEqrzKv0f5
         4xX8XFwOn5M8yv3GbYO14tmLygTvJ2UsYw/ybTb6wLfZ1Yvyi5y9/fp4hqxZnNM+DUkU
         xgAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792589591; x=1793194391; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mzhN59aUdpFqksyzkN0log26xHQWNSCFpleWOq4jTQY=;
        b=pgnaMBleCn1rfiMKktiiqR8q/NIjJ1erjX1yzrhggkxq5nGGK78/YPQeAZkUV1eIeB
         07hJdMzOQrCFiwO7Pd0amXWgZuSgL/IRqvUO7v4lWJrPhsZGOPc0jlih7fGk/72eMU1W
         F55kr311v3V3FO/whuRxnJRuxfEMhaxGER815OYXj6M8Y92jTNgJMOksKxisuGEgOOzr
         RLqyc13IixpmZxOC0t6Fl1ymbeerFKNbn8QCv7Lldz9HZUN0IkvFgsukWZFPANw5PuRl
         e/iTd3WHxKbG7lbiuT/Z5nKayPhXa1CPDMP6vkE5Oft8KQWKn7jnqWbXro5X+E2OmfcJ
         AGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792589591; x=1793194391;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mzhN59aUdpFqksyzkN0log26xHQWNSCFpleWOq4jTQY=;
        b=tqx7/Y/iygtEhZhlrdaTXLJPtoU/QBWBXV8WGmfdy1T+Vel2gvTumTMhh/ZNNlgPUN
         glOoLzRuirCpbEJUFn5vmlPdVAcnOZ4hCw41MM7J3XUjfa75HZsuN5b4xdVpSFBjzbOf
         ig4RkLp8tnsVSr3ZcpExeNGs/LKl8w7AUeQG4fI70t6Jj7ahJtK6VTUQy8ITs+4ZVlkV
         77Bw57fz4iQSyk2qubW+x5PyCaTspHHxBa6whalWvr9bCXsKdvoGyyQdUZnEbO52P6co
         yTr5Ty8cB06/Zg0dnJvT1UE/4bW5HWHjF2saYAD8zKiXIUqISLcUcepta3YXm+zKtBqn
         n6Ew==
X-Forwarded-Encrypted: i=1; AKwUvByHcdGaq7moOPjsC7nChvEQWxitWQrGUpEPmfasfJSkCk1s+76/mf+nqLuo/rR5ujr16DiWL7gc@vger.kernel.org
X-Gm-Message-State: AFq9FYJBNbrp18G2Gn632duEqUNxrQFu7ht3KQcoyd39UL6dio7rXm6V
	R33Z/x85CjmTYZ4OQdl1NYU6sTzEHdfEmARfqpBZ3VwZiGWXjReDSL1I3HAeJOCz9DbMfzJW0N1
	HoDe3XFqz7d9AqeiWjHAgcBUdoxrSfJVBvhXKm5tzfA==
X-Gm-Gg: AYBFou0Jlh2WiTutmLKtwpsRCKo8w9Wo8i0XbGlFM1EsIYcPkTvklE6oDjvFvhsCYwV
	nIPzfcUd8pNjB5ujEo3mYxb5DHAZ//J0J1luRP4PSN+s9789FsGAVhjeVslOYTJFpb7/4a7x5QF
	akyTYnkqapGwaJ+VeK3jbUz9IQLkAKoaG2fyB7VIabRjENIq50P8Qz8rfuW0DvlG/PeGO8HZQS8
	qS3dsZ/dezY09tLj4cnbf0IXxxUUWlPTl44svYXBzwPTXr7w38uoNg4EXss1y+iuALX8k0OZ3e3
	+Z69sklACAUIaz/Ok5hoXaaQn3fsUh+gibWdBmnnkdBVM35X9gqrXJhAr9tfsKa1sEJZG17prcn
	6yNY4bbANsgWO4eYHglwolbOVSzjTCx9JpK8vyrUtIoz15o1S1+ApelzzZulDuxcu8/Npag==
X-Received: by 2002:a17:907:6d24:b0:c2e:808a:f78a with SMTP id
 a640c23a62f3a-c46796e73a9mr181786666b.32.1792589591100; Wed, 21 Oct 2026
 06:33:11 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019182622.1584454-1-vincent.guittot@linaro.org> <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
In-Reply-To: <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 21 Oct 2026 15:32:59 +0200
X-Gm-Features: AclHuK_wglfPwgvmED2Zs7zk8TF7VCrlIgIH4q9AzKzQdRiB6v4sIHacjNMHvTU
Message-ID: <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, juri.lelli@redhat.com, dietmar.eggemann@arm.com, 
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, jakub@okonski.org, 
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Oct 2026 at 15:13, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Oct 19, 2026 at 08:26:22PM +0200, Vincent Guittot wrote:
> > Even with flat hierarchy which puts all runnable tasks in the same cfs rq,
> > we need to parse the hierarchy to check for sched_idle task group.
>
> I F'ing hate cgroups :-(
>
>
> > +static void
> > +find_matching_se(struct sched_entity **se, struct sched_entity **pse)
> > +{
> > +     int se_depth, pse_depth;
> > +
> > +     /*
> > +      * preemption test can be made between sibling entities who are in the
> > +      * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
> > +      * both tasks until we find their ancestors who are siblings of common
> > +      * parent.
> > +      */
> > +
> > +     /* First walk up until both entities are at same depth */
> > +     se_depth = (*se)->depth;
> > +     pse_depth = (*pse)->depth;
> > +
> > +     while (se_depth > pse_depth) {
> > +             se_depth--;
> > +             *se = parent_entity(*se);
> > +     }
> > +
> > +     while (pse_depth > se_depth) {
> > +             pse_depth--;
> > +             *pse = parent_entity(*pse);
> > +     }
> > +
> > +     while (!is_same_group(*se, *pse)) {
> > +             *se = parent_entity(*se);
> > +             *pse = parent_entity(*pse);
> > +     }
> > +}
> > +
> >  static int tg_is_idle(struct task_group *tg)
> >  {
> >       return tg->idle > 0;
> > @@ -476,6 +508,11 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
> >       return NULL;
> >  }
> >
> > +static inline void
> > +find_matching_se(struct sched_entity **se, struct sched_entity **pse)
> > +{
> > +}
> > +
> >  static inline int tg_is_idle(struct task_group *tg)
> >  {
> >       return 0;
> > @@ -10129,7 +10166,35 @@ preempt_sync(struct rq *rq, int wake_flags,
> >  }
> >
> >  /*
> > - * Preempt the current task with a newly woken task if needed:
> > + * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> > + * in the inverse case).
> > + */
> > +static inline enum preempt_wakeup_action
> > +wakeup_preempt_sched_idle(struct sched_entity *cse, struct sched_entity *pse)
> > +{
> > +     int cse_is_idle, pse_is_idle;
> > +
> > +     find_matching_se(&cse, &pse);
> > +     WARN_ON_ONCE(!pse);
> > +
> > +     cse_is_idle = se_is_idle(cse);
> > +     pse_is_idle = se_is_idle(pse);
> > +
> > +     /*
> > +      * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> > +      * in the inverse case).
> > +      */
> > +     if (cse_is_idle && !pse_is_idle)
> > +             return PREEMPT_WAKEUP_RESCHED;
> > +
> > +     if (cse_is_idle != pse_is_idle)
> > +             return PREEMPT_WAKEUP_NONE;
> > +
> > +     return PREEMPT_WAKEUP_PICK;
> > +}
> > +
> > +/*
> > + * Preempt the current task with a newly woken task if needed.
> >   */
> >  static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_flags)
> >  {
> > @@ -10137,7 +10202,6 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
> >       struct task_struct *donor = rq->donor;
> >       struct sched_entity *nse, *se = &donor->se, *pse = &p->se;
> >       struct cfs_rq *cfs_rq = &rq->cfs;
> > -     int cse_is_idle, pse_is_idle;
> >
> >       /*
> >        * XXX Getting preempted by higher class, try and find idle CPU?
> > @@ -10174,22 +10238,14 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
> >       if (!sched_feat(WAKEUP_PREEMPTION))
> >               return;
> >
> > -     WARN_ON_ONCE(!pse);
> > -
> > -     cse_is_idle = se_is_idle(se);
> > -     pse_is_idle = se_is_idle(pse);
> > +     preempt_action = wakeup_preempt_sched_idle(se, pse);
> >
> > -     nse = se;
> > -     /*
> > -      * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> > -      * in the inverse case).
> > -      */
> > -     if (cse_is_idle && !pse_is_idle)
> > +     if (preempt_action == PREEMPT_WAKEUP_RESCHED)
> >               goto preempt;
> >
> >       update_curr_fair(rq);
> >
> > -     if (cse_is_idle != pse_is_idle)
> > +     if (preempt_action == PREEMPT_WAKEUP_NONE)
> >               goto update;
> >
> >       /*
>
> What is the actual semantics of cpu.idle nonsense? Why do we care about
> this common ancestor?

AFAICT, cpu.idle applied to one level and against entities at the same level

>
> Can't we do any of:
>
>  - propagate cfs_rq->idle to all child groups in sched_group_set_idle(); or
>
>  - have se_is_idle() walk up and report true if any of the ancestors is
>    idle?

I'm fine with either way but this will change the behavior.

>
> I despise this find_matching_se() thing and was so very glad to have
> deleted it.

+1

>
