Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69682EEE91
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 02:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792117113; cv=none; b=TM8+iUpZbmPm466WFT44dXDVzBZXFc/52CRYzMiTX02KQRS0MJVisXa14frlnqggNxkioPyeCTRKu2OY1hfBAEuT9GbXI6gSRwicdqXh+gpwM9zd9cXqg2wevmxkmAMj1HXEhnOka1WEjNMIS3xmqaSuMJabq4qOYzPREwBe5ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792117113; c=relaxed/simple;
	bh=ks5sQzAvABoNIRxdBaTzmfZSRGdmFNus3FIGYRXeTtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nkI3Ua17r8lMdXBhK3PSJCHZnDvOukXM9v80sv2M9E2FgrAhxXN6QX569krCYwHywvh2UkJR3DCeFV0ZHhtT9fc0+KcTaeEeP69fMhfTspQ3vsY8/Z+m3HC1UvhcIwRhFvHKZz2WS13x6iIgZTO1FwitEEblrLdxV2wuBzeZilw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rBd0eV1F; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rBd0eV1F"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ks5sQzAvABoNIRxdBaTzmfZSRGdmFNus3FIGYRXeTtk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792117109; v=1; x=1792721909;
 b=rBd0eV1FHxZbcF6ylJaKIE9Su9TnK6/HMq0nux6fG3N6RMAcoiwXFPyhlpr99PzJqNpKX6Ni
 MVtXTpdQgdatckmcALEVOK0IUdaolPjZOtIfrtifS0SWW6G+o3/WepChF6w3cdWBkEP0SjCRAmW
 mEsJgxq2eVjQ8CtKSJJ5VCmw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b546029e03d10300;
	Fri, 16 Oct 2026 02:18:29 +0000
X-Mizu-Trace-ID: b546029e03d10300
X-Migadu-Flow: FLOW_OUT
Message-ID: <6bf0bfec-1726-41a4-b9ee-aac23da18d19@linux.dev>
Date: Fri, 16 Oct 2026 10:18:25 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v3 3/9] cgroup/cpuset: Consider all the exclusive
 CPUs when doing housekeeping check
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20261014140548.575122-1-longman@redhat.com>
 <20261014140548.575122-4-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261014140548.575122-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/14 22:05, Waiman Long 写道:
> When prstate_housekeeping_conflict() is called to perform housekeeping
> check with cpumask changes, the cpumask changes are passed in via addmask
> and delmask. With this arrangement, the exclusive CPUs owned by the child
> partitions and not affected by the cpumask change, if any, are excluded
> in the analysis. If the current cpuset is an isolated partition with
> root partition children, it is possible the cpumask change will still
> leave active housekeeping CPUs but then no housekeeping CPUs will be
> left when the child partitions are disabled or invalidated.
> 
> As a first step to protect against this possibility, all the exclusive
> CPUs of the cpuset should be considered to be owned by the current cpuset
> when doing housekeeping check. As a result, there is no need to pass in
> separate add_mask and del_mask parameters. They are combined into a single
> new_cpus parameter. The parent_prs parameter can be removed as well.
> 
> With this change, the prstate_housekeeping_conflict() call in
> update_parent_effective_cpumask() with partcmd_update and newmask
> is now duplicative and can be removed. The housekeeping check in
> remote_cpus_update(), however, will still be useful as this function can
> be called directly from update_cpumasks_hier() without going through
> partition_cpus_change(). The update_parent_effective_cpumask() call
> from update_cpumasks_hier() is partcmd_update with no cpumask which
> still have the housekeeping check and so is covered.
> 
> Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 77 ++++++++++++++++--------------------------
>  1 file changed, 30 insertions(+), 47 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2b9aefc0edb8..b2684c98d8c0 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1355,26 +1355,20 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>  /*
>   * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
>   * @new_prs: new partition root state to be checked
> - * @parent_prs: Parent partition root state
> - * @add_cpus: additional CPUs to be added to current cpuset
> - * @del_cpus: CPUs to be removed from current cpuset, can be NULL
> + * @new_cpus: cpu mask to be checked
>   * Return: true if there is conflict, false otherwise
>   *
>   * There are two different housekeeping conflicts to be checked:
> - * 1) If new_prs is PRS_ROOT, none of the @add_cpus can be a boot-time isolated
> - *    CPU. IOW, the whole @add_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
> + * 1) If new_prs is PRS_ROOT, none of the @new_cpus can be a boot-time isolated
> + *    CPU. IOW, the whole @new_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
>   * 2) If nohz_full is enabled and we have isolated CPUs, their combination must
> - *    still leave housekeeping CPUs. This check is only needed if new_prs
> - *    differs from parent_prs and one of them is PRS_ISOLATED.
> + *    still leave housekeeping CPUs.
>   */
> -static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
> -					  struct cpumask *add_cpus,
> -					  struct cpumask *del_cpus)
> +static bool prstate_housekeeping_conflict(int new_prs, struct cpumask *new_cpus)
>  {
>  	cpumask_var_t full_hk_cpus;
>  	int res;
>  
> -	WARN_ON_ONCE(parent_prs <= 0);
>  	if (!new_prs)
>  		return false;
>  
> @@ -1393,30 +1387,18 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>  		new_prs = -new_prs;
>  
>  	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
> -	    !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
> +	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>  		return true;
>  
>  	/*
>  	 * Exit 2nd check early and return false if
>  	 * 1) there is no boot time isolated nohz_full CPU
> -	 * 2) new_prs is PRS_ROOT, parent_prs is PRS_ISOLATED and no CPU will
> -	 *    be returned back to the parent.
> +	 * 2) @new_prs is not PRS_ISOLATED
> +	 * 3) @new_cpus is a subset of isolated_cpus
>  	 */
>  	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
> -	    (!del_cpus && (new_prs == PRS_ROOT) && (parent_prs == PRS_ISOLATED)))
> -		return false;
> -
> -	/*
> -	 * Now make sure that @add_cpus contains new CPUs to be isolated and
> -	 * @del_cpus contains isolated CPUs to be un-isolated.
> -	 * With the guards above, @add_cpus can't be NULL after the swap.
> -	 */
> -	if (parent_prs == PRS_ISOLATED)
> -		swap(add_cpus, del_cpus);
> -
> -	if (del_cpus &&
> -	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
> -				   cpu_active_mask) < nr_cpu_ids))
> +	    (new_prs != PRS_ISOLATED) ||
> +	    cpumask_subset(new_cpus, isolated_cpus))
>  		return false;
>  
>  	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
> @@ -1426,7 +1408,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>  		    housekeeping_cpumask(HK_TYPE_DOMAIN));
>  	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
>  	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
> -	res = !cpumask_weight_andnot(full_hk_cpus, add_cpus);
> +	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
>  

