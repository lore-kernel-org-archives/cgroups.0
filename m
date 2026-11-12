Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510957;
	b=ufuTSV+u8GNLjP5ggI2F9jp0hN+hRpBwPXyV8Ui3ckGvh7939MwpKQVm41CFq9tUD0bt
	 hwVdwIPcdkbo1olA9uNp0MEJMBamMbHnLSQSTB/i+xPIC3qn5BcFpbJ6zcS5qUR9GgVvH
	 aEozH3u0miVdwhxUitW8ZqJgl5zE4VHwqdoOPeRfW7jx9t6x4wb6F4Y8E2vyXWyR3zS1l
	 xbRD9yc8CrgXUUrN3n2bdP4TieGpWRGtCBYMU5x/I++TL7TMiGWn6B6N9xr6q/c2NvEgD
	 Q2lC3Yf9YVxAHgVMOjeVDUU3SG4n+JQm9KRLeVNGlQqbvF12gHE6ocVdaXSXXlaRv5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510957;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=NW7THZlaf80mvmTuYOTfhqswF2bQb3V1m7VgmwQbFyU=;
	b=g+sINTtbN3FDw1yUeFpdZfnfTECaRosjGnVjUBaAUZubyuoJAC+RZNqx/2MKKXVUamYS
	 YB0dXisQtPQNL3r9NPh2SvkO/jRZdJZVh2VWWbpsbnB5itKsHJuglgcWB8Y2C7/zuUnP7
	 ka7Z/aNg9985hJmXO7Q33pMwr47HIpJh7GcG6Ds7upGH/uK8SarIlTxRI3rchvJb7RxV3
	 kHsRA7X0ue12+sac8+yF+9CRWfz4kgAUWNpDdgtueiSH3nIVgvX2H324L+OvX94NRlTDE
	 t5YlY1nPLw9vVKEl8eUrRudAOPOlxWUPXt0+itJvkv8JZvF3YITSOB4hFUVetpRhVCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YrS6JFmD;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E93606A336
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 19:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64E93606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YrS6JFmD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794510956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NW7THZlaf80mvmTuYOTfhqswF2bQb3V1m7VgmwQbFyU=;
	b=YrS6JFmDP2STEpXouimq82/c1aCgmU9hSdnvD5EwZKhVUVG9cr9LvrytdhZVLGUqKoWSV8
	OorMg/t8xRFsyVlYFJGXnr6DOSL1A2x2KJCCIqgiTG0Xh6d7ThMKdnIkvktHMY7IlSFaZQ
	EXnyxLT0l89fcWPn58Jd/sHw+VP/SE0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-L3EwCWwaMWGAFs1PctNVOg-1; Thu,
 12 Nov 2026 14:15:50 -0500
X-MC-Unique: L3EwCWwaMWGAFs1PctNVOg-1
X-Mimecast-MFC-AGG-ID: L3EwCWwaMWGAFs1PctNVOg_1794510948
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A159518004DA;
	Thu, 12 Nov 2026 19:15:47 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7E590410;
	Thu, 12 Nov 2026 19:15:45 +0000 (UTC)
Message-ID: <5402d139-37bf-408a-b956-6c76b8832710@redhat.com>
Date: Thu, 12 Nov 2026 14:15:44 -0500
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
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261112031931.2815548-1-ridong.chen@linux.dev>
 <20261112031931.2815548-3-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261112031931.2815548-3-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95


On 11/11/26 10:19 PM, Ridong Chen wrote:
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
>    echo 2-3 > P/cpuset.cpus
>    echo 2-3 > P/cpuset.cpus.exclusive
>    echo 2-3 > P/C/cpuset.cpus
>    echo 2 > P/C/cpuset.cpus.exclusive
>    echo root > P/C/cpuset.cpus.partition
>    (a task in P)
>    echo 2-3 > P/C/cpuset.cpus.exclusive
>    cat P/C/cpuset.cpus.partition
>    root invalid (Parent is not a partition root)
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
>   kernel/cgroup/cpuset.c                        | 119 +++++++++---------
>   .../selftests/cgroup/test_cpuset_prs.sh       |   5 +
>   2 files changed, 64 insertions(+), 60 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index c7d4cfb615b7..7e374210c123 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1414,6 +1414,48 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>   	return res;
>   }
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
>   /*
>    * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
>    *
> @@ -1934,18 +1976,10 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
>   		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
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
>   		/*
>   		 * This function will only be called when all the preliminary
> @@ -2428,32 +2462,6 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
>   	return 0;
>   }
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
>   /**
>    * partition_cpus_change - Handle partition state changes due to CPU mask updates
>    * @cs: The target cpuset being modified
> @@ -2467,33 +2475,24 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
>   				  struct tmpmasks *tmp)
>   {
>   	enum prs_errcode prs_err;
> -	int parent_prs = is_remote_partition(cs)
> -		       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
> +	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
>   
>   	if (cs_is_member(cs))
>   		return;
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
>   	if (prs_err) {
>   		WRITE_ONCE(cs->prs_err, prs_err);
>   		trialcs->prs_err = prs_err;
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 1e9e6b4c6f7b..1397ec428c46 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -707,6 +707,11 @@ REMOTE_TEST_MATRIX=(
>   	"  C1-4:P1 C5-6   C1-2     .       C5      .  \
>   	      .      P1    P1      .      O5=0     .     p1:3-4|p2:6|c11:1-2|c12:3-4|c21:6|c22:6 \
>   							 p1:P1|p2:P1|c11:P1"
> +	# Expanding a remote partition should check top cpuset, not its member
> +	# parent, for the no CPU left for tasks error.
> +	"  CX2-3:T  .   C2-3:X2:P1  .       .       .  \
> +	      .      .     X2-3    .       .       .     p1:1,4-7|c11:2-3 \
> +							 p1:P0|c11:P1"
>   )
>   
>   #
LGTM
Reviewed-by: Waiman Long <longman@redhat.com>

