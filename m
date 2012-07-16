From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH mmotm] mm, oom: reduce dependency on tasklist_lock: fix
Date: Mon, 16 Jul 2012 10:06:03 +0200
Message-ID: <20120716080603.GA14664@tiehlicka.suse.cz>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1206291406110.6040@chino.kir.corp.google.com>
 <20120713143206.GA4511@tiehlicka.suse.cz>
 <alpine.LSU.2.00.1207160039120.3936@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207160039120.3936-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 16-07-12 00:42:37, Hugh Dickins wrote:
> Slab poisoning gave me a General Protection Fault on the
> 	atomic_dec(&__task_cred(p)->user->processes);
> line of release_task() called from wait_task_zombie(),
> every time my dd to USB testing generated a memcg OOM.

Just curious, was it with the wait-on-pagereclaim patch?

> oom_kill_process() now does the put_task_struct(),
> mem_cgroup_out_of_memory() should not repeat it.

Good catch. I have missed that during review - my bad...

> 
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
> 
>  mm/memcontrol.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- mmotm/mm/memcontrol.c	2012-07-11 14:50:29.808349013 -0700
> +++ linux/mm/memcontrol.c	2012-07-15 12:21:26.234289161 -0700
> @@ -1533,7 +1533,6 @@ void mem_cgroup_out_of_memory(struct mem
>  	points = chosen_points * 1000 / totalpages;
>  	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
>  			 NULL, "Memory cgroup out of memory");
> -	put_task_struct(chosen);
>  }
>  
>  static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
