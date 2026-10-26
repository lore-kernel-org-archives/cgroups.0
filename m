Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792996764;
	b=yegLIH0nTGeeEcgTSU9Pm6IOiGZMl73f3gPlNAm2lisiGEcXDbMCLp1Rok9rlASxNL+d
	 kPIjgJtlqxrQs+KJJSvsJFZIuwuXONkZDzba+U6xnUa+t+cpy+tPDWt1cMtkZ4xLRGcrF
	 UyTiM2WDmUY+8dLFTzeMDjD6cckZr+S8ODPeeSQUS7Nbu1K8zwFpSjAIPpsAjrk0ELyxq
	 a6yu9ZzpOs7g6XL2KHrF+dza1jQRMkDDSk1pS8uvOMH2XEqi3JXQ5OPpePhOpfrZ7AanA
	 zggegiLVvvE8iDb+mQR+t4/D0stgt2i78qVPEbxzx0mLS7a+Inedk7M054cDIWJdPXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792996764;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=/N/xE84PocqyOAP0Dt4y/I58wEJZRZjEFHwItj6N+Rk=;
	b=JgsevX8mmCkQszUlmepp3+UzI0+79eQepgghkiuAotCs2Yuz2bLJ+aVMzNQUk7k1E2nz
	 Zs3U/DMydavBTN7nS55zm5ymKEwADCJF2bXQB0JfOEWuLT2c/nmMHXlyN+TAeTDPq09aF
	 uxI6xhJ9qu5YDdVQOr2uwdynR1/28yuo5xHQkjgeLHeJNtRWvGhn7Np2aNDgf2F9qYR2l
	 16D34X8C6AU7JcWPRUdusWwkYkDYi3zyMqZbEA6DP5ZNw7S5QAO4CYSD/8AtHuoQVwigJ
	 6+pH0ZJuouH7/KfWABqEfK87+buDjwpQZ4OgGRWD3iDI2+IwaO8Fao4qREComPwCV3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nkVPhuPb;
	arc=none smtp.remote-ip=95.215.58.123
