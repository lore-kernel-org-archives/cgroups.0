From: Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter fields
Date: Sun, 21 Aug 2022 20:24:04 -0400
Message-ID: <CACSApvYU5gfbDv9dyaypu1oOPB58eT1inX9EX6gV5b2q3+qr6Q@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-3-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Eqv/19N5yEMgS5A7uMKIDvv+xbcnmfhfYxaJZgO8F20=;
        b=UicQpWpEmeF4kKoeqp/WmxAnf9tSyJSlCCvCKpoqea2kLCQ69aIPlMRNh8C+3XkGXM
         CKOhqFgao3DWFDsjsLNq8xeVqbewCc8NY9lCkqgwSywO8chlQH1+JVfwzfmlOpCeeddL
         ir8WDMIFe6sx2wEA55JyybCPBhEpqg/vfyoiWOWv7MhagbOKbO8lPdDqTDWvJscIAu6T
         g85dXRDbtNY6hSb/sZbRSHwGldG8kMBGLoi9Lcxh9F9wHALlSTO1M6IEA7bhddGDltAY
         uaPJXmxeBr/+rY0peyXTPwikF6BcvdKBZy1ivGuvz7hXUurZcqE3n6U9eAeqRYOQ8HXj
         ahsQ==
In-Reply-To: <20220822001737.4120417-3-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Aug 21, 2022 at 8:18 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> With memcg v2 enabled, memcg->memory.usage is a very hot member for
> the workloads doing memcg charging on multiple CPUs concurrently.
> Particularly the network intensive workloads. In addition, there is a
> false cache sharing between memory.usage and memory.high on the charge
> path. This patch moves the usage into a separate cacheline and move all
> the read most fields into separate cacheline.
>
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy with top
> level having min and low setup appropriately. More specifically
> memory.min equal to size of netperf binary and memory.low double of
> that.
>
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
>
> Results (average throughput of netperf):
> Without (6.0-rc1)       10482.7 Mbps
> With patch              12413.7 Mbps (18.4% improvement)
>
> With the patch, the throughput improved by 18.4%.

Shakeel, for my understanding: is this on top of the gains from the
previous patch?

> One side-effect of this patch is the increase in the size of struct
> mem_cgroup. However for the performance improvement, this additional
> size is worth it. In addition there are opportunities to reduce the size
> of struct mem_cgroup like deprecation of kmem and tcpmem page counters
> and better packing.
>
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/page_counter.h | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 679591301994..8ce99bde645f 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -3,15 +3,27 @@
>  #define _LINUX_PAGE_COUNTER_H
>
>  #include <linux/atomic.h>
> +#include <linux/cache.h>
>  #include <linux/kernel.h>
>  #include <asm/page.h>
>
> +#if defined(CONFIG_SMP)
> +struct pc_padding {
> +       char x[0];
> +} ____cacheline_internodealigned_in_smp;
> +#define PC_PADDING(name)       struct pc_padding name
> +#else
> +#define PC_PADDING(name)
> +#endif
> +
>  struct page_counter {
> +       /*
> +        * Make sure 'usage' does not share cacheline with any other field. The
> +        * memcg->memory.usage is a hot member of struct mem_cgroup.
> +        */
> +       PC_PADDING(_pad1_);
>         atomic_long_t usage;
> -       unsigned long min;
> -       unsigned long low;
> -       unsigned long high;
> -       unsigned long max;
> +       PC_PADDING(_pad2_);
>
>         /* effective memory.min and memory.min usage tracking */
>         unsigned long emin;
> @@ -23,16 +35,16 @@ struct page_counter {
>         atomic_long_t low_usage;
>         atomic_long_t children_low_usage;
>
> -       /* legacy */
>         unsigned long watermark;
>         unsigned long failcnt;
>
> -       /*
> -        * 'parent' is placed here to be far from 'usage' to reduce
> -        * cache false sharing, as 'usage' is written mostly while
> -        * parent is frequently read for cgroup's hierarchical
> -        * counting nature.
> -        */
> +       /* Keep all the read most fields in a separete cacheline. */
> +       PC_PADDING(_pad3_);
> +
> +       unsigned long min;
> +       unsigned long low;
> +       unsigned long high;
> +       unsigned long max;
>         struct page_counter *parent;
>  };
>
> --
> 2.37.1.595.g718a3a8f04-goog
>
