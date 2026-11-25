Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795593683;
	b=mNAsa+aR1grbsNiT5PwDcXtfFqtfihzWWznpJFoqzcLTn2TVvIsxYsl6+a43voKmNL1p
	 iqAmxo5aRqwhQlWasTsqum9rPjMfw04yJmcQ+SudStYi1Vfmbbkd9V9kfRQdmpIMt+gIO
	 R0i074xP1S4xUTmAZOao44nCf4Yv50guydroPi7/dOhFWT9EqKUTdo5VSWEC8foa1pSlz
	 j+mZANGP+C9YtZk1YbCbW4Ar9XlpPTzpfFCMqBdWaxrzgSNj5qrgMuiiK3lHgw+patys+
	 nQe+3fD6SzLADY2gBu6S3rz8WP7CIEd52llMdk5vDdeg8FlQBoAc8IDA3HZJoxvZOhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593683;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LP1IAtDHQ50/Gr6AuuC//yWbzp4GHMqhUbSTNkvSPwg=;
	b=FGWppeStHzb9MJnIOcWPvahwPT25daFFdFmhrH/cX1A97/pnYAyYKQo30RhAYk11uubL
	 bLFjSi0hdSbP2OTDbDqW/0JZ6C7gkzkm+BY0YYkGYQYITDWbtBzk3ZR50w35gj6Cq/PWK
	 M6ufy69idXHuEMX0CBITAQr6aQWBrwx9l/YdxFpnmwoxlilHjJiQBtPWiyEuxIneTqkn9
	 RPfJxTl9HtnkSkL6MkPOQMBMYVg7eS1Vic3C/s/3EGyxpt4MIdWv3hKuDWyLQx4T/DIdH
	 aUPyO6AW8+Bm9bIe8kH77N6urOuPOxhPb46mqFriz6eUOVWyR8MkC9gjGXMIRZqYoyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c+sN9FYr;
	arc=none smtp.remote-ip=91.218.175.221
Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2AA606A329
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 08:01:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF2AA606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c+sN9FYr
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YtzcS03QyCHrAEwClfwZE+Y9bJNf/vFcYTDViFBQxp4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795593680; v=1; x=1796198480;
 b=c+sN9FYrwiW4WYCWkSb/NylduYoC2C5I6iTz8kaL0RKL8GXw3Ad7uWT6XOCqMlUJ3QfoeKRt
 gxyFQS9eu6vn3gE1FDKl6URNorw3kTSyMI4vsMGV1Z0CUvtvHtWnqjAlNkAoXyHyXGZAw57AhVg
 001bH2lTEkdMfjv9GOdex1bk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9e5ae19e1785dc42;
	Wed, 25 Nov 2026 08:01:19 +0000
X-Mizu-Trace-ID: 9e5ae19e1785dc42
X-Migadu-Flow: FLOW_OUT
Message-ID: <e4adf40a-d77f-4ecd-a205-ea5eac1293a7@linux.dev>
Date: Wed, 25 Nov 2026 16:01:15 +0800
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
Subject: Re: [PATCH v5 05/12] cpuset: use partition_disable() for remote
 partition disablement
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
 <20261114083124.1340140-6-ridong.chen@linux.dev>
 <08e4f7bd-37d7-4752-93f3-23fe6d15b1df@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <08e4f7bd-37d7-4752-93f3-23fe6d15b1df@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/24/2026 6:34 PM, Guopeng Zhang wrote:
