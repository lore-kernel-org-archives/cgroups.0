From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Wed, 9 Aug 2023 06:17:18 -0700
Message-ID: <CAJD7tkaPPcMsq-pbu26H332xBJP-m=v1aBbU_NJQQn+7motX9g@mail.gmail.com>
References: <20230809045810.1659356-1-yosryahmed@google.com>
 <ZNNTgZVPZipTL/UM@dhcp22.suse.cz> <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA@mail.gmail.com>
 <ZNONgeoytpkchHga@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691587074; x=1692191874;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r7GQah3LR29pNwUlAFsHmzB3/MgA9amRpVJYquX5jX0=;
        b=j2xSiU48lAhLr6GSJ/DFJP5FmUuUSjaBQhgGtPkSEPls0F47OUNh8TIbrSr5UMunMZ
         uM2ZUT0AV6Yl9Qlwub03wbHBRZjf4OaV9YYJm/YEXekUy4vO6Sjeybnabl5D10LLVSjn
         swU57o/MSbPRGeE+ljLde+9aziPyf0+7ZdSzgtsDh6skzxrYO/yjzQ+Pj0y2dU1pdUdr
         2y6VTAnLM4T3A1v5je6mTuQx7nD+wKUg0/0kJJk3EZnC32WVXkdj0Q0Sk5PC/EHZ4xgU
         8lISujnCVovjWP5Jh+CduFXCDAJVx2O+ylOXE2UnEchucJ2qS+wwVmDkpuWz7YVTBaqW
         /Pxw==
In-Reply-To: <ZNONgeoytpkchHga-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

<snip>
> > > [...]
> > > > @@ -639,17 +639,24 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
> > > >       }
> > > >  }
> > > >
> > > > -static void do_flush_stats(void)
> > > > +static void do_flush_stats(bool full)
> > > >  {
> > > > +     if (!atomic_read(&stats_flush_ongoing) &&
> > > > +         !atomic_xchg(&stats_flush_ongoing, 1))
> > > > +             goto flush;
> > > > +
> > > >       /*
> > > > -      * We always flush the entire tree, so concurrent flushers can just
> > > > -      * skip. This avoids a thundering herd problem on the rstat global lock
> > > > -      * from memcg flushers (e.g. reclaim, refault, etc).
> > > > +      * We always flush the entire tree, so concurrent flushers can choose to
> > > > +      * skip if accuracy is not critical. Otherwise, wait for the ongoing
> > > > +      * flush to complete. This avoids a thundering herd problem on the rstat
> > > > +      * global lock from memcg flushers (e.g. reclaim, refault, etc).
> > > >        */
> > > > -     if (atomic_read(&stats_flush_ongoing) ||
> > > > -         atomic_xchg(&stats_flush_ongoing, 1))
> > > > -             return;
> > > > -
> > > > +     while (full && atomic_read(&stats_flush_ongoing) == 1) {
> > > > +             if (!cond_resched())
> > > > +                     cpu_relax();
> > >
> > > You are reinveting a mutex with spinning waiter. Why don't you simply
> > > make stats_flush_ongoing a real mutex and make use try_lock for !full
> > > flush and normal lock otherwise?
> >
> > So that was actually a spinlock at one point, when we used to skip if
> > try_lock failed.
>
> AFAICS cgroup_rstat_flush is allowed to sleep so spinlocks are not
> really possible.

Sorry I hit the send button too early, didn't get to this part.

We were able to use a spinlock because we used to disable sleeping
when flushing the stats then, which opened another can of worms :)

>
> > We opted for an atomic because the lock was only used
> > in a try_lock fashion. The problem here is that the atomic is used to
> > ensure that only one thread actually attempts to flush at a time (and
> > others skip/wait), to avoid a thundering herd problem on
> > cgroup_rstat_lock.
> >
> > Here, what I am trying to do is essentially equivalent to "wait until
> > the lock is available but don't grab it". If we make
> > stats_flush_ongoing a mutex, I am afraid the thundering herd problem
> > will be reintroduced for stats_flush_ongoing this time.
>
> You will have potentially many spinners for something that might take
> quite a lot of time (sleep) if there is nothing else to schedule. I do
> not think this is a proper behavior. Really, you shouldn't be busy
> waiting for a sleeper.
>
> > I am not sure if there's a cleaner way of doing this, but I am
> > certainly open for suggestions. I also don't like how the spinning
> > loop looks as of now.
>
> mutex_try_lock for non-critical flushers and mutex_lock of syncing ones.
> We can talk a custom locking scheme if that proves insufficient or
> problematic.

I have no problem with this. I can send a v2 following this scheme,
once we agree on the importance of this patch :)

> --
> Michal Hocko
> SUSE Labs
