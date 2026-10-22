Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792691392;
	b=3ffUKlvKqE27mUxni4dsrm3rSLwhs3Wsa0Jkn6NroUStgV6G64Sw1tpdXhXu+fVHo6z6
	 7aJC8jyN/WOdACb9Ws7oBWcmrvwdT5eOwdpecxCRzsLk/66OItdxbEIy7OReXPA8kQSKQ
	 sgS/6QGqYEZNBdDl7NN8L/iU7fI03eluNhn5qfyJrkRBCUoLACxZHnl4bPJZMfOkl9nwu
	 ZNknI7BuUvIeUDhR2HCJaujUxroNuMUb/Wx01nC1+BWyKFtWLZ2GkUwiVMNc2RHpNcLBm
	 /Gwvdy1Q0CBASn8HK03S1pfifVG8PIFyYNcqhbfaRG+dc+Wi60ZVypg01oaKZ1Pe/Bw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YwUU5llaVxHh9xPyzzxrFtLQ5vm0PkgX5FJfwLMxXVA=;
	b=KvLMwMVhPTkVaevvjS3ZuOLOPcByoKl1lezfVE10Jl9m/R9DqmWkFmb79OxNALmvQqj1
	 vCqLVKHx3O996qF7zLvk6oOC/e7F20+XIoCRfkY7Wm16DTi+MjJRrWYFTWyWmuPdGaP+J
	 VXr/iWis9NJcNK5jDy1pP3Od1IiNAoExq/dm8/4elaWiAT1PywRGEm4nSB3xeh8dFZAfM
	 XpVETjw3lQa12W4MGMoku3LOC5GB4TLNzmvjJ9HDkBjzrywtIULk9HVRzzDw+54sSzlkv
	 EaeEYC4SfwmKhyNIVjV1B8LRPFvHm9alU5ilD7NqIX1hNFhGUHr5KEYkQv+S7zyqVCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=JDIpGEmn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A4606A31A
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 17:49:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B3A4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=JDIpGEmn
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so430e87.1
        for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 10:49:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792691390; cv=none;
        d=google.com; s=arc-20260327;
        b=li967Rkn8lnzvENbAS7gpVxMH4+l4EWxOx3v3yskCY4idQmAVoOwsG55lElG7K+dvD
         vn4XJu1d+vT1JuTlmUriHiRcIpdP5kFDecw5zRqYmIb7XBOEvvk6q3FOgmADydNaMnnk
         fKNwHHywm+6FREBLQPIxUZjHkkC0B9q1xi6UVrxnThHf004DhPKfmVHGWY+WQTZIu1aj
         0NcabnfH/9Vlg/E8heMAsE6+XoY6d8h7038D+OpbjeUAd0Jn6T9DxXju4fYF1HuimYWS
         s+uizSnPvj19OzukXt1QllUAhe2zV/ZbNk0j9Cp8TwqzouqsSN//a3jjMHl7ATuGkJ2I
         rNUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YwUU5llaVxHh9xPyzzxrFtLQ5vm0PkgX5FJfwLMxXVA=;
        fh=oV2k9Eu7/8qHVc7s/NaXrCfXfLaDiPsvJ3RKMQWTQUk=;
        b=Rmsjz7FrD8t0XX5I+1GI9sqJ+WYZWmDM9wqquQfGBvWEUblq/ikZBo4T+edrdVXf25
         a6Kit5B1Kykwwuq3OLscUB+Z6Hrk8E+tT6Ye5RWgW9MujtG70VB0g612WNnyv4U/gS/u
         R1F3cQh9WNZg066UVUk2+UAIpA9VQbAZ5OIGoyrXcetRM2dcj2/og/dhZzRZgfEFQLu+
         W0wAVUJL4vRnH8v8l/hezWQQBAbxfasAwLml93u1eC33nHWWShBNOvm1Rr6ILkTLb430
         Ewg6GNnG/OsyXDG6Utgj1mSc87cKEutTNOfGo6s0XyAODT8+o+9sJY+EMjz7UBKQDLmh
         EUdw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792691390; x=1793296190; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YwUU5llaVxHh9xPyzzxrFtLQ5vm0PkgX5FJfwLMxXVA=;
        b=JDIpGEmnXvCMMIIcjx6Eci8J5IFTPVQCKStz+ctddlVN+EpHzVJRZ63nHg+u5WK8oI
         ukaXIwZAqmFLKmiaTa1ZfLwJCplo+kyyjWK4LuleAY+JheWHHFijWxIRVLdxbsMvYpVP
         kvT++FymsNLvtrsCbd+ewc6bjrES5p9twrK1UI0DTo+RxCgiMYXnnzYo3QBDU5NEqcvt
         D4AEi2yb1EYIZZ6PP9DaKoR2HKVSkvTHL+sTRlDfpKsRvA9kEVB9u7kORQdzcjM/07bM
         EkukujjnkKFgc0RSFJnHVQ4xIbpJRLXkNrKga1/giE3uSq50wMhM9/+mxfq6lBr7I7LX
         wspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792691390; x=1793296190;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YwUU5llaVxHh9xPyzzxrFtLQ5vm0PkgX5FJfwLMxXVA=;
        b=R+NDA32kNP22dMSJKiLFaNIpGzCzPdyCzN8VWWVtcgkX5StRMFoCJyVf+NFlzq8XPc
         orPT/+rumUNi6uN3vQKGuOMBz0prcELhG4r6kGmxUxA4SjyHQd2V1KkpkPRGx7Bc41a9
         8G+w9BpPbzaswKylzD5h67nNUXqizbGyrGG5kfeU9wy3+Z0K6Jk1/S4KcgSi4utIX7cq
         i7uC64XDjwW+Ey+dlCJH+ais56qsZaVillGjwS4vAqQEFzi/NIxrxtnBAe20xwhwjFSO
         KEqX5RnROTVcYyk3/ZgD6yBLPiG57VTrXWVPrLl5uWt0jYlezH0T23IpAfXS2gl57lrM
         v1CQ==
