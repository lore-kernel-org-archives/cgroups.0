Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.61
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795593206;
	b=CfMxaQBiO7qeWlPGE2wAJZ1fS9/MAGgBAcWxoU3v1hgiamqFlmSyREJP/uYRJhBJ9D2y
	 7XwBDj/Kp2tdOh1Sy9gq0SNpAEHqJpVJH7x2z5lmkrhoI2NEMFLyA0QIB5BYZdnrXYaDj
	 eI0dTsd2/qL97/tw6bQodyOghToXgFmWgHNQhEeyShPwxk9eukYdr9o2Ww/hrzlXAyaSP
	 fRzRK4+NMZrg6Mfhly7wrTiW9Jc4IEPbRVpenRhbFSIiShEBHRSmqZ7ILWuzVAai5Jiui
	 v+Be9SuOjEFh27imD7S1KFvYz7iBQkI1LD1ZzGx+eUyQmCU0KXR6WAxAjLGa73Zzlaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593206;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LxZT7ZjAx5dLugEibQIK7MHwJ1X97KSE7N0NP3JiYOo=;
	b=NtLZSebSZW3cnh07kqVq7/02P8Jc7Y77NiJJjJlC5F2BgZDri+UoIltgjXAYCvFb4sHE
	 XbpqJS3qc9hxjgEtfr5Fq/oIo0Ongxq3ep3axml2RzGa6OnFjSsob30V/oX99RMTksXK8
	 NdRv6yp0wHlE25vcJrFg0+e9bOYH2kxVlkqA15+P5O+LFiSYySKXnAmqmLZAJhBYNv3kY
	 L96+WaP1RBjvdIReXE97dK9BtVRxEe0eTR/qBeLJH369ugiKVGSoJdZ75RAhmyVMZObMt
	 DeKAZqJe/2ASjm16SBrI0FHhnlY1SBI/8Cz5usKgQNJh1shmaV1OGZO9Qrx5up4baHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GdblKYot;
	arc=none smtp.remote-ip=95.215.58.61
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592AB606A31E
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 07:53:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 592AB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GdblKYot
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MAslaRM54tE3XjgvOR0kxLBY4cJjVeHgCxJcmnBGZE8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795593203; v=1; x=1796198003;
 b=GdblKYot6vc+2CPrL89l1kq1SfRpLgdzHn/okgT2I+pD6oSGHSpPmqBPj9r5OZ4QUIDP4L4s
 dXoax4R6n89k6m+Gf1gNPlUvhiMqMTE4it07jVOPKqhcuKAQePmhWZ49/f78hbgKSw3rXQmeVFC
 dUtEUtWTk3Z7tEm/b7tcFgtw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 34eb167e6bfe3a5d;
	Wed, 25 Nov 2026 07:53:23 +0000
X-Mizu-Trace-ID: 34eb167e6bfe3a5d
X-Migadu-Flow: FLOW_OUT
Message-ID: <75457f63-70fb-4675-bb7f-0a22bc193446@linux.dev>
Date: Wed, 25 Nov 2026 15:53:18 +0800
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
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
 <20261114083124.1340140-4-ridong.chen@linux.dev>
 <833af431-3580-4a7d-987f-30d8d60893a3@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <833af431-3580-4a7d-987f-30d8d60893a3@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/24/2026 6:06 PM, Guopeng Zhang wrote:
