From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter
 fields
Date: Mon, 22 Aug 2022 10:10:58 +0800
Message-ID: <YwLlsr0jNq5m6v8z@feng-clx>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-3-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661134315; x=1692670315;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=78YdFVWcZoZhkv1NVUGW31kEaECXwO+E+G/qPSQW6CE=;
  b=W/ogPRAHKvkWGHaeJwu1BdfXzzN6zIwdZhVnUKZIcnbt/bGoxbkoQmMK
   njXbpjpNyLm5kft8G+fzU7QYgiOD06CrU39FXr83dPHaOg3TnwZnP3AzG
   XTqXCmNcxLSFv8cbO36Z8hXreQP+rnwowWLu1wZsORHc0VBUNIwpFeeLd
   VysuSoR1jePUJwzBIFtQHxGKOmlerbJad+kquCRkInfJJC8HtEuW1Qzih
   rgqhCYgPzpvl4iirFbX7WCKqunPYADA+Xruj+Gt5GL2zGhKoUXRVdqCX4
   O7XhunBnPb1gOnXnuoiNzgggJfDi1NqHlU3iJJ/3Dl/vyN6j7ZtBjdiE+
   g==;
Content-Disposition: inline
In-Reply-To: <20220822001737.4120417-3-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Koutn?? <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Sang, Oliver" <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Aug 22, 2022 at 08:17:36AM +0800, Shakeel Butt wrote:
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
> Without (6.0-rc1)	10482.7 Mbps
> With patch		12413.7 Mbps (18.4% improvement)
> 
> With the patch, the throughput improved by 18.4%.
> 
> One side-effect of this patch is the increase in the size of struct
> mem_cgroup. However for the performance improvement, this additional
> size is worth it. In addition there are opportunities to reduce the size
> of struct mem_cgroup like deprecation of kmem and tcpmem page counters
> and better packing.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good to me, with one nit below. 

Reviewed-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

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
> +	char x[0];
> +} ____cacheline_internodealigned_in_smp;
> +#define PC_PADDING(name)	struct pc_padding name
> +#else
> +#define PC_PADDING(name)
> +#endif

There are 2 similar padding definitions in mmzone.h and memcontrol.h:

	struct memcg_padding {
		char x[0];
	} ____cacheline_internodealigned_in_smp;
	#define MEMCG_PADDING(name)      struct memcg_padding name

	struct zone_padding {
		char x[0];
	} ____cacheline_internodealigned_in_smp;
	#define ZONE_PADDING(name)	struct zone_padding name;

Maybe we can generalize them, and lift it into include/cache.h? so
that more places can reuse it in future.

Thanks,
Feng

