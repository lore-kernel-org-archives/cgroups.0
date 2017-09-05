From: Roman Gushchin <guro@fb.com>
Subject: Re: [v7 2/5] mm, oom: cgroup-aware OOM killer
Date: Tue, 5 Sep 2017 21:23:57 +0100
Message-ID: <20170905202357.GA10535@castle.DHCP.thefacebook.com>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-3-guro@fb.com>
 <20170905145700.fd7jjd37xf4tb55h@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=8brOgzvrowmbrObEoCPiAHcfPenGOGvsdB2H6A22o/E=;
 b=nTpHiqynr5ObHQKj4EdW7QUZt593AbeDUgG9UiZt6V9ZO80vQIE0+gGAbXlcXzw+bGNj
 V+79eVyg8li5i6qYZLR2VNJvsfYReexwqfQgpOgakhZKEk3DGTzftGbyTpaU/T2tuypU
 QZszrszdivCNF8FBgc3neC7YAyUj/gRLjEs= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8brOgzvrowmbrObEoCPiAHcfPenGOGvsdB2H6A22o/E=;
 b=SVzblwvO6VMeYfV9AH8xV8USAw5h7YPIZhJjBdfMeiUT82ePQGLpBRb/THXc4Hqqfc02RZHYHmu6v1bn5ExntpWom7LYzsKVdw5rwWeG1D/EiwYoyn6IZVvn640U6fh2d7ObihcHIHnycJFK8NE0Noro2rfFY8BLsevmxJrirJ8=
