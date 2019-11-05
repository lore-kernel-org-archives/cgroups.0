From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 03/10] netprio: use css ID instead of cgroup ID
Date: Tue, 5 Nov 2019 08:27:41 -0500
Message-ID: <20191105132741.GA27571@hmswarspite.think-freely.org>
References: <20191104235944.3470866-1-tj@kernel.org>
 <20191104235944.3470866-4-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191104235944.3470866-4-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net, "David S. Miller" <davem@davemloft.net>

On Mon, Nov 04, 2019 at 03:59:37PM -0800, Tejun Heo wrote:
> netprio uses cgroup ID to index the priority mapping table.  This is
> currently okay as cgroup IDs are allocated using idr and packed.
> However, cgroup IDs will be changed to use full 64bit range and won't
> be packed making this impractical.  netprio doesn't care what type of
> IDs it uses as long as they can identify the controller instances and
> are packed.  Let's switch to css IDs instead of cgroup IDs.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> ---
> Hello,
> 
> This is to prepare for kernfs 64bit ino support.  It'd be best to
> route this with the rest of kernfs patchset.
> 
> Thanks.
> 
>  include/net/netprio_cgroup.h | 2 +-
>  net/core/netprio_cgroup.c    | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/netprio_cgroup.h b/include/net/netprio_cgroup.h
> index cfc9441ef074..dec7522b6ce1 100644
> --- a/include/net/netprio_cgroup.h
> +++ b/include/net/netprio_cgroup.h
> @@ -26,7 +26,7 @@ static inline u32 task_netprioidx(struct task_struct *p)
>  
>  	rcu_read_lock();
>  	css = task_css(p, net_prio_cgrp_id);
> -	idx = css->cgroup->id;
> +	idx = css->id;
>  	rcu_read_unlock();
>  	return idx;
>  }
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index 256b7954b720..8881dd943dd0 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -93,7 +93,7 @@ static int extend_netdev_table(struct net_device *dev, u32 target_idx)
>  static u32 netprio_prio(struct cgroup_subsys_state *css, struct net_device *dev)
>  {
>  	struct netprio_map *map = rcu_dereference_rtnl(dev->priomap);
> -	int id = css->cgroup->id;
> +	int id = css->id;
>  
>  	if (map && id < map->priomap_len)
>  		return map->priomap[id];
> @@ -113,7 +113,7 @@ static int netprio_set_prio(struct cgroup_subsys_state *css,
>  			    struct net_device *dev, u32 prio)
>  {
>  	struct netprio_map *map;
> -	int id = css->cgroup->id;
> +	int id = css->id;
>  	int ret;
>  
>  	/* avoid extending priomap for zero writes */
> @@ -177,7 +177,7 @@ static void cgrp_css_free(struct cgroup_subsys_state *css)
>  
>  static u64 read_prioidx(struct cgroup_subsys_state *css, struct cftype *cft)
>  {
> -	return css->cgroup->id;
> +	return css->id;
>  }
>  
>  static int read_priomap(struct seq_file *sf, void *v)
> @@ -237,7 +237,7 @@ static void net_prio_attach(struct cgroup_taskset *tset)
>  	struct cgroup_subsys_state *css;
>  
>  	cgroup_taskset_for_each(p, css, tset) {
> -		void *v = (void *)(unsigned long)css->cgroup->id;
> +		void *v = (void *)(unsigned long)css->id;
>  
>  		task_lock(p);
>  		iterate_fd(p->files, 0, update_netprio, v);
> -- 
> 2.17.1
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
