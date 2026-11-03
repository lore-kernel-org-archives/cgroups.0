Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701441;
	b=ovmqIsWZOUdd6ZylQzQ4CGgGeXiJfGQ96xpEDmIS2FHSlpUVdc2X/Py/1YQfVJJMW/RJ
	 WMcga6wiRD8IforJboatHV3uCLhtAntV2/UwwEaDIz47mirJg9CJfwi8hfZ049MsNuNCF
	 2Dpkv0ji9ZXGCtNwv2MWdXrNDS6g/+xe71kZVqu3LrLZYQiB8vySnmtoj4LhDwERYBZFC
	 ZjTA7pGz4yNucPdZ4vGcLm/HnnRmC74RWDkoiCKgCBeuq6qV085FS31ONjESn3AbaKrfu
	 qafpk/H1NTdNP8STKM2wKlRXpi6JwrzNBgVoY0ddWQNAGaBILUrG0MYwgJNeo15gLdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701441;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=/l9b5HDBEbiobyCbPvDxjXgTJel864ilDzKeeNbqOYI=;
	b=shq2Lwul+o53YYXbeTHbVGCynFsDLJuIDlP52J11YClCfQVba8Y2MlDatHAWv5IohJS/
	 N2oJI2eCcnM3eBX1JAXCRn9Wd4HffETxS8HSJphC1IkX5k7AA81i08XHu1tiYKBqhb4Zh
	 tspeLOr2UWucmM/p5t3miA/W9yD7SnMkn+rK+pcy+ongLbhXNXg1lZ3FcygzE42GxQb2l
	 PpCfNRiOHqKPuJMbp3Vu83/rAozTByEPZWzIs0b5hwuEnDKRJnTTp7On5xX/XlvqcVTdX
	 Axegs99eWF7KuUIMziLyO418KxpQb03r8kV6b8rtBZKmaz0e1FMEiNwV5laB5DHV/Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nb9dlx1w;
	arc=none smtp.remote-ip=91.218.175.195
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4CB606A803
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 10:23:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C4CB606A803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nb9dlx1w
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D2uPv4OT0ua1maKMS8AfkLRaw/ThnBCuIFJmT4dYX/0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793701438; v=1; x=1794306238;
 b=nb9dlx1w4KL1457BoBGgmaLbctwQVWeXcEMjnWMHbRFUCownVdeAn7Mec+r6/M/tFQDKUrjC
 0MVUr+pwev6Cx9c7VwHyXqWE0Rlne4WL6EO5eeDABs1JsxpAydbpi8Xu/4yemtYwFYyDt4A8P7r
 g3FTs2iJGg8kvBxYayazHvHc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e39d3eeb0efff061;
	Tue, 03 Nov 2026 10:23:57 +0000
X-Mizu-Trace-ID: e39d3eeb0efff061
X-Migadu-Flow: FLOW_OUT
Message-ID: <247cb2ad-d3c5-4303-85ca-fe023f9ada41@linux.dev>
Date: Tue, 3 Nov 2026 18:23:50 +0800
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
Subject: Re: [RFC PATCH -v4 02/22] cpuset: settle isolation state when CPUs
 are given back to parent
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutn? <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261101114206.2434398-1-ridong.chen@linux.dev>
 <20261101114206.2434398-3-ridong.chen@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261101114206.2434398-3-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/1 19:41, Ridong Chen 写道:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> partition_xcpus_del() only updates isolated_cpus when the partition that