Content-Disposition: inline
In-Reply-To: <20170905145700.fd7jjd37xf4tb55h@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Sep 05, 2017 at 04:57:00PM +0200, Michal Hocko wrote:
> On Mon 04-09-17 15:21:05, Roman Gushchin wrote:
> [...]
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a69d23082abf..97813c56163b 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2649,6 +2649,213 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
> >  	return ret;
> >  }
> >  
> > +static long memcg_oom_badness(struct mem_cgroup *memcg,
> > +			      const nodemask_t *nodemask)
> > +{
> > +	long points = 0;
> > +	int nid;
> > +	pg_data_t *pgdat;
> > +
> > +	for_each_node_state(nid, N_MEMORY) {
> > +		if (nodemask && !node_isset(nid, *nodemask))
> > +			continue;
> > +
> > +		points += mem_cgroup_node_nr_lru_pages(memcg, nid,
> > +				LRU_ALL_ANON | BIT(LRU_UNEVICTABLE));
> 
> Why don't you consider file LRUs here? What if there is a lot of page
> cache which is not reclaimed because it is protected by memcg->low.
> Should we hide that from the OOM killer?

I'm not sure here.
I agree with your argument, although memcg->low should not cause OOMs
in the current implementation (which is a separate problem).
Also I can imagine some edge cases with mlocked pagecache belonging
to a process from a different cgroup.

I would suggest to refine this later.

> 
> [...]
> > +static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
> > +{
> > +	struct mem_cgroup *iter, *parent;
> > +
> > +	for_each_mem_cgroup_tree(iter, root) {
> > +		if (memcg_has_children(iter)) {
> > +			iter->oom_score = 0;
> > +			continue;
> > +		}
> 
> Do we really need this check? If it is a mere optimization then
> we should probably check for tasks in the memcg rather than
> descendant. More on that below.

The idea is to traverse memcg only once: we're resetting oom_score
for non-leaf cgroups, and for each leaf cgroup calculate the score
and propagate it upwards.

> 
> > +
> > +		iter->oom_score = oom_evaluate_memcg(iter, oc->nodemask);
> > +
> > +		/*
> > +		 * Ignore empty and non-eligible memory cgroups.
> > +		 */
> > +		if (iter->oom_score == 0)
> > +			continue;
> > +
> > +		/*
> > +		 * If there are inflight OOM victims, we don't need to look
> > +		 * further for new victims.
> > +		 */
> > +		if (iter->oom_score == -1) {
> > +			oc->chosen_memcg = INFLIGHT_VICTIM;
> > +			mem_cgroup_iter_break(root, iter);
> > +			return;
> > +		}
> > +
> > +		for (parent = parent_mem_cgroup(iter); parent && parent != root;
> > +		     parent = parent_mem_cgroup(parent))
> > +			parent->oom_score += iter->oom_score;
> 
> Hmm. The changelog says "By default, it will look for the biggest leaf
> cgroup, and kill the largest task inside." But you are accumulating
> oom_score up the hierarchy and so parents will have higher score than
> the layer of their children and the larger the sub-hierarchy the more
> biased it will become. Say you have
> 	root
>          /\
>         /  \
>        A    D
>       / \
>      B   C
> 
> B (5), C(15) thus A(20) and D(20). Unless I am missing something we are
> going to go down A path and then chose C even though D is the largest
> leaf group, right?

You're right, changelog is not accurate, I'll fix it.
The behavior is correct, IMO.

> 
> > +	}
> > +
> > +	for (;;) {
> > +		struct cgroup_subsys_state *css;
> > +		struct mem_cgroup *memcg = NULL;
> > +		long score = LONG_MIN;
> > +
> > +		css_for_each_child(css, &root->css) {
> > +			struct mem_cgroup *iter = mem_cgroup_from_css(css);
> > +
> > +			/*
> > +			 * Ignore empty and non-eligible memory cgroups.
> > +			 */
> > +			if (iter->oom_score == 0)
> > +				continue;
> > +
> > +			if (iter->oom_score > score) {
> > +				memcg = iter;
> > +				score = iter->oom_score;
> > +			}
> > +		}
> > +
> > +		if (!memcg) {
> > +			if (oc->memcg && root == oc->memcg) {
> > +				oc->chosen_memcg = oc->memcg;
> > +				css_get(&oc->chosen_memcg->css);
> > +				oc->chosen_points = oc->memcg->oom_score;
> > +			}
> > +			break;
> > +		}
> > +
> > +		if (memcg->oom_group || !memcg_has_children(memcg)) {
> > +			oc->chosen_memcg = memcg;
> > +			css_get(&oc->chosen_memcg->css);
> > +			oc->chosen_points = score;
> > +			break;
> > +		}
> > +
> > +		root = memcg;
> > +	}
> > +}
> > +
> [...]
> > +	/*
> > +	 * For system-wide OOMs we should consider tasks in the root cgroup
> > +	 * with oom_score larger than oc->chosen_points.
> > +	 */
> > +	if (!oc->memcg) {
> > +		select_victim_root_cgroup_task(oc);
> 
> I do not understand why do we have to handle root cgroup specially here.
> select_victim_memcg already iterates all memcgs in the oom hierarchy
> (including root) so if the root memcg is the largest one then we
> should simply consider it no?

We don't have necessary stats for the root cgroup, so we can't calculate
it's oom_score.

> You are skipping root there because of
> memcg_has_children but I suspect this and the whole accumulate up the
> hierarchy approach just makes the whole thing more complex than necessary. With
> "tasks only in leafs" cgroup policy we should only see any pages on LRUs
> on the global root memcg and leaf cgroups. The same applies to memcg
> stats. So why cannot we simply do the tree walk, calculate
> badness/check the priority and select the largest memcg in one go?

We have to traverse from top to bottom to make priority-based decision,
but size-based oom_score is calculated as sum of descending leaf cgroup scores.

For example:
 	root
          /\
         /  \
        A    D
       / \
      B   C
A and D have same priorities, B has larger priority than C.

In this case we need to calculate size-based score for A, which requires
summing oom_score of the sub-tree (B an C), despite we don't need it
for choosing between B and C.

Maybe I don't see it, but I don't know how to implement it more optimal.

> 
> > @@ -810,6 +810,9 @@ static void __oom_kill_process(struct task_struct *victim)
> >  	struct mm_struct *mm;
> >  	bool can_oom_reap = true;
> >  
> > +	if (is_global_init(victim) || (victim->flags & PF_KTHREAD))
> > +		return;
> > +
> 
> This will leak a reference to the victim AFACS

Good catch!
I didn't fix this after moving reference dropping into __oom_kill_process().
Fixed.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
