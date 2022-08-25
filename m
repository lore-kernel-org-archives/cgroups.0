From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: page_counter: rearrange struct page_counter fields
Date: Thu, 25 Aug 2022 08:25:38 -0700
Message-ID: <CALvZod6mqtZ+iELhg2Q+SbdcicGSbY4piymzFCOPsy5UxvtbRg@mail.gmail.com>
References: <20220825000506.239406-1-shakeelb@google.com> <20220825000506.239406-3-shakeelb@google.com>
 <Ywca/EqpyQDAWlE2@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Zsqv9AykgJ+WV9feY4vZLdyL0HO37C5wC/zUOZBB/Rs=;
        b=HWnl7UrUYlzNgRl6uEFPplyGVawiIDXFH7m8PBsKuwLAyY4wVOH5/4W+KHE3cm4dmy
         4VKpGXbIOjUVTNJ5qTAEfFLY5j3Yf3cnEjwgexlgBZzwA/NZqy+OA837il6nxkXV5MZ8
         bWeOe7RYnCeBZeCaEDApmwAvBPMIcLaY9ZVBN4TcWiNWpqvDtnBHm4rNi4l+iIhXSBbt
         Vb5TpW9i3LVxD0fenWNvYo2kmlhk6MMD/fpNzQjOSsWwzJLxUQdlnEY1aV6QOjHMKsIC
         o6Aj0pItiOXOcalFXaXlzd4qp/y4sLZ4X8K4ywWFjTAOSTa/Uzz4A9Ct6uhXYJn4n24B
         gkOA==
In-Reply-To: <Ywca/EqpyQDAWlE2-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Aug 24, 2022 at 11:47 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 25-08-22 00:05:05, Shakeel Butt wrote:
> > With memcg v2 enabled, memcg->memory.usage is a very hot member for
> > the workloads doing memcg charging on multiple CPUs concurrently.
> > Particularly the network intensive workloads. In addition, there is a
> > false cache sharing between memory.usage and memory.high on the charge
> > path. This patch moves the usage into a separate cacheline and move all
> > the read most fields into separate cacheline.
> >
> > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > ran the following workload in a three level of cgroup hierarchy.
> >
> >  $ netserver -6
> >  # 36 instances of netperf with following params
> >  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> >
> > Results (average throughput of netperf):
> > Without (6.0-rc1)     10482.7 Mbps
> > With patch            12413.7 Mbps (18.4% improvement)
> >
> > With the patch, the throughput improved by 18.4%.
> >
> > One side-effect of this patch is the increase in the size of struct
> > mem_cgroup. For example with this patch on 64 bit build, the size of
> > struct mem_cgroup increased from 4032 bytes to 4416 bytes. However for
> > the performance improvement, this additional size is worth it. In
> > addition there are opportunities to reduce the size of struct
> > mem_cgroup like deprecation of kmem and tcpmem page counters and
> > better packing.
> >
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Reviewed-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Acked-by: Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>

Thanks.

> One nit below
>
> > ---
> > Changes since v1:
> > - Updated the commit message
> > - Make struct page_counter cache align.
> >
> >  include/linux/page_counter.h | 35 +++++++++++++++++++++++------------
> >  1 file changed, 23 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> > index 679591301994..78a1c934e416 100644
> > --- a/include/linux/page_counter.h
> > +++ b/include/linux/page_counter.h
> > @@ -3,15 +3,26 @@
> >  #define _LINUX_PAGE_COUNTER_H
> >
> >  #include <linux/atomic.h>
> > +#include <linux/cache.h>
> >  #include <linux/kernel.h>
> >  #include <asm/page.h>
> >
> > +#if defined(CONFIG_SMP)
> > +struct pc_padding {
> > +     char x[0];
> > +} ____cacheline_internodealigned_in_smp;
> > +#define PC_PADDING(name)     struct pc_padding name
> > +#else
> > +#define PC_PADDING(name)
> > +#endif
> > +
> >  struct page_counter {
> > +     /*
> > +      * Make sure 'usage' does not share cacheline with any other field. The
> > +      * memcg->memory.usage is a hot member of struct mem_cgroup.
> > +      */
> >       atomic_long_t usage;
> > -     unsigned long min;
> > -     unsigned long low;
> > -     unsigned long high;
> > -     unsigned long max;
> > +     PC_PADDING(_pad1_);
> >
> >       /* effective memory.min and memory.min usage tracking */
> >       unsigned long emin;
> > @@ -23,18 +34,18 @@ struct page_counter {
> >       atomic_long_t low_usage;
> >       atomic_long_t children_low_usage;
> >
> > -     /* legacy */
> >       unsigned long watermark;
> >       unsigned long failcnt;
>
> These two are also touched in the charging path so we could squeeze them
> into the same cache line as usage.
>
> 0-day machinery was quite good at hitting noticeable regression anytime
> we have changed layout so let's see what they come up with after this
> patch ;)

I will try this locally first (after some cleanups) to see if there is
any positive or negative impact and report here.

> --
> Michal Hocko
> SUSE Labs
