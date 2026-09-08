Received: from mta1.migadu.com (out-208.mta1.migadu.com [95.215.58.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4410D3054C7
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 01:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788831650; cv=none; b=TJrwsuyASCOeJCz5cqzQp5sbfMJHv6CR5MpvwWAtPTPVN38eQ/mpeiqgMeQWht7fHlDlhlIeDOtDA7yjR9zqTaHfsSbiIXmrjFLBL9Blh9fD2Uqn5QMu59ejPs6EvzWNmi2kgPsQQLO6mL9S1gV2HMZNiWj0pLXQfjkLeFfKXrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788831650; c=relaxed/simple;
	bh=njFz8+N4GFRKkhHgnolDJ7cNiihKm6IZpjgne2qpBeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zw5FOdCmT/8bkC3gmjG3aHUn+6ngxUj6ArPV77bjBwq4ruAwhr7o6/1CtFldHjmkPmyTTLoHyNXurn9x8/4zFD2oQMlGvnUVaQGDwhrNvhFV8+p7tZMyfEu05djBRPjtBf0ggjZ+vP0W4+RPELNy+awT/94rIiExb+D9jSELQ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cIrTkaO2; arc=none smtp.client-ip=95.215.58.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cIrTkaO2"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=njFz8+N4GFRKkhHgnolDJ7cNiihKm6IZpjgne2qpBeA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788831646; v=1; x=1789436446;
 b=cIrTkaO2+1oIJBRQdukQkPLAkrtIkeLDI3/RKMqZeUhIqJqSaSQ73zDgxpBiDPw3Tsc29ii1
 pt16SpLfPrnWxNYbT8kEnFAqyf1LHj1CSuTbx3h0R4iSOfLrqSJPwmF03ntBrR+mi4MvGJxH6Mx
 8gJe35iG/rzPn41nDA/Dmrmo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e543444743d1275e;
	Tue, 08 Sep 2026 01:40:45 +0000
X-Mizu-Trace-ID: e543444743d1275e
X-Migadu-Flow: FLOW_OUT
Message-ID: <7c2a545f-7fa2-40d5-8d4f-25a65ec5df24@linux.dev>
Date: Tue, 8 Sep 2026 09:40:41 +0800
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
 <fe0c93af-5562-44fe-8aee-328c4a450a9b@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <fe0c93af-5562-44fe-8aee-328c4a450a9b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/7/2026 5:49 PM, Guopeng Zhang wrote:
> 
> 
> 在 2026/9/4 09:25, Ridong Chen 写道:
>>
>>
>> On 9/4/2026 2:33 AM, Waiman Long wrote:
>>> On 9/2/26 6:26 AM, Guopeng Zhang wrote:
>>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>
>>>> compute_partition_effective_cpumask() checks whether each valid child
>>>> partition remains covered by the parent exclusive CPU mask and whether it
>>>> would consume all remaining CPUs of a populated parent.
>>>>
>>>> Factor these two checks into child_partition_error() so the same rules can
>>>> be reused when evaluating a proposed parent configuration. This is a
>>>> preparatory refactoring with no intended functional change.
>>>>
>>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>> ---
>>>>    kernel/cgroup/cpuset.c | 38 +++++++++++++++++++++++++++++---------
>>>>    1 file changed, 29 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>>> index 8f24171b6055..6994dc75d940 100644
>>>> --- a/kernel/cgroup/cpuset.c
>>>> +++ b/kernel/cgroup/cpuset.c
>>>> @@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>>>        return 0;
>>>>    }
>>>> +/*
>>>> + * Return the error that will invalidate a child partition under a proposed
>>>> + * parent partition configuration.
>>>> + */
>>>> +static enum prs_errcode
>>>> +child_partition_error(struct cpuset *child,
>>>> +              const struct cpumask *partition_cpus,
>>>> +              const struct cpumask *remaining_cpus,
>>>> +              bool parent_populated)
>>> I think you should add some functional comments on what "partition_cpus" and "remaining_cpus" are supposed to be so that caller knows what to pass into this helper.
>>
>> Would it help to rename them to excpus and local_excpus?
>> local already implies "excluding children" (just like cgroup.stat.local), so I think that makes the intent clearer.
>>
> 
> Ridong, thanks for your review.
> 
> Renaming the masks would help, but I think `local_excpus` may be slightly misleading here. When the helper is called, the mask may still contain active CPUs assigned to the current child and to children that have not yet been visited. It excludes only the CPUs of previously visited children that remain valid under the configuration being evaluated, and the mask itself is restricted to active CPUs.
> 
> In addition, "local" already has the local-versus-remote partition meaning in cpuset.
> 
> Would `parent_xcpus` for the complete effective exclusive mask, which may include offline CPUs, and `remaining_ecpus` for the remaining active CPUs before evaluating the current child be clearer? I will also document both parameters explicitly.
> 

Passing struct cpuset *parent into the function simplifies naming, as the needed 
values become local variables derived from it.

> 
>>>> +{
>>>> +    if (!cpumask_subset(child->effective_xcpus, partition_cpus))
>>>> +        return PERR_INVCPUS;
>>>> +
>>>> +    if (parent_populated &&
>>>> +        cpumask_subset(remaining_cpus, child->effective_xcpus))
>>>> +        return PERR_NOCPUS;
>>>> +
>>>> +    return PERR_NONE;
>>>> +}
>>>> +
>>>>    /**
>>>>     * compute_partition_effective_cpumask - compute effective_cpus for partition
>>>>     * @cs: partition root cpuset
>>>> @@ -2121,6 +2141,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>>>        rcu_read_lock();
>>>>        cpuset_for_each_child(child, css, cs) {
>>>> +        enum prs_errcode child_err;
>>>> +
>>>>            if (!is_partition_valid(child))
>>>>                continue;
>>>> @@ -2129,15 +2151,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>>>             * partition root.
>>>>             */
>>>>            WARN_ON_ONCE(is_remote_partition(child));
>>>> -        WRITE_ONCE(child->prs_err, 0);
>>>> -        if (!cpumask_subset(child->effective_xcpus,
>>>> -                    cs->effective_xcpus))
>>>> -            WRITE_ONCE(child->prs_err, PERR_INVCPUS);
>>>> -        else if (populated &&
>>>> -             cpumask_subset(new_ecpus, child->effective_xcpus))
>>>> -            WRITE_ONCE(child->prs_err, PERR_NOCPUS);
>>>> -
>>>> -        if (child->prs_err) {
>>>> +        WRITE_ONCE(child->prs_err, PERR_NONE);
>>>> +        child_err = child_partition_error(child, cs->effective_xcpus,
>>>> +                          new_ecpus, populated);
>>>> +        if (child_err)
>>>> +            WRITE_ONCE(child->prs_err, child_err);
>>>> +
>>>
>>> You can ignore the inital PERR_NONE write and always write the child_err value into child->prs_err.
>>>
>>> Not big issue, just some nits.
>>>
>>> Cheers,
>>> Longman
>>>
>>>> +        if (child_err) {
>>>>                int old_prs = child->partition_root_state;
>>>>                /*
>>>
>>
> 

-- 
Best regards
Ridong

