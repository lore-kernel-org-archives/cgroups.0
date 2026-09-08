Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C51B29E0E5
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 01:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830851; cv=none; b=UKw7fkkYAXtrHtfLtZhyCVZPTrppPvpww1XzmlhsBeHD5mYOlEpbmE5/uElmtPAHfAASA/+p/6i4VOPzWjwQH0ui99hISt4EXmJ5Z/lBJoUaXszhmhy1cAS73lDL8yT+e3yyn74sDNdAV1kF6QZwxZqAPWupsvQ+GbGTwlxNFZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830851; c=relaxed/simple;
	bh=dsDRaDunIKCn+MJPiPdeLUKuKsqc8In8Ij1klgunuKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WC+PcbUVitSdpEBMaXk5Z81RjYBAYWjwEOIkgRigOgU1fisbUaq/p7ymJqGtYPzG940Xwc4lRsj7/UeBQ9oraErKOoNnj0gWQN/95EyvXWrq4VqAnQuB421Uj5vQn7FpF2lAHgs75WDgJz6ebPqtIZD1wRqsv4TiGwdqosgWL40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C+uvDn8x; arc=none smtp.client-ip=91.218.175.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C+uvDn8x"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dsDRaDunIKCn+MJPiPdeLUKuKsqc8In8Ij1klgunuKA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788830846; v=1; x=1789435646;
 b=C+uvDn8xCDw+XGQR7EDzpxMWYlvnBHcH+jj4UhK5jXHNzLoBhnFCfVvGAiUyc0Q9ETq4vJIP
 9mxIyUFqsOf6S7iuHWSO4sVYceBY8dJjua/jZuh1SbJcRO5C/zQdhu5i9Tr4lWE6iZY2a3wFEW/
 Kw+hNJxDZV3+EBx9/oIgKmMQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ef7a5941853f9600;
	Tue, 08 Sep 2026 01:27:26 +0000
X-Mizu-Trace-ID: ef7a5941853f9600
X-Migadu-Flow: FLOW_OUT
Message-ID: <a89dab46-c6e8-4643-bf83-83fd76a38ab7@linux.dev>
Date: Tue, 8 Sep 2026 09:27:17 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] cgroup/cpuset: Factor out child partition
 validation
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long
 <longman@redhat.com>, cgroups@vger.kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
 <20260902102615.79189-2-guopeng.zhang@linux.dev>
 <5842edcd-9283-4a87-afc9-50e51962368e@redhat.com>
 <5e0d1386-b094-4d4e-8569-e6b584f955c5@linux.dev>
 <7d1f1c95-5dad-4124-858c-7c8e3119f437@linux.dev>
 <0b2b6b9d-98de-4f45-8e65-a202fe9ce0d1@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <0b2b6b9d-98de-4f45-8e65-a202fe9ce0d1@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/7/2026 6:16 PM, Guopeng Zhang wrote:
> 
> 
> 在 2026/9/4 09:55, Ridong Chen 写道:
>>
>>
>> On 9/4/2026 9:25 AM, Ridong Chen wrote:
>>>
>>>
>>> On 9/4/2026 2:33 AM, Waiman Long wrote:
>>>> On 9/2/26 6:26 AM, Guopeng Zhang wrote:
>>>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>>
>>>>> compute_partition_effective_cpumask() checks whether each valid child
>>>>> partition remains covered by the parent exclusive CPU mask and whether it
>>>>> would consume all remaining CPUs of a populated parent.
>>>>>
>>>>> Factor these two checks into child_partition_error() so the same rules can
>>>>> be reused when evaluating a proposed parent configuration. This is a
>>>>> preparatory refactoring with no intended functional change.
>>>>>
>>>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>> ---
>>>>>    kernel/cgroup/cpuset.c | 38 +++++++++++++++++++++++++++++---------
>>>>>    1 file changed, 29 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>>>> index 8f24171b6055..6994dc75d940 100644
>>>>> --- a/kernel/cgroup/cpuset.c
>>>>> +++ b/kernel/cgroup/cpuset.c
>>>>> @@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>>>>        return 0;
>>>>>    }
>>>>> +/*
>>>>> + * Return the error that will invalidate a child partition under a proposed
>>>>> + * parent partition configuration.
>>>>> + */
>>>>> +static enum prs_errcode
>>>>> +child_partition_error(struct cpuset *child,
>>>>> +              const struct cpumask *partition_cpus,
>>>>> +              const struct cpumask *remaining_cpus,
>>>>> +              bool parent_populated)
>>>> I think you should add some functional comments on what "partition_cpus" and "remaining_cpus" are supposed to be so that caller knows what to pass into this helper.
>>>
>>> Would it help to rename them to excpus and local_excpus?
>>> local already implies "excluding children" (just like cgroup.stat.local), so I think that makes the intent clearer.
>>>
>>
>> Regarding the naming: child_partition_error is a bit odd — it sounds like it's validating a hierarchical child partition, but it's actually validating the partition itself (the child argument). The parent is only needed as context for the validation logic, not because we're checking a subordinate partition.
>>
>> I'd suggest renaming it to something like:
>>
>> ```
>> static enum prs_errcode cs_partition_error(struct cpuset *cs, ...)
>>
>> ```
>>
>> That would better reflect what the function actually does.
>>
> 
> Thanks, Ridong. I see what you mean about the name.
> 
> My intention with "child" was to describe the role of the partition in these checks. Both callers use the helper while walking a parent's child partitions, and the result depends on the parent's complete exclusive mask, whether the parent is populated, and the active CPUs remaining at that point in the walk. The helper also checks only the two conditions that can invalidate a child during this process, rather than performing general validation of an arbitrary cpuset partition.
> 
> For that reason, `cs_partition_error()` might suggest a broader scope than the helper actually has. Would it make sense to keep `child_partition_error()` and clarify the comment, for example:
> 

