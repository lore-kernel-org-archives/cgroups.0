From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/4] mm/vmscan: Don't change pgdat state on base of a
 single LRU list state.
Date: Thu, 5 Apr 2018 15:17:51 -0700
Message-ID: <20180405151751.c07ee14496f9d5b691b49c64@linux-foundation.org>
References: <20180323152029.11084-1-aryabinin@virtuozzo.com>
        <20180323152029.11084-4-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323152029.11084-4-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, 23 Mar 2018 18:20:28 +0300 Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:

> We have separate LRU list for each memory cgroup. Memory reclaim iterates
> over cgroups and calls shrink_inactive_list() every inactive LRU list.
> Based on the state of a single LRU shrink_inactive_list() may flag
> the whole node as dirty,congested or under writeback. This is obviously
> wrong and hurtful. It's especially hurtful when we have possibly
> small congested cgroup in system. Than *all* direct reclaims waste time
> by sleeping in wait_iff_congested(). And the more memcgs in the system
> we have the longer memory allocation stall is, because
> wait_iff_congested() called on each lru-list scan.
> 
> Sum reclaim stats across all visited LRUs on node and flag node as dirty,
> congested or under writeback based on that sum. Also call
> congestion_wait(), wait_iff_congested() once per pgdat scan, instead of
> once per lru-list scan.
> 
> This only fixes the problem for global reclaim case. Per-cgroup reclaim
> may alter global pgdat flags too, which is wrong. But that is separate
> issue and will be addressed in the next patch.
> 
> This change will not have any effect on a systems with all workload
> concentrated in a single cgroup.
> 

Could we please get this reviewed?
