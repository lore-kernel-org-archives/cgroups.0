From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Fri, 13 Dec 2013 15:55:44 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com>
References: <20131203120454.GA12758@dhcp22.suse.cz> <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com> <20131204111318.GE8410@dhcp22.suse.cz> <alpine.DEB.2.02.1312041606260.6329@chino.kir.corp.google.com> <20131209124840.GC3597@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com> <20131210103827.GB20242@dhcp22.suse.cz> <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com> <20131211095549.GA18741@dhcp22.suse.cz> <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com>
 <20131212103159.GB2630@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=WsR3OwjUmLA1cI50HqLA13II92hQy3JkApbwJ+l3V8c=;
        b=OzM4vrNuZACn26PiDHJlCrVc24fxcZ1CxElFBHtOpfR/LdG0W1QuN94DQGRQd4quYe
         83D34sIzDaSmv1rmJGI/BIFYR0Q1St/E9eimVX7ywzDeJZ+7sK2SBqebyzngRnRe4ayR
         NWr1OAusmJ90g8HRcgzaNOgGel6W527sQX0HYi2BkhaESTZSIbDKOLR0q9txzV88sJl2
         YVW93y6vxFMQZV3g3ZWVrR4SpD7T8GXvFckx4LhQb8DFn4ROq/Pe3aWi3YvNbIwZYx59
         dqKk4uwvHP1lPdBOBFLw/b46JNJKcVMz0i2CqDFMhTkzh0+CvwhVdPCZ6snBy4SIc8mS
         w0Qw==
In-Reply-To: <20131212103159.GB2630@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Thu, 12 Dec 2013, Michal Hocko wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c72b03bf9679..5cb1deea6aac 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2256,15 +2256,16 @@ bool mem_cgroup_oom_synchronize(bool handle)
>  
>  	locked = mem_cgroup_oom_trylock(memcg);
>  
> -	if (locked)
> -		mem_cgroup_oom_notify(memcg);
> -
>  	if (locked && !memcg->oom_kill_disable) {
>  		mem_cgroup_unmark_under_oom(memcg);
>  		finish_wait(&memcg_oom_waitq, &owait.wait);
> +		/* calls mem_cgroup_oom_notify if there is a task to kill */
>  		mem_cgroup_out_of_memory(memcg, current->memcg_oom.gfp_mask,
>  					 current->memcg_oom.order);
>  	} else {
> +		if (locked && memcg->oom_kill_disable)
> +			mem_cgroup_oom_notify(memcg);
> +
>  		schedule();
>  		mem_cgroup_unmark_under_oom(memcg);
>  		finish_wait(&memcg_oom_waitq, &owait.wait);
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 1e4a600a6163..2a7f15900922 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -470,6 +470,9 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  		victim = p;
>  	}
>  
> +	if (memcg)
> +		mem_cgroup_oom_notify(memcg);
> +
>  	/* mm cannot safely be dereferenced after task_unlock(victim) */
>  	mm = victim->mm;
>  	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",

Yes, I like this.

> The semantic would be as simple as "notification is sent only when
> an action is due". It will be still racy as nothing prevents a task
> which is not under OOM to exit and release some memory but there is no
> sensible way to address that. On the other hand such a semantic would be
> sensible for oom_control listeners because they will know that an action
> has to be or will be taken (the line was drawn).
> 

I think this makes absolute sense and is in agreement with what is 
described in Documentation/cgroups/memory.txt.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c72b03bf9679..fee25c5934d2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2692,7 +2693,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  	 * MEMDIE process.
>  	 */
>  	if (unlikely(test_thread_flag(TIF_MEMDIE)
> -		     || fatal_signal_pending(current)))
> +		     || fatal_signal_pending(current))
> +		     || current->flags & PF_EXITING)
>  		goto bypass;
>  
>  	if (unlikely(task_in_memcg_oom(current)))
> 
> rather than the later checks down the oom_synchronize paths. The comment
> already mentions dying process...
> 

This is scary because it doesn't even try to reclaim memcg memory before 
allowing the allocation to succeed.  I think we could even argue that we 
should move the fatal_signal_pending(current) check to later and the only 
condition we should really be bypassing here is TIF_MEMDIE since it will 
only get set when reclaim has already failed.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
