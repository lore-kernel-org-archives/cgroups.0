From: Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Sun, 21 Aug 2022 20:24:36 -0400
Message-ID: <CACSApvYOfFtn9TvRk2W5Xxv4Z90MZHqbffuB6XQXXxiG+F6WrA@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-4-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vOM6Qk7H6503nwlxurWDnApj6tGcPYJKuggwnA4Q7DI=;
        b=d18GG+Bt516p+zMinyCQn18btHPsTUkM8kPzrVj0qRlWdy2iXgPx5SdfNKsgRcQ5+t
         OtpT4LYrHOqGSPN6EtuMYhEn51cgY1lIg1cVM4bqJBczwtMS70sLDPg356P2VE3PM9Dh
         mgRZekRTLn1Ac3RMfhbmkkN+PXDbsIU/PgXaHy/nHlK1uWtZJVQNzXTxZ/9TdY4yv7E7
         6YRljr0tzGJfVO75aEh2zLCwUUaQb+K9LDB+6+a6DUjZevqZX+VoHbDggFmctnlqzlJc
         uJuGiXe1qObFP1Y+nN/gYcpwbAf8zmYaSbZfrL1rUOPvdz8Vng8leg9pLCE7NFHmnv79
         eBNQ==
In-Reply-To: <20220822001737.4120417-4-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Aug 21, 2022 at 8:18 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
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
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Nice!

Acked-by: Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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
