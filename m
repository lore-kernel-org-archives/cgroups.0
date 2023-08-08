From: Xiongwei Song <sxwjean-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: add tips for kmem.slabinfo
Date: Tue, 8 Aug 2023 20:08:26 +0800
Message-ID: <CAEVVKH-+L8O_wyzj7nueSPN7c0wbG0iUrM61hYXQOm7R7KCjiw@mail.gmail.com>
References: <20230808022229.1560559-1-xiongwei.song@windriver.com>
 <ZNG9vwg1K6fn1SvN@P9FQF9L96D> <ZNHu8m3h3ckn+HeI@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691512153; x=1692116953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5jWDe5wn3rMqNcO4b1gbGyhh2S63llVj6tRKZkmEkI=;
        b=nClH4hqUumhc5ncPR9uFyByCM7+yqL2gwOXGECS46FF8ujEELgbfd4uWIiHhBoFNIL
         4yh+nl4uQZH7DRUO57TRW3uBOKWYno1/+Sd/gNr7y/TXi2GSZCNvHlaIwzsFgYHQWLoy
         lF+Y185xvk02OEoe66FXDKrKZcdzFCpwg6RISl7S6w4nEgyVsL1o8Fk/pJSfgw61O8jV
         d2eqqsKXFS9/QUm3Fvx9lCagHdooxEYFI8ZGhO24usFkYUUn89xr7tjy3TEmNj11F5Dq
         1lj5NQjGC0nTu5CCaf1dpwfQeZxiGc5ZS6WXPaA6y4poTI44Ep13/OHQ0V66DrhAS9b4
         3EBw==
In-Reply-To: <ZNHu8m3h3ckn+HeI-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 8, 2023 at 3:30=E2=80=AFPM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Mon 07-08-23 20:59:59, Roman Gushchin wrote:
> > On Tue, Aug 08, 2023 at 10:22:29AM +0800, xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org w=
rote:
> > > From: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> > >
> > > No any output from kmem.slabinfo, which is not friendly. Adding
> > > tips for it.
> > >
> > > Signed-off-by: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> > > ---
> > >  mm/memcontrol.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index e8ca4bdcb03c..58d3bd93890b 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -5002,10 +5002,8 @@ static ssize_t memcg_write_event_control(struc=
t kernfs_open_file *of,
> > >  #if defined(CONFIG_MEMCG_KMEM) && (defined(CONFIG_SLAB) || defined(C=
ONFIG_SLUB_DEBUG))
> > >  static int mem_cgroup_slab_show(struct seq_file *m, void *p)
> > >  {
> > > -   /*
> > > -    * Deprecated.
> > > -    * Please, take a look at tools/cgroup/memcg_slabinfo.py .
> > > -    */
> > > +   seq_puts(m, "This file is deprecated.\n"
> > > +           "Please use tools/cgroup/memcg_slabinfo.py, which is in k=
ernel source.\n");
> >
> > It'll break the ABI.
>
> Agreed
>
> > The only possible option here is to use WARN_ON_ONCE(), which will prin=
t once to dmesg.
> > But honestly I'm not sure we need it.
>
> There are systems with panic_on_warn configured. I do not think we want
> those to go down just becasue some random tool tries to read this file.

Thank you for the comments.

> --
> Michal Hocko
> SUSE Labs
>
