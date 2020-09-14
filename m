From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v3] mm: memcontrol: Add the missing
 numa_stat interface for cgroup v2
Date: Tue, 15 Sep 2020 00:54:50 +0800
Message-ID: <CAMZfGtXoBrFioh=FqRA82ZRSt=2oW=ie8BgZE0hAvtCOBRMXiw@mail.gmail.com>
References: <20200913070010.44053-1-songmuchun@bytedance.com> <CALvZod7VH3NDwBXrY9w95pUY7DV+R-b_chBHuygmwH_bhpULkQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nn8uGO9a9X0XwaIfMVFd2VgaWgHbpK8dvPYHd7Sq/nA=;
        b=RB+2IbSgUvQBoAdsF0OTSCz20nt98NJ5VHwnf9jRx7zYNTMQeX4LZz03zL76irCDsG
         0mdg45wZp2YAKNVNcAwTPfapLTrblMQfnEi5juhLmTb8jSzbarIx3WRVlOGm1lwO0q4M
         JQXKYTnJSK2DV38j5skJQDiuqxCdrQ3kOy8gMmaXArc3C/XUvXxCidE0P/u3zhA62+yi
         xxn5pXMlfzPSghT6dqYreCTRbu1o6GiEEvmXJk4bl7fHVfWaL8keJwVa0PHKeirScjuK
         prJC8gaEvEx5yF4bvJyP9nUjr2ef9WkOsxRj3i4EAEkOXmG5T4VYP6A9imu3h5LqM1Nm
         5WRg==
In-Reply-To: <CALvZod7VH3NDwBXrY9w95pUY7DV+R-b_chBHuygmwH_bhpULkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Sep 15, 2020 at 12:07 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Sun, Sep 13, 2020 at 12:01 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> >
> > In the cgroup v1, we have a numa_stat interface. This is useful for
> > providing visibility into the numa locality information within an
> > memcg since the pages are allowed to be allocated from any physical
> > node. One of the use cases is evaluating application performance by
> > combining this information with the application's CPU allocation.
> > But the cgroup v2 does not. So this patch adds the missing information.
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> [snip]
> > +
> > +static struct numa_stat numa_stats[] = {
> > +       { "anon", PAGE_SIZE, NR_ANON_MAPPED },
> > +       { "file", PAGE_SIZE, NR_FILE_PAGES },
> > +       { "kernel_stack", 1024, NR_KERNEL_STACK_KB },
> > +       { "shmem", PAGE_SIZE, NR_SHMEM },
> > +       { "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
> > +       { "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
> > +       { "file_writeback", PAGE_SIZE, NR_WRITEBACK },
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +       /*
> > +        * The ratio will be initialized in numa_stats_init(). Because
> > +        * on some architectures, the macro of HPAGE_PMD_SIZE is not
> > +        * constant(e.g. powerpc).
> > +        */
> > +       { "anon_thp", 0, NR_ANON_THPS },
> > +#endif
> > +       { "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
> > +       { "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
> > +       { "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
> > +       { "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
> > +       { "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
> > +       { "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
> > +       { "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
> > +};
> > +
> > +static int __init numa_stats_init(void)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +               if (numa_stats[i].idx == NR_ANON_THPS)
> > +                       numa_stats[i].ratio = HPAGE_PMD_SIZE;
> > +#endif
> > +       }
>
> The for loop seems excessive but I don't really have a good alternative.

Yeah, I also have no good alternative. The numa_stats is only initialized
once. So there may be no problem :).

>
> > +
> > +       return 0;
> > +}
> > +pure_initcall(numa_stats_init);
> > +
> > +static unsigned long memcg_node_page_state(struct mem_cgroup *memcg,
> > +                                          unsigned int nid,
> > +                                          enum node_stat_item idx)
> > +{
> > +       VM_BUG_ON(nid >= nr_node_ids);
> > +       return lruvec_page_state(mem_cgroup_lruvec(memcg, NODE_DATA(nid)), idx);
> > +}
> > +
> > +static const char *memory_numa_stat_format(struct mem_cgroup *memcg)
> > +{
> > +       int i;
> > +       struct seq_buf s;
> > +
> > +       /* Reserve a byte for the trailing null */
> > +       seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE - 1);
> > +       if (!s.buffer)
> > +               return NULL;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
> > +               int nid;
> > +
> > +               seq_buf_printf(&s, "%s", numa_stats[i].name);
> > +               for_each_node_state(nid, N_MEMORY) {
> > +                       u64 size;
> > +
> > +                       size = memcg_node_page_state(memcg, nid,
> > +                                                    numa_stats[i].idx);
> > +                       size *= numa_stats[i].ratio;
> > +                       seq_buf_printf(&s, " N%d=%llu", nid, size);
> > +               }
> > +               seq_buf_putc(&s, '\n');
> > +       }
> > +
> > +       /* The above should easily fit into one page */
> > +       if (WARN_ON_ONCE(seq_buf_putc(&s, '\0')))
> > +               s.buffer[PAGE_SIZE - 1] = '\0';
>
> I think you should follow Michal's recommendation at
> http://lkml.kernel.org/r/20200914115724.GO16999-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org

Here is different, because the seq_buf_putc(&s, '\n') will not add \0 unless
we use seq_buf_puts(&s, "\n").


-- 
Yours,
Muchun
