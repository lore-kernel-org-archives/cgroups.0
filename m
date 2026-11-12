Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.31
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794452759;
	b=AkTIQKw1R3EG8zww9KVRPaJc1TP/8OB1k1lTLvM/LfCvVBvD34QtKiNv3QsmZxzMnq37
	 H+djwmPfq38SYNMk9BdKtCzf2RaMP2hgE938fOrRr3YP93CCN0vvOJ1ZF37M7GHyZvndE
	 446xnU1zEP1aUo+qmsNdjcjmyq6YYgeOiphA6mpgAxc3c3lIY7BmoV5seH7fyYLxRILLB
	 S9cm7XeorD7yiiHftrG31njCjBPR8JiZftuNXv1+6BotFHM6bF3ULs/iiu1j4CoJgCytt
	 IolPtFu/IaLP9SlqMtYxV3C5Me7tTJc+7R6jxuiOzGCSeHa5pS91H9HHakd1MBZYhow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794452759;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=+p8m1xXCOpMHRar5y3t+7zIQNJagHd7hv3urfwSVoHY=;
	b=hKLJtQDKEx3H/33oZs6oRHgLTAubCnA5LoI/7kXVruxR17xXTS1cn1br7e/hOx9XIG/c
	 Dk9EwfS7Wfs0GSGIl6KyTruuYS9RcL5N3B1r6x5qw7ueEujsgTJ5CUpg94D77FRP2qJQU
	 A9GwBhbBuRE2Ay1NT5ILdihA2X/RRQGuRapGpHovfH5UPfroZsnSIeeFNo4nk8K3BxmqK
	 S2dtYm6Crd2UtsKG9E57uAHOylLsZR6J38J7lIlO6hBuTnUDhb5SXyKv49mu6LScXecAM
	 J4boXwD5mann5uAOC6vky4V8Oy9nRPbbo5ss3pH+rhfJGCgP3d+Uv0G2oIu8uhlXyEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k5NTGYqx;
	arc=none smtp.remote-ip=91.218.175.31
Received: from mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C14606A31C
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 03:05:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74C14606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k5NTGYqx
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Rscbj3ii3KXkedD9Ow5GtxaK25H7qUUhhe198y9+pqU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794452756; v=1; x=1795057556;
 b=k5NTGYqx+Ej5c09JHDIEjuF6TeZNDFAC5aPg3p/egPViB3BFXWjoVBeosPD4ZLURp1bEo8qk
 whre2bHnmbYq+LUveuBty+VmUUfaoHayUIpRYL7llbz78hogV2VvP/aWw5mkWPwLWKyZ05qMgG3
 JXRSp5lwyNrfJBldK2DoiQSQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 481f0c4052730cb6;
	Thu, 12 Nov 2026 03:05:56 +0000
X-Mizu-Trace-ID: 481f0c4052730cb6
X-Migadu-Flow: FLOW_OUT
Message-ID: <8b256809-79b1-4438-ae3e-4cceb32cd7c2@linux.dev>
Date: Thu, 12 Nov 2026 11:05:50 +0800
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
Subject: Re: [PATCH v4 1/2] cgroup/cpuset: Keep an active housekeeping CPU in
 the top sched domain
To: Guopeng Zhang <guopeng.zhang@linux.dev>, longman@redhat.com
Cc: cgroups@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, mathieu.desnoyers@efficios.com,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
References: <20261111134250.16852-1-guopeng.zhang@linux.dev>
 <20261111134250.16852-2-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261111134250.16852-2-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/2026 9:42 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Boot-isolated CPUs remain in top_cpuset.effective_cpus, but are excluded
