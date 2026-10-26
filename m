Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792996406;
	b=PNA8fQ77hwwkSkEWaCOsb3B4/nCKOa61Z9CJ9a2Vs/bpIrdrddK9UJiPKu2Lj0noipN/
	 R8PpkITV7HlufXTg5XuBaHk8XamH1hEXuvmHzYRLA32xSHwbBuwM7nP7Mh3hTwOZK1eZJ
	 VJXQVoNwLXBY39QH01kdR3BJJ1pfR6sR6+zCppho09pjlmR7KHZGIWvUjCKwzeMbc5UQI
	 jFKu3yVMBK6ZxOiIl2wz6n81BGLLjbnKodrXK+V86kNDIlPSTEHFclTKaHup60oZ7+Met
	 xZZWVuZFER19uCSIw4DB23MTsZCeITv+cTjOH2Vyw5XBmUNmocyzTdWtUHz4Na2c34g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792996406;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=uUoKt/goi6/gdJH+xfQQEGMWPgHYjoWcetRx8SRGhMo=;
	b=tlqMcXBLC1oYDMV0+rUEiIWsqR+6UBDA4UmMK82tnk3efG12YoNg91EN0w5muq9y63MJ
	 pDrtIR8rF5r3Xs51jOmrZGiUGb30W7nxbWT8euOYayRUpHgGi+93GqEplk6WgVGXyoQX2
	 ToSndWjbJVMWTKy2Ug5wTT4tcCN3QPYKCr5XrL8RWMJQ0z0zeEBLyfXfaQgoXesBw8ptP
	 b1BeYlB5NaEBJsUMqlfPhC3HI4SRM+SmwAprywzavX9kvhtRQLbyzwDWq/On1i5A1wW3t
	 nL1MHDP+IggY4lzZOu7t/TH3kVGD5hSE841voNf4QJ7RrUyvYEkTZmOXObAUcDgA+Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D0i9EJmn;
	arc=none smtp.remote-ip=91.218.175.84
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECDD606A31D
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 06:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BECDD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D0i9EJmn
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j9y/gJSpMQGmuIOH4DvgaG5yYS9ycUpPlogqZlKBAY4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792996403; v=1; x=1793601203;
 b=D0i9EJmnH3zyPuRGUbFg5dFF3EvyrTMoMKqnSqVkXHwY1YEcRc6eh7Ajqo7cDZc33TvFCuJu
 AqWnqwzzxskhS+UGTcorUBjmLWTq1HiOjmTGoMhVeSq/Qn1n6tNNjjMjPdmsYXutUZXRy8mhhV9
 3gyAptbjw8w+3cZerF5pmz4Q=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ffcdcf60b4644b82;
	Mon, 26 Oct 2026 06:33:23 +0000
X-Mizu-Trace-ID: ffcdcf60b4644b82
X-Migadu-Flow: FLOW_OUT
Message-ID: <48408c54-8fdd-443e-94b3-2aca07d298dc@linux.dev>
Date: Mon, 26 Oct 2026 14:33:17 +0800
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
Subject: Re: [PATCH-next v3 01/11] cgroup/cpuset: Find furthest isolated
 ancestor for invalidated isolated partition
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261025214449.310715-1-longman@redhat.com>
 <20261025214449.310715-2-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261025214449.310715-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/26 05:44, Waiman Long 写道:
