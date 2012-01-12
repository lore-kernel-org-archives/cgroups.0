From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: hierarchical soft limit reclaim
Date: Thu, 12 Jan 2012 10:54:27 +0900
Message-ID: <20120112105427.4b80437b.kamezawa.hiroyu@jp.fujitsu.com>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
	<1326207772-16762-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326207772-16762-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 10 Jan 2012 16:02:52 +0100
Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> Right now, memcg soft limits are implemented by having a sorted tree
> of memcgs that are in excess of their limits.  Under global memory
> pressure, kswapd first reclaims from the biggest excessor and then
> proceeds to do regular global reclaim.  The result of this is that
> pages are reclaimed from all memcgs, but more scanning happens against
> those above their soft limit.
> 
> With global reclaim doing memcg-aware hierarchical reclaim by default,
> this is a lot easier to implement: everytime a memcg is reclaimed
> from, scan more aggressively (per tradition with a priority of 0) if
> it's above its soft limit.  With the same end result of scanning
> everybody, but soft limit excessors a bit more.
> 
> Advantages:
> 
>   o smoother reclaim: soft limit reclaim is a separate stage before
>     global reclaim, whose result is not communicated down the line and
>     so overreclaim of the groups in excess is very likely.  After this
>     patch, soft limit reclaim is fully integrated into regular reclaim
>     and each memcg is considered exactly once per cycle.
> 
>   o true hierarchy support: soft limits are only considered when
>     kswapd does global reclaim, but after this patch, targetted
>     reclaim of a memcg will mind the soft limit settings of its child
>     groups.
> 
>   o code size: soft limit reclaim requires a lot of code to maintain
>     the per-node per-zone rb-trees to quickly find the biggest
>     offender, dedicated paths for soft limit reclaim etc. while this
>     new implementation gets away without all that.
> 
> Test:
> 
> The test consists of two concurrent kernel build jobs in separate
> source trees, the master and the slave.  The two jobs get along nicely
> on 600MB of available memory, so this is the zero overcommit control
> case.  When available memory is decreased, the overcommit is
> compensated by decreasing the soft limit of the slave by the same
> amount, in the hope that the slave takes the hit and the master stays
> unaffected.
> 
>                                     600M-0M-vanilla         600M-0M-patched
> Master walltime (s)               552.65 (  +0.00%)       552.38 (  -0.05%)
> Master walltime (stddev)            1.25 (  +0.00%)         0.92 ( -14.66%)
> Master major faults               204.38 (  +0.00%)       205.38 (  +0.49%)
> Master major faults (stddev)       27.16 (  +0.00%)        13.80 ( -47.43%)
> Master reclaim                     31.88 (  +0.00%)        37.75 ( +17.87%)
> Master reclaim (stddev)            34.01 (  +0.00%)        75.88 (+119.59%)
> Master scan                        31.88 (  +0.00%)        37.75 ( +17.87%)
> Master scan (stddev)               34.01 (  +0.00%)        75.88 (+119.59%)
> Master kswapd reclaim           33922.12 (  +0.00%)     33887.12 (  -0.10%)
> Master kswapd reclaim (stddev)    969.08 (  +0.00%)       492.22 ( -49.16%)
> Master kswapd scan              34085.75 (  +0.00%)     33985.75 (  -0.29%)
> Master kswapd scan (stddev)      1101.07 (  +0.00%)       563.33 ( -48.79%)
> Slave walltime (s)                552.68 (  +0.00%)       552.12 (  -0.10%)
> Slave walltime (stddev)             0.79 (  +0.00%)         1.05 ( +14.76%)
> Slave major faults                212.50 (  +0.00%)       204.50 (  -3.75%)
> Slave major faults (stddev)        26.90 (  +0.00%)        13.17 ( -49.20%)
> Slave reclaim                      26.12 (  +0.00%)        35.00 ( +32.72%)
> Slave reclaim (stddev)             29.42 (  +0.00%)        74.91 (+149.55%)
> Slave scan                         31.38 (  +0.00%)        35.00 ( +11.20%)
> Slave scan (stddev)                33.31 (  +0.00%)        74.91 (+121.24%)
> Slave kswapd reclaim            34259.00 (  +0.00%)     33469.88 (  -2.30%)
> Slave kswapd reclaim (stddev)     925.15 (  +0.00%)       565.07 ( -38.88%)
> Slave kswapd scan               34354.62 (  +0.00%)     33555.75 (  -2.33%)
> Slave kswapd scan (stddev)        969.62 (  +0.00%)       581.70 ( -39.97%)
> 
> In the control case, the differences in elapsed time, number of major
> faults taken, and reclaim statistics are within the noise for both the
> master and the slave job.
> 
>                                      600M-280M-vanilla      600M-280M-patched
> Master walltime (s)                  595.13 (  +0.00%)      553.19 (  -7.04%)
> Master walltime (stddev)               8.31 (  +0.00%)        2.57 ( -61.64%)
> Master major faults                 3729.75 (  +0.00%)      783.25 ( -78.98%)
> Master major faults (stddev)         258.79 (  +0.00%)      226.68 ( -12.36%)
> Master reclaim                       705.00 (  +0.00%)       29.50 ( -95.68%)
> Master reclaim (stddev)              232.87 (  +0.00%)       44.72 ( -80.45%)
> Master scan                          714.88 (  +0.00%)       30.00 ( -95.67%)
> Master scan (stddev)                 237.44 (  +0.00%)       45.39 ( -80.54%)
> Master kswapd reclaim                114.75 (  +0.00%)       50.00 ( -55.94%)
> Master kswapd reclaim (stddev)       128.51 (  +0.00%)        9.45 ( -91.93%)
> Master kswapd scan                   115.75 (  +0.00%)       50.00 ( -56.32%)
> Master kswapd scan (stddev)          130.31 (  +0.00%)        9.45 ( -92.04%)
> Slave walltime (s)                   631.18 (  +0.00%)      577.68 (  -8.46%)
> Slave walltime (stddev)                9.89 (  +0.00%)        3.63 ( -57.47%)
> Slave major faults                 28401.75 (  +0.00%)    14656.75 ( -48.39%)
> Slave major faults (stddev)         2629.97 (  +0.00%)     1911.81 ( -27.30%)
> Slave reclaim                      65400.62 (  +0.00%)     1479.62 ( -97.74%)
> Slave reclaim (stddev)             11623.02 (  +0.00%)     1482.13 ( -87.24%)
> Slave scan                       9050047.88 (  +0.00%)    95968.25 ( -98.94%)
> Slave scan (stddev)              1912786.94 (  +0.00%)    93390.71 ( -95.12%)
> Slave kswapd reclaim              327894.50 (  +0.00%)   227099.88 ( -30.74%)
> Slave kswapd reclaim (stddev)      22289.43 (  +0.00%)    16113.14 ( -27.71%)
> Slave kswapd scan               34987335.75 (  +0.00%)  1362367.12 ( -96.11%)
> Slave kswapd scan (stddev)       2523642.98 (  +0.00%)   156754.74 ( -93.79%)
> 
> Here, the available memory is limited to 320 MB, the machine is
> overcommitted by 280 MB.  The soft limit of the master is 300 MB, that
> of the slave merely 20 MB.
> 
> Looking at the slave job first, it is much better off with the patched
> kernel: direct reclaim is almost gone, kswapd reclaim is decreased by
> a third.  The result is much fewer major faults taken, which in turn
> lets the job finish quicker.
> 
> It would be a zero-sum game if the improvement happened at the cost of
> the master but looking at the numbers, even the master performs better
> with the patched kernel.  In fact, the master job is almost unaffected
> on the patched kernel compared to the control case.
> 
> This is an odd phenomenon, as the patch does not directly change how
> the master is reclaimed.  An explanation for this is that the severe
> overreclaim of the slave in the unpatched kernel results in the master
> growing bigger than in the patched case.  Combining the fact that
> memcgs are scanned according to their size with the increased refault
> rate of the overreclaimed slave triggering global reclaim more often
> means that overall pressure on the master job is higher in the
> unpatched kernel.
> 
> At any rate, the patched kernel seems to do a much better job at both
> overall resource allocation under soft limit overcommit as well as the
> requested prioritization of the master job.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thank you for your work and the result seems atractive and code is much
simpler. My small concerns are..

1. This approach may increase latency of direct-reclaim because of priority=0.
2. In a case numa-spread/interleave application run in its own container, 
   pages on a node may paged-out again and again becasue of priority=0
   if some other application runs in the node.
   It seems difficult to use soft-limit with numa-aware applications.
   Do you have suggestions ?


Thanks,
-Kame
