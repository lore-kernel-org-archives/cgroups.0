From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 02/16] memcg: enable accounting for IP address and
 routing-related objects
Date: Mon, 19 Jul 2021 07:22:59 -0700
Message-ID: <CALvZod7YhG1Ojp2Eyk=30OBzWr5_AyEW-c1AhQVDn7zpd6mpww@mail.gmail.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com> <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
 <CAJwJo6ZgXDoXevNRte4G3Phei8WcgJ897JebWDkQDnPYrgTTQA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9dzQVKu6j3ok3pHXGU2YjadQUcak15VnK5ptAnsE2nQ=;
        b=PklgTmTvSMwVinlTqF889GVxQI07YN5I6XZrLOHo5AcaDLtgY9qEx6V1VSo/dbLGL3
         zSk1uCn3zuUTz/voDm+IzpF7tmedV9j9ljnKcTGjqHZFlBSn0bQ3gqyam8KLtG1tVymq
         Dfea8Msy6UF7PAS2/AZif3mxDHCa9ZCGCVcoKh7L467wUhuMm0E+GaFU+4ckbUckoW07
         Ynn+l2syik4a7HttWnxq8QiHkkR0K7vQdpZxgsvrFo8G0d36QKY1zTrAJE1bwYF2K2pT
         2YHe4sLvToroZ3xd3xdSU+/9bwlYF2DjfpZpq2bWFFqrjG7tUQRqkMuC8HyVRPhoMhCg
         ieUA==
In-Reply-To: <CAJwJo6ZgXDoXevNRte4G3Phei8WcgJ897JebWDkQDnPYrgTTQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 19, 2021 at 7:00 AM Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Vasily,
>
> On Mon, 19 Jul 2021 at 11:45, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> [..]
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index ae1f5d0..1bbf239 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -968,7 +968,7 @@ static __always_inline bool memcg_kmem_bypass(void)
> >                 return false;
> >
> >         /* Memcg to charge can't be determined. */
> > -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
> > +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
> >                 return true;
>
> This seems to do two separate things in one patch.
> Probably, it's better to separate them.
> (I may miss how route changes are related to more generic
> __alloc_pages() change)
>

It was requested to squash them together in some previous versions.
https://lore.kernel.org/linux-mm/YEiUIf0old+AZssa-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/
