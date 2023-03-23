From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 2/7] memcg: do not disable interrupts when holding stats_flush_lock
Date: Wed, 22 Mar 2023 22:16:40 -0700
Message-ID: <CAJD7tkZJWXDinusUeYNBf_qov0+4ug2hG75Ge8NuP=6jG7+byA@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-3-yosryahmed@google.com> <CALvZod5MnM8UJ0pj44QYb4sVwgFZ1B2KpSL6oqBQbJU3wH6eNA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679548637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wf+Rn+FqVZ/sEEsLcWdc0Ab7428JNqhvJozhY+1OPkE=;
        b=UHxWcP+YzEnDXmlCMM4KkoxJ1LDDdOcgokWC5PN8qmiIJBy4Amlu03ZpAtkmIXsfwm
         RWn4PlsACc2XuTxyHVrWJGu4NoFd4ClniTSizL/83reSjz4HKmvfbePZbcokbL9DDWiG
         TP5Sjo3IF8xMn8px91h8B4L5Eh9dPtZq4JhbqVT9k24fwBDe+4+sU9Z2i8Ok57D6Qb/N
         rnLUbX3kP4DcjeHwrk+/nzNrcNoBYwqDvNsx8nBG6TmYcm1YuX9LPzwcvMxSubyOjAnF
         krM2wEcyWV/eQ3sw5wI3NOyBMOQzFLMafCs6zrgwLGYhZyaKdjtssQ8BakuWxEgVN9jf
         A4+g==
In-Reply-To: <CALvZod5MnM8UJ0pj44QYb4sVwgFZ1B2KpSL6oqBQbJU3wH6eNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 22, 2023 at 9:32=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> On Wed, Mar 22, 2023 at 9:00=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >
> > The rstat flushing code was modified so that we do not disable interrup=
ts
> > when we hold the global rstat lock. Do the same for stats_flush_lock on
> > the memcg side to avoid unnecessarily disabling interrupts throughout
> > flushing.
> >
> > Since the code exclusively uses trylock to acquire this lock, it should
> > be fine to hold from interrupt contexts or normal contexts without
> > disabling interrupts as a deadlock cannot occur. For interrupt contexts
> > we will return immediately without flushing anyway.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 5abffe6f8389..e0e92b38fa51 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -636,15 +636,17 @@ static inline void memcg_rstat_updated(struct mem=
_cgroup *memcg, int val)
> >
> >  static void __mem_cgroup_flush_stats(void)
> >  {
> > -       unsigned long flag;
> > -
> > -       if (!spin_trylock_irqsave(&stats_flush_lock, flag))
> > +       /*
> > +        * This lock can be acquired from interrupt context,
>
> How? What's the code path?

I believe through the charge/uncharge path we can do
memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usage()->mem_cgrou=
p_flush_stats(),
right? I am assuming we can charge/uncharge memory in an interrupt
context.

Also the current code always disables interrupts before calling
memcg_check_events(), which made me suspect the percpu variables that
are modified by that call can also be modified in interrupt context.

>
> > but we only acquire
> > +        * using trylock so it should be fine as we cannot cause a dead=
lock.
> > +        */
> > +       if (!spin_trylock(&stats_flush_lock))
> >                 return;
> >
> >         flush_next_time =3D jiffies_64 + 2*FLUSH_TIME;
> >         cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
> >         atomic_set(&stats_flush_threshold, 0);
> > -       spin_unlock_irqrestore(&stats_flush_lock, flag);
> > +       spin_unlock(&stats_flush_lock);
> >  }
> >
> >  void mem_cgroup_flush_stats(void)
> > --
> > 2.40.0.rc1.284.g88254d51c5-goog
> >
