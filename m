From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 10/12] cgroup/drm: Introduce weight based drm cgroup control
Date: Fri, 27 Jan 2023 15:11:19 -1000
Message-ID: <Y9R2N8sl+7f8Zacv@slm.duckdns.org>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230112165609.1083270-11-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GkIPhMBlAguq3FpLF2bZhv+JUE0U4Yd9XqKOrWVb86U=;
        b=T/yjCD7aAOS7VSevYpoV8uPNqOX9/HTALgteOMMYgpyI3MhRyAu+YD3dWSItr3uMKd
         3GxM6KwOplc8c6T2VCDElYplaPui6ZBpurwTBcTp/88En30KDkoRkhGQXY2kDyN56U16
         YDo679wn6KpfLCufDkgvlAzyD2zTsSicSs0GZMqfZcjwhFhfqpbM1JCdXS323w1NVpfQ
         xMSXjIqAhLoFdyE5ztg6T0XEIj2653LI/UHlea/dw8asYDJFXYjh3wkPSbrQ+8Mw7s0q
         +Oz7NwncqTLmicgOYmqhSzXhfUKVBCVVefB/BmtsjrJJV7AuzKO8JXM3EvSbWhGK7ir6
         9vng==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230112165609.1083270-11-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, Jan 12, 2023 at 04:56:07PM +0000, Tvrtko Ursulin wrote:
...
> +	/*
> +	 * 1st pass - reset working values and update hierarchical weights and
> +	 * GPU utilisation.
> +	 */
> +	if (!__start_scanning(root, period_us))
> +		goto out_retry; /*
> +				 * Always come back later if scanner races with
> +				 * core cgroup management. (Repeated pattern.)
> +				 */
> +
> +	css_for_each_descendant_pre(node, &root->css) {
> +		struct drm_cgroup_state *drmcs = css_to_drmcs(node);
> +		struct cgroup_subsys_state *css;
> +		unsigned int over_weights = 0;
> +		u64 unused_us = 0;
> +
> +		if (!css_tryget_online(node))
> +			goto out_retry;
> +
> +		/*
> +		 * 2nd pass - calculate initial budgets, mark over budget
> +		 * siblings and add up unused budget for the group.
> +		 */
> +		css_for_each_child(css, &drmcs->css) {
> +			struct drm_cgroup_state *sibling = css_to_drmcs(css);
> +
> +			if (!css_tryget_online(css)) {
> +				css_put(node);
> +				goto out_retry;
> +			}
> +
> +			sibling->per_s_budget_us  =
> +				DIV_ROUND_UP_ULL(drmcs->per_s_budget_us *
> +						 sibling->weight,
> +						 drmcs->sum_children_weights);
> +
> +			sibling->over = sibling->active_us >
> +					sibling->per_s_budget_us;
> +			if (sibling->over)
> +				over_weights += sibling->weight;
> +			else
> +				unused_us += sibling->per_s_budget_us -
> +					     sibling->active_us;
> +
> +			css_put(css);
> +		}
> +
> +		/*
> +		 * 3rd pass - spread unused budget according to relative weights
> +		 * of over budget siblings.
> +		 */
> +		css_for_each_child(css, &drmcs->css) {
> +			struct drm_cgroup_state *sibling = css_to_drmcs(css);
> +
> +			if (!css_tryget_online(css)) {
> +				css_put(node);
> +				goto out_retry;
> +			}
> +
> +			if (sibling->over) {
> +				u64 budget_us =
> +					DIV_ROUND_UP_ULL(unused_us *
> +							 sibling->weight,
> +							 over_weights);
> +				sibling->per_s_budget_us += budget_us;
> +				sibling->over = sibling->active_us  >
> +						sibling->per_s_budget_us;
> +			}
> +
> +			css_put(css);
> +		}
> +
> +		css_put(node);
> +	}
> +
> +	/*
> +	 * 4th pass - send out over/under budget notifications.
> +	 */
> +	css_for_each_descendant_post(node, &root->css) {
> +		struct drm_cgroup_state *drmcs = css_to_drmcs(node);
> +
> +		if (!css_tryget_online(node))
> +			goto out_retry;
> +
> +		if (drmcs->over || drmcs->over_budget)
> +			signal_drm_budget(drmcs,
> +					  drmcs->active_us,
> +					  drmcs->per_s_budget_us);
> +		drmcs->over_budget = drmcs->over;
> +
> +		css_put(node);
> +	}

It keeps bothering me that the distribution logic has no memory. Maybe this
is good enough for coarse control with long cycle durations but it likely
will get in trouble if pushed to finer grained control. State keeping
doesn't require a lot of complexity. The only state that needs tracking is
each cgroup's vtime and then the core should be able to tell specific
drivers how much each cgroup is over or under fairly accurately at any given
time.

That said, this isn't a blocker. What's implemented can work well enough
with coarse enough time grain and that might be enough for the time being
and we can get back to it later. I think Michal already mentioned it but it
might be a good idea to track active and inactive cgroups and build the
weight tree with only active ones. There are machines with a lot of mostly
idle cgroups (> tens of thousands) and tree wide scanning even at low
frequency can become a pretty bad bottleneck.

Thanks.

-- 
tejun