One of my test cases regressed in v3 compared to v2. CPUs 0-15 are online,
with nohz_full=2-15 and no isolcpus:

    # cd /sys/fs/cgroup
    # echo +cpuset > cgroup.subtree_control
    # mkdir A
    # echo 0 > A/cpuset.cpus
    # echo isolated > A/cpuset.cpus.partition
    # cat cpuset.cpus.isolated
    0
    # echo 1 > A/cpuset.cpus
    # cat A/cpuset.cpus.partition
    isolated invalid (partition config conflicts with housekeeping setup)

The last write should release CPU 0 for housekeeping, leaving A as a valid
isolated partition on CPU 1. It looks like the check uses the state before
the update, sees only CPU 1 available for housekeeping, and incorrectly
invalidates A.

thanks,
Guopeng
>  	free_cpumask_var(full_hk_cpus);
>  	return res;
> @@ -1613,7 +1595,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>  		return PERR_INVCPUS;
>  	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
>  		return PERR_NOCPUS;
> -	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
> +	if (prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
>  		return PERR_HKEEPING;
>  
>  	spin_lock_irq(&callback_lock);
> @@ -1715,8 +1697,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>  		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
>  			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
>  			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
> -		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
> -						       tmp->addmask, tmp->delmask))
> +		else if (prstate_housekeeping_conflict(prs, excpus))
>  			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
>  		if (cs->prs_err)
>  			goto invalidate;
> @@ -1796,7 +1777,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  	int old_prs, new_prs;
>  	int part_error = PERR_NONE;	/* Partition error? */
>  	struct cpumask *xcpus = user_xcpus(cs);
> -	int parent_prs = parent->partition_root_state;
>  	bool nocpu;
>  
>  	lockdep_assert_cpuset_lock_held();
> @@ -1858,7 +1838,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		if (cpumask_empty(xcpus))
>  			return PERR_INVCPUS;
>  
> -		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
> +		if (prstate_housekeeping_conflict(new_prs, xcpus))
>  			return PERR_HKEEPING;
>  
>  		if (tasks_nocpu_error(parent, cs, xcpus))
> @@ -1930,14 +1910,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  					       parent->effective_xcpus);
>  		}
>  
> -		/*
> -		 * Check for housekeeping conflicts
> -		 */
> -		if (is_partition_valid(cs) &&
> -		    prstate_housekeeping_conflict(old_prs, parent_prs,
> -						  tmp->delmask, tmp->addmask))
> -			part_error = PERR_HKEEPING;
> -
>  		/*
>  		 * The new CPUs to be removed from parent's effective CPUs
>  		 * must be present.
> @@ -2430,6 +2402,21 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
>  		return;
>  
>  	prs_err = validate_partition(cs, trialcs);
> +	if (!prs_err && !cpumask_empty(trialcs->effective_xcpus)) {
> +		int parent_prs = is_remote_partition(cs)
> +			       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
> +		/*
> +		 * Check for housekeeping CPUs conflict assuming that all
> +		 * the exclusive CPUs belong to the current cpuset. We rely
> +		 * on the fact that effective_xcpus has been set up by
> +		 * compute_trial_excpus() which is called previously in
> +		 * update_cpumask() and update_exclusive_cpumask().
> +		 */
> +		if (parent_prs > 0 &&
> +		    prstate_housekeeping_conflict(trialcs->partition_root_state,
> +						  trialcs->effective_xcpus))
> +			prs_err = PERR_HKEEPING;
> +	}
>  	if (prs_err) {
>  		WRITE_ONCE(cs->prs_err, prs_err);
>  		trialcs->prs_err = prs_err;
> @@ -2922,15 +2909,11 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  			err = remote_partition_enable(cs, new_prs, &tmpmask);
>  		}
>  	} else if (old_prs && new_prs) {
> -		int parent_prs = is_remote_partition(cs)
> -				 ? PRS_ROOT : parent->partition_root_state;
> -
>  		/*
>  		 * A change in load balance state only, no change in cpumasks.
>  		 * Need to update isolated_cpus.
>  		 */
> -		if (prstate_housekeeping_conflict(new_prs, parent_prs,
> -						  cs->effective_xcpus, NULL))
> +		if (prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
>  			err = PERR_HKEEPING;
>  		else
>  			isolcpus_updated = true;

