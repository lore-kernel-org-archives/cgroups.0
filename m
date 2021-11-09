From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v1 1/5] mm/shmem: support deterministic charging of tmpfs
Date: Mon, 8 Nov 2021 17:15:09 -0800
Message-ID: <YYnLnciiQDRC/Xv7@carbon.dhcp.thefacebook.com>
References: <20211108211959.1750915-1-almasrymina@google.com>
 <20211108211959.1750915-2-almasrymina@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=p+05fbAkDH+oG9y4EgNquICD+QKs3DQ85ghtGkc0SII=;
 b=H8L5VDmrw/S5Z9rV6hJsdZgoW2+3UWJLVOJ9sfwgBgwRXn23NcO9mMxg2PkB047j/Q+c
 iQcY6Yl7pE3BiPxPLAuV/HdvAeQwAO2YA4Suc7O1K7pxOU6TcxV3rjIx4ByEyuiQtQde
 25fGhIMDk+t0BSP4hA8ryPCaj8so0zmlU4E= 
Content-Disposition: inline
In-Reply-To: <20211108211959.1750915-2-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <songmuchun@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, riel@surriel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Nov 08, 2021 at 01:19:55PM -0800, Mina Almasry wrote:
> Add memcg= option to shmem mount.
> 
> Users can specify this option at mount time and all data page charges
> will be charged to the memcg supplied.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Hello, Mina!

Overall I think it's a useful option and I do see it being used outside
of tmpfs usecase. In certain cases a user might want to use memory
cgroups to limit the amount of pagecache and something like what you've
suggested might be useful. I agree with Michal that it opens some
hard questions about certain corner cases, but I don't think there any
show stoppers (at least as now).

> 
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Greg Thelen <gthelen@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Roman Gushchin <songmuchun@bytedance.com>

This is clearly not my email.

> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: riel@surriel.com
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> 
> ---
>  fs/super.c                 |   3 ++
>  include/linux/fs.h         |   5 ++
>  include/linux/memcontrol.h |  46 ++++++++++++++--
>  mm/filemap.c               |   2 +-
>  mm/memcontrol.c            | 104 ++++++++++++++++++++++++++++++++++++-
>  mm/shmem.c                 |  50 +++++++++++++++++-
>  6 files changed, 201 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 3bfc0f8fbd5bc..8aafe5e4e6200 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -24,6 +24,7 @@
>  #include <linux/export.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> +#include <linux/memcontrol.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
>  #include <linux/writeback.h>		/* for the emergency remount stuff */
> @@ -180,6 +181,7 @@ static void destroy_unused_super(struct super_block *s)
>  	up_write(&s->s_umount);
>  	list_lru_destroy(&s->s_dentry_lru);
>  	list_lru_destroy(&s->s_inode_lru);
> +	mem_cgroup_set_charge_target(&s->s_memcg_to_charge, NULL);
>  	security_sb_free(s);
>  	put_user_ns(s->s_user_ns);
>  	kfree(s->s_subtype);
> @@ -292,6 +294,7 @@ static void __put_super(struct super_block *s)
>  		WARN_ON(s->s_dentry_lru.node);
>  		WARN_ON(s->s_inode_lru.node);
>  		WARN_ON(!list_empty(&s->s_mounts));
> +		mem_cgroup_set_charge_target(&s->s_memcg_to_charge, NULL);
>  		security_sb_free(s);
>  		fscrypt_sb_free(s);
>  		put_user_ns(s->s_user_ns);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 3afca821df32e..59407b3e7aee3 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1567,6 +1567,11 @@ struct super_block {
>  	struct workqueue_struct *s_dio_done_wq;
>  	struct hlist_head s_pins;
> 
> +#ifdef CONFIG_MEMCG
> +	/* memcg to charge for pages allocated to this filesystem */
> +	struct mem_cgroup *s_memcg_to_charge;
> +#endif
> +
>  	/*
>  	 * Owning user namespace and default context in which to
>  	 * interpret filesystem uids, gids, quotas, device nodes,
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0c5c403f4be6b..e9a64c1b8295b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -27,6 +27,7 @@ struct obj_cgroup;
>  struct page;
>  struct mm_struct;
>  struct kmem_cache;
> +struct super_block;
> 
>  /* Cgroup-specific page state, on top of universal node page state */
>  enum memcg_stat_item {
> @@ -689,7 +690,8 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
>  		page_counter_read(&memcg->memory);
>  }
> 
> -int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
> +int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp,
> +			struct address_space *mapping);
> 
>  /**
>   * mem_cgroup_charge - Charge a newly allocated folio to a cgroup.
> @@ -710,7 +712,7 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
>  {
>  	if (mem_cgroup_disabled())
>  		return 0;
> -	return __mem_cgroup_charge(folio, mm, gfp);
> +	return __mem_cgroup_charge(folio, mm, gfp, NULL);
>  }
> 
>  int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
> @@ -923,6 +925,16 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
>  	return !!(memcg->css.flags & CSS_ONLINE);
>  }
> 
> +bool is_remote_oom(struct mem_cgroup *memcg_under_oom);
> +void mem_cgroup_set_charge_target(struct mem_cgroup **target,
> +				  struct mem_cgroup *memcg);
> +struct mem_cgroup *mem_cgroup_get_from_path(const char *path);
> +/**
> + * User is responsible for providing a buffer @buf of length @len and freeing
> + * it.
> + */
> +int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf, size_t len);
> +
>  void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
>  		int zid, int nr_pages);
> 
> @@ -1217,8 +1229,15 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
>  	return false;
>  }
> 
> -static inline int mem_cgroup_charge(struct folio *folio,
> -		struct mm_struct *mm, gfp_t gfp)
> +static inline int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
> +				      gfp_t gfp_mask,
> +				      struct address_space *mapping)
> +{
> +	return 0;
> +}
> +
> +static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
> +				    gfp_t gfp_mask)
>  {
>  	return 0;
>  }
> @@ -1326,6 +1345,25 @@ static inline void mem_cgroup_iter_break(struct mem_cgroup *root,
>  {
>  }
> 
> +static inline bool is_remote_oom(struct mem_cgroup *memcg_under_oom)
> +{
> +	return false;
> +}
> +
> +static inline void mem_cgroup_set_charge_target(struct mem_cgroup **target,
> +						struct mem_cgroup *memcg)
> +{
> +}
> +
> +static inline int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf,
> +					      size_t len)
> +{
> +	if (len < 1)
> +		return -EINVAL;
> +	buf[0] = '\0';
> +	return 0;
> +}
> +
>  static inline int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  		int (*fn)(struct task_struct *, void *), void *arg)
>  {
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6844c9816a864..75e81dfd2c580 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -903,7 +903,7 @@ noinline int __filemap_add_folio(struct address_space *mapping,
>  	folio->index = index;
> 
>  	if (!huge) {
> -		error = mem_cgroup_charge(folio, NULL, gfp);
> +		error = __mem_cgroup_charge(folio, NULL, gfp, mapping);
>  		VM_BUG_ON_FOLIO(index & (folio_nr_pages(folio) - 1), folio);
>  		if (error)
>  			goto error;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 781605e920153..389d2f2be9674 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2580,6 +2580,103 @@ void mem_cgroup_handle_over_high(void)
>  	css_put(&memcg->css);
>  }
> 
> +/*
> + * Non error return value must eventually be released with css_put().
> + */
> +struct mem_cgroup *mem_cgroup_get_from_path(const char *path)
> +{
> +	struct file *file;
> +	struct cgroup_subsys_state *css;
> +	struct mem_cgroup *memcg;
> +
> +	file = filp_open(path, O_DIRECTORY | O_RDONLY, 0);
> +	if (IS_ERR(file))
> +		return (struct mem_cgroup *)file;
> +
> +	css = css_tryget_online_from_dir(file->f_path.dentry,
> +					 &memory_cgrp_subsys);
> +	if (IS_ERR(css))
> +		memcg = (struct mem_cgroup *)css;
> +	else
> +		memcg = container_of(css, struct mem_cgroup, css);
> +
> +	fput(file);
> +	return memcg;
> +}
> +
> +/*
> + * Get the name of the optional charge target memcg associated with @sb.  This
> + * is the cgroup name, not the cgroup path.
> + */
> +int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf, size_t len)
> +{
> +	struct mem_cgroup *memcg;
> +	int ret = 0;
> +
> +	buf[0] = '\0';
> +
> +	rcu_read_lock();
> +	memcg = rcu_dereference(sb->s_memcg_to_charge);
> +	if (memcg && !css_tryget_online(&memcg->css))
> +		memcg = NULL;
> +	rcu_read_unlock();
> +
> +	if (!memcg)
> +		return 0;
> +
> +	ret = cgroup_path(memcg->css.cgroup, buf + len / 2, len / 2);
> +	if (ret >= len / 2)
> +		strcpy(buf, "?");
> +	else {
> +		char *p = mangle_path(buf, buf + len / 2, " \t\n\\");
> +
> +		if (p)
> +			*p = '\0';
> +		else
> +			strcpy(buf, "?");
> +	}
> +
> +	css_put(&memcg->css);
> +	return ret < 0 ? ret : 0;
> +}
> +
> +/*
> + * Set or clear (if @memcg is NULL) charge association from file system to
> + * memcg.  If @memcg != NULL, then a css reference must be held by the caller to
> + * ensure that the cgroup is not deleted during this operation.
> + */
> +void mem_cgroup_set_charge_target(struct mem_cgroup **target,
> +				  struct mem_cgroup *memcg)
> +{
> +	if (memcg)
> +		css_get(&memcg->css);
> +	memcg = xchg(target, memcg);
> +	if (memcg)
> +		css_put(&memcg->css);
> +}
> +
> +/*
> + * Returns the memcg to charge for inode pages.  If non-NULL is returned, caller
> + * must drop reference with css_put().  NULL indicates that the inode does not
> + * have a memcg to charge, so the default process based policy should be used.
> + */
> +static struct mem_cgroup *
> +mem_cgroup_mapping_get_charge_target(struct address_space *mapping)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	if (!mapping)
> +		return NULL;
> +
> +	rcu_read_lock();
> +	memcg = rcu_dereference(mapping->host->i_sb->s_memcg_to_charge);
> +	if (memcg && !css_tryget_online(&memcg->css))
> +		memcg = NULL;
> +	rcu_read_unlock();
> +
> +	return memcg;
> +}
> +
>  static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  			unsigned int nr_pages)
>  {
> @@ -6678,12 +6775,15 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>  	return ret;
>  }
> 
> -int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
> +int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp,
> +			struct address_space *mapping)
>  {
>  	struct mem_cgroup *memcg;
>  	int ret;
> 
> -	memcg = get_mem_cgroup_from_mm(mm);
> +	memcg = mem_cgroup_mapping_get_charge_target(mapping);
> +	if (!memcg)
> +		memcg = get_mem_cgroup_from_mm(mm);
>  	ret = charge_memcg(folio, memcg, gfp);
>  	css_put(&memcg->css);

This function becomes very non-obvious as it's taking a folio (ex-page),
mm and now mapping as arguments. I'd just add a new wrapper around
charge_memcg() instead.

I'd also merge the next patch into this one.

Thanks!
