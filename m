From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2] mm: memcg: use rstat for non-hierarchical stats
Date: Tue, 25 Jul 2023 19:15:41 -0700
Message-ID: <ZMCBzUH7qIdc3Y2X@P9FQF9L96D>
References: <20230726002904.655377-1-yosryahmed@google.com>
 <20230726002904.655377-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690337752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LkLUCGJT74cllQvTQ6MTx9QgnJE9Fo6dHQUygyCQSWc=;
        b=P59UCGFim3QDtZSMOt0VwRb3ocDo8l1wi2zSA6eSN/BqU/YIRayerwirvZbuLcLx1R37DN
        YdCcgNxDBq30Q2BEtIH4BuGRjBqYNWesRuyquAwbIs9iakR3r3SbyA4SCffn+s846tmvRs
        qjD5LYy9+6Me2P46VLNrPfjgPrgZvp8=
Content-Disposition: inline
In-Reply-To: <20230726002904.655377-2-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed, Jul 26, 2023 at 12:29:04AM +0000, Yosry Ahmed wrote:
> Currently, memcg uses rstat to maintain hierarchical stats. Counters are
> maintained for hierarchical stats at each memcg. Rstat tracks which
> cgroups have updates on which cpus to keep those counters fresh on the
> read-side.
> 
> For non-hierarchical stats, we do not maintain counters. Instead, the
                                                global?
> percpu counters for a given stat need to be summed to get the
> non-hierarchical stat value. The original implementation did the same.
> At some point before rstat, non-hierarchical counters were introduced by
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
> A caveat is that we now a stats flush before reading
                         need?
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
> [1]https://lore.kernel.org/lkml/20230725201811.GA1231514@cmpxchg.org/
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thank you!
