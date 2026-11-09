Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794235890;
	b=yCUhPWXTJrusu5+G2MTTAIh0dscUCAcOAeHuKiAc9saVrAi7V95aHkc6Ak2fLpjYHECl
	 ZA8RlIXP6/gYWU0HFeu3mXZG6SE1PhCJOo1xcpisnRqU8JRfgZsHYOw7rvFtfRuUtQ9Nl
	 kqaN0Wl5MImYYLQcebuZMlsRYAajYhCJ7/ov79Epk8yYJ3tqKUjI4T5EHtjjafE1N7mp/
	 DNun/GuqtuNDriVEk/QsYwJJCK6jUT/N8cvaUz5o5RQWGs6p9pk/VKvLmw3ZTGs08E3p9
	 MtxMm0HPvarhQ3zqh6WEjy2u9D5aoOuEYbao78W8nGd3yqusLepBI4d2UBSR6gUjleg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235890;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=95sYWm0bdbmzG4Y6u+KF2rC96kbn8XW509E6ZE8/7NU=;
	b=VJemfsGK3QgM4A4DmdyPUGtJPsE7b9IaYhofan7/An1CvRVXvWRSDh0d09FpOdTYEg8K
	 WkBv+NJwt7Y/ntic0+7ujwoWiUHwPhx1qS7JyGVs9QONz+Q23QCsfT2XC9+29zVvokRD1
	 dhOno1dSSkvoer/5bj5Bte6PTJ8Um9515dY+y6xZnrTydp5KArlxNT/KGCXPnpnw+b7fg
	 Bp8E+rmvvi2W4r6zNwUBx4h2CL96HROPZVSBLtHxaG+VqECXNhpbUYugmi+LsGqi+XWOx
	 X7T96qUvh2BJQwF0hBYg21i8UWCPCz2JVjnicxs3JZ12YFTXSsZNHy3oLGT7RQmEh+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YaPSTUXv;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3019F606A330
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 14:51:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3019F606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YaPSTUXv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794235889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=95sYWm0bdbmzG4Y6u+KF2rC96kbn8XW509E6ZE8/7NU=;
	b=YaPSTUXvrgOiUkbu0SVkeBKRAC0jUKGp3xSBO5aQrsYc2wPsLiacCOq4FjITr6NNtglDMW
	vZnmJdBWSUn8RsdTZyIP4aXE0JJfg8KQECsyUljzfkxAvWoHmDWfGbVjn8ns1xrNMfMPGn
	IJd4aAKmV0CfF7MQqKVV9OsM2pXUwwU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-61cevDxjPHC7P30dI86d8w-1; Mon,
 09 Nov 2026 09:51:23 -0500
X-MC-Unique: 61cevDxjPHC7P30dI86d8w-1
X-Mimecast-MFC-AGG-ID: 61cevDxjPHC7P30dI86d8w_1794235881
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6ABF1955E92;
	Mon,  9 Nov 2026 14:51:20 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7E99930000E5;
	Mon,  9 Nov 2026 14:51:17 +0000 (UTC)
