From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/9] cgroup: use restart_syscall() for mount retries
Date: Wed, 14 May 2014 10:53:47 +0800
Message-ID: <5372DABB.4040908@huawei.com>
References: <1399670015-23463-1-git-send-email-tj@kernel.org> <1399670015-23463-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399670015-23463-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/5/10 5:13, Tejun Heo wrote:
> cgroup_mount() uses dumb delay-and-retry logic to wait for cgroup_root
> which is being destroyed.  The retry currently loops inside
> cgroup_mount() proper.  This patch makes it return with
> restart_syscall() instead so that retry travels out to userland
> boundary.
> 
> This slightly simplifies the logic and more importantly makes the
> retry logic behave better when the wait for some reason becomes
> lengthy or infinite by allowing the operation to be suspended or
> terminated from userland.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  kernel/cgroup.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 3083c5a..2755f33 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1681,7 +1681,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  	ret = parse_cgroupfs_options(data, &opts);
>  	if (ret)
>  		goto out_unlock;
> -retry:
> +
>  	/* look for a matching existing root */
>  	if (!opts.subsys_mask && !opts.none && !opts.name) {
>  		cgrp_dfl_root_visible = true;
> @@ -1740,8 +1740,7 @@ retry:
>  		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
>  			mutex_unlock(&cgroup_mutex);
>  			msleep(10);
> -			mutex_lock(&cgroup_mutex);
> -			goto retry;
> +			return ERR_PTR(restart_syscall());

We leak memory allocated in parse_cgroupfs_options().
