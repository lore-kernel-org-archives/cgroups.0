From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: use rstat for non-hierarchical stats
Date: Tue, 25 Jul 2023 10:04:35 -0400
Message-ID: <20230725140435.GB1146582@cmpxchg.org>
References: <20230719174613.3062124-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1690293876; x=1690898676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L6q2fbSEUaRmabz4YeOC1QVhb19awtdwyXc9KAJHQSg=;
        b=NhRu+ZEBbGmHUyV23DWyyUEl6Nq9VUT++p+9QWJdkAJ01svswkr1clQ+XgDEJoKZlu
         Weht+NskAhuvf8tGjjG2GgCJMoox5KBq9h7cac9rQqrC1vpsp28oMsNe9KY4CjN98NgM
         2onTXCyaJs2t96h7XB5cCypHFdWg+fwb65PFB8O3ZrvuiaJHuzW2QZDMOqGry5xTxZnL
         a0LtNC5vIK9Xsexs+3OgGgt5bslUleSsJtnl1gA4F45g2Ko2FIGEpl62me3wUqr1jORf
         2aM4RpjbPng4AlA4q3lBQwcuniuBSVYARmbS0pCKD+STkQGtoiTn6CFXFLVdidVlar95
         wCyQ==
Content-Disposition: inline
In-Reply-To: <20230719174613.3062124-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Jul 19, 2023 at 05:46:13PM +0000, Yosry Ahmed wrote:
> Currently, memcg uses rstat to maintain hierarchical stats. The rstat
> framework keeps track of which cgroups have updates on which cpus.
> 
> For non-hierarchical stats, as memcg moved to rstat, they are no longer
> readily available as counters. Instead, the percpu counters for a given
> stat need to be summed to get the non-hierarchical stat value. This
> causes a performance regression when reading non-hierarchical stats on
> kernels where memcg moved to using rstat. This is especially visible
> when reading memory.stat on cgroup v1. There are also some code paths
> internal to the kernel that read such non-hierarchical stats.

It's actually not an rstat regression. It's always been this costly.

Quick history:

We used to maintain *all* stats in per-cpu counters at the local
level. memory.stat reads would have to iterate and aggregate the
entire subtree every time. This was obviously very costly, so we added
batched upward propagation during stat updates to simplify reads:

commit 42a300353577ccc17ecc627b8570a89fa1678bec
Author: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date:   Tue May 14 15:47:12 2019 -0700

    mm: memcontrol: fix recursive statistics correctness & scalabilty

However, that caused a regression in the stat write path, as the
upward propagation would bottleneck on the cachelines in the shared
parents. The fix for *that* re-introduced the per-cpu loops in the
local stat reads:

commit 815744d75152078cde5391fc1e3c2d4424323fb6
Author: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date:   Thu Jun 13 15:55:46 2019 -0700

    mm: memcontrol: don't batch updates of local VM stats and events

So I wouldn't say it's a regression from rstat. Except for that short
period between the two commits above, the read side for local stats
was always expensive.

rstat promises a shot at finally fixing it, with less risk to the
write path.

> It is inefficient to iterate and sum counters in all cpus when the rstat
> framework knows exactly when a percpu counter has an update. Instead,
> maintain cpu-aggregated non-hierarchical counters for each stat. During
> an rstat flush, keep those updated as well. When reading
> non-hierarchical stats, we no longer need to iterate cpus, we just need
> to read the maintainer counters, similar to hierarchical stats.
> 
> A caveat is that we now a stats flush before reading
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
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

But I want to be clear: this isn't a regression fix. It's a new
performance optimization for the deprecated cgroup1 code. And it comes
at the cost of higher memory footprint for both cgroup1 AND cgroup2.

If this causes a regression, we should revert it again. But let's try.
