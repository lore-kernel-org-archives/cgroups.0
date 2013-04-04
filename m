From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC][PATCH 5/7] cgroup: make sure parent won't be destroyed
 before its children
Date: Thu, 4 Apr 2013 13:37:50 +0200
Message-ID: <20130404113750.GH29911@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
 <515BF2A4.1070703@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515BF2A4.1070703-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed 03-04-13 17:13:08, Li Zefan wrote:
> Suppose we rmdir a cgroup and there're still css refs, this cgroup won't
> be freed. Then we rmdir the parent cgroup, and the parent is freed due
> to css ref draining to 0. Now it would be a disaster if the child cgroup
> tries to access its parent.

Hmm, I am not sure what is the correct layer for this to handle - cgroup
core or memcg. But we have enforced that in mem_cgroup_css_online where
we take an additional reference to the memcg.

Handling it in the memcg code would have an advantage of limiting an
additional reference only to use_hierarchy cases which is sufficient
as we never touch the parent otherwise (parent_mem_cgroup).

So I think this patch should just take css reference to parent during
online and drop it from mem_cgroup_css_free.

If there are more contollers that need this then it should be handled by
the cgroup core of course.

> Make sure this won't happen.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index fa54b92..78204bc 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -888,6 +888,13 @@ static void cgroup_free_fn(struct work_struct *work)
>  	mutex_unlock(&cgroup_mutex);
>  
>  	/*
> +	 * We get a ref to the parent's dentry, and put the ref when
> +	 * this cgroup is being freed, so it's guaranteed that the
> +	 * parent won't be destroyed before its children.
> +	 */
> +	dput(cgrp->parent->dentry);
> +
> +	/*
>  	 * Drop the active superblock reference that we took when we
>  	 * created the cgroup
>  	 */
> @@ -4171,6 +4178,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>  	for_each_subsys(root, ss)
>  		dget(dentry);
>  
> +	/* hold a ref to the parent's dentry */
> +	dget(parent->dentry);
> +
>  	/* creation succeeded, notify subsystems */
>  	for_each_subsys(root, ss) {
>  		err = online_css(ss, cgrp);
> -- 
> 1.8.0.2

-- 
Michal Hocko
SUSE Labs
