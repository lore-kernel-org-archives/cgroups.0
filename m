From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] cgroup: rstat: punt root-level optimization to
 individual controllers
Date: Fri, 5 Feb 2021 22:34:39 -0500
Message-ID: <YB4OT61owRaze5/M@mtj.duckdns.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
 <20210205182806.17220-6-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IvmfqIU5DXZ+U45JTS5bf/DzmLeS1efZIG+7GNtTIZs=;
        b=nlB9qdbDK7an1HVmKu1x7dyzmCUf75hspLWyYVdt9HRej55Aa/uBj8j7Cb2YG9ouOE
         SxWkGe4WkVQZw1074K5MKXCyYgpcammBsW6K7BNMyziereI6ca7/R3JRbJIrGdUJMEwb
         imDqwlc50saRmE2N9wzsZrxs1N71E9fWPkAL9Dv98YGbN+o20OZVONYavOKyMkhI7aLo
         7y9dPVA5gOjjSZhzfPwFBRGPkWri2jhw2IPnoij3/jNy68WslT/zBjWOP9V8w0K/R3GP
         tKIRNLnc8y/4HyX3eXOLsfTWjbBmg20T7OaKfnz5fnvpDxCoUzi8p6ensZ9nrSUnSVIL
         h5fg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210205182806.17220-6-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Fri, Feb 05, 2021 at 01:28:03PM -0500, Johannes Weiner wrote:
> Current users of the rstat code can source root-level statistics from
> the native counters of their respective subsystem, allowing them to
> forego aggregation at the root level. This optimization is currently
> implemented inside the generic rstat code, which doesn't track the
> root cgroup and doesn't invoke the subsystem flush callbacks on it.
> 
> However, the memory controller cannot do this optimization, because
> cgroup1 breaks out memory specifically for the local level, including
> at the root level. In preparation for the memory controller switching
> to rstat, move the optimization from rstat core to the controllers.
> 
> Afterwards, rstat will always track the root cgroup for changes and
> invoke the subsystem callbacks on it; and it's up to the subsystem to
> special-case and skip aggregation of the root cgroup if it can source
> this information through other, cheaper means.
> 
> The extra cost of tracking the root cgroup is negligible: on stat
> changes, we actually remove a branch that checks for the root. The
> queueing for a flush touches only per-cpu data, and only the first
> stat change since a flush requires a (per-cpu) lock.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Generally looks good to me.

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

A couple nits below.

> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 02ce2058c14b..76725e1cad7f 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -766,6 +766,10 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>  	struct blkcg *blkcg = css_to_blkcg(css);
>  	struct blkcg_gq *blkg;
>  
> +	/* Root-level stats are sourced from system-wide IO stats */
> +	if (!cgroup_parent(css->cgroup))
> +		return;
> +
>  	rcu_read_lock();
>  
>  	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
> @@ -789,6 +793,7 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>  		u64_stats_update_end(&blkg->iostat.sync);
>  
>  		/* propagate global delta to parent */
> +		/* XXX: could skip this if parent is root */
>  		if (parent) {
>  			u64_stats_update_begin(&parent->iostat.sync);
>  			blkg_iostat_set(&delta, &blkg->iostat.cur);

Might as well update this similar to cgroup_base_stat_flush()?

> @@ -58,8 +53,16 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
>  		if (rstatc->updated_next)
>  			break;
>  
> +		if (!parent) {

Maybe useful to note that the node is being marked busy but not added to the
non-existent parent.

> +			rstatc->updated_next = cgrp;
> +			break;
> +		}
> +
> +		prstatc = cgroup_rstat_cpu(parent, cpu);
>  		rstatc->updated_next = prstatc->updated_children;
>  		prstatc->updated_children = cgrp;
> +
> +		cgrp = parent;
>  	}
>  
>  	raw_spin_unlock_irqrestore(cpu_lock, flags);
...
>  static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
>  {
> -	struct cgroup *parent = cgroup_parent(cgrp);
>  	struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
> +	struct cgroup *parent = cgroup_parent(cgrp);

Is this chunk intentional?

>  	struct cgroup_base_stat cur, delta;
>  	unsigned seq;
>  
> +	/* Root-level stats are sourced from system-wide CPU stats */
> +	if (!parent)
> +		return;
> +
>  	/* fetch the current per-cpu values */
>  	do {
>  		seq = __u64_stats_fetch_begin(&rstatc->bsync);
> @@ -326,8 +336,8 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
>  	cgroup_base_stat_add(&cgrp->bstat, &delta);
>  	cgroup_base_stat_add(&rstatc->last_bstat, &delta);
>  
> -	/* propagate global delta to parent */
> -	if (parent) {
> +	/* propagate global delta to parent (unless that's root) */
> +	if (cgroup_parent(parent)) {

Yeah, this makes sense. Can you add a short while-at-it note in the patch
description?

Thanks.

-- 
tejun