As you can see, we are continuing to add partition checks, so I'd still suggest 
avoiding child_partition_error(), it would become confusing when we later 
refactor the partition validation logic. All of these functions are ultimately 
used to validate a partition, and the validation may depend on either the parent 
or a trialcs, or something else.

So I'd propose keeping it as:

static enum prs_errcode cs_partition_error(struct cpuset *cs, struct cpuset 
*parent);

This is more general and better accommodates future extensions.


> /*
>   * Return the error that would invalidate @child under its parent
>   * partition's CPU configuration.
>   */
> 
> I am also open to another name that preserves this parent-child context.
> 



> 
>> On a related note, the current partition validation logic is scattered across the code. I think we should consider consolidating it into a common set of helpers, perhaps like:
>>
>>
>> ```
>> static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *trialcs, struct cpuset *parent)
>> {
>> ...
>> }
>>
>> static enum prs_errcode validate_local_partition(struct cpuset *cs, struct cpuset *trialcs, struct cpuset *parent)
>> {
>>      // local partion specific check
>>      // call validate_partition
>>      
>> }
>>
>> static enum prs_errcode validate_remote_partition(struct cpuset *cs, struct cpuset *trialcs, struct cpuset *parent)
>> {
>>      // remote partion specific check
>>      // call validate_partition
>> }
>>
>> ```
>>
> 
> That sounds like a good idea.
> 
> Since these validation paths have different inputs and side effects, consolidating them may require a broader review and restructuring.
> 
> I will look into this separately after the current series is completed.
> 
> Thanks,
> Guopeng
>>
>>>>> +{
>>>>> +    if (!cpumask_subset(child->effective_xcpus, partition_cpus))
>>>>> +        return PERR_INVCPUS;
>>>>> +
>>>>> +    if (parent_populated &&
>>>>> +        cpumask_subset(remaining_cpus, child->effective_xcpus))
>>>>> +        return PERR_NOCPUS;
>>>>> +
>>>>> +    return PERR_NONE;
>>>>> +}
>>>>> +
>>>>>    /**
>>>>>     * compute_partition_effective_cpumask - compute effective_cpus for partition
>>>>>     * @cs: partition root cpuset
>>>>> @@ -2121,6 +2141,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>>>>        rcu_read_lock();
>>>>>        cpuset_for_each_child(child, css, cs) {
>>>>> +        enum prs_errcode child_err;
>>>>> +
>>>>>            if (!is_partition_valid(child))
>>>>>                continue;
>>>>> @@ -2129,15 +2151,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>>>>             * partition root.
>>>>>             */
>>>>>            WARN_ON_ONCE(is_remote_partition(child));
>>>>> -        WRITE_ONCE(child->prs_err, 0);
>>>>> -        if (!cpumask_subset(child->effective_xcpus,
>>>>> -                    cs->effective_xcpus))
>>>>> -            WRITE_ONCE(child->prs_err, PERR_INVCPUS);
>>>>> -        else if (populated &&
>>>>> -             cpumask_subset(new_ecpus, child->effective_xcpus))
>>>>> -            WRITE_ONCE(child->prs_err, PERR_NOCPUS);
>>>>> -
>>>>> -        if (child->prs_err) {
>>>>> +        WRITE_ONCE(child->prs_err, PERR_NONE);
>>>>> +        child_err = child_partition_error(child, cs->effective_xcpus,
>>>>> +                          new_ecpus, populated);
>>>>> +        if (child_err)
>>>>> +            WRITE_ONCE(child->prs_err, child_err);
>>>>> +
>>>>
>>>> You can ignore the inital PERR_NONE write and always write the child_err value into child->prs_err.
>>>>
>>>> Not big issue, just some nits.
>>>>
>>>> Cheers,
>>>> Longman
>>>>
>>>>> +        if (child_err) {
>>>>>                int old_prs = child->partition_root_state;
>>>>>                /*
>>>>
>>>
>>
> 

-- 
Best regards
Ridong

