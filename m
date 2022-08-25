From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: page_counter: rearrange struct page_counter
 fields
Date: Wed, 24 Aug 2022 17:33:30 -0700
Message-ID: <20220824173330.2a15bcda24d2c3c248bc43c7@linux-foundation.org>
References: <20220825000506.239406-1-shakeelb@google.com>
        <20220825000506.239406-3-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661387611;
        bh=3yxsP6DawL5+lHuusAb977k18cNkRTLfgXocBtYSv1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oGJkgMPUbZFMjG8O/7KdMb+vxZpJH+5niJeB5INpD8x3qYjLkUAwWFAEXr5JNN1eo
         Zvf29lZuGkCpHP0RE/bBdynwQoc8oxWiELrbP6kyLDky2jSG7ggF/8yGnTB04Gjxo1
         pMFYLznoGdT4pFmceHv0wgl291f+JjhUcTezFMoo=
In-Reply-To: <20220825000506.239406-3-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?ISO-8859-1?Q? Michal_Koutn=FD ?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 25 Aug 2022 00:05:05 +0000 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

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

Did you evaluate the effects of using a per-cpu counter of some form?