> Commit 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus
> update in update_cpumasks_hier()") searches for the closet partition
> root ancestor to determine if the isolated CPUs in a to be invalidated
> isolation partition should be removed from isolated_cpus or not.
> 
> As reported by sashiko, this method may not work when there is a deeply
> nested isolated partition hierarchy. For instance, Consider a nested
> hierarchy A0 -> A1 -> A2 -> A3 where all four are PRS_ISOLATED:
> 
>   A0: effective_xcpus = 0-4
>   A1: effective_xcpus = 1-4
>   A2: effective_xcpus = 2-4
>   A3: effective_xcpus = 3-4
> 
> When A1 shrinks its exclusive_cpus from 1-4 to 1-2, A2 will update it
> effective_xcpus to 2. A3 will find its closet partition root ancestor
> A2 and decides that its effective_xcpus 3-4 should be removed from
> isolated_cpus which is incorrect.
> 
> Address this corner case by adding a new isolated_cpus_release() helper
> to replace the existing ancestor_partition() helper. This new helper
> will search for the furthest isolated partition root ancestor to decide
> if some or all of its isolated CPUs should be removed from isolated_cpus
> and also perform the removal when appropriate.
> 
> The is_remote_partition() and is_local_partition() helpers are also
> moved up so they can be used in earlier functions.
> 
> There are other pre-existing problems that will still prevent the
> above test case to work correctly. These problems will be addressed in
> subsequent patches.
> 
> Fixes: 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 104 +++++++++++++++++++++--------------------
>  1 file changed, 53 insertions(+), 51 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 585a982249ad..bbd44782d4bf 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1257,6 +1257,16 @@ static void reset_partition_data(struct cpuset *cs)
>  		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
>  }
>  
> +static inline bool is_remote_partition(struct cpuset *cs)
> +{
> +	return cs->remote_partition;
> +}
> +
> +static inline bool is_local_partition(struct cpuset *cs)
> +{
> +	return is_partition_valid(cs) && !is_remote_partition(cs);
> +}
> +
>  /* Return true if isolated_cpus changes. */
>  static bool isolated_cpu_update(int new_prs, int cpu)
>  {
> @@ -1299,6 +1309,45 @@ static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus
>  		update_housekeeping = true;
>  }
>  
> +/*
> + * isolated_cpus_release - Remove the relevant CPUs in @xcpus from isolated_cpus
> + * @cs: the current cpuset
> + * @xcpus: the set of effective xcpus to be considered for removal
> + *
> + * This function is called when an isolated partition is invalidated or when
> + * some of its effective xcpus are to be removed from isolated_cpus due to
> + * changes in parent cpuset. The given @xcpus must be modifiable as the function
> + * will update its value to determine the right set of CPUs to be removed.
> + */
> +static void isolated_cpus_release(struct cpuset *cs, struct cpumask *xcpus)
> +{
> +	struct cpuset *ancestor = parent_cs(cs);
> +	struct cpuset *iancestor = NULL;
> +
> +	/*
> +	 * Search the furthest isolated partition root ancestor available
> +	 * until top_cpuset or a remote partition root is hit.
> +	 */
> +	for (; ancestor; ancestor = parent_cs(ancestor)) {
> +		if (ancestor->partition_root_state == PRS_ISOLATED)
> +			iancestor = ancestor;
> +		if (is_remote_partition(ancestor))
> +			break;
> +	}
> +
> +	/*
> +	 * If a furthest isolated partition acnestor is found, use it to
> +	 * determine which of the CPUs in @xcpus should be removed from
> +	 * isolated_cpus. Otherwise, all of them will be removed.
> +	 */
> +	if (iancestor && !cpumask_andnot(xcpus, xcpus, iancestor->effective_xcpus))
> +		return; /* No CPU should be removed from isolated_cpus */
> +
> +	spin_lock_irq(&callback_lock);
> +	isolated_cpus_update(PRS_ISOLATED, PRS_ROOT, xcpus);
> +	spin_unlock_irq(&callback_lock);
> +}
> +
>  /*
>   * partition_xcpus_add - Add new exclusive CPUs to partition
>   * @new_prs: new partition_root_state
> @@ -1571,16 +1620,6 @@ static int compute_trialcs_excpus(struct cpuset *trialcs, struct cpuset *cs)
>  	return rm_siblings_excl_cpus(parent, cs, excpus);
>  }
>  
> -static inline bool is_remote_partition(struct cpuset *cs)
> -{
> -	return cs->remote_partition;
> -}
> -
> -static inline bool is_local_partition(struct cpuset *cs)
> -{
> -	return is_partition_valid(cs) && !is_remote_partition(cs);
> -}
> -
>  /*
>   * remote_partition_enable - Enable current cpuset as a remote partition root
>   * @cs: the cpuset to update
> @@ -2155,25 +2194,6 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>  	rcu_read_unlock();
>  }
>  
> -/*
> - * ancestor_partition - Find and return the closest valid partition root ancestor
> - * @cs: the current cpuset
> - *
> - * Return: The closet partition root ancestor cpuset
> - */
> -static struct cpuset *ancestor_partition(struct cpuset *cs)
> -{
> -	struct cpuset *ancestor = parent_cs(cs);
> -
> -	/*
> -	 * The top_cpuset is always a valid partition root which will stop
> -	 * the loop if it is reached.
> -	 */
> -	while (!is_partition_valid(ancestor))
> -		ancestor = parent_cs(ancestor);
> -	return ancestor;
> -}
> -
>  /*
>   * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
>   * @cs:  the cpuset to consider
> @@ -2267,7 +2287,6 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  		 */
>  		if ((cp != cs) && old_prs) {
>  			int parent_prs = parent->partition_root_state;
> -			struct cpumask *del_cpus = NULL;
>  
>  			switch (parent_prs) {
>  			case PRS_ROOT:
> @@ -2281,32 +2300,15 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  				 * child partition roots become invalid too.
>  				 *
>  				 * For a to be invalidated isolated partition,
> -				 * its isolated CPUs may or may not need to be
> -				 * removed from isolated_cpus depending on if
> -				 * its closest partition root ancestor is a root
> -				 * or isolated partition. With a PRS_ISOLATED
> -				 * ancestor, the CPUs are checked against its
> -				 * effective xcpus to see if any of them needed
> -				 * to be removed.
> +				 * call return_isolated_cpus() to remove the
> +				 * relevant CPUs from isolated_cpus.
>  				 */
>  				if (is_partition_valid(cp))
>  					new_prs = -old_prs;
>  
>  				if (old_prs == PRS_ISOLATED) {
> -					struct cpuset *ancestor = ancestor_partition(cp);
> -
> -					if (ancestor->partition_root_state == PRS_ROOT)
> -						del_cpus = cp->effective_xcpus;
> -					else if (cpumask_andnot(tmp->delmask,
> -								cp->effective_xcpus,
> -								ancestor->effective_xcpus))
> -						del_cpus = tmp->delmask;
> -
> -					if (del_cpus) {
> -						spin_lock_irq(&callback_lock);
> -						isolated_cpus_update(old_prs, new_prs, del_cpus);
> -						spin_unlock_irq(&callback_lock);
> -					}
> +					cpumask_copy(tmp->delmask, cp->effective_xcpus);
> +					isolated_cpus_release(cp, tmp->delmask);
>  				}
>  				WRITE_ONCE(cp->prs_err,
>  					   is_partition_invalid(parent)

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
