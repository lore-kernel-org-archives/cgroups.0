Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792590119;
	b=PBLoCeHJV1sPUzuQ2we0CL+erYfLC2VU9OW20VAEcjUlSBcnCExa9HWrze4g9lztuCFb
	 eKgVsU1kruwvWJokNn/5naddN/O+5f4ibK6H8wDLLKN8eYWMgxR1pIax96NRqNr90WheZ
	 FOZUnkX/Qv/ZHDeH7WfNBClm8qHCtC2Y0Op25LpL6STyUs0f6SGHQxUBmLAewvWxIeeDW
	 f1e5CnfIhEt9iFovJ4SaoSu7d4FQJfcANTkK2yPdobM8z38/9RbHCNt4H9WlFwfXBqeoT
	 PglgTabBLIgrZIkfzNa31GZm85zXWwj7DXNEkcQzK3an6eWGOQ7l2SLFc/F2uAPA6Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590119;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ywqdoksWZOxBEsKjGYaWE7dzHDWPLk7jVmwHHRaLveU=;
	b=sfPKAIvuntmXizQwCc/jvQuCLUPHCra2f3MZuSeUdrrMBQWbnxdm5wIyysUDcp7ugdo+
	 Ewk/8s2iU+QCGzicvC5AQroEI6q13dcrq+ALVtxSHrWu2a7LSsgi/wo/atzy0/e7byRRc
	 KryTHAYaC6xQGr4vzvz1D4qp5cHjn8ubo53n6y6BlQ6anUBaLO0aNIPagEWAqawLNUcId
	 uJtj3fGlvhThd44OpxeBRgoV3RfFthg20hcV2HSJwlpXnGlHvizFxEBpMFAkTiHraZTW+
	 B+crqtqEYdd+5Am1iFsDwFL+BjlRUDqGatKY/w8/6m+0kQ1HFH2o2kzN2cUNacBSByw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cTNWLBv5;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A88606A31A
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 13:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42A88606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cTNWLBv5
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48bbb06f29bso98578f8f.3
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 06:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792590117; x=1793194917; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ywqdoksWZOxBEsKjGYaWE7dzHDWPLk7jVmwHHRaLveU=;
        b=cTNWLBv5u68Vm7ONZtq4Wi1HY7JigVi2CND5dATmJc2Xmfv1aqkpcV/IdAGk8nNs0J
         Zlhl+I/Z4r/YuMhgN+b8Btty3GH/MrOQyXKcF9XSgei7yYx0pwULvm6VeGZZBJVjWGw/
         d2pE/+cyLXtWIHjNnuDP560OVo5VhgLIWBy+einGtgZoulAcJneyHbOUIluyxmZTj2cr
         oZhUxxASTAPVVqnl01VyHP9bYEVNWx5KZTQ8mnYCjgYiRyWoAXKm8w/2sUZ67RVn9ctX
         /zBSc2EIQtw04L8vyHcdekZ6C5BlFqiL9MdixyMV5IDiDn7qNoRG6HKMVd3xQeHgfj6/
         j61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792590117; x=1793194917;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ywqdoksWZOxBEsKjGYaWE7dzHDWPLk7jVmwHHRaLveU=;
        b=JPdN/Fbgtdrlh8FFQcC3t3Asla2bezsug22EbM3jgpp5zq9X1mVc+KYNgZIuG+GQDi
         lpuhwsxYl+qsFJYS+e/t34nSH+/72zL/xTKBvuxltHV4aZlHxtqq4W2UCwYpsnBabC0F
         G1GKNpOHghGkasQKgghRYZmAb2453FDZPobAjy1m7v8bGlmMEIyb5n/BmcFLSb7F24uf
         NG3s4U8mm8L4UfchinaOV1C1CQnHVFLjqLfZuhdLLc6ceX0oYpG3l0dks9BD49guJ5Oc
         b/9OyTsCSa7mxmqec3LbSNu0sBjyxaGLfOtCz5SXft24z+lFrWbOPQdNemSAmHmQ5hVA
         J9xg==