> 
> 
> 在 2026/11/14 16:31, Ridong Chen 写道:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Introduce partition_update() to centralize updates to key cpuset structures
>> during a partition update, including:
>> 1. effective_xcpus
>> 2. exclusive_cpus
>>
>> Key operations performed:
>> 1. Adding and removing exclusive CPUs via partition_xcpus_add()/del()
>> 2. Synchronizing the effective exclusive CPUs mask
>> 3. Updating the exclusive CPUs mask when modification is required
>> 4. Triggering scheduler domain rebuilds
>>
>> For a local partition, the CPUs to be added or deleted are restricted to
>> those in the parent's effective_xcpus, as the parent may have shrunk.
>> The function returns early if nothing is to be changed.
>>
>> The partition root state is unchanged by this function, so no partition
>> change notification is sent.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   kernel/cgroup/cpuset.c | 52 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 52 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 12bdcaeb8ae5..c66864faab32 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1824,6 +1824,58 @@ static void __maybe_unused partition_disable(struct cpuset *cs, int new_prs,
>>   	update_sibling_cpumasks(parent, cs, tmp);
>>   }
>>   
>> +/**
>> + * partition_update - Update an existing partition configuration
>> + * @cs: The cpuset to update
>> + * @prs: Partition root state (must be positive)
>> + * @xcpus: New exclusive CPUs mask for the partition (NULL to keep current)
>> + * @excpus: New effective exclusive CPUs mask
>> + * @tmp: Temporary masks
>> + *
>> + * Updates partition-related fields. The tmp->addmask is the CPU mask that
>> + * will be added to the subpartitions_cpus and removed from parent's
>> + * effective_cpus, and the tmp->delmask vice versa.
>> + */
> 
> My understanding is that tmp->addmask is added to subpartitions_cpus
> only when the resource parent is top_cpuset. For remote partitions,
> NULL represents that resource parent.
> 
> For a nested local partition, this helper updates the parent's
> effective_cpus without changing subpartitions_cpus.
> 
> Is my understanding correct? Please correct me if I'm missing something.
> 

Yes, that's right, the comment is inaccurate. partition_xcpus_add/del()
only touch subpartitions_cpus when the parent is top_cpuset, which
covers remote partitions and local partitions directly under
top_cpuset. For a nested local partition, only the parent's
effective_cpus is changed.

I'll update the comment in v6 as below:

/**
* partition_update - Update an existing partition configuration
* @cs: The cpuset to update
* @prs: Partition root state (must be positive)
* @xcpus: New exclusive CPUs mask for the partition (NULL to keep current)
* @excpus: New effective exclusive CPUs mask
* @tmp: Temporary masks
*
* Updates partition-related fields. The CPUs in tmp->addmask are taken
* from the effective_cpus of the parent, or of top_cpuset for a remote
* partition, and the CPUs in tmp->delmask are given back to it. If that
* parent is top_cpuset, subpartitions_cpus is updated accordingly.
*/


> 
>> +static void __maybe_unused partition_update(struct cpuset *cs, int prs, struct cpumask *xcpus,
>> +					    struct cpumask *excpus, struct tmpmasks *tmp)
>> +{
>> +	struct cpuset *parent;
>> +
>> +	lockdep_assert_cpuset_lock_held();
>> +	WARN_ON_ONCE(!cpuset_v2());
>> +	WARN_ON_ONCE(prs <= 0);
>> +
>> +	parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
>> +
>> +	/*
>> +	 * Only CPUs owned by the parent can be taken from or given back to
>> +	 * it, the parent may have shrunk. A remote partition gets its CPUs
>> +	 * from top_cpuset which owns all the CPUs.
>> +	 */
>> +	if (parent) {
>> +		cpumask_and(tmp->addmask, tmp->addmask, parent->effective_xcpus);
>> +		cpumask_and(tmp->delmask, tmp->delmask, parent->effective_xcpus);
>> +	}
>> +	if (cpumask_empty(tmp->addmask) &&
>> +	    cpumask_empty(tmp->delmask) &&
>> +	    cpumask_equal(cs->effective_xcpus, excpus))
>> +		return;
>> +
>> +	spin_lock_irq(&callback_lock);
>> +	partition_xcpus_add(prs, parent, tmp->addmask);
>> +	partition_xcpus_del(prs, parent, tmp->delmask);
>> +	/*
>> +	 * Need to update effective_xcpus and exclusive_cpus now as
>> +	 * update_sibling_cpumasks() called by the callers afterwards may
>> +	 * iterate back to the same cs.
>> +	 */
>> +	cpumask_copy(cs->effective_xcpus, excpus);
>> +	if (xcpus)
>> +		cpumask_copy(cs->exclusive_cpus, xcpus);
>> +	spin_unlock_irq(&callback_lock);
>> +	cpuset_force_rebuild();
>> +}
>> +
>>   /*
>>    * remote_partition_enable - Enable current cpuset as a remote partition root
>>    * @cs: the cpuset to update
> 

-- 
Best regards
Ridong

