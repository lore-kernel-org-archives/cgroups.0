From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v4] mm: memcontrol: Add the missing
 numa_stat interface for cgroup v2
Date: Wed, 16 Sep 2020 00:01:41 +0800
Message-ID: <CAMZfGtVQtsFmU_5DVSZ1mFCnqZrPHrJFKT81Zg8TXDM7c74TDQ@mail.gmail.com>
References: <20200915055825.5279-1-songmuchun@bytedance.com> <a3e2a7bf-ae5a-9ca8-74f9-57af795f0380@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rnn7brXuIav3vAJTNVyPdEtGBil0goNlmFybmIVcOOc=;
        b=PTyR5b3m8PvFl4k4qRhRZIkSU9mFdibCwuJoEEZyE7EFbYgXGr4CcNzaev27AjjfNc
         HoCamxH5F/HWhJfSDX+OxZ3APaUc1piqWZ5C+iIe+CPpXvToy3TDWysXE1tG4T9cGFdk
         +qASkYp6nF/cB/pFMhLJF+WxCtaZk+IsKBKpOcXI59vQSqFNxEVWVlP384in/vbsvdMv
         NF0Zer0ktFfIbKm+vjp/5IKg2aq4fkoIkaVyBrV4eH/EoF1oIq9hEI8ZZz6dxJ2DK/lM
         LiFfSrW505/AmnrJ0giADbQGzmcL0R899C73AmhF4l+Gszx/MbcuPpM9CmtC75eOBOC5
         PDxQ==
