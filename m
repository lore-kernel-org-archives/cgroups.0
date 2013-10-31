From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm, memcg: add memory.oom_control notification for
 system oom
Date: Thu, 31 Oct 2013 01:49:42 -0400
Message-ID: <20131031054942.GA26301@cmpxchg.org>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=CKqQh8X+es6Wgnl08h0Vf0mhROx4tfqC/Gyde5rh8hw=;
	b=LBr8F1ZmmLnwuCxddEbSEhTZSw+a8neAreQOIFtTETlSARDVxn1FbjEM/hGYXJtmy3MYvbDASm3z/qXr72PnHXPIbojtD0t7XvnqxaPUwN5s3+YBiZZDkB14nyoYem04SPGb7tvMoWMjw0kYy8v18bFYXdCGPXjAWKqY0lnkUBU=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310301838300.13556-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Oct 30, 2013 at 06:39:16PM -0700, David Rientjes wrote:
> A subset of applications that wait on memory.oom_control don't disable
> the oom killer for that memcg and simply log or cleanup after the kernel
> oom killer kills a process to free memory.
> 
> We need the ability to do this for system oom conditions as well, i.e.
> when the system is depleted of all memory and must kill a process.  For
> convenience, this can use memcg since oom notifiers are already present.
> 
> When a userspace process waits on the root memcg's memory.oom_control, it
> will wake up anytime there is a system oom condition so that it can log
> the event, including what process was killed and the stack, or cleanup
> after the kernel oom killer has killed something.
> 
> This is a special case of oom notifiers since it doesn't subsequently
> notify all memcgs under the root memcg (all memcgs on the system).  We
> don't want to trigger those oom handlers which are set aside specifically
> for true memcg oom notifications that disable their own oom killers to
> enforce their own oom policy, for example.

There is nothing they can do anyway since the handler is hardcoded for
the root cgroup, so this seems fine.

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -155,6 +155,7 @@ static inline bool task_in_memcg_oom(struct task_struct *p)
>  }
>  
>  bool mem_cgroup_oom_synchronize(bool wait);
> +void mem_cgroup_root_oom_notify(void);
>  
>  #ifdef CONFIG_MEMCG_SWAP
>  extern int do_swap_account;
> @@ -397,6 +398,10 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
>  	return false;
>  }
>  
> +static inline void mem_cgroup_root_oom_notify(void)
> +{
> +}
> +
>  static inline void mem_cgroup_inc_page_stat(struct page *page,
>  					    enum mem_cgroup_stat_index idx)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5641,6 +5641,15 @@ static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
>  		mem_cgroup_oom_notify_cb(iter);
>  }
>  
> +/*
> + * Notify any process waiting on the root memcg's memory.oom_control, but do not
> + * notify any child memcgs to avoid triggering their per-memcg oom handlers.
> + */
> +void mem_cgroup_root_oom_notify(void)
> +{
> +	mem_cgroup_oom_notify_cb(root_mem_cgroup);
> +}
> +
>  static int mem_cgroup_usage_register_event(struct cgroup_subsys_state *css,
>  	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
>  {
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -632,6 +632,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
>  		return;
>  	}
>  
> +	/* Avoid waking up processes for oom kills triggered by sysrq */
> +	if (!force_kill)
> +		mem_cgroup_root_oom_notify();

We have an API for global OOM notifications, please just use
register_oom_notifier() instead.
