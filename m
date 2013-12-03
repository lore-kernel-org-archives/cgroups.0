From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Tue, 3 Dec 2013 15:50:41 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com>
References: <20131114032508.GL707@cmpxchg.org> <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <20131118154115.GA3556@cmpxchg.org> <20131118165110.GE32623@dhcp22.suse.cz>
 <20131122165100.GN3556@cmpxchg.org> <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com> <20131127163435.GA3556@cmpxchg.org> <20131202200221.GC5524@dhcp22.suse.cz> <20131202212500.GN22729@cmpxchg.org> <20131203120454.GA12758@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=Ob8hLwNZ52HDI/78rMS9K8BmKKv7VNSjjuVg9KTcmtA=;
        b=JIMsOAhpKWwiJcNPxDKIYBc60uPmstLWLr8eGpNUdOqzAb41ttkhnK2qXBTiJRFg1V
         pojrYgmsAOlzTREnWsdflbVcjgw/L/mx3q4pciuyIuRxTNpKNM9DMmZ/vnsiV2gn2CNJ
         vkGL5MvPnYUgs1Dg+C+aJkGbA0ouNOixN30+RLcoQFUb5mb6TTZfa/nF0brEUL6g67fe
         PBP0NnIFwR79HMgFbEM6H0D9bdFqL7fc2uWxwGkFsxGsRohpkSptG2oZuPsNRLKGvm35
         8ADY9ZP+o8Wx9fMsnJGQFQqzSATeOjbX31ctTKiic/1coVrvGOZWKlOxh10STjQnsVyy
         2SVQ==
In-Reply-To: <20131203120454.GA12758@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Tue, 3 Dec 2013, Michal Hocko wrote:

> OK, as it seems that the notification part is too controversial, how
> would you like the following? It reverts the notification part and still
> solves the fault on exit path. I will prepare the full patch with the
> changelog if this looks reasonable:

Um, no, that's not satisfactory because it obviously does the check after 
mem_cgroup_oom_notify().  There is absolutely no reason why userspace 
should be woken up when current simply needs access to memory reserves to 
exit.  You can already get such notification by memory thresholds at the 
memcg limit.

I'll repeat: Section 10 of Documentation/cgroups/memory.txt specifies what 
userspace should do when waking up; one of those options is not "check if 
the memcg is still actually oom in a short period of time once a charging 
task with a pending SIGKILL or in the exit path has been able to exit."  
Users of this interface typically also disable the memcg oom killer 
through the same file, it's ludicrous to put the responsibility on 
userspace to determine if the wakeup is actionable and requires it to 
intervene in one of the methods listed in section 10.

> ---
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 28c9221b74ea..f44fe7e65a98 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1783,6 +1783,16 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	unsigned int points = 0;
>  	struct task_struct *chosen = NULL;
>  
> +	/*
> +	 * If current has a pending SIGKILL or is exiting, then automatically
> +	 * select it.  The goal is to allow it to allocate so that it may
> +	 * quickly exit and free its memory.
> +	 */
> +	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
> +		set_thread_flag(TIF_MEMDIE);
> +		goto cleanup;
> +	}
> +
>  	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
>  	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
>  	for_each_mem_cgroup_tree(iter, memcg) {
> @@ -2233,16 +2243,6 @@ bool mem_cgroup_oom_synchronize(bool handle)
>  	if (!handle)
>  		goto cleanup;
>  
> -	/*
> -	 * If current has a pending SIGKILL or is exiting, then automatically
> -	 * select it.  The goal is to allow it to allocate so that it may
> -	 * quickly exit and free its memory.
> -	 */
> -	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
> -		set_thread_flag(TIF_MEMDIE);
> -		goto cleanup;
> -	}
> -
>  	owait.memcg = memcg;
>  	owait.wait.flags = 0;
>  	owait.wait.func = memcg_oom_wake_function;
> @@ -2266,6 +2266,13 @@ bool mem_cgroup_oom_synchronize(bool handle)
>  		schedule();
>  		mem_cgroup_unmark_under_oom(memcg);
>  		finish_wait(&memcg_oom_waitq, &owait.wait);
> +
> +		/* Userspace OOM handler cannot set TIF_MEMDIE to a target */
> +		if (memcg->oom_kill_disable) {
> +			if ((fatal_signal_pending(current) ||
> +						current->flags & PF_EXITING))
> +				set_thread_flag(TIF_MEMDIE);
> +		}
>  	}
>  
>  	if (locked) {

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
