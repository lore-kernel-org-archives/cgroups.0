From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/5 v2] memcg: replace unsigned long by u64 to avoid
 overflow
Date: Mon, 25 Jun 2012 09:52:15 +0200
Message-ID: <20120625075215.GW27816@cmpxchg.org>
References: <1340604266-7937-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1340604266-7937-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 25, 2012 at 02:04:20PM +0800, Wanpeng Li wrote:
> Changlog:
> 
> V2 -> V1:
> * fix zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'
> 
> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Since the return value variable in mem_cgroup_zone_nr_lru_pages and
> mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
> value of funtions by u64 to avoid overflow.
> 
> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/vmstat.h |    2 +-
>  mm/memcontrol.c        |    5 ++---
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 65efb92..6a14291 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -106,7 +106,7 @@ static inline unsigned long global_page_state(enum zone_stat_item item)
>  	return x;
>  }
>  
> -static inline unsigned long zone_page_state(struct zone *zone,
> +static inline u64 zone_page_state(struct zone *zone,
>  					enum zone_stat_item item)
>  {
>  	long x = atomic_long_read(&zone->vm_stat[item]);

We established that there is no known reason to use ulong for page
counters and that IF YOU HAD ONE, you should obviously say so and then
do a wholesale conversion.  But I don't think you have one.

This patch makes absolutely no sense.
