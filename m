From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH 01/14] cgroup: remove css_parent()
Date: Sun, 11 May 2014 09:02:08 -0400
Message-ID: <20140511130208.GA13495@hmsreliant.think-freely.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1399671091-23867-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

On Fri, May 09, 2014 at 05:31:18PM -0400, Tejun Heo wrote:
> cgroup in general is moving towards using cgroup_subsys_state as the
> fundamental structural component and css_parent() was introduced to
> convert from using cgroup->parent to css->parent.  It was quite some
> time ago and we're moving forward with making css more prominent.
> 
> This patch drops the trivial wrapper css_parent() and let the users
> dereference css->parent.  While at it, explicitly mark fields of css
> which are public and immutable.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
> Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> ---
>  block/blk-cgroup.h           |  2 +-
>  include/linux/cgroup.h       | 29 +++++++++++------------------
>  kernel/cgroup.c              |  8 ++++----
>  kernel/cgroup_freezer.c      |  2 +-
>  kernel/cpuset.c              |  2 +-
>  kernel/sched/core.c          |  2 +-
>  kernel/sched/cpuacct.c       |  2 +-
>  mm/hugetlb_cgroup.c          |  2 +-
>  mm/memcontrol.c              | 14 +++++++-------
>  net/core/netclassid_cgroup.c |  2 +-
>  net/core/netprio_cgroup.c    |  2 +-
>  security/device_cgroup.c     |  6 +++---
>  12 files changed, 33 insertions(+), 40 deletions(-)
> 
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 371fe8e..d692b29 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -204,7 +204,7 @@ static inline struct blkcg *bio_blkcg(struct bio *bio)
>   */
>  static inline struct blkcg *blkcg_parent(struct blkcg *blkcg)
>  {
> -	return css_to_blkcg(css_parent(&blkcg->css));
> +	return css_to_blkcg(blkcg->css.parent);
>  }
>  
>  /**
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 76dadd77..88c4d03 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -48,22 +48,28 @@ enum cgroup_subsys_id {
>  };
>  #undef SUBSYS
>  
> -/* Per-subsystem/per-cgroup state maintained by the system. */
> +/*
> + * Per-subsystem/per-cgroup state maintained by the system.  This is the
> + * fundamental structural building block that controllers deal with.
> + *
> + * Fields marked with "PI:" are public and immutable and may be accessed
> + * directly without synchronization.
> + */
>  struct cgroup_subsys_state {
> -	/* the cgroup that this css is attached to */
> +	/* PI: the cgroup that this css is attached to */
>  	struct cgroup *cgroup;
>  
> -	/* the cgroup subsystem that this css is attached to */
> +	/* PI: the cgroup subsystem that this css is attached to */
>  	struct cgroup_subsys *ss;
>  
>  	/* reference count - access via css_[try]get() and css_put() */
>  	struct percpu_ref refcnt;
>  
> -	/* the parent css */
> +	/* PI: the parent css */
>  	struct cgroup_subsys_state *parent;
>  
>  	/*
> -	 * Subsys-unique ID.  0 is unused and root is always 1.  The
> +	 * PI: Subsys-unique ID.  0 is unused and root is always 1.  The
>  	 * matching css can be looked up using css_from_id().
>  	 */
>  	int id;
> @@ -665,19 +671,6 @@ struct cgroup_subsys {
>  #undef SUBSYS
>  
>  /**
> - * css_parent - find the parent css
> - * @css: the target cgroup_subsys_state
> - *
> - * Return the parent css of @css.  This function is guaranteed to return
> - * non-NULL parent as long as @css isn't the root.
> - */
> -static inline
> -struct cgroup_subsys_state *css_parent(struct cgroup_subsys_state *css)
> -{
> -	return css->parent;
> -}
> -
> -/**
>   * task_css_set_check - obtain a task's css_set with extra access conditions
>   * @task: the task to obtain css_set for
>   * @__c: extra condition expression to be passed to rcu_dereference_check()
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 64ff413..dab8f35 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3175,10 +3175,10 @@ css_next_descendant_pre(struct cgroup_subsys_state *pos,
>  
>  	/* no child, visit my or the closest ancestor's next sibling */
>  	while (pos != root) {
> -		next = css_next_child(pos, css_parent(pos));
> +		next = css_next_child(pos, pos->parent);
>  		if (next)
>  			return next;
> -		pos = css_parent(pos);
> +		pos = pos->parent;
>  	}
>  
>  	return NULL;
> @@ -3260,12 +3260,12 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
>  		return NULL;
>  
>  	/* if there's an unvisited sibling, visit its leftmost descendant */
> -	next = css_next_child(pos, css_parent(pos));
> +	next = css_next_child(pos, pos->parent);
>  	if (next)
>  		return css_leftmost_descendant(next);
>  
>  	/* no sibling left, visit parent */
> -	return css_parent(pos);
> +	return pos->parent;
>  }
>  
>  static bool cgroup_has_live_children(struct cgroup *cgrp)
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index f52c443..fee1ae63 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -59,7 +59,7 @@ static inline struct freezer *task_freezer(struct task_struct *task)
>  
>  static struct freezer *parent_freezer(struct freezer *freezer)
>  {
> -	return css_freezer(css_parent(&freezer->css));
> +	return css_freezer(freezer->css.parent);
>  }
>  
>  bool cgroup_freezing(struct task_struct *task)
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 2f4b08b..5b2a310 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -124,7 +124,7 @@ static inline struct cpuset *task_cs(struct task_struct *task)
>  
>  static inline struct cpuset *parent_cs(struct cpuset *cs)
>  {
> -	return css_cs(css_parent(&cs->css));
> +	return css_cs(cs->css.parent);
>  }
>  
>  #ifdef CONFIG_NUMA
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45e..ac61ad1 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7586,7 +7586,7 @@ cpu_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  static int cpu_cgroup_css_online(struct cgroup_subsys_state *css)
>  {
>  	struct task_group *tg = css_tg(css);
> -	struct task_group *parent = css_tg(css_parent(css));
> +	struct task_group *parent = css_tg(css->parent);
>  
>  	if (parent)
>  		sched_online_group(tg, parent);
> diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
> index c143ee3..9cf350c 100644
> --- a/kernel/sched/cpuacct.c
> +++ b/kernel/sched/cpuacct.c
> @@ -46,7 +46,7 @@ static inline struct cpuacct *task_ca(struct task_struct *tsk)
>  
>  static inline struct cpuacct *parent_ca(struct cpuacct *ca)
>  {
> -	return css_ca(css_parent(&ca->css));
> +	return css_ca(ca->css.parent);
>  }
>  
>  static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index a380681..493f758 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -52,7 +52,7 @@ static inline bool hugetlb_cgroup_is_root(struct hugetlb_cgroup *h_cg)
>  static inline struct hugetlb_cgroup *
>  parent_hugetlb_cgroup(struct hugetlb_cgroup *h_cg)
>  {
> -	return hugetlb_cgroup_from_css(css_parent(&h_cg->css));
> +	return hugetlb_cgroup_from_css(h_cg->css.parent);
>  }
>  
>  static inline bool hugetlb_cgroup_have_usage(struct hugetlb_cgroup *h_cg)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b638a79..a5e0417 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1540,7 +1540,7 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
>  int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>  {
>  	/* root ? */
> -	if (!css_parent(&memcg->css))
> +	if (!memcg->css.parent)
>  		return vm_swappiness;
>  
>  	return memcg->swappiness;
> @@ -4909,7 +4909,7 @@ static int mem_cgroup_hierarchy_write(struct cgroup_subsys_state *css,
>  {
>  	int retval = 0;
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> -	struct mem_cgroup *parent_memcg = mem_cgroup_from_css(css_parent(&memcg->css));
> +	struct mem_cgroup *parent_memcg = mem_cgroup_from_css(memcg->css.parent);
>  
>  	mutex_lock(&memcg_create_mutex);
>  
> @@ -5207,8 +5207,8 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
>  	if (!memcg->use_hierarchy)
>  		goto out;
>  
> -	while (css_parent(&memcg->css)) {
> -		memcg = mem_cgroup_from_css(css_parent(&memcg->css));
> +	while (memcg->css.parent) {
> +		memcg = mem_cgroup_from_css(memcg->css.parent);
>  		if (!memcg->use_hierarchy)
>  			break;
>  		tmp = res_counter_read_u64(&memcg->res, RES_LIMIT);
> @@ -5443,7 +5443,7 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
>  				       struct cftype *cft, u64 val)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> -	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
> +	struct mem_cgroup *parent = mem_cgroup_from_css(memcg->css.parent);
>  
>  	if (val > 100 || !parent)
>  		return -EINVAL;
> @@ -5790,7 +5790,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
>  	struct cftype *cft, u64 val)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> -	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
> +	struct mem_cgroup *parent = mem_cgroup_from_css(memcg->css.parent);
>  
>  	/* cannot set to root cgroup and only 0 and 1 are allowed */
>  	if (!parent || !((val == 0) || (val == 1)))
> @@ -6407,7 +6407,7 @@ static int
>  mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> -	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(css));
> +	struct mem_cgroup *parent = mem_cgroup_from_css(css->parent);
>  
>  	if (css->id > MEM_CGROUP_ID_MAX)
>  		return -ENOSPC;
> diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
> index 22931e1..30d903b 100644
> --- a/net/core/netclassid_cgroup.c
> +++ b/net/core/netclassid_cgroup.c
> @@ -42,7 +42,7 @@ cgrp_css_alloc(struct cgroup_subsys_state *parent_css)
>  static int cgrp_css_online(struct cgroup_subsys_state *css)
>  {
>  	struct cgroup_cls_state *cs = css_cls_state(css);
> -	struct cgroup_cls_state *parent = css_cls_state(css_parent(css));
> +	struct cgroup_cls_state *parent = css_cls_state(css->parent);
>  
>  	if (parent)
>  		cs->classid = parent->classid;
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index b990cef..2f385b9 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -140,7 +140,7 @@ cgrp_css_alloc(struct cgroup_subsys_state *parent_css)
>  
>  static int cgrp_css_online(struct cgroup_subsys_state *css)
>  {
> -	struct cgroup_subsys_state *parent_css = css_parent(css);
> +	struct cgroup_subsys_state *parent_css = css->parent;
>  	struct net_device *dev;
>  	int ret = 0;
>  
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 82d6b4f..3116015 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -182,7 +182,7 @@ static inline bool is_devcg_online(const struct dev_cgroup *devcg)
>  static int devcgroup_online(struct cgroup_subsys_state *css)
>  {
>  	struct dev_cgroup *dev_cgroup = css_to_devcgroup(css);
> -	struct dev_cgroup *parent_dev_cgroup = css_to_devcgroup(css_parent(css));
> +	struct dev_cgroup *parent_dev_cgroup = css_to_devcgroup(css->parent);
>  	int ret = 0;
>  
>  	mutex_lock(&devcgroup_mutex);
> @@ -374,7 +374,7 @@ static bool may_access(struct dev_cgroup *dev_cgroup,
>  static int parent_has_perm(struct dev_cgroup *childcg,
>  				  struct dev_exception_item *ex)
>  {
> -	struct dev_cgroup *parent = css_to_devcgroup(css_parent(&childcg->css));
> +	struct dev_cgroup *parent = css_to_devcgroup(childcg->css.parent);
>  
>  	if (!parent)
>  		return 1;
> @@ -502,7 +502,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
>  	char temp[12];		/* 11 + 1 characters needed for a u32 */
>  	int count, rc = 0;
>  	struct dev_exception_item ex;
> -	struct dev_cgroup *parent = css_to_devcgroup(css_parent(&devcgroup->css));
> +	struct dev_cgroup *parent = css_to_devcgroup(devcgroup->css.parent);
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -- 
> 1.9.0
> 
> 
For netprio and netclassid
Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
