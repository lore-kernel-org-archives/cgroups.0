Received: from mta1.migadu.com (out-238.mta1.migadu.com [95.215.58.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A0850E58F
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 13:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069446; cv=none; b=HxVkOV6AWUyTM/Dx7glYCsFOl53eDwQKj6aqTvT4Qtqq38lLkUHbL3dQZqmU936EOfZ7LCm/N2cHtShIkCgymzmL90/mGqnQEEyWu0JZL6hb5xn07dt/cXYV9xszO/Rc2ePKopFEU9ow/MaQVXmWtX2SMdYvsc2BaNdRZ542vHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069446; c=relaxed/simple;
	bh=j0FM6knfQCQongDtRedHfCCQ/tTyakNICVlk5MG6c+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+f9zpCKFUs70tgHOFtNj6FFnFVADT2kgILsrZgBCII8goSJ1dqEu6CMNlrX4Dh47LdeYwJMtfAsIkBhHwe3kufW1hn25TjjQPwp0LrQvAwlREYfOGgWeCBIAMd8UN6j/0jyFcrdfacsgv6QG3yANEBZQhGQTGe0HbgMjwzk11A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=txEekj92; arc=none smtp.client-ip=95.215.58.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="txEekj92"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j0FM6knfQCQongDtRedHfCCQ/tTyakNICVlk5MG6c+g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792069442; v=1; x=1792674242;
 b=txEekj921oHsbIKHyfw7u0zUqxBd8LxnZ0892bz06JuLQtaqdQDw8AcK/W3svBUxj7/A6Bry
 UUX4KlC5slaLWOfqG/rDTJWbtb1s7gAOJxrmi0jfGg19TAA5yvQg7O/18/iJsacCKqxoWYa/ZYP
 w0S9vaKkvudWE50tnvyDyta0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2d4dd912bfaf673b;
	Thu, 15 Oct 2026 13:04:02 +0000
X-Mizu-Trace-ID: 2d4dd912bfaf673b
X-Migadu-Flow: FLOW_OUT
Message-ID: <0cbe9b1e-dbee-420f-ac44-e2ecac2ac440@linux.dev>
Date: Thu, 15 Oct 2026 21:03:58 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v3 2/9] cgroup/cpuset: Consolidate
 isolated_cpus_can_update() into prstate_housekeeping_conflict()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20261014140548.575122-1-longman@redhat.com>
 <20261014140548.575122-3-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261014140548.575122-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/14 22:05, Waiman Long 写道:
> The isolated_cpus_can_update() and prstate_housekeeping_conflict() are
> checking different aspects of upcoming cpumask changes that may conflict
> with the current setting of the housekeeping cpumasks. There are places
> where both are called together. There are also places where only one
> of them is called. That inconsistency can contribute to missing check
> where invalid cpumask changes may be allowed to move forward.
> 
> Fix that by consolidating isolated_cpus_can_update() into
> prstate_housekeeping_conflict() and call prstate_housekeeping_conflict()
> in all the places where either one of them or both are called. The
> exception is the validate_partition() function where the
> prstate_housekeeping_conflict() call is removed. It is because
> validate_partition() is called only from partition_cpus_change()
> where prstate_housekeeping_conflict() will be called from either
> remote_cpus_update() or update_parent_effective_cpumask() with
> partcmd_update if not for partition invalidatation or disablement.
> 
> Now prstate_housekeeping_conflict() will be called in the following
> locations:
>  - when a partition is enabled in remote_partition_enable() or in
>    update_parent_effective_cpumask() with partcmd_enable*.
>  - when a cpumask is updated in remote_cpus_update() or in
>    update_parent_effective_cpumask() with partcmd_update.
>  - when a partition state changes from root to isolated or vice versa
>    in update_prstate().
> 
> Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
> Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 146 +++++++++++++++++++++--------------------
>  1 file changed, 75 insertions(+), 71 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 6b5c870e5607..2b9aefc0edb8 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1353,65 +1353,85 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>  }
>  
>  /*
> - * isolated_cpus_can_update - check for isolated & nohz_full conflicts
> - * @add_cpus: cpu mask for cpus that are going to be isolated
> - * @del_cpus: cpu mask for cpus that are no longer isolated, can be NULL
> - * Return: false if there is conflict, true otherwise
> - *
> - * If nohz_full is enabled and we have isolated CPUs, their combination must
> - * still leave housekeeping CPUs.
> + * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
> + * @new_prs: new partition root state to be checked
> + * @parent_prs: Parent partition root state
> + * @add_cpus: additional CPUs to be added to current cpuset
> + * @del_cpus: CPUs to be removed from current cpuset, can be NULL
> + * Return: true if there is conflict, false otherwise
>   *
> - * TBD: Should consider merging this function into
> - *      prstate_housekeeping_conflict().
> + * There are two different housekeeping conflicts to be checked:
> + * 1) If new_prs is PRS_ROOT, none of the @add_cpus can be a boot-time isolated
> + *    CPU. IOW, the whole @add_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
> + * 2) If nohz_full is enabled and we have isolated CPUs, their combination must
> + *    still leave housekeeping CPUs. This check is only needed if new_prs
> + *    differs from parent_prs and one of them is PRS_ISOLATED.
>   */
> -static bool isolated_cpus_can_update(struct cpumask *add_cpus,
> -				     struct cpumask *del_cpus)
> +static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
> +					  struct cpumask *add_cpus,
> +					  struct cpumask *del_cpus)
>  {
>  	cpumask_var_t full_hk_cpus;
> -	int res = true;
> +	int res;
>  
> -	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
> -		return true;
> +	WARN_ON_ONCE(parent_prs <= 0);
> +	if (!new_prs)
> +		return false;
> +
> +	/*
> +	 * For a currently invalid partition root state, do the check assuming
> +	 * that it may be converted back to valid.
> +	 *
> +	 * There are code paths where an invalid partition may be reverted back
> +	 * to a valid partition but we still need to run the housekeeping check
> +	 * before the conversion happens to make sure the switch is valid. We
> +	 * can either do the negative to positive PRS switch individually in all
> +	 * these code paths or do it here which I think will make the code a bit
> +	 * easier to read.
> +	 */
> +	if (new_prs < 0)
> +		new_prs = -new_prs;
>  
> -	if (del_cpus && cpumask_weight_and(del_cpus,
> -			housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)))
> +	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
> +	    !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>  		return true;
>  
> -	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
> +	/*
> +	 * Exit 2nd check early and return false if
> +	 * 1) there is no boot time isolated nohz_full CPU
> +	 * 2) new_prs is PRS_ROOT, parent_prs is PRS_ISOLATED and no CPU will
> +	 *    be returned back to the parent.
> +	 */
> +	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
> +	    (!del_cpus && (new_prs == PRS_ROOT) && (parent_prs == PRS_ISOLATED)))
> +		return false;
> +
> +	/*
> +	 * Now make sure that @add_cpus contains new CPUs to be isolated and
> +	 * @del_cpus contains isolated CPUs to be un-isolated.
> +	 * With the guards above, @add_cpus can't be NULL after the swap.
> +	 */
> +	if (parent_prs == PRS_ISOLATED)
> +		swap(add_cpus, del_cpus);
> +
> +	if (del_cpus &&
> +	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
> +				   cpu_active_mask) < nr_cpu_ids))
>  		return false;
>  
> +	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
> +		return true;
> +
>  	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
>  		    housekeeping_cpumask(HK_TYPE_DOMAIN));
>  	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
>  	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
> -	if (!cpumask_weight_andnot(full_hk_cpus, add_cpus))
> -		res = false;
> +	res = !cpumask_weight_andnot(full_hk_cpus, add_cpus);
>  
>  	free_cpumask_var(full_hk_cpus);
>  	return res;
>  }
>  
> -/*
> - * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
> - * @prstate: partition root state to be checked
> - * @new_cpus: cpu mask
> - * Return: true if there is conflict, false otherwise
> - *
> - * CPUs outside of HK_TYPE_DOMAIN_BOOT, if defined, can only be used in an
> - * isolated partition.
> - */
> -static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
> -{
> -	if (!housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
> -		return false;
> -
> -	if ((prstate != PRS_ISOLATED) &&
> -	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
> -		return true;
> -
> -	return false;
> -}
> -
>  /*
>   * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
>   *
> @@ -1593,9 +1613,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>  		return PERR_INVCPUS;
>  	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
>  		return PERR_NOCPUS;
> -	if (((new_prs == PRS_ISOLATED) &&
> -	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
> -	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
> +	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
>  		return PERR_HKEEPING;
>  
>  	spin_lock_irq(&callback_lock);
> @@ -1697,8 +1715,8 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>  		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
>  			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
>  			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
> -		else if ((prs == PRS_ISOLATED) &&
> -			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
> +		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
> +						       tmp->addmask, tmp->delmask))
>  			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
>  		if (cs->prs_err)
>  			goto invalidate;
> @@ -1840,11 +1858,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		if (cpumask_empty(xcpus))
>  			return PERR_INVCPUS;
>  
> -		if (prstate_housekeeping_conflict(new_prs, xcpus))
> -			return PERR_HKEEPING;
> -
> -		if ((new_prs == PRS_ISOLATED) && (new_prs != parent_prs) &&
> -		    !isolated_cpus_can_update(xcpus, NULL))
> +		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
>  			return PERR_HKEEPING;
>  
>  		if (tasks_nocpu_error(parent, cs, xcpus))
> @@ -1917,20 +1931,12 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		}
>  
>  		/*
> -		 * TBD: Invalidate a currently valid child root partition may
> -		 * still break isolated_cpus_can_update() rule if parent is an
> -		 * isolated partition.
> +		 * Check for housekeeping conflicts
>  		 */
> -		if (is_partition_valid(cs) && (old_prs != parent_prs)) {
> -			if ((parent_prs == PRS_ROOT) &&
> -			    /* Adding to parent means removing isolated CPUs */
> -			    !isolated_cpus_can_update(tmp->delmask, tmp->addmask))
> -				part_error = PERR_HKEEPING;
> -			if ((parent_prs == PRS_ISOLATED) &&
> -			    /* Adding to parent means adding isolated CPUs */
> -			    !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
> -				part_error = PERR_HKEEPING;
> -		}
> +		if (is_partition_valid(cs) &&
> +		    prstate_housekeeping_conflict(old_prs, parent_prs,
> +						  tmp->delmask, tmp->addmask))
> +			part_error = PERR_HKEEPING;
>  
>  		/*
>  		 * The new CPUs to be removed from parent's effective CPUs
> @@ -2400,10 +2406,6 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>  	if (cpumask_empty(trialcs->effective_xcpus))
>  		return PERR_INVCPUS;
>  
> -	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
> -					  trialcs->effective_xcpus))
> -		return PERR_HKEEPING;
> -
>  	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
>  		return PERR_NOCPUS;
>  
> @@ -2420,7 +2422,7 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>   * CPU modifications may cause a partition to be disabled or require state updates.
>   */
>  static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
> -					struct tmpmasks *tmp)
> +				  struct tmpmasks *tmp)
>  {
>  	enum prs_errcode prs_err;
>  
> @@ -2920,13 +2922,15 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  			err = remote_partition_enable(cs, new_prs, &tmpmask);
>  		}
>  	} else if (old_prs && new_prs) {
> +		int parent_prs = is_remote_partition(cs)
> +				 ? PRS_ROOT : parent->partition_root_state;
> +
>  		/*
>  		 * A change in load balance state only, no change in cpumasks.
>  		 * Need to update isolated_cpus.
>  		 */
> -		if (((new_prs == PRS_ISOLATED) &&
> -		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
> -		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
> +		if (prstate_housekeeping_conflict(new_prs, parent_prs,
> +						  cs->effective_xcpus, NULL))
>  			err = PERR_HKEEPING;
>  		else
>  			isolcpus_updated = true;

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
