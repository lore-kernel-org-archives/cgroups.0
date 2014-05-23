From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 8/9] mm: memcontrol: rewrite charge API
Date: Fri, 23 May 2014 16:18:20 +0200
Message-ID: <20140523141820.GE22135@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-9-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1398889543-23671-9-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 30-04-14 16:25:42, Johannes Weiner wrote:
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d3961fce1d54..6f48e292ffe7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2574,163 +2574,6 @@ static int memcg_cpu_hotplug_callback(struct notifier_block *nb,
>  	return NOTIFY_OK;
>  }
>  
> -/**
> - * mem_cgroup_try_charge - try charging a memcg
> - * @memcg: memcg to charge
> - * @nr_pages: number of pages to charge
> - * @oom: trigger OOM if reclaim fails
> - *
> - * Returns 0 if @memcg was charged successfully, -EINTR if the charge
> - * was bypassed to root_mem_cgroup, and -ENOMEM if the charge failed.
> - */
> -static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
> -				 gfp_t gfp_mask,
> -				 unsigned int nr_pages,
> -				 bool oom)

Why haven't you simply renamed mem_cgroup_try_charge to try_charge here?
The code move is really hard to review.
[...]
-- 
Michal Hocko
SUSE Labs