> from its scheduling domain. A partition can therefore take all boot
> domain housekeeping CPUs while leaving effective_cpus nonempty. For
> example, on a 32-CPU system with all CPUs online and
> isolcpus=domain,10-31:
> 
>    echo 0-9 > A/cpuset.cpus
>    echo root > A/cpuset.cpus.partition
>    Oops: general protection fault
>    RIP: 0010:build_perf_domains+...
> 
> tasks_nocpu_error() also rejects valid CPU replacements because it does
> not account for CPUs returned by the update. With a fresh cgroup A under
> the same boot configuration:
> 
>    echo 2-31 > A/cpuset.cpus
>    echo isolated > A/cpuset.cpus.partition
>    echo 0-4 > A/cpuset.cpus
>    cat A/cpuset.cpus.partition
>    isolated invalid (Parent unable to distribute cpu downstream)
> 
> The update should return CPUs 5-31 to top_cpuset, including housekeeping
> CPUs 5-9, and leave A valid. This replacement failure also occurs without
> boot isolation and under populated local parents.
> 
> Extend tasks_nocpu_error() to take an explicit mask of CPUs being
> returned and use it for local and remote updates. Require an active
> HK_TYPE_DOMAIN_BOOT CPU to remain in top_cpuset. For other populated
> parents, check within their current exclusive grant so an ancestor
> update cannot credit CPUs that the parent no longer owns.
> 
> CPU hotplug can also empty the top scheduling domain. Pass no returned
> CPUs during its availability check, and only invalidate a partition to
> restore the top domain if it can return an active boot domain
> housekeeping CPU. Still invalidate a populated partition that has no
> active CPU of its own.
> 
> Fixes: 9b496a8bbed9 ("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
> Co-developed-by: Ridong Chen <chenridong@xiaomi.com>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 85 ++++++++++++++++++++++++++++++++++--------
>   1 file changed, 70 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3052413e41e7..85f92ae0c6f4 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1181,18 +1181,54 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
>   }
>   
>   /*
> - * tasks_nocpu_error - Return true if tasks will have no effective_cpus
> + * tasks_nocpu_error - Return true if tasks or the top domain lack active CPUs
> + * @parent: parent partition, NULL for a remote partition
> + * @cs: the partition
> + * @xcpus: exclusive CPUs that @cs will hold after the update
> + * @del_cpus: exclusive CPUs to be returned to @parent, can be NULL
> + *
> + * @del_cpus may include CPUs that are also in @xcpus and will stay in
> + * @cs. They are skipped by the @xcpus check, so callers can pass the
> + * current effective_xcpus of @cs without masking it first.
> + *
> + * top_cpuset always has tasks. Boot-isolated CPUs remain in its
> + * effective_cpus but are excluded from its sched domain, which must
> + * retain an active boot domain housekeeping CPU.
>    */
>   static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
> -			      struct cpumask *xcpus)
> +			      const struct cpumask *xcpus,
> +			      const struct cpumask *del_cpus)
>   {
> +	const struct cpumask *mask;
> +	int cpu;
> +
> +	/* A populated @cs must have an active CPU in @xcpus. */
> +	if (!cpumask_intersects(xcpus, cpu_active_mask) &&
> +	    partition_is_populated(cs, NULL))
> +		return true;
> +
>   	/*
> -	 * A populated partition (cs or parent) can't have empty effective_cpus
> +	 * A populated @parent must keep an active CPU in @mask, either from
> +	 * its effective_cpus or from @del_cpus, that isn't taken by @cs.
>   	 */
> -	return (cpumask_subset(parent->effective_cpus, xcpus) &&
> -		partition_is_populated(parent, cs)) ||
> -	       (!cpumask_intersects(xcpus, cpu_active_mask) &&
> -		partition_is_populated(cs, NULL));
> +	if (!parent)
> +		parent = &top_cpuset;
> +
> +	/* CPUs outside the parent's current grant cannot be returned. */
> +	mask = parent->effective_xcpus;
> +	if (parent == &top_cpuset)
> +		mask = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
> +	else if (!partition_is_populated(parent, cs))
> +		return false;
> +

The mask selection looks right to me. HK_TYPE_DOMAIN_BOOT is the right
one for top_cpuset, since CPUs returned by an isolated child are not in
HK_TYPE_DOMAIN yet. Limiting a local parent to its effective_xcpus also
correctly drops stale CPUs in del_cpus after the parent shrinks.

One corner case: validate_partition() also calls this for an invalid
cs whose parent is not a valid partition. If the parent is an invalid
partition without cpuset.cpus.exclusive, reset_partition_data() has
cleared its effective_xcpus, the loop does nothing, and we return true
when the parent is populated. The child's prs_err then changes from
PERR_INVPARENT to PERR_NOCPUS, which reports the wrong reason. The old
code did not do that. How about:

	  else if (!is_partition_valid(parent) ||
			   !partition_is_populated(parent, cs))
			  return false;
			
The invalid parent case is already reported by PERR_INVPARENT/PERR_NOTPART.

Nit: the comment "Return true if tasks or the top domain lack active
CPUs" doesn't cover local parents. Maybe "Return true if @cs or @parent
would lack active CPUs; for top_cpuset, only active boot domain
housekeeping CPUs count".


> +	for_each_cpu_and(cpu, mask, cpu_active_mask) {
> +		if (cpumask_test_cpu(cpu, xcpus))
> +			continue;
> +		if (cpumask_test_cpu(cpu, parent->effective_cpus) ||
> +		    (del_cpus && cpumask_test_cpu(cpu, del_cpus)))
> +			return false;
> +	}
> +	return true;
>   }
>   
>   static void reset_partition_data(struct cpuset *cs)
> @@ -1724,7 +1760,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>   	 */
>   	compute_excpus(cs, tmp->new_cpus);
>   	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
> -	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
> +	    tasks_nocpu_error(NULL, cs, tmp->new_cpus, NULL))
>   		return PERR_INVCPUS;
>   	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
>   		return PERR_NOCPUS;
> @@ -1828,7 +1864,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>   		if (!capable(CAP_SYS_ADMIN))
>   			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
>   		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
> -			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
> +			 tasks_nocpu_error(NULL, cs, excpus, cs->effective_xcpus))
>   			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
>   		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
>   						       excpus, tmp->delmask))
> @@ -1961,7 +1997,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   	 */
>   	if ((cmd != partcmd_disable) && !newmask) {
>   		compute_excpus(cs, tmp->delmask);
> -		nocpu = tasks_nocpu_error(parent, cs, tmp->delmask);
> +		nocpu = tasks_nocpu_error(parent, cs, tmp->delmask,
> +					  is_partition_valid(cs) ? cs->effective_xcpus : NULL);
>   	}
>   
>   	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
> @@ -2497,7 +2534,9 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>   	if (cpumask_empty(trialcs->effective_xcpus))
>   		return PERR_INVCPUS;
>   
> -	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
> +	if (tasks_nocpu_error(is_remote_partition(cs) ? NULL : parent, cs,
> +			      trialcs->effective_xcpus,
> +			      is_partition_valid(cs) ? cs->effective_xcpus : NULL))
>   		return PERR_NOCPUS;
>   
>   	return PERR_NONE;
> @@ -3997,6 +4036,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	static nodemask_t new_mems;
>   	bool cpus_updated;
>   	bool mems_updated;
> +	bool nocpu;
>   	int partcmd = -1;
>   	struct cpuset *parent;
>   
> @@ -4008,9 +4048,23 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	if (!tmp || !cs->partition_root_state)
>   		goto update_tasks;
>   
> -	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
> -				       (cpumask_empty(&new_cpus) &&
> -					partition_is_populated(cs, NULL)))) {
> +	/* Do not count any CPUs as returned during this hotplug check. */
> +	nocpu = tasks_nocpu_error(is_remote_partition(cs) ? NULL : parent, cs,
> +				  &new_cpus, NULL);
> +	if (nocpu && (parent == &top_cpuset || is_remote_partition(cs))) {
> +		/*
> +		 * Only invalidate a partition for an empty top sched domain if
> +		 * it can return an active boot domain housekeeping CPU. A
> +		 * populated partition with no active CPU must still be invalidated.
> +		 */
> +		cpumask_and(tmp->addmask, cs->effective_xcpus,
> +			    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
> +		if (!cpumask_intersects(tmp->addmask, cpu_active_mask))
> +			nocpu = cpumask_empty(&new_cpus) &&
> +				partition_is_populated(cs, NULL);
> +	}
> +

This is hard to follow. nocpu is computed first and then partly undone,
so that only a partition owning an active housekeeping CPU gets
invalidated.

Do we really need this? When hotplug leaves top_cpuset with no active
CPU, cpuset_handle_hotplug() already clears subpartitions_cpus and
invalidates all the partitions under it. If we handle an empty top
sched domain the same way, this block can go away.

Longman, what do you think?

> +	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) || nocpu)) {
>   		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>   		remote_partition_disable(cs, tmp);
>   		compute_effective_cpumask(&new_cpus, cs, parent);
> @@ -4023,10 +4077,11 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	 * 2) parent is invalid or doesn't grant any cpus to child
>   	 *    partitions.
>   	 * 3) subpartitions_cpus is empty.
> +	 * 4) top_cpuset needs an active boot domain housekeeping CPU from cs.
>   	 */
>   	if (is_local_partition(cs) &&
>   	    (!is_partition_valid(parent) ||
> -	     tasks_nocpu_error(parent, cs, &new_cpus) ||
> +	     nocpu ||
>   	     cpumask_empty(subpartitions_cpus)))
>   		partcmd = partcmd_invalidate;
>   	/*

-- 
Best regards
Ridong

