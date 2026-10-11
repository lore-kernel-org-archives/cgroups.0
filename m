Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AFD36E49B
	for <cgroups@vger.kernel.org>; Sun, 11 Oct 2026 06:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791698749; cv=none; b=sFPDBtyFcibPXlfaE8F1kRAljX6mLHCVsRd9kjtok2pT4NmY6G8OLrNxgwoOi4T7pELj6IGa/olAvMZcK5mwqbzQmo55XczyToZ61+VgeBd9IjuojbWEjCI/xO2G29i0SVNx5FGwOxXyga3bvTbx3GS/Vn6L5eC8ZsbtxxcxaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791698749; c=relaxed/simple;
	bh=XLD13vdTh+nPbO3bsCbikHpH8QFwWZS3n5MpVfOxjIA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OP1VcwSH3/MdDlrrBumgQDBDWDa0ZY3DSntajOh8TbukGXFdSRk+zzKcnIcx1dR6TaKGn1tcEn7wni7fOYUhT3mgIrVB95SoP3ZWYr9kC9Mul8f0QbxCHHtWRMa8w1Ugx44OzztVVxJfo5TQm+5KdXh+N8dVFGBMpow33Jiz7ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RfYLQZBq; arc=none smtp.client-ip=95.215.58.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RfYLQZBq"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XLD13vdTh+nPbO3bsCbikHpH8QFwWZS3n5MpVfOxjIA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791698744; v=1; x=1792303544;
 b=RfYLQZBqGKL1AVlnsm78lVQ0ulxnAJ9Tr56Ds9OW78q59pZYaUnpVMxqNbeGnNggGysZStFz
 ZDYKECOiITK2Gm31VSJ9BKsnQHpq1P0WG7qtOZtIP2+Y3Aeq7Va8s82mDJrvKzi8CWfLBbdw38B
 wwgnPfp0L3qTLiiviM+dZyg0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9a93c669608db274;
	Sun, 11 Oct 2026 06:05:26 +0000
X-Mizu-Trace-ID: 9a93c669608db274
X-Migadu-Flow: FLOW_OUT
Message-ID: <fe08846e-715f-4819-b08d-95ca3e20f725@linux.dev>
Date: Sun, 11 Oct 2026 14:05:20 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 4/6] cgroup/cpuset: Properly disabling partition
 when partition state switching fails
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>
References: <20261010221938.243859-1-longman@redhat.com>
 <20261010221938.243859-5-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261010221938.243859-5-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/11 06:19, Waiman Long 写道:
> Before commit 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full
> don't leave any housekeeping"), the partition state can be freely switched
> from "root" to "isolated" and vice versa. After that commit, the switch
> from "root" to "isolated" can fail if it exhausts all the housekeeping
> CPUs. Later on, the switch from "isolated" to "root" can also fail if
> some of the partition CPUs are boot-time isolated by "isolcpus".
> 
> A local or remote partition is made invalid when the switch fails.
> However there are 2 problems with the existing invalidation code.
> 
>  1) Both the subpartitions_cpus and isolated_cpus are not properly
>     updated.
>  2) In the case of remote partition with remote_partition flag set, it
>     is not cleared.
> 
> Fix this by calling the proper partition disabling function in this case.
> 
> On an x86 test system with boot option "isolcpus=10 cgroup_debug" set
> and more than 16 cores, the following commands were executed after boot.
> 
>   # cd /sys/fs/cgroup
>   # echo +cpuset > cgroup.subtree_control
>   # cat cpuset.cpus.isolated
>   10
>   # mkdir A
>   # echo 10-12 > A/cpuset.cpus
>   # echo isolated > A/cpuset.cpus.partition
>   # cat A/cpuset.cpus.partition
>   isolated
> 
> Before the patch:
> 
>   # echo root > A/cpuset.cpus.partition
>   # cat A/cpuset.cpus.partition
>   root invalid (partition config conflicts with housekeeping setup)
>   # cat cpuset.cpus.isolated .__DEBUG__.cpuset.cpus.subpartitions
>   10-12
>   10-12
> 
> After the patch:
> 
>   # echo root > A/cpuset.cpus.partition
>   # cat A/cpuset.cpus.partition
>   root invalid (partition config conflicts with housekeeping setup)
>   # cat cpuset.cpus.isolated .__DEBUG__.cpuset.cpus.subpartitions
>   10
> 
> Reported-by: Tejun Heo <tj@kernel.org>
> Link: https://lore.kernel.org/lkml/7f4c57b26ad120ab30adf35653f1dd94@kernel.org/
> Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
> Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index fb41cd76add6..df1619d7a701 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2863,6 +2863,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  	struct cpuset *parent = parent_cs(cs);
>  	struct tmpmasks tmpmask;
>  	bool isolcpus_updated = false;
> +	bool disable_partition = false;
>  
>  	if (old_prs == new_prs)
>  		return 0;
> @@ -2920,15 +2921,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  		 */
>  		compute_excpus(cs, tmpmask.new_cpus);
>  		if (prstate_housekeeping_conflict(new_prs, parent_prs,
> -						  tmpmask.new_cpus, NULL))
> +						  tmpmask.new_cpus, NULL)) {
> +			disable_partition = true;
>  			err = PERR_HKEEPING;
> -		else
> +		} else {
>  			isolcpus_updated = true;
> +		}
>  	} else {
>  		/*
>  		 * Switching back to member is always allowed even if it
>  		 * disables child partitions.
>  		 */
> +		disable_partition = true;
> +	}
> +
> +	if (disable_partition) {
>  		if (is_remote_partition(cs))
>  			remote_partition_disable(cs, &tmpmask);
>  		else
> @@ -2937,7 +2944,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  
>  		/*
>  		 * Invalidation of child partitions will be done in
> -		 * update_cpumasks_hier().
> +		 * update_cpumasks_hier() below.
>  		 */
>  	}
>  out:
> @@ -2956,8 +2963,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
>  	spin_unlock_irq(&callback_lock);
>  
> -	/* Force update if switching back to member & update effective_xcpus */
> -	update_cpumasks_hier(cs, &tmpmask, !new_prs);
> +	/* Force update if partition is disabled & update effective_xcpus */
> +	update_cpumasks_hier(cs, &tmpmask, disable_partition);
>  
>  	/* A newly created partition must have effective_xcpus set */
>  	WARN_ON_ONCE(!old_prs && (new_prs > 0)


Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
