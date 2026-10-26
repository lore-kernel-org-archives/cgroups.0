Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.68
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005715;
	b=WVUOzj8qSt1hFop5fKKXiLP0DhC0w2I++IQIyYrbtLJS1YfOfVDlejXlYWGzkBHiKJ3b
	 r3cH/6sbt7iWtKM1XjJWdcvmBYLFpGsbJzJZ63CDOOxOqEYMNVeZxPw/5ak9bVVXc+lBW
	 T6JGklgPZ9UCQ4ysJ3EpgzupH1HUhtIvkaJ5AnRzw+QORaoH7eVMMRtijKCLh8dgVulkW
	 pazJLHXHplckoKob345zn3915PEYAMml48GhXquugJtaa3L/ykhnzwct1+03T3CqpMyr2
	 ir/Hz1kyGzoYNTdWb7tQ9JiR7hyKvyn7JLR85NA2hc3LWxKQxpEaPs7avqo5tcI9+zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005715;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=E/PvYa+Hv8Cu19xIRMXvOaIkRSINoOuwkFEJjysia+Q=;
	b=u3V9qA0rLPoO5P/0Qv4imalUTiqGPEWUp1GGGgFVYDjoH+8So07TSqfOyfbJf0OsRLHN
	 lPl+f88Nqbx5PF5V/hSTBmA2J0s1FaTbvwFX29TBXulyJPcLJMpyXhxFrJA+npbR0eu4o
	 aMpgFl5dc8ry4tvR++XOb95yU8d0y16gcZbKjG9SrOpzPh4AVoxQDhZVURJWMa8KA9OOL
	 Xd5JrfgBIL7J4pE2qSuQygXNZSzohnulOr9ejyPEnkm4+kAkwvr/dfluXpZdbNr1anDoV
	 r2zdJKOQqJSzLCg1AeT/6dnyqZwQCS5xI3ltgfpsEQieTqhMCWBnyd8t42HGefYJ6sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pM958C3G;
	arc=none smtp.remote-ip=95.215.58.68
