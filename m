From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] mm/vmscan: Don't mess with pgdat->flags in memcg
 reclaim.
Date: Thu, 5 Apr 2018 15:18:28 -0700
Message-ID: <20180405151828.98b5bfb143a7a8b7dec4b153@linux-foundation.org>
References: <20180323152029.11084-1-aryabinin@virtuozzo.com>
        <20180323152029.11084-5-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323152029.11084-5-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, 23 Mar 2018 18:20:29 +0300 Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:

> memcg reclaim may alter pgdat->flags based on the state of LRU lists
> in cgroup and its children. PGDAT_WRITEBACK may force kswapd to sleep
> congested_wait(), PGDAT_DIRTY may force kswapd to writeback filesystem
> pages. But the worst here is PGDAT_CONGESTED, since it may force all
> direct reclaims to stall in wait_iff_congested(). Note that only kswapd
> have powers to clear any of these bits. This might just never happen if
> cgroup limits configured that way. So all direct reclaims will stall
> as long as we have some congested bdi in the system.
> 
> Leave all pgdat->flags manipulations to kswapd. kswapd scans the whole
> pgdat, only kswapd can clear pgdat->flags once node is balance, thus
> it's reasonable to leave all decisions about node state to kswapd.
> 
> Moving pgdat->flags manipulation to kswapd, means that cgroup2 recalim
> now loses its congestion throttling mechanism. Add per-cgroup congestion
> state and throttle cgroup2 reclaimers if memcg is in congestion state.
> 
> Currently there is no need in per-cgroup PGDAT_WRITEBACK and PGDAT_DIRTY
> bits since they alter only kswapd behavior.
> 
> The problem could be easily demonstrated by creating heavy congestion
> in one cgroup:
> 
>     echo "+memory" > /sys/fs/cgroup/cgroup.subtree_control
>     mkdir -p /sys/fs/cgroup/congester
>     echo 512M > /sys/fs/cgroup/congester/memory.max
>     echo $$ > /sys/fs/cgroup/congester/cgroup.procs
>     /* generate a lot of diry data on slow HDD */
>     while true; do dd if=/dev/zero of=/mnt/sdb/zeroes bs=1M count=1024; done &
>     ....
>     while true; do dd if=/dev/zero of=/mnt/sdb/zeroes bs=1M count=1024; done &
> 
> and some job in another cgroup:
> 
>     mkdir /sys/fs/cgroup/victim
>     echo 128M > /sys/fs/cgroup/victim/memory.max
> 
>     # time cat /dev/sda > /dev/null
>     real    10m15.054s
>     user    0m0.487s
>     sys     1m8.505s
> 
> According to the tracepoint in wait_iff_congested(), the 'cat' spent 50%
> of the time sleeping there.
> 
> With the patch, cat don't waste time anymore:
> 
>     # time cat /dev/sda > /dev/null
>     real    5m32.911s
>     user    0m0.411s
>     sys     0m56.664s
> 

Reviewers, please?
