From: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: export workingset refault stats for cgroup v1
Date: Wed, 17 Aug 2022 14:10:26 -0700
Message-ID: <CAHbLzkqpC+kwAmVNw+w+YejS8fowEhseizc+E2PzChAYy3HBAQ@mail.gmail.com>
References: <20220816185801.651091-1-shy828301@gmail.com> <CALvZod5t7Qo1NQ040pRyWco+nJGn3hSrxZyuFQ0UBi31Ni6=_g@mail.gmail.com>
 <CAHbLzkrSU3ZHRiZAxy9Jju3-3ZFpDmE4uMx81c+yPWN28_j+tw@mail.gmail.com> <CALvZod6558Ub52uvyGq02474noskMGf-jqeCEyoLqY0s4brQQw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=jubgmtu9ZCV2QamN97BJw9SKo7GeHiKN8FVBsuK4MpI=;
        b=ht0aNzrRUImTnu8m1fHSTGs+ufFWe/8x7bzHLosVnh7BI1beTfMKcxipuQ0yK5aeis
         9slQDNzhO5mKIxJGUa2m6YRI87WzGWk37jrmGvTQhUY/oPtIPce3BMRowls9MzMKTwUB
         bkE2Da0iUdGcVkeONg7sUqORvzcdE5CZOZAWlY4Cx2EN0f5FkB5lNy5OAuwZvhcDaZRt
         KvHtVJDhe/ZpIpdLnaFfelO8+TiwhFpYyu6B63i+hB/qUo4iPV5H5ZGcvDqbGRHsZDJ8
         fOT4hjPork4yl/xLMWag47Aynp0q/xot6f/Zvd+/f2Wv5yX6E6LbpcalrtAphtGsuB5S
         Inxg==
In-Reply-To: <CALvZod6558Ub52uvyGq02474noskMGf-jqeCEyoLqY0s4brQQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Aug 16, 2022 at 7:05 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, Aug 16, 2022 at 7:01 PM Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Tue, Aug 16, 2022 at 3:06 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Tue, Aug 16, 2022 at 11:58 AM Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > >
> > > > Workingset refault stats are important and usefule metrics to measure
> > > > how well reclaimer and swapping work and how healthy the services are,
> > > > but they are just available for cgroup v2.  There are still plenty users
> > > > with cgroup v1, export the stats for cgroup v1.
> > > >
> > > > Signed-off-by: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > > ---
> > > > I do understand the development of cgroup v1 is actually stalled and
> > > > the community is reluctant to accept new features for v1.  However
> > > > the workingset refault stats are really quite useful and exporting
> > > > two new stats, which have been supported by v2, seems ok IMHO.  So
> > > > hopefully this patch could be considered.  Thanks.
> > > >
> > >
> > > Is just workingset refault good enough for your use-case? What about
> > > the other workingset stats? I don't have a strong opinion against
> > > adding these to v1 and I think these specific stats should be fine.
> >
> > The workingset refault is good enough for our usercase, but I don't
> > mind adding all the workingset_* stats if nobody has objection.
>
> For now let's just start with what your use-case needs. If in future
> there is a need we can add other workingset_* stats as well.

Sure, works for me.

>
> >
> > > (There is subtlety in exposing objcg based stats (i.e. reparenting) in
> > > v1 due to non-hierarchical stats in v1. I remember Yosry and Muchun
> > > were looking into that.)
> >
> > The workingset_* stats should have nothing to do with obj based stats IIUC.
>
> Yeah, that was just FYI for anyone in future who wants to export such
> stat in v1.

Thanks, Shakeel. If it looks good to me, would you please ack the patch?
