Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3B34AF16B
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 21:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384579; cv=none; b=bPeKzIaYMYuv/ePuU1LQDUwUW1+jPZa1EaKbfAxKnW6OzKrTf9j7ZAT64Q1XOnyL9S5rh6ghR3I4hf/C820XyqlWnt0aXOB2/xEKbl5Ms5JXCgwwR3mAXJcIsLmVaEJB6hkQ5jo4fGXnW9Y7Z9cTBzWwyodo/yzyzKvnbNVVUoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384579; c=relaxed/simple;
	bh=SLpsL7aewllAQXYeJ6oHpWTSORAK7QcTH4xYlx0kwyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QIGZHgjRX7eatNaOSn7Ohv+IRMFyoTQFnXyPA1O0UW9IQIk58nlJ7rl1B4iCN7NIu9Vak2Li50uGHbW6bh0qYY3mz9DvAN5KmhIPgkETz2dRSHY+r8b9TqfCChggiYdfUMu/0eGacAZOBd5mPBngOVg02WS1AMpveztXC7J6P3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqkZ7iNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqkZ7iNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EE21F00A3F
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 21:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788384566;
	bh=lOFFuLPw3HeacpN5FBG2k3Uyd7RtjFEI844Ov3f+DbU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hqkZ7iNfqvprmKbYG32MTYOoeUESENp1IRZj7TkRgavZh+8Cm5PqHVlKtfpt0krkH
	 BY6iPAzstLXeUbya/r9y0/o8LifIVfISwbzpa006ebqdXW0WkIAlJpcwIw25xJ/goY
	 YDI+WGGw0s1dtrC2vQIwWCATWM0wmG8YmIgFnjzS16mkgPJxh0PW9G7pNLKKv65GuE
	 S0f/D3knnDjOxpKpQHNuzXZGoTGJWKs9XnKTZ4OmPo/89Gkr/Ub9JDPumtXyHbved0
	 e8pUt6MFBMua/rHpczETuLkJP4M8M1NNdfjGX3c9Ak75edasarB9itVtLaF15RC3m8
	 xTccToANStutA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1712a04ddaso260650066b.2
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 14:29:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxRreWTnMwqGXBvzER3w8w/R5y7d2315q9vq4mviek7aO5Ota8OOYLYybGX2lfx41olAXSCapWR@vger.kernel.org
X-Gm-Message-State: AFuF++kDcBsZX6Ohn1fynytZ88WBWrUfhn1vd6jfJwj1gqma7APb7/MT
	l2HcG6IYcQ9JkQtmYcr1YMys5wu4iohX7UBU/eqhK4I3sp8K7sa9KZRJYAluUz5WKGETHamS3Re
	F9EzyJgMVq7SdaJchh07So9bEzREMmCU=
X-Received: by 2002:a17:907:1c94:b0:c16:4df6:176b with SMTP id
 a640c23a62f3a-c25d5509d5amr471936766b.20.1788384565448; Wed, 02 Sep 2026
 14:29:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902205406.624782-1-joannelkoong@gmail.com>
