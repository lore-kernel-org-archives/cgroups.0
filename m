From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] mm: vmpressure: don't count proactive reclaim in vmpressure
Date: Wed, 6 Jul 2022 13:19:56 -0700
Message-ID: <CAJD7tkZ7haRwRgE5723Sfqr4WzeoATy-3SUROgAZpinyxsMt2Q@mail.gmail.com>
References: <20220630083044.997474-1-yosryahmed@google.com> <20220701160947.e4902e5b0484ed084db5d41f@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zN05oMg9A5eMExVvuhLNwOOx17/+XHETTJXVnUtgWnA=;
        b=T6LSPKDIQlfkCde1dkkcPrJsSgkHNqUSJpiXKz/0vT1OX0fc18YBReSbC51uYTchM9
         /gQT9y8WsL8XZQPIyiTT2IU6yDNYMTHbdkW4gKnLR0WEBfSxw0mcKXEyrIVwnn6Bov8U
         IpqUrIX6zjWpKYr3tV3SGFvdrx2ZvGxsSPDVC7jOAeSy6CcZtY//HpliLN50I4rR+KpV
         xW/f9UEvQHE52zXqJGyZKMr7jZhWHUAs9uWPj51w0ZZFp8GYPDTG3N3b8v9O5wyBf2QR
         RD0vMPEqy0M85Z3kt0tDYjQre0PGe7u18n6V4HvBonyimUFpLgkq7R0p1ENxG7VI13To
         8fEA==
In-Reply-To: <20220701160947.e4902e5b0484ed084db5d41f-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Jul 1, 2022 at 4:09 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Thu, 30 Jun 2022 08:30:44 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > vmpressure is used in cgroup v1 to notify userspace of reclaim
> > efficiency events, and is also used in both cgroup v1 and v2 as a signal
> > for memory pressure for networking, see
> > mem_cgroup_under_socket_pressure().
> >
> > Proactive reclaim intends to probe memcgs for cold memory, without
> > affecting their performance. Hence, reclaim caused by writing to
> > memory.reclaim should not trigger vmpressure.
> >
> > ...
> >
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2319,6 +2319,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
> >                                 gfp_t gfp_mask)
> >  {
> >       unsigned long nr_reclaimed = 0;
> > +     unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> >
> >       do {
> >               unsigned long pflags;
> > @@ -2331,7 +2332,8 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
> >
> >               psi_memstall_enter(&pflags);
> >               nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
> > -                                                          gfp_mask, true);
> > +                                                          gfp_mask,
> > +                                                          reclaim_options);
>
> It's a bit irksome to create all these unneeded local variables.  Why
> not simply add the constant arg to the try_to_free_mem_cgroup_pages()
> call?
>

I was trying to improve readability by trying to have consistent
reclaim_options local variable passed into
try_to_free_mem_cgroup_pages(), and also to avoid nested line-wrapping
in cases where reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
MEMCG_RECLAIM_PROACTIVE (like in memory_reclaim()). Since you found it
irksome, I obviously failed :)

Will remove the local variables where possible and send a v4. Thanks
for taking a look!

> >               psi_memstall_leave(&pflags);
> >       } while ((memcg = parent_mem_cgroup(memcg)) &&
> >                !mem_cgroup_is_root(memcg));
> > @@ -2576,7 +2578,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >       struct page_counter *counter;
> >       unsigned long nr_reclaimed;
> >       bool passed_oom = false;
> > -     bool may_swap = true;
> > +     unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> >       bool drained = false;
> >       unsigned long pflags;
> >
> > @@ -2593,7 +2595,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >               mem_over_limit = mem_cgroup_from_counter(counter, memory);
> >       } else {
> >               mem_over_limit = mem_cgroup_from_counter(counter, memsw);
> > -             may_swap = false;
> > +             reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
>
>         reclaim_options = 0
>
> would be clearer?
>

I feel like the current code is more clear to the reader and
future-proof. If we can't swap, we want to remove the MAY_SWAP flag,
we don't want to remove all existing flags. In this case it's the
same, but maybe in the future it won't be and someone will miss
updating this line. Anyway, I don't have a strong opinion, let me know
what you prefer for v4.
