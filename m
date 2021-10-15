From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 1/2] memcg: flush stats only if updated
Date: Fri, 15 Oct 2021 19:55:31 +0200
Message-ID: <20211015175531.GB46263@blackbody.suse.cz>
References: <20211013180130.GB22036@blackbody.suse.cz>
 <20211014163146.2177266-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634320533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4jBn2VNfaCZDHefss5Z1r9mqIdP3xRVwotwlK+Rm7xY=;
        b=n1K8M3Dt3d5TeTHwFKotWO6NgpCUxVj9yloDRCzY2ACk+N04k0IsJk9kqYAIr5CkXCtahO
        nlU9a0EBiwuhBPySCxctmkoH2iaJWzcfoYspQAfFg6jbjBTLBTW345dDdKwJR+lFFJ2ZBN
        k3qq64TE8yeQUYARubZvGlGdIcnGP1c=
Content-Disposition: inline
In-Reply-To: <20211014163146.2177266-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Thu, Oct 14, 2021 at 09:31:46AM -0700, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Thanks for your review. This forces me to think more on this because each
> update does not necessarily be a single page sized update e.g. adding a hugepage
> to an LRU.

Aha, hugepages... (I also noticed that on the opposite size scale are
NR_SLAB_{UN,}RECLAIMABLE_B, the complementary problem to too big error
would be too frequent flushes.)

> Though I think the error is time bounded by 2 seconds but in those 2 seconds
> mathematically the error can be large.

Honestly, I can't tell how much the (transient) errors in various
node_stat_item entries will or won't affect MM behavior. But having some
guards on it sounds practical when some problems to troubleshoot arise.

> What do you think of the following change? It will bound the error
> better within the 2 seconds window.
> [...]
> -static inline void memcg_rstat_updated(struct mem_cgroup *memcg)
> +static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
>  {
> +	unsigned int x;
> +
>  	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
> -	if (!(__this_cpu_inc_return(stats_updates) % MEMCG_CHARGE_BATCH))
> -		atomic_inc(&stats_flush_threshold);
> +
> +	x = abs(__this_cpu_add_return(stats_diff, val));
> +	if (x > MEMCG_CHARGE_BATCH) {
> +		atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
> +		__this_cpu_write(stats_diff, 0);
> +	}
>  }

Looks better wrt meaningful error calculation (and hopefully still
doesn't add too much to the hot path).

> @@ -807,7 +813,7 @@ void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
>  		return;
>  
>  	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
> -	memcg_rstat_updated(memcg);
> +	memcg_rstat_updated(memcg, val);

s/val/count/

(Just thinking loudly.) At one moment I thought, it could
effectively be even s/val/0/ since events aren't(?) inputs for reclaim
calculations. But with the introduced stats_diff it may happen
stats_diff flickers (its abs value) within the MEMCG_CHARGE_BATCH and
stats_flush_threshold would never be incremented. Basically disabling
the periodic flush. Therefore the events must also increment the
stats_diff.

