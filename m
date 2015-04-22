From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Wed, 22 Apr 2015 12:29:54 -0400
Message-ID: <20150422162954.GF10738@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-5-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=3pstiWQ1cmKf4iYpe9Mdw+4lgq+ctAxHtikuXvvpzpA=;
        b=PccpVVjVeyb27mQLK9/jnIKkscJxe48Th/R5GbhMCVwrmrJ0MEJhnRMIEHFPOWJmZt
         78GpVbPXXCXqxv5HIScL7FWPxmgrW3RGKDybSkmr0579OrbbgW7EwJOE4pIQyr9TMuzG
         /OSfPWpWFZ3uTPfOLptnmQz2I+KUD33mKSJ9vXFxE61rXOtZ6aHzw4HvnY6sA+3+DF2f
         ECtg3+pAPCxirTf/y+OFhH2buqxuIyd+Lq/ZoxPYELrVIW1ybAGDsUO642iN2O/EDRYJ
         pxnl8REJaldCioogbk6YOPA0zza88/KvOFqJ5KONeOWjjiR14iNHkzVeGMzHDKfa1f8v
         PsCQ==
Content-Disposition: inline
In-Reply-To: <1429446154-10660-5-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> @@ -0,0 +1,368 @@
> +/*
> + * Process number limiting controller for cgroups.
> + *
> + * Used to allow a cgroup hierarchy to stop any new processes
> + * from fork()ing after a certain limit is reached.
> + *
> + * Since it is trivial to hit the task limit without hitting
> + * any kmemcg limits in place, PIDs are a fundamental resource.
> + * As such, PID exhaustion must be preventable in the scope of
> + * a cgroup hierarchy by allowing resource limiting of the
> + * number of tasks in a cgroup.
> + *
> + * In order to use the `pids` controller, set the maximum number
> + * of tasks in pids.max (this is not available in the root cgroup
> + * for obvious reasons). The number of processes currently
> + * in the cgroup is given by pids.current. Organisational operations
> + * are not blocked by cgroup policies, so it is possible to have
> + * pids.current > pids.max. However, fork()s will still not work.
> + *
> + * To set a cgroup to have no limit, set pids.max to "max". fork()
> + * will return -EBUSY if forking would cause a cgroup policy to be
> + * violated.
> + *
> + * pids.current tracks all child cgroup hierarchies, so
> + * parent/pids.current is a superset of parent/child/pids.current.
> + *
> + * Copyright (C) 2015 Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

The above text looks wrapped too narrow.

> +struct pids_cgroup {
> +	struct cgroup_subsys_state	css;
> +
> +	/*
> +	 * Use 64-bit types so that we can safely represent "max" as
> +	 * (PID_MAX_LIMIT + 1).
            ^^^^^^^^^^^^^^^^^
...
> +static struct cgroup_subsys_state *
> +pids_css_alloc(struct cgroup_subsys_state *parent)
> +{
> +	struct pids_cgroup *pids;
> +
> +	pids = kzalloc(sizeof(struct pids_cgroup), GFP_KERNEL);
> +	if (!pids)
> +		return ERR_PTR(-ENOMEM);
> +
> +	pids->limit = PIDS_MAX;
                      ^^^^^^^^^

> +	atomic64_set(&pids->counter, 0);
> +	return &pids->css;
> +}
...
> +static void pids_detach(struct cgroup_subsys_state *old_css,
> +			struct task_struct *task)
> +{
> +	struct pids_cgroup *old_pids = css_pids(old_css);
> +
> +	pids_uncharge(old_pids, 1);
> +}

You can do the above as a part of can/cancel.

> +static int pids_can_fork(struct task_struct *task, void **private)

Maybe @priv_p or something which signifies it's of different type from
others?

> +{
...
> +	rcu_read_lock();
> +	css = task_css(current, pids_cgrp_id);
> +	if (!css_tryget_online(css)) {
> +		retval = -EBUSY;
> +		goto err_rcu_unlock;
> +	}
> +	rcu_read_unlock();

Hmmm... so, the above is guaranteed to succeed in finite amount of
time (the race window is actually very narrow) and it'd be silly to
fail fork because a task was being moved across cgroups.

I think it'd be a good idea to implement task_get_css() which loops
and returns the current css for the requested subsystem with reference
count bumped and it can use css_tryget() too.  Holding a ref doesn't
prevent css from dying anyway, so it doesn't make any difference.

> +static void pids_fork(struct task_struct *task, void *private)
> +{
...
> +	rcu_read_lock();
> +	css = task_css(task, pids_cgrp_id);
> +	css_get(css);

Why is this safe?  What guarantees that css's ref isn't already zero
at this point?

> +	rcu_read_unlock();
> +
> +	pids = css_pids(css);
> +
> +	/*
> +	 * The association has changed, we have to revert and reapply the
> +	 * charge/uncharge on the wrong hierarchy to the current one. Since
> +	 * the association can only change due to an organisation event, its
> +	 * okay for us to ignore the limit in this case.
> +	 */
> +	if (pids != old_pids) {
> +		pids_uncharge(old_pids, 1);
> +		pids_charge(pids, 1);
> +	}
> +
> +	css_put(css);
> +	css_put(old_css);
> +}
...
> +static ssize_t pids_max_write(struct kernfs_open_file *of, char *buf,
> +			      size_t nbytes, loff_t off)
> +{
> +	struct cgroup_subsys_state *css = of_css(of);
> +	struct pids_cgroup *pids = css_pids(css);
> +	int64_t limit;
> +	int err;
> +
> +	buf = strstrip(buf);
> +	if (!strcmp(buf, PIDS_MAX_STR)) {
> +		limit = PIDS_MAX;
> +		goto set_limit;
> +	}
> +
> +	err = kstrtoll(buf, 0, &limit);
> +	if (err)
> +		return err;
> +
> +	/* We use INT_MAX as the maximum value of pid_t. */
> +	if (limit < 0 || limit > INT_MAX)

This is kinda weird if we're using PIDS_MAX for max as it may end up
showing "max" after some larger number is written to the file.

Thanks.

-- 
tejun
