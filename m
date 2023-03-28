From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 5/9] memcg: replace stats_flush_lock with an atomic
Date: Tue, 28 Mar 2023 11:52:50 -0700
Message-ID: <CAJD7tkYo=CeXJPUi_KxjzC0QCxC2qd_J2_FQi_aXh7svD8u60A@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-6-yosryahmed@google.com> <20230328141523.txyhl7wt7wtvssea@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680029606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Knz0ICKyVQWqTN98QRlsl94SOUBbAgJSfpknOWcWIz8=;
        b=eBFPS5upevzYowGb39P08hDPA5ByzP8CKwYQMFgOKj+6IYq2Vkfhm5oL5cVrbZhHzf
         eQHkB8C313lW8nsV9BpZNUZGGFqiswJwY5FMsPU6z/cd/O9XwAIDMFqeGPfx35miDyrF
         +bGkozLip971EeAk9h6UC0HOXtdfFwRiZJkEUoXuLJ3fBqgLl1/lbS6hfhsmfL9XRhH+
         KR9XbqwM57zERf5JS531f6qDu8XI49Nmmt2jHNhErVh4imKzomY5+lfULAhHKaJb3jM2
         Rye/OtfKqLqEEIMO08YuFZgxXxl9NZRbCLkFj6dKWKMGFVVM0dFa3ui8jA4/djrvfILk
         dA1w==
In-Reply-To: <20230328141523.txyhl7wt7wtvssea-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 7:15=E2=80=AFAM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> On Tue, Mar 28, 2023 at 06:16:34AM +0000, Yosry Ahmed wrote:
> [...]
> > @@ -585,8 +585,8 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgrou=
p_tree_per_node *mctz)
> >   */
> >  static void flush_memcg_stats_dwork(struct work_struct *w);
> >  static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dw=
ork);
> > -static DEFINE_SPINLOCK(stats_flush_lock);
> >  static DEFINE_PER_CPU(unsigned int, stats_updates);
> > +static atomic_t stats_flush_ongoing =3D ATOMIC_INIT(0);
> >  static atomic_t stats_flush_threshold =3D ATOMIC_INIT(0);
> >  static u64 flush_next_time;
> >
> > @@ -636,15 +636,18 @@ static inline void memcg_rstat_updated(struct mem=
_cgroup *memcg, int val)
> >
> >  static void __mem_cgroup_flush_stats(void)
> >  {
> > -     unsigned long flag;
> > -
> > -     if (!spin_trylock_irqsave(&stats_flush_lock, flag))
> > +     /*
> > +      * We always flush the entire tree, so concurrent flushers can ju=
st
> > +      * skip. This avoids a thundering herd problem on the rstat globa=
l lock
> > +      * from memcg flushers (e.g. reclaim, refault, etc).
> > +      */
> > +     if (atomic_xchg(&stats_flush_ongoing, 1))
>
> Have you profiled this? I wonder if we should replace the above with
>
>         if (atomic_read(&stats_flush_ongoing) || atomic_xchg(&stats_flush=
_ongoing, 1))

I profiled the entire series with perf and I haven't noticed a notable
difference between before and after the patch series -- but maybe some
specific access patterns cause a regression, not sure.

Does an atomic_cmpxchg() satisfy the same purpose? it's easier to read
/ more concise I guess.

Something like

    if (atomic_cmpxchg(&stats_flush_ongoing, 0, 1))

WDYT?




>
> to not always dirty the cacheline. This would not be an issue if there
> is no cacheline sharing but I suspect percpu stats_updates is sharing
> the cacheline with it and may cause false sharing with the parallel stat
> updaters (updaters only need to read the base percpu pointer).
>
> Other than that the patch looks good.
