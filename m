From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 6/6] mm/memcg: Disable migration instead of preemption
 in drain_all_stock().
Date: Tue, 22 Feb 2022 10:56:41 +0100
Message-ID: <YhSzWXyPe14vOaGa@dhcp22.suse.cz>
References: <20220221182540.380526-1-bigeasy@linutronix.de>
 <20220221182540.380526-7-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645523802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VGiep3feZi3i71q2uR3AtjKvdwdXMRiWG5Ve1qZIums=;
        b=HH/AA24vtus8H7QzqmXfaHlpyMoTTdIz4y7K1qhVbmoA0oHm70LgWbqT7UD5GdFkWF18uu
        6PWMKoEWPeLobCcxBRmt/+cxE91ngjt3PJR1FWOxIrecN5iuOvg8hafX5lil//rLNxm2tF
        DM5K8wHHX7YrlQpH9ouqeYgQBo/Jx/4=
Content-Disposition: inline
In-Reply-To: <20220221182540.380526-7-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon 21-02-22 19:25:40, Sebastian Andrzej Siewior wrote:
> Before the for-each-CPU loop, preemption is disabled so that so that
> drain_local_stock() can be invoked directly instead of scheduling a
> worker. Ensuring that drain_local_stock() completed on the local CPU is
> not correctness problem. It _could_ be that the charging path will be
> forced to reclaim memory because cached charges are still waiting for
> their draining.
> 
> Disabling preemption before invoking drain_local_stock() is problematic
> on PREEMPT_RT due to the sleeping locks involved. To ensure that no CPU
> migrations happens across the for_each_online_cpu() it is enouhg to use
> migrate_disable() which disables migration and keeps context preemptible
> to a sleeping lock can be acquired.

I would just add that a race with cpu hotplug is not a problem because
pcp data is not going away. In the worst case we just schedule draining
of an empty stock.
> 
> Use migrate_disable() instead of get_cpu() around the
> for_each_online_cpu() loop.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3d7ccb104374c..9c29b1a0e6bec 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2293,7 +2293,8 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
>  	 * as well as workers from this path always operate on the local
>  	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
>  	 */
> -	curcpu = get_cpu();
> +	migrate_disable();
> +	curcpu = smp_processor_id();
>  	for_each_online_cpu(cpu) {
>  		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
>  		struct mem_cgroup *memcg;
> @@ -2316,7 +2317,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
>  				schedule_work_on(cpu, &stock->work);
>  		}
>  	}
> -	put_cpu();
> +	migrate_enable();
>  	mutex_unlock(&percpu_charge_mutex);
>  }
>  
> -- 
> 2.35.1

-- 
Michal Hocko
SUSE Labs
