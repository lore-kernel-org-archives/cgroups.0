From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 5/9] memcg: replace stats_flush_lock with an atomic
Date: Tue, 28 Mar 2023 14:15:23 +0000
Message-ID: <20230328141523.txyhl7wt7wtvssea@google.com>
References: <20230328061638.203420-1-yosryahmed@google.com> <20230328061638.203420-6-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680012925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjzC1AXnpW8l0xPrPEZPgxXh3c0otg2X0grqn38oTAU=;
        b=Z21Fhu3pxXs+t1qejKjoB06mqPadXXUaJj6uhGgpRk+3gLqlDes+wtSSSWE2knRI8/
         qiF1U6JTQdX1HxRtou/7QeC7ME871T4I2lhXvmsiB9LqWDQkJ4A+0KJwwrxD+tJ4Zz1U
         eS8+YEXBsJWpRHPbqfmOGMvVMX3kHO1M02ByL8p7FWqBJtGrwNge2GxAveCUIe2ZNQ6v
         dvl7/FGZwG59zro3vm/oD7ttk1pXq3InfcSBeQsKHb9wmWZOyOVM20v0sF2M0rosq1uZ
         BvtS7Z8Fw8zE99KoUjs5+fCH5VuwRsaKfmGjaYi/I6cgKnvsxM9ic7CzcXo5qhkkLbxE
         V9bA==
In-Reply-To: <20230328061638.203420-6-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 06:16:34AM +0000, Yosry Ahmed wrote:
[...]
> @@ -585,8 +585,8 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
>   */
>  static void flush_memcg_stats_dwork(struct work_struct *w);
>  static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
> -static DEFINE_SPINLOCK(stats_flush_lock);
>  static DEFINE_PER_CPU(unsigned int, stats_updates);
> +static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
>  static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
>  static u64 flush_next_time;
>  
> @@ -636,15 +636,18 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
>  
>  static void __mem_cgroup_flush_stats(void)
>  {
> -	unsigned long flag;
> -
> -	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
> +	/*
> +	 * We always flush the entire tree, so concurrent flushers can just
> +	 * skip. This avoids a thundering herd problem on the rstat global lock
> +	 * from memcg flushers (e.g. reclaim, refault, etc).
> +	 */
> +	if (atomic_xchg(&stats_flush_ongoing, 1))

Have you profiled this? I wonder if we should replace the above with
	
	if (atomic_read(&stats_flush_ongoing) || atomic_xchg(&stats_flush_ongoing, 1))

to not always dirty the cacheline. This would not be an issue if there
is no cacheline sharing but I suspect percpu stats_updates is sharing
the cacheline with it and may cause false sharing with the parallel stat
updaters (updaters only need to read the base percpu pointer).

Other than that the patch looks good.
