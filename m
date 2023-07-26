From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg: use rstat for non-hierarchical stats
Date: Wed, 26 Jul 2023 08:14:35 -0700
Message-ID: <CAJD7tkYS1iSo94WhtDE2GbpTkukaKY3aAKTSaUkGj0K5ifek+A@mail.gmail.com>
References: <20230726002904.655377-1-yosryahmed@google.com>
 <20230726002904.655377-2-yosryahmed@google.com> <CAJD7tkZK2T2ebOPw6K0M+YWyKUtx9bE2uyFj4VOehhd+fYnk8w@mail.gmail.com>
 <20230726151315.GB1365610@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690384512; x=1690989312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EmHtEDaViE9w7v3YPcqZQ4Gg5qZi74veSidbXAx7Uuk=;
        b=Z0sm/6YlFBVHxaxcjSwwX/bHyhr+EAoV9DMvYiCLh1gzjeElQo2oiosipQdXcgFCHC
         Dh4l2DPNInb8wFxoVcaMu053NsAepgd8juJJfi4f77Oq8z0fvgOLujl1esBDHY59v22f
         II4Ew7GK+kdxPpty5uTynOE0fZn80NMl/SqI9jM4NmWlTGldJ0png0oDQtxH5YQ2jU3C
         YHPELzG2W5BDzAJ1G9YhcsCe6V4xvHEGxMVEG09eNkGKoa5TFPuol693V9n79qX3GuTR
         7S9RI4L/pBPsq54wiwxps6KS/O679itw93JRxiFCJQL9iOnmPpwTAZkp5AOvwgnOm/En
         ohrA==
In-Reply-To: <20230726151315.GB1365610-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed, Jul 26, 2023 at 8:13=E2=80=AFAM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org=
> wrote:
>
> On Tue, Jul 25, 2023 at 05:36:45PM -0700, Yosry Ahmed wrote:
> > On Tue, Jul 25, 2023 at 5:29=E2=80=AFPM Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > > - Fix a subtle bug where updating a local counter would be missed if =
it
> > >   was cancelled out by a pending update from child memcgs.
> >
> >
> > Johannes, I fixed a subtle bug here and I kept your Ack, I wasn't sure
> > what the Ack retention policy should be here. A quick look at the fix
> > would be great.
>
> Ah, I found it:
>
> > > @@ -5542,19 +5539,23 @@ static void mem_cgroup_css_rstat_flush(struct=
 cgroup_subsys_state *css, int cpu)
> > >                         memcg->vmstats->state_pending[i] =3D 0;
> > >
> > >                 /* Add CPU changes on this level since the last flush=
 */
> > > +               delta_cpu =3D 0;
> > >                 v =3D READ_ONCE(statc->state[i]);
> > >                 if (v !=3D statc->state_prev[i]) {
> > > -                       delta +=3D v - statc->state_prev[i];
> > > +                       delta_cpu =3D v - statc->state_prev[i];
> > > +                       delta +=3D delta_cpu;
> > >                         statc->state_prev[i] =3D v;
> > >                 }
> > >
> > > -               if (!delta)
> > > -                       continue;
> > > -
> > >                 /* Aggregate counts on this level and propagate upwar=
ds */
> > > -               memcg->vmstats->state[i] +=3D delta;
> > > -               if (parent)
> > > -                       parent->vmstats->state_pending[i] +=3D delta;
> > > +               if (delta_cpu)
> > > +                       memcg->vmstats->state_local[i] +=3D delta_cpu=
;
>
> When delta nulls out, but delta_cpu is non-zero... subtle.

Yup, led to a few missed updates, was not trivial to track down :)

>
> This fixed version looks good, please keep my ack :)

Thanks!
