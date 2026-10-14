Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E683544C50B
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 06:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791961102; cv=none; b=asPGcPSVdirpCFBlejipw5wz7YrisCnvBDQfnwSEzBhUxKiuUxVG3CXC/gHwHc7fuXXOQ1tufwUveW6gOUScFgrIt/xsr0uCx4L1NAHchtOS1yO1g3AGp2yJwFC6vxGPmTcY55+Nri5ciwKizXTBkXw6YI/QHKPOBMtSPG+7EsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791961102; c=relaxed/simple;
	bh=yfed7VdbcjS1SYYYrpngOFPiBqGUy+y6aRotqy033rI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t1uEaqf/r4xFnkeBIGs/BeAiSnJ9bvZCfsjIsM/G7YRh8O6ZaYNoBvN2QQMNs2Luwma6E9hpUIwa7eKcL21ir+me7DeOOa14gQIYt91RpfwdxajLPPWWzmrIjbg7RJynhVWyBVcMSPPFhpqQ+GBbsu/TmmQxSBE8rtTAxpApwZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RJ/AFPj8; arc=none smtp.client-ip=91.218.175.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RJ/AFPj8"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yfed7VdbcjS1SYYYrpngOFPiBqGUy+y6aRotqy033rI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791961096; v=1; x=1792565896;
 b=RJ/AFPj8Yc4XxGVs6ygQtLmKkK3C43KRUpkSQ58mLfDD01tgjASwWu6wROnerdwRORKZwoF3
 oe7OoKmx2yhpnQ7C5W/k91EouC3o4CzRaBGC2fwZs5zbhQLj7QONd3HFTh7dMF0X9/WjDs5dE7q
 o5wF36+QCrjfiW/DGluzR0hc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 935e00c1cceda272;
	Wed, 14 Oct 2026 06:58:16 +0000
X-Mizu-Trace-ID: 935e00c1cceda272
X-Migadu-Flow: FLOW_OUT
Message-ID: <a0739252-5d96-4e73-825d-4d97f5be41f4@linux.dev>
Date: Wed, 14 Oct 2026 14:58:09 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 1/6] cgroup/cpuset: Consolidate
 isolated_cpus_can_update() into prstate_housekeeping_conflict()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>
References: <20261010221938.243859-1-longman@redhat.com>
 <20261010221938.243859-2-longman@redhat.com>
 <7ec04fe0-994e-44d3-8c20-6732c9f20afd@linux.dev>
 <37481345-f80b-4b28-8519-15c396fc7942@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <37481345-f80b-4b28-8519-15c396fc7942@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/14 02:59, Waiman Long 写道:
