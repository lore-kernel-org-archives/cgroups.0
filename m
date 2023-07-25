From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] mm: memcg: use rstat for non-hierarchical stats
Date: Tue, 25 Jul 2023 12:24:19 -0700
Message-ID: <CAJD7tkaYHvaX6SL=A6TsCQHT+rOTp-WhOiQ1XSN+ywOVN=-QBQ@mail.gmail.com>
References: <20230719174613.3062124-1-yosryahmed@google.com> <20230725140435.GB1146582@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690313096; x=1690917896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1uMPkgHteWQUIoqBLGXNOkNPWdTfMsi2o8RVrftxNk=;
        b=ooRahWUd9qepvopG3J9bw8egrolyIsO84D5Vc0l1eY7rKbHLsh4YLsQhAkHszACG43
         wiDdZqDCfuuZG0/qiNUsKynyxGflky1uwaaXpJIgWCWwyX50Bx2lq2hxpkz0LEfD9cD7
         08HWy/WST4OLNYWEfwBafRDQQdKtdlRQ4NyE9pxSSW2B8prEMlyI6Lq7Vk7jgjQVPxpT
         1yfFkkxhTK0RvKM7EfpXF6sG/rTkke8+HFRi1yyIM18vj2TKd8NhpBhNxcwxAm8Fntfv
         itmeTnNvDP1worfpkzjL3V/Vi4p3Q4MC+X0pnrXtub5xWx6V9wHU4GMu/+yCT0tixuYA
         hlfA==
In-Reply-To: <20230725140435.GB1146582@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Hey Johannes,

On Tue, Jul 25, 2023 at 7:04=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Wed, Jul 19, 2023 at 05:46:13PM +0000, Yosry Ahmed wrote:
> > Currently, memcg uses rstat to maintain hierarchical stats. The rstat
> > framework keeps track of which cgroups have updates on which cpus.
> >
> > For non-hierarchical stats, as memcg moved to rstat, they are no longer
> > readily available as counters. Instead, the percpu counters for a given
> > stat need to be summed to get the non-hierarchical stat value. This
> > causes a performance regression when reading non-hierarchical stats on
> > kernels where memcg moved to using rstat. This is especially visible
> > when reading memory.stat on cgroup v1. There are also some code paths
> > internal to the kernel that read such non-hierarchical stats.
>
> It's actually not an rstat regression. It's always been this costly.
>
> Quick history:

Thanks for the context.

>
> We used to maintain *all* stats in per-cpu counters at the local
> level. memory.stat reads would have to iterate and aggregate the
> entire subtree every time. This was obviously very costly, so we added
> batched upward propagation during stat updates to simplify reads:
>
> commit 42a300353577ccc17ecc627b8570a89fa1678bec
> Author: Johannes Weiner <hannes@cmpxchg.org>
> Date:   Tue May 14 15:47:12 2019 -0700
>
>     mm: memcontrol: fix recursive statistics correctness & scalabilty
>
> However, that caused a regression in the stat write path, as the
> upward propagation would bottleneck on the cachelines in the shared
> parents. The fix for *that* re-introduced the per-cpu loops in the
> local stat reads:
>
> commit 815744d75152078cde5391fc1e3c2d4424323fb6
> Author: Johannes Weiner <hannes@cmpxchg.org>
> Date:   Thu Jun 13 15:55:46 2019 -0700
>
>     mm: memcontrol: don't batch updates of local VM stats and events
>
> So I wouldn't say it's a regression from rstat. Except for that short
> period between the two commits above, the read side for local stats
> was always expensive.

I was comparing from an 4.15 kernel, so I assumed the major change was
from rstat, but that was not accurate. Thanks for the history.

However, in that 4.15 kernel the local (non-hierarchical) stats were
readily available without iterating percpu counters. There is a
regression that was introduced somewhere.

Looking at the history you described, it seems like up until
815744d75152 we used to maintain "local" (aka non-hierarchical)
counters, so reading local stats was reading one counter, and starting
815744d75152 we started having to loop percpu counters for that.

So it is not a regression of rstat, but seemingly it is a regression
of 815744d75152. Is my understanding incorrect?

>
> rstat promises a shot at finally fixing it, with less risk to the
> write path.
>
> > It is inefficient to iterate and sum counters in all cpus when the rsta=
t
> > framework knows exactly when a percpu counter has an update. Instead,
> > maintain cpu-aggregated non-hierarchical counters for each stat. During
> > an rstat flush, keep those updated as well. When reading
> > non-hierarchical stats, we no longer need to iterate cpus, we just need
> > to read the maintainer counters, similar to hierarchical stats.
> >
> > A caveat is that we now a stats flush before reading
> > local/non-hierarchical stats through {memcg/lruvec}_page_state_local()
> > or memcg_events_local(), where we previously only needed a flush to
> > read hierarchical stats. Most contexts reading non-hierarchical stats
> > are already doing a flush, add a flush to the only missing context in
> > count_shadow_nodes().
> >
> > With this patch, reading memory.stat from 1000 memcgs is 3x faster on a
> > machine with 256 cpus on cgroup v1:
> >  # for i in $(seq 1000); do mkdir /sys/fs/cgroup/memory/cg$i; done
> >  # time cat /dev/cgroup/memory/cg*/memory.stat > /dev/null
> >  real  0m0.125s
> >  user  0m0.005s
> >  sys   0m0.120s
> >
> > After:
> >  real  0m0.032s
> >  user  0m0.005s
> >  sys   0m0.027s
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks! I will reformulate the commit log after we agree on the history.

>
> But I want to be clear: this isn't a regression fix. It's a new
> performance optimization for the deprecated cgroup1 code. And it comes
> at the cost of higher memory footprint for both cgroup1 AND cgroup2.

I still think it is, but I can easily be wrong. I am hoping that the
memory footprint is not a problem. There are *roughly* 80 per-memcg
stats/events (MEMCG_NR_STAT + NR_MEMCG_EVENTS) and 55 per-lruvec stats
(NR_VM_NODE_STAT_ITEMS). For each stat there is an extra 8 bytes, so
on a two-node machine that's  8 * (80 + 55 * 2) ~=3D 1.5 KiB per memcg.

Given that struct mem_cgroup is already large, and can easily be 100s
of KiBs on a large machine with many cpus, I hope there won't be a
noticeable regression.

>
> If this causes a regression, we should revert it again. But let's try.

Of course. Fingers crossed.
