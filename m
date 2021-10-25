From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg v3 2/3] mm, oom: do not trigger out_of_memory from
 the #PF
Date: Mon, 25 Oct 2021 11:34:12 +0200
Message-ID: <YXZ6FMzJLEz4TA2d@dhcp22.suse.cz>
References: <YXJ/63kIpTq8AOlD@dhcp22.suse.cz>
 <cover.1634994605.git.vvs@virtuozzo.com>
 <f5fd8dd8-0ad4-c524-5f65-920b01972a42@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635154453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BgwDwtXcCfqvhCbDv78Ercq+F3VCH7U2rqOPEH8FuqI=;
        b=aAjwYxoi8Gd35iaLIZ4FAw/Tlx9KYkaQC0/n2ofQtUBK8Gne2NHNToXX1Oo97clokPA4Wo
        5QFhR9MITddfqEzwLdbCR6dQY1qRlx1cJFFBnNQCXETxGhOw4KBElVNbkDVEwjDZgp+Sqe
        JrF5CGJuIV/72+/CzNFcHohV8Qmb2r8=
Content-Disposition: inline
In-Reply-To: <f5fd8dd8-0ad4-c524-5f65-920b01972a42-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Sat 23-10-21 16:20:18, Vasily Averin wrote:
> From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> Any allocation failure during the #PF path will return with VM_FAULT_OOM
> which in turn results in pagefault_out_of_memory. This can happen for
> 2 different reasons. a) Memcg is out of memory and we rely on
> mem_cgroup_oom_synchronize to perform the memcg OOM handling or b)
> normal allocation fails.
> 
> The later is quite problematic because allocation paths already trigger
> out_of_memory and the page allocator tries really hard to not fail
> allocations. Anyway, if the OOM killer has been already invoked there
> is no reason to invoke it again from the #PF path. Especially when the
> OOM condition might be gone by that time and we have no way to find out
> other than allocate.
> 
> Moreover if the allocation failed and the OOM killer hasn't been
> invoked then we are unlikely to do the right thing from the #PF context
> because we have already lost the allocation context and restictions and
> therefore might oom kill a task from a different NUMA domain.
> 
> This all suggests that there is no legitimate reason to trigger
> out_of_memory from pagefault_out_of_memory so drop it. Just to be sure
> that no #PF path returns with VM_FAULT_OOM without allocation print a
> warning that this is happening before we restart the #PF.
> 
> [VvS: #PF allocation can hit into limit of cgroup v1 kmem controller.
> This is a local problem related to memcg, however, it causes unnecessary
> global OOM kills that are repeated over and over again and escalate into
> a real disaster. This has been broken since kmem accounting has been
> introduced for cgroup v1 (3.8). There was no kmem specific reclaim
> for the separate limit so the only way to handle kmem hard limit
> was to return with ENOMEM.
> In upstream the problem will be fixed by removing the outdated kmem limit,
> however stable and LTS kernels cannot do it and are still affected.
> This patch fixes the problem and should be backported into stable/LTS.]
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I would be still careful about backporting to stable trees. At least
wait for a release cycle to catch potential problems before backporting.
The problem with kmem is documented and for quite a lot of time and we
haven't received a single bug report IIRC so this is likely not a real
problem people are facing out there.


> Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

I think this is the right thing to do. Hopefuly we won't find some
tricky code which would depend on this behavior. If this turns out to be
the case then we will clearly learn about it by the kernel message and
we can to handle that situation more gracefully.

Maybe we will want to update the chengelog to be more specific based on
the review comments but this one should describe the problem quite well
already.
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
> v2: hook with fatal_signal_pending() has beem moved into a separate patch,
>     improved patch description, removed "Fixed" mark.
> ---
>  mm/oom_kill.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 1deef8c7a71b..f98954befafb 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1120,19 +1120,15 @@ bool out_of_memory(struct oom_control *oc)
>  }
>  
>  /*
> - * The pagefault handler calls here because it is out of memory, so kill a
> - * memory-hogging task. If oom_lock is held by somebody else, a parallel oom
> - * killing is already in progress so do nothing.
> + * The pagefault handler calls here because some allocation has failed. We have
> + * to take care of the memcg OOM here because this is the only safe context without
> + * any locks held but let the oom killer triggered from the allocation context care
> + * about the global OOM.
>   */
>  void pagefault_out_of_memory(void)
>  {
> -	struct oom_control oc = {
> -		.zonelist = NULL,
> -		.nodemask = NULL,
> -		.memcg = NULL,
> -		.gfp_mask = 0,
> -		.order = 0,
> -	};
> +	static DEFINE_RATELIMIT_STATE(pfoom_rs, DEFAULT_RATELIMIT_INTERVAL,
> +				      DEFAULT_RATELIMIT_BURST);
>  
>  	if (mem_cgroup_oom_synchronize(true))
>  		return;
> @@ -1140,10 +1136,8 @@ void pagefault_out_of_memory(void)
>  	if (fatal_signal_pending(current))
>  		return;
>  
> -	if (!mutex_trylock(&oom_lock))
> -		return;
> -	out_of_memory(&oc);
> -	mutex_unlock(&oom_lock);
> +	if (__ratelimit(&pfoom_rs))
> +		pr_warn("Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF\n");
>  }
>  
>  SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
> -- 
> 2.32.0

-- 
Michal Hocko
SUSE Labs
