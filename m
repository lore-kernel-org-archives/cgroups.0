From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Wed, 26 Jan 2022 17:57:14 +0100
Message-ID: <7f4928b8-16e2-88b3-2688-1519a19653a9@suse.cz>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1643216234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3McJH9/soyjDGsp4lQ4WDb3Lp1cmKICM9yz0suAddps=;
        b=cLAh3kTg6YH2mjns+CgakIQCEYBwygZGFAjVifsaYEfSyZACiBw3lgIHsgMtKLsXBXryhj
        egW/JW0V5e116ht90lFaE441PuvGgBp++a980OIva1KUIwmXSRsYAe+9C+Gx3IpZyRtzBe
        OZHRFzRYtyR7iOmR3AENe0VrXAALha4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1643216234;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3McJH9/soyjDGsp4lQ4WDb3Lp1cmKICM9yz0suAddps=;
        b=d/ezpIRJ0s+H4pkw6fmafDzl1Bi4zJkzOM51iBovrsIs36OlEObcv9xuoDYSVUUZLoPSN/
        GZZwnKlYI3E2yJCA==
Content-Language: en-US
In-Reply-To: <20220125164337.2071854-4-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 1/25/22 17:43, Sebastian Andrzej Siewior wrote:
> The members of the per-CPU structure memcg_stock_pcp are protected
> either by disabling interrupts or by disabling preemption if the
> invocation occurred in process context.
> Disabling interrupts protects most of the structure excluding task_obj
> while disabling preemption protects only task_obj.
> This schema is incompatible with PREEMPT_RT because it creates atomic
> context in which actions are performed which require preemptible
> context. One example is obj_cgroup_release().
> 
> The IRQ-disable and preempt-disable sections can be replaced with
> local_lock_t which preserves the explicit disabling of interrupts while
> keeps the code preemptible on PREEMPT_RT.
> 
> The task_obj has been added for performance reason on non-preemptible
> kernels where preempt_disable() is a NOP. On the PREEMPT_RT preemption
> model preempt_disable() is always implemented. Also there are no memory
> allocations in_irq() context and softirqs are processed in (preemptible)
> process context. Therefore it makes sense to avoid using task_obj.
> 
> Don't use task_obj on PREEMPT_RT and replace manual disabling of
> interrupts with a local_lock_t. This change requires some factoring:
> 
> - drain_obj_stock() drops a reference on obj_cgroup which leads to an
>   invocation of obj_cgroup_release() if it is the last object. This in
>   turn leads to recursive locking of the local_lock_t. To avoid this,
>   obj_cgroup_release() is invoked outside of the locked section.
> 
> - drain_obj_stock() gets a memcg_stock_pcp passed if the stock_lock has been
>   acquired (instead of the task_obj_lock) to avoid recursive locking later
>   in refill_stock().

Looks like this was maybe true in some previous version but now
drain_obj_stock() gets a bool parameter that is passed to
obj_cgroup_uncharge_pages(). But drain_local_stock() uses a NULL or
stock_pcp for that bool parameter which is weird.

> - drain_all_stock() disables preemption via get_cpu() and then invokes
>   drain_local_stock() if it is the local CPU to avoid scheduling a worker
>   (which invokes the same function). Disabling preemption here is
>   problematic due to the sleeping locks in drain_local_stock().
>   This can be avoided by always scheduling a worker, even for the local
>   CPU. Using cpus_read_lock() stabilizes cpu_online_mask which ensures
>   that no worker is scheduled for an offline CPU. Since there is no
>   flush_work(), it is still possible that a worker is invoked on the wrong
>   CPU but it is okay since it operates always on the local-CPU data.
> 
> - drain_local_stock() is always invoked as a worker so it can be optimized
>   by removing in_task() (it is always true) and avoiding the "irq_save"
>   variant because interrupts are always enabled here. Operating on
>   task_obj first allows to acquire the lock_lock_t without lockdep
>   complains.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

The problem is that this pattern where get_obj_stock() sets a
stock_lock_acquried bool and this is passed down and acted upon elsewhere,
is a well known massive red flag for Linus :/
Maybe we should indeed just revert 559271146efc, as Michal noted there were
no hard numbers to justify it, and in previous discussion it seemed to
surface that the costs of irq disable/enable are not that bad on recent cpus
as assumed?

> ---
>  mm/memcontrol.c | 174 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 114 insertions(+), 60 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3d1b7cdd83db0..2d8be88c00888 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -260,8 +260,10 @@ bool mem_cgroup_kmem_disabled(void)
>  	return cgroup_memory_nokmem;
>  }
>  
> +struct memcg_stock_pcp;

Seems this forward declaration is unused.

>  static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
> -				      unsigned int nr_pages);
> +				      unsigned int nr_pages,
> +				      bool stock_lock_acquried);
>  
>  static void obj_cgroup_release(struct percpu_ref *ref)
>  {
