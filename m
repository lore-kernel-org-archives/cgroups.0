Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.40
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736678;
	b=KsITEJckI7BvinMtPUvY5csApao/WOvLFDsm/Ry92myvKKmxvxTOKsJMUbgjNbC7uxJi
	 ibwsRpgn0sbagHmqWLRUH0BM5DE9rdpDCBQVvoByXKNd9UOwvxwmaB6+hbLEY/Jz+AicQ
	 RoPy0spJTeE9uUembvl6DjRw7TiVW8ZO9vYk1PCJ29v3CuoViiA178fFU4Qbfp1+Ve7vL
	 zFqB7/OuWUvWvCjd8C5u+p4nG6z2ribBZBpDJ96Fo7BcHbrclHbmu/W6KDIb2JjP+YZ0r
	 nT9EvfMudgksqjUv0rzr17W1fXcuQteZHK24czwFkGNoPW7U/vIFadpfy0Arm3t34+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736678;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=y0NcD85P4YuQlHetNwNJI+QSXD/4mVy6NLxkpgdSMcU=;
	b=VbstOo3gGZd/3+yGLTLlhIa+hAG3MyIYYVwLyJGXodsS4Xiop3pwA7V8I3KFuHjMSdWN
	 Uk0z++Tckojz5i6j3d/EpVonffysqK9u4THTdnnlPTuCrWgW9rsmk3BlilvtF96oHEY0B
	 gOJXOQdO4O5XcmFr8rUrvq8VdQTq01I2rtiBSrA8yVa42sV+K0HH792plw3dx6/aUk/V4
	 FUsVrF0MJqbIBXm/eHI1P6ovh0mvRctiFCeWPBfQuVNBYyochfRGYaXyWDVbrD2L5mJLt
	 h1sxcLhZ655An0YNKf7z4iK3ZuiLKlxTySY/rXhn1V4Bju9bdtWZoEiIjjmLQDf98Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IlLNheOE;
	arc=none smtp.remote-ip=95.215.58.40
Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE32D606A31B
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 06:24:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE32D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IlLNheOE
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DuMewOc/Oc4cYh9XSaYEomynuxuFlTvkkFfrgqfljXE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792736675; v=1; x=1793341475;
 b=IlLNheOEG9OQ0eBItoBFq7njROvMMIzVGAybOucV6/Ef/4MHPCnOVWatwfkLWibaVTMAC8HY
 50hyBaD46gOq51DZBr2sZr+XAqoDGxUz4jpnRyINwUcYlzPKJi3kezYu0UPBPNUEVm+w+CnQEG6
 6OlM1IhfGlebvNCKv6kLLgUo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bd516687889a695d;
	Fri, 23 Oct 2026 06:24:34 +0000
X-Mizu-Trace-ID: bd516687889a695d
X-Migadu-Flow: FLOW_OUT
Message-ID: <c0a4470f-ef81-47a2-9d4b-a28a7fe1a529@linux.dev>
Date: Fri, 23 Oct 2026 14:24:28 +0800
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
Subject: Re: [PATCH-next 1/6] cgroup/cpuset: Find furthest isolated ancestor
 for invalidated isolated partition
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-2-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261022031643.1351877-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/22/2026 11:16 AM, Waiman Long wrote:
> Commit 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus
> update in update_cpumasks_hier()") searches for the closet partition
> root ancestor to determine if the isolated CPUs in a to be invalidated
> isolation partition should be removed from isolated_cpus or not.
> 
> As reported by sashiko, this method may not work when there is a deeply
> nested isolated partition hierarchy. For instance, Consider a nested
> hierarchy A0 -> A1 -> A2 -> A3 where all four are PRS_ISOLATED:
> 
>    A0: effective_xcpus = 0-4
>    A1: effective_xcpus = 1-4
>    A2: effective_xcpus = 2-4
>    A3: effective_xcpus = 3-4
> 
> When A1 shrinks its exclusive_cpus from 1-4 to 1-2, A2 will update it
> effective_xcpus to 2. A3 will find its closet partition root ancestor
> A2 and decides that its effective_xcpus 3-4 should be removed from
> isolated_cpus which is incorrect.
> 
> Address this corner case by searching for the furthest isolated partition
> root ancestor instead to decide if its isolated CPUs should be returned
> to isolated_cpus.
> 
> Fixes: 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 36 +++++++++++++++++-------------------
>   1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 585a982249ad..7ead8c3b7974 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2156,22 +2156,20 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>   }
>   
>   /*
> - * ancestor_partition - Find and return the closest valid partition root ancestor
> + * iancestor_partition - Return furthest isolated partition root ancestor available
>    * @cs: the current cpuset
> - *
> - * Return: The closet partition root ancestor cpuset
> + * Return: The furthest isolated partition root ancestor available or NULL if
> + *	   not found.
>    */
> -static struct cpuset *ancestor_partition(struct cpuset *cs)
> +static struct cpuset *iancestor_partition(struct cpuset *cs)

Nit.

iancestor is confusing.
Can we renmae it furthest_isolated_ancestor?

>   {
>   	struct cpuset *ancestor = parent_cs(cs);
> +	struct cpuset *iancestor = NULL;
>   
> -	/*
> -	 * The top_cpuset is always a valid partition root which will stop
> -	 * the loop if it is reached.
> -	 */
> -	while (!is_partition_valid(ancestor))
> -		ancestor = parent_cs(ancestor);
> -	return ancestor;
> +	for (; ancestor; ancestor = parent_cs(ancestor))
> +		if (ancestor->partition_root_state == PRS_ISOLATED)
> +			iancestor = ancestor;
> +	return iancestor;
>   }
>   
>   /*
> @@ -2283,23 +2281,23 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>   				 * For a to be invalidated isolated partition,
>   				 * its isolated CPUs may or may not need to be
>   				 * removed from isolated_cpus depending on if
> -				 * its closest partition root ancestor is a root
> -				 * or isolated partition. With a PRS_ISOLATED
> -				 * ancestor, the CPUs are checked against its
> -				 * effective xcpus to see if any of them needed
> -				 * to be removed.
> +				 * there is a furthest isolated partition root
> +				 * ancestor available. When such a PRS_ISOLATED
> +				 * ancestor is available, the CPUs are checked
> +				 * against its effective xcpus to see if any of
> +				 * them needed to be removed.
>   				 */
>   				if (is_partition_valid(cp))
>   					new_prs = -old_prs;
>   
>   				if (old_prs == PRS_ISOLATED) {
> -					struct cpuset *ancestor = ancestor_partition(cp);
> +					struct cpuset *iancestor = iancestor_partition(cp);
>   
> -					if (ancestor->partition_root_state == PRS_ROOT)
> +					if (!iancestor)
>   						del_cpus = cp->effective_xcpus;
>   					else if (cpumask_andnot(tmp->delmask,
>   								cp->effective_xcpus,
> -								ancestor->effective_xcpus))
> +								iancestor->effective_xcpus))
>   						del_cpus = tmp->delmask;
>   
>   					if (del_cpus) {

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