X-Forwarded-Encrypted: i=1; AKwUvBwa+8MuUQoiId29LDq8PkiyCyPGoOaPGUK+uBMGEZMMi8YiCjHsCDg7Uo/S4rAU8W885zyWsmBO@vger.kernel.org
X-Gm-Message-State: AFq9FYJeSW0qhYbp9BVI3OHGm62C34bt3fAsGUENAJZdWY6Z0higGvj/
	hvFf4aurcfpNUF7J7V9JpWkNGl97DE9SKcKsc32/p4OfnZADS+i/YYFP3HacE/gIfAFYqzxqdVn
	J1CNssQCt67OxR91n5Iee1A/NBqPikfGKJqvxWJbK
X-Gm-Gg: AYBFou2YBGyO4CjK0ox3dA5TlZDmMyG/mW5S6g+VMNoU9UvDt+pzvGshFoYvmUspDGy
	hyhwDo+mDHMFHLipkllrxZyuWV3hu+pzeQ3M4bU5afHl1hDKbzHJdeexjIDcuFkDrsCFo2m5KQk
	iJup/Q3h2JJXasatJWp5LJNa/FDxiW7KvTLvQsjOftfdC+WtXgrqfhl180KCKAqBeMiLXPs8fiq
	VZygxLDrBGHg6dU2IoSJpV8GxaqQ1eKtQ1Gq819qv/hqDCB3T0348VuLNJO17EqOZMu0Y61rKxF
	BKxvygXJQWFM61WgR8Q4ZsP02jXV78GsjPJ08ZrN8djLlQXdMqLInWRuSetJAZAcSDvb5Xij5L5
	Ap3GhFs7K0lXwZphmdVwY7YRClDlbEOyful3H/FClq/qKcGfcB2YSxBRr4JZoUys4eb1Sqg==
