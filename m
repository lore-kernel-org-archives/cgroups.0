From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Fri, 12 Aug 2022 14:56:16 -0700
Message-ID: <CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com>
References: <20220811081913.102770-1-liliguang@baidu.com> <YvWa9MOQWBICInjO@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=o2hp/mCYv88Mu5Svxez+bwRchvdFYkFYWfUz+bymVnc=;
        b=q1jKUnyVZ9vO4CNzKCvW4vPDrvisSyGyG/aj2uv3JTpY33zTgaWK4E20HV+lY9mCRW
         NAQfFUw/KuEcyS66BsOz17ZF45PP3LT9pkwMDyCAQUvMFTOxZ21/n6yfZ90uGfu3lwDB
         Z5zVIcCxdviScscBaVZGTwL8svQwie4johmolE7J6EJcwLeQBarQM4aM6sUiR/DelNuu
         bHEwrLxWqs9KOD/3WF1o59D7PyuzMsPWE6RCFtCofmK7NBHMRlQwmiZBo8Lgr5syF5gu
         gPd3ia9znghXyZh726OwhHTlQ1ItRFVZ7GLkXtsfn/K9oo5jjtEYPZ8gJxmMIvDK60nN
         e2tQ==
In-Reply-To: <YvWa9MOQWBICInjO-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: liliguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

+Andrew & linux-mm

On Thu, Aug 11, 2022 at 5:12 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> On Thu, Aug 11, 2022 at 04:19:13PM +0800, liliguang wrote:
> > From: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> >
> > Kswapd will reclaim memory when memory pressure is high, the
> > annonymous memory will be compressed and stored in the zpool
> > if zswap is enabled. The memcg_kmem_bypass() in
> > get_obj_cgroup_from_page() will bypass the kernel thread and
> > cause the compressed memory not charged to its memory cgroup.
> >
> > Remove the memcg_kmem_bypass() and properly charge compressed
> > memory to its corresponding memory cgroup.
> >
> > Signed-off-by: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index b69979c9ced5..6a95ea7c5ee7 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2971,7 +2971,7 @@ struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
> >  {
> >       struct obj_cgroup *objcg;
> >
> > -     if (!memcg_kmem_enabled() || memcg_kmem_bypass())
> > +     if (!memcg_kmem_enabled())
> >               return NULL;
> >
> >       if (PageMemcgKmem(page)) {
> > --
> > 2.32.0 (Apple Git-132)
> >
>
> Hi Li!
>
> The fix looks good to me! As we get objcg pointer from a page and not from
> the current task, memcg_kmem_bypass() doesn't makes much sense.
>
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>
> Probably, we need to add
> Fixes: f4840ccfca25 ("zswap: memcg accounting")
>
> Thank you!

You can add:

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
