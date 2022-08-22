From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Mon, 22 Aug 2022 11:37:30 -0700
Message-ID: <YwPM6o1+pZ2kRyy3@P9FQF9L96D>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-4-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661193456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3icLRlffoR+2bh6AZBpCk9+vi7OPaMiHjmut8kzqVHM=;
        b=HbWlYxX1EJmz75AZbYDPBp74453btzjOhTRWKtlJOGuc1jQO24pHe/hVo32YJuG3ao8+iO
        ZKgUv+hqXTU6VWEGEungqgWleeZt4YEED0xXWrB3WsujuUR2ZsuOFwGTRy18nWJVgzW3fD
        YRJ16tZfmzfWWnGq3Ow3YE7Ru4ZjXyg=
Content-Disposition: inline
In-Reply-To: <20220822001737.4120417-4-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 22, 2022 at 12:17:37AM +0000, Shakeel Butt wrote:
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

This is pretty significant!

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

I wonder only if we want to make it configurable (Idk a sysctl or maybe
a config option) and close the topic.

Thanks!
