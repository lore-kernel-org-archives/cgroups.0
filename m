From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3] mm: vmpressure: don't count proactive reclaim in vmpressure
Date: Tue, 12 Jul 2022 15:51:54 -0700
Message-ID: <CAJD7tkbvPX+jMHOF6TbhBYvX-3nZ+k4-7NEKX5cudBS7ZuSNdQ@mail.gmail.com>
References: <20220630083044.997474-1-yosryahmed@google.com>
 <20220701160947.e4902e5b0484ed084db5d41f@linux-foundation.org> <CAJD7tkZ7haRwRgE5723Sfqr4WzeoATy-3SUROgAZpinyxsMt2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=htaxsmbLkerK/WzSwDGnn60xtZCz4ZbFlZTWngCZmEo=;
        b=PJvAiv/DmAKyikrJij5JE66g75DNqz4DHzNmHd/JdP5z0zk7MZqnCrSzDvKAn/vIHL
         /D1NSeoCJVH6odh+Uj/o+s5cBf7HLPhJcKRVVRRPWXogWz+S1pndViMAUC1Zvw5ESZAP
         a4uDkbnnM/6ytDcaYwsBLjwLxeO9Rih93Gr+RXKEKTPt1wqx/q0JXbde46/8Bpzm1NLV
         78Bw7c0NvdCwXjhEsfKVunNKJ9ihm2+YXJqQWj5UFZzKq30VoqbtCJCBYX34Eh3+yLHx
         tX5KytQJPfANtkoIvguy1zTKRUksrSmQqW7JiP3kjvDh4jRUVC8MV/aTs5+JNNpJOxnR
         3ZKw==
In-Reply-To: <CAJD7tkZ7haRwRgE5723Sfqr4WzeoATy-3SUROgAZpinyxsMt2Q@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>, NeilBrown <neilb@suse.de>, Alistair Popple <apopple@nvidia.com>, Suren Baghdasaryan <surenb@google.com>, Peter Xu <peterx@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>

On Wed, Jul 6, 2022 at 1:19 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Fri, Jul 1, 2022 at 4:09 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Thu, 30 Jun 2022 08:30:44 +0000 Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > > vmpressure is used in cgroup v1 to notify userspace of reclaim
> > > efficiency events, and is also used in both cgroup v1 and v2 as a signal
> > > for memory pressure for networking, see
> > > mem_cgroup_under_socket_pressure().
> > >
> > > Proactive reclaim intends to probe memcgs for cold memory, without
> > > affecting their performance. Hence, reclaim caused by writing to
> > > memory.reclaim should not trigger vmpressure.
> > >
> > > ...
> > >
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2319,6 +2319,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
> > >                                 gfp_t gfp_mask)
> > >  {
> > >       unsigned long nr_reclaimed = 0;
> > > +     unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> > >
> > >       do {
> > >               unsigned long pflags;
> > > @@ -2331,7 +2332,8 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
> > >
> > >               psi_memstall_enter(&pflags);
> > >               nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
> > > -                                                          gfp_mask, true);
> > > +                                                          gfp_mask,
> > > +                                                          reclaim_options);
> >
> > It's a bit irksome to create all these unneeded local variables.  Why
> > not simply add the constant arg to the try_to_free_mem_cgroup_pages()
> > call?
> >
>
> I was trying to improve readability by trying to have consistent
> reclaim_options local variable passed into
> try_to_free_mem_cgroup_pages(), and also to avoid nested line-wrapping
> in cases where reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
> MEMCG_RECLAIM_PROACTIVE (like in memory_reclaim()). Since you found it
> irksome, I obviously failed :)
>
> Will remove the local variables where possible and send a v4. Thanks
> for taking a look!
>
> > >               psi_memstall_leave(&pflags);
> > >       } while ((memcg = parent_mem_cgroup(memcg)) &&
> > >                !mem_cgroup_is_root(memcg));
> > > @@ -2576,7 +2578,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > >       struct page_counter *counter;
> > >       unsigned long nr_reclaimed;
> > >       bool passed_oom = false;
> > > -     bool may_swap = true;
> > > +     unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> > >       bool drained = false;
> > >       unsigned long pflags;
> > >
> > > @@ -2593,7 +2595,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > >               mem_over_limit = mem_cgroup_from_counter(counter, memory);
> > >       } else {
> > >               mem_over_limit = mem_cgroup_from_counter(counter, memsw);
> > > -             may_swap = false;
> > > +             reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
> >
> >         reclaim_options = 0
> >
> > would be clearer?
> >
>
> I feel like the current code is more clear to the reader and
> future-proof. If we can't swap, we want to remove the MAY_SWAP flag,
> we don't want to remove all existing flags. In this case it's the
> same, but maybe in the future it won't be and someone will miss
> updating this line. Anyway, I don't have a strong opinion, let me know
> what you prefer for v4.


Andrew, any preferences on this before I send v4?
