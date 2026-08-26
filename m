Received: from mta0.migadu.com (out-123.mta0.migadu.com [91.218.175.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FB338330A
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 05:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787723085; cv=none; b=FQ7zvqVEbAsnYlFnXvHX4YOHU56KIzBRmunLUx9TLbRXLZ4XQFHQnSu1DX5NFYW/YMm3MMQu7hyjOo9gzRImMMofGFyEy+zPGmtxradx8ChafQoVdvy9JFMsJkugCBk3AW40SPola+doqgeC17sVysRHSb8/2Yt6Qpb3ASmU5d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787723085; c=relaxed/simple;
	bh=EHSU1HLywans4vNZvGF0DqPTQrozoJrQ4qJHsKE6DXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EHiIHk+z/jmnCkX8RNRSkpnfMcmS9v26St5/c8+ku0YZf2O+YwN6iMNZOfjeKXnzCno0TwBUJV8RGXIiRvayZRob+QGEH6MDwCWx6Vz9QaoZPjjuNIhBj4984VCuDcbRuW4AmoCRE2091TeEDQ6qQCQFNiBdCLtsMsFpEmV1AYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A1XI6Sy7; arc=none smtp.client-ip=91.218.175.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A1XI6Sy7"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EHSU1HLywans4vNZvGF0DqPTQrozoJrQ4qJHsKE6DXo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787723080; v=1; x=1788327880;
 b=A1XI6Sy7qF7SuwcYW1I3PkPkhCIIVS9n6jfLHEAoysOGULfAwjVJEgZm19V5agKyGG58YoX0
 xrlBlP6nm5AitlB3lNxaXM1uhJ5ijzhh8K5mxcPJfY6TZAdlkQlXt9g2XkBgt9HdbHJM6fV8wow
 cgu4OtIz4Il7fRb1dl3i3r9Q=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.109.140] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id ffcd139b4e6b6437;
	Wed, 26 Aug 2026 05:44:29 +0000
X-Mizu-Trace-ID: ffcd139b4e6b6437
X-Migadu-Flow: FLOW_OUT
Message-ID: <94688248-9fe9-4a52-9fb1-bac003fe2dd8@linux.dev>
Date: Wed, 26 Aug 2026 13:44:20 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/17] cgroup/cpuset: Limit type-change accounting to
 owned CPUs
To: Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-5-guopeng.zhang@linux.dev>
 <e31d80e4-321e-4259-ba0b-392705a8fad8@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <e31d80e4-321e-4259-ba0b-392705a8fad8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/24 22:24, Waiman Long 写道:
> On 8/20/26 8:41 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> effective_xcpus includes CPUs granted to valid child partitions. Passing
>> the whole mask to isolated_cpus_update() during a root-to-isolated or
>> isolated-to-root change applies the parent's new state to child-owned
>> CPUs as well.
>>
>> Build a mask of CPUs owned by the partition by subtracting the
>> effective_xcpus of valid children. Use this mask when updating
>> isolated_cpus for a partition type change.
>>
>> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 30 ++++++++++++++++++++++++++++--
>>   1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 2538faac9aba..468272baadb2 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2155,6 +2155,30 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>       rcu_read_unlock();
>>   }
>>   +/*
>> + * Compute CPUs owned directly by a partition.
>> + *
>> + * effective_xcpus includes CPUs granted to valid child partitions. Exclude
>> + * those CPUs when changing only this partition's type.
>> + */
>> +static void compute_partition_owned_cpumask(struct cpuset *cs,
>> +                        struct cpumask *owned_cpus)
>> +{
>> +    struct cgroup_subsys_state *css;
>> +    struct cpuset *child;
>> +
>> +    lockdep_assert_held(&cpuset_mutex);
>> +    cpumask_copy(owned_cpus, cs->effective_xcpus);
>> +
>> +    rcu_read_lock();
>> +    cpuset_for_each_child(child, css, cs) {
>> +        if (is_partition_valid(child))
>> +            cpumask_andnot(owned_cpus, owned_cpus,
>> +                       child->effective_xcpus);
>> +    }
>> +    rcu_read_unlock();
>> +}
>> +
>>   /*
>>    * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
>>    * @cs:  the cpuset to consider
>> @@ -2990,8 +3014,10 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>       } else if (old_prs && new_prs) {
>>           /*
>>            * A change in load balance state only, no change in cpumasks.
>> -         * Need to update isolated_cpus.
>> +         * Need to update isolated_cpus for CPUs owned by this partition,
>> +         * excluding CPUs distributed to valid child partitions.
>>            */
>> +        compute_partition_owned_cpumask(cs, tmpmask.new_cpus);
>>           if (((new_prs == PRS_ISOLATED) &&
>>                !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
>>               prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
>> @@ -3030,7 +3056,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>       if (!is_partition_valid(cs))
>>           reset_partition_data(cs);
>>       else if (isolcpus_updated)
>> -        isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
>> +        isolated_cpus_update(old_prs, new_prs, tmpmask.new_cpus);
>>       spin_unlock_irq(&callback_lock);
>>         /* Force update if switching back to member & update effective_xcpus */
> 
> Your use of tmpmask.new_cpus in isolated_cpus_update() can be problematic. isolcpus_updated can be set when an isolated partition is enabled or disabled. In both cases, tmpmask.new_cpus can be used temporarily. So the content of this temporary cpumask may not be what we want to pass into isolated_cpus_update(). I will suggest you only use tmpmask.new_cpus if it is determined to be coming from partition state transition instead of enabling/disabling of partition.
> 

Thanks for the review, Longman.

I followed your suggestion and checked update_prstate() again.

isolcpus_updated starts as false and is set only in the
old_prs && new_prs branch, after tmpmask.new_cpus has been filled with
the CPUs owned directly by the partition. That branch handles only
root-to-isolated and isolated-to-root transitions. The
member-to-partition and partition-to-member paths do not set the flag.

Those enable and disable paths update isolated_cpus separately. For a
local partition, the path is:

        update_parent_effective_cpumask()
          -> partition_xcpus_add()/partition_xcpus_del()
             -> isolated_cpus_update()

For a remote partition, the path is:

        remote_partition_enable()/remote_partition_disable()
          -> partition_xcpus_add()/partition_xcpus_del()
             -> isolated_cpus_update()

There is no write to tmpmask.new_cpus between
compute_partition_owned_cpumask() and the isolated_cpus_update() call
guarded by isolcpus_updated. As far as I can tell, tmpmask.new_cpus
therefore still contains the directly owned CPUs whenever the flag is
set.

Please let me know if I have overlooked another path.

Thanks,
Guopeng

> Cheers,
> Longman