X-Received: by 2002:a05:6512:3f15:b0:5b7:6707:e44c with SMTP id
 2adb3069b0e04-5bfb00c65abmr2700e87.12.1792691388576; Thu, 22 Oct 2026
 10:49:48 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
 <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
 <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
 <ati_o5c-SoiOp529@scheduler.schedules> <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>
 <CABk29Nv2ZzB1KGEuPmx4VmxTJ6pKmikGMr8cvzzDhHZSKpkgvg@mail.gmail.com> <20261022114705.GW88198@noisy.programming.kicks-ass.net>
In-Reply-To: <20261022114705.GW88198@noisy.programming.kicks-ass.net>
From: Josh Don <joshdon@google.com>
Date: Thu, 22 Oct 2026 10:49:36 -0700
X-Gm-Features: AclHuK9wX5DupT_MOWjlFRzljvX9p-nmpLPmso8ADHLanWwUB5ZN_75eF8Vy_X4
Message-ID: <CABk29NviVUAK6B_deQ7qah8eABiCikbFpTwDEO2hdproGLdLwQ@mail.gmail.com>
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kayra Cizmeci <kayracizmeci@gmail.com>, Vincent Guittot <vincent.guittot@linaro.org>, mingo@redhat.com, 
	juri.lelli@redhat.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, jakub@okonski.org, 
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 4:47=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Wed, Oct 21, 2026 at 09:39:52AM -0700, Josh Don wrote:
> > On Wed, Oct 21, 2026 at 7:50=E2=80=AFAM Peter Zijlstra <peterz@infradea=
d.org> wrote:
> > >
> > > On Wed, Oct 21, 2026 at 04:41:52PM +0300, Kayra Cizmeci wrote:
> > > > On Wed, Oct 21, 2026 at 03:32:59PM +0200, Vincent Guittot wrote:
> > > > > On Wed, 21 Oct 2026 at 15:13, Peter Zijlstra <peterz@infradead.or=
g> wrote:
> > >
> > > > > > What is the actual semantics of cpu.idle nonsense? Why do we ca=
re about
> > > > > > this common ancestor?
> > > > >
> > > > > AFAICT, cpu.idle applied to one level and against entities at the=
 same level
> > > > >
> > > >
> > > > Yeah. Like on here:
> > > >
> > > >     ROOT
> > > >      /\
> > > >     /  \
> > > >    /    \
> > > >   GA*   GB
> > > >    |    /\
> > > >    V   /  \
> > > >   TA  GC*  GD
> > > >       |    |
> > > >       V    V
> > > >       TB   TC
> > >
> > > (marked GA and GC with * to denote their 'idleness')
> > >
> > > > If GA is idle and GB is not, while GC is idle and were looking to T=
A and
> > > > TB we gotta choose TB. But if we just look to GC and GA we would ch=
oose
> > > > neither. .idle just applies to one level as Vincent says.
> > >
> > > Yeah, that's what we used to do, but the more I think about this, the
> > > less sense it makes!
> > >
> > > Josh added this (added to Cc now), but we have a number of Google fol=
ks
> > > on Cc already. It would be good to hear how this is actually used.
> > >
> > >
> > > So in your example TA and TB are both inside an idle group, and
> > > therefore one can argue their behaviour should be like !idle. But the=
ir
> > > common ancestor is root, and so the fact that they're contained in id=
le
> > > groups gets lost (which seems crazeh).
> >
> > TA and TB have a matching se of GA and GB, since those entities are
> > siblings under the common ancestor. Since GB is not idle but GA is, I
> > would argue that TB should preempt TA.
>
> So I find this 'weird', at the end both TA and TB are marked idle,
> albeit at different levels in the hierarchy. And yes, with the old code
> this would lead to TB preempting TA, but I really don't see why that's a
> good thing.

It is marked idle relative to where it is positioned in the hierarchy.

It's the same reason why modifying the cpu.weight of GC or the
niceness of TB makes no difference to the relative runtime of TA and
TB; the competition there is dictated by the weights of GA vs GB.

In the same way that cpu.weight is a cgroup relative property, so too
is the intent with cpu.idle.

