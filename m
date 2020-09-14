From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3] mm: memcontrol: Add the missing numa_stat interface
 for cgroup v2
Date: Mon, 14 Sep 2020 09:07:28 -0700
Message-ID: <CALvZod7VH3NDwBXrY9w95pUY7DV+R-b_chBHuygmwH_bhpULkQ@mail.gmail.com>
References: <20200913070010.44053-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K/o4tAbgmhnFT0w3pjwutrP2CtxBURpGRMbYhc3bTBE=;
        b=pPpu3G310vswA/nzxXfPePwsCLMfpRmAnUA0uCGCsS5PHm/yNqAAZL2/DWNTt+l3lM
         PvlI6UlO5TrzkcEInN5arkbz9MYp5S/M8PMd7n++rLAP9m+3RZZ/Am/tFaUXp52FBSLC
         g9fkBMmm8TJVzOiKLzLjysDoYMvdFdpXgllEVnYccmou3TECsBCo4Q2XgnBx3b4PGwt4
         BMgJKPRRG756/BLx5t0gSUmFPXy7A4lKFKoEMbj5iWrtu7xM2kDexDml++76NxnnYD9H
         94UfzpBjkzJ7QZEtd34w21csMPfqIeV1HofiC94xe6y3JiZRWGK2Vp6V0Ze6AjD7WFwN
         V5mA==
In-Reply-To: <20200913070010.44053-1-songmuchun@bytedance.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>

On Sun, Sep 13, 2020 at 12:01 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> In the cgroup v1, we have a numa_stat interface. This is useful for
> providing visibility into the numa locality information within an
> memcg since the pages are allowed to be allocated from any physical
> node. One of the use cases is evaluating application performance by
> combining this information with the application's CPU allocation.
> But the cgroup v2 does not. So this patch adds the missing information.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Suggested-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
[snip]
> +
> +static struct numa_stat numa_stats[] = {
> +       { "anon", PAGE_SIZE, NR_ANON_MAPPED },
> +       { "file", PAGE_SIZE, NR_FILE_PAGES },
> +       { "kernel_stack", 1024, NR_KERNEL_STACK_KB },
> +       { "shmem", PAGE_SIZE, NR_SHMEM },
> +       { "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
> +       { "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
> +       { "file_writeback", PAGE_SIZE, NR_WRITEBACK },
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +       /*
> +        * The ratio will be initialized in numa_stats_init(). Because
> +        * on some architectures, the macro of HPAGE_PMD_SIZE is not
> +        * constant(e.g. powerpc).
> +        */
> +       { "anon_thp", 0, NR_ANON_THPS },
> +#endif
> +       { "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
> +       { "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
> +       { "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
> +       { "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
> +       { "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
> +       { "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
> +       { "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
> +};
> +
> +static int __init numa_stats_init(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +               if (numa_stats[i].idx == NR_ANON_THPS)
> +                       numa_stats[i].ratio = HPAGE_PMD_SIZE;
> +#endif
> +       }

The for loop seems excessive but I don't really have a good alternative.

> +
> +       return 0;
> +}
> +pure_initcall(numa_stats_init);
> +
> +static unsigned long memcg_node_page_state(struct mem_cgroup *memcg,
> +                                          unsigned int nid,
> +                                          enum node_stat_item idx)
> +{
> +       VM_BUG_ON(nid >= nr_node_ids);
> +       return lruvec_page_state(mem_cgroup_lruvec(memcg, NODE_DATA(nid)), idx);
> +}
> +
> +static const char *memory_numa_stat_format(struct mem_cgroup *memcg)
> +{
> +       int i;
> +       struct seq_buf s;
> +
> +       /* Reserve a byte for the trailing null */
> +       seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE - 1);
> +       if (!s.buffer)
> +               return NULL;
> +
> +       for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
> +               int nid;
> +
> +               seq_buf_printf(&s, "%s", numa_stats[i].name);
> +               for_each_node_state(nid, N_MEMORY) {
> +                       u64 size;
> +
> +                       size = memcg_node_page_state(memcg, nid,
> +                                                    numa_stats[i].idx);
> +                       size *= numa_stats[i].ratio;
> +                       seq_buf_printf(&s, " N%d=%llu", nid, size);
> +               }
> +               seq_buf_putc(&s, '\n');
> +       }
> +
> +       /* The above should easily fit into one page */
> +       if (WARN_ON_ONCE(seq_buf_putc(&s, '\0')))
> +               s.buffer[PAGE_SIZE - 1] = '\0';

I think you should follow Michal's recommendation at
http://lkml.kernel.org/r/20200914115724.GO16999@dhcp22.suse.cz
