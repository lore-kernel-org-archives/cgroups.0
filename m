Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794473511;
	b=lVOZhdq/UUElAOrpO873HBW+ltLBaiPyJicqaccLrviJXTKgItqH7C+xk7o4AkguQuzo
	 H9Q7GGOgo4M1zvTxk8K0XTpxSUcMxd7qlTPw54DpQaf49UMLuxJuitbF9gtAKBTZrxWB5
	 E7Fz9L0oPiwWad9yg4NCFyFDLD7rOtiX+TJZBFQCQtuWYqCA8u2WRQCmGN2ieqzNsovwd
	 uxRhDtruyycWHmA7TIsl2Eoq+yEJWUJOJiNg7SIVuw3eO8ezOqXr72nufXNojaWOenBGd
	 Wtg38kDZifVxXuf6T/L9X0ovRXeLdmo6PW9XAWfjOzhdcRWHGiWOrxyQwKlR02lx0Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794473511;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=ifd3Ny9pO2imzHx3tZY9omeBo1tLc+ksznp/hcOFanc=;
	b=vGds77m4UY23ZT1Tg9TtgLnU87yfTNvFi2FzUZvXwy9G/VVrl3XjI7a4X1IqYuQ/3V8P
	 Ill/N9fcmM1qfpksdnST1Cj6cTQbx9JukFPL8x5ZYsbw5snoCaUtkZ6xE8hVJSQtxLOaK
	 OHHeh7GVR677R/Iz8UG3ACfjeyvh1Dn0WOkORI2Q5bcH5aWxue4+ozqAq3pUN8ZhIyYIt
	 SKo1Wit4r/TsIzjl8jo3XqpAPMkHc6bqVwG62UCG3b8EnuEWzR6GIskKBevScLhkEHIZc
	 TUraVQZONVeHEVdjHf8PUzibnrSpFn+I+ZsogYErsYRTtnaMz+SL5W6EO4j5/H49hQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Z5w/hPHN";
	arc=none smtp.remote-ip=95.215.58.2
Received: from mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC72606B24F
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 08:51:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DC72606B24F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Z5w/hPHN
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mx9E1e/I3LCYVSIIJ+glyO3DlhIEku7AJQTeqmgZKic=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794473507; v=1; x=1795078307;
 b=Z5w/hPHNqBkIdfcdI3VGvQtN1Gu/r/DrsPHjjpJ/gO5yiMtl4HeYhe78kGfsRDc+85K9eHOk
 d4uxXVUl03LQCXgK7nL+bqgh1TgSm3v7gJhhT0t03G3HqQ3dGoXI8bAjhuVeOkYJh3JAeOpF3lB
 BuLxORa9tK8nRtk3+YQlQSpc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fdb8d4e8cc49206d;
	Thu, 12 Nov 2026 08:51:47 +0000
X-Mizu-Trace-ID: fdb8d4e8cc49206d
X-Migadu-Flow: FLOW_OUT
Message-ID: <5edbb6e7-589a-441a-b82d-99b64d5ecdbe@linux.dev>
Date: Thu, 12 Nov 2026 16:51:32 +0800
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
Subject: Re: [PATCH for-7.4-fixes v4 2/2] cpuset: generalize the
 validate_partition() interface
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261112031931.2815548-1-ridong.chen@linux.dev>
 <20261112031931.2815548-3-ridong.chen@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261112031931.2815548-3-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/12 11:19, Ridong Chen 写道:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Refactor validate_partition() to take the parent partition, the new