> 
> On 10/11/26 1:49 AM, Guopeng Zhang wrote:
>> Hi，Longman,
>> 在 2026/10/11 06:19, Waiman Long 写道:
>>> The isolated_cpus_can_update() and prstate_housekeeping_conflict() are
>>> checking different aspects of upcoming cpumask changes that may conflict
>>> with the current setting of the housekeeping cpumasks. There are places
>>> where both are called together. There are also places where only one
>>> of them is called. That inconsistency can contribute to missing check
>>> where invalid cpumask changes may be allowed to move forward.
>>>
>>> Fix that by consolidating isolated_cpus_can_update() into
>>> prstate_housekeeping_conflict() and call prstate_housekeeping_conflict()
>>> in all the places where either one of them or both are called. The
>>> exception is the validate_partition() function where the
>>> prstate_housekeeping_conflict() call is removed. It is because
>>> validate_partition() is called only from partition_cpus_change()
>>> where prstate_housekeeping_conflict() will be called from either
>>> remote_cpus_update() or update_parent_effective_cpumask() with
>>> partcmd_update if not for partition invalidatation or disablement.
>>>
>>> Now prstate_housekeeping_conflict() will be called in the following
>>> locations:
>>>   - when a partition is enabled in remote_partition_enable() or in
>>>     update_parent_effective_cpumask() with partcmd_enable*.
>>>   - when a cpumask is updated in remote_cpus_update() or in
>>>     update_parent_effective_cpumask() with partcmd_update.
>>>   - when a partition state changes from root to isolated or vice versa
>>>     in update_prstate().
>>>
>>> Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
>>> Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
>>> Signed-off-by: Waiman Long <longman@redhat.com>
>>> ---
>>>   kernel/cgroup/cpuset.c | 123 +++++++++++++++++------------------------
>>>   1 file changed, 52 insertions(+), 71 deletions(-)
>>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 0ebba2d646c3..f3cebb277a68 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -1353,65 +1353,62 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>>>   }
>>>     /*
>>> - * isolated_cpus_can_update - check for isolated & nohz_full conflicts
>>> - * @add_cpus: cpu mask for cpus that are going to be isolated
>>> - * @del_cpus: cpu mask for cpus that are no longer isolated, can be NULL
>>> - * Return: false if there is conflict, true otherwise
>>> - *
>>> - * If nohz_full is enabled and we have isolated CPUs, their combination must
>>> - * still leave housekeeping CPUs.
>>> + * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
>>> + * @new_prs: new partition root state to be checked
>>> + * @parent_prs: Parent partition root state
>>> + * @add_cpus: additional CPUs to be added to current cpuset
>>> + * @del_cpus: CPUs to be removed from current cpuset, can be NULL
>>> + * Return: true if there is conflict, false otherwise
>>>    *
>>> - * TBD: Should consider merging this function into
>>> - *      prstate_housekeeping_conflict().
>>> + * There are two different housekeeping conflicts to be checked:
>>> + * 1) If new_prs is PRS_ROOT, none of the @add_cpus can be a boot-time isolated
>>> + *    CPU. IOW, the whole @add_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
>>> + * 2) If nohz_full is enabled and we have isolated CPUs, their combination must
>>> + *    still leave housekeeping CPUs. This check is only needed if new_prs
>>> + *    differs from parent_prs and one of them is PRS_ISOLATED.
>>>    */
>>> -static bool isolated_cpus_can_update(struct cpumask *add_cpus,
>>> -                     struct cpumask *del_cpus)
>>> +static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>>> +                      struct cpumask *add_cpus,
>>> +                      struct cpumask *del_cpus)
>>>   {
>>>       cpumask_var_t full_hk_cpus;
>>> -    int res = true;
>>> +    int res;
>>>   -    if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
>>> +    if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
>>> +        !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>>>           return true;
>>>   -    if (del_cpus && cpumask_weight_and(del_cpus,
>>> -            housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)))
>>> -        return true;
>>> +    if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
>>> +        (new_prs == parent_prs) ||
>>> +        (!del_cpus && (new_prs != PRS_ISOLATED)) ||
>>> +        ((new_prs != PRS_ISOLATED) && (parent_prs != PRS_ISOLATED)))
>>> +        return false;
>>>   
>> When a child partition switches from root to isolated under an isolated
>> parent, this returns false even though the child's CPUs were not isolated
>> before the switch.
>>
>> On a fresh boot with CPUs 0-15 online and nohz_full=2-15:
>>
>>      # cd /sys/fs/cgroup
>>      # echo +cpuset > cgroup.subtree_control
>>      # mkdir A B
>>      # echo 1-2 > A/cpuset.cpus
>>      # echo isolated > A/cpuset.cpus.partition
>>      # echo +cpuset > A/cgroup.subtree_control
>>      # mkdir A/C
>>      # echo 1 > A/C/cpuset.cpus
>>      # echo root > A/C/cpuset.cpus.partition
>>      # echo 0 > B/cpuset.cpus
>>      # echo isolated > B/cpuset.cpus.partition
>>      # cat cpuset.cpus.isolated
>>      0,2
>>      # echo isolated > A/C/cpuset.cpus.partition
>>      # cat A/C/cpuset.cpus.partition
>>      isolated
>>      # cat cpuset.cpus.isolated
>>      0-2
>>
>> CPU 1 was the last remaining housekeeping CPU: it was in neither the
>> nohz_full mask nor the cpuset.cpus.isolated mask. The final write isolates
>> CPU 1 as well, leaving no housekeeping CPU.
>>
>> Should this check also take the child's previous partition state into
>> account, rather than just comparing its new state with the parent's state?
> 
> This is actually a problem that is hard to fix without introducing a lot of complexity. After spending a day or so trying to find a possible fix from 2 different perspectives, I realize that either one will introduce quite a lot of complexity into the existing cpuset partition code. When looking at it again from a higher level, I think we may have allowed too much freedom to create a complicated nested partition hierarchy. If we simply don't allow the creation of root partition under an isolated partition parent, this problem will not exist. It is indeed a new limitation imposed on the existing cpuset partition functionality, but it is a simple solution and I don't believe there is a real use case in the creation of a root partition under isolated partition. Please correct me if my use case assumption is wrong.
> 

Thanks for taking the time to look into this.
Your suggestion to disallow root partitions under isolated parents gives us a different perspective on some of the issues we've encountered in our product.
As part of our transition from cgroup v1 to v2, we've been testing various cpuset configurations allowed by the current rules. 
Some of these tests have uncovered corner cases, including the one reported here.
So far, we haven't received any customer reports of a use case that requires a root partition under an isolated parent.

Thanks,
Guopeng

> Thanks,
> Longman

