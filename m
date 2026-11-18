Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.107
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794999552;
	b=xQPSFWZLjKZ2C3qdBfv8BPLONQrlWahVXVtbaOMxU8p8KEzch9jbq4k5QEfzrUNeI7l+
	 3thgOgNHqDtJqN/IHhfDq/sTflO0WqBdi19FFdMc9YCGkanav+IBurWU4dIYGn7ynqw3q
	 ktTYiXQPI/sf+JzON9GdZ8z53y3Py4o2lnLwaVKYMO/X2Iynud/dZociAjfZZxR/ibBuS
	 FDaXrxrjMWy38IyePH/sYlwMT1kmXz3ZmZwyaXZHc/xJ+sGRn5DQ2+9ki8kXfvgjEOxQS
	 4bC9yLbc6veDui2DSuDREEPEm/LUL8u2Spq06yqHgh8w8HWoe+uBI4iZSkzLEZTGEeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794999552;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=QWvIsJtrReV7KbLevOiLFUjwXjw+VatSEqPVFo8kR3Q=;
	b=260gv1rWpjnUkb18xIolLsZSRTFOYVczjykJUKwF5ypuzqmiu/1Yl0U5gFK7/g7uiA1E
	 bV1xAchbyXvb4FMb+SaBRGFBWineERDHHHCf67J2SZDURhnh62Tl02YenTBT8AC4ESv4V
	 zyXhvSe0hU/KXBN6WHO7VMTlNRI1z2sRpwtY1QMtds/b3eKCnEEq/+cwx7T0vYppDdwK1
	 BuJ1G9gy0PkXndMS0wrY8swThhiXqN8kakZf6AMAB/WXzSVlT2kp5LZxLtUEx5dfru2Kj
	 NUvR+HSVUbGORt8WfupKqqDY2/4vzqMXTL5Ottniza/DG3738tIwL78B9HtpPqTuigw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q0KqfaQX;
	arc=none smtp.remote-ip=91.218.175.107
Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BF1606A32C
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 10:59:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69BF1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q0KqfaQX
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1K7vf7VTqj35kXLKBg/SDCIsZcVAnykU0+/tJeFp5/E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794999549; v=1; x=1795604349;
 b=q0KqfaQXNrI/XzN2kJxsko3rr0+Lcqhn5puYXMNnI7o3npafv0g5suVrpO+j4MPGGSTWbvC7
 vVm7pRAFrdSteypFAXNNPKjAMy6LNrJYp/0hlrqxBFlS9oCapjafmv16mRhn9cfe7XbC7gv2z4z
 bzkSEtlkQGyXSxVAdPM8laZs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4d5f03835c47d320;
	Wed, 18 Nov 2026 10:59:09 +0000
X-Mizu-Trace-ID: 4d5f03835c47d320
X-Migadu-Flow: FLOW_OUT
Message-ID: <db90e662-175c-4de5-aab5-ab751a7f270f@linux.dev>
Date: Wed, 18 Nov 2026 18:59:01 +0800
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
Subject: Re: [PATCH v5 01/12] cpuset: introduce partition_enable()
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
 <20261114083124.1340140-2-ridong.chen@linux.dev>
 <58a7a7fa-500d-467a-840f-fedb59a73e52@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <58a7a7fa-500d-467a-840f-fedb59a73e52@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/18/2026 5:21 PM, Guopeng Zhang wrote:
