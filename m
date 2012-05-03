From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file
 (fork, exit, move pid from file)
Date: Thu, 3 May 2012 08:50:12 -0700
Message-ID: <20120503155012.GB5528@google.com>
References: <4F98E4E5.6020602@samsung.com>
 <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com>
 <4F9B82E1.3070602@samsung.com>
 <20120428214131.GB4586@mtj.dyndns.org>
 <4FA24E07.1010206@samsung.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iEBUyd+iRH/VCpxERL31pZrGRmQ6OnOakqkqaaOMjjI=;
        b=q7uM9XG89vMp44tRjo4Lp1tvTvzu8hnR/rMygpqehjWGFkyjp2aKvp455bq4iKl0pM
         YVN6v+J4FkKNsNUVvXPuyxeQFIm4cPGwILcO+cceQPjyZort4POJWsw5EcGEINgSLYWa
         vIdTYxCLKUzm63yjsAh/bL4+PuiWLu8sJC8IA/KHlY9OuMaybQcwi3COuF/m6mBUaCC1
         nNN/Y1ZDhI8TZ3MiBMG85NZ9k1tuPMteP7Q4FN1z5J4uT9xp7GIIY+fubntelqxwa4la
         cdSWAdWiWkfyKOMdr4aDXdU1gDtMsXelX7rYaQGM/qXzZJYlOSJLHHGJXVjJEptzob0n
         YmUQ==
Content-Disposition: inline
In-Reply-To: <4FA24E07.1010206-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

> Signed-off-by: Alex Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Please read how other patches are being posted.  You need to explain
what the patch does and why.

> +static void fsnotify_cgroup(struct task_struct *tsk, __u32 mask)
> +{
> +	struct cgroupfs_root *root;
> +	struct inode	*d_inode;
> +	struct cgroup	*cgrp;

Please read how other local variable definitions are indented.  Read
the coding style and follow your surroundings.

> +	lockdep_assert_held(&cgroup_mutex);
> +
> +	for_each_active_root(root) {
> +		cgrp = task_cgroup_from_root(tsk, root);
> +		d_inode = cgrp->tasks_cfe->dentry->d_inode;

Why not define these variables inside loop?

> +		fsnotify_parent(NULL, cgrp->tasks_cfe->dentry, mask);
> +		fsnotify(d_inode, mask, d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
> +	}
> +}
> +
>  /*
>   * There is one global cgroup mutex. We also require taking
>   * task_lock() when dereferencing a task's cgroup subsys pointers.
> @@ -1978,6 +1996,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  		goto out;
>  	}
>  
> +	/* cgroup_attach_task() already guarded by cgroup_lock by caller */

If you have lockdep annotation, I don't think this is necessary.

> +	fsnotify_cgroup(tsk, FS_MODIFY);
> +
>  	cgroup_task_migrate(cgrp, oldcgrp, tsk, newcg);
>  
>  	for_each_subsys(root, ss) {
> @@ -2669,7 +2690,7 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
>  	return mode;
>  }
>  
> -static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
> +static struct cfent* cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>  			   const struct cftype *cft)
>  {
>  	struct dentry *dir = cgrp->dentry;
> @@ -2696,12 +2717,13 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>  
>  	cfe = kzalloc(sizeof(*cfe), GFP_KERNEL);
>  	if (!cfe)
> -		return -ENOMEM;
> +		return NULL;
>  
>  	dentry = lookup_one_len(name, dir, strlen(name));
>  	if (IS_ERR(dentry)) {
>  		error = PTR_ERR(dentry);
> -		goto out;
> +		kfree(cfe);
> +		return NULL;
>  	}
>  
>  	mode = cgroup_file_mode(cft);
> @@ -2711,29 +2733,34 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>  		cfe->dentry = dentry;
>  		dentry->d_fsdata = cfe;
>  		list_add_tail(&cfe->node, &parent->files);
> -		cfe = NULL;
>  	}
>  	dput(dentry);
> -out:
> -	kfree(cfe);
> -	return error;
> +
> +	return cfe;
>  }

Are you sure you're not creating a memory leak here?

>  static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>  			      const struct cftype cfts[], bool is_add)
>  {
>  	const struct cftype *cft;
> -	int err, ret = 0;
> +	struct cfent *cfe;
> +	int ret = 0;
>  
>  	for (cft = cfts; cft->name[0] != '\0'; cft++) {
> -		if (is_add)
> -			err = cgroup_add_file(cgrp, subsys, cft);
> -		else
> -			err = cgroup_rm_file(cgrp, cft);
> -		if (err) {
> -			pr_warning("cgroup_addrm_files: failed to %s %s, err=%d\n",
> -				   is_add ? "add" : "remove", cft->name, err);
> -			ret = err;
> +		if (is_add) {
> +			cfe = cgroup_add_file(cgrp, subsys, cft);
> +			if(!cfe) {
> +				pr_warning("%s: failed to add %s\n",
> +					   __func__, cft->name);
> +				ret = -1;
> +			} else if(strcmp(cft->name, "tasks") == 0)
                                 ^
				space here.

Please read Documents/CodingStyle.

> +				cgrp->tasks_cfe = cfe;
> +		} else {
> +			if (cgroup_rm_file(cgrp, cft)) {
> +				pr_warning("%s: failed to remove %s\n",
> +					   __func__, cft->name);
> +				ret = -1;
> +			}

Please don't bury this inside cgroup_addrm_files() with strcmp()
trying to find out again which one is the task file - in general, if
you're doing strcmp() inside kernel which isn't parsing userland
input, something is wrong.  Just separate out the cftype of task file
into a standalone entry and let cgroup_populate_dir() call
cgroup_add_file() on it and then record the returned cfe.

Thanks.

-- 
tejun
