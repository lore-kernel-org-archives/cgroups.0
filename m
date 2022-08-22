From: Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Mon, 22 Aug 2022 10:30:51 +0800
Message-ID: <YwLqW8Bc2CWCJsAE@feng-clx>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-4-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661135510; x=1692671510;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7mqlmf4nE6XZxy6FrrXnNdanXlIfzXZjbW+EADVO9o8=;
  b=gaB6+8bt9bWmE1eJCy6b0DfWIHG3DwIdFEBQGhiNp8sTo+9aD+P8coo4
   SJVwhGb/B4bHz/cSwIfiNcJskmOXTAuUQoKmrDbem6kT0KZptaaYSBtYz
   A646qdcuEjfwYjLGI8xtCfSIajeFhzrmN3O6qG6uCC9tW8TK8hLQmuWmr
   fQXVe4dbxgruKuNjw/7PkGhxUQLHKFz6X/T7Ui2HLLN0BSQcIM5fgkTE1
   r74iuchytCcYEvi1gxkWpJs/98SxmJz3eR+norFDnSnGvp7qBOOXIAcz1
   gQpk0FFpiezzGeZuYIfkHXl2cBqOxSUpvg3+/PgblZja1Vrd64CDYoUaA
   A==;
Content-Disposition: inline
In-Reply-To: <20220822001737.4120417-4-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Michal Koutn?? <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, "Sang, Oliver" <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "lkp@lists.01.org" <lkp@lists.01.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Aug 22, 2022 at 08:17:37AM +0800, Shakeel Butt wrote:
> For several years, MEMCG_CHARGE_BATCH was kept at 32 but with bigger
> machines and the network intensive workloads requiring througput in
> Gbps, 32 is too small and makes the memcg charging path a bottleneck.
> For now, increase it to 64 for easy acceptance to 6.0. We will need to
> revisit this in future for ever increasing demand of higher performance.
> 
> Please note that the memcg charge path drain the per-cpu memcg charge
> stock, so there should not be any oom behavior change.
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
> With patch              17064.7 Mbps (62.7% improvement)
> 
> With the patch, the throughput improved by 62.7%.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>

This batch number has long been a pain point :) thanks for the work!

Reviewed-by: Feng Tang <feng.tang@intel.com>

- Feng

> ---
>  include/linux/memcontrol.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 4d31ce55b1c0..70ae91188e16 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -354,10 +354,11 @@ struct mem_cgroup {
>  };
>  
>  /*
> - * size of first charge trial. "32" comes from vmscan.c's magic value.
> - * TODO: maybe necessary to use big numbers in big irons.
> + * size of first charge trial.
> + * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
> + * workload.
>   */
> -#define MEMCG_CHARGE_BATCH 32U
> +#define MEMCG_CHARGE_BATCH 64U
>  
>  extern struct mem_cgroup *root_mem_cgroup;
>  
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
