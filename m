From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] cgroup: require write perm on common ancestor when
 moving processes on the default hierarchy
Date: Thu, 18 Jun 2015 11:14:38 +0800
Message-ID: <5582379E.1050508@huawei.com>
References: <1434481817-32001-1-git-send-email-tj@kernel.org> <1434481817-32001-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434481817-32001-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Tejun,

> -static int cgroup_procs_write_permission(struct task_struct *task)
> +static int cgroup_procs_write_permission(struct task_struct *task,
> +					 struct cgroup *dst_cgrp,
> +					 struct kernfs_open_file *of)
>  {
>  	const struct cred *cred = current_cred();
>  	const struct cred *tcred = get_task_cred(task);
> @@ -2407,6 +2409,26 @@ static int cgroup_procs_write_permission(struct task_struct *task)
>  	    !uid_eq(cred->euid, tcred->suid))
>  		ret = -EACCES;
>  
> +	if (cgroup_on_dfl(dst_cgrp)) {

if (!ret && cgroup_on_dfl(dst_cgrp))

> +		struct super_block *sb = of->file->f_path.dentry->d_sb;
> +		struct cgroup *cgrp;
> +		struct inode *inode;
> +
> +		down_read(&css_set_rwsem);
> +		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
> +		up_read(&css_set_rwsem);
> +
> +		while (!cgroup_is_descendant(dst_cgrp, cgrp))
> +			cgrp = cgroup_parent(cgrp);
> +
> +		ret = -ENOMEM;
> +		inode = kernfs_get_inode(sb, cgrp->procs_kn);
> +		if (inode) {
> +			ret = inode_permission(inode, MAY_WRITE);
> +			iput(inode);
> +		}
> +	}
> +
>  	put_cred(tcred);
>  	return ret;
>  }
