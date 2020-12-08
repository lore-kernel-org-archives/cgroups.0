From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v3 7/7] mm: memcontrol: make the slab
 calculation consistent
Date: Tue, 8 Dec 2020 15:53:05 +0800
Message-ID: <CAMZfGtV=tc3=ZbePPEWTA2ziDb1hw8KzJXc+Uiedx+xmXY--XA@mail.gmail.com>
References: <20201208041847.72122-1-songmuchun@bytedance.com>
 <20201208041847.72122-8-songmuchun@bytedance.com> <CAM9Jb+jg7dD3u4b8P4X_6ginSM3UwVtmbdQzjaencb0r3_bAuQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6yOAVZjGe0LBykCQztVKp2D4Gmc2eJlF3ZDhvK2CW4w=;
        b=I6+h+plxzfDytT3JY5089iYAUGryc03SX1u46qY0mKqZS/nBI9KbegEu4vDHyaZvR8
         1gN8VtP1D147cTFIn3dimmElmmW76jgsNjvyGHLhCTrWY/PbxZ2JNdKmCFX4ErbFkjK6
         HjxKS1TkSg3AOZFe/5hrIX2hAd2b44RDj1bMTGPEEXKy3iMOS7DPGQyzMTKIGLaEinoL
         QMwcLKR5xgMkmSRwfs3nkZLQtNfN/Kn3deg57xuctwnL+SjgCSeNvHrAVcebgTrCUkC9
         5VfC3mjMfe9zjGzylGzR1BMiECSMMYtrSnV24QfimsEQvbnmPOGGuiScUPM2EVmWBFSc
         mGsg==
