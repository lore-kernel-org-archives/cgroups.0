Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592865;
	b=VsEZeaBlDUoWkJ/lD7CkpeVlFjo9eb5BUIMfMsMu2K6xJ3eRD0GGnrpvixPnKw1uqIpm
	 hdaAUEHZAA/pXlOVyjGBnOfUb1jZGANzTdix4ycmrHGHL+1b+e7pls9FP0xGFByIMCiby
	 tLGxGeWBT7BcKAAOxQ5jzVlMZ80hYo0gE7nT0E3ThjjPG6Vg2dUUTK3rfeBHLvPvmW3Dq
	 eDQyPao7RW+rlaS+YQiNl+Y8p+75J7BwKT7P0sn8d2OtiCKzBYAeIQ9MwHoge+rW36qMp
	 vHIqzqpSJO7SQTlOcdShZsgMGTtfMR4hzJOFfXtqRPWYgGuQWbZjiLO1mZu6vL6Bbug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592865;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=oqNo54Rq6ZbI84uaQi0jkXA6/exLVGaSiNEbdrTOAAo=;
	b=e1KT3Oa7HdvJ5rHJ0UCDr3grSvYkXbLASNfgKIgAhizqNS+e18UNGwxFwFhGAHRlsRkh
	 ncBoqGJG4gdYCrPbu/8BOxqJC0cYpxFLGt3Rs1PMBkErCvdO5s/GEpHyLML3PeOIrpvVK
	 Wi82b4oWRT2upt+Kq1EeoR5/lsIfPQXetghnW0x4MFwln/v7/kHbypZbgEV/jZFA7CtDa
	 Pp32p4xV0ogCWbT+nZ1D+rUa4h6Wd0DPeScQXYF0c2SXH290XE4EjELq5bDTCSeZ/1afM
	 HKlaMUByj7eT2zNazrqq3+sENNk8dUb+nOEe2hMQFWNjSnNbPpR7yC004Xu+xXi9Lvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZTkfpzfL;
	arc=none smtp.remote-ip=95.215.58.43
Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738BF606A321
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 07:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 738BF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZTkfpzfL
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OuEZZJLkjSixhKPGo9xaYYjhl1eN2q8WB1Wl3ODorEo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795592862; v=1; x=1796197662;
 b=ZTkfpzfLWCnIkCy/NA+namee7pdB2JrduFCRC3Ne0BwvJBv6PRrmEKlQ6Y51RRTx1tpCZwgN
 YjMFX4M2xkAl50rRFkqpC1ZbJulxV+qR81Gz0KHEUeBX2Ir1fWGqca3OeByGXOuulS0ceHSKQt0
 ztzbiWxcMnIvKvBNhc/RrDfw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5a15d3c5aa704682;
	Wed, 25 Nov 2026 07:47:42 +0000
X-Mizu-Trace-ID: 5a15d3c5aa704682
X-Migadu-Flow: FLOW_OUT
Message-ID: <5e5c33c4-221d-4e52-b2f0-9dcc8b7935ef@linux.dev>
Date: Wed, 25 Nov 2026 15:47:33 +0800
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
Subject: Re: [PATCH v5 02/12] cpuset: introduce partition_disable()
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
 <20261114083124.1340140-3-ridong.chen@linux.dev>
 <71e4954b-b50f-455f-9f5c-5e053ccd6870@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <71e4954b-b50f-455f-9f5c-5e053ccd6870@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/24/2026 6:04 PM, Guopeng Zhang wrote:
> 
> 
> 在 2026/11/14 16:31, Ridong Chen 写道:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Add partition_disable() to consolidate updates to key cpuset structures
>> during partition disablement, including:
>> 1. remote_partition
>> 2. effective_xcpus
>> 3. partition_root_state
>> 4. prs_err
>>
>> Key operations performed:
>> 1. Cleaning up remote_partition
>> 2. Removing exclusive CPUs via partition_xcpus_del()
>> 3. Recomputing effective exclusive CPUs mask
>> 4. Updating partition state and error status
>> 5. Triggering required scheduler domain rebuilds
>> 6. Sending partition change notifications
>> 7. Propagating the change of the parent's effective_cpus
>>
>> Only the CPUs actually granted by the parent are given back, as the
>> parent may have shrunk. An invalid partition, or a partition under an
>> invalid parent, has already given back its exclusive CPUs, so there is
>> nothing to delete. A remote partition gets its CPUs from top_cpuset,
>> which owns all the CPUs.
>>
>> The parent is derived from @cs, top_cpuset for a remote partition.
>> When a valid partition gives back its CPUs, the change of the parent's
>> effective_cpus is propagated to the tasks of the parent and to its
>> other children. A member or an invalid partition only has its state
>> updated, so that all the callers can call partition_disable()
>> directly.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   kernel/cgroup/cpuset.c | 66 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 66 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 860cb7ea3efb..12bdcaeb8ae5 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1758,6 +1758,72 @@ static void __maybe_unused partition_enable(struct cpuset *cs, struct cpuset *pa
>>   	notify_partition_change(cs, old_prs);
>>   }
>>   
>> +/**
>> + * partition_disable - Disable partition root state for a cpuset
>> + * @cs: The cpuset to disable partition for
>> + * @new_prs: New partition root state (should be non-positive)
>> + * @prs_err: Error code to set if disabling due to validation failure
>> + * @tmp: Temporary masks
>> + *
>> + * A valid partition gives its CPUs back to its parent, or to top_cpuset
>> + * for a remote partition, and the change is propagated to the tasks and
>> + * the other children of the parent. A member or an invalid partition only
>> + * has its state updated. A valid partition under an invalid parent has
>> + * already given back its CPUs, so only the propagation is done.
>> + */
>> +static void __maybe_unused partition_disable(struct cpuset *cs, int new_prs,
>> +					     enum prs_errcode prs_err,
>> +					     struct tmpmasks *tmp)
>> +{
>> +	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
>> +	int old_prs = cs->partition_root_state;
>> +
>> +	lockdep_assert_cpuset_lock_held();
>> +	WARN_ON_ONCE(new_prs > 0);
>> +	WARN_ON_ONCE(!cpuset_v2());
>> +	/*
>> +	 * When a CPU is offlined, top_cpuset may end up with no available CPUs,
>> +	 * which should clear subpartitions_cpus. We should not emit a warning for this
>> +	 * scenario: the hierarchy is updated from top to bottom, so subpartitions_cpus
>> +	 * may already be cleared when disabling a remote partition.
>> +	 */
>> +	if (!parent)
>> +		WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) &&
>> +			     !cpumask_empty(subpartitions_cpus));
>> +
>> +	spin_lock_irq(&callback_lock);
>> +	cs->remote_partition = false;
>> +	/*
>> +	 * Disabling a partition should only delete exclusive CPUs, and only
>> +	 * those actually granted by the parent as the parent may have shrunk.
>> +	 * An invalid partition or an invalid parent has already given back
>> +	 * its exclusive CPUs, there is nothing to delete. A remote partition
>> +	 * gets its CPUs from top_cpuset which owns all the CPUs.
>> +	 */
>> +	if (is_partition_valid(cs) && (!parent || is_partition_valid(parent))) {
>> +		if (parent)
>> +			cpumask_and(cs->effective_xcpus, cs->effective_xcpus,
>> +				    parent->effective_xcpus);
>> +		partition_xcpus_del(old_prs, parent, cs->effective_xcpus);
>> +	}
>> +	/* effective_xcpus may need to be changed */
>> +	compute_excpus(cs, cs->effective_xcpus);
> 
> Hi Ridong,
> 
> Nit:
> 
> When cs->exclusive_cpus is empty, the current sequence is:
> compute_excpus()-> partition_state_update() -> reset_partition_data()-> effective_xcpus is cleared
> 
> In other words, the effective_xcpus just computed by compute_excpus() is immediately cleared by reset_partition_data().
> For this implicit exclusive CPU case, could we simply skip the computation?
> 
> if (!cpumask_empty(cs->exclusive_cpus))
>      compute_excpus(cs, cs->effective_xcpus);
> 
> If there are many sibling cpusets, the unnecessary scan could increase the time spent holding callback_lock. Of course, I haven't measured the actual overhead in practice.
> 

Good catch, thanks. new_prs is never positive here, so
reset_partition_data() always runs and clears effective_xcpus when
exclusive_cpus is empty. The sibling scan in compute_excpus() only
happens in that case, so it is wasted work under callback_lock. I'll
skip it in v6, with a comment on why.

> 
>> +	partition_state_update(cs, new_prs, prs_err);
>> +	spin_unlock_irq(&callback_lock);
>> +	cpuset_force_rebuild();
>> +	notify_partition_change(cs, old_prs);
>> +
>> +	/* A member or an invalid partition owns no CPU, nothing to propagate */
>> +	if (old_prs <= 0)
>> +		return;
>> +
>> +	/* Propagate changes in the parent's effective_cpus down the hierarchy */
>> +	if (!parent)
>> +		parent = &top_cpuset;
>> +	cpuset_update_tasks_cpumask(parent, tmp->new_cpus);
>> +	update_sibling_cpumasks(parent, cs, tmp);
>> +}
>> +
>>   /*
>>    * remote_partition_enable - Enable current cpuset as a remote partition root
>>    * @cs: the cpuset to update
> 

-- 
Best regards
Ridong