In-Reply-To: <a3e2a7bf-ae5a-9ca8-74f9-57af795f0380-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Sep 15, 2020 at 11:45 PM Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> Hi,
>
> On 9/14/20 10:58 PM, Muchun Song wrote:
> > In the cgroup v1, we have a numa_stat interface. This is useful for
> > providing visibility into the numa locality information within an
> > memcg since the pages are allowed to be allocated from any physical
> > node. One of the use cases is evaluating application performance by
> > combining this information with the application's CPU allocation.
> > But the cgroup v2 does not. So this patch adds the missing information.
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  changelog in v4:
> >  1. Fix some document problems pointed out by Randy Dunlap.
> >  2. Remove memory_numa_stat_format() suggested by Shakeel Butt.
> >
> >  changelog in v3:
> >  1. Fix compiler error on powerpc architecture reported by kernel test robot.
> >  2. Fix a typo from "anno" to "anon".
> >
> >  changelog in v2:
> >  1. Add memory.numa_stat interface in cgroup v2.
> >
> >  Documentation/admin-guide/cgroup-v2.rst | 72 +++++++++++++++++++++
> >  mm/memcontrol.c                         | 86 +++++++++++++++++++++++++
> >  2 files changed, 158 insertions(+)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 6be43781ec7f..bcb7b202e88d 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1368,6 +1368,78 @@ PAGE_SIZE multiple when read back.
> >               collapsing an existing range of pages. This counter is not
> >               present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
> >
> > +  memory.numa_stat
> > +     A read-only flat-keyed file which exists on non-root cgroups.
> > +
> > +     This breaks down the cgroup's memory footprint into different
> > +     types of memory, type-specific details, and other information
> > +     per node on the state of the memory management system.
> > +
> > +     This is useful for providing visibility into the NUMA locality
> > +     information within an memcg since the pages are allowed to be
> > +     allocated from any physical node. One of the use cases is evaluating
> > +     application performance by combining this information with the
> > +     application's CPU allocation.
> > +
> > +     All memory amounts are in bytes.
> > +
> > +     The output format of memory.numa_stat is::
> > +
> > +       type N0=<bytes in node 0 pages> N1=<bytes in node 1 pages> ...
>
> I'm OK with Shakeel's suggested change here.
>
> > +     The entries are ordered to be human readable, and new entries
> > +     can show up in the middle. Don't rely on items remaining in a
> > +     fixed position; use the keys to look up specific values!
> > +
> > +       anon
> > +             Amount of memory per node used in anonymous mappings such
> > +             as brk(), sbrk(), and mmap(MAP_ANONYMOUS).
> > +
> > +       file
> > +             Amount of memory per node used to cache filesystem data,
> > +             including tmpfs and shared memory.
> > +
> > +       kernel_stack
> > +             Amount of memory per node allocated to kernel stacks.
> > +
> > +       shmem
> > +             Amount of cached filesystem data per node that is swap-backed,
> > +             such as tmpfs, shm segments, shared anonymous mmap()s.
> > +
> > +       file_mapped
> > +             Amount of cached filesystem data per node mapped with mmap().
> > +
> > +       file_dirty
> > +             Amount of cached filesystem data per node that was modified but
> > +             not yet written back to disk.
> > +
> > +       file_writeback
> > +             Amount of cached filesystem data per node that was modified and
> > +             is currently being written back to disk.
> > +
> > +       anon_thp
> > +             Amount of memory per node used in anonymous mappings backed by
> > +             transparent hugepages.
> > +
> > +       inactive_anon, active_anon, inactive_file, active_file, unevictable
> > +             Amount of memory, swap-backed and filesystem-backed,
> > +             per node on the internal memory management lists used
> > +             by the page reclaim algorithm.
> > +
> > +             As these represent internal list state (e.g. shmem pages are on
> > +             anon memory management lists), inactive_foo + active_foo may not
> > +             be equal to the value for the foo counter, since the foo counter
> > +             is type-based, not list-based.
> > +
> > +       slab_reclaimable
> > +             Amount of memory per node used for storing in-kernel data
> > +             structures which might be reclaimed, such as dentries and
> > +             inodes.
> > +
> > +       slab_unreclaimable
> > +             Amount of memory per node used for storing in-kernel data
> > +             structures which cannot be reclaimed on memory pressure.
> > +
> >    memory.swap.current
> >       A read-only single value file which exists on non-root
> >       cgroups.
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 75cd1a1e66c8..ff919ef3b57b 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6425,6 +6425,86 @@ static int memory_stat_show(struct seq_file *m, void *v)
> >       return 0;
> >  }
> >
> > +#ifdef CONFIG_NUMA
> > +struct numa_stat {
> > +     const char *name;
> > +     unsigned int ratio;
> > +     enum node_stat_item idx;
> > +};
> > +
> > +static struct numa_stat numa_stats[] = {
> > +     { "anon", PAGE_SIZE, NR_ANON_MAPPED },
> > +     { "file", PAGE_SIZE, NR_FILE_PAGES },
> > +     { "kernel_stack", 1024, NR_KERNEL_STACK_KB },
> > +     { "shmem", PAGE_SIZE, NR_SHMEM },
> > +     { "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
> > +     { "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
> > +     { "file_writeback", PAGE_SIZE, NR_WRITEBACK },
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +     /*
> > +      * The ratio will be initialized in numa_stats_init(). Because
> > +      * on some architectures, the macro of HPAGE_PMD_SIZE is not
> > +      * constant(e.g. powerpc).
> > +      */
> > +     { "anon_thp", 0, NR_ANON_THPS },
> > +#endif
> > +     { "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
> > +     { "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
> > +     { "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
> > +     { "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
> > +     { "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
> > +     { "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
> > +     { "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
> > +};
> > +
> > +static int __init numa_stats_init(void)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +             if (numa_stats[i].idx == NR_ANON_THPS)
> > +                     numa_stats[i].ratio = HPAGE_PMD_SIZE;
> > +#endif
> > +     }
>
> Although the loop may be needed sometime in the future due to
> other changes.. why couldn't it be like this for now?

The compiler is so smart, so there is nothing difference between
them. I disassemble the numa_stats_init when
!CONFIG_TRANSPARENT_HUGEPAGE.

Dump of assembler code for function numa_stats_init:
   0xffffffff8273b061 <+0>: callq  0xffffffff81057490 <__fentry__>
   0xffffffff8273b066 <+5>: xor    %eax,%eax
   0xffffffff8273b068 <+7>: retq

>
>
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +     for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
> > +             if (numa_stats[i].idx == NR_ANON_THPS)
> > +                     numa_stats[i].ratio = HPAGE_PMD_SIZE;
> > +     }
> > +#endif
>
>
> > +
> > +     return 0;
> > +}
> > +pure_initcall(numa_stats_init);
>
>
> thanks.
> --
> ~Randy
>


-- 
Yours,
Muchun
