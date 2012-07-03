From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 4/5] mm, oom: reduce dependency on tasklist_lock
Date: Tue, 3 Jul 2012 20:17:08 +0200
Message-ID: <20120703181708.GB14104@redhat.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291406110.6040@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206291406110.6040-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/29, David Rientjes wrote:
>
> +/*
> + * Must be called while holding a reference to p, which will be released upon
> + * returning.
> + */

I am not really sure this is the most clean approach, see below...

>  void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  		      unsigned int points, unsigned long totalpages,
>  		      struct mem_cgroup *memcg, nodemask_t *nodemask,
> @@ -454,6 +462,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	 */
>  	if (p->flags & PF_EXITING) {
>  		set_tsk_thread_flag(p, TIF_MEMDIE);
> +		put_task_struct(p);
>  		return;
>  	}
>  
> @@ -471,6 +480,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	 * parent.  This attempts to lose the minimal amount of work done while
>  	 * still freeing memory.
>  	 */
> +	read_lock(&tasklist_lock);
>  	do {
>  		list_for_each_entry(child, &t->children, sibling) {
>  			unsigned int child_points;
> @@ -483,15 +493,26 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  			child_points = oom_badness(child, memcg, nodemask,
>  								totalpages);
>  			if (child_points > victim_points) {
> +				put_task_struct(victim);
>  				victim = child;
>  				victim_points = child_points;
> +				get_task_struct(victim);
>  			}
>  		}
>  	} while_each_thread(p, t);
> +	read_unlock(&tasklist_lock);
>  
> -	victim = find_lock_task_mm(victim);
> -	if (!victim)
> +	rcu_read_lock();
> +	p = find_lock_task_mm(victim);
> +	if (!p) {
> +		rcu_read_unlock();
> +		put_task_struct(victim);
>  		return;
> +	} else if (victim != p) {
> +		get_task_struct(p);
> +		put_task_struct(victim);
> +		victim = p;
> +	}
>  
>  	/* mm cannot safely be dereferenced after task_unlock(victim) */
>  	mm = victim->mm;
> @@ -522,9 +543,11 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  			task_unlock(p);
>  			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
>  		}
> +	rcu_read_unlock();
>  
>  	set_tsk_thread_flag(victim, TIF_MEMDIE);
>  	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
> +	put_task_struct(victim);

It seems to me we can avoid this get/put dance in oom_kill_process(),
just you need to extend the rcu-protected area. In this case the caller
of select_bad_process() does a single put_, and
sysctl_oom_kill_allocating_task doesn't need get_task_struct(current).
Look more clean/simple to me.

However. This is subjective, and I see nothing wrong in this patch,
I won't insist.

Looks correct.

Oleg.
