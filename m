From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Mon, 15 Aug 2022 06:46:46 -0700
Message-ID: <CAJD7tkYdJrakJGp8XMt49ixZJuf=qpGm=vSxH6G_GWeenk35dQ@mail.gmail.com>
References: <20220811081913.102770-1-liliguang@baidu.com> <YvWa9MOQWBICInjO@P9FQF9L96D.corp.robot.car>
 <CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com>
 <CAJD7tkbrCNDMkE8dJDWHiTfi=nJJzrZwepaWb3YioRHMrSEuQA@mail.gmail.com>
 <1704B09B-F758-47DF-BDDE-FEA9AB227E12@baidu.com> <CAJD7tkaW7qtaNpc3UHuQAcJAjdjzjmWZCqCMafT-nUES+2QtYg@mail.gmail.com>
 <E0E6FD3B-242B-4187-B4B4-9D4496A5B19A@baidu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=Yns/Jpj95x/nJs+G87dScDOGDHWXu34AZre/Qatzji0=;
        b=tdkveuBu6uaMJub+24M/znCUtI3DkObWNMw10VbS9Nd/vD8SzGgbPG38IsiEeqbxkx
         v3WNuqJmqbWiuztrkUQHhrrykz3j04t5AbBbAmOGwR+3iZvGnZ4qj2wNYwDjhclPm/T3
         yvvFwFHnbcx8SJ/4lIJK5+zhKaAZ7kT5LZ9QMswh7fdUtMlqTcauTcQFCgMCtGuXTM4x
         hVhdsLvc0FSKpmTELK5Lxtu8mlm9ksa21N4HDWXQigzhdAqmuClT7WHe9WGXfrXKHuyv
         xrTii1J3G3ZdH/w0tZWGUHSoyEaJphj3Z4dTmw/yLRw4bbftBtoucTKx8M6591O16k3h
         QpDA==
In-Reply-To: <E0E6FD3B-242B-4187-B4B4-9D4496A5B19A-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Li,Liguang" <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Mon, Aug 15, 2022 at 4:48 AM Li,Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org> wrote:
>
>
> > =E5=9C=A8 2022/8/15 =E4=B8=8B=E5=8D=884:10=EF=BC=8C=E2=80=9CYosry Ahmed=
=E2=80=9D<yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =E5=86=99=E5=85=A5:
> >
> > On Sun, Aug 14, 2022 at 7:52 PM Li,Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > =E5=9C=A8 2022/8/13 =E4=B8=8A=E5=8D=888:44=EF=BC=8C=E2=80=9CYosry Ahm=
ed=E2=80=9D<yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =E5=86=99=E5=85=A5:
> > >
> > > > On Fri, Aug 12, 2022 at 2:56 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
> > > > >
> > > > > +Andrew & linux-mm
> > > > >
> > > > > On Thu, Aug 11, 2022 at 5:12 PM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
> > > > > >
> > > > > > On Thu, Aug 11, 2022 at 04:19:13PM +0800, liliguang wrote:
> > > > > > > From: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> > > > > > >
> > > > > > > Kswapd will reclaim memory when memory pressure is high, the
> > > > > > > annonymous memory will be compressed and stored in the zpool
> > > > > > > if zswap is enabled. The memcg_kmem_bypass() in
> > > > > > > get_obj_cgroup_from_page() will bypass the kernel thread and
> > > > > > > cause the compressed memory not charged to its memory cgroup.
> > > > > > >
> > > > > > > Remove the memcg_kmem_bypass() and properly charge compressed
> > > > > > > memory to its corresponding memory cgroup.
> > > > > > >
> > > > > > > Signed-off-by: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> > > > > > > ---
> > > > > > >  mm/memcontrol.c | 2 +-
> > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > > index b69979c9ced5..6a95ea7c5ee7 100644
> > > > > > > --- a/mm/memcontrol.c
> > > > > > > +++ b/mm/memcontrol.c
> > > > > > > @@ -2971,7 +2971,7 @@ struct obj_cgroup *get_obj_cgroup_from_=
page(struct page *page)
> > > > > > >  {
> > > > > > >       struct obj_cgroup *objcg;
> > > > > > >
> > > > > > > -     if (!memcg_kmem_enabled() || memcg_kmem_bypass())
> > > > > > > +     if (!memcg_kmem_enabled())
> > > >
> > > >
> > > > Won't the memcg_kmem_enabled() check also cause a problem in that s=
ame
> > > > scenario (e.g. if CONFIG_MEMCG_KMEM=3Dn)? or am I missing something
> > > > here?
> > > >
> > >
> > > Please notes that the return value is a pointer to obj_cgroup, not me=
mcg.
> > > If CONFIG_MEMCG_KMEM=3Dn or memcg kmem charge is disabled, the NULL n=
eed
> > > to be returned.
> > >
> >
> > Right. I am not implying that the check should be removed, or that
> > this is something this patch should address for that matter.
> >
> > I just realized while looking at this patch that because we are using
> > objcg in zswap charging, it is dependent on memcg kmem charging. I am
> > not sure I understand if such dependency is needed? IIUC swapped out
> > pages hold references to the memcg they are charged to anyway, so why
> > do we need to use objcgs in charging zswap? I feel like I am missing
> > something.
> >
>
> The compressed size of swapped out pages is nearly a quarter of its RAM,
> and a page in the zswap can store multiple compressed swapped out
> pages. So objcg is used here.
>
> Please check this post for more information.
> https://lore.kernel.org/lkml/20220510152847.230957-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org/T=
/#mbd0254ffd377bf843ac50850bf0a6d41505a925a

Yeah I understand this much, what I don't understand is why we charge
the zswap memory through objcg (thus tying it to memcg kmem charging)
rather than directly through memcg.

>
> > > > >
> > > > > > >               return NULL;
> > > > > > >
> > > > > > >       if (PageMemcgKmem(page)) {
> > > > > > > --
> > > > > > > 2.32.0 (Apple Git-132)
> > > > > > >
> > > > > >
> > > > > > Hi Li!
> > > > > >
> > > > > > The fix looks good to me! As we get objcg pointer from a page a=
nd not from
> > > > > > the current task, memcg_kmem_bypass() doesn't makes much sense.
> > > > > >
> > > > > > Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> > > > > >
> > > > > > Probably, we need to add
> > > > > > Fixes: f4840ccfca25 ("zswap: memcg accounting")
> > > > > >
> > > > > > Thank you!
> > > > >
> > > > > You can add:
> > > > >
> > > > > Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > >
> > >
>
