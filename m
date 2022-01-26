From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Wed, 26 Jan 2022 16:20:36 +0100
Message-ID: <YfFmxH1IXeegNOa9@dhcp22.suse.cz>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643210436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MVPJooxS63HNRIlS658e3iRyqgnX+uNa3dzCBUuD74s=;
        b=dDKvAH5+JEZr5MU/CK0fGHdnmiSPWzpIjSHUTtooVpBAbJSbTs3slFzRHp5ut07ZpIEcwQ
        zF2igFDbx9qby+qr9YIXOmKVgpkpxHMxWXTtA8w5Wb+YHzfuaT92huY6eBF+RUTHwkv2eF
        maLGRM+zutuUJqYAXjn6HrYwFNznypg=
Content-Disposition: inline
In-Reply-To: <20220125164337.2071854-4-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue 25-01-22 17:43:36, Sebastian Andrzej Siewior wrote:
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
> 
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

I do not see any obvious problem with this patch. The code is ugly as
hell, though, but a large part of that is because of the weird locking
scheme we already have. I've had a look at 559271146efc ("mm/memcg:
optimize user context object stock access") and while I agree that it
makes sense to optimize for user context I do not really see any numbers
justifying the awkward locking scheme. Is this complexity really worth
it?
-- 
Michal Hocko
SUSE Labs
