From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 5/8] mm/memcontrol: Replace the PREEMPT_RT conditionals
Date: Thu, 1 Sep 2022 16:45:58 +0200
Message-ID: <YxDFplJXPudU4AS7@dhcp22.suse.cz>
References: <20220825164131.402717-1-bigeasy@linutronix.de>
 <20220825164131.402717-6-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662043559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d7JBI/07yd8WyaO8RcKiT0B2kXWtniRx5v9bl5XBNpQ=;
        b=GS1zPTgzUE7SA44v31qD+AF4XlSoLr11tpr0vjqCs+efGkDBBFb84tSlbKYIVFvq+9Bbxg
        1gChdqfyylgk0jM/3/KNCh57buu3X/Asiq54vFxcf6MyZrYILVJzzn+0uFG07K6PhaUaoX
        3+RP+L1VtsfNVpeMC7kf8MDnB3x4wgU=
Content-Disposition: inline
In-Reply-To: <20220825164131.402717-6-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 25-08-22 18:41:28, Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> 
> Use VM_WARN_ON_IRQS_ENABLED() and preempt_disable/enable_nested() to
> replace the CONFIG_PREEMPT_RT #ifdeffery.
> 
> Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Thanks!

> ---
>  mm/memcontrol.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b69979c9ced5c..d35b6fa560f0a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -597,25 +597,18 @@ static u64 flush_next_time;
>   */
>  static void memcg_stats_lock(void)
>  {
> -#ifdef CONFIG_PREEMPT_RT
> -      preempt_disable();
> -#else
> -      VM_BUG_ON(!irqs_disabled());
> -#endif
> +	preempt_disable_nested();
> +	VM_WARN_ON_IRQS_ENABLED();
>  }
>  
>  static void __memcg_stats_lock(void)
>  {
> -#ifdef CONFIG_PREEMPT_RT
> -      preempt_disable();
> -#endif
> +	preempt_disable_nested();
>  }
>  
>  static void memcg_stats_unlock(void)
>  {
> -#ifdef CONFIG_PREEMPT_RT
> -      preempt_enable();
> -#endif
> +	preempt_enable_nested();
>  }
>  
>  static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
> @@ -715,7 +708,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  	 * interrupt context while other caller need to have disabled interrupt.
>  	 */
>  	__memcg_stats_lock();
> -	if (IS_ENABLED(CONFIG_DEBUG_VM) && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
> +	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
>  		switch (idx) {
>  		case NR_ANON_MAPPED:
>  		case NR_FILE_MAPPED:
> @@ -725,7 +718,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  			WARN_ON_ONCE(!in_task());
>  			break;
>  		default:
> -			WARN_ON_ONCE(!irqs_disabled());
> +			VM_WARN_ON_IRQS_ENABLED();
>  		}
>  	}
>  
> -- 
> 2.37.2

-- 
Michal Hocko
SUSE Labs