Message-ID: <09c033dd-41dc-4503-9def-4e662e946dc4@redhat.com>
Date: Mon, 9 Nov 2026 09:51:16 -0500
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
Subject: Re: [PATCH v3 3/4] cpuset: settle isolation state when CPUs are given
 back to parent
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261107120100.3587595-1-ridong.chen@linux.dev>
 <20261107120100.3587595-4-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261107120100.3587595-4-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 11/7/26 7:00 AM, Ridong Chen wrote:
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
> As the parent may be shrunk and its effective_xcpus not updated yet,
> only do so for the CPUs the parent still owns. This is to keep the
> isolation state correct for now, the in-place invalidation here will be
> removed later in the partition rework.
>
> isolated_cpus_update() assumes the old and new states are different,
> which no longer holds now that partition_xcpus_del() proceeds regardless
> of the states. Drop its @old_prs argument and the WARN_ON_ONCE() so that
> it simply sets the isolation state of the given CPUs, and use it
> everywhere. The state check in partition_xcpus_add() is dropped as well,
> as setting the state is a no-op when the states are the same.
>
> isolated_cpus_release() is no longer needed and is removed.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   kernel/cgroup/cpuset.c | 98 ++++++++----------------------------------
>   1 file changed, 19 insertions(+), 79 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 85e5b529d144..fc9de6e16ff5 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1244,17 +1244,17 @@ static bool isolated_cpu_update(int new_prs, int cpu)
>   }
>   
>   /*
> - * isolated_cpus_update - Update the isolated_cpus mask
> - * @old_prs: old partition_root_state
> - * @new_prs: new partition_root_state
> - * @xcpus: exclusive CPUs with state change
> + * isolated_cpus_update - Set the isolation state of @xcpus
> + * @new_prs: partition root state that @xcpus will belong to
> + * @xcpus: exclusive CPUs whose isolation state may change
> + *
> + * CPUs isolated at boot time are kept isolated.
>    */
> -static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus)
> +static void isolated_cpus_update(int new_prs, struct cpumask *xcpus)
>   {
>   	bool updated = false;
>   	int cpu;
>   
> -	WARN_ON_ONCE(old_prs == new_prs);
>   	lockdep_assert_held(&callback_lock);
>   	lockdep_assert_held(&cpuset_mutex);
>   	for_each_cpu(cpu, xcpus)
> @@ -1263,45 +1263,6 @@ static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus
>   		update_housekeeping = true;
>   }
>   
> -/*
> - * isolated_cpus_release - Remove the relevant CPUs in @xcpus from isolated_cpus
> - * @cs: the current cpuset
> - * @xcpus: the set of effective xcpus to be considered for removal
> - *
> - * This function is called when an isolated partition is invalidated or when
> - * some of its effective xcpus are to be removed from isolated_cpus due to
> - * changes in parent cpuset. The given @xcpus must be modifiable as the function
> - * will update its value to determine the right set of CPUs to be removed.
> - */
> -static void isolated_cpus_release(struct cpuset *cs, struct cpumask *xcpus)
> -{
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
> -
> -	spin_lock_irq(&callback_lock);
> -	isolated_cpus_update(PRS_ISOLATED, PRS_ROOT, xcpus);
> -	spin_unlock_irq(&callback_lock);
> -}
> -
>   /*
>    * partition_xcpus_add - Add new exclusive CPUs to partition
>    * @new_prs: new partition_root_state
> @@ -1325,9 +1286,7 @@ static void partition_xcpus_add(int new_prs, struct cpuset *parent,
>   	if (parent == &top_cpuset)
>   		cpumask_or(subpartitions_cpus, subpartitions_cpus, xcpus);
>   
> -	if (new_prs != parent->partition_root_state)
> -		isolated_cpus_update(parent->partition_root_state, new_prs,
> -				     xcpus);
> +	isolated_cpus_update(new_prs, xcpus);
>   
>   	cpumask_andnot(parent->effective_cpus, parent->effective_cpus, xcpus);
>   }
> @@ -1355,9 +1314,8 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>   	if (parent == &top_cpuset)
>   		cpumask_andnot(subpartitions_cpus, subpartitions_cpus, xcpus);
>   
> -	if (old_prs != parent->partition_root_state)
> -		isolated_cpus_update(old_prs, parent->partition_root_state,
> -				     xcpus);
> +	/* CPUs given back, including those of descendants, take parent's state */
> +	isolated_cpus_update(parent->partition_root_state, xcpus);
>   
>   	cpumask_or(parent->effective_cpus, parent->effective_cpus, xcpus);
>   	cpumask_and(parent->effective_cpus, parent->effective_cpus, cpu_active_mask);
> @@ -1612,6 +1570,7 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>   	struct cgroup_subsys_state *css;
>   	struct cpuset *child;
>   	bool populated = partition_is_populated(cs, NULL);
> +	static cpumask_t xcpus;		/* Protected by cpuset_mutex */
>   
>   	/*
>   	 * Check child partition roots to see if they should be invalidated
> @@ -1640,14 +1599,15 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>   			int parent_prs = cs->partition_root_state;
>   
>   			/*
> -			 * Invalidate child partition and update isolated_cpus
> -			 * if necessary.
> +			 * Invalidate child partition. Its CPUs still owned by
> +			 * cs take the isolation state of cs. effective_xcpus
> +			 * of cs may not be updated yet, so recompute it.
>   			 */
>   			spin_lock_irq(&callback_lock);
>   			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
> -			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
> -				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
> -						     child->effective_xcpus);
> +			compute_excpus(cs, &xcpus);
> +			cpumask_and(&xcpus, &xcpus, child->effective_xcpus);
> +			isolated_cpus_update(parent_prs, &xcpus);
>   			child->partition_root_state = -old_prs;
>   			spin_unlock_irq(&callback_lock);
>   			notify_partition_change(child, old_prs);
> @@ -2080,22 +2040,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   		 *
>   		 * A partition error happens when parent has tasks and all
>   		 * its effective CPUs will have to be distributed out.
> -		 *
> -		 * For an isolated partition with a shrunk root partition parent
> -		 * we may need to return some or all of its isolated CPUs.
>   		 */
>   		nocpu |= cpumask_empty(tmp->delmask);
> -		if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED)) {
> -			cpumask_clear(tmp->addmask);
> -			if (nocpu)
> -				cpumask_copy(tmp->addmask, cs->effective_xcpus);
> -			else if (!cpumask_subset(cs->effective_xcpus, parent->effective_xcpus))
> -				cpumask_andnot(tmp->addmask, cs->effective_xcpus,
> -							     parent->effective_xcpus);
> -			if (!cpumask_empty(tmp->addmask))
> -				isolated_cpus_release(cs, tmp->addmask);
> -			/* Expansion of parent's effective_xcpus is handled below */
> -		}
>   		if (nocpu) {
>   			part_error = PERR_NOCPUS;
>   			if (is_partition_valid(cs))
> @@ -2341,18 +2287,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>   				/*
>   				 * When parent is not a valid partition root,
>   				 * child partition roots become invalid too.
> -				 *
> -				 * For a to be invalidated isolated partition,
> -				 * call return_isolated_cpus() to remove the
> -				 * relevant CPUs from isolated_cpus.
> +				 * The isolation state of their CPUs has been
> +				 * settled when the parent gave them back.
>   				 */
>   				if (is_partition_valid(cp))
>   					new_prs = -old_prs;
>   
> -				if (old_prs == PRS_ISOLATED) {
> -					cpumask_copy(tmp->delmask, cp->effective_xcpus);
> -					isolated_cpus_release(cp, tmp->delmask);
> -				}
>   				WRITE_ONCE(cp->prs_err,
>   					   is_partition_invalid(parent)
>   					   ? PERR_INVPARENT : PERR_NOTPART);
> @@ -3108,7 +3048,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>   	if (!is_partition_valid(cs))
>   		reset_partition_data(cs);
>   	else if (isolcpus_updated)
> -		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
> +		isolated_cpus_update(new_prs, cs->effective_xcpus);
>   	spin_unlock_irq(&callback_lock);
>   
>   	/* Force update if partition is disabled & update effective_xcpus */

The code change looks good to me. However this is not just a code 
restructuring, it also includes a bug fix. I wonder if we should clarify 
that and maybe add a Fixes tag.

Cheers,
Longman