>
> > Consider GA and GB as groups representing different users, and user GB
> > has internally decided to create an idle cgroup GC to adjust
> > competition between its own tasks (TB and TC). This should not affect
> > GB's overall preemption ability against other users.
>
> It doesn't; TC is not idle and will preempt just fine. But by marking
> GB, and thus TB, as idle, we basically say we don't care about it, so
> preempting should also be irrelevant.
>
> Consider this:
>
>      ROOT
>       /\
>      /  \
>     /    \
>    GA*   GB
>     |    /\
>     V   /  \
>    TA  GC*  GD
>        |    |
>        v    V
>        GE   TB
>        /\
>       /  \
>      TC   TD
>
> Suppose TC runs and TD wakes, with the strict LCA rules we'd find that
> neither is idle and have one preempt the other. Even though they're well
> part of an 'idle' sub-tree.
>
> > However in practice doing the exact computation to determine
> > preemption for relative idle properties (especially on wakeup) is
> > expensive and perhaps not strictly required. This is also why e.g. the
> > whole sched_idle_rq stuff is imprecise. We keep an overall tally of
> > the number of tasks that have a cpu.idle ancestor cgroup and use that
> > for wakeup placement, but if we were trying to be perfect we would
> > need to consider the matching_se stuff for that as well. What I'd say
> > there though is that imprecise placement is better than imprecise
> > preemption.
> >
> > So overall, I would say the find_matching_se() stuff gives the more
> > ideal preemption decision; my first preference would be to keep it. It
> > avoids a regression with users who delegate cpu.idle internally within
> > their own cgroup hierarchy. FWIW wakeup preemption already does a
> > cgroup ancestor walk via update_curr; find_matching_se is similar in
> > spirit.
>
> So its probably not the end of the world -- and we sort of still have
> one in put_prev_task_fair(), but still, I find the semantics weird.
>
> > But to be clear I also don't think it would be terrible if we did
> > something like you suggest, cache whether a cgroup has _any_ cpu.idle
> > ancestor and then just make a single decision on wakeup comparing this
> > for the two tasks. The result of which is TC preempts T{AB}, but TA
> > and TB don't preempt each other. In which case I would suggest we
> > cache that as a part of updating cpu.idle so that we can avoid a
> > pointer chasing loop in se_is_idle().
>
> Just so. Let me try and implement that, see how horrible it looks.
>
> > Either of these two will at least also restore some semblance of
> > respecting cgroup cpu.idle in wakeup, as the flattening made it only
> > consider task level SCHED_IDLE.
>
> Right; I agree the current situation is somewhat broken.
>
> Something like so ...
>
> ---
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b5546cd27dba..779fcd5a2830 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -15767,6 +15767,40 @@ int sched_group_set_shares(struct task_group *tg=
, unsigned long shares)
>         return ret;
>  }
>
> +struct tg_set_idle_struct {
> +       long idle;
> +       int cpu;
> +};
> +
> +static int tg_set_idle_up(struct task_group *tg, void *data)
> +{
> +       struct tg_set_idle_struct *tsi =3D data;
> +       struct cfs_rq *grp_cfs_rq =3D tg_cfs_rq(tg, tsi->cpu);
> +       struct sched_entity *se =3D tg_se(tg, tsi->cpu);
> +       int old_idle =3D grp_cfs_rq->idle;
> +       long task_delta;
> +
> +       grp_cfs_rq->idle +=3D tsi->idle;
> +
> +       if (!!old_idle =3D=3D !!grp_cfs_rq->idle)
> +               return 0;
> +
> +       task_delta =3D grp_cfs_rq->h_nr_queued - grp_cfs_rq->h_nr_idle;
> +       if (!task_delta)
> +               return 0;
> +
> +       task_delta *=3D tsi->idle;
> +
> +       for_each_sched_entity(se) {
> +               if (!se->on_rq)
> +                       break;
> +
> +               cfs_rq_of(se)->h_nr_idle +=3D task_delta;
> +       }
> +
> +       return 0;
> +}

