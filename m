From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 6/7] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Thu, 23 Mar 2023 09:02:25 -0700
Message-ID: <CAJD7tkZ2cOQ8fVRewxznYin6VgeRHiJAQMZbhhi6cT64xfRvqg@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-7-yosryahmed@google.com> <20230323160030.GD739026@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679587382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0qq4eAJlExkTdfdM7Y2EFZtPczMJ0l3cf4DT7uOI7JI=;
        b=b2L3krFnhws7f+p6hNHEuWxd6zHS4DqTuXhpP/rStBHvPGchFK0OAE51Mv5Gggdeva
         0g+X1gb+kxTGwE7MuENLR+hBwy5CJCvKIeflwI8gTeX7juPYoXVi6mToYkQu2jsd6VVK
         XkpNk/cz5nwC5XHfmfjMuww1FYcjHs0qPmGVGUo4z9Ghsk7Eb1tXZJTLTmpPar+FodLP
         ufTGqdkDyfaPIyftUYuOdlRHEhAF00xxGUsvAS7AFhZdslbx6UQqkV+Zc9Xvt9lR/pVo
         p0D8+Hc5PEtyv37lvNruiMQD1DsZALHgLLaWg+NZbdFcsLcZ3CNgbGpSXxz9y6+ZVaJt
         NXIA==
In-Reply-To: <20230323160030.GD739026-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 23, 2023 at 9:00=E2=80=AFAM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org=
> wrote:
>
> On Thu, Mar 23, 2023 at 04:00:36AM +0000, Yosry Ahmed wrote:
> > In workingset_refault(), we call mem_cgroup_flush_stats_delayed() to
> > flush stats within an RCU read section and with sleeping disallowed.
> > Move the call to mem_cgroup_flush_stats_delayed() above the RCU read
> > section and allow sleeping to avoid unnecessarily performing a lot of
> > work without sleeping.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >
> > A lot of code paths call into workingset_refault(), so I am not
> > generally sure at all whether it's okay to sleep in all contexts or not=
.
> > Feedback here would be very helpful.
> >
> > ---
> >  mm/workingset.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/workingset.c b/mm/workingset.c
> > index 042eabbb43f6..410bc6684ea7 100644
> > --- a/mm/workingset.c
> > +++ b/mm/workingset.c
> > @@ -406,6 +406,8 @@ void workingset_refault(struct folio *folio, void *=
shadow)
> >       unpack_shadow(shadow, &memcgid, &pgdat, &eviction, &workingset);
> >       eviction <<=3D bucket_order;
> >
> > +     /* Flush stats (and potentially sleep) before holding RCU read lo=
ck */
> > +     mem_cgroup_flush_stats_delayed(true);
>
> Btw, it might be a good time to rename this while you're in the
> area. delayed suggests this is using a delayed_work, but this is
> actually sometimes flushing directly from the callsite.
>
> What it's doing is ratelimited calls. A better name would be:
>
>         mem_cgroup_flush_stats_ratelimited()

Agreed. Will do in the next version.
