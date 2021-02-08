From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 5/8] cgroup: rstat: punt root-level optimization to
 individual controllers
Date: Mon, 8 Feb 2021 15:29:21 -0500
Message-ID: <YCGfIYTLzcTO+ng8@cmpxchg.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
 <20210205182806.17220-6-hannes@cmpxchg.org>
 <YB4OT61owRaze5/M@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+W+MLaT/TXNsbaKxVAInWpHHDZc9eH9AzV5HpOZtk1o=;
        b=apHJgSOvhe5ZskHK3zxdt0o5vOX1K/DnUVvo1YFy+TT6/qeKrazZ/tuagXJHv9sjnj
         Au1UjaBP+G0hqohnHtm7s5g5Tu/725HxS4SN09uwAPWTk+XYmR09wakqnLKcrm6sUIBB
         tk5yftslC7tLC2PSiqiBqfkyQHbVNYykfNGNhOHdhHKa6kDEeSujOAJl28U3n7MW6fNF
         UzJoS8NWwIqCrVAeUjp2h66GuqBDpL49bOTzGsZq2IIZlE0OTGFl+v7UN82sm9ycAmUd
         PGwdZLEER7S9hg6uE1d45GB00ML82m+mbaWWj4gXv2ArgSx+739lbaYxR2CVGiOAhCrT
         J4Mw==
Content-Disposition: inline
In-Reply-To: <YB4OT61owRaze5/M@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Feb 05, 2021 at 10:34:39PM -0500, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 05, 2021 at 01:28:03PM -0500, Johannes Weiner wrote:
> > Current users of the rstat code can source root-level statistics from
> > the native counters of their respective subsystem, allowing them to
> > forego aggregation at the root level. This optimization is currently
> > implemented inside the generic rstat code, which doesn't track the
> > root cgroup and doesn't invoke the subsystem flush callbacks on it.
> > 
> > However, the memory controller cannot do this optimization, because
> > cgroup1 breaks out memory specifically for the local level, including
> > at the root level. In preparation for the memory controller switching
> > to rstat, move the optimization from rstat core to the controllers.
> > 
> > Afterwards, rstat will always track the root cgroup for changes and
> > invoke the subsystem callbacks on it; and it's up to the subsystem to
> > special-case and skip aggregation of the root cgroup if it can source
> > this information through other, cheaper means.
> > 
> > The extra cost of tracking the root cgroup is negligible: on stat
> > changes, we actually remove a branch that checks for the root. The
> > queueing for a flush touches only per-cpu data, and only the first
> > stat change since a flush requires a (per-cpu) lock.
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Generally looks good to me.
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks!

> A couple nits below.
> 
> > diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> > index 02ce2058c14b..76725e1cad7f 100644
> > --- a/block/blk-cgroup.c
> > +++ b/block/blk-cgroup.c
> > @@ -766,6 +766,10 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
> >  	struct blkcg *blkcg = css_to_blkcg(css);
> >  	struct blkcg_gq *blkg;
> >  
> > +	/* Root-level stats are sourced from system-wide IO stats */
> > +	if (!cgroup_parent(css->cgroup))
> > +		return;
> > +
> >  	rcu_read_lock();
> >  
> >  	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
> > @@ -789,6 +793,7 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
> >  		u64_stats_update_end(&blkg->iostat.sync);
> >  
> >  		/* propagate global delta to parent */
> > +		/* XXX: could skip this if parent is root */
> >  		if (parent) {
> >  			u64_stats_update_begin(&parent->iostat.sync);
> >  			blkg_iostat_set(&delta, &blkg->iostat.cur);
> 
> Might as well update this similar to cgroup_base_stat_flush()?

I meant to revisit that, but I'm never 100% confident when it comes to
the interaction and lifetime of css, blkcg and blkg_gq.

IIUC, the blkg_gq->parent linkage always matches the css parent
linkage; it just exists as an optimization for ancestor walks, which
would otherwise have to do radix lookups when going through the css.

So with the cgroup_parent() check at the beginning of the function
making sure we're looking at a non-root group, blkg_gq->parent should
also never be NULL and I can do if (paren->parent) directly, right?

> > @@ -58,8 +53,16 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
> >  		if (rstatc->updated_next)
> >  			break;
> >  
> > +		if (!parent) {
> 
> Maybe useful to note that the node is being marked busy but not added to the
> non-existent parent.

Makes sense, I'll add a comment.

> > +			rstatc->updated_next = cgrp;
> > +			break;
> > +		}
> > +
> > +		prstatc = cgroup_rstat_cpu(parent, cpu);
> >  		rstatc->updated_next = prstatc->updated_children;
> >  		prstatc->updated_children = cgrp;
> > +
> > +		cgrp = parent;
> >  	}
> >  
> >  	raw_spin_unlock_irqrestore(cpu_lock, flags);
> ...
> >  static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
> >  {
> > -	struct cgroup *parent = cgroup_parent(cgrp);
> >  	struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
> > +	struct cgroup *parent = cgroup_parent(cgrp);
> 
> Is this chunk intentional?

Yeah, it puts the local variable declarations into reverse christmas
tree ordering to make them a bit easier to read. It's a while-at-it
cleanup, mostly a force of habit. I can drop it if it bothers you.

> >  	struct cgroup_base_stat cur, delta;
> >  	unsigned seq;
> >  
> > +	/* Root-level stats are sourced from system-wide CPU stats */
> > +	if (!parent)
> > +		return;
> > +
> >  	/* fetch the current per-cpu values */
> >  	do {
> >  		seq = __u64_stats_fetch_begin(&rstatc->bsync);
> > @@ -326,8 +336,8 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
> >  	cgroup_base_stat_add(&cgrp->bstat, &delta);
> >  	cgroup_base_stat_add(&rstatc->last_bstat, &delta);
> >  
> > -	/* propagate global delta to parent */
> > -	if (parent) {
> > +	/* propagate global delta to parent (unless that's root) */
> > +	if (cgroup_parent(parent)) {
> 
> Yeah, this makes sense. Can you add a short while-at-it note in the patch
> description?

Will do.

Thanks for the review!
