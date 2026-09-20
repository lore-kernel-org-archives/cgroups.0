Received: from mta1.migadu.com (out-99.mta1.migadu.com [95.215.58.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FF2318BB5
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 06:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789885836; cv=none; b=SzNCTSJpTRs65zvGLUso1K3EXPMyXmjQHwXnvhH6gBxH3fB8vlr5poh8eWGYO8Mw50m5vlsHiL65b5BD8Nwsz5fWV8b1of1ktCUGyerJ6cJck0G3rtWt7H99ViSkX4J9EJmvpvdP8lZLmg0JsIKawVXCyFegoZrgIV7aMz+3GuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789885836; c=relaxed/simple;
	bh=Pv9EV8bO6mfi0NkJtb1zwwVK+S+58D5VVIJK1Mf9buw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=a5c94l9BPOigjyKrepvLcxDR04XCcAUZfcvWtNwOREzaf8plczh6adp5VxINt++lrK4hQUsqOppm+wUqKrSvDgdEn+atNcBbBo5L9VWX4WBOs1wLGa+nX8CzocsDcKhu1h371lJia0LCnLM77mAaYOp1Dvj68cbpbOJRX33moA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bJqq4dnD; arc=none smtp.client-ip=95.215.58.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bJqq4dnD"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Pv9EV8bO6mfi0NkJtb1zwwVK+S+58D5VVIJK1Mf9buw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789885830; v=1; x=1790490630;
 b=bJqq4dnDE7JmrGAB/QQj7Pfn+CXGIgD63exg0pKJwDVAgHyVlHqFzCDAy8ZLU5OGuSjWkS3Z
 /FfxZHIlMgdFcgYts84CJLsTaY3NhaS847XF1rs3poNN93/GZkZ/XIhYOqWtaHQm/lrfbClwbVe
 x8YT8IHpZzcVdFg0j6aOWD3c=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 24ca9784efa152a4;
	Sun, 20 Sep 2026 06:30:30 +0000
X-Mizu-Trace-ID: 24ca9784efa152a4
X-Migadu-Flow: FLOW_OUT
Message-ID: <25b72fce-5354-435b-9256-482c15ae7b06@linux.dev>
Date: Sun, 20 Sep 2026 14:30:23 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Guopeng Zhang <guopeng.zhang@linux.dev>
Subject: Re: [PATCH] cgroup/cpuset: prevent overlapping local and remote
 partition creation
To: Hui Peng <benquike@gmail.com>, longman@redhat.com, ridong.chen@linux.dev,
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260919221727.3706964-1-benquike@gmail.com>
Content-Language: en-US
In-Reply-To: <20260919221727.3706964-1-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/20 06:17, Hui Peng 写道:

Hello Hui,

> Fix two partition validation bugs in kernel/cgroup/cpuset.c:
> 
> 1. In remote_partition_enable(), check whether the requested effective
>    xcpus intersect parent->subpartitions_cpus so a remote partition
>    cannot claim CPUs already delegated to a local child partition.
> 2. In validate_partition(), verify that enabling a local partition does
>    not overlap CPUs already allocated to an active remote partition.
> 
> Fixes: aa7d3a56a20f ("cpuset: fix warning when disabling remote partition")
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2538faac9aba..13fad096c494 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -713,7 +713,10 @@ static inline bool cpus_excl_conflict(struct cpuset *trial, struct cpuset *sibli
>  		return true;
>  
>  	/* Exclusive_cpus cannot intersect */
> -	return cpumask_intersects(trial->exclusive_cpus, sibling->exclusive_cpus);
> +	return cpumask_intersects(trial->exclusive_cpus,
> +				  cpumask_empty(sibling->exclusive_cpus)
> +				  ? sibling->effective_xcpus
> +				  : sibling->exclusive_cpus);
>  }
>  
>  static inline bool mems_excl_conflict(struct cpuset *cs1, struct cpuset *cs2)
> @@ -1591,8 +1594,8 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>  	 * above it or remote partition root underneath it is not allowed.
>  	 */
>  	compute_excpus(cs, tmp->new_cpus);
> -	WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus));
>  	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
> +	    cpumask_intersects(tmp->new_cpus, subpartitions_cpus) ||
>  	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
>  		return PERR_INVCPUS;

I have been going through this part of the code repeatedly recently, and I
would like to share one thought.

Should this return PERR_NOCPUS instead?

+	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
+		return PERR_NOCPUS;

In the first reproducer you described in your reply to Ridong:

Minimized reproducer (Scenario 1):
#!/bin/sh
mkdir -p /tmp/cg1
mount -t cgroup2 none /tmp/cg1
echo "+cpuset" > /tmp/cg1/cgroup.subtree_control

mkdir /tmp/cg1/A
echo 1 > /tmp/cg1/A/cpuset.cpus
echo 1 > /tmp/cg1/A/cpuset.cpus.exclusive
echo root > /tmp/cg1/A/cpuset.cpus.partition
echo "+cpuset" > /tmp/cg1/A/cgroup.subtree_control

mkdir /tmp/cg1/A/B
echo 1 > /tmp/cg1/A/B/cpuset.cpus
echo 1 > /tmp/cg1/A/B/cpuset.cpus.exclusive
echo "+cpuset" > /tmp/cg1/A/B/cgroup.subtree_control

mkdir /tmp/cg1/A/B/D
echo 1 > /tmp/cg1/A/B/D/cpuset.cpus
echo 1 > /tmp/cg1/A/B/D/cpuset.cpus.exclusive
echo root > /tmp/cg1/A/B/D/cpuset.cpus.partition

CPU 1 is active, and the requested CPU mask itself is valid. The failure
happens because CPU 1 has already been allocated to partition A, so the
top cpuset can no longer distribute it to the remote partition D.

remote_cpus_update() uses PERR_NOCPUS for the same kind of
subpartitions_cpus conflict:

else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
         cpumask_subset(top_cpuset.effective_cpus,
                        tmp->addmask))
        WRITE_ONCE(cs->prs_err, PERR_NOCPUS);

Would using PERR_NOCPUS here be more appropriate? This would keep the
initial remote-partition enable path consistent with the CPU update path
for an existing remote partition, and it also seems to describe the
failure more accurately: the CPU itself is not invalid, but has already
been allocated to another partition, so the parent can no longer
distribute it downstream.

Thanks,
Guopeng

>  	if (((new_prs == PRS_ISOLATED) &&
> @@ -2411,6 +2414,10 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>  	if (cpumask_empty(trialcs->effective_xcpus))
>  		return PERR_INVCPUS;
>  
> +	if ((parent == &top_cpuset) &&
> +	    cpumask_intersects(trialcs->effective_xcpus, subpartitions_cpus))
> +		return PERR_REMOTE;
> +
>  	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
>  					  trialcs->effective_xcpus))
>  		return PERR_HKEEPING;
> @@ -2970,7 +2977,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  		 * local or remote partition.
>  		 */
>  		if ((parent == &top_cpuset) &&
> -		    cpumask_intersects(cs->exclusive_cpus, subpartitions_cpus)) {
> +		    cpumask_intersects(user_xcpus(cs), subpartitions_cpus)) {
>  			err = PERR_REMOTE;
>  			goto out;
>  		}

