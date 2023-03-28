From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 5/9] memcg: replace stats_flush_lock with an atomic
Date: Tue, 28 Mar 2023 12:34:15 -0700
Message-ID: <CAJD7tkb_YA3fvo3LgCzR+X-b-r-AmAR68hNR=xT7B6TJfBa54A@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-6-yosryahmed@google.com> <20230328141523.txyhl7wt7wtvssea@google.com>
 <CAJD7tkYo=CeXJPUi_KxjzC0QCxC2qd_J2_FQi_aXh7svD8u60A@mail.gmail.com> <CALvZod4Gsngc6MjXdk4s5+ePVjsgcVppdRmsQovN6gSrxzdbfA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680032092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCcvIywQQCX7FP21Q6hk+wcOp0VhtxDKF+8JhJGEAfQ=;
        b=dHoOF8rNOSkdjd1rnnf8XC6IGb6FKwmM7Ivdvjk2GQi/EbVyThzjBYyHQXopuJULIg
         3p1bzuC4gKKNl6Fqhda2du3Rr+s6FdBcg4aXKrD1ycu2zktIM3FTOAoGmv4pZHnjujsT
         rvqc9SbA4NjhcACriIJnLeYfMpWyuhW0j5mUqMiEJuGYX3I6Vm1bge9vyTRqSfTQ+kFD
         hcNKe+61X/fdB+69ZT/PWtpn27JcWOnhGjSUdRlOVudULYhr4IE9KPo4WrZdFpVOufcb
         x3G5vlvhcJZuXWJ1jNnDtE5NmkzFKju+dq8flQe22Sd56znLfGyB2CeL5tXa6i93FNYi
         J7Xg==
In-Reply-To: <CALvZod4Gsngc6MjXdk4s5+ePVjsgcVppdRmsQovN6gSrxzdbfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 12:28=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> On Tue, Mar 28, 2023 at 11:53=E2=80=AFAM Yosry Ahmed <yosryahmed@google.c=
om> wrote:
> >
> [...]
> > > > +     if (atomic_xchg(&stats_flush_ongoing, 1))
> > >
> > > Have you profiled this? I wonder if we should replace the above with
> > >
> > >         if (atomic_read(&stats_flush_ongoing) || atomic_xchg(&stats_f=
lush_ongoing, 1))
> >
> > I profiled the entire series with perf and I haven't noticed a notable
> > difference between before and after the patch series -- but maybe some
> > specific access patterns cause a regression, not sure.
> >
> > Does an atomic_cmpxchg() satisfy the same purpose? it's easier to read
> > / more concise I guess.
> >
> > Something like
> >
> >     if (atomic_cmpxchg(&stats_flush_ongoing, 0, 1))
> >
> > WDYT?
> >
>
> No, I don't think cmpxchg will be any different from xchg(). On x86,
> the cmpxchg will always write to stats_flush_ongoing and depending on
> the comparison result, it will either be 0 or 1 here.
>
> If you see the implementation of queued_spin_trylock(), it does the
> same as well.

Interesting. I thought cmpxchg by definition will compare first and
only do the write if stats_flush_ongoing =3D=3D 0 in this case.

I thought queued_spin_trylock() was doing an atomic_read() first to
avoid the LOCK instruction unnecessarily the lock is held by someone
else.
