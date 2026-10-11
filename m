Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC16255F52
	for <cgroups@vger.kernel.org>; Sun, 11 Oct 2026 05:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791697775; cv=none; b=qs5gNKjHYO2ZwuvwTXwyhaMDZ+AgGSX1QYki50MlacCOxlIKiSfQJ3PzurFiGo7cESWBro15tSHascbyXK8lSzNofgQWdwEyUHEHN4DBWezkIxi/rHP2v+Tpl5RmC0nWhVeGwtJprOm0K/6JHxuFbMOm4dg4W19Sur3E2tK8S30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791697775; c=relaxed/simple;
	bh=gS5Etuu4WIQTaJqIfZ2zQNCFEW0Wd2cr710qmr7iq78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KB9sQ2FNwoFEPxl/wNKLOsD0BTROfdetJ+Ta/WMO+yVYTgsRhQU7u96I8booeYH/ytA33EBTHRg011ZMf0IpwAxDES0z91EcGxpDikPrG3lT5nu/vtV29R2C3Sl1Ik5IUKcMPTOoRD5ETCvFtp4xpUTFPv4yZIoxcMRNXbcQTZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xORIKmiv; arc=none smtp.client-ip=91.218.175.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xORIKmiv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gS5Etuu4WIQTaJqIfZ2zQNCFEW0Wd2cr710qmr7iq78=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791697770; v=1; x=1792302570;
 b=xORIKmivSUagDIgbi8WDd3pN+zXxBAp9QnEnxaVb93eCYtITJY2/fpoMK7SmEXLAdfVWWHX5
 Ytbzy/7kn5xCtrMDBFeW91sMw5M0zoWWurgFwD5zbjGOKKDvBVokYVWHgOdDu5yQ9jXm8ZjWuhA
 +7E9m25grdbC/8D6mxXabpOY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 855e2b9029b1dc76;
	Sun, 11 Oct 2026 05:49:30 +0000
X-Mizu-Trace-ID: 855e2b9029b1dc76
X-Migadu-Flow: FLOW_OUT
Message-ID: <7ec04fe0-994e-44d3-8c20-6732c9f20afd@linux.dev>
Date: Sun, 11 Oct 2026 13:49:23 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 1/6] cgroup/cpuset: Consolidate
 isolated_cpus_can_update() into prstate_housekeeping_conflict()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>
References: <20261010221938.243859-1-longman@redhat.com>
 <20261010221938.243859-2-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261010221938.243859-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Hi，Longman,
在 2026/10/11 06:19, Waiman Long 写道:
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
>  kernel/cgroup/cpuset.c | 123 +++++++++++++++++------------------------
>  1 file changed, 52 insertions(+), 71 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 0ebba2d646c3..f3cebb277a68 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1353,65 +1353,62 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
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
> +	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
> +	    !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>  		return true;
>  
> -	if (del_cpus && cpumask_weight_and(del_cpus,
> -			housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)))
> -		return true;
> +	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
> +	    (new_prs == parent_prs) ||
> +	    (!del_cpus && (new_prs != PRS_ISOLATED)) ||
> +	    ((new_prs != PRS_ISOLATED) && (parent_prs != PRS_ISOLATED)))
> +		return false;
>  

When a child partition switches from root to isolated under an isolated
parent, this returns false even though the child's CPUs were not isolated
before the switch.

On a fresh boot with CPUs 0-15 online and nohz_full=2-15:

    # cd /sys/fs/cgroup
    # echo +cpuset > cgroup.subtree_control
    # mkdir A B
    # echo 1-2 > A/cpuset.cpus
    # echo isolated > A/cpuset.cpus.partition
    # echo +cpuset > A/cgroup.subtree_control
    # mkdir A/C
    # echo 1 > A/C/cpuset.cpus
    # echo root > A/C/cpuset.cpus.partition
    # echo 0 > B/cpuset.cpus
    # echo isolated > B/cpuset.cpus.partition
    # cat cpuset.cpus.isolated
    0,2
    # echo isolated > A/C/cpuset.cpus.partition
    # cat A/C/cpuset.cpus.partition
    isolated
    # cat cpuset.cpus.isolated
    0-2

CPU 1 was the last remaining housekeeping CPU: it was in neither the
nohz_full mask nor the cpuset.cpus.isolated mask. The final write isolates
CPU 1 as well, leaving no housekeeping CPU.

Should this check also take the child's previous partition state into
account, rather than just comparing its new state with the parent's state?

Thanks,
Guopeng
> -	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
> +	/*
> +	 * Make sure that @add_cpus contains new CPUs to be isolated and
> +	 * @del_cpus contains isolated CPUs to be un-isolated.
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
> @@ -1593,9 +1590,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
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
> @@ -1697,8 +1692,8 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
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
> @@ -1840,11 +1835,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
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
> @@ -1917,20 +1908,12 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
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
> @@ -2391,10 +2374,6 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
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
> @@ -2411,7 +2390,7 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>   * CPU modifications may cause a partition to be disabled or require state updates.
>   */
>  static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
> -					struct tmpmasks *tmp)
> +				  struct tmpmasks *tmp)
>  {
>  	enum prs_errcode prs_err;
>  
> @@ -2911,13 +2890,15 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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