> 
> 
> 在 2026/11/14 16:31, Ridong Chen 写道:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Now that the partition_disable() helper is available, replace the
>> existing implementation for remote partition disablement with this
>> centralized function to unify the disablement logic.
>>
>> remote_partition_disable() is removed and its callers call
>> partition_disable() directly. The new partition root state is passed
>> in by the caller instead of being derived from cs->prs_err, as only the
>> caller knows which state the partition is going to.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   kernel/cgroup/cpuset.c | 57 ++++++------------------------------------
>>   1 file changed, 8 insertions(+), 49 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 3702e43e95ef..681adcde10e8 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1771,9 +1771,8 @@ static void partition_enable(struct cpuset *cs, struct cpuset *parent,
>>    * has its state updated. A valid partition under an invalid parent has
>>    * already given back its CPUs, so only the propagation is done.
>>    */
>> -static void __maybe_unused partition_disable(struct cpuset *cs, int new_prs,
>> -					     enum prs_errcode prs_err,
>> -					     struct tmpmasks *tmp)
>> +static void partition_disable(struct cpuset *cs, int new_prs,
>> +			      enum prs_errcode prs_err, struct tmpmasks *tmp)
>>   {
>>   	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
>>   	int old_prs = cs->partition_root_state;
>> @@ -1923,48 +1922,6 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>>   	return 0;
>>   }
>>   
>> -/*
>> - * remote_partition_disable - Remove current cpuset from remote partition list
>> - * @cs: the cpuset to update
>> - * @tmp: temporary masks
>> - *
>> - * The effective_cpus is also updated.
>> - *
>> - * cpuset_mutex must be held by the caller.
>> - */
>> -static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
>> -{
>> -	WARN_ON_ONCE(!is_remote_partition(cs));
>> -	/*
>> -	 * When a CPU is offlined, top_cpuset may end up with no available CPUs,
>> -	 * which should clear subpartitions_cpus. We should not emit a warning for this
>> -	 * scenario: the hierarchy is updated from top to bottom, so subpartitions_cpus
>> -	 * may already be cleared when disabling the partition.
>> -	 */
>> -	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) &&
>> -		     !cpumask_empty(subpartitions_cpus));
>> -
>> -	spin_lock_irq(&callback_lock);
>> -	cs->remote_partition = false;
>> -	partition_xcpus_del(cs->partition_root_state, NULL, cs->effective_xcpus);
>> -	if (cs->prs_err)
>> -		cs->partition_root_state = -cs->partition_root_state;
>> -	else
>> -		cs->partition_root_state = PRS_MEMBER;
>> -
>> -	/* effective_xcpus may need to be changed */
>> -	compute_excpus(cs, cs->effective_xcpus);
>> -	reset_partition_data(cs);
>> -	spin_unlock_irq(&callback_lock);
>> -	cpuset_force_rebuild();
>> -
>> -	/*
>> -	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
>> -	 */
>> -	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
>> -	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
>> -}
>> -
>>   /*
>>    * remote_cpus_update - cpus_exclusive change of remote partition
>>    * @cs: the cpuset to be updated
>> @@ -2039,7 +1996,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>>   	return;
>>   
>>   invalidate:
>> -	remote_partition_disable(cs, tmp);
>> +	partition_disable(cs, -prs, cs->prs_err, tmp);
>>   }
>>   
>>   /**
>> @@ -2667,7 +2624,8 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
>>   
>>   	if (is_remote_partition(cs)) {
>>   		if (trialcs->prs_err)
>> -			remote_partition_disable(cs, tmp);
>> +			partition_disable(cs, -cs->partition_root_state,
>> +					  cs->prs_err, tmp);
>>   		else
>>   			remote_cpus_update(cs, trialcs->exclusive_cpus,
>>   					   trialcs->effective_xcpus, tmp);
>> @@ -3215,7 +3173,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>   
>>   	if (disable_partition) {
>>   		if (is_remote_partition(cs))
>> -			remote_partition_disable(cs, &tmpmask);
>> +			partition_disable(cs, PRS_MEMBER, PERR_NONE, &tmpmask);
>>   		else
>>   			update_parent_effective_cpumask(cs, partcmd_disable,
>>   							NULL, &tmpmask);
>> @@ -4164,7 +4122,8 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>>   				       (cpumask_empty(&new_cpus) &&
>>   					partition_is_populated(cs, NULL)))) {
>>   		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>> -		remote_partition_disable(cs, tmp);
>> +		partition_disable(cs, -cs->partition_root_state, cs->prs_err,
>> +				  tmp);
> 
> Now that partition_disable() takes the error code directly and updates
> prs_err through partition_state_update(), the preceding
> WRITE_ONCE(cs->prs_err, PERR_HOTPLUG) seems unnecessary.
> 
> Could we pass PERR_HOTPLUG directly to partition_disable() and remove
> that assignment?
> 

Yes, nothing reads cs->prs_err before partition_state_update() sets it,
so the assignment is redundant. Passing PERR_HOTPLUG directly also
matches the local partition case below. I'll change it in v6.

> Thanks,
> Guopeng
> 
>>   		compute_effective_cpumask(&new_cpus, cs, parent);
>>   	}
>>   
> 

-- 
Best regards
Ridong