X-Forwarded-Encrypted: i=1; AKwUvBx/Dcmu/2Bd91sUhZpFFts0VCxr2FOj9iILBeLGyf1L/3MA4lM7FINyifSySz6z+FXLa6QfmCh9@vger.kernel.org
X-Gm-Message-State: AFq9FYIJRGo/fTiOiNfb+SXwWexbp1CL1kwbQUFMoQ+o8d36WEUTjDz7
	Rzkyq2qEizj8GdzMnVqpowW0Ne2E04aUUlrpRfosdna1U6a5kG9JK4If
X-Gm-Gg: AYBFou3iLF6fsbw/eUywTdRRUqUh1hbJrBAOFSA4CgbEiVsMsmS8xP8KlJnUuJ6E5oy
	usbgC+LHDqN4psvqlGE6bgSv/Wxz/XJPyNYfRdtH7q8Gh0jTkTS0DjUVafiayJfKBB26PLIBLdz
	pDGnsVVhpWd/r/8BfH3208CJ/hRaqLH7zeqeVjg1ixXF3GLPNYI40kv4O869aoiD/tuzSflmsJ7
	kWYs0RiZDnMWHYyBnCwArMk7YVtKtxZofzfdoASiNdjCb9p1GB/wFVGXr9VX08ooS2umSpSFGLZ
	KoDj3Ukm12YWf9SE3N7r8vTW8GEVKi0LUN2z/Y3s6y6nVVNn72Mq/U8H13cqRJh/fRr7Ewy872Q
	pVvB0B9KN4J9iVN0eu4QvoKO0u7exnweWH2MElm0P7n2GH1vLnMPzLbWEkEasx9tominuwUjQsQ
	jeep9twhpPD9ZhYu6uJvxbEU/gBDY22JnsLYUzJD4C6Ag2miSY5SQKxlsgFIVpLv+D2rVEz+kST
	8nk6bqhs9syb6p27U/TS2USAvBjR8rYrzPrj2psbpXJehBUMzyRbGu/K2Tt45qz71UrYxWM1H99
	3lUoqbg=
X-Received: by 2002:a5d:68d2:0:b0:48d:f9c1:2ad4 with SMTP id ffacd0b85a97d-48e264c4036mr2820239f8f.4.1792590116806;
        Wed, 21 Oct 2026 06:41:56 -0700 (PDT)
Received: from scheduler.schedules ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25835e22sm6317584f8f.44.2026.10.21.06.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 06:41:56 -0700 (PDT)
Date: Wed, 21 Oct 2026 16:41:52 +0300
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, 
	juri.lelli@redhat.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-kernel@vger.kernel.org, jakub@okonski.org, longman@redhat.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org, jstultz@google.com, 
	qyousef@layalina.io
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
Message-ID: <ati_o5c-SoiOp529@scheduler.schedules>
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
 <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
 <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
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
In-Reply-To: <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>

