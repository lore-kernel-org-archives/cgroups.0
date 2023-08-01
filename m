From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcg: use rstat for non-hierarchical stats
Date: Tue, 1 Aug 2023 16:30:38 +0200
Message-ID: <ZMkXDuwD8RFRKnNQ@dhcp22.suse.cz>
References: <20230726153223.821757-1-yosryahmed@google.com>
 <20230726153223.821757-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1690900239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pz1l+QMKxerQA4dFIRKVby7zK5mB68xPOHSaoNz0WSY=;
        b=I+JPhdeNfZHKugkMSm3dRiHW3/+V5hLTM6bz+YUA2ilPxJsvrB1WGeE5MI4+Ty4K/HJ4DI
        +LGu6r+O8WcwHc1IYlRKJdWvXrBblVNgxExfag+U0p/0INLcESk4JWw8UQa0vrSwpThptj
        ADb/Vn0X+V4ZvO4iLQqkjORvST1JclQ=
Content-Disposition: inline
In-Reply-To: <20230726153223.821757-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 26-07-23 15:32:23, Yosry Ahmed wrote:
> Currently, memcg uses rstat to maintain aggregated hierarchical stats.
> Counters are maintained for hierarchical stats at each memcg. Rstat
> tracks which cgroups have updates on which cpus to keep those counters
> fresh on the read-side.
> 
> Non-hierarchical stats are currently not covered by rstat. Their
> per-cpu counters are summed up on every read, which is expensive.
> The original implementation did the same. At some point before rstat,
> non-hierarchical aggregated counters were introduced by
> commit a983b5ebee57 ("mm: memcontrol: fix excessive complexity in
> memory.stat reporting"). However, those counters were updated on the
> performance critical write-side, which caused regressions, so they were
> later removed by commit 815744d75152 ("mm: memcontrol: don't batch
> updates of local VM stats and events"). See [1] for more detailed
> history.
> 
> Kernel versions in between a983b5ebee57 & 815744d75152 (a year and a
> half) enjoyed cheap reads of non-hierarchical stats, specifically on
> cgroup v1. When moving to more recent kernels, a performance regression
> for reading non-hierarchical stats is observed.
> 
> Now that we have rstat, we know exactly which percpu counters have
> updates for each stat. We can maintain non-hierarchical counters again,
> making reads much more efficient, without affecting the performance
> critical write-side. Hence, add non-hierarchical (i.e local) counters
> for the stats, and extend rstat flushing to keep those up-to-date.
> 
> A caveat is that we now need a stats flush before reading
> local/non-hierarchical stats through {memcg/lruvec}_page_state_local()
> or memcg_events_local(), where we previously only needed a flush to
> read hierarchical stats. Most contexts reading non-hierarchical stats
> are already doing a flush, add a flush to the only missing context in
> count_shadow_nodes().
> 
> With this patch, reading memory.stat from 1000 memcgs is 3x faster on a
> machine with 256 cpus on cgroup v1:
>  # for i in $(seq 1000); do mkdir /sys/fs/cgroup/memory/cg$i; done
>  # time cat /dev/cgroup/memory/cg*/memory.stat > /dev/null
>  real	 0m0.125s
>  user	 0m0.005s
>  sys	 0m0.120s
> 
> After:
>  real	 0m0.032s
>  user	 0m0.005s
>  sys	 0m0.027s

Have you measured any potential regression for cgroup v2 which collects
all this data without ever using it (AFAICS)?
-- 
Michal Hocko
SUSE Labs
