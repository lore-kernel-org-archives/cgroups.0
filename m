Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510906;
	b=uQ4i4hDcBAsqmFYZ6C+gqpZLoYxS7Qs4rYkrHhd31XVpmDXWEXED006mg71iA79k75fq
	 gXMFYHUzl0SRh2FZlRCYHKXVWKXrBtX3bs7X3nSIkEpoPDFav+f19T0y1dj4mhCaqoAMF
	 YVOq8HUFsGrv/2bIiqLJbvmux4FooJ1PAYIpEUtSqDAQZXu9wkcxIoi3h/2urSv68p7Gx
	 dUckbL3vi/ytsDU7uhB40qCNnyg5JzfiT/sznRSQzVk0zHtnVtfT1HQcnfn2FBkljfM00
	 jWe+XfWkT+JyROQiyRa4c/6+CJXa7uVNLy9WMkXQZ/XiYyPLRfiXRhAsRPhHVWVHOAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510906;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=AuWvJV0EsxvzRXPJHEpd6FhQCGPsTzgWcoVXOl1hzJY=;
	b=PsFtdqM1djOgy1mCUFwkK+KGNZmCJXwyvTJXhP8i7qVDmh111IBQHpX9klF9NE02CTx6
	 AKClxi9y2KmOh//aTuwmPO7d8EbKeypVm19xsQmZeNC5K8hQ7QmCw8QG1ojA/PNdemvN3
	 yS8GHrfvJxGr77JxYh0mO1MAY0iUFNB/8rZX19dsLOQIIOapX0Q3RRX/U0fECTDszI72f
	 deHP6HDfe6dZeK8gNzHO5wGa+0OxjhfcETEt26FVHYS1xSCBGI6dHZF1ipjrVmVIM+DYN
	 6/mKlwZ1AqsTLmCRQAjtwBf9SJ2qvve5Z/ahnBa0LrVMKUN3f4tX/bd9a/50N7CfHwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HNQzUMKV;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0E5606A333
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 19:15:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE0E5606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HNQzUMKV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794510905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AuWvJV0EsxvzRXPJHEpd6FhQCGPsTzgWcoVXOl1hzJY=;
	b=HNQzUMKV4NcC/mtqJqYE4ev1MCYMDwrEa1Cj/zTXD8BQEa75vcHkGaqbVPekQ1LL6D05F6
	l2rBxcE9+pSSWFVeI8wVXP1VEDSXNTC4dfNhVqXT/tSZ5FNYUpdSQlOmZZwezJhrnHXIo9
	fXNV4kabqpeKJBM8ZoFQEmnMIoPd+iY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-a-p1hkAtPsutLLgGfAr03Q-1; Thu,
 12 Nov 2026 14:14:58 -0500
X-MC-Unique: a-p1hkAtPsutLLgGfAr03Q-1
X-Mimecast-MFC-AGG-ID: a-p1hkAtPsutLLgGfAr03Q_1794510897
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 341CE18004F6;
	Thu, 12 Nov 2026 19:14:56 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E5491800545;
	Thu, 12 Nov 2026 19:14:53 +0000 (UTC)
Message-ID: <bb0377ee-5726-454a-b057-73c89dd45dcb@redhat.com>
Date: Thu, 12 Nov 2026 14:14:53 -0500
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
Subject: Re: [PATCH for-7.4-fixes v4 1/2] cpuset: settle isolation state when
 CPUs are given back to parent
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261112031931.2815548-1-ridong.chen@linux.dev>
 <20261112031931.2815548-2-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261112031931.2815548-2-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 11/11/26 10:19 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
>
> partition_xcpus_del() only updates isolated_cpus when the partition that
> gives back the CPUs has a different state than its parent. CPUs that were
> further distributed to descendant isolated partitions are not taken into
> account, so isolated_cpus_release() has to be called afterwards in
> several places to walk up the ancestors and fix isolated_cpus.
>
> This misses some cases and leaks isolated CPUs, as reported by Guopeng.
> An isolated partition can be invalidated after its parent has already
> become invalid, and its CPUs are left in isolated_cpus. For example, on a
> 32-CPU system with all CPUs online and without isolcpus= or nohz_full=
> boot parameters:
>
>    cd /sys/fs/cgroup
>    echo +cpuset > cgroup.subtree_control
>    mkdir A
>    echo 0,2-31 > A/cpuset.cpus
>    echo root > A/cpuset.cpus.partition
>    echo +cpuset > A/cgroup.subtree_control
>    mkdir A/B
>    echo 2-3 > A/B/cpuset.cpus
>    echo isolated > A/B/cpuset.cpus.partition
>    cat cpuset.cpus.isolated
>    2-3
>    echo 0 > /sys/devices/system/cpu/cpu1/online
>    cat A/B/cpuset.cpus.partition
>    isolated invalid
>    cat cpuset.cpus.isolated
>    2-3
>
> When A is invalidated, partition_xcpus_del() gives CPUs 0,2-31 back to
> top cpuset. Both A and top cpuset are root partitions, so isolated_cpus
> is left untouched although CPUs 2-3 were distributed to the isolated B.
> B is then invalidated with an invalid parent, and nothing releases CPUs
> 2-3 either.
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
> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
> Reported-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Closes: https://lore.kernel.org/all/20261105130344.664336-4-guopeng.zhang@linux.dev/
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   kernel/cgroup/cpuset.c | 98 ++++++++----------------------------------
>   1 file changed, 19 insertions(+), 79 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 06ceeb0ac8c0..c7d4cfb615b7 100644
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
> @@ -2090,22 +2050,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
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
> @@ -2345,18 +2291,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
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
> @@ -3132,7 +3072,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>   	if (!is_partition_valid(cs))
>   		reset_partition_data(cs);
>   	else if (isolcpus_updated)
> -		isolated_cpus_update(old_prs, new_prs, tmpmask.new_cpus);
> +		isolated_cpus_update(new_prs, tmpmask.new_cpus);
>   	spin_unlock_irq(&callback_lock);
>   
>   	/* Force update if partition is disabled & update effective_xcpus */

LGTM
Reviewed-by: Waiman Long <longman@redhat.com>