In-Reply-To: <CAM9Jb+jg7dD3u4b8P4X_6ginSM3UwVtmbdQzjaencb0r3_bAuQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Sami Tolvanen <samitolvanen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Dec 8, 2020 at 3:21 PM Pankaj Gupta
<pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> > Although the ratio of the slab is one, we also should read the ratio
> > from the related memory_stats instead of hard-coding. And the local
> > variable of size is already the value of slab_unreclaimable. So we
> > do not need to read again.
> >
> > We can drop the ratio in struct memory_stat. This can make the code
> > clean and simple. And get rid of the awkward mix of static and runtime
> > initialization of the memory_stats table.
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 112 ++++++++++++++++++++++++++++++++++++--------------------
> >  1 file changed, 73 insertions(+), 39 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a40797a27f87..841ea37cc123 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1511,49 +1511,78 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
> >
> >  struct memory_stat {
> >         const char *name;
> > -       unsigned int ratio;
> >         unsigned int idx;
> >  };
> >
> >  static const struct memory_stat memory_stats[] = {
> > -       { "anon", PAGE_SIZE, NR_ANON_MAPPED },
> > -       { "file", PAGE_SIZE, NR_FILE_PAGES },
> > -       { "kernel_stack", 1024, NR_KERNEL_STACK_KB },
> > -       { "pagetables", PAGE_SIZE, NR_PAGETABLE },
> > -       { "percpu", 1, MEMCG_PERCPU_B },
> > -       { "sock", PAGE_SIZE, MEMCG_SOCK },
> > -       { "shmem", PAGE_SIZE, NR_SHMEM },
> > -       { "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
> > -       { "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
> > -       { "file_writeback", PAGE_SIZE, NR_WRITEBACK },
> > +       { "anon",                       NR_ANON_MAPPED                  },
> > +       { "file",                       NR_FILE_PAGES                   },
> > +       { "kernel_stack",               NR_KERNEL_STACK_KB              },
> > +       { "pagetables",                 NR_PAGETABLE                    },
> > +       { "percpu",                     MEMCG_PERCPU_B                  },
> > +       { "sock",                       MEMCG_SOCK                      },
> > +       { "shmem",                      NR_SHMEM                        },
> > +       { "file_mapped",                NR_FILE_MAPPED                  },
> > +       { "file_dirty",                 NR_FILE_DIRTY                   },
> > +       { "file_writeback",             NR_WRITEBACK                    },
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -       { "anon_thp", PAGE_SIZE, NR_ANON_THPS },
> > -       { "file_thp", PAGE_SIZE, NR_FILE_THPS },
> > -       { "shmem_thp", PAGE_SIZE, NR_SHMEM_THPS },
> > +       { "anon_thp",                   NR_ANON_THPS                    },
> > +       { "file_thp",                   NR_FILE_THPS                    },
> > +       { "shmem_thp",                  NR_SHMEM_THPS                   },
> >  #endif
> > -       { "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
> > -       { "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
> > -       { "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
> > -       { "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
> > -       { "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
> > -
> > -       /*
> > -        * Note: The slab_reclaimable and slab_unreclaimable must be
> > -        * together and slab_reclaimable must be in front.
> > -        */
> > -       { "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
> > -       { "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
> > +       { "inactive_anon",              NR_INACTIVE_ANON                },
> > +       { "active_anon",                NR_ACTIVE_ANON                  },
> > +       { "inactive_file",              NR_INACTIVE_FILE                },
> > +       { "active_file",                NR_ACTIVE_FILE                  },
> > +       { "unevictable",                NR_UNEVICTABLE                  },
> > +       { "slab_reclaimable",           NR_SLAB_RECLAIMABLE_B           },
> > +       { "slab_unreclaimable",         NR_SLAB_UNRECLAIMABLE_B         },
> >
> >         /* The memory events */
> > -       { "workingset_refault_anon", 1, WORKINGSET_REFAULT_ANON },
> > -       { "workingset_refault_file", 1, WORKINGSET_REFAULT_FILE },
> > -       { "workingset_activate_anon", 1, WORKINGSET_ACTIVATE_ANON },
> > -       { "workingset_activate_file", 1, WORKINGSET_ACTIVATE_FILE },
> > -       { "workingset_restore_anon", 1, WORKINGSET_RESTORE_ANON },
> > -       { "workingset_restore_file", 1, WORKINGSET_RESTORE_FILE },
> > -       { "workingset_nodereclaim", 1, WORKINGSET_NODERECLAIM },
> > +       { "workingset_refault_anon",    WORKINGSET_REFAULT_ANON         },
> > +       { "workingset_refault_file",    WORKINGSET_REFAULT_FILE         },
> > +       { "workingset_activate_anon",   WORKINGSET_ACTIVATE_ANON        },
> > +       { "workingset_activate_file",   WORKINGSET_ACTIVATE_FILE        },
> > +       { "workingset_restore_anon",    WORKINGSET_RESTORE_ANON         },
> > +       { "workingset_restore_file",    WORKINGSET_RESTORE_FILE         },
> > +       { "workingset_nodereclaim",     WORKINGSET_NODERECLAIM          },
> >  };
> >
> > +/* Translate stat items to the correct unit for memory.stat output */
> > +static int memcg_page_state_unit(int item)
> > +{
> > +       int unit;
> > +
> > +       switch (item) {
> > +       case MEMCG_PERCPU_B:
> > +       case NR_SLAB_RECLAIMABLE_B:
> > +       case NR_SLAB_UNRECLAIMABLE_B:
> > +       case WORKINGSET_REFAULT_ANON:
> > +       case WORKINGSET_REFAULT_FILE:
> > +       case WORKINGSET_ACTIVATE_ANON:
> > +       case WORKINGSET_ACTIVATE_FILE:
> > +       case WORKINGSET_RESTORE_ANON:
> > +       case WORKINGSET_RESTORE_FILE:
> > +       case WORKINGSET_NODERECLAIM:
> > +               unit = 1;
> > +               break;
> > +       case NR_KERNEL_STACK_KB:
> > +               unit = SZ_1K;
> > +               break;
> > +       default:
> > +               unit = PAGE_SIZE;
> > +               break;
>  break not needed here, or maybe we can return for every case,
> that will avoid "unit" variable.

Yeah, thanks.

>
> > +       }
> > +
> > +       return unit;
> > +}
> > +
> > +static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg,
> > +                                                   int item)
> > +{
> > +       return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
> > +}
> > +
> >  static char *memory_stat_format(struct mem_cgroup *memcg)
> >  {
> >         struct seq_buf s;
> > @@ -1577,13 +1606,12 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
> >         for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
> >                 u64 size;
> >
> > -               size = memcg_page_state(memcg, memory_stats[i].idx);
> > -               size *= memory_stats[i].ratio;
> > +               size = memcg_page_state_output(memcg, memory_stats[i].idx);
> >                 seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
> >
> >                 if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
> > -                       size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
> > -                              memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
> > +                       size +=
> (memcg,
> > +                                                       NR_SLAB_RECLAIMABLE_B);
> >                         seq_buf_printf(&s, "slab %llu\n", size);
> >                 }
> >         }
> > @@ -6377,6 +6405,12 @@ static int memory_stat_show(struct seq_file *m, void *v)
> >  }
> >
> >  #ifdef CONFIG_NUMA
> > +static inline unsigned long lruvec_page_state_output(struct lruvec *lruvec,
> > +                                                    int item)
> > +{
> > +       return lruvec_page_state(lruvec, item) * memcg_page_state_unit(item);
> > +}
> > +
> >  static int memory_numa_stat_show(struct seq_file *m, void *v)
> >  {
> >         int i;
> > @@ -6394,8 +6428,8 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
> >                         struct lruvec *lruvec;
> >
> >                         lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> > -                       size = lruvec_page_state(lruvec, memory_stats[i].idx);
> > -                       size *= memory_stats[i].ratio;
> > +                       size = lruvec_page_state_output(lruvec,
> > +                                                       memory_stats[i].idx);
> >                         seq_printf(m, " N%d=%llu", nid, size);
> >                 }
> >                 seq_putc(m, '\n');
> > --
> > 2.11.0
> >
> >



-- 
Yours,
Muchun
