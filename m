Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.191
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514817;
	b=fKy+Qb5+Uy0UzU7aDiftzLGIqcfETGgwOHZmySwVw7vCzTZAAmpwqTwWHkrtQnwsHiuZ
	 uYoWvydWwHDSEz5/fcT9/vAR9emd+3uyl0gGlqFYkNIco4Al1CepXNoo13Jkg2u7XYdtD
	 +8a473KyZ4ef/fXfiwudNlsmL8SsSJcZaU9shDO6o7WOHR9tjW+6f5p7AsJWGQg4fsZcI
	 qfzbEEoSSRMlIc37Yd3BanwyzUs0sxm9AQ6kkEAHBx+Ye1vsVW7oF1mX0F6Uuep4AVkXP
	 qRiaaMALWgI3UeS1QBtmLL7Fwj/WYHRejUAaNXo2wYcSqYWcv0dEWZ+jdaFmllkOYzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514817;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=SPdpyfE1HWRnsvTxbeiugbn90kA/dX96AegfRSmK+b8=;
	b=iKNtl2aQ16Nl7OuhmjH7T4gaKUfBOqwE2Z1LqRjRpaPg8QM1gOGONbaNypFnLFptH24f
	 6oHxJiF3YseRx/vWj6bbComlBqRxqFI8lGHL7u++zUE9hsPecl4U15AMZY+8xqT0HR/5I
	 ej+9y9yn8Aif6uOKrpwmOA9X4JZcFI5qjNqbkdY8JylDw2Vh4y6afXv3I4RKEWkkXj9wF
	 1CD343owt9RMn1tRR7YVo3dAmvKGoBOx+JlFEcZG8GycKsqN16+VvBYxhjlJQDDbGNoWj
	 ySXyGfThv2sIgOng49wmByPr+lpaghZt27/VhSUs5WPjp4ElcHpEogKrW9q+BDWsgRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MlLzpEVB;
	arc=none smtp.remote-ip=95.215.58.191
Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EB3606A332
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 10:06:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06EB3606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MlLzpEVB
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YPGU1SINjNaGBg7pnT2MKcQEc9iGIgNnZDDzouMsAPQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795514814; v=1; x=1796119614;
 b=MlLzpEVBcZucMBEmEWDnf08shNM0f9psvhXQv3jDHBkkFrmkHYYLOCq4/V1DpB/3I1KlKTRJ
 ZztR000BAGmlbpyL0kSY90WOpc5Dg4C3m/4zuTMfdwVGkxPgffYA+aEbX7EMM13gDh7d0KVn6CU
 6C2WHA9dDzsi/u+dTJaTB53g=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a282bc42fc97d6e8;
	Tue, 24 Nov 2026 10:06:53 +0000
X-Mizu-Trace-ID: a282bc42fc97d6e8
X-Migadu-Flow: FLOW_OUT
Message-ID: <833af431-3580-4a7d-987f-30d8d60893a3@linux.dev>
Date: Tue, 24 Nov 2026 18:06:39 +0800
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
Subject: Re: [PATCH v5 03/12] cpuset: introduce partition_update()
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
 <20261114083124.1340140-4-ridong.chen@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261114083124.1340140-4-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/14 16:31, Ridong Chen 写道:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Introduce partition_update() to centralize updates to key cpuset structures
> during a partition update, including:
> 1. effective_xcpus
> 2. exclusive_cpus
> 
> Key operations performed:
> 1. Adding and removing exclusive CPUs via partition_xcpus_add()/del()
> 2. Synchronizing the effective exclusive CPUs mask
> 3. Updating the exclusive CPUs mask when modification is required
> 4. Triggering scheduler domain rebuilds
> 
> For a local partition, the CPUs to be added or deleted are restricted to
> those in the parent's effective_xcpus, as the parent may have shrunk.
> The function returns early if nothing is to be changed.
> 
> The partition root state is unchanged by this function, so no partition
> change notification is sent.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  kernel/cgroup/cpuset.c | 52 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 12bdcaeb8ae5..c66864faab32 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1824,6 +1824,58 @@ static void __maybe_unused partition_disable(struct cpuset *cs, int new_prs,
>  	update_sibling_cpumasks(parent, cs, tmp);
>  }
>  
> +/**
> + * partition_update - Update an existing partition configuration
> + * @cs: The cpuset to update
> + * @prs: Partition root state (must be positive)
> + * @xcpus: New exclusive CPUs mask for the partition (NULL to keep current)
> + * @excpus: New effective exclusive CPUs mask
> + * @tmp: Temporary masks
> + *
> + * Updates partition-related fields. The tmp->addmask is the CPU mask that
> + * will be added to the subpartitions_cpus and removed from parent's
> + * effective_cpus, and the tmp->delmask vice versa.
> + */

My understanding is that tmp->addmask is added to subpartitions_cpus
only when the resource parent is top_cpuset. For remote partitions,
NULL represents that resource parent.

For a nested local partition, this helper updates the parent's
effective_cpus without changing subpartitions_cpus.

Is my understanding correct? Please correct me if I'm missing something.

Thanks,
Guopeng

> +static void __maybe_unused partition_update(struct cpuset *cs, int prs, struct cpumask *xcpus,
> +					    struct cpumask *excpus, struct tmpmasks *tmp)
> +{
> +	struct cpuset *parent;
> +
> +	lockdep_assert_cpuset_lock_held();
> +	WARN_ON_ONCE(!cpuset_v2());
> +	WARN_ON_ONCE(prs <= 0);
> +
> +	parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
> +
> +	/*
> +	 * Only CPUs owned by the parent can be taken from or given back to
> +	 * it, the parent may have shrunk. A remote partition gets its CPUs
> +	 * from top_cpuset which owns all the CPUs.
> +	 */
> +	if (parent) {
> +		cpumask_and(tmp->addmask, tmp->addmask, parent->effective_xcpus);
> +		cpumask_and(tmp->delmask, tmp->delmask, parent->effective_xcpus);
> +	}
> +	if (cpumask_empty(tmp->addmask) &&
> +	    cpumask_empty(tmp->delmask) &&
> +	    cpumask_equal(cs->effective_xcpus, excpus))
> +		return;
> +
> +	spin_lock_irq(&callback_lock);
> +	partition_xcpus_add(prs, parent, tmp->addmask);
> +	partition_xcpus_del(prs, parent, tmp->delmask);
> +	/*
> +	 * Need to update effective_xcpus and exclusive_cpus now as
> +	 * update_sibling_cpumasks() called by the callers afterwards may
> +	 * iterate back to the same cs.
> +	 */
> +	cpumask_copy(cs->effective_xcpus, excpus);
> +	if (xcpus)
> +		cpumask_copy(cs->exclusive_cpus, xcpus);
> +	spin_unlock_irq(&callback_lock);
> +	cpuset_force_rebuild();
> +}
> +
>  /*
>   * remote_partition_enable - Enable current cpuset as a remote partition root
>   * @cs: the cpuset to update

