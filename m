From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 11/13] cgroup/drm: Introduce weight based drm cgroup control
Date: Tue, 22 Nov 2022 11:29:20 -1000
Message-ID: <Y30/MIsLmVAZ7pQi@slm.duckdns.org>
References: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
 <20221109161141.2987173-12-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XYbx+av6DBnORVcQ2ULxfCSTDy21R06QMcTObHYEV34=;
        b=YGgKFSzVDtg4WqE7blC+H6hUzPYoBzvcBGqcO8VWfLHbMTqWNn4bE7btkALc2ygD5T
         D2Xj8asn40IU8QFMvKIiMRt9BNe+DUkTI09kpbDa7g6S4DYFTI1rHz51KuXDTKNuj/Sh
         Njuax5n6GHUJW8GAskJ2gtcmll/eWEZMsPzskTGXNZq1xDdhzPToaaPHs1DMAxoR4CXC
         g4T4/4TWRfjOCE9jGNmZHF8RmxInIK24wUW/svb5XVdP3I4wtMt1v020nT6Bdw3YBKkC
         HS1n2b8c0YyB6P4nGoAjBTrENJqPW49nR/dgfsFdWHaBGUsSvvgdvsl3W2dE202ZTirX
         l7Lw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221109161141.2987173-12-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Nov 09, 2022 at 04:11:39PM +0000, Tvrtko Ursulin wrote:
> +DRM scheduling soft limits
> +~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Because of the heterogenous hardware and driver DRM capabilities, soft limits
> +are implemented as a loose co-operative (bi-directional) interface between the
> +controller and DRM core.
> +
> +The controller configures the GPU time allowed per group and periodically scans
> +the belonging tasks to detect the over budget condition, at which point it
> +invokes a callback notifying the DRM core of the condition.
> +
> +DRM core provides an API to query per process GPU utilization and 2nd API to
> +receive notification from the cgroup controller when the group enters or exits
> +the over budget condition.
> +
> +Individual DRM drivers which implement the interface are expected to act on this
> +in the best-effort manner only. There are no guarantees that the soft limits
> +will be respected.

Soft limits is a bit of misnomer and can be confused with best-effort limits
such as memory.high. Prolly best to not use the term.

> +static bool
> +__start_scanning(struct drm_cgroup_state *root, unsigned int period_us)
> +{
> +	struct cgroup_subsys_state *node;
> +	bool ok = false;
> +
> +	rcu_read_lock();
> +
> +	css_for_each_descendant_post(node, &root->css) {
> +		struct drm_cgroup_state *drmcs = css_to_drmcs(node);
> +
> +		if (!css_tryget_online(node))
> +			goto out;
> +
> +		drmcs->active_us = 0;
> +		drmcs->sum_children_weights = 0;
> +
> +		if (node == &root->css)
> +			drmcs->per_s_budget_ns =
> +				DIV_ROUND_UP_ULL(NSEC_PER_SEC * period_us,
> +						 USEC_PER_SEC);
> +		else
> +			drmcs->per_s_budget_ns = 0;
> +
> +		css_put(node);
> +	}
> +
> +	css_for_each_descendant_post(node, &root->css) {
> +		struct drm_cgroup_state *drmcs = css_to_drmcs(node);
> +		struct drm_cgroup_state *parent;
> +		u64 active;
> +
> +		if (!css_tryget_online(node))
> +			goto out;
> +		if (!node->parent) {
> +			css_put(node);
> +			continue;
> +		}
> +		if (!css_tryget_online(node->parent)) {
> +			css_put(node);
> +			goto out;
> +		}
> +		parent = css_to_drmcs(node->parent);
> +
> +		active = drmcs_get_active_time_us(drmcs);
> +		if (active > drmcs->prev_active_us)
> +			drmcs->active_us += active - drmcs->prev_active_us;
> +		drmcs->prev_active_us = active;
> +
> +		parent->active_us += drmcs->active_us;
> +		parent->sum_children_weights += drmcs->weight;
> +
> +		css_put(node);
> +		css_put(&parent->css);
> +	}
> +
> +	ok = true;
> +
> +out:
> +	rcu_read_unlock();
> +
> +	return ok;
> +}

A more conventional and scalable way to go about this would be using an
rbtree keyed by virtual time. Both CFS and blk-iocost are examples of this,
but I think for drm, it can be a lot simpler.

Thanks.

-- 
tejun
