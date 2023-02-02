From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC 10/12] cgroup/drm: Introduce weight based drm cgroup control
Date: Thu, 2 Feb 2023 14:26:06 +0000
Message-ID: <27b7882e-1201-b173-6f56-9ececb5780e8@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230112165609.1083270-11-tvrtko.ursulin@linux.intel.com>
 <Y9R2N8sl+7f8Zacv@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675347972; x=1706883972;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f3HA4j/3sz9ZxloTe8PsLAHonqU/MTJv3W2yuiyZ67c=;
  b=c2DtQs5Y4GqsemFMDxMC+ks8uXmurvmadj+hGftBSn0acb3jjdpcCa16
   koGhRMcrlHdZKbKjeFABjqe3VN45sKb+82KVs5CFdiGGaZvqpJ6NYV8Fc
   aKwaPcMwPg9Bi/6teGxi4/1pvHgiCCPEJuT4PpYtygtmZlMOof0tfQsDo
   bgsuTBVtl0hVLht0mRu8CFwK0bw3T/ZGJF4cApPA0qXU1dCUX1iddGr21
   AuHUyQ8Wl37rL6sIIeA35aCVao7LFHaesfnFkOn3Vphh6dNAAE64A7v11
   QjT7gFUkn7PeuZtHaH4KQBlA4w0Mje8bzEF0iEJV6NhRM/KEjssaL+wMM
   A==;
Content-Language: en-US
In-Reply-To: <Y9R2N8sl+7f8Zacv-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


On 28/01/2023 01:11, Tejun Heo wrote:
> On Thu, Jan 12, 2023 at 04:56:07PM +0000, Tvrtko Ursulin wrote:
> ...
>> +	/*
>> +	 * 1st pass - reset working values and update hierarchical weights and
>> +	 * GPU utilisation.
>> +	 */
>> +	if (!__start_scanning(root, period_us))
>> +		goto out_retry; /*
>> +				 * Always come back later if scanner races with
>> +				 * core cgroup management. (Repeated pattern.)
>> +				 */
>> +
>> +	css_for_each_descendant_pre(node, &root->css) {
>> +		struct drm_cgroup_state *drmcs = css_to_drmcs(node);
>> +		struct cgroup_subsys_state *css;
>> +		unsigned int over_weights = 0;
>> +		u64 unused_us = 0;
>> +
>> +		if (!css_tryget_online(node))
>> +			goto out_retry;
>> +
>> +		/*
>> +		 * 2nd pass - calculate initial budgets, mark over budget
>> +		 * siblings and add up unused budget for the group.
>> +		 */
>> +		css_for_each_child(css, &drmcs->css) {
>> +			struct drm_cgroup_state *sibling = css_to_drmcs(css);
>> +
>> +			if (!css_tryget_online(css)) {
>> +				css_put(node);
>> +				goto out_retry;
>> +			}
>> +
>> +			sibling->per_s_budget_us  =
>> +				DIV_ROUND_UP_ULL(drmcs->per_s_budget_us *
>> +						 sibling->weight,
>> +						 drmcs->sum_children_weights);
>> +
>> +			sibling->over = sibling->active_us >
>> +					sibling->per_s_budget_us;
>> +			if (sibling->over)
>> +				over_weights += sibling->weight;
>> +			else
>> +				unused_us += sibling->per_s_budget_us -
>> +					     sibling->active_us;
>> +
>> +			css_put(css);
>> +		}
>> +
>> +		/*
>> +		 * 3rd pass - spread unused budget according to relative weights
>> +		 * of over budget siblings.
>> +		 */
>> +		css_for_each_child(css, &drmcs->css) {
>> +			struct drm_cgroup_state *sibling = css_to_drmcs(css);
>> +
>> +			if (!css_tryget_online(css)) {
>> +				css_put(node);
>> +				goto out_retry;
>> +			}
>> +
>> +			if (sibling->over) {
>> +				u64 budget_us =
>> +					DIV_ROUND_UP_ULL(unused_us *
>> +							 sibling->weight,
>> +							 over_weights);
>> +				sibling->per_s_budget_us += budget_us;
>> +				sibling->over = sibling->active_us  >
>> +						sibling->per_s_budget_us;
>> +			}
>> +
>> +			css_put(css);
>> +		}
>> +
>> +		css_put(node);
>> +	}
>> +
>> +	/*
>> +	 * 4th pass - send out over/under budget notifications.
>> +	 */
>> +	css_for_each_descendant_post(node, &root->css) {
>> +		struct drm_cgroup_state *drmcs = css_to_drmcs(node);
>> +
>> +		if (!css_tryget_online(node))
>> +			goto out_retry;
>> +
>> +		if (drmcs->over || drmcs->over_budget)
>> +			signal_drm_budget(drmcs,
>> +					  drmcs->active_us,
>> +					  drmcs->per_s_budget_us);
>> +		drmcs->over_budget = drmcs->over;
>> +
>> +		css_put(node);
>> +	}
> 
> It keeps bothering me that the distribution logic has no memory. Maybe this
> is good enough for coarse control with long cycle durations but it likely
> will get in trouble if pushed to finer grained control. State keeping
> doesn't require a lot of complexity. The only state that needs tracking is
> each cgroup's vtime and then the core should be able to tell specific
> drivers how much each cgroup is over or under fairly accurately at any given
> time.
> 
> That said, this isn't a blocker. What's implemented can work well enough
> with coarse enough time grain and that might be enough for the time being
> and we can get back to it later. I think Michal already mentioned it but it
> might be a good idea to track active and inactive cgroups and build the
> weight tree with only active ones. There are machines with a lot of mostly
> idle cgroups (> tens of thousands) and tree wide scanning even at low
> frequency can become a pretty bad bottleneck.

Right, that's the kind of experience (tens of thousands) I was missing, 
thank you. Another one item on my TODO list then but I have a question 
first.

When you say active/inactive - to what you are referring in the cgroup 
world? Offline/online? For those my understanding was offline was a 
temporary state while css is getting destroyed.

Also, I am really postponing implementing those changes until I hear at 
least something from the DRM community.

Regards,

Tvrtko
