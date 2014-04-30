From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 6/6] cgroup, memcg: implement css->id and convert
 css_from_id() to use it
Date: Wed, 30 Apr 2014 15:24:51 +0200
Message-ID: <20140430132451.GF4357@dhcp22.suse.cz>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
 <1398373333-1521-7-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1398373333-1521-7-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu 24-04-14 17:02:13, Tejun Heo wrote:
> Until now, cgroup->id has been used to identify all the associated
> csses and css_from_id() takes cgroup ID and returns the matching css
> by looking up the cgroup and then dereferencing the css associated
> with it; however, now that the lifetimes of cgroup and css are
> separate, this is incorrect and breaks on the unified hierarchy when a
> controller is disabled and enabled back again before the previous
> instance is released.
> 
> This patch adds css->id which is a subsystem-unique ID and converts
> css_from_id() to look up by the new css->id instead.  memcg is the
> only user of css_from_id() and also converted to use css->id instead.
> 
> For traditional hierarchies, this shouldn't make any functional
> difference.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good to me
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  include/linux/cgroup.h |  9 ++++++++
>  kernel/cgroup.c        | 59 ++++++++++++++++++++++++++++++++------------------
>  mm/memcontrol.c        |  4 ++--
>  3 files changed, 49 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 793f70a..2dfabb3 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -62,6 +62,12 @@ struct cgroup_subsys_state {
>  	/* the parent css */
>  	struct cgroup_subsys_state *parent;
>  
> +	/*
> +	 * Subsys-unique ID.  0 is unused and root is always 1.  The
> +	 * matching css can be looked up using css_from_id().
> +	 */
> +	int id;
> +
>  	unsigned int flags;
>  
>  	/* percpu_ref killing and RCU release */
> @@ -655,6 +661,9 @@ struct cgroup_subsys {
>  	/* link to parent, protected by cgroup_lock() */
>  	struct cgroup_root *root;
>  
> +	/* idr for css->id */
> +	struct idr css_idr;
> +
>  	/*
>  	 * List of cftypes.  Each entry is the first entry of an array
>  	 * terminated by zero length name.
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f1c98c5..a1a20e8 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -100,8 +100,8 @@ static DECLARE_RWSEM(css_set_rwsem);
>  #endif
>  
>  /*
> - * Protects cgroup_idr so that IDs can be released without grabbing
> - * cgroup_mutex.
> + * Protects cgroup_idr and css_idr so that IDs can be released without
> + * grabbing cgroup_mutex.
>   */
>  static DEFINE_SPINLOCK(cgroup_idr_lock);
>  
> @@ -1089,12 +1089,6 @@ static void cgroup_put(struct cgroup *cgrp)
>  	if (WARN_ON_ONCE(cgrp->parent && !cgroup_is_dead(cgrp)))
>  		return;
>  
> -	/*
> -	 * XXX: cgrp->id is only used to look up css's.  As cgroup and
> -	 * css's lifetimes will be decoupled, it should be made
> -	 * per-subsystem and moved to css->id so that lookups are
> -	 * successful until the target css is released.
> -	 */
>  	cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
>  	cgrp->id = -1;
>  
> @@ -4104,8 +4098,11 @@ static void css_release(struct percpu_ref *ref)
>  {
>  	struct cgroup_subsys_state *css =
>  		container_of(ref, struct cgroup_subsys_state, refcnt);
> +	struct cgroup_subsys *ss = css->ss;
> +
> +	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], NULL);
> +	cgroup_idr_remove(&ss->css_idr, css->id);
>  
> -	RCU_INIT_POINTER(css->cgroup->subsys[css->ss->id], NULL);
>  	call_rcu(&css->rcu_head, css_free_rcu_fn);
>  }
>  
> @@ -4195,9 +4192,17 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
>  	if (err)
>  		goto err_free_css;
>  
> +	err = cgroup_idr_alloc(&ss->css_idr, NULL, 2, 0, GFP_NOWAIT);
> +	if (err < 0)
> +		goto err_free_percpu_ref;
> +	css->id = err;
> +
>  	err = cgroup_populate_dir(cgrp, 1 << ss->id);
>  	if (err)
> -		goto err_free_percpu_ref;
> +		goto err_free_id;
> +
> +	/* @css is ready to be brought online now, make it visible */
> +	cgroup_idr_replace(&ss->css_idr, css, css->id);
>  
>  	err = online_css(css);
>  	if (err)
> @@ -4216,6 +4221,8 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
>  
>  err_clear_dir:
>  	cgroup_clear_dir(css->cgroup, 1 << css->ss->id);
> +err_free_id:
> +	cgroup_idr_remove(&ss->css_idr, css->id);
>  err_free_percpu_ref:
>  	percpu_ref_cancel_init(&css->refcnt);
>  err_free_css:
> @@ -4642,7 +4649,7 @@ static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
>  	.rename			= cgroup_rename,
>  };
>  
> -static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
> +static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
>  {
>  	struct cgroup_subsys_state *css;
>  
> @@ -4651,6 +4658,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
>  	mutex_lock(&cgroup_tree_mutex);
>  	mutex_lock(&cgroup_mutex);
>  
> +	idr_init(&ss->css_idr);
>  	INIT_LIST_HEAD(&ss->cfts);
>  
>  	/* Create the root cgroup state for this subsystem */
> @@ -4659,6 +4667,13 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
>  	/* We don't handle early failures gracefully */
>  	BUG_ON(IS_ERR(css));
>  	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp);
> +	if (early) {
> +		/* idr_alloc() can't be called safely during early init */
> +		css->id = 1;
> +	} else {
> +		css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2, GFP_KERNEL);
> +		BUG_ON(css->id < 0);
> +	}
>  
>  	/* Update the init_css_set to contain a subsys
>  	 * pointer to this state - since the subsystem is
> @@ -4709,7 +4724,7 @@ int __init cgroup_init_early(void)
>  		ss->name = cgroup_subsys_name[i];
>  
>  		if (ss->early_init)
> -			cgroup_init_subsys(ss);
> +			cgroup_init_subsys(ss, true);
>  	}
>  	return 0;
>  }
> @@ -4741,8 +4756,16 @@ int __init cgroup_init(void)
>  	mutex_unlock(&cgroup_tree_mutex);
>  
>  	for_each_subsys(ss, ssid) {
> -		if (!ss->early_init)
> -			cgroup_init_subsys(ss);
> +		if (ss->early_init) {
> +			struct cgroup_subsys_state *css =
> +				init_css_set.subsys[ss->id];
> +
> +			css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2,
> +						   GFP_KERNEL);
> +			BUG_ON(css->id < 0);
> +		} else {
> +			cgroup_init_subsys(ss, false);
> +		}
>  
>  		list_add_tail(&init_css_set.e_cset_node[ssid],
>  			      &cgrp_dfl_root.cgrp.e_csets[ssid]);
> @@ -5196,14 +5219,8 @@ struct cgroup_subsys_state *css_tryget_from_dir(struct dentry *dentry,
>   */
>  struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
>  {
> -	struct cgroup *cgrp;
> -
>  	WARN_ON_ONCE(!rcu_read_lock_held());
> -
> -	cgrp = idr_find(&ss->root->cgroup_idr, id);
> -	if (cgrp)
> -		return cgroup_css(cgrp, ss);
> -	return NULL;
> +	return idr_find(&ss->css_idr, id);
>  }
>  
>  #ifdef CONFIG_CGROUP_DEBUG
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1d0b297..c3f82f6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -527,7 +527,7 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>  
>  static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
>  {
> -	return memcg->css.cgroup->id;
> +	return memcg->css.id;
>  }
>  
>  static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
> @@ -6401,7 +6401,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(css));
>  
> -	if (css->cgroup->id > MEM_CGROUP_ID_MAX)
> +	if (css->id > MEM_CGROUP_ID_MAX)
>  		return -ENOSPC;
>  
>  	if (!parent)
> -- 
> 1.9.0
> 

-- 
Michal Hocko
SUSE Labs
