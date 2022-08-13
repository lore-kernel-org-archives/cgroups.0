From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Fri, 12 Aug 2022 17:43:49 -0700
Message-ID: <CAJD7tkbrCNDMkE8dJDWHiTfi=nJJzrZwepaWb3YioRHMrSEuQA@mail.gmail.com>
References: <20220811081913.102770-1-liliguang@baidu.com> <YvWa9MOQWBICInjO@P9FQF9L96D.corp.robot.car>
 <CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nsBuNh8ySi6ShETxrYCuKi8D+pIFk/T+cDDfDt4bPtw=;
        b=flhpfV8eLQphDY35QUDVJ7szN/37QPBxxglfSV+QSAbZ16HmGEjx4iXgN+A3uyEiy5
         u+TX01e611Jk7krensRzI4SVwdTXzRykr7IwEg4tIDyxtRN/s1P+9E0kz+aaf58Y7Cv8
         mT3IvEYgBb3t7lKpqzhzYpn/C4vsS7C5ZTNUM5zk710sz++5UEVtcFb0AxRGMLa6trcr
         31xVxvDzY0e9/5TJSegj41peN9rpqzrhczVGSc2Io9vwX0TOK3QZhEKyL5YrHWSEzSBH
         6KcFZGfBSt4Hcv5gGqfp4ALrC4XcY4b1KRXRj9b4m8o9ZGOnr2vyeghnnWm4gBvQbEQD
         as2w==
In-Reply-To: <CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: liliguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Fri, Aug 12, 2022 at 2:56 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> +Andrew & linux-mm
>
> On Thu, Aug 11, 2022 at 5:12 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> >
> > On Thu, Aug 11, 2022 at 04:19:13PM +0800, liliguang wrote:
> > > From: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> > >
> > > Kswapd will reclaim memory when memory pressure is high, the
> > > annonymous memory will be compressed and stored in the zpool
> > > if zswap is enabled. The memcg_kmem_bypass() in
> > > get_obj_cgroup_from_page() will bypass the kernel thread and
> > > cause the compressed memory not charged to its memory cgroup.
> > >
> > > Remove the memcg_kmem_bypass() and properly charge compressed
> > > memory to its corresponding memory cgroup.
> > >
> > > Signed-off-by: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  mm/memcontrol.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index b69979c9ced5..6a95ea7c5ee7 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2971,7 +2971,7 @@ struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
> > >  {
> > >       struct obj_cgroup *objcg;
> > >
> > > -     if (!memcg_kmem_enabled() || memcg_kmem_bypass())
> > > +     if (!memcg_kmem_enabled())


Won't the memcg_kmem_enabled() check also cause a problem in that same
scenario (e.g. if CONFIG_MEMCG_KMEM=n)? or am I missing something
here?

>
> > >               return NULL;
> > >
> > >       if (PageMemcgKmem(page)) {
> > > --
> > > 2.32.0 (Apple Git-132)
> > >
> >
> > Hi Li!
> >
> > The fix looks good to me! As we get objcg pointer from a page and not from
> > the current task, memcg_kmem_bypass() doesn't makes much sense.
> >
> > Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> >
> > Probably, we need to add
> > Fixes: f4840ccfca25 ("zswap: memcg accounting")
> >
> > Thank you!
>
> You can add:
>
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
