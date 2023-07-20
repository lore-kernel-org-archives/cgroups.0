From: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 7/8] memcg: add sysctl and config option to control
 memory recharging
Date: Thu, 20 Jul 2023 11:30:49 -0700
Message-ID: <ZLl9WfMgZSeKtyX7@bombadil.infradead.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720070825.992023-8-yosryahmed@google.com>
 <ZLl5XA25BIlYyngD@bombadil.infradead.org>
 <CAJD7tkbsZ5rAn5nNUvhuN9uUb4qPcsGZ8pcwCHzbqbajXKP9=g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=TVc0DH5y5ZMGm3BerZTpK/u+XD4hMTin0vDBzxNt6yk=; b=k0wUa4Bc0gX81i186z/h55eQuL
        vN2ed/onpM28iKxC4yEvpheHnOUG0NwZNNTD58Efa5NxWnv8JEi+GPkO0rBNzcOVbiOC0JDx4vExy
        62BA0UYuhCnDDXCUAcHUFoby7XFd5M9jWSdS9lfREMafDc3OHhgbMYx7lejYTutJ2gFH9OAkhkD2q
        Iex0W2rl79yFoa2zJp4tUDJuQY6KkxOA+6Q/NVHpzYBA8oL3jzUcj/YbCkwN9ejIWCcVMrHZOMy/e
        oILegG1jfTpeFUg80y2sMHbIdrvmHw5WpoMbIiyPvoeDu0hQru9bMv/Xx+SN3p+prtgLGa3MNUuJw
        4iYrGLKQ==;
Content-Disposition: inline
In-Reply-To: <CAJD7tkbsZ5rAn5nNUvhuN9uUb4qPcsGZ8pcwCHzbqbajXKP9=g@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 20, 2023 at 11:24:20AM -0700, Yosry Ahmed wrote:
> On Thu, Jul 20, 2023 at 11:13=E2=80=AFAM Luis Chamberlain <mcgrof-DgEjT+A=
i2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Thu, Jul 20, 2023 at 07:08:24AM +0000, Yosry Ahmed wrote:
> > > Add a sysctl to enable/disable memory recharging for offline memcgs. =
Add
> > > a config option to control whether or not it is enabled by default.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.=
gmane.org>
> > > ---
> > >  include/linux/memcontrol.h |  2 ++
> > >  kernel/sysctl.c            | 11 +++++++++++
> > >  mm/Kconfig                 | 12 ++++++++++++
> > >  mm/memcontrol.c            |  9 ++++++++-
> > >  4 files changed, 33 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 59b653d4a76e..ae9f09ee90cb 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -60,6 +60,8 @@ struct mem_cgroup_reclaim_cookie {
> > >
> > >  #ifdef CONFIG_MEMCG
> > >
> > > +extern int sysctl_recharge_offline_memcgs;
> > > +
> > >  #define MEM_CGROUP_ID_SHIFT  16
> > >  #define MEM_CGROUP_ID_MAX    USHRT_MAX
> > >
> > > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > > index 354a2d294f52..1735d1d95652 100644
> > > --- a/kernel/sysctl.c
> > > +++ b/kernel/sysctl.c
> > > @@ -2249,6 +2249,17 @@ static struct ctl_table vm_table[] =3D {
> > >               .extra2         =3D (void *)&mmap_rnd_compat_bits_max,
> > >       },
> > >  #endif
> > > +#ifdef CONFIG_MEMCG
> > > +     {
> > > +             .procname       =3D "recharge_offline_memcgs",
> > > +             .data           =3D &sysctl_recharge_offline_memcgs,
> > > +             .maxlen         =3D sizeof(sysctl_recharge_offline_memc=
gs),
> > > +             .mode           =3D 0644,
> > > +             .proc_handler   =3D proc_dointvec_minmax,
> > > +             .extra1         =3D SYSCTL_ZERO,
> > > +             .extra2         =3D SYSCTL_ONE,
> > > +     },
> > > +#endif /* CONFIG_MEMCG */
> > >       { }
> > >  };
> >
> > Please don't add any more sysctls to kernel/sysctl.c, git log that file
> > for a series of cleanups which show how to use your own and why we have
> > been doing that cleanup.
>=20
> Thanks for pointing this out, I definitely missed it. Will do that in
> the next version. I guess this will also reduce the reviewer churn if
> I won't be touching kernel/sysctl.c?

Right, it means I don't have to care anymore about random sysctl knobs.
Let people knob it all up.

  Luis