Received: from mta1.migadu.com (out-68.mta1.migadu.com [95.215.58.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E477F606A31F
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 09:08:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E477F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pM958C3G
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kezgeJJuXjINaxpCoBFqIa5vpAZOYmHSJIb/3/2Rwts=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793005711; v=1; x=1793610511;
 b=pM958C3GLd1327a2Yh/usQ3e1YaCSHs1yKt3BQrSMukk8yMmFr7hdby/vXVZ/5vadQbGugW+
 ogW8qrsBS2VWNiR+4v+HO6tauANJKZhmqMMsyGFitCP7RNIdohxgQdqwRG810rC97hHkYCdahF+
 7s0dq/Gi/6tgPJMZ8/MD2wpM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d2663e986784d090;
	Mon, 26 Oct 2026 09:08:31 +0000
X-Mizu-Trace-ID: d2663e986784d090
X-Migadu-Flow: FLOW_OUT
Message-ID: <2eb44d83-b5ff-4a6e-94ae-956993da48ea@linux.dev>
Date: Mon, 26 Oct 2026 17:08:18 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v3 10/11] cgroup/cpuset: Relocate
 compute_*effective_cpumask() and compute_effective_nodemask()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261025214449.310715-1-longman@redhat.com>
 <20261025214449.310715-11-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261025214449.310715-11-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/26 05:44, Waiman Long 写道:
> Relocate compute_partition_effective_cpumask(),
> compute_effective_cpumask(), and compute_effective_nodemask() together so
> that compute_effective_cpumask() and compute_partition_effective_cpumask()
> can be further integrated together. There is no functional change.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 212 ++++++++++++++++++++---------------------
>  1 file changed, 106 insertions(+), 106 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3daab2381f04..f37d929616a6 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1135,43 +1135,6 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
>  	css_task_iter_end(&it);
>  }
>  
> -/**
> - * compute_effective_cpumask - Compute the effective cpumask of the cpuset
> - * @new_cpus: the temp variable for the new effective_cpus mask
> - * @cs: the cpuset the need to recompute the new effective_cpus mask
> - * @parent: the parent cpuset
> - *
> - * For v2, the parent's effective_cpus is inherited if cpumask is empty.
> - * The result is valid only if the given cpuset isn't a partition root.
> - */
> -static void compute_effective_cpumask(struct cpumask *new_cpus,
> -				      struct cpuset *cs, struct cpuset *parent)
> -{
> -	bool has_cpus;
> -
> -	has_cpus = cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
> -	if (!has_cpus && is_in_v2_mode())
> -		cpumask_copy(new_cpus, parent->effective_cpus);
> -}
> -
> -/**
> - * compute_effective_nodemask - Compute the effective nodemask of the cpuset
> - * @new_mems: the temp variable for the new effective_mems mask
> - * @cs: the cpuset the need to recompute the new effective_mems mask
> - * @parent: the parent cpuset
> - *
> - * For v2, the parent's effective_mems is inherited if nodemask is empty.
> - */
> -static void compute_effective_nodemask(nodemask_t *new_mems,
> -				       struct cpuset *cs, struct cpuset *parent)
> -{
> -	bool has_mems;
> -
> -	has_mems = nodes_and(*new_mems, cs->mems_allowed, parent->effective_mems);
> -	if (!has_mems && is_in_v2_mode())
> -		nodes_copy(*new_mems, parent->effective_mems);
> -}
> -
>  /*
>   * Commands for update_parent_effective_cpumask
>   */
> @@ -1622,6 +1585,112 @@ static int compute_trialcs_excpus(struct cpuset *trialcs, struct cpuset *cs)
>  	return rm_siblings_excl_cpus(parent, cs, excpus);
>  }
>  
> +/**
> + * compute_partition_effective_cpumask - compute effective_cpus for partition
> + * @cs: partition root cpuset
> + * @new_ecpus: previously computed effective_cpus to be updated
> + *
> + * Compute the effective_cpus of a partition root by scanning effective_xcpus
> + * of child partition roots and excluding their effective_xcpus.
> + *
> + * This has the side effect of invalidating valid child partition roots,
> + * if necessary. Since it is called from either cpuset_hotplug_update_tasks()
> + * or update_cpumasks_hier() where parent and children are modified
> + * successively, we don't need to call update_parent_effective_cpumask()
> + * and the child's effective_cpus will be updated in later iterations.
> + */
> +static void compute_partition_effective_cpumask(struct cpuset *cs,
> +						struct cpumask *new_ecpus)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct cpuset *child;
> +	bool populated = partition_is_populated(cs, NULL);
> +
> +	WARN_ON_ONCE(!is_partition_valid(cs));
> +
> +	/*
> +	 * Check child partition roots to see if they should be invalidated
> +	 * when all the effective_cpus will be used up and cs is populated.
> +	 * It is better to sacrifice a child partition root than invalidating
> +	 * the whole subtree.
> +	 *
> +	 * Return early if the effective_cpus is already empty.
> +	 */
> +	compute_excpus(cs, new_ecpus);
> +	if (!cpumask_and(new_ecpus, new_ecpus, cpu_active_mask))
> +		return;
> +
> +	rcu_read_lock();
> +	cpuset_for_each_child(child, css, cs) {
> +		if (!is_partition_valid(child))
> +			continue;
> +
> +		/*
> +		 * There shouldn't be a remote partition underneath another
> +		 * partition root.
> +		 */
> +		WARN_ON_ONCE(is_remote_partition(child));
> +		if (populated && cpumask_subset(new_ecpus, child->effective_xcpus)) {
> +			int old_prs = child->partition_root_state;
> +			int parent_prs = cs->partition_root_state;
> +
> +			/*
> +			 * Invalidate child partition and update isolated_cpus
> +			 * if necessary.
> +			 */
> +			spin_lock_irq(&callback_lock);
> +			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
> +			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
> +				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
> +						     child->effective_xcpus);
> +			child->partition_root_state = -old_prs;
> +			spin_unlock_irq(&callback_lock);
> +			notify_partition_change(child, old_prs);
> +			continue;
> +		}
> +		cpumask_andnot(new_ecpus, new_ecpus,
> +			       child->effective_xcpus);
> +	}
> +	rcu_read_unlock();
> +}
> +
> +/**
> + * compute_effective_cpumask - Compute the effective cpumask of the cpuset
> + * @new_cpus: the temp variable for the new effective_cpus mask
> + * @cs: the cpuset the need to recompute the new effective_cpus mask
> + * @parent: the parent cpuset
> + *
> + * For v2, the parent's effective_cpus is inherited if cpumask is empty.
> + * The result is valid only if the given cpuset isn't a partition root.
> + */
> +static void compute_effective_cpumask(struct cpumask *new_cpus,
> +				      struct cpuset *cs, struct cpuset *parent)
> +{
> +	bool has_cpus;
> +
> +	has_cpus = cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
> +	if (!has_cpus && is_in_v2_mode())
> +		cpumask_copy(new_cpus, parent->effective_cpus);
> +}
> +
> +/**
> + * compute_effective_nodemask - Compute the effective nodemask of the cpuset
> + * @new_mems: the temp variable for the new effective_mems mask
> + * @cs: the cpuset the need to recompute the new effective_mems mask
> + * @parent: the parent cpuset
> + *
> + * For v2, the parent's effective_mems is inherited if nodemask is empty.
> + */
> +static void compute_effective_nodemask(nodemask_t *new_mems,
> +				       struct cpuset *cs, struct cpuset *parent)
> +{
> +	bool has_mems;
> +
> +	has_mems = nodes_and(*new_mems, cs->mems_allowed, parent->effective_mems);
> +	if (!has_mems && is_in_v2_mode())
> +		nodes_copy(*new_mems, parent->effective_mems);
> +}
> +
>  /*
>   * remote_partition_enable - Enable current cpuset as a remote partition root
>   * @cs: the cpuset to update
> @@ -2145,75 +2214,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  	return 0;
>  }
>  
> -/**
> - * compute_partition_effective_cpumask - compute effective_cpus for partition
> - * @cs: partition root cpuset
> - * @new_ecpus: previously computed effective_cpus to be updated
> - *
> - * Compute the effective_cpus of a partition root by scanning effective_xcpus
> - * of child partition roots and excluding their effective_xcpus.
> - *
> - * This has the side effect of invalidating valid child partition roots,
> - * if necessary. Since it is called from either cpuset_hotplug_update_tasks()
> - * or update_cpumasks_hier() where parent and children are modified
> - * successively, we don't need to call update_parent_effective_cpumask()
> - * and the child's effective_cpus will be updated in later iterations.
> - */
> -static void compute_partition_effective_cpumask(struct cpuset *cs,
> -						struct cpumask *new_ecpus)
> -{
> -	struct cgroup_subsys_state *css;
> -	struct cpuset *child;
> -	bool populated = partition_is_populated(cs, NULL);
> -
> -	WARN_ON_ONCE(!is_partition_valid(cs));
> -
> -	/*
> -	 * Check child partition roots to see if they should be invalidated
> -	 * when all the effective_cpus will be used up and cs is populated.
> -	 * It is better to sacrifice a child partition root than invalidating
> -	 * the whole subtree.
> -	 *
> -	 * Return early if the effective_cpus is already empty.
> -	 */
> -	compute_excpus(cs, new_ecpus);
> -	if (!cpumask_and(new_ecpus, new_ecpus, cpu_active_mask))
> -		return;
> -
> -	rcu_read_lock();
> -	cpuset_for_each_child(child, css, cs) {
> -		if (!is_partition_valid(child))
> -			continue;
> -
> -		/*
> -		 * There shouldn't be a remote partition underneath another
> -		 * partition root.
> -		 */
> -		WARN_ON_ONCE(is_remote_partition(child));
> -		if (populated && cpumask_subset(new_ecpus, child->effective_xcpus)) {
> -			int old_prs = child->partition_root_state;
> -			int parent_prs = cs->partition_root_state;
> -
> -			/*
> -			 * Invalidate child partition and update isolated_cpus
> -			 * if necessary.
> -			 */
> -			spin_lock_irq(&callback_lock);
> -			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
> -			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
> -				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
> -						     child->effective_xcpus);
> -			child->partition_root_state = -old_prs;
> -			spin_unlock_irq(&callback_lock);
> -			notify_partition_change(child, old_prs);
> -			continue;
> -		}
> -		cpumask_andnot(new_ecpus, new_ecpus,
> -			       child->effective_xcpus);
> -	}
> -	rcu_read_unlock();
> -}
> -
>  /*
>   * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
>   * @cs:  the cpuset to consider


Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
