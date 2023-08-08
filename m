From: Xiongwei Song <sxwjean-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: add tips for kmem.slabinfo
Date: Tue, 8 Aug 2023 20:08:57 +0800
Message-ID: <CAEVVKH-hdpVwLZMzW41fvvwUDGAYpsUHwfOf=_VM9OuDrmmkcg@mail.gmail.com>
References: <20230808022229.1560559-1-xiongwei.song@windriver.com> <ZNG9vwg1K6fn1SvN@P9FQF9L96D>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691512029; x=1692116829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n17U5qh0OrK3kvBv9V9L+D0ClJ7otAlPJK+8puyUKR0=;
        b=R9MM9qtcdWK6ALzoyjStuJ1cKn4gHm0nKPRoq9v6WU//494PvRCVoizlwxpSB7Drq5
         PkpAsBRdO6kebLLBV1eO3x8N1gVnQMrZ96KIGwypJXK3mt5n4XqxY2L9ouNEbcmUSMdQ
         VW6eL2ZF8SgJCGeyLRpuzQIWeHbFUXs8EnlA3vW4A9XSXKo2pNMZ8gz327rsBfsHFAAM
         vy3gZkSk82+C9oXJjCcdjYS+j3qB0TT4CyfrGWM5SOKmsI+XTdIinG4Cm8a3W5yOZHD1
         +zq6pbc2BaRGIMvcMyxTwne37QIixGwvDkGfIsuWzccKIJzntyBs3XRQlXk3yCjSGQYq
         BIfg==
In-Reply-To: <ZNG9vwg1K6fn1SvN@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 8, 2023 at 12:00=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> On Tue, Aug 08, 2023 at 10:22:29AM +0800, xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wro=
te:
> > From: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> >
> > No any output from kmem.slabinfo, which is not friendly. Adding
> > tips for it.
> >
> > Signed-off-by: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e8ca4bdcb03c..58d3bd93890b 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5002,10 +5002,8 @@ static ssize_t memcg_write_event_control(struct =
kernfs_open_file *of,
> >  #if defined(CONFIG_MEMCG_KMEM) && (defined(CONFIG_SLAB) || defined(CON=
FIG_SLUB_DEBUG))
> >  static int mem_cgroup_slab_show(struct seq_file *m, void *p)
> >  {
> > -     /*
> > -      * Deprecated.
> > -      * Please, take a look at tools/cgroup/memcg_slabinfo.py .
> > -      */
> > +     seq_puts(m, "This file is deprecated.\n"
> > +             "Please use tools/cgroup/memcg_slabinfo.py, which is in k=
ernel source.\n");
>
> It'll break the ABI.
> The only possible option here is to use WARN_ON_ONCE(), which will print =
once to dmesg.
> But honestly I'm not sure we need it.

Ok, thanks for the comments.

>
> Thanks!
>
