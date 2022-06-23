From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Wed, 22 Jun 2022 17:24:55 -0700
Message-ID: <CAJD7tkag2sj86FXnMb+v4GhDJWOZ_tNpMMCde8faEgqdQ9=uEg@mail.gmail.com>
References: <20220623000530.1194226-1-yosryahmed@google.com> <20220622171624.fc7de8d0ab18a5cf663f8ab8@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGc760CUzqfAXiBkGN4MiPEho4dLgNkLq+hTF2lwnHA=;
        b=gQuswyeZ2unJsJtQNdmDZ13sMjSqQo1RWSPOiC/NK2N6itjLR5J+1pYFpBUaOk6nGg
         z+eBGxEETPfbh6+Q/63zwgCuErxr1n5GlLO2m24RI9cwyao/BcBdP5QxFZb4hbKT5u9S
         5ZWz9nJuRU6vErz7/qraQ8ex4nAKDzu/I6waUlkUe/Dymw127vM04k6MDKa8JQQVJNRp
         MEM20FVHD7SEBwGul5ytxZpGM2ExN8pkl9+MfLjZOGxUCQK6nCy5A5DDHQGfFFkEUd7s
         twcRMDz8TGTNcaoADcabM6Q7zjLE+6dLSgcXdTT+XOe04JLMDh6byVctoHADa4HYUVNS
         GfKg==
In-Reply-To: <20220622171624.fc7de8d0ab18a5cf663f8ab8-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Jun 22, 2022 at 5:16 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Thu, 23 Jun 2022 00:05:30 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > Commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> > as memory pressure") made sure that memory reclaim that is induced by
> > userspace (limit-setting, proactive reclaim, ..) is not counted as
> > memory pressure for the purposes of psi.
> >
> > Instead of counting psi inside try_to_free_mem_cgroup_pages(), callers
> > from try_charge() and reclaim_high() wrap the call to
> > try_to_free_mem_cgroup_pages() with psi handlers.
> >
> > However, vmpressure is still counted in these cases where reclaim is
> > directly induced by userspace. This patch makes sure vmpressure is not
> > counted in those operations, in the same way as psi. Since vmpressure
> > calls need to happen deeper within the reclaim path, the same approach
> > could not be followed. Hence, a new "controlled" flag is added to struct
> > scan_control to flag a reclaim operation that is controlled by
> > userspace. This flag is set by limit-setting and proactive reclaim
> > operations, and is used to count vmpressure correctly.
> >
> > To prevent future divergence of psi and vmpressure, commit e22c6ed90aa9
> > ("mm: memcontrol: don't count limit-setting reclaim as memory pressure")
> > is effectively reverted and the same flag is used to control psi as
> > well.
>
> I'll await reviewer input on this, but I can always do trivia!

Thanks for taking a look so quickly, will address and send v2 soon!

>
> > @@ -3502,6 +3497,8 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
> >  static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
> >  {
> >       int nr_retries = MAX_RECLAIM_RETRIES;
> > +     unsigned int reclaim_options = MEMCG_RECLAIM_CONTROLLED |
> > +             MEMCG_RECLAIM_MAY_SWAP;
>
> If it doesn't fit, it's nicer to do
>
>         unsigned int reclaim_options;
>         ...
>
>         reclaim_options = MEMCG_RECLAIM_CONTROLLED | MEMCG_RECLAIM_MAY_SWAP;
>
> (several places)
>
> > @@ -3751,6 +3757,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> >               .may_writepage = !laptop_mode,
> >               .may_unmap = 1,
> >               .may_swap = 1,
> > +             .controlled = 0,
> >       };
>
> Let's just skip all these initializations to zero, let the compiler take
> care of it.
>
> > @@ -4095,6 +4112,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
> >               .gfp_mask = GFP_KERNEL,
> >               .order = order,
> >               .may_unmap = 1,
> > +             .controlled = 0,
> >       };
> >
> >       set_task_reclaim_state(current, &sc.reclaim_state);
> > @@ -4555,6 +4573,7 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
> >               .may_unmap = 1,
> >               .may_swap = 1,
> >               .hibernation_mode = 1,
> > +             .controlled = 0,
> >       };
> >       struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
> >       unsigned long nr_reclaimed;
> > @@ -4707,6 +4726,7 @@ static int __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned in
> >               .may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP),
> >               .may_swap = 1,
> >               .reclaim_idx = gfp_zone(gfp_mask),
> > +             .controlled = 0,
> >       };
> >       unsigned long pflags;
>
>
