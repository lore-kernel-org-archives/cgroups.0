From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: make the slab calculation consistent
Date: Thu, 3 Dec 2020 10:53:33 +0800
Message-ID: <CAMZfGtWUWAO8J6iBpQLV0T8xPAuQvFTfX9UQ7G2eM_O9C7w83w@mail.gmail.com>
References: <20201202121434.75099-1-songmuchun@bytedance.com> <20201202211646.GA1517142@carbon.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GDcWWcWtZ2CIT3OcyxlFsQ8cIBNK++QYLLtJ9vIR6kA=;
        b=sDSPa8a747MqIOZ3kxtOh3eGCz6jS+hENFwV7LofZs09YNQAcrvfmOunXFm1AN3MNz
         8qIpEx3Esxeo1AKK3mb9soO9OCpbXBSWyeHgFnOhkYY0yvKmUFXLGjTTByFJ+sewzvsd
         DNIjXqfF7QMMLXx0Q+ISBY6DsryjqzemNv1LEIxt7a1/rMC9LqD0539AzqRZKyX2jjQA
         tB0+wgPGI/SuFEESCOsYdE6zo++XPwYovqBs2tq/nSnzwVIcXTidTqB33Jhunv9+Wubh
         HVHhV8zsjUOOT4c9C/SaEZUBpmV4DM3n7Oye0Xtri3kHVVcu/5ac4U7J2P38HI9ITuPU
         LEVA==
In-Reply-To: <20201202211646.GA1517142-esYZh5BkUNV+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Dec 3, 2020 at 5:16 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Wed, Dec 02, 2020 at 08:14:34PM +0800, Muchun Song wrote:
> > Although the ratio of the slab is one, we also should read the ratio
> > from the related memory_stats instead of hard-coding. And the local
> > variable of size is already the value of slab_unreclaimable. So we
> > do not need to read again. Simplify the code here.
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 22 +++++++++++++++++-----
> >  1 file changed, 17 insertions(+), 5 deletions(-)
>
> Hi Muchun!
>
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 9922f1510956..03a9c64560f6 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1545,12 +1545,22 @@ static int __init memory_stats_init(void)
> >       int i;
> >
> >       for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
> > +             switch (memory_stats[i].idx) {
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -             if (memory_stats[i].idx == NR_ANON_THPS ||
> > -                 memory_stats[i].idx == NR_FILE_THPS ||
> > -                 memory_stats[i].idx == NR_SHMEM_THPS)
> > +             case NR_ANON_THPS:
> > +             case NR_FILE_THPS:
> > +             case NR_SHMEM_THPS:
> >                       memory_stats[i].ratio = HPAGE_PMD_SIZE;
> > +                     break;
> >  #endif
> > +             case NR_SLAB_UNRECLAIMABLE_B:
> > +                     VM_BUG_ON(i < 1);
> > +                     VM_BUG_ON(memory_stats[i - 1].idx != NR_SLAB_RECLAIMABLE_B);
>
> Please, convert these to BUILD_BUG_ON(), they don't have to be runtime checks.

Agree. But here we cannot use BUILD_BUG_ON(). The compiler will
complain about it.

>
>
> > +                     break;
> > +             default:
> > +                     break;
> > +             }
> > +
> >               VM_BUG_ON(!memory_stats[i].ratio);
> >               VM_BUG_ON(memory_stats[i].idx >= MEMCG_NR_STAT);
> >       }
> > @@ -1587,8 +1597,10 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
> >               seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
> >
>
> Can you, please, add a small comment here stating that we're printing
> unreclaimable, reclaimable and the sum of both? It will simplify the reading of the code.

Will do.

>
> >               if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
> > -                     size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
> > -                            memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
> > +                     int idx = i - 1;
> > +
> > +                     size += memcg_page_state(memcg, memory_stats[idx].idx) *
> > +                             memory_stats[idx].ratio;
> >                       seq_buf_printf(&s, "slab %llu\n", size);
> >               }
> >       }
>
> Otherwise the patch looks good to me! Please, feel free to add
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> after addressing my comments.
>
> Thanks!
> > --
> > 2.11.0
> >



-- 
Yours,
Muchun