> 
> 
> 在 2026/11/14 16:31, Ridong Chen 写道:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Add partition_enable() to consolidate updates to key cpuset structures
>> during partition enablement, including:
>> 1. remote_partition
>> 2. effective_xcpus
>> 3. partition_root_state
>> 4. prs_err
>>
>> Key operations performed:
>> 1. Invokes partition_xcpus_add() to assign exclusive CPUs
>> 2. Maintains remote partition flag
>> 3. Syncs the effective_xcpus mask
>> 4. Updates partition_root_state and prs_err
>> 5. Triggers scheduler domain rebuilds
>> 6. Sends partition change notifications
>>
>> This helper also handles the transition between root and isolated
>> states of a valid partition. In that case the cpumasks are unchanged
>> and only the isolation state of the CPUs in @new_excpus is updated. The
>> caller passes the CPUs used by the partition itself, as the CPUs of its
>> valid child partitions keep their own state.
>>
>> A partition_state_update() helper is added to set partition_root_state
>> and prs_err, and to reset the partition data when the new state is not
>> a valid partition.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   kernel/cgroup/cpuset.c | 56 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 56 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 7e374210c123..860cb7ea3efb 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1702,6 +1702,62 @@ static void compute_effective_nodemask(nodemask_t *new_mems,
>>   		nodes_copy(*new_mems, parent->effective_mems);
>>   }
>>   
>> +static void partition_state_update(struct cpuset *cs, int new_prs,
>> +				   enum prs_errcode prs_err)
>> +{
>> +	lockdep_assert_held(&callback_lock);
>> +
>> +	cs->partition_root_state = new_prs;
>> +	WRITE_ONCE(cs->prs_err, prs_err);
>> +	if (!is_partition_valid(cs))
>> +		reset_partition_data(cs);
>> +}
>> +
>> +/**
>> + * partition_enable - Transitions a cpuset to a partition root
>> + * @cs: The cpuset to enable partition for
>> + * @parent: Parent cpuset of @cs, NULL for remote parent
>> + * @new_prs: New partition state to set
>> + * @new_excpus: New effective exclusive CPUs mask for the partition, or the
>> + *              CPUs whose isolation state changes when switching between
>> + *              root and isolated
>> + *
>> + * Transitions a cpuset to a partition root, only for v2.
>> + * It also supports the transition between root and isolated partition.
>> + */
>> +static void __maybe_unused partition_enable(struct cpuset *cs, struct cpuset *parent,
>> +					    int new_prs, struct cpumask *new_excpus)
>> +{
>> +	int old_prs = cs->partition_root_state;
>> +
>> +	lockdep_assert_cpuset_lock_held();
>> +	WARN_ON_ONCE(new_prs <= 0);
>> +	WARN_ON_ONCE(!cpuset_v2());
>> +
>> +	if (old_prs == new_prs)
>> +		return;
>> +
>> +	spin_lock_irq(&callback_lock);
>> +	if (old_prs > 0) {
>> +		/*
>> +		 * Switch between root and isolated, cpumasks are unchanged.
>> +		 * @new_excpus holds the CPUs whose isolation state changes.
>> +		 */
>> +		isolated_cpus_update(new_prs, new_excpus);
>> +	} else {
>> +		/* enable partition should only add exclusive cpus */
>> +		partition_xcpus_add(new_prs, parent, new_excpus);
>> +		/* enable remote partition */
>> +		if (!parent)
>> +			cs->remote_partition = true;
>> +		cpumask_copy(cs->effective_xcpus, new_excpus);
>> +	}
>> +	partition_state_update(cs, new_prs, PERR_NONE);
>> +	spin_unlock_irq(&callback_lock);
>> +	cpuset_force_rebuild();
>> +	notify_partition_change(cs, old_prs);
>> +}
>> +
> 
> Hi Ridong,
> 
> I haven't found any functional issues with this patch, and I think the overall direction of the refactoring is good. I just had a thought of my own and wanted to hear what you think.
> 
> Currently, partition_enable() handles two different operations: enabling a partition and switching a valid partition between root and isolated. As a result, new_excpus has two different meanings depending on old_prs. Looking at the callers introduced in patches 4/12, 8/12, and 11/12, they all use partition_enable() to enable a previously non-valid partition. None of them seems to need the old_prs > 0 branch.
> 
> I understand that this branch may be intended for the follow-up refactoring of update_prstate(), since partition_switch() introduced in v4 also calls partition_enable().
> 
> However, could we consider keeping partition_enable() focused solely on enabling partitions, so that new_excpus always has a single meaning? The root/isolated transition could remain in update_prstate() for now and be handled separately when update_prstate() is simplified later, perhaps through partition_switch(), or by introducing another function such as partition_set_isolation(), or some other more suitable approach.
> 

Hi Guopeng,

Thanks for the review and the suggestion.

Keeping partition_enable() focused on enabling a partition is fine
with me. I folded the root/isolated switch into it because, when I
posted the RFC, Longman suggested that a new helper should come with
its complete functionality when it is introduced, so that it doesn't
have to be reworked back and forth in later patches. That is why the
old_prs > 0 branch is already here, even though only the later
update_prstate() rework needs it.

That said, if keeping it focused makes the series easier to review,
I can go that way in the next version: partition_enable() will only
handle enabling, the root/isolated switch stays in update_prstate()
for now, and we can see whether there is a better way to handle it
when update_prstate() is simplified later.

Longman, since this follows your earlier suggestion, what do you
prefer here? I'll go with whichever way you think is better.


> If I've misunderstood anything or overlooked a reason for keeping these two operations together, please let me know.
> 
> Thanks, and all the best!
> 
> Best regards,
> Guopeng
> 
>>   /*
>>    * remote_partition_enable - Enable current cpuset as a remote partition root
>>    * @cs: the cpuset to update
> 

-- 
Best regards
Ridong