> gives back the CPUs has a different state than its parent. CPUs that were
> further distributed to descendant isolated partitions are not taken into
> account, so isolated_cpus_release() has to be called afterwards in
> several places to walk up the ancestors and fix isolated_cpus.
> 
> Make partition_xcpus_del() always set the isolation state of the given
> back CPUs to the state of the parent that receives them. As the
> effective_xcpus of a partition covers the CPUs distributed to its
> descendants, the isolation state of those CPUs is settled at the same
> time. Boot-time isolated CPUs are still preserved by isolated_cpu_update().
> 
> compute_partition_effective_cpumask() invalidates a child partition
> without going through partition_xcpus_del(), so do the same there: the
> CPUs of the invalidated child take the isolation state of its parent.
> 
> isolated_cpus_release() is no longer needed and is removed.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  kernel/cgroup/cpuset.c | 86 ++++++++++++------------------------------
>  1 file changed, 24 insertions(+), 62 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 72e1df1295e1..df9fc126e391 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1264,42 +1264,21 @@ static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus
>  }
>  
>  /*
> - * isolated_cpus_release - Remove the relevant CPUs in @xcpus from isolated_cpus
> - * @cs: the current cpuset
> - * @xcpus: the set of effective xcpus to be considered for removal
> - *
> - * This function is called when an isolated partition is invalidated or when
> - * some of its effective xcpus are to be removed from isolated_cpus due to
> - * changes in parent cpuset. The given @xcpus must be modifiable as the function
> - * will update its value to determine the right set of CPUs to be removed.
> + * isolated_cpus_set_state - Set the isolation state of @xcpus
> + * @prs: partition root state that @xcpus will belong to
> + * @xcpus: exclusive CPUs whose isolation state may change
>   */
> -static void isolated_cpus_release(struct cpuset *cs, struct cpumask *xcpus)
> +static void isolated_cpus_set_state(int prs, struct cpumask *xcpus)
>  {
> -	struct cpuset *ancestor = parent_cs(cs);
> -	struct cpuset *iancestor = NULL;
> -
> -	/*
> -	 * Search the furthest isolated partition root ancestor available
> -	 * until top_cpuset or a remote partition root is hit.
> -	 */
> -	for (; ancestor; ancestor = parent_cs(ancestor)) {
> -		if (ancestor->partition_root_state == PRS_ISOLATED)
> -			iancestor = ancestor;
> -		if (is_remote_partition(ancestor))
> -			break;
> -	}
> -
> -	/*
> -	 * If a furthest isolated partition acnestor is found, use it to
> -	 * determine which of the CPUs in @xcpus should be removed from
> -	 * isolated_cpus. Otherwise, all of them will be removed.
> -	 */
> -	if (iancestor && !cpumask_andnot(xcpus, xcpus, iancestor->effective_xcpus))
> -		return; /* No CPU should be removed from isolated_cpus */
> +	bool updated = false;
> +	int cpu;
>  
> -	spin_lock_irq(&callback_lock);
> -	isolated_cpus_update(PRS_ISOLATED, PRS_ROOT, xcpus);
> -	spin_unlock_irq(&callback_lock);
> +	lockdep_assert_held(&callback_lock);
> +	lockdep_assert_held(&cpuset_mutex);
> +	for_each_cpu(cpu, xcpus)
> +		updated |= isolated_cpu_update(prs, cpu);
> +	if (updated)
> +		update_housekeeping = true;
>  }
>  
>  /*
> @@ -1355,9 +1334,12 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>  	if (parent == &top_cpuset)
>  		cpumask_andnot(subpartitions_cpus, subpartitions_cpus, xcpus);
>  
> -	if (old_prs != parent->partition_root_state)
> -		isolated_cpus_update(old_prs, parent->partition_root_state,
> -				     xcpus);
> +	/*
> +	 * CPUs given back to parent take the parent's isolation state. This
> +	 * also covers CPUs that were further distributed to descendant
> +	 * isolated partitions.
> +	 */
> +	isolated_cpus_set_state(parent->partition_root_state, xcpus);
>  
>  	cpumask_or(parent->effective_cpus, parent->effective_cpus, xcpus);
>  	cpumask_and(parent->effective_cpus, parent->effective_cpus, cpu_active_mask);
> @@ -1640,14 +1622,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>  			int parent_prs = cs->partition_root_state;
>  
>  			/*
> -			 * Invalidate child partition and update isolated_cpus
> -			 * if necessary.
> +			 * Invalidate child partition. Its CPUs, including those
> +			 * further distributed to its descendants, take the
> +			 * isolation state of cs.
>  			 */
>  			spin_lock_irq(&callback_lock);
>  			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
> -			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
> -				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
> -						     child->effective_xcpus);
> +			isolated_cpus_set_state(parent_prs, child->effective_xcpus);
>  			child->partition_root_state = -old_prs;
>  			spin_unlock_irq(&callback_lock);
>  			notify_partition_change(child, old_prs);
> @@ -2090,21 +2071,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		 *
>  		 * A partition error happens when parent has tasks and all
>  		 * its effective CPUs will have to be distributed out.
> -		 *
> -		 * For an isolated partition with a shrunk root partition parent
> -		 * we may need to return some or all of its isolated CPUs.
>  		 */
>  		nocpu |= cpumask_empty(tmp->delmask);
> -		if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED)) {
> -			cpumask_clear(tmp->addmask);
> -			if (nocpu)
> -				cpumask_copy(tmp->addmask, cs->effective_xcpus);
> -			else if (!cpumask_subset(cs->effective_xcpus, parent->effective_xcpus))
> -				cpumask_andnot(tmp->addmask, cs->effective_xcpus,
> -							     parent->effective_xcpus);
> -			if (!cpumask_empty(tmp->addmask))
> -				isolated_cpus_release(cs, tmp->addmask);
> -		}
>  		if (nocpu) {
>  			part_error = PERR_NOCPUS;
>  			if (is_partition_valid(cs))
> @@ -2327,18 +2295,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  				/*
>  				 * When parent is not a valid partition root,
>  				 * child partition roots become invalid too.
> -				 *
> -				 * For a to be invalidated isolated partition,
> -				 * call return_isolated_cpus() to remove the
> -				 * relevant CPUs from isolated_cpus.
> +				 * The isolation state of their CPUs has been
> +				 * settled when the parent gave them back.
>  				 */
>  				if (is_partition_valid(cp))
>  					new_prs = -old_prs;
>  
> -				if (old_prs == PRS_ISOLATED) {
> -					cpumask_copy(tmp->delmask, cp->effective_xcpus);
> -					isolated_cpus_release(cp, tmp->delmask);
> -				}
>  				WRITE_ONCE(cp->prs_err,
>  					   is_partition_invalid(parent)
>  					   ? PERR_INVPARENT : PERR_NOTPART);

Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
