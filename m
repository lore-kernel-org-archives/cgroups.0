Received: from mta0.migadu.com (out-223.mta0.migadu.com [91.218.175.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13E8530E15
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 12:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788869705; cv=none; b=RBuEl22s6feK7zjAuE/m9fP6cQiAeCxD/G/8ZOxyyLVvDGme2m/knEDDRpE1cj9zi0m/cPgXYTaviyX+0mKQ/4HXGr8NvDPec/zBhIbhVmNVaWlLlTJcpLDtiP/m27retjTrZUl9onA4/Ja5es5duJNkKbPxOtquIrLxGzdTsEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788869705; c=relaxed/simple;
	bh=s0JjhgQcWXx5LvEeft7Y4N1FNjMy2Kjb8rSLh9lKqgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZAuSuzyTa7+H8CjvaPTTkBhI6n0Ls/bYiaoWLRsYxp0jsh7qew+wng4lhHlTlABeFzO7RMoRDhIYahDKdpY/hDivDO+uUW6qt7NROtWBUEvlmxNM0Me5TZOqPE+le/Y+JDEu3RUEWt6oeRbc6X+mAhVbP7m65eYdhSStSZB92Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=roUaCKHs; arc=none smtp.client-ip=91.218.175.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="roUaCKHs"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=s0JjhgQcWXx5LvEeft7Y4N1FNjMy2Kjb8rSLh9lKqgQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788869689; v=1; x=1789474489;
 b=roUaCKHs3r1TvrHU378+J1r5NsuAjptnEIzvzJvqF9jmemdukP0xo/a7ohpl29LbBbkGxAHU
 NMeOTqaDU7AlViDVLr+IMYd6pg+XewyedsNvLjWD9uevmXsXniLHDYc0WjCCPiwx7cUaVxKBfIn
 khHUFOXzwpxde0efuMmm36OA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a6ac0f3f3b0ab0b5;
	Tue, 08 Sep 2026 12:14:39 +0000
X-Mizu-Trace-ID: a6ac0f3f3b0ab0b5
X-Migadu-Flow: FLOW_OUT
Message-ID: <55327e28-1d34-4913-97cc-eb281b6f5b37@linux.dev>
Date: Tue, 8 Sep 2026 20:14:28 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] cgroup/cpuset: Factor out child partition
 validation
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 cgroups@vger.kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
 <20260902102615.79189-2-guopeng.zhang@linux.dev>
 <5842edcd-9283-4a87-afc9-50e51962368e@redhat.com>
 <5e0d1386-b094-4d4e-8569-e6b584f955c5@linux.dev>
 <7d1f1c95-5dad-4124-858c-7c8e3119f437@linux.dev>
 <0b2b6b9d-98de-4f45-8e65-a202fe9ce0d1@linux.dev>
 <a89dab46-c6e8-4643-bf83-83fd76a38ab7@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <a89dab46-c6e8-4643-bf83-83fd76a38ab7@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/8 09:27, Ridong Chen 写道:
> 
> 
> On 9/7/2026 6:16 PM, Guopeng Zhang wrote:
>>
>>
>> 在 2026/9/4 09:55, Ridong Chen 写道:
>>>
>>>
>>> On 9/4/2026 9:25 AM, Ridong Chen wrote:
>>>>
>>>>
>>>> On 9/4/2026 2:33 AM, Waiman Long wrote:
>>>>> On 9/2/26 6:26 AM, Guopeng Zhang wrote:
>>>>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>>>
>>>>>> compute_partition_effective_cpumask() checks whether each valid child
>>>>>> partition remains covered by the parent exclusive CPU mask and whether it
>>>>>> would consume all remaining CPUs of a populated parent.
>>>>>>
>>>>>> Factor these two checks into child_partition_error() so the same rules can
>>>>>> be reused when evaluating a proposed parent configuration. This is a
>>>>>> preparatory refactoring with no intended functional change.
>>>>>>
>>>>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>>> ---
>>>>>>    kernel/cgroup/cpuset.c | 38 +++++++++++++++++++++++++++++---------
>>>>>>    1 file changed, 29 insertions(+), 9 deletions(-)
>>>>>>
>>>>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>>>>> index 8f24171b6055..6994dc75d940 100644
>>>>>> --- a/kernel/cgroup/cpuset.c
>>>>>> +++ b/kernel/cgroup/cpuset.c
>>>>>> @@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>>>>>        return 0;
>>>>>>    }
>>>>>> +/*
>>>>>> + * Return the error that will invalidate a child partition under a proposed
>>>>>> + * parent partition configuration.
>>>>>> + */
>>>>>> +static enum prs_errcode
>>>>>> +child_partition_error(struct cpuset *child,
>>>>>> +              const struct cpumask *partition_cpus,
>>>>>> +              const struct cpumask *remaining_cpus,
>>>>>> +              bool parent_populated)
>>>>> I think you should add some functional comments on what "partition_cpus" and "remaining_cpus" are supposed to be so that caller knows what to pass into this helper.
>>>>
>>>> Would it help to rename them to excpus and local_excpus?
>>>> local already implies "excluding children" (just like cgroup.stat.local), so I think that makes the intent clearer.
>>>>
>>>
>>> Regarding the naming: child_partition_error is a bit odd — it sounds like it's validating a hierarchical child partition, but it's actually validating the partition itself (the child argument). The parent is only needed as context for the validation logic, not because we're checking a subordinate partition.
>>>
>>> I'd suggest renaming it to something like:
>>>
>>> ```
>>> static enum prs_errcode cs_partition_error(struct cpuset *cs, ...)
>>>
>>> ```
>>>
>>> That would better reflect what the function actually does.
>>>
>>
>> Thanks, Ridong. I see what you mean about the name.
>>
>> My intention with "child" was to describe the role of the partition in these checks. Both callers use the helper while walking a parent's child partitions, and the result depends on the parent's complete exclusive mask, whether the parent is populated, and the active CPUs remaining at that point in the walk. The helper also checks only the two conditions that can invalidate a child during this process, rather than performing general validation of an arbitrary cpuset partition.
>>
>> For that reason, `cs_partition_error()` might suggest a broader scope than the helper actually has. Would it make sense to keep `child_partition_error()` and clarify the comment, for example:
>>
> 
> As you can see, we are continuing to add partition checks, so I'd still suggest avoiding child_partition_error(), it would become confusing when we later refactor the partition validation logic. All of these functions are ultimately used to validate a partition, and the validation may depend on either the parent or a trialcs, or something else.
> 
> So I'd propose keeping it as:
> 
> static enum prs_errcode cs_partition_error(struct cpuset *cs, struct cpuset *parent);
> 
> This is more general and better accommodates future extensions.
> 

I see your point now. You are looking at this from a longer-term design perspective. I will update it in the next version.

Thanks,
Guopeng