Took me a bit to parse this double traversal. I think this is broken
for the clear side?

root
  |
 A ( 2 tasks)
 |
 B (3 tasks)

If we start out with A marked as idle, then we have
root: h_nr_idle =3D 5
A: h_nr_idle =3D 3
B: h_nr_idle =3D 0

When we clear, we'll first start with B and subtract 3...
root: h_nr_idle =3D 2
A: h_nr_idle =3D 0
B: h_nr_idle =3D 0

Then we go to A and try to subtract 5 leading to
root: h_nr_idle =3D -3

> +
>  int sched_group_set_idle(struct task_group *tg, long idle)
>  {
>         int i;
> @@ -15777,49 +15811,22 @@ int sched_group_set_idle(struct task_group *tg,=
 long idle)
>         if (idle < 0 || idle > 1)
>                 return -EINVAL;
>
> -       mutex_lock(&shares_mutex);
> -
> -       if (tg->idle =3D=3D idle) {
> -               mutex_unlock(&shares_mutex);
> +       guard(mutex)(&shares_mutex);
> +       if (tg->idle =3D=3D idle)
>                 return 0;
> -       }
>
>         tg->idle =3D idle;

Now that we have a hierarchical count of idle, a nice option here
could be to still keep find_matching_se() for the accurate preemption
checking as described earlier, but only invoke if at least one of the
two tasks has any idle ancestor.

>
>         for_each_possible_cpu(i) {
>                 struct rq *rq =3D cpu_rq(i);
> -               struct sched_entity *se =3D tg_se(tg, i);
> -               struct cfs_rq *grp_cfs_rq =3D tg_cfs_rq(tg, i);
> -               bool was_idle =3D cfs_rq_is_idle(grp_cfs_rq);
> -               long idle_task_delta;
> -               struct rq_flags rf;
>
> -               rq_lock_irqsave(rq, &rf);
> +               guard(rq_lock_irqsave)(rq);
>
> -               grp_cfs_rq->idle =3D idle;
> -               if (WARN_ON_ONCE(was_idle =3D=3D cfs_rq_is_idle(grp_cfs_r=
q)))
> -                       goto next_cpu;
> -
> -               idle_task_delta =3D grp_cfs_rq->h_nr_queued -
> -                                 grp_cfs_rq->h_nr_idle;
> -               if (!cfs_rq_is_idle(grp_cfs_rq))
> -                       idle_task_delta *=3D -1;
> -
> -               for_each_sched_entity(se) {
> -                       struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
> -
> -                       if (!se->on_rq)
> -                               break;
> -
> -                       cfs_rq->h_nr_idle +=3D idle_task_delta;
> -
> -                       /* Already accounted at parent level and above. *=
/
> -                       if (cfs_rq_is_idle(cfs_rq))
> -                               break;
> -               }
> -
> -next_cpu:
> -               rq_unlock_irqrestore(rq, &rf);
> +               struct tg_set_idle_struct tsi =3D {
> +                       .idle =3D idle ? 1 : -1,
> +                       .cpu =3D i,
> +               };
> +               walk_tg_tree_from(tg, tg_nop, tg_set_idle_up, &tsi);
>         }
>
>         /* Idle groups have minimum weight. */
> @@ -15828,7 +15835,6 @@ int sched_group_set_idle(struct task_group *tg, l=
ong idle)
>         else
>                 __sched_group_set_shares(tg, NICE_0_LOAD);
>
> -       mutex_unlock(&shares_mutex);
>         return 0;
>  }
>
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 499a5649582e..06bcee5bb89f 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -751,7 +751,7 @@ struct cfs_rq {
>         struct list_head        leaf_cfs_rq_list;
>         struct task_group       *tg;    /* Group that "owns" this runqueu=
e */
>
> -       /* Locally cached copy of our task_group's idle value */
> +       /* Sum of all ancestor tg->idle. */
>         int                     idle;

Since this is a sum of ancestors, we'd need to also now set it on
cgroup creation

>
>  # ifdef CONFIG_CFS_BANDWIDTH