> partition root state, the new effective exclusive CPUs and the CPUs to
> be deleted, instead of a trial cpuset. A NULL parent stands for a
> remote partition, whose CPUs come from top_cpuset. This makes the
> interface flexible enough to handle both local and remote partition
> validation.
> 
> This also fixes a false PERR_NOCPUS error when expanding a remote
> partition. The no CPU left for tasks check in partition_cpus_change()
> is done against the cgroup parent, but the CPUs of a remote partition
> come from top_cpuset, not from its parent. For example, on a 4-CPU
> system:
> 
>   echo 2-3 > P/cpuset.cpus
>   echo 2-3 > P/cpuset.cpus.exclusive
>   echo 2-3 > P/C/cpuset.cpus
>   echo 2 > P/C/cpuset.cpus.exclusive
>   echo root > P/C/cpuset.cpus.partition
>   (a task in P)
>   echo 2-3 > P/C/cpuset.cpus.exclusive
>   cat P/C/cpuset.cpus.partition
>   root invalid (Parent is not a partition root)
> 
> The effective_cpus of P is 3, a subset of the new exclusive CPUs 2-3 of
> C, and P has a task, so the expansion is rejected. However, P is not a
> partition root and does not give any CPU to C, and top_cpuset still has
> CPUs 0-1 for the task. Enabling C directly with exclusive CPUs 2-3
> succeeds, as remote_partition_enable() checks top_cpuset instead.
> 
> The no CPU left for tasks check now uses the given parent instead of
> parent_cs(cs), and top_cpuset for a remote partition, as that is where
> its CPUs are taken from.
> 
> The housekeeping conflict check is folded into validate_partition(). It
> is skipped when the parent is not a valid partition root, as @cs can't
> be a valid local partition in that case.
> 
> Use the new interface for local partition enablement in
> update_parent_effective_cpumask() and in partition_cpus_change(),
> replacing the open-coded checks there. The order of the checks is now
> the same for both paths: empty CPUs, housekeeping conflict, then no CPU
> left for tasks.
> 
> Add a test case to test_cpuset_prs.sh for the remote partition
> expansion above.
> 
> Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  kernel/cgroup/cpuset.c                        | 119 +++++++++---------
>  .../selftests/cgroup/test_cpuset_prs.sh       |   5 +
>  2 files changed, 64 insertions(+), 60 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index c7d4cfb615b7..7e374210c123 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1414,6 +1414,48 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>  	return res;
>  }
>  
> +/**
> + * validate_partition - Validate a cpuset partition configuration
> + * @cs: The cpuset to validate
> + * @parent: Parent partition of @cs, NULL for remote partition
> + * @new_prs: The proposed new partition root state
> + * @new_excpus: The new effective exclusive CPUs mask to validate
> + * @del: exclusive CPUs to be deleted from @cs, can be NULL
> + *
> + * A remote partition gets its CPUs from top_cpuset, so top_cpuset is used
> + * as the parent when @parent is NULL.
> + *
> + * The housekeeping check is skipped if @parent is not a valid partition
> + * root as @cs can't be a valid local partition in that case.
> + *
> + * Return: PRS error code (0 if valid, non-zero error code if invalid)
> + */
> +static enum prs_errcode validate_partition(struct cpuset *cs,
> +					   struct cpuset *parent, int new_prs,
> +					   struct cpumask *new_excpus,
> +					   struct cpumask *del)
> +{
> +	int parent_prs;
> +
> +	if (new_prs == PRS_MEMBER)
> +		return PERR_NONE;
> +
> +	if (cpumask_empty(new_excpus))
> +		return PERR_INVCPUS;
> +
> +	if (!parent)
> +		parent = &top_cpuset;
> +	parent_prs = parent->partition_root_state;
> +	if (parent_prs > 0 &&
> +	    prstate_housekeeping_conflict(new_prs, parent_prs, new_excpus, del))
> +		return PERR_HKEEPING;
> +
> +	if (tasks_nocpu_error(parent, cs, new_excpus))
> +		return PERR_NOCPUS;
> +
> +	return PERR_NONE;
> +}
> +
>  /*
>   * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
>   *
> @@ -1934,18 +1976,10 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
>  		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
>  
> -		/*
> -		 * Enabling partition root is not allowed if its
> -		 * effective_xcpus is empty.
> -		 */
> -		if (cpumask_empty(tmp->delmask))
> -			return PERR_INVCPUS;
> -
> -		if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, NULL))
> -			return PERR_HKEEPING;
> -
> -		if (nocpu)
> -			return PERR_NOCPUS;
> +		part_error = validate_partition(cs, parent, new_prs,
> +						tmp->delmask, NULL);
> +		if (part_error)
> +			return part_error;
>  
>  		/*
>  		 * This function will only be called when all the preliminary
> @@ -2428,32 +2462,6 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
>  	return 0;
>  }
>  
> -/**
> - * validate_partition - Validate a cpuset partition configuration
> - * @cs: The cpuset to validate
> - * @trialcs: The trial cpuset containing proposed configuration changes
> - *
> - * If any validation check fails, the appropriate error code is set in the
> - * cpuset's prs_err field.
> - *
> - * Return: PRS error code (0 if valid, non-zero error code if invalid)
> - */
> -static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *trialcs)
> -{
> -	struct cpuset *parent = parent_cs(cs);
> -
> -	if (cs_is_member(trialcs))
> -		return PERR_NONE;
> -
> -	if (cpumask_empty(trialcs->effective_xcpus))
> -		return PERR_INVCPUS;
> -
> -	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
> -		return PERR_NOCPUS;
> -
> -	return PERR_NONE;
> -}
> -
>  /**
>   * partition_cpus_change - Handle partition state changes due to CPU mask updates
>   * @cs: The target cpuset being modified
> @@ -2467,33 +2475,24 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
>  				  struct tmpmasks *tmp)
>  {
>  	enum prs_errcode prs_err;
> -	int parent_prs = is_remote_partition(cs)
> -		       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
> +	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
>  
>  	if (cs_is_member(cs))
>  		return;
>  
> -	prs_err = validate_partition(cs, trialcs);
> -	if (!prs_err && (parent_prs > 0) &&
> -	    !cpumask_empty(trialcs->effective_xcpus)) {
> -		int prs = cs->partition_root_state;
> -
> -		/*
> -		 * Check for housekeeping conflict by passing the whole
> -		 * effective_xcpus as well as those CPUs that are to be
> -		 * removed from cs as delmask.
> -		 */
> -		if (prs > 0)
> -			cpumask_andnot(tmp->delmask, cs->effective_xcpus,
> -				       trialcs->effective_xcpus);
> -		else
> -			cpumask_clear(tmp->delmask);
> -
> -		if (prstate_housekeeping_conflict(prs, parent_prs,
> -						  trialcs->effective_xcpus, tmp->delmask))
> -			prs_err = PERR_HKEEPING;
> -	}
> +	/*
> +	 * Check for housekeeping conflict by passing the whole
> +	 * effective_xcpus as well as those CPUs that are to be
> +	 * removed from cs as delmask.
> +	 */
> +	if (is_partition_valid(cs))
> +		cpumask_andnot(tmp->delmask, cs->effective_xcpus,
> +			       trialcs->effective_xcpus);
> +	else
> +		cpumask_clear(tmp->delmask);
>  
> +	prs_err = validate_partition(cs, parent, trialcs->partition_root_state,
> +				     trialcs->effective_xcpus, tmp->delmask);
>  	if (prs_err) {
>  		WRITE_ONCE(cs->prs_err, prs_err);
>  		trialcs->prs_err = prs_err;
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 1e9e6b4c6f7b..1397ec428c46 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -707,6 +707,11 @@ REMOTE_TEST_MATRIX=(
>  	"  C1-4:P1 C5-6   C1-2     .       C5      .  \
>  	      .      P1    P1      .      O5=0     .     p1:3-4|p2:6|c11:1-2|c12:3-4|c21:6|c22:6 \
>  							 p1:P1|p2:P1|c11:P1"
> +	# Expanding a remote partition should check top cpuset, not its member
> +	# parent, for the no CPU left for tasks error.
> +	"  CX2-3:T  .   C2-3:X2:P1  .       .       .  \
> +	      .      .     X2-3    .       .       .     p1:1,4-7|c11:2-3 \
> +							 p1:P0|c11:P1"
>  )
>  
>  #

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
