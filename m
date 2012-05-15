From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 0/6] mm: memcg: statistics implementation cleanups
Date: Tue, 15 May 2012 09:19:33 +0900
Message-ID: <4FB1A115.2080303@jp.fujitsu.com>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337018451-27359-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/05/15 3:00), Johannes Weiner wrote:

> Before piling more things (reclaim stats) on top of the current mess,
> I thought it'd be better to clean up a bit.
> 
> The biggest change is printing statistics directly from live counters,
> it has always been annoying to declare a new counter in two separate
> enums and corresponding name string arrays.  After this series we are
> down to one of each.
> 
>  mm/memcontrol.c |  223 +++++++++++++++++------------------------------
>  1 file changed, 82 insertions(+), 141 deletions(-)
> 


to all 1-6. Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

One excuse for my old implementation of mem_cgroup_get_total_stat(),
which is fixed in patch 6, is that I thought it's better to touch all counters
in a cachineline at once and avoiding long distance for-each loop.

What number of performance difference with some big hierarchy(100+children) tree ?
(But I agree your code is cleaner. I'm just curious.)

Thanks,
-Kame
