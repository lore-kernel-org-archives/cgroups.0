From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch v2 -mm] mm, oom: prefer thread group leaders for display
 purposes
Date: Thu, 16 Jan 2014 15:21:41 +0100
Message-ID: <20140116142141.GF28157@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com>
 <20140116070549.GL6963@cmpxchg.org>
 <alpine.DEB.2.02.1401152344560.14407@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1401152345330.14407@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401152345330.14407-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 15-01-14 23:46:44, David Rientjes wrote:
> When two threads have the same badness score, it's preferable to kill the 
> thread group leader so that the actual process name is printed to the 
> kernel log rather than the thread group name which may be shared amongst 
> several processes.

I am not sure I understand this. Is this about ->comm? If yes then why
couldn't the group leader do PR_SET_NAME?

> This was the behavior when select_bad_process() used to do 
> for_each_process(), but it now iterates threads instead and leads to 
> ambiguity.
> 
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  v2: fixes missing get_task_struct() found by Johannes.
> 
>  mm/memcontrol.c | 19 ++++++++++++-------
>  mm/oom_kill.c   | 12 ++++++++----
>  2 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a815686..d69c4b3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1841,13 +1841,18 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  				break;
>  			};
>  			points = oom_badness(task, memcg, NULL, totalpages);
> -			if (points > chosen_points) {
> -				if (chosen)
> -					put_task_struct(chosen);
> -				chosen = task;
> -				chosen_points = points;
> -				get_task_struct(chosen);
> -			}
> +			if (points < chosen_points)
> +				continue;
> +			/* Prefer thread group leaders for display purposes */
> +			if (points == chosen_points &&
> +			    thread_group_leader(chosen))
> +				continue;
> +
> +			if (chosen)
> +				put_task_struct(chosen);
> +			chosen = task;
> +			chosen_points = points;
> +			get_task_struct(chosen);
>  		}
>  		css_task_iter_end(&it);
>  	}
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 054ff47..1dca3d8 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -327,10 +327,14 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  			break;
>  		};
>  		points = oom_badness(p, NULL, nodemask, totalpages);
> -		if (points > chosen_points) {
> -			chosen = p;
> -			chosen_points = points;
> -		}
> +		if (points < chosen_points)
> +			continue;
> +		/* Prefer thread group leaders for display purposes */
> +		if (points == chosen_points && thread_group_leader(chosen))
> +			continue;
> +
> +		chosen = p;
> +		chosen_points = points;
>  	}
>  	if (chosen)
>  		get_task_struct(chosen);

-- 
Michal Hocko
SUSE Labs
