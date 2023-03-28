From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Tue, 28 Mar 2023 15:18:28 -0700
Message-ID: <CAJD7tkbH8WQ8K-pQZVwnz9ZaJ=iHBE-LDnzpD7Dzd1zf_xMx4g@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-5-yosryahmed@google.com> <ZCMojk50vjiK6mBe@cmpxchg.org>
 <CAJD7tkYA=0rKSmtQzYQpZ2DuUoJq0bQcVqPgSpVEs0M4zAktnw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680041945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wL4GcqYYIvPt1Pi6ck7hlX2oFSHc5TZT9/OZ5kAArQo=;
        b=ZC6EC0DFE1hHUTV2LBaIFnK+dTTA9H/SYOdOb0dhH00vk7KbwRxBEbTfOOdBRB86Rg
         jg44S7degscRQn7Sr3Wx0ShbNoWLNgtyWVzLTr9J/rMgQ0cWTowD4bfEmQX06+cuuYTr
         HuVqdAQMIhsByAw/q1S4YbnR52GCVi0abm/WefRvQ/pX3odeyr4l8J7PPCwpfNHEHsUn
         ZaK2Ex2ZdabfxXoUFAPPmjleoMH3gRvtZCtys7cEv9WMJSFpV2zbljOiJsAo5MHnFGbU
         ASJUQ6Kq8/VVtikM1hs1wkVX107ltZ305Vjzbe+0lVumZUAQFAFUKuOIpWqYW77w9swX
         l64w==
In-Reply-To: <CAJD7tkYA=0rKSmtQzYQpZ2DuUoJq0bQcVqPgSpVEs0M4zAktnw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 11:59=E2=80=AFAM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
>
> On Tue, Mar 28, 2023 at 10:49=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.=
org> wrote:
> >
> > On Tue, Mar 28, 2023 at 06:16:33AM +0000, Yosry Ahmed wrote:
> > > rstat flushing is too expensive to perform in irq context.
> > > The previous patch removed the only context that may invoke an rstat
> > > flush from irq context, add a WARN_ON_ONCE() to detect future
> > > violations, or those that we are not aware of.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  kernel/cgroup/rstat.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> > > index d3252b0416b6..c2571939139f 100644
> > > --- a/kernel/cgroup/rstat.c
> > > +++ b/kernel/cgroup/rstat.c
> > > @@ -176,6 +176,8 @@ static void cgroup_rstat_flush_locked(struct cgro=
up *cgrp, bool may_sleep)
> > >  {
> > >       int cpu;
> > >
> > > +     /* rstat flushing is too expensive for irq context */
> > > +     WARN_ON_ONCE(!in_task());
> > >       lockdep_assert_held(&cgroup_rstat_lock);
> >
> > This seems a bit arbitrary. Why is an irq caller forbidden, but an
> > irq-disabled, non-preemptible section caller is allowed? The latency
> > impact on the system would be the same, right?
>
> Thanks for taking a look.
>
> So in the first patch series the initial purpose was to make sure
> cgroup_rstat_lock was never acquired in an irq context, so that we can
> stop disabling irqs while holding it. Tejun disagreed with this
> approach though.
>
> We currently have one caller that calls flushing with irqs disabled
> (mem_cgroup_usage()) -- so we cannot forbid such callers (yet), but I
> thought we can at least forbid callers from irq context now (or catch
> those that we are not aware of), and then maybe forbid irqs_disabled()
> contexts as well we can get rid of that callsite.
>
> WDYT?

I added more context in the commit log in the v2 respin [1]. Let me
know if you want me to change something else, rephrase the comment, or
drop the patch entirely.

[1]https://lore.kernel.org/linux-mm/20230328221644.803272-5-yosryahmed@goog=
le.com/
