Received: from mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3957D25A645
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 02:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792117366; cv=none; b=m8golcchqzbSdoK7bmxMl7hQM73C/jmoOApMbTgzgqc0SpwghvgqGQ41yPjPYbNOyVK0uEdgKjPDebvsRAPoqLA2kDV1hznBdW8kHYBF5D5cyorXb6JF78rOw4GJ37l++GmDX4fI+KbAgh+Ta6BKoR+np6vfNn5MOQ8rV1Ejfpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792117366; c=relaxed/simple;
	bh=SdQ6kJyMEO0gh3BM/SI7J243J1sPEJVlOZXKOSbqdoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g59eIElct1Ft2HXMxJF5zuSFwg1fLR1Iy38i2zXxlVpPaGX+RzF1isAb2VlsDibooKl9z5aYBy5FiOXJe/GKsyKzVV99IGoh5DxgnBJVirHkil7IMQUv/TqW85Wz//3KmuCAl53NOrzXRhRk/JrYFyda8IhvGpBD4mQL01OyoFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rR1TDjrw; arc=none smtp.client-ip=91.218.175.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rR1TDjrw"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SdQ6kJyMEO0gh3BM/SI7J243J1sPEJVlOZXKOSbqdoc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792117363; v=1; x=1792722163;
 b=rR1TDjrwnddUvXDR11Hgz8Bd2EYcDHa3XdBAbu5YFCjNxBJqqCxorGQ3vhWlawUUz1CznhEa
 FSfjqgIyqXUapI55di3C5VwbNnqBpGSiqW3azeepgnBIzDq6dFvRsvBCZ6UTVUNu/YNFVxkyvhL
 q6oMmr0xlP2o9QCFVpSdo8bk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 42672e19db55343e;
	Fri, 16 Oct 2026 02:22:43 +0000
X-Mizu-Trace-ID: 42672e19db55343e
X-Migadu-Flow: FLOW_OUT
Message-ID: <5c776fbf-4785-4b10-a7c4-65b54712ec94@linux.dev>
Date: Fri, 16 Oct 2026 10:22:39 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v3 5/9] cgroup/cpuset: Properly disabling partition
 when partition state switching fails
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20261014140548.575122-1-longman@redhat.com>
 <20261014140548.575122-6-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261014140548.575122-6-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/14 22:05, Waiman Long 写道:
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
> index 51723c299ca5..40c004386af0 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2866,6 +2866,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  	struct cpuset *parent = parent_cs(cs);
>  	struct tmpmasks tmpmask;
>  	bool isolcpus_updated = false;
> +	bool disable_partition = false;
>  
>  	if (old_prs == new_prs)
>  		return 0;
> @@ -2918,15 +2919,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  		 * A change in load balance state only, no change in cpumasks.
>  		 * Need to update isolated_cpus.
>  		 */
> -		if (prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
> +		if (prstate_housekeeping_conflict(new_prs, cs->effective_xcpus)) {
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
> @@ -2935,7 +2942,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  
>  		/*
>  		 * Invalidation of child partitions will be done in
> -		 * update_cpumasks_hier().
> +		 * update_cpumasks_hier() below.
>  		 */
>  	}
>  out:
> @@ -2954,8 +2961,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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