In-Reply-To: <20260902205406.624782-1-joannelkoong@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 2 Sep 2026 14:29:12 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPqXkWBPbObB1ngCjUWjXJJ8sD4a7ZtfGOLQe+-NfD=zw@mail.gmail.com>
X-Gm-Features: AcwNN1W0PvOInumEIH4KfMlRHsyF0_QiPyqsuyTviCrdmyZbZoy7z9M-CghGPg8
Message-ID: <CAO9r8zPqXkWBPbObB1ngCjUWjXJJ8sD4a7ZtfGOLQe+-NfD=zw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memcontrol: skip non-hierarchical memcg-wide stats
 on the default hierarchy
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 1:56=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
> and event alongside the hierarchical one. The only readers however are
> the legacy memory.stat and memory.numa_stat, and reparenting on offline,
> which are only used when on the legacy v1 hierarchy.
>
> On the default hierarchy, memcg_vmstats's non-hierarchical arrays are
> written to on every rstat flush, despite their values never being read /
> accessed.
>
> Instead, skip non-hierarchical memcg-wide stats on the default hierarchy.
> This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
> read-modify-write of ac->local[i]. When on the default hierarchy,
> nothing else accesses state_local or events_local, so those cachelines
> were getting pulled in solely for the writes, and they are separate from
> the ones the loop is already walking / accessing.
>
> There is the unlikely case where a controller can be moved from the
> default hierarchy to the legacy v1 hierarchy at runtime, which means the
> non-hierarchical memcg-wide arrays will need to be populated with the
> correct values. This can be handled through the bind callback, which
> gets called by rebind_subsystems(). We can copy over the counters from
> the hierarchical arrays since rebinding is only allowed when the root is
> the only memcg, so the hierarchical arrays and the non-hierarchical
> arrays values should be the same.
>
> On an 80-cpu x86_64 machine with 500 cgroups each running a workload that
> dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
> counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
> flush showed roughly
>
>                          before   after    delta
> memcg-wide aggregation   1231     1180     -4.1%
> overall flush function   2452     2397     -2.2%
>
> These numbers are from taking the median of 70 samples, one per 20s
> window on each kernel. The 95% intervals observed on the two deltas are
> [-5.41%, -1.76%] and [-4.53%, -0.14%]. The values above include the
> timing overhead itself, so only the delta is meaningful here.
>
> Counting the items that actually changed, a median of 1.5 of the 77
> memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
> each flush, which means the benchmarks above are with one or two fewer
> cachelines pulled in per flush. The count is low because the benchmark
> reads memory.stat in a loop to keep the flush rate up. For cases where
> flushes are triggered only by the 2s periodic worker, more changes will
> have accumulated between flushes, so more cachelines are skipped and the
> per-flush saving should be larger.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
> v1: https://lore.kernel.org/linux-mm/20260901232834.22221-1-joannelkoong@=
gmail.com/
> Changes since v1:
>   * Change from gating on builds w/out CONFIG_MEMCG_V1 to gating on the
>     default hierarchy so CONFIG_MEMCG_V1=3Dy kernels that do not use v1 b=
enefit
>     too (Yosry)
>
>  mm/memcontrol.c | 89 +++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 82 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7ce50bccf126..196e1791c10d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -687,6 +687,29 @@ struct memcg_vmstats {
>         atomic_long_t           stats_updates;
>  };
>
> +/*
> + * The non-hierarchical memcg-wide counters are read back only by the le=
gacy
> + * memory.stat and by reparenting on offline, both of which are v1-only.
> + * They are skipped if the controller sits on the default hierarchy
> + * (mem_cgroup_bind() populates them if it is later moved onto the legac=
y
> + * hierarchy).
> + */
> +static long *memcg_state_local_array(struct mem_cgroup *memcg)
> +{
> +       if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +               return NULL;
> +
> +       return memcg->vmstats->state_local;
> +}
> +
> +static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
> +{
> +       if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +               return NULL;
> +
> +       return memcg->vmstats->events_local;
> +}
> +
>  /*
>   * memcg and lruvec stats flushing
>   *
> @@ -4468,7 +4491,10 @@ static void mem_cgroup_css_reset(struct cgroup_sub=
sys_state *css)
>  struct aggregate_control {
>         /* pointer to the aggregated (CPU and subtree aggregated) counter=
s */
>         long *aggregate;
> -       /* pointer to the non-hierarchichal (CPU aggregated) counters */
> +       /*
> +        * pointer to the non-hierarchical (CPU aggregated) counters or N=
ULL to
> +        * skip updating them (see memcg_state_local_array())
> +        */
>         long *local;
>         /* pointer to the pending child counters during tree propagation =
*/
>         long *pending;
> @@ -4507,7 +4533,7 @@ static void mem_cgroup_stat_aggregate(struct aggreg=
ate_control *ac)
>                 }
>
>                 /* Aggregate counts on this level and propagate upwards *=
/
> -               if (delta_cpu)
> +               if (delta_cpu && ac->local)
>                         ac->local[i] +=3D delta_cpu;
>
>                 if (delta) {
> @@ -4521,6 +4547,7 @@ static void mem_cgroup_stat_aggregate(struct aggreg=
ate_control *ac)
>  #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>  static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup =
*parent)
>  {
> +       long *state_local =3D memcg_state_local_array(memcg);
>         int nid;
>
>         if (atomic_read(&memcg->kmem_stat)) {
> @@ -4528,7 +4555,8 @@ static void flush_nmi_stats(struct mem_cgroup *memc=
g, struct mem_cgroup *parent)
>                 int index =3D memcg_stats_index(MEMCG_KMEM);
>
>                 memcg->vmstats->state[index] +=3D kmem;
> -               memcg->vmstats->state_local[index] +=3D kmem;
> +               if (state_local)
> +                       state_local[index] +=3D kmem;
>                 if (parent)
>                         parent->vmstats->state_pending[index] +=3D kmem;
>         }
> @@ -4550,7 +4578,8 @@ static void flush_nmi_stats(struct mem_cgroup *memc=
g, struct mem_cgroup *parent)
>                         if (plstats)
>                                 plstats->state_pending[index] +=3D slab;
>                         memcg->vmstats->state[index] +=3D slab;
> -                       memcg->vmstats->state_local[index] +=3D slab;
> +                       if (state_local)
> +                               state_local[index] +=3D slab;
>                         if (parent)
>                                 parent->vmstats->state_pending[index] +=
=3D slab;
>                 }
> @@ -4563,7 +4592,8 @@ static void flush_nmi_stats(struct mem_cgroup *memc=
g, struct mem_cgroup *parent)
>                         if (plstats)
>                                 plstats->state_pending[index] +=3D slab;
>                         memcg->vmstats->state[index] +=3D slab;
> -                       memcg->vmstats->state_local[index] +=3D slab;
> +                       if (state_local)
> +                               state_local[index] +=3D slab;
>                         if (parent)
>                                 parent->vmstats->state_pending[index] +=
=3D slab;
>                 }
> @@ -4588,7 +4618,7 @@ static void mem_cgroup_css_rstat_flush(struct cgrou=
p_subsys_state *css, int cpu)
>
>         ac =3D (struct aggregate_control) {
>                 .aggregate =3D memcg->vmstats->state,
> -               .local =3D memcg->vmstats->state_local,
> +               .local =3D memcg_state_local_array(memcg),
>                 .pending =3D memcg->vmstats->state_pending,
>                 .ppending =3D parent ? parent->vmstats->state_pending : N=
ULL,
>                 .cstat =3D statc->state,
> @@ -4599,7 +4629,7 @@ static void mem_cgroup_css_rstat_flush(struct cgrou=
p_subsys_state *css, int cpu)
>
>         ac =3D (struct aggregate_control) {
>                 .aggregate =3D memcg->vmstats->events,
> -               .local =3D memcg->vmstats->events_local,
> +               .local =3D memcg_events_local_array(memcg),
>                 .pending =3D memcg->vmstats->events_pending,
>                 .ppending =3D parent ? parent->vmstats->events_pending : =
NULL,
>                 .cstat =3D statc->events,
> @@ -5183,6 +5213,50 @@ static struct cftype memory_files[] =3D {
>         { }     /* terminate */
>  };
>
> +#ifdef CONFIG_MEMCG_V1
> +/*
> + * Called after the controller has moved between hierarchies, with the o=
n_dfl
> + * key already in its new state.
> + *
> + * If the controller is moving from the default hierarchy to the legacy
> + * hierarchy, vmstats's state_local and events_local arrays need to be p=
opulated
> + * since they get read by the legacy hierarchy. Those values can just be=
 taken
> + * from the vmstats's state and events arrays since rebind_subsystems() =
only
> + * allows the move when the root is the only memcg.
> + */
> +static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
> +{
> +       struct mem_cgroup *memcg =3D mem_cgroup_from_css(root_css);
> +       int i;
> +
> +       if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +               return;
> +
> +       /*
> +        * The flush is necessary because there might be descendants that=
 got
> +        * destroyed right before the rebind that may have left counts in=
 the
> +        * pending arrays that haven't yet been folded into the state and=
 events
> +        * arrays
> +        */
> +       __mem_cgroup_flush_stats(memcg, true);
> +
> +       /*
> +        * Not serialized against a concurrent flush. The periodic flushe=
r runs
> +        * on root_mem_cgroup without cgroup_mutex and a flush increments=
 state
> +        * and state_local together. If the flush happens in between when=
 we
> +        * read state and write to state_local, its state_local increment=
 is
> +        * overwritten and the counter stays short, but the difference wo=
uld be
> +        * a single CPU's accumulated charges since the last flush and th=
e
> +        * counters are approximate values.
> +        */
> +       for (i =3D 0; i < MEMCG_VMSTAT_SIZE; i++)
> +               memcg->vmstats->state_local[i] =3D memcg->vmstats->state[=
i];
> +
> +       for (i =3D 0; i < NR_MEMCG_EVENTS; i++)
> +               memcg->vmstats->events_local[i] =3D memcg->vmstats->event=
s[i];
> +}

I wonder if the complexity is warranted for this optimization to work
when switching from v2 -> v1, or if we should just query the boot
parameter.

> +#endif /* CONFIG_MEMCG_V1 */
> +
>  struct cgroup_subsys memory_cgrp_subsys =3D {
>         .css_alloc =3D mem_cgroup_css_alloc,
>         .css_online =3D mem_cgroup_css_online,
> @@ -5196,6 +5270,7 @@ struct cgroup_subsys memory_cgrp_subsys =3D {
>         .exit =3D mem_cgroup_exit,
>         .dfl_cftypes =3D memory_files,
>  #ifdef CONFIG_MEMCG_V1
> +       .bind =3D mem_cgroup_bind,
>         .legacy_cftypes =3D mem_cgroup_legacy_files,
>  #endif
>         .early_init =3D 0,
> --
> 2.52.0
>
