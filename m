From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch] mm, memcg: avoid unnecessary function call when memcg
 is disabled
Date: Tue, 20 Nov 2012 13:49:32 -0800
Message-ID: <20121120134932.055bc192.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1211191741060.24618-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, 19 Nov 2012 17:44:34 -0800 (PST)
David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> While profiling numa/core v16 with cgroup_disable=memory on the command 
> line, I noticed mem_cgroup_count_vm_event() still showed up as high as 
> 0.60% in perftop.
> 
> This occurs because the function is called extremely often even when memcg 
> is disabled.
> 
> To fix this, inline the check for mem_cgroup_disabled() so we avoid the 
> unnecessary function call if memcg is disabled.
> 
> ...
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -181,7 +181,14 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
>  						gfp_t gfp_mask,
>  						unsigned long *total_scanned);
>  
> -void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
> +void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
> +static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
> +					     enum vm_event_item idx)
> +{
> +	if (mem_cgroup_disabled() || !mm)
> +		return;
> +	__mem_cgroup_count_vm_event(mm, idx);
> +}

Does the !mm case occur frequently enough to justify inlining it, or
should that test remain out-of-line?
