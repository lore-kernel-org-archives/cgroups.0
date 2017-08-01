From: Roman Gushchin <guro@fb.com>
Subject: Re: [v4 2/4] mm, oom: cgroup-aware OOM killer
Date: Tue, 1 Aug 2017 16:25:48 +0100
Message-ID: <20170801152548.GA29502@castle.dhcp.TheFacebook.com>
References: <20170726132718.14806-1-guro@fb.com>
 <20170726132718.14806-3-guro@fb.com>
 <20170801145435.GN15774@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Dq06hVvTItjQShH8ln/7V5W+bkSUK7eADeG/pbWqCUM=;
 b=AwaZmLECCdpKultKzKXrzlBC5z/dL/EFidL2WJMJ7wR+he3MuokcIhkeWyXMGD3jbSKr
 0RV4vRoSrI2KDZfnXcS+nvdkfpeZsXVQ03U3Fvl5FhAvQjf6vXiVN27SYpzobuuRC+AM
 HRIh0l2jqzPmIziOWTj+ogJZBxYY7XY2Wlc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Dq06hVvTItjQShH8ln/7V5W+bkSUK7eADeG/pbWqCUM=;
 b=duxT6Ylgin4XPXm8sfyMw/Hn3lQEmi5f/JT0laZpfu7Xo1Ozzb9DV4uzH/Le8pL18e8EHPVxJas1c5Q2bDhCyI9BCPY2/WUH4/eZHnj4yVMF1wldxhbO/NImD+OhW3OTFbQ/PHiaum7VKcIHrCIoFHsZ54geWdJPmHK23hqUfRQ=
Content-Disposition: inline
In-Reply-To: <20170801145435.GN15774@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 01, 2017 at 04:54:35PM +0200, Michal Hocko wrote:
> On Wed 26-07-17 14:27:16, Roman Gushchin wrote:
> [...]
> > +static long memcg_oom_badness(struct mem_cgroup *memcg,
> > +			      const nodemask_t *nodemask)
> > +{
> > +	long points = 0;
> > +	int nid;
> > +
> > +	for_each_node_state(nid, N_MEMORY) {
> > +		if (nodemask && !node_isset(nid, *nodemask))
> > +			continue;
> > +
> > +		points += mem_cgroup_node_nr_lru_pages(memcg, nid,
> > +				LRU_ALL_ANON | BIT(LRU_UNEVICTABLE));
> > +	}
> > +
> > +	points += memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) /
> > +		(PAGE_SIZE / 1024);
> > +	points += memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE);
> > +	points += memcg_page_state(memcg, MEMCG_SOCK);
> > +	points += memcg_page_state(memcg, MEMCG_SWAP);
> > +
> > +	return points;
> 
> I am wondering why are you diverging from the global oom_badness
> behavior here. Although doing per NUMA accounting sounds like a better
> idea but then you just end up mixing this with non NUMA numbers and the
> whole thing is harder to understand without great advantages.

Ok, makes sense. I can revert to the existing OOM behaviour here.

> > +static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
> > +{
> > +	struct mem_cgroup *iter, *parent;
> > +
> > +	for_each_mem_cgroup_tree(iter, root) {
> > +		if (memcg_has_children(iter)) {
> > +			iter->oom_score = 0;
> > +			continue;
> > +		}
> > +
> > +		iter->oom_score = oom_evaluate_memcg(iter, oc->nodemask);
> > +		if (iter->oom_score == -1) {
> > +			oc->chosen_memcg = (void *)-1UL;
> > +			mem_cgroup_iter_break(root, iter);
> > +			return;
> > +		}
> > +
> > +		if (!iter->oom_score)
> > +			continue;
> > +
> > +		for (parent = parent_mem_cgroup(iter); parent && parent != root;
> > +		     parent = parent_mem_cgroup(parent))
> > +			parent->oom_score += iter->oom_score;
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
> > +		if (memcg->oom_kill_all_tasks || !memcg_has_children(memcg)) {
> > +			oc->chosen_memcg = memcg;
> > +			css_get(&oc->chosen_memcg->css);
> > +			oc->chosen_points = score;
> > +			break;
> > +		}
> > +
> > +		root = memcg;
> > +	}
> > +}
> 
> This and the rest of the victim selection code is really hairy and hard
> to follow.

Will adding more comments help here?

> 
> I would reap out the oom_kill_process into a separate patch.

It was a separate patch, I've merged it based on Vladimir's feedback.
No problems, I can divide it back.

> > -static void oom_kill_process(struct oom_control *oc, const char *message)
> > +static void __oom_kill_process(struct task_struct *victim)
> 
> To the rest of the patch. I have to say I do not quite like how it is
> implemented. I was hoping for something much simpler which would hook
> into oom_evaluate_task. If a task belongs to a memcg with kill-all flag
> then we would update the cumulative memcg badness (more specifically the
> badness of the topmost parent with kill-all flag). Memcg will then
> compete with existing self contained tasks (oom_badness will have to
> tell whether points belong to a task or a memcg to allow the caller to
> deal with it). But it shouldn't be much more complex than that.

I'm not sure, it will be any simpler. Basically I'm doing the same:
the difference is that you want to iterate over tasks and for each
task traverse the memcg tree, update per-cgroup oom score and find
the corresponding memcg(s) with the kill-all flag. I'm doing the opposite:
traverse the cgroup tree, and for each leaf cgroup iterate over processes.

Also, please note, that even without the kill-all flag the decision is made
on per-cgroup level (except tasks in the root cgroup).

Thank you!

Roman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
