From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
Date: Sun, 6 Mar 2022 18:44:04 -0800
Message-ID: <20220306184404.049447f8447d288fde34cabe@linux-foundation.org>
References: <20220304184040.1304781-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646621045;
        bh=fXrrtpJvgRp7AsWlaFX0EIrBU3vOypZe0/w7Wy6tFaw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yl3BC2AszB49zMZHwLObBmVoM7K4Jl5NAwLN0LcontcU6+PloRGpwxKbmoFAmASQj
         nil01KZFN6gYYCX2zEhBcI6kMloe1CybbviLAQBKoOkg5XN9rEbtCJknWmiocyWi5A
         D0VbwX/8Vvx4sLUsNXs5QUX9ruW6Do6QDnUJL25c=
In-Reply-To: <20220304184040.1304781-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: =?ISO-8859-1?Q? Michal_Koutn=FD ?= <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Frank Hofmann <fhofmann@cloudflare.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, stable@vger.kernel.org

On Fri,  4 Mar 2022 18:40:40 +0000 Shakeel Butt <shakeelb@google.com> wrote:

> Daniel Dao has reported [1] a regression on workloads that may trigger
> a lot of refaults (anon and file). The underlying issue is that flushing
> rstat is expensive. Although rstat flush are batched with (nr_cpus *
> MEMCG_BATCH) stat updates, it seems like there are workloads which
> genuinely do stat updates larger than batch value within short amount of
> time. Since the rstat flush can happen in the performance critical
> codepaths like page faults, such workload can suffer greatly.
> 
> This patch fixes this regression by making the rstat flushing
> conditional in the performance critical codepaths. More specifically,
> the kernel relies on the async periodic rstat flusher to flush the stats
> and only if the periodic flusher is delayed by more than twice the
> amount of its normal time window then the kernel allows rstat flushing
> from the performance critical codepaths.
> 
> Now the question: what are the side-effects of this change? The worst
> that can happen is the refault codepath will see 4sec old lruvec stats
> and may cause false (or missed) activations of the refaulted page which
> may under-or-overestimate the workingset size. Though that is not very
> concerning as the kernel can already miss or do false activations.
> 
> There are two more codepaths whose flushing behavior is not changed by
> this patch and we may need to come to them in future. One is the
> writeback stats used by dirty throttling and second is the deactivation
> heuristic in the reclaim. For now keeping an eye on them and if there is
> report of regression due to these codepaths, we will reevaluate then.
> 
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
>
> ...
>
> @@ -648,10 +652,16 @@ void mem_cgroup_flush_stats(void)
>  		__mem_cgroup_flush_stats();
>  }
>  
> +void mem_cgroup_flush_stats_delayed(void)
> +{
> +	if (rstat_flush_time && time_after64(jiffies_64, flush_next_time))

rstat_flush_time isn't defined for me and my googling indicates this is
the first time the symbol has been used in the history of the world. 
I'm stumped.

> +		mem_cgroup_flush_stats();
> +}
> +
>
> ...
>