On Wed, Oct 21, 2026 at 03:32:59PM +0200, Vincent Guittot wrote:
> On Wed, 21 Oct 2026 at 15:13, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Mon, Oct 19, 2026 at 08:26:22PM +0200, Vincent Guittot wrote:
> > > Even with flat hierarchy which puts all runnable tasks in the same cfs rq,
> > > we need to parse the hierarchy to check for sched_idle task group.
> >
> > I F'ing hate cgroups :-(
> >
> >
> > > +static void
> > > +find_matching_se(struct sched_entity **se, struct sched_entity **pse)
> > > +{
> > > +     int se_depth, pse_depth;
> > > +
> > > +     /*
> > > +      * preemption test can be made between sibling entities who are in the
> > > +      * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
> > > +      * both tasks until we find their ancestors who are siblings of common
> > > +      * parent.
> > > +      */
> > > +
> > > +     /* First walk up until both entities are at same depth */
> > > +     se_depth = (*se)->depth;
> > > +     pse_depth = (*pse)->depth;
> > > +
> > > +     while (se_depth > pse_depth) {
> > > +             se_depth--;
> > > +             *se = parent_entity(*se);
> > > +     }
> > > +
> > > +     while (pse_depth > se_depth) {
> > > +             pse_depth--;
> > > +             *pse = parent_entity(*pse);
> > > +     }
> > > +
> > > +     while (!is_same_group(*se, *pse)) {
> > > +             *se = parent_entity(*se);
> > > +             *pse = parent_entity(*pse);
> > > +     }
> > > +}
> > > +
> > >  static int tg_is_idle(struct task_group *tg)
> > >  {
> > >       return tg->idle > 0;
> > > @@ -476,6 +508,11 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
> > >       return NULL;
> > >  }
> > >
> > > +static inline void
> > > +find_matching_se(struct sched_entity **se, struct sched_entity **pse)
> > > +{
> > > +}
> > > +
> > >  static inline int tg_is_idle(struct task_group *tg)
> > >  {
> > >       return 0;
> > > @@ -10129,7 +10166,35 @@ preempt_sync(struct rq *rq, int wake_flags,
> > >  }
> > >
> > >  /*
> > > - * Preempt the current task with a newly woken task if needed:
> > > + * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> > > + * in the inverse case).
> > > + */
> > > +static inline enum preempt_wakeup_action
> > > +wakeup_preempt_sched_idle(struct sched_entity *cse, struct sched_entity *pse)
> > > +{
> > > +     int cse_is_idle, pse_is_idle;
> > > +
> > > +     find_matching_se(&cse, &pse);
> > > +     WARN_ON_ONCE(!pse);
> > > +
> > > +     cse_is_idle = se_is_idle(cse);
> > > +     pse_is_idle = se_is_idle(pse);
> > > +
> > > +     /*
> > > +      * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> > > +      * in the inverse case).
> > > +      */
> > > +     if (cse_is_idle && !pse_is_idle)
> > > +             return PREEMPT_WAKEUP_RESCHED;
> > > +
> > > +     if (cse_is_idle != pse_is_idle)
> > > +             return PREEMPT_WAKEUP_NONE;
> > > +
> > > +     return PREEMPT_WAKEUP_PICK;
> > > +}
> > > +
> > > +/*
> > > + * Preempt the current task with a newly woken task if needed.
> > >   */
> > >  static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_flags)
> > >  {
> > > @@ -10137,7 +10202,6 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
> > >       struct task_struct *donor = rq->donor;
> > >       struct sched_entity *nse, *se = &donor->se, *pse = &p->se;
> > >       struct cfs_rq *cfs_rq = &rq->cfs;
> > > -     int cse_is_idle, pse_is_idle;
> > >
> > >       /*
> > >        * XXX Getting preempted by higher class, try and find idle CPU?
> > > @@ -10174,22 +10238,14 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
> > >       if (!sched_feat(WAKEUP_PREEMPTION))
> > >               return;
> > >
> > > -     WARN_ON_ONCE(!pse);
> > > -
> > > -     cse_is_idle = se_is_idle(se);
> > > -     pse_is_idle = se_is_idle(pse);
> > > +     preempt_action = wakeup_preempt_sched_idle(se, pse);
> > >
> > > -     nse = se;
> > > -     /*
> > > -      * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> > > -      * in the inverse case).
> > > -      */
> > > -     if (cse_is_idle && !pse_is_idle)
> > > +     if (preempt_action == PREEMPT_WAKEUP_RESCHED)
> > >               goto preempt;
> > >
> > >       update_curr_fair(rq);
> > >
> > > -     if (cse_is_idle != pse_is_idle)
> > > +     if (preempt_action == PREEMPT_WAKEUP_NONE)
> > >               goto update;
> > >
> > >       /*
> >
> > What is the actual semantics of cpu.idle nonsense? Why do we care about
> > this common ancestor?
> 
> AFAICT, cpu.idle applied to one level and against entities at the same level
>

Yeah. Like on here:

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

If GA is idle and GB is not, while GC is idle and were looking to TA and
TB we gotta choose TB. But if we just look to GC and GA we would choose
neither. .idle just applies to one level as Vincent says.

> >
> > Can't we do any of:
> >
> >  - propagate cfs_rq->idle to all child groups in sched_group_set_idle(); or
> >
> >  - have se_is_idle() walk up and report true if any of the ancestors is
> >    idle?
> 
> I'm fine with either way but this will change the behavior.
> 

So is it good or bad to change the behavior in this case? If we don't
want to change it are there any cleaner way? Well I can't find any.

> >
> > I despise this find_matching_se() thing and was so very glad to have
> > deleted it.
> 
> +1
> 
> >
