From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 2/3] mm: page_counter: rearrange struct page_counter
 fields
Date: Thu, 25 Aug 2022 08:47:24 +0200
Message-ID: <Ywca/EqpyQDAWlE2@dhcp22.suse.cz>
References: <20220825000506.239406-1-shakeelb@google.com>
 <20220825000506.239406-3-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661410045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zLRWmwcimgQLwECe4VlFsT+nEfyDLI69yDOnnoQ7NCo=;
        b=qL0xHbIA8DNVfkr/xEEsAFL6UM7wiK2Au3n1koR1lst2jLTaeQ5OPjq50FEyTFusso1VDB
        FirljZWBsdFYK23F4Hf/RYnI/zzzCntvRuUj0pxGiuZZ6GQxQ2f6MddIcLyqKENJRZesOl
        vsYJr4Vzc3Z5rMGNQ8svI56dp/Y4Aeg=
Content-Disposition: inline
In-Reply-To: <20220825000506.239406-3-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 25-08-22 00:05:05, Shakeel Butt wrote:
> With memcg v2 enabled, memcg->memory.usage is a very hot member for
> the workloads doing memcg charging on multiple CPUs concurrently.
> Particularly the network intensive workloads. In addition, there is a
> false cache sharing between memory.usage and memory.high on the charge
> path. This patch moves the usage into a separate cacheline and move all
> the read most fields into separate cacheline.
> 
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy.
> 
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> 
> Results (average throughput of netperf):
> Without (6.0-rc1)	10482.7 Mbps
> With patch		12413.7 Mbps (18.4% improvement)
> 
> With the patch, the throughput improved by 18.4%.
> 
> One side-effect of this patch is the increase in the size of struct
> mem_cgroup. For example with this patch on 64 bit build, the size of
> struct mem_cgroup increased from 4032 bytes to 4416 bytes. However for
> the performance improvement, this additional size is worth it. In
> addition there are opportunities to reduce the size of struct
> mem_cgroup like deprecation of kmem and tcpmem page counters and
> better packing.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Reviewed-by: Feng Tang <feng.tang@intel.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>

One nit below

> ---
> Changes since v1:
> - Updated the commit message
> - Make struct page_counter cache align.
> 
>  include/linux/page_counter.h | 35 +++++++++++++++++++++++------------
>  1 file changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 679591301994..78a1c934e416 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -3,15 +3,26 @@
>  #define _LINUX_PAGE_COUNTER_H
>  
>  #include <linux/atomic.h>
> +#include <linux/cache.h>
>  #include <linux/kernel.h>
>  #include <asm/page.h>
>  
> +#if defined(CONFIG_SMP)
> +struct pc_padding {
> +	char x[0];
> +} ____cacheline_internodealigned_in_smp;
> +#define PC_PADDING(name)	struct pc_padding name
> +#else
> +#define PC_PADDING(name)
> +#endif
> +
>  struct page_counter {
> +	/*
> +	 * Make sure 'usage' does not share cacheline with any other field. The
> +	 * memcg->memory.usage is a hot member of struct mem_cgroup.
> +	 */
>  	atomic_long_t usage;
> -	unsigned long min;
> -	unsigned long low;
> -	unsigned long high;
> -	unsigned long max;
> +	PC_PADDING(_pad1_);
>  
>  	/* effective memory.min and memory.min usage tracking */
>  	unsigned long emin;
> @@ -23,18 +34,18 @@ struct page_counter {
>  	atomic_long_t low_usage;
>  	atomic_long_t children_low_usage;
>  
> -	/* legacy */
>  	unsigned long watermark;
>  	unsigned long failcnt;

These two are also touched in the charging path so we could squeeze them
into the same cache line as usage.

0-day machinery was quite good at hitting noticeable regression anytime
we have changed layout so let's see what they come up with after this
patch ;)
-- 
Michal Hocko
SUSE Labs
