Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02701242D62
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 01:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789867339; cv=none; b=PtQ3jfdIt49ZHYeYi9xfrErKMaSeSTqMZc8WsJYDGr6uTJiCLk3rgtBtT3Sj7KEmcn9zzVAyuhNanLMEmV7NlUAcgbjXMFHH3FMQ+kZZHsuLc5UMIIi8DQ/XcuEl3SIU5gQSM8FeMhF9X2pXI4IdN74+EQ6Ei60+ShUYaw6nsZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789867339; c=relaxed/simple;
	bh=zNg6ggh/qrQhEZHMUwzyVw+hyvtM2edzNeoN55FgiT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H6vUq2gtpoC+iipWcxdG4qPl9psAOqDo2+QQ8vuq3400S5tLs79D5NydQ90GyL5TfoQ20ph4aidM/whYse0DYDQRQ456InU2H6JT2uNG9/j88uoZwY2t3Fx4x1KC/IamUZyqCt4KCR7dNhOmxXY0fthZTZXGzUtKGqu6B+s+2vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pTjSBtUw; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pTjSBtUw"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zNg6ggh/qrQhEZHMUwzyVw+hyvtM2edzNeoN55FgiT8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789867333; v=1; x=1790472133;
 b=pTjSBtUwac/wwWZ4km+kX5hIp9UGjkCa+L0wZ8JkDZ84clqk4XcBEHF9HTMLzFQFUSf37FiA
 653VoWa63oWjPSnsG8MF518JFq5tDRMo6vd5vjXyU7PZyaceb+M4MCRTKl5P7nS9Noz73tjPeCP
 ZAvrtdFfF+NmpUGS2Tq6Xp/Y=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c3d1a31c9ccba09c;
	Sun, 20 Sep 2026 01:22:13 +0000
X-Mizu-Trace-ID: c3d1a31c9ccba09c
X-Migadu-Flow: FLOW_OUT
Message-ID: <139d9231-4723-4365-9af7-8142e6581ede@linux.dev>
Date: Sun, 20 Sep 2026 09:22:09 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: prevent overlapping local and remote
 partition creation
To: Hui Peng <benquike@gmail.com>, longman@redhat.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260919221727.3706964-1-benquike@gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260919221727.3706964-1-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2026 6:17 AM, Hui Peng wrote:
> Fix two partition validation bugs in kernel/cgroup/cpuset.c:
> 
> 1. In remote_partition_enable(), check whether the requested effective
>     xcpus intersect parent->subpartitions_cpus so a remote partition
>     cannot claim CPUs already delegated to a local child partition.
> 2. In validate_partition(), verify that enabling a local partition does
>     not overlap CPUs already allocated to an active remote partition.
> 
> Fixes: aa7d3a56a20f ("cpuset: fix warning when disabling remote partition")
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>

Could you please first describe what the issue is and how it can be triggered?
Or is there any reproducer?

> ---
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2538faac9aba..13fad096c494 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -713,7 +713,10 @@ static inline bool cpus_excl_conflict(struct cpuset *trial, struct cpuset *sibli
>   		return true;
>   
>   	/* Exclusive_cpus cannot intersect */
> -	return cpumask_intersects(trial->exclusive_cpus, sibling->exclusive_cpus);
> +	return cpumask_intersects(trial->exclusive_cpus,
> +				  cpumask_empty(sibling->exclusive_cpus)
> +				  ? sibling->effective_xcpus
> +				  : sibling->exclusive_cpus);
>   }
>   
>   static inline bool mems_excl_conflict(struct cpuset *cs1, struct cpuset *cs2)
> @@ -1591,8 +1594,8 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>   	 * above it or remote partition root underneath it is not allowed.
>   	 */
>   	compute_excpus(cs, tmp->new_cpus);
> -	WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus));
>   	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
> +	    cpumask_intersects(tmp->new_cpus, subpartitions_cpus) ||
>   	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
>   		return PERR_INVCPUS;
>   	if (((new_prs == PRS_ISOLATED) &&
> @@ -2411,6 +2414,10 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>   	if (cpumask_empty(trialcs->effective_xcpus))
>   		return PERR_INVCPUS;
>   
> +	if ((parent == &top_cpuset) &&
> +	    cpumask_intersects(trialcs->effective_xcpus, subpartitions_cpus))
> +		return PERR_REMOTE;
> +
>   	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
>   					  trialcs->effective_xcpus))
>   		return PERR_HKEEPING;
> @@ -2970,7 +2977,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>   		 * local or remote partition.
>   		 */
>   		if ((parent == &top_cpuset) &&
> -		    cpumask_intersects(cs->exclusive_cpus, subpartitions_cpus)) {
> +		    cpumask_intersects(user_xcpus(cs), subpartitions_cpus)) {
>   			err = PERR_REMOTE;
>   			goto out;
>   		}

-- 
Best regards
Ridong

