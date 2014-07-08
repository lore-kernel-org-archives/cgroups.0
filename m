From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 6/6] blkcg, memcg: make blkcg depend on memcg on the
 default hierarchy
Date: Tue, 8 Jul 2014 15:42:26 -0400
Message-ID: <20140708194226.GA18382@redhat.com>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
 <1403917392-32555-7-git-send-email-tj@kernel.org>
 <20140628114907.GA10829@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140628114907.GA10829@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, axboe@kernel.dk

On Sat, Jun 28, 2014 at 07:49:07AM -0400, Tejun Heo wrote:
> >From 8e67ad03ab03839456816e922c57a7ab3bcf5474 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Sat, 28 Jun 2014 07:47:57 -0400
> 
> Currently, the blkio subsystem attributes all of writeback IOs to the
> root.  One of the issues is that there's no way to tell who originated
> a writeback IO from block layer.  Those IOs are usually issued
> asynchronously from a task which didn't have anything to do with
> actually generating the dirty pages.  The memory subsystem, when
> enabled, already keeps track of the ownership of each dirty page and
> it's desirable for blkio to piggyback instead of adding its own
> per-page tag.
> 
> cgroup now has a mechanism to express such dependency -
> cgroup_subsys->depends_on.  This patch declares that blkcg depends on
> memcg so that memcg is enabled automatically on the default hierarchy
> when available.  Future changes will make blkcg map the memcg tag to
> find out the cgroup to blame for writeback IOs.
> 
> As this means that a memcg may be made invisible, this patch also
> implements css_reset() for memcg which resets its basic
> configurations.  This implementation will probably need to be expanded
> to cover other states which are used in the default hierarchy.
> 
> v2: blkcg's dependency on memcg is wrapped with CONFIG_MEMCG to avoid
>     build failure.  Reported by kbuild test robot.
> 

Hi Tejun,

I have couple questions about new semantics. Following is my
understanding. Is it right?

- So after this change one can not use blkio controller on unified
  hiearchy if memory controller is mounted on some other hierarchy
  and is not available for mounting unified hiearchy.

- If blkio controller is enabled on unified hiearchy (memory controller
  implicitly enabled), then one can't mount memory controller on other
  hierarchies without first disabling blkio controller on unified hiearchy.

I think this change makes sense. memory controller already knows which
cgroup dirtied the page and making use of same data by forcing memory
and blkio to be mounted together should work.

There are some cases where people don't want to use blkio because of
overhead, and in that case, they can simply not enable blkio controller
on children (which memory controller can still be enabled on children).

Thanks
Vivek

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-cgroup.c |  8 ++++++++
>  mm/memcontrol.c    | 24 ++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 069bc20..63c3cd4 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -925,6 +925,14 @@ struct cgroup_subsys blkio_cgrp_subsys = {
>  	.css_free = blkcg_css_free,
>  	.can_attach = blkcg_can_attach,
>  	.base_cftypes = blkcg_files,
> +#ifdef CONFIG_MEMCG
> +	/*
> +	 * This ensures that, if available, memcg is automatically enabled
> +	 * together on the default hierarchy so that the owner cgroup can
> +	 * be retrieved from writeback pages.
> +	 */
> +	.depends_on = 1 << memory_cgrp_id,
> +#endif
>  };
>  EXPORT_SYMBOL_GPL(blkio_cgrp_subsys);
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a2c7bcb..db536e9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6407,6 +6407,29 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  	__mem_cgroup_free(memcg);
>  }
>  
> +/**
> + * mem_cgroup_css_reset - reset the states of a mem_cgroup
> + * @css: the target css
> + *
> + * Reset the states of the mem_cgroup associated with @css.  This is
> + * invoked when the userland requests disabling on the default hierarchy
> + * but the memcg is pinned through dependency.  The memcg should stop
> + * applying policies and should revert to the vanilla state as it may be
> + * made visible again.
> + *
> + * The current implementation only resets the essential configurations.
> + * This needs to be expanded to cover all the visible parts.
> + */
> +static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> +
> +	mem_cgroup_resize_limit(memcg, ULLONG_MAX);
> +	mem_cgroup_resize_memsw_limit(memcg, ULLONG_MAX);
> +	memcg_update_kmem_limit(memcg, ULLONG_MAX);
> +	res_counter_set_soft_limit(&memcg->res, ULLONG_MAX);
> +}
> +
>  #ifdef CONFIG_MMU
>  /* Handlers for move charge at task migration. */
>  #define PRECHARGE_COUNT_AT_ONCE	256
> @@ -7019,6 +7042,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
>  	.css_online = mem_cgroup_css_online,
>  	.css_offline = mem_cgroup_css_offline,
>  	.css_free = mem_cgroup_css_free,
> +	.css_reset = mem_cgroup_css_reset,
>  	.can_attach = mem_cgroup_can_attach,
>  	.cancel_attach = mem_cgroup_cancel_attach,
>  	.attach = mem_cgroup_move_task,
> -- 
> 1.9.3
