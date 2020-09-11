From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: Add the missing numa stat
 of anon and file for cgroup v2
Date: Fri, 11 Sep 2020 14:51:33 -0700
Message-ID: <20200911215133.GD1163084@carbon.dhcp.thefacebook.com>
References: <20200910084258.22293-1-songmuchun@bytedance.com>
 <CALvZod5JQWGHUAPnj9S0pKFQreLPST441mZnp+h=fue_nnh1yQ@mail.gmail.com>
 <CAMZfGtUncFZZe2RDb54ALMt1DAVqBxAD1TQrpjei1H5nRbH6jg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=+cHyWJM/k6ZvAGNU1rhyNtRlMgYYyGXeA8nsE+XExs4=;
 b=qtUJMGD4ittKGAab9GoWTFdNnO57VoeRfbKBG9J/dfGWEIq+l6ajhCF0mvTeZVR1H3Bz
 0VPrcPukSnYMqDT72At1wGUu3rNEeA5+yJZEDOOxCwdzx5YKP9b8/fV0cW3qCkd+xRcJ
 ii+vGVNWFJzyhWAHbVcOJoOALJq/Om0/kvM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cHyWJM/k6ZvAGNU1rhyNtRlMgYYyGXeA8nsE+XExs4=;
 b=BWoNeM4+d2BGt9cA7hcV4/vwCApbH/DGxZNR49OFQ8wt/TQVhRooBfLGXc04BaJD6RfyyvEmGsNlvZ3JpcrGMH9LVVNO1FOLhfP0UFMLCOBuDSqdsqWydzyp5SavrlPWDFcyxHSzr4XKdL9WkAR0Cx8AM2sJv3qHxiNnLc6Fens=
Content-Disposition: inline
In-Reply-To: <CAMZfGtUncFZZe2RDb54ALMt1DAVqBxAD1TQrpjei1H5nRbH6jg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 11, 2020 at 11:51:42AM +0800, Muchun Song wrote:
> On Fri, Sep 11, 2020 at 12:02 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Thu, Sep 10, 2020 at 1:46 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > >
> > > In the cgroup v1, we have a numa_stat interface. This is useful for
> > > providing visibility into the numa locality information within an
> > > memcg since the pages are allowed to be allocated from any physical
> > > node. One of the use cases is evaluating application performance by
> > > combining this information with the application's CPU allocation.
> > > But the cgroup v2 does not. So this patch adds the missing information.
> > >
> > > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > > ---
> >
> > I am actually working on exposing this info on v2 as well.
> >
> > >  mm/memcontrol.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 44 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 75cd1a1e66c8..c779673f29b2 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -1492,10 +1492,34 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
> > >         return false;
> > >  }
> > >
> > > +#ifdef CONFIG_NUMA
> > > +static unsigned long memcg_node_page_state(struct mem_cgroup *memcg,
> > > +                                          unsigned int nid,
> > > +                                          enum node_stat_item idx)
> > > +{
> > > +       long x;
> > > +       struct mem_cgroup_per_node *pn;
> > > +       struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> > > +
> > > +       VM_BUG_ON(nid >= nr_node_ids);
> > > +
> > > +       pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> > > +       x = atomic_long_read(&pn->lruvec_stat[idx]);
> > > +#ifdef CONFIG_SMP
> > > +       if (x < 0)
> > > +               x = 0;
> > > +#endif
> > > +       return x;
> > > +}
> > > +#endif
> > > +
> > >  static char *memory_stat_format(struct mem_cgroup *memcg)
> > >  {
> > >         struct seq_buf s;
> > >         int i;
> > > +#ifdef CONFIG_NUMA
> > > +       int nid;
> > > +#endif
> > >
> > >         seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);
> > >         if (!s.buffer)
> > > @@ -1512,12 +1536,30 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
> > >          * Current memory state:
> > >          */
> > >
> >
> > Let's not break the parsers of memory.stat. I would prefer a separate
> > interface like v1 i.e. memory.numa_stat.
> 
> It is also a good idea to expose a new interface like memory.numa_stat.
> 
> >
> > > -       seq_buf_printf(&s, "anon %llu\n",
> > > +       seq_buf_printf(&s, "anon %llu",
> > >                        (u64)memcg_page_state(memcg, NR_ANON_MAPPED) *
> > >                        PAGE_SIZE);
> > > -       seq_buf_printf(&s, "file %llu\n",
> > > +#ifdef CONFIG_NUMA
> > > +       for_each_node_state(nid, N_MEMORY)
> > > +               seq_buf_printf(&s, " N%d=%llu", nid,
> > > +                              (u64)memcg_node_page_state(memcg, nid,
> > > +                                                         NR_ANON_MAPPED) *
> > > +                              PAGE_SIZE);
> > > +#endif
> > > +       seq_buf_putc(&s, '\n');
> > > +
> > > +       seq_buf_printf(&s, "file %llu",
> > >                        (u64)memcg_page_state(memcg, NR_FILE_PAGES) *
> > >                        PAGE_SIZE);
> > > +#ifdef CONFIG_NUMA
> > > +       for_each_node_state(nid, N_MEMORY)
> > > +               seq_buf_printf(&s, " N%d=%llu", nid,
> > > +                              (u64)memcg_node_page_state(memcg, nid,
> > > +                                                         NR_FILE_PAGES) *
> > > +                              PAGE_SIZE);
> > > +#endif
> > > +       seq_buf_putc(&s, '\n');
> > > +
> >
> > The v1's numa_stat exposes the LRUs, why NR_ANON_MAPPED and NR_FILE_PAGES?
> 
> If we want to expose the anon per node, we need to add inactive anon and
> active anon together. Why not use NR_ANON_MAPPED directly?
> 
> >
> > Also I think exposing slab_[un]reclaimable per node would be beneficial as well.
> 
> Yeah, I agree with you. Maybe kernel_stack and percpu also should
> be exposed.

Percpu allocations are usually spread over multiple pages and numa nodes,
so there are no per-node pepcpu counters.

Thanks!

> 
> >
> > >         seq_buf_printf(&s, "kernel_stack %llu\n",
> > >                        (u64)memcg_page_state(memcg, NR_KERNEL_STACK_KB) *
> > >                        1024);
> > > --
> > > 2.20.1
> > >
> 
> 
> 
> -- 
> Yours,
> Muchun
