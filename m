From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter fields
Date: Sun, 21 Aug 2022 21:59:20 -0700
Message-ID: <CALvZod6d_0ERWy3bsCaLwoNhn7H6YnGeJfs_S5H+Fy2xb3eM9w@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-3-shakeelb@google.com>
 <YwLlsr0jNq5m6v8z@feng-clx>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9XhZmihVWYtN8pqGhGwupTf+AWRqtf1YyaQ/pGiog9k=;
        b=e4g+T2mMYZZcLZKVuyYTBE7KioYD6BNBNG1cLqDFZ5B9t0E6FIRD5EvbyAzLTCr3kJ
         rA6ZK7oCz9GEATt82qpw+2JFjAHNx6MWzrOEJkCcglpPUJI6hS1usRrjSP0PtvLaklzt
         2SWFQW3etXo3F8BRQXjkvsEAD1xWTy3389fS+y8cwwh/ZpGZYzfVQV4mAVDrVneI1RKY
         LqoHhaNoGRAKG4D6abLWZ4z6qaxhraGCM7tcAmHqKNXwMFf8R6WZS65/KM+mSpunicvW
         NoZagRqgMyd0mx1A/gtNa8G0tjAlwmRM7GukYQSHxRJh5NrCaUN7Ht0Ligb/wX1I4ajV
         MSHA==
In-Reply-To: <YwLlsr0jNq5m6v8z@feng-clx>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Koutn?? <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Sang, Oliver" <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Aug 21, 2022 at 7:12 PM Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> On Mon, Aug 22, 2022 at 08:17:36AM +0800, Shakeel Butt wrote:
> > With memcg v2 enabled, memcg->memory.usage is a very hot member for
> > the workloads doing memcg charging on multiple CPUs concurrently.
> > Particularly the network intensive workloads. In addition, there is a
> > false cache sharing between memory.usage and memory.high on the charge
> > path. This patch moves the usage into a separate cacheline and move all
> > the read most fields into separate cacheline.
> >
> > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > ran the following workload in a three level of cgroup hierarchy with top
> > level having min and low setup appropriately. More specifically
> > memory.min equal to size of netperf binary and memory.low double of
> > that.
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
> > mem_cgroup. However for the performance improvement, this additional
> > size is worth it. In addition there are opportunities to reduce the size
> > of struct mem_cgroup like deprecation of kmem and tcpmem page counters
> > and better packing.
> >
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Looks good to me, with one nit below.
>
> Reviewed-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks.

>
> > ---
> >  include/linux/page_counter.h | 34 +++++++++++++++++++++++-----------
> >  1 file changed, 23 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> > index 679591301994..8ce99bde645f 100644
> > --- a/include/linux/page_counter.h
> > +++ b/include/linux/page_counter.h
> > @@ -3,15 +3,27 @@
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
>
> There are 2 similar padding definitions in mmzone.h and memcontrol.h:
>
>         struct memcg_padding {
>                 char x[0];
>         } ____cacheline_internodealigned_in_smp;
>         #define MEMCG_PADDING(name)      struct memcg_padding name
>
>         struct zone_padding {
>                 char x[0];
>         } ____cacheline_internodealigned_in_smp;
>         #define ZONE_PADDING(name)      struct zone_padding name;
>
> Maybe we can generalize them, and lift it into include/cache.h? so
> that more places can reuse it in future.
>

This makes sense but let me do that in a separate patch.
