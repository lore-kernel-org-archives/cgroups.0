From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Thu, 25 Aug 2022 08:49:05 +0200
Message-ID: <YwcbYQHRuThE18QN@dhcp22.suse.cz>
References: <20220825000506.239406-1-shakeelb@google.com>
 <20220825000506.239406-4-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661410146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hCOkZ1R+3Ps2iKEQMkAGWbxoqzFDDsd5JC+8lsArgGY=;
        b=t+iNVMXgawnOo26nJ0TYL5x/n2/mTXp5VPRShA6ztSQWzxIh3W0eaKXh+Lm7NRjG+9vVAG
        My0w3z2TjVgNuaHWVhhBjJkd874Xto/GeUkKCuohcF8xCIMjWj2eHVInmxCW/uYnIZ69gP
        7pfKhI3yz9xq8yt/uPBJ9lMRs7vD50Y=
Content-Disposition: inline
In-Reply-To: <20220825000506.239406-4-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 25-08-22 00:05:06, Shakeel Butt wrote:
> For several years, MEMCG_CHARGE_BATCH was kept at 32 but with bigger
> machines and the network intensive workloads requiring througput in
> Gbps, 32 is too small and makes the memcg charging path a bottleneck.
> For now, increase it to 64 for easy acceptance to 6.0. We will need to
> revisit this in future for ever increasing demand of higher performance.
> 
> Please note that the memcg charge path drain the per-cpu memcg charge
> stock, so there should not be any oom behavior change. Though it does
> have impact on rstat flushing and high limit reclaim backoff.
> 
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy.
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
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Reviewed-by: Feng Tang <feng.tang@intel.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> Changes since v1:
> - Updated commit message
> 
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

-- 
Michal Hocko
SUSE Labs