Received: from mta1.migadu.com (out-123.mta1.migadu.com [95.215.58.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9557E606A31A
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 06:39:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9557E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nkVPhuPb
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6a75/GLo+zgQm/2IZiuenZ69fWTStQnvKmbm4FFx2Ro=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792996761; v=1; x=1793601561;
 b=nkVPhuPbcoT5mqNdCwKhUf7FJ0WYcSOasvtkJBy0lyAAufKDbgtACFXknghxoEGxSD0+FLuI
 g/tUhnHsn4akwtpp2xKOm3EmB1RUM4XMhieTKzFNAifnDCzo1thJhjXY8mh/pM2IsXo4YdTuQmX
 wJsdBCG4UaHb+MHRTugrZ1iY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e717e60d4673babe;
	Mon, 26 Oct 2026 06:39:21 +0000
X-Mizu-Trace-ID: e717e60d4673babe
X-Migadu-Flow: FLOW_OUT
Message-ID: <b6b32541-7add-48b4-af00-af276c8b016f@linux.dev>
Date: Mon, 26 Oct 2026 14:39:14 +0800
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
Subject: Re: [PATCH-next v3 02/11] cgroup/cpuset: Properly compute effective
 xcpus in update_parent_effective_cpumask()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261025214449.310715-1-longman@redhat.com>
 <20261025214449.310715-3-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261025214449.310715-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/26 05:44, Waiman Long 写道:
> Since the introduction of cpuset.cpus.exclusive in commit
> e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2"), a
> compute_effective_exclusive_cpumask() helper which is later renamed to
> compute_excpus() is added to compute the effective xcpus of a partition
> root. However update_parent_effective_cpumask() is not updated in all
> proper places to use the new helper to check if a given cpuset should
> remain a valid partition root. This can cause a cpuset to incorrectly
> remain a valid partition root even if no effective xcpus is left.
> 
> Fix that problem by using compute_excpus() to compute the effective xcpus
> into delmask in all cases except partcmd_disable, partcmd_invalidate
> or partcmd_update with newmask set and use it for tasks_nocpu_error()
> check as well as checking its emptiness. This enables us to catch invalid
> partition root more accurately in update_parent_effective_cpumask().
> 
> In the case of partcmd_update with newmask set, the passed in new
> effective xcpus value will directly be used in the tasks_nocpu_error()
> check without relying on old data in the cpuset.
> 
> For the partcmd_update with NULL newmask case, the cpu exclusivity test
> there is also relaxed to be performed only if exclusive_cpus is empty.
> 
> Some test case are added to test_cpuset_prs.sh for invalidating a
> partition root due to its effective xcpus becoming empty as well as
> making sure that an invalid partition can only be revived when exclusive
> CPUs are available agin.
> 
> Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c                        | 87 ++++++++++---------
>  .../selftests/cgroup/test_cpuset_prs.sh       | 11 +++
>  2 files changed, 56 insertions(+), 42 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index bbd44782d4bf..b850aba4d907 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1795,7 +1795,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>   * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
>   * @cs:      The cpuset that requests change in partition root state
>   * @cmd:     Partition root state change command
> - * @newmask: Optional new cpumask for partcmd_update
> + * @newmask: Optional new effective xcpus for partcmd_update
>   * @tmp:     Temporary addmask and delmask
>   * Return:   0 or a partition root state error code
>   *
> @@ -1810,11 +1810,11 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>   * given back to parent's effective_cpus. 0 will always be returned.
>   *
>   * For partcmd_update, if the optional newmask is specified, the cpu list is
> - * to be changed from effective_xcpus to newmask. Otherwise, effective_xcpus is
> - * assumed to remain the same. The cpuset should either be a valid or invalid
> - * partition root. The partition root state may change from valid to invalid
> - * or vice versa. An error code will be returned if transitioning from
> - * invalid to valid violates the exclusivity rule.
> + * to be changed from effective_xcpus to newmask. Otherwise, effective_xcpus
> + * will be computed and a valid partition will be invalidated if it is the new
> + * cpumask is empty. The cpuset should either be a valid or invalid partition
> + * root. The partition root state may change from valid to invalid or vice
> + * versa.
>   *
>   * For partcmd_invalidate, the current partition will be made invalid.
>   *
> @@ -1837,7 +1837,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  	int deleting;	/* Deleting cpus from parent's effective_cpus	*/
>  	int old_prs, new_prs;
>  	int part_error = PERR_NONE;	/* Partition error? */
> -	struct cpumask *xcpus = user_xcpus(cs);
>  	int parent_prs = parent->partition_root_state;
>  	bool nocpu;
>  
> @@ -1880,30 +1879,30 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  	if (!newmask && xcpus_empty(cs))
>  		return PERR_CPUSEMPTY;
>  
> -	nocpu = tasks_nocpu_error(parent, cs, xcpus);
> +	/*
> +	 * Except for partcmd_disable and non-NULL newmask, use delmask
> +	 * to compute the current effective xcpus value and use it for
> +	 * tasks_nocpu_error check.
> +	 */
> +	if ((cmd != partcmd_disable) && !newmask) {
> +		compute_excpus(cs, tmp->delmask);
> +		nocpu = tasks_nocpu_error(parent, cs, tmp->delmask);
> +	}
>  
>  	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
> -		/*
> -		 * Need to call compute_excpus() in case
> -		 * exclusive_cpus not set. Sibling conflict should only happen
> -		 * if exclusive_cpus isn't set.
> -		 */
> -		xcpus = tmp->delmask;
> -		if (compute_excpus(cs, xcpus))
> -			WARN_ON_ONCE(!cpumask_empty(cs->exclusive_cpus));
>  		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
>  
>  		/*
>  		 * Enabling partition root is not allowed if its
>  		 * effective_xcpus is empty.
>  		 */
> -		if (cpumask_empty(xcpus))
> +		if (cpumask_empty(tmp->delmask))
>  			return PERR_INVCPUS;
>  
> -		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
> +		if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, NULL))
>  			return PERR_HKEEPING;
>  
> -		if (tasks_nocpu_error(parent, cs, xcpus))
> +		if (nocpu)
>  			return PERR_NOCPUS;
>  
>  		/*
> @@ -1915,16 +1914,14 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		 *
>  		 * Warn if it is not the case.
>  		 */
> -		cpumask_and(tmp->new_cpus, xcpus, cpu_active_mask);
> +		cpumask_and(tmp->new_cpus, tmp->delmask, cpu_active_mask);
>  		WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus, parent->effective_cpus));
> -
>  		deleting = true;
>  	} else if (cmd == partcmd_disable) {
>  		/*
>  		 * May need to add cpus back to parent's effective_cpus
>  		 * (and maybe removed from subpartitions_cpus/isolated_cpus)
> -		 * for valid partition root. xcpus may contain CPUs that
> -		 * shouldn't be removed from the two global cpumasks.
> +		 * for valid partition root.
>  		 */
>  		if (is_partition_valid(cs)) {
>  			cpumask_copy(tmp->addmask, cs->effective_xcpus);
> @@ -1944,8 +1941,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  			goto write_error;
>  		}
>  
> -		/* Check newmask again, whether cpus are available for parent/cs */
> -		nocpu |= tasks_nocpu_error(parent, cs, newmask);
> +		/* Check newmask whether cpus are available for parent/cs */
> +		nocpu = tasks_nocpu_error(parent, cs, newmask);
>  
>  		/*
>  		 * partcmd_update with newmask:
> @@ -2000,7 +1997,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		/*
>  		 * partcmd_update w/o newmask
>  		 *
> -		 * delmask = effective_xcpus & parent->effective_cpus
> +		 * delmask = newly computed effective xcpus value
>  		 *
>  		 * This can be called from:
>  		 * 1) update_cpumasks_hier()
> @@ -2012,7 +2009,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		 * A partition error happens when parent has tasks and all
>  		 * its effective CPUs will have to be distributed out.
>  		 */
> -		if (nocpu) {
> +		if (nocpu || cpumask_empty(tmp->delmask)) {
>  			part_error = PERR_NOCPUS;
>  			if (is_partition_valid(cs))
>  				adding = cpumask_and(tmp->addmask,
> @@ -2025,38 +2022,44 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  				cpumask_copy(tmp->addmask, cs->effective_xcpus);
>  				adding = true;
>  			}
> -		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
> -			   cpumask_subset(xcpus, parent->effective_xcpus)) {
> +		} else if (is_partition_invalid(cs)) {
>  			struct cgroup_subsys_state *css;
>  			struct cpuset *child;
>  			bool exclusive = true;
>  
>  			/*
>  			 * Convert invalid partition to valid has to pass the
> -			 * cpu exclusivity test as well as the housekeeping
> -			 * check.
> +			 * cpu exclusivity test when cpuset.cpus.exclusive is
> +			 * empty as well as the housekeeping check.
>  			 */
>  			if (prstate_housekeeping_conflict(cs->partition_root_state,
> -							  parent_prs, xcpus, NULL)) {
> +							  parent_prs, tmp->delmask, NULL)) {
>  				part_error = PERR_HKEEPING;
>  				goto write_error;
>  			}
> -			rcu_read_lock();
> -			cpuset_for_each_child(child, css, parent) {
> -				if (child == cs)
> -					continue;
> -				if (!cpusets_are_exclusive(cs, child)) {
> -					exclusive = false;
> -					break;
> +			if (cpumask_empty(cs->exclusive_cpus)) {
> +				rcu_read_lock();
> +				cpuset_for_each_child(child, css, parent) {
> +					if (child == cs)
> +						continue;
> +					if (!cpusets_are_exclusive(cs, child)) {
> +						exclusive = false;
> +						break;
> +					}
>  				}
> +				rcu_read_unlock();
>  			}
> -			rcu_read_unlock();
>  			if (exclusive)
> -				deleting = cpumask_and(tmp->delmask,
> -						xcpus, parent->effective_cpus);
> +				deleting = !cpumask_empty(tmp->delmask);
>  			else
>  				part_error = PERR_NOTEXCL;
>  		}
> +		/*
> +		 * When both cs and parent remain valid, parent's
> +		 * compute_partition_effective_cpumask() call would have removed
> +		 * cs's effective_xcpus from the parent's effective_cpus. So
> +		 * there is no need to adjust parent's effective_cpus here.
> +		 */
>  	}
>  
>  write_error:
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index d04aad697b96..8bdda955b4a7 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -359,6 +359,8 @@ TEST_MATRIX=(
>  								       A1:P0|A2:P1|A3:P2|B1:P1 2-4|3"
>  	"  C1-6:P1 C3-6:P1 C5-6:P1 .      .      P2      .      .    0 A1:1-2|A2:3-6|A3:5-6 \
>  								       A1:P1|A2:P2|A3:P-1 3-6"
> +	"  C1-6:P2 C3-6:P2 C3-4:P2 .      .     C5-6     .      .    0 A1:1-4|A2:5-6|A3:5-6 \
> +								       A1:P2|A2:P2|A3:P-2 1-6"
>  	" C1-4:X2-4 C2-4:X3-4:P1 C3-4:X4:P2 \
>  				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
>  								       A1:P0|A2:P-1|A3:P-2 ."
> @@ -427,6 +429,10 @@ TEST_MATRIX=(
>  	# cpuset.cpus is allowed, but those extra CPUs are ignored.
>  	"  C2-3:P1   C3:P1  .      .      .     C2-4    .      .     0 A1:|A2:2-3 A1:P1|A2:P1"
>  
> +	# A child cannot recover until its exclusive CPUs are available again.
> +	" CX1-4:P1 CX3-4:P1 .     .     X1-2     .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
> +	" CX1-4:P1 CX3-4:P1 .     .  X1-2:X1-4   .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"
> +
>  	# Taking away all CPUs from parent or itself if there are tasks
>  	# will make the partition invalid.
>  	"  C2-3:P1   C3:P1  .      .      T     C2-3    .      .     0 A1:2-3|A2:2-3 A1:P1|A2:P-1"
> @@ -503,6 +509,11 @@ TEST_MATRIX=(
>  	"  C1-3:P2 C2:P2    .      .       .     P1     .      .     0 A1:1-3|A2:2 A1:P2|A2:P-1 1-3"
>  	"  C1-3:P2 C2:P1    .      .       .    C2-3    .      .     0 A1:1-3|A2:2-3 A1:P2|A2:P-1 1-3"
>  
> +	# A middle isolated parent shrunk below coverage: the released CPUs of
> +	# an invalidated child stay isolated as a higher ancestor still covers them.
> +	" CX0-4:P2 CX2-4:P2 CX3-4:P2 .     .     X2     .      .     0 A1:0-1,3-4|A2:2|A3:2 \
> +								       A1:P2|A2:P2|A3:P-2 0-4"
> +
>  	#
>  	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>  	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
