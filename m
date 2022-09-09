From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: reduce size of memcg vmstats structures
Date: Fri, 9 Sep 2022 10:14:35 -0700
Message-ID: <CALvZod5XGH6MzMhqQfLPtD4zXdSNk_EptGN17Gmp-N8HM8Fjkw@mail.gmail.com>
References: <20220907043537.3457014-1-shakeelb@google.com> <20220907043537.3457014-4-shakeelb@google.com>
 <YxqHZtOx2+LUYZth@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=YEKmBV4DSzD2JzeAdPDODbMxDTccaOdJer2Iy9wMS0Y=;
        b=KLtgJv7vnGcaTzYuJKcaPa8SvcX/RhNHCSwGuaj4IxlzcD/vIVBFio3ImKjzb/N58H
         cAGtKDcLeIJ3xxrnwtHxjnFvWHoH2mZCthaFL3jmWfciibNLiFYWrzxT5pYp/hLEduTS
         uxgqJNnfnC3nD8h2/vfLu90tEtccsyTcif0rhGug4TKEbT/jh0MV2XwBQJBNDqGo/rGw
         HBU5H+cDuBLQV30w68xQK5yjGJBXxR0lsg4X63gyCuM37CnQvYQBoYjnm1pMvb44aEQ1
         HGlwzLWYuouZ4QeoCZXhr9Sn7kmwC2feqcLF+o9HC8netoigO7OWALeUIHKWsMtQ8KtZ
         kNoQ==
In-Reply-To: <YxqHZtOx2+LUYZth@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 8, 2022 at 5:23 PM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>
> Hello.
>
> On Wed, Sep 07, 2022 at 04:35:37AM +0000, Shakeel Butt <shakeelb@google.c=
om> wrote:
> >  /* Subset of vm_event_item to report for memcg event stats */
> >  static const unsigned int memcg_vm_event_stat[] =3D {
> > +     PGPGIN,
> > +     PGPGOUT,
> >       PGSCAN_KSWAPD,
> >       PGSCAN_DIRECT,
> >       PGSTEAL_KSWAPD,
>
> What about adding a dummy entry at the beginning like:
>
>  static const unsigned int memcg_vm_event_stat[] =3D {
> +       NR_VM_EVENT_ITEMS,
> +       PGPGIN,
> +       PGPGOUT,
>         PGSCAN_KSWAPD,
>         PGSCAN_DIRECT,
>
>
> > @@ -692,14 +694,30 @@ static const unsigned int memcg_vm_event_stat[] =
=3D {
> >  #endif
> >  };
> >
> > +#define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
> > +static int mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
> > +
> > +static void init_memcg_events(void)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < NR_MEMCG_EVENTS; ++i)
> > +             mem_cgroup_events_index[memcg_vm_event_stat[i]] =3D i + 1=
;
>
> Start such loops from i =3D 1, save i to the table.
>
> > +}
> > +
> > +static inline int memcg_events_index(enum vm_event_item idx)
> > +{
> > +     return mem_cgroup_events_index[idx] - 1;
> > +}
>
> And the there'd be no need for the reverse transforms -1.
>
> I.e. it might be just a negligible micro-optimization but since the
> event updates are on some fast (albeit longer) paths, it may be worth
> sacrificing one of the saved 8Bs in favor of no arithmetics.
>
> What do you think about this?
>
> >  static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
> >  {
> > -     return READ_ONCE(memcg->vmstats->events[event]);
> > +     int index =3D memcg_events_index(event);
> > +
> > +     if (index < 0)
> > +             return 0;
>
> As a bonus these undefined maps could use the zero at the dummy location
> without branch (slow paths though).
>
>
> > @@ -5477,7 +5511,7 @@ static void mem_cgroup_css_rstat_flush(struct cgr=
oup_subsys_state *css, int cpu)
> >                       parent->vmstats->state_pending[i] +=3D delta;
> >       }
> >
> > -     for (i =3D 0; i < NR_VM_EVENT_ITEMS; i++) {
> > +     for (i =3D 0; i < NR_MEMCG_EVENTS; i++) {
>
> I applaud this part :-)
>
>

Hi Michal,

Thanks for taking a look. Let me get back to you on this later. I am
at the moment rearranging struct mem_cgroup for better packing and
will be running some benchmarks. Later I will see if your suggestion
has any performance benefit or just more readable code then I will
follow up.

Shakeel
