Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.238
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795516501;
	b=YrN9d7PcJ9YgE7eg8G7cBEmBaedTSXUfgA4sBS1BwXexaA3gcaX53NT7K65Bz44Opdxu
	 YEoVob6ACEwUYHUDQjCBY2rzpxExWQpDlIrfvcg0ENM5F85GsLnNrAcrHVCAxfdD/wvRG
	 /P7+2A3dMTv1jTl/Ygg5LXPGNgXAhhtQLwFuC73x13xHIL8SsVvqnMxDirrTO9eXwqwwF
	 cjxPqUDXkEbLlf2aGdeFuqwzJUgCZqljDFPvunCBlsybZpLDHbgMKR1Xb3Ja30Aw4e/d5
	 Lyfuk+VMPBhKSCrypSS6uQM7dRLw80KEDuM/lO/uvFt8izmpR/9N+NO3JDCq7ZwptBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795516501;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=E8TKtlO/g2Vvau18zRvilWHUXtmHqgRya704gc35gHo=;
	b=FE67/m/WHt+BP7OW3L8LRNPhS7OGW/TTwJhN/vV+WqI/UkU1iWN2gMRZ2vwLxDEp8C8I
	 qAI+4fzW9eFMJuIfa7aYWAfmT1Uii9pTx128yFpP1XKzrW+ZkVb+aPCg/CtUWM5VdvPcM
	 3ekZDTMb1pfqZuIz5ODxIsKE34t8j6CkcHqMAhpl58JtjW3Hoz6qNYZaWccmdv7Ua9iNK
	 tUKg0PeegiiLNzBRoxZmdFu4/I46vos38HkeC3xhzJJ5p/cpW3cE8btZg4cAn+BbqqYkZ
	 XGJFiOBguPjd2QLa/xbycSk0phKBbuyjCawPmYkuIisHDhxaQcL4/4SKMclWvGBs0EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QHmdxfdT;
	arc=none smtp.remote-ip=95.215.58.238
Received: from mta1.migadu.com (out-238.mta1.migadu.com [95.215.58.238])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ABE606A31E
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 10:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6ABE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QHmdxfdT
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Suno0SlRBQWBmt2uzfjPtzfcYe0F75PFnMbgP8poVtU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795516497; v=1; x=1796121297;
 b=QHmdxfdTzbRx5MbMytt7YbBkYgKHqvmp7tnmQsqcsOSIjH30id72q51Mo5Dkjq0vM+2dfQ92
 ycb7RbFtsDKIfwyBMwF/2SxKxmXXZ0PVma0ngG/CGTHTNXZjC8NlBunWWN22Q6WGI3A2o6twNY2
 v68dizYA6sIOGl6gj27tV4w8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bac6370eabe62822;
	Tue, 24 Nov 2026 10:34:57 +0000
X-Mizu-Trace-ID: bac6370eabe62822
X-Migadu-Flow: FLOW_OUT
Message-ID: <08e4f7bd-37d7-4752-93f3-23fe6d15b1df@linux.dev>
Date: Tue, 24 Nov 2026 18:34:49 +0800
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
Subject: Re: [PATCH v5 05/12] cpuset: use partition_disable() for remote
 partition disablement
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
 <20261114083124.1340140-6-ridong.chen@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261114083124.1340140-6-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/14 16:31, Ridong Chen 写道:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Now that the partition_disable() helper is available, replace the
