From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Sun, 8 Mar 2015 23:34:05 -0400
Message-ID: <20150309033405.GE13283@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-3-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xSmhlhI4TwvNtkEXsIEi1adA1DqunuQuh1cuCSC1U/4=;
        b=qZAu+nhdnReTmKgl/cO2KoqnSnSuzdXcj2TkJ+Xo9Wa3/pcJgfva3SGOikXlxjRrOz
         WKKGhH0gSJZaZpfr0EqR3hr3cS2wa9ERTQuPc82gLIeQjFmkmZY3Sup+sh6LVASpnkrg
         QarhGRG+A0DYG3Po6XUNIwXQr+SvIEG0DrwH7gb9azqBld54PI5WU4bdqNyYEmRf9bLI
         CCMZSFOtYzp0v6qw3Di81WZX7DmDaoY4asaFBunDmFXtgTh81gr+hTPGsz+Dz2Tj3O2A
         aMRKNuXKd2YMEVRqeetxiUD5l39q8b2BO0vs5+5qK437g9MLBQjaGV/W9LQfMIyGXXq9
         gZMQ==
Content-Disposition: inline
In-Reply-To: <1425606357-6337-3-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 06, 2015 at 12:45:57PM +1100, Aleksa Sarai wrote:
> +struct pids {

This name is way too generic.  Please make it clear it's part of a
cgroup controller.

> +	struct pids *parent;
> +	struct cgroup_subsys_state css;

Please make css the first element.  The above prevents css <-> pids
pointer conversions from being noop.

> +
> +	atomic_long_t counter;
> +	long limit;

Why are these long?

> +};
> +
> +static inline struct pids *css_pids(struct cgroup_subsys_state *css)

No need for explicit inlines.

> +{
> +	return css ? container_of(css, struct pids, css) : NULL;
> +}
> +
> +static inline struct pids *task_pids(struct task_struct *task)
> +{
> +	return css_pids(task_css(task, pids_cgrp_id));
> +}
> +
> +static struct pids *parent_pids(struct pids *pids)
> +{
> +	return css_pids(pids->css.parent);
> +}

For all the above functions.

> +static int pids_css_online(struct cgroup_subsys_state *css)
> +{
> +	struct pids *pids = css_pids(css);
> +	long limit = -1;
> +
> +	pids->parent = parent_pids(pids);
> +	if (pids->parent)
> +		limit = pids->parent->limit;
> +
> +	pids->limit = limit;

Why would a child inherit the setting of the parent?  It's already
hierarchically limited by the parent.  There's no point in inheriting
the setting itself.

> +	atomic_long_set(&pids->counter, 0);
> +	return 0;
> +}
> +
> +static void pids_css_free(struct cgroup_subsys_state *css)
> +{
> +	kfree(css_pids(css));
> +}
> +
> +/**
> + * pids_cancel - uncharge the local pid count
> + * @pids: the pid cgroup state
> + * @num: the number of pids to cancel
> + *
> + * This function will WARN if the pid count goes under 0,
> + * but will not prevent it.
> + */
> +static void pids_cancel(struct pids *pids, int num)
> +{
> +	long new;
> +
> +	new = atomic_long_sub_return(num, &pids->counter);
> +
> +	/*
> +	 * A negative count is invalid, but pids_cancel() can't fail.
> +	 * So just emit a WARN.
> +	 */
> +	WARN_ON(new < 0);

WARN_ON_ONCE() would be better.  Also, if you're gonna warn against
underflow, why not warn about overflow?  Just use
WARN_ON_ONCE(atomic_add_negative()).

> +}
> +
> +/**
> + * pids_charge - hierarchically uncharge the pid count
> + * @pids: the pid cgroup state
> + * @num: the number of pids to uncharge
> + *
> + * This function will not allow the pid count to go under 0,
> + * and will WARN if a caller attempts to do so.
> + */
> +static void pids_uncharge(struct pids *pids, int num)
> +{
> +	struct pids *p;
> +
> +	for (p = pids; p; p = p->parent)
> +		pids_cancel(p, num);
> +}

Does pids limit make sense in the root cgroup?

> +static int pids_try_charge(struct pids *pids, int num)
> +{
> +	struct pids *p, *fail;
> +
> +	for (p = pids; p; p = p->parent) {
> +		long new;
> +
> +		new = atomic_long_add_return(num, &p->counter);
> +
> +		if (p->limit == PIDS_UNLIMITED)
> +			continue;

Huh?  So, the counter stays out of sync if unlimited?  What happens
when it gets set to something else later?

> +
> +		if (new > p->limit) {
> +			atomic_long_sub(num, &p->counter);
> +			fail = p;
> +			goto revert;
> +		}
> +	}
> +
> +	return 0;
> +
> +revert:
> +	for (p = pids; p != fail; p = p->parent)
> +		pids_cancel(pids, num);
> +
> +	return -EAGAIN;
> +}
...
> +static void pids_exit(struct cgroup_subsys_state *css,
> +		      struct cgroup_subsys_state *old_css,
> +		      struct task_struct *task)
> +{
> +	struct pids *pids = css_pids(old_css);
> +
> +	/*
> +	 * cgroup_exit() gets called as part of the cleanup code when
> +	 * copy_process() fails. This should ignored, because the
> +	 * pids_cancel_fork callback already deals with the cgroup failed fork
> +	 * case.
> +	 */

Do we even need cancel call then?

> +	if (!(task->flags & PF_EXITING))
> +		return;
> +
> +	pids_uncharge(pids, 1);
> +}
> +
> +static int pids_write_max(struct cgroup_subsys_state *css,
> +			  struct cftype *cft, s64 val)
> +{
> +	struct pids *pids = css_pids(css);
> +
> +	/* PIDS_UNLIMITED is the only legal negative value. */
> +	if (val < 0 && val != PIDS_UNLIMITED)
> +		return -EINVAL;

Ugh... let's please not do negatives.  Please input and output "max"
for no limit conditions.

> +	/*
> +	 * Limit updates don't need to be mutex'd, since they
> +	 * are more of a "soft" limit in the sense that you can
> +	 * set a limit which is smaller than the current count
> +	 * to stop any *new* processes from spawning.
> +	 */
> +	pids->limit = val;

So, on 32bit machines, we're assigning 64bit inte to 32bit after
ensuring the 64bit is a positive number?

Overall, I'm not too confident this is going well.

Thanks.

-- 
tejun
