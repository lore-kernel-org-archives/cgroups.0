From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: kill cgroup_subsys->__DEPRECATED_clear_css_refs
Date: Wed, 31 Oct 2012 17:21:29 +0400
Message-ID: <509125D9.8070100@parallels.com>
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351657365-25055-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


>  	}
>  	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
> -	if (!cgroup_clear_css_refs(cgrp)) {
> -		mutex_unlock(&cgroup_mutex);
> -		/*
> -		 * Because someone may call cgroup_wakeup_rmdir_waiter() before
> -		 * prepare_to_wait(), we need to check this flag.
> -		 */
> -		if (test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags))
> -			schedule();
> -		finish_wait(&cgroup_rmdir_waitq, &wait);
> -		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
> -		if (signal_pending(current))
> -			return -EINTR;
> -		goto again;
> +
> +	local_irq_disable();
> +
> +	/* block new css_tryget() by deactivating refcnt */
> +	for_each_subsys(cgrp->root, ss) {
> +		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> +
> +		WARN_ON(atomic_read(&css->refcnt) < 0);
> +		atomic_add(CSS_DEACT_BIAS, &css->refcnt);
>  	}
> -	/* NO css_tryget() can success after here. */
> +
> +	/*
> +	 * Set REMOVED.  All in-progress css_tryget() will be released.
> +	 * Put all the base refs.  Each css holds an extra reference to the
> +	 * cgroup's dentry and cgroup removal proceeds regardless of css
> +	 * refs.  On the last put of each css, whenever that may be, the
> +	 * extra dentry ref is put so that dentry destruction happens only
> +	 * after all css's are released.
> +	 */
> +	for_each_subsys(cgrp->root, ss) {
> +		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> +
> +		set_bit(CSS_REMOVED, &css->flags);
> +		css_put(css);
> +	}
> +
> +	local_irq_enable();
> +
>  	finish_wait(&cgroup_rmdir_waitq, &wait);

It seems to me that the main reason for doing this in two passes was to
derive a global "failed" state on the first pass. Now that we can't
fail, why can't you just loop through the subsystems just once ?
