Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794018497;
	b=0X9IO7msd4EN2auuZG/54CWbicenrh/GlbaitsRueVFrT8NoBrz6tZIq/itklzmAdS1Z
	 HSOL+N8AyZ1w7JIIuK3EivqntK7XJu30AKL8CAaX9F/v87yJ0Av/D0AKOjKeDMlpScS/R
	 pgm49dJ1OGCsBZIUa6NnWRJtI64bG1wnPgzf4i79/WdTIaD8ol3RiNB80i/3d2oyZOwln
	 5KFlg3nqRd4Kv0hdkVayo/SqO+RjGUXDFRyutfsVH/tNIlw6EI9FNtOoMAILTC6cu6fu6
	 kXVz1f3UI4wiJyJlhGFxCKgJLqEQa98zhOj58VCCSPnpSWZxwQ9AiRvI974a6cwHxKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794018497;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=PQIY5AfzFKo+BkiA5kBZ+MPfUU094fTi0Qg5ZumEVnE=;
	b=4i7MprpsNpikEgndYZOHy8Z/I7SaE5hEswZFF5fQxfmYmN5BclNhONID44sVCax+2u0W
	 uPqKBOAGj+F2PQ83VudfbRNy8JZfkDFT5O1UeUI+XRc9zYZBHgKMPmqqngJwEeNPGLtJg
	 ngDrZoxPVNIoxKGFftxvVt8Errga0IQNKD4Ey9S/9a2wNtA53biD3EUlve40C1d0NVDqL
	 0DwH3EUyxUVqqfBKoCo6P48xVoI/290lJWjgRrB8PW8f7IjZvW2g30xD3QhFWqZgbu3Sm
	 UmkfDkesYUR26Mz5PD5S+3MR3Q1dtS8cdQKlzNODUEFpQ0y9sZZwx8WtmkHTfw5l5gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="Qiv+/SgG";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A946606A326
	for <cgroups@vger.kernel.org>; Sat,  7 Nov 2026 02:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A946606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Qiv+/SgG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794018496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PQIY5AfzFKo+BkiA5kBZ+MPfUU094fTi0Qg5ZumEVnE=;
	b=Qiv+/SgGGNWtcnTrdRXA3z1AW0E8EbMt4Kb/MlYhYWa3P7xpK+KAuW8lFI2iK1j1XNdy3+
	axCw2gPdGnwmxplZKX4lf40XZdH+qOwrJirytV8lKFoCC8dfbJtkrZAgSdWKlVuZkPaEM4
	NinjRKP1Eg21duc6KORJMl0Ff+5M1Uw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-3SoHPqelPZuoNwmfP82KUQ-1; Fri,
 06 Nov 2026 21:28:12 -0500
X-MC-Unique: 3SoHPqelPZuoNwmfP82KUQ-1
X-Mimecast-MFC-AGG-ID: 3SoHPqelPZuoNwmfP82KUQ_1794018491
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 830131944EB6;
	Sat,  7 Nov 2026 02:28:09 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E862218004E9;
	Sat,  7 Nov 2026 02:28:06 +0000 (UTC)
Message-ID: <8efc80ab-3b65-4573-aac4-452bfdbb9a80@redhat.com>
Date: Fri, 6 Nov 2026 21:28:05 -0500
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
Subject: Re: [PATCH v2 3/4] cpuset: settle isolation state when CPUs are given
 back to parent
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261106105538.2915492-1-ridong.chen@linux.dev>
 <20261106105538.2915492-4-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261106105538.2915492-4-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


On 11/6/26 5:55 AM, Ridong Chen wrote:
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
> isolated_cpus_release() is no longer needed and is removed.
>
> Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   kernel/cgroup/cpuset.c | 86 +++++++++++-------------------------------
>   1 file changed, 23 insertions(+), 63 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 85e5b529d144..a5ab9396eb61 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1264,42 +1264,21 @@ static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus
>   }
>   
>   /*
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
>    */
> -static void isolated_cpus_release(struct cpuset *cs, struct cpumask *xcpus)
> +static void isolated_cpus_set_state(int prs, struct cpumask *xcpus)
>   {
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
>   }
>   

isolated_cpus_set_state() is almost the same as isolated_cpus_update(). 
isolated_cpus_update() just assumes that parent and child prs state 
should be different. You are right that we should proceed no matter if 
the parent and child has the same state or not. So you should consider 
merging these two functions as well.

Cheers,
Longman

>   /*
> @@ -1355,9 +1334,8 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>   	if (parent == &top_cpuset)
>   		cpumask_andnot(subpartitions_cpus, subpartitions_cpus, xcpus);
>   
> -	if (old_prs != parent->partition_root_state)
> -		isolated_cpus_update(old_prs, parent->partition_root_state,
> -				     xcpus);
> +	/* CPUs given back, including those of descendants, take parent's state */
> +	isolated_cpus_set_state(parent->partition_root_state, xcpus);
>   
>   	cpumask_or(parent->effective_cpus, parent->effective_cpus, xcpus);
>   	cpumask_and(parent->effective_cpus, parent->effective_cpus, cpu_active_mask);
> @@ -1612,6 +1590,7 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>   	struct cgroup_subsys_state *css;
>   	struct cpuset *child;
>   	bool populated = partition_is_populated(cs, NULL);
> +	static cpumask_t xcpus;		/* Protected by cpuset_mutex */
>   
>   	/*
>   	 * Check child partition roots to see if they should be invalidated
> @@ -1640,14 +1619,15 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
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
> +			isolated_cpus_set_state(parent_prs, &xcpus);
>   			child->partition_root_state = -old_prs;
>   			spin_unlock_irq(&callback_lock);
>   			notify_partition_change(child, old_prs);
> @@ -2080,22 +2060,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
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
> @@ -2341,18 +2307,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
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