> existing implementation for remote partition disablement with this
> centralized function to unify the disablement logic.
> 
> remote_partition_disable() is removed and its callers call
> partition_disable() directly. The new partition root state is passed
> in by the caller instead of being derived from cs->prs_err, as only the
> caller knows which state the partition is going to.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  kernel/cgroup/cpuset.c | 57 ++++++------------------------------------
>  1 file changed, 8 insertions(+), 49 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3702e43e95ef..681adcde10e8 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1771,9 +1771,8 @@ static void partition_enable(struct cpuset *cs, struct cpuset *parent,
>   * has its state updated. A valid partition under an invalid parent has
>   * already given back its CPUs, so only the propagation is done.
>   */
> -static void __maybe_unused partition_disable(struct cpuset *cs, int new_prs,
> -					     enum prs_errcode prs_err,
> -					     struct tmpmasks *tmp)
> +static void partition_disable(struct cpuset *cs, int new_prs,
> +			      enum prs_errcode prs_err, struct tmpmasks *tmp)
>  {
>  	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
>  	int old_prs = cs->partition_root_state;
> @@ -1923,48 +1922,6 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>  	return 0;
>  }
>  
> -/*
> - * remote_partition_disable - Remove current cpuset from remote partition list
> - * @cs: the cpuset to update
> - * @tmp: temporary masks
> - *
> - * The effective_cpus is also updated.
> - *
> - * cpuset_mutex must be held by the caller.
> - */
> -static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
> -{
> -	WARN_ON_ONCE(!is_remote_partition(cs));
> -	/*
> -	 * When a CPU is offlined, top_cpuset may end up with no available CPUs,
> -	 * which should clear subpartitions_cpus. We should not emit a warning for this
> -	 * scenario: the hierarchy is updated from top to bottom, so subpartitions_cpus
> -	 * may already be cleared when disabling the partition.
> -	 */
> -	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) &&
> -		     !cpumask_empty(subpartitions_cpus));
> -
> -	spin_lock_irq(&callback_lock);
> -	cs->remote_partition = false;
> -	partition_xcpus_del(cs->partition_root_state, NULL, cs->effective_xcpus);
> -	if (cs->prs_err)
> -		cs->partition_root_state = -cs->partition_root_state;
> -	else
> -		cs->partition_root_state = PRS_MEMBER;
> -
> -	/* effective_xcpus may need to be changed */
> -	compute_excpus(cs, cs->effective_xcpus);
> -	reset_partition_data(cs);
> -	spin_unlock_irq(&callback_lock);
> -	cpuset_force_rebuild();
> -
> -	/*
> -	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
> -	 */
> -	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
> -	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
> -}
> -
>  /*
>   * remote_cpus_update - cpus_exclusive change of remote partition
>   * @cs: the cpuset to be updated
> @@ -2039,7 +1996,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>  	return;
>  
>  invalidate:
> -	remote_partition_disable(cs, tmp);
> +	partition_disable(cs, -prs, cs->prs_err, tmp);
>  }
>  
>  /**
> @@ -2667,7 +2624,8 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
>  
>  	if (is_remote_partition(cs)) {
>  		if (trialcs->prs_err)
> -			remote_partition_disable(cs, tmp);
> +			partition_disable(cs, -cs->partition_root_state,
> +					  cs->prs_err, tmp);
>  		else
>  			remote_cpus_update(cs, trialcs->exclusive_cpus,
>  					   trialcs->effective_xcpus, tmp);
> @@ -3215,7 +3173,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  
>  	if (disable_partition) {
>  		if (is_remote_partition(cs))
> -			remote_partition_disable(cs, &tmpmask);
> +			partition_disable(cs, PRS_MEMBER, PERR_NONE, &tmpmask);
>  		else
>  			update_parent_effective_cpumask(cs, partcmd_disable,
>  							NULL, &tmpmask);
> @@ -4164,7 +4122,8 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  				       (cpumask_empty(&new_cpus) &&
>  					partition_is_populated(cs, NULL)))) {
>  		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
> -		remote_partition_disable(cs, tmp);
> +		partition_disable(cs, -cs->partition_root_state, cs->prs_err,
> +				  tmp);

Now that partition_disable() takes the error code directly and updates
prs_err through partition_state_update(), the preceding
WRITE_ONCE(cs->prs_err, PERR_HOTPLUG) seems unnecessary.

Could we pass PERR_HOTPLUG directly to partition_disable() and remove
that assignment?

Thanks,
Guopeng

>  		compute_effective_cpumask(&new_cpus, cs, parent);
>  	}
>  

