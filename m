From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg v2 2/2] memcg: prohibit unconditional exceeding the
 limit of dying tasks
Date: Fri, 22 Oct 2021 11:10:03 +0200
Message-ID: <YXJ/63kIpTq8AOlD@dhcp22.suse.cz>
References: <YXGZoVhROdFG2Wym@dhcp22.suse.cz>
 <cover.1634889066.git.vvs@virtuozzo.com>
 <4b315938-5600-b7f5-bde9-82f638a2e595@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634893803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vr4YC4Ootp7YmZVbnn2IeZzn/hRDb/zTjl1sQmsj3Y4=;
        b=R9XstMmNBuTc8yClgMbVxDC5C6GgjMu70ghewFBYZCpoiP06QqDFRqWH3wnrvhv/IQmgaP
        QS2K0ayylJY9+kzYN4p8QdPHBeCm1vg7vQognKVqlhHNuUEVuZ4huerfiP8txsHMEmJmv4
        59ZPx7m1v06coMsJDaEm6dUfI9Dilp0=
Content-Disposition: inline
In-Reply-To: <4b315938-5600-b7f5-bde9-82f638a2e595-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Fri 22-10-21 11:11:29, Vasily Averin wrote:
> Memory cgroup charging allows killed or exiting tasks to exceed the hard
> limit. It is assumed that the amount of the memory charged by those
> tasks is bound and most of the memory will get released while the task
> is exiting. This is resembling a heuristic for the global OOM situation
> when tasks get access to memory reserves. There is no global memory
> shortage at the memcg level so the memcg heuristic is more relieved.
> 
> The above assumption is overly optimistic though. E.g. vmalloc can scale
> to really large requests and the heuristic would allow that. We used to
> have an early break in the vmalloc allocator for killed tasks but this
> has been reverted by commit b8c8a338f75e ("Revert "vmalloc: back off when
> the current task is killed""). There are likely other similar code paths
> which do not check for fatal signals in an allocation&charge loop.
> Also there are some kernel objects charged to a memcg which are not
> bound to a process life time.
> 
> It has been observed that it is not really hard to trigger these
> bypasses and cause global OOM situation.
> 
> One potential way to address these runaways would be to limit the amount
> of excess (similar to the global OOM with limited oom reserves). This is
> certainly possible but it is not really clear how much of an excess is
> desirable and still protects from global OOMs as that would have to
> consider the overall memcg configuration.
> 
> This patch is addressing the problem by removing the heuristic
> altogether. Bypass is only allowed for requests which either cannot fail
> or where the failure is not desirable while excess should be still
> limited (e.g. atomic requests). Implementation wise a killed or dying
> task fails to charge if it has passed the OOM killer stage. That should
> give all forms of reclaim chance to restore the limit before the
> failure (ENOMEM) and tell the caller to back off.
> 
> In addition, this patch renames should_force_charge() helper
> to task_is_dying() because now its use is not associated witch forced
> charging.

I would explicitly mention that this depends on pagefault_out_of_memory
to not trigger out_of_memory because then a memcg failure can unwind to
VM_FAULT_OOM and cause a global OOM killer.

Maybe it would be even better to fold the removal to this patch so the
dependency is more obvious. I will live that to you.

> Fixes: a636b327f731 ("memcg: avoid unnecessary system-wide-oom-killer")

Fixes tag would be quite hard here. For example you certainly didn't
have a practically unbound vector to go over the hard limit - like
vmalloc. At least not after __GFP_ACCOUNT has been introduced. So I
would just not bother with a Fixes tag at all rather than cause it more
questions than answers.

> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Other than that looks good to me.
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!
> ---
>  mm/memcontrol.c | 27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6da5020a8656..87e41c3cac10 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -239,7 +239,7 @@ enum res_type {
>  	     iter != NULL;				\
>  	     iter = mem_cgroup_iter(NULL, iter, NULL))
>  
> -static inline bool should_force_charge(void)
> +static inline bool task_is_dying(void)
>  {
>  	return tsk_is_oom_victim(current) || fatal_signal_pending(current) ||
>  		(current->flags & PF_EXITING);
> @@ -1575,7 +1575,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * A few threads which were not waiting at mutex_lock_killable() can
>  	 * fail to bail out. Therefore, check again after holding oom_lock.
>  	 */
> -	ret = should_force_charge() || out_of_memory(&oc);
> +	ret = task_is_dying() || out_of_memory(&oc);
>  
>  unlock:
>  	mutex_unlock(&oom_lock);
> @@ -2530,6 +2530,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	struct page_counter *counter;
>  	enum oom_status oom_status;
>  	unsigned long nr_reclaimed;
> +	bool passed_oom = false;
>  	bool may_swap = true;
>  	bool drained = false;
>  	unsigned long pflags;
> @@ -2564,15 +2565,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (gfp_mask & __GFP_ATOMIC)
>  		goto force;
>  
> -	/*
> -	 * Unlike in global OOM situations, memcg is not in a physical
> -	 * memory shortage.  Allow dying and OOM-killed tasks to
> -	 * bypass the last charges so that they can exit quickly and
> -	 * free their memory.
> -	 */
> -	if (unlikely(should_force_charge()))
> -		goto force;
> -
>  	/*
>  	 * Prevent unbounded recursion when reclaim operations need to
>  	 * allocate memory. This might exceed the limits temporarily,
> @@ -2630,8 +2622,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (gfp_mask & __GFP_RETRY_MAYFAIL)
>  		goto nomem;
>  
> -	if (fatal_signal_pending(current))
> -		goto force;
> +	/* Avoid endless loop for tasks bypassed by the oom killer */
> +	if (passed_oom && task_is_dying())
> +		goto nomem;
>  
>  	/*
>  	 * keep retrying as long as the memcg oom killer is able to make
> @@ -2640,14 +2633,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 */
>  	oom_status = mem_cgroup_oom(mem_over_limit, gfp_mask,
>  		       get_order(nr_pages * PAGE_SIZE));
> -	switch (oom_status) {
> -	case OOM_SUCCESS:
> +	if (oom_status == OOM_SUCCESS) {
> +		passed_oom = true;
>  		nr_retries = MAX_RECLAIM_RETRIES;
>  		goto retry;
> -	case OOM_FAILED:
> -		goto force;
> -	default:
> -		goto nomem;
>  	}
>  nomem:
>  	if (!(gfp_mask & __GFP_NOFAIL))
> -- 
> 2.32.0

-- 
Michal Hocko
SUSE Labs
