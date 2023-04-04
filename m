From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 4/8] memcg: replace stats_flush_lock with an atomic
Date: Tue, 4 Apr 2023 10:21:33 -0700
Message-ID: <CALvZod7Ao-VmB4as+VHsR+awW1jmOA18uVM7qk21mVsXTOYC2A@mail.gmail.com>
References: <20230330191801.1967435-1-yosryahmed@google.com>
 <20230330191801.1967435-5-yosryahmed@google.com> <20230404165258.ie6ttxobbmgn62hs@blackpad>
 <CALvZod5Y+quOS1XQvVBTvv7FRs3455j_79f0GoR+FqCFzbwkuA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680628904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/6nWpG035DFCd1KL6TSDLFyH9kaDtT1tj9RQy6j89U=;
        b=PKraOirR2pRBA2DBW/b33pTm+8HXjKvpeNeRzehm9FD9V7XXtodyrrySXy1qTEBZQr
         KFtO6wcuZl5I0TAgoLpYtumb2AXH1YDSl7tNZVF0teic9sNmnZ5Au1/xUa9gyEVdQLdV
         AY7qyFZ1dPyPFa1UUhVHvv8/mO0zS1TBX7chxj/oUPivbEu361UcjMNugE1rCkF2gF0Q
         67lgHtBl39eyST0OLIFXiGODcqI2+588kxayaRE7NbbqOro+EqNNKkmqAeeBCCR7SquS
         F31eMziiL3Tu2fHhzHuplp2dE7AYSjVVNkuvNqRVoXYN2Tei1Q9gxYr8f2pGG+ajomnQ
         hbug==
In-Reply-To: <CALvZod5Y+quOS1XQvVBTvv7FRs3455j_79f0GoR+FqCFzbwkuA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

On Tue, Apr 4, 2023 at 10:13=E2=80=AFAM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> On Tue, Apr 4, 2023 at 9:53=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.c=
om> wrote:
> >
> > Hello.
> >
> > On Thu, Mar 30, 2023 at 07:17:57PM +0000, Yosry Ahmed <yosryahmed@googl=
e.com> wrote:
> > >  static void __mem_cgroup_flush_stats(void)
> > >  {
> > > -     unsigned long flag;
> > > -
> > > -     if (!spin_trylock_irqsave(&stats_flush_lock, flag))
> > > +     /*
> > > +      * We always flush the entire tree, so concurrent flushers can =
just
> > > +      * skip. This avoids a thundering herd problem on the rstat glo=
bal lock
> > > +      * from memcg flushers (e.g. reclaim, refault, etc).
> > > +      */
> > > +     if (atomic_read(&stats_flush_ongoing) ||
> > > +         atomic_xchg(&stats_flush_ongoing, 1))
> > >               return;
> >
> > I'm curious about why this instead of
> >
> >         if (atomic_xchg(&stats_flush_ongoing, 1))
> >                 return;
> >
> > Is that some microarchitectural cleverness?
> >
>
> Yes indeed it is. Basically we want to avoid unconditional cache
> dirtying. This pattern is also used at other places in the kernel like
> qspinlock.

Oh also take a look at
https://lore.kernel.org/all/20230404052228.15788-1-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
