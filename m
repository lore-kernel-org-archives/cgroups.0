From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] mm/page_alloc: detect allocation forbidden by cpuset
 and bail out early
Date: Tue, 14 Sep 2021 17:30:03 -0700 (PDT)
Message-ID: <3bd87d8a-d09e-ac7-1d1d-25ad1b9d5ed9@google.com>
References: <1631590828-25565-1-git-send-email-feng.tang@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=rKPPAqWinMrhwkk8dufmKi/m/ykeo+r7lvr15eegekI=;
        b=W2174p+PqjMxAD9mRnHIDPyb0Hd47zmv7xSvtB0BplA6tW99nXaMcj6zZMFxVYKqr/
         aiWbzUiEnk7Yv0hrWrGe6Iv+pWtGsAhgHWbQUJznuTtE/8voNYohxNO8yD8ldhvedz5+
         X7S7j0KC/4hn3xr7HmGB5e8QTvtfLe4BXudToAyDuruq6R+cFEkf1jZ8jGyKsXEdaPT9
         mo3QPYhGJVCYsYVyh/dFAHL6eb5zq19RzKbCWkcUZKlt2o4UZ+vx2zsfwGGh+NFSIWQF
         CmCwHYqugGqzlhbWTeEwAaZfQ0rNWF4ZoEs9xk2J5qFerGA79vTYmcIW1/Z49zvr+fDH
         CjyQ==
In-Reply-To: <1631590828-25565-1-git-send-email-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 14 Sep 2021, Feng Tang wrote:

> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index d2b9c41..d58e047 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -34,6 +34,8 @@
>   */
>  extern struct static_key_false cpusets_pre_enable_key;
>  extern struct static_key_false cpusets_enabled_key;
> +extern struct static_key_false cpusets_insane_config_key;
> +
>  static inline bool cpusets_enabled(void)
>  {
>  	return static_branch_unlikely(&cpusets_enabled_key);
> @@ -51,6 +53,19 @@ static inline void cpuset_dec(void)
>  	static_branch_dec_cpuslocked(&cpusets_pre_enable_key);
>  }
>  
> +/*
> + * This will get enabled whenever a cpuset configuration is considered
> + * unsupportable in general. E.g. movable only node which cannot satisfy
> + * any non movable allocations (see update_nodemask). Page allocator
> + * needs to make additional checks for those configurations and this
> + * check is meant to guard those checks without any overhead for sane
> + * configurations.
> + */
> +static inline bool cpusets_insane_config(void)
> +{
> +	return static_branch_unlikely(&cpusets_insane_config_key);
> +}
> +
>  extern int cpuset_init(void);
>  extern void cpuset_init_smp(void);
>  extern void cpuset_force_rebuild(void);
> @@ -167,6 +182,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
>  
>  static inline bool cpusets_enabled(void) { return false; }
>  
> +static inline bool cpusets_insane_config(void) { return false; }
> +
>  static inline int cpuset_init(void) { return 0; }
>  static inline void cpuset_init_smp(void) {}
>  
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6a1d79d..a455333 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1220,6 +1220,22 @@ static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
>  #define for_each_zone_zonelist(zone, z, zlist, highidx) \
>  	for_each_zone_zonelist_nodemask(zone, z, zlist, highidx, NULL)
>  
> +/* Whether the 'nodes' are all movable nodes */
> +static inline bool movable_only_nodes(nodemask_t *nodes)
> +{
> +	struct zonelist *zonelist;
> +	struct zoneref *z;
> +
> +	if (nodes_empty(*nodes))
> +		return false;
> +
> +	zonelist =
> +	    &NODE_DATA(first_node(*nodes))->node_zonelists[ZONELIST_FALLBACK];
> +	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
> +	return (!z->zone) ? true : false;
> +}
> +
> +
>  #ifdef CONFIG_SPARSEMEM
>  #include <asm/sparsemem.h>
>  #endif
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index df1ccf4..7fa633e 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -69,6 +69,13 @@
>  DEFINE_STATIC_KEY_FALSE(cpusets_pre_enable_key);
>  DEFINE_STATIC_KEY_FALSE(cpusets_enabled_key);
>  
> +/*
> + * There could be abnormal cpuset configurations for cpu or memory
> + * node binding, add this key to provide a quick low-cost judgement
> + * of the situation.
> + */
> +DEFINE_STATIC_KEY_FALSE(cpusets_insane_config_key);
> +
>  /* See "Frequency meter" comments, below. */
>  
>  struct fmeter {
> @@ -1868,6 +1875,14 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
>  	if (retval < 0)
>  		goto done;
>  
> +	if (!cpusets_insane_config() &&
> +		movable_only_nodes(&trialcs->mems_allowed)) {
> +		static_branch_enable(&cpusets_insane_config_key);
> +		pr_info("Unsupported (movable nodes only) cpuset configuration detected (nmask=%*pbl)! "
> +			"Cpuset allocations might fail even with a lot of memory available.\n",
> +			nodemask_pr_args(&trialcs->mems_allowed));
> +	}
> +
>  	spin_lock_irq(&callback_lock);
>  	cs->mems_allowed = trialcs->mems_allowed;
>  	spin_unlock_irq(&callback_lock);

Is this the only time that the state of the nodemask may change?

I'm wondering about a single node nodemask, for example, where all 
ZONE_NORMAL memory is hot-removed.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b37435c..a7e0854 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4914,6 +4914,19 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (!ac->preferred_zoneref->zone)
>  		goto nopage;
>  
> +	/*
> +	 * Check for insane configurations where the cpuset doesn't contain
> +	 * any suitable zone to satisfy the request - e.g. non-movable
> +	 * GFP_HIGHUSER allocations from MOVABLE nodes only.
> +	 */
> +	if (cpusets_insane_config() && (gfp_mask & __GFP_HARDWALL)) {
> +		struct zoneref *z = first_zones_zonelist(ac->zonelist,
> +					ac->highest_zoneidx,
> +					&cpuset_current_mems_allowed);
> +		if (!z->zone)
> +			goto nopage;
> +	}
> +
>  	if (alloc_flags & ALLOC_KSWAPD)
>  		wake_all_kswapds(order, gfp_mask, ac);
>  
