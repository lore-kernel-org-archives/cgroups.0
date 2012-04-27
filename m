From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD/RFC v2] event about group change
Date: Fri, 27 Apr 2012 15:34:55 -0700
Message-ID: <20120427223455.GU26595@google.com>
References: <4F98E4E5.6020602@samsung.com>
 <4F98E57E.1040201@samsung.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pGUZDPOefBtjkNsK2EChYEFWzweAo3QvD3FrbHvPTjY=;
        b=ChSSR7A9pE5Bdqj+g2i7cOSfhlcC9oY0R4QQ15Ny40rKF5zeA30qRRFhyqSU/7/BJR
         SCbSTW0stdTKQfXuZOPMtbZG+jA2XWx0qGyFhVes2ttUTYoE6ixPby36CanSsyDr45LR
         UGhnMHaj2THYDQq0+/AtIS7he43e0BHjsUeLXc/mekNlLHOZNvsrMTwZwu9nvz+A7vBt
         p1FtCL6if3adokds0jorMkvJBV8opr1M0GHzZMGlitgZ99yaFSBVp3tg+4PsKh0opL7w
         1J/UBJipPR6NMvYOIzACsUF++o6mI7U71qycQlp1YUfiWUtRv83QyiOU/LZxsuJDdAs0
         cX4A==
Content-Disposition: inline
In-Reply-To: <4F98E57E.1040201-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Hello,

I like it generally (well I suggested it so...) but can you please
post a proper patch with SOB against cgroup/for-3.5 branch?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.5

Also, can you please cc fsnotify people so that they can go over the
new usage?

> @@ -179,6 +179,8 @@ struct cgroup {
>  	struct cgroup *parent;		/* my parent */
>  	struct dentry __rcu *dentry;	/* cgroup fs entry, RCU protected */
>  
> +	struct dentry *tasks_dentry;	/* "tasks" dentry */

Urgh... not the prettiest but I suppose it's necessary.  It will
probably be better to point to cfent instead.

> +static inline void fsnotify_cgroup(struct task_struct *tsk, __u32 mask)

No need to make it inline.

> +{
> +	struct cgroupfs_root *root;
> +	struct inode	*d_inode;
> +	struct cgroup	*cgrp;

What are the locking rules?

> +	for_each_active_root(root) {
> +		cgrp = task_cgroup_from_root(tsk, root);
> +		d_inode = cgrp->tasks_dentry->d_inode;
> +
> +		fsnotify_parent(NULL, cgrp->tasks_dentry, mask);
> +		fsnotify(d_inode, mask, d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);

The interface is rather weird.  It's called fsnotify_cgroup() and it
always generates the requested event on its tasks file?

>  int cgroup_add_file(struct cgroup *cgrp,
>  		       struct cgroup_subsys *subsys,
> -		       const struct cftype *cft)
> +		       const struct cftype *cft,
> +		       int tasks)

Ugh... this is ugly.

>  {
>  	struct dentry *dir = cgrp->dentry;
>  	struct dentry *dentry;
> @@ -2629,6 +2649,12 @@ int cgroup_add_file(struct cgroup *cgrp,
>  		dput(dentry);
>  	} else
>  		error = PTR_ERR(dentry);
> +
> +	if(tasks) {

          ^ missing space

> +		pr_warn("%s(): cft name: %s\n", __func__, name);

Why pr_warn?

> +		cgrp->tasks_dentry = dentry;
> +	}
> +
>  	return error;
>  }
>  EXPORT_SYMBOL_GPL(cgroup_add_file);
> @@ -2640,7 +2666,7 @@ int cgroup_add_files(struct cgroup *cgrp,
>  {
>  	int i, err;
>  	for (i = 0; i < count; i++) {
> -		err = cgroup_add_file(cgrp, subsys, &cft[i]);
> +		err = cgroup_add_file(cgrp, subsys, &cft[i], 0);
>  		if (err)
>  			return err;
>  	}
> @@ -3642,12 +3668,16 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
>  	/* First clear out any existing files */
>  	cgroup_clear_directory(cgrp->dentry);
>  
> -	err = cgroup_add_files(cgrp, NULL, files, ARRAY_SIZE(files));
> +	err = cgroup_add_file(cgrp, NULL, files, 1);
> +	if (err)
> +		return err;
> +
> +	err = cgroup_add_files(cgrp, NULL, files + 1, ARRAY_SIZE(files) - 1);
>  	if (err < 0)
>  		return err;
>  
>  	if (cgrp == cgrp->top_cgroup) {
> -		if ((err = cgroup_add_file(cgrp, NULL, &cft_release_agent)) < 0)
> +		if ((err = cgroup_add_file(cgrp, NULL, &cft_release_agent, 0)) < 0)
>  			return err;
>  	}

Wouldn't it be better to make cgroup_add_file() return the created cft
and let the caller handle the tasks special case?  Also, why use 1/0
for boolean values instead of true/false?

> @@ -4480,6 +4510,7 @@ static const struct file_operations proc_cgroupstats_operations = {
>   */
>  void cgroup_fork(struct task_struct *child)
>  {
> +

Why the new line?

Thanks.

-- 
tejun
