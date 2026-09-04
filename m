Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28DF357D08
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 01:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487033; cv=none; b=QDV8qnk0/aYRH3+72N1M4XCLbJ+0PntJnm0z/1ZPp5awbrqI3rnrCoTSKRonI7PhpvFqSOXrwG6sTab/5Y2k96g8VTTSIdPz9ckYmrqmpN5L58Tr0awLVY35mTA1GS/RazFcOWbTp4Tkev5aW8c7y5AvHpTzZ8Mmwy8sjBM98X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487033; c=relaxed/simple;
	bh=DVuNyZ7EXHoYVxNEMvSHfqDkBER0yL8vohLELNvu600=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=k/MuJe9W/FiZu5TSdrjU97xy8Kxx+syWp30fx0hBz6T6Fsq0Pfy4vyyKU1V8EY0MA1RZbp426RQEAd8USPyOkHHG2u3Xc60ouaI829yqr6yqMqk84AbEHJSSr/C6RSXBN+5Gxr/Jm9mk1BpmpzG13Tr3SL06u06fEbMMiAY7a5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F6uJCr09; arc=none smtp.client-ip=91.218.175.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F6uJCr09"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DVuNyZ7EXHoYVxNEMvSHfqDkBER0yL8vohLELNvu600=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788487028; v=1; x=1789091828;
 b=F6uJCr09dsuP+xeu21k1S9qt3HBZhE6+knDNHe3N79HIvXFNYpXSQ74C48A3dQTFeKzLqbmn
 bbgHcUyzU64f2tET5WQMJ6ShwdP1KEC+Ab1JgLO4wpthfMXq7qf4qWbi1YfSYoYwkC6VE3O8d5e
 6yp7QNY0kcOYOGmfmptEjIr4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 79fb17a627ba0ab3;
	Fri, 04 Sep 2026 01:57:08 +0000
X-Mizu-Trace-ID: 79fb17a627ba0ab3
X-Migadu-Flow: FLOW_OUT
Message-ID: <a307dfc1-2aa9-43d6-82c7-d364028bafca@linux.dev>
Date: Fri, 4 Sep 2026 09:57:05 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] cgroup/cpuset: Factor out child partition
 validation
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>, Guopeng Zhang
 <guopeng.zhang@linux.dev>, cgroups@vger.kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
 <20260902102615.79189-2-guopeng.zhang@linux.dev>
 <5842edcd-9283-4a87-afc9-50e51962368e@redhat.com>
 <5e0d1386-b094-4d4e-8569-e6b584f955c5@linux.dev>
In-Reply-To: <5e0d1386-b094-4d4e-8569-e6b584f955c5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/4/2026 9:25 AM, Ridong Chen wrote:
> 
> 
> On 9/4/2026 2:33 AM, Waiman Long wrote:
>> On 9/2/26 6:26 AM, Guopeng Zhang wrote:
>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>
>>> compute_partition_effective_cpumask() checks whether each valid child
>>> partition remains covered by the parent exclusive CPU mask and whether it
>>> would consume all remaining CPUs of a populated parent.
>>>
>>> Factor these two checks into child_partition_error() so the same rules can
>>> be reused when evaluating a proposed parent configuration. This is a
>>> preparatory refactoring with no intended functional change.
>>>
>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>> ---
>>>   kernel/cgroup/cpuset.c | 38 +++++++++++++++++++++++++++++---------
>>>   1 file changed, 29 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 8f24171b6055..6994dc75d940 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct 
>>> cpuset *cs, int cmd,
>>>       return 0;
>>>   }
>>> +/*
>>> + * Return the error that will invalidate a child partition under a proposed
>>> + * parent partition configuration.
>>> + */
>>> +static enum prs_errcode
>>> +child_partition_error(struct cpuset *child,
>>> +              const struct cpumask *partition_cpus,
>>> +              const struct cpumask *remaining_cpus,
>>> +              bool parent_populated)
>> I think you should add some functional comments on what "partition_cpus" and 
>> "remaining_cpus" are supposed to be so that caller knows what to pass into 
>> this helper.
> 
> Would it help to rename them to excpus and local_excpus?
> local already implies "excluding children" (just like cgroup.stat.local), so I 
> think that makes the intent clearer.
> 

Regarding the naming: child_partition_error is a bit odd — it sounds like it's 
validating a hierarchical child partition, but it's actually validating the 
partition itself (the child argument). The parent is only needed as context for 
the validation logic, not because we're checking a subordinate partition.

I'd suggest renaming it to something like:

```
static enum prs_errcode cs_partition_error(struct cpuset *cs, ...)

```

That would better reflect what the function actually does.

On a related note, the current partition validation logic is scattered across 
the code. I think we should consider consolidating it into a common set of 
helpers, perhaps like:


```
static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset 
*trialcs, struct cpuset *parent)
{
...
}

static enum prs_errcode validate_local_partition(struct cpuset *cs, struct 
cpuset *trialcs, struct cpuset *parent)
{
	// local partion specific check
	// call validate_partition
	
}

static enum prs_errcode validate_remote_partition(struct cpuset *cs, struct 
cpuset *trialcs, struct cpuset *parent)
{
	// remote partion specific check
	// call validate_partition
}

```


>>> +{
>>> +    if (!cpumask_subset(child->effective_xcpus, partition_cpus))
>>> +        return PERR_INVCPUS;
>>> +
>>> +    if (parent_populated &&
>>> +        cpumask_subset(remaining_cpus, child->effective_xcpus))
>>> +        return PERR_NOCPUS;
>>> +
>>> +    return PERR_NONE;
>>> +}
>>> +
>>>   /**
>>>    * compute_partition_effective_cpumask - compute effective_cpus for partition
>>>    * @cs: partition root cpuset
>>> @@ -2121,6 +2141,8 @@ static void compute_partition_effective_cpumask(struct 
>>> cpuset *cs,
>>>       rcu_read_lock();
>>>       cpuset_for_each_child(child, css, cs) {
>>> +        enum prs_errcode child_err;
>>> +
>>>           if (!is_partition_valid(child))
>>>               continue;
>>> @@ -2129,15 +2151,13 @@ static void 
>>> compute_partition_effective_cpumask(struct cpuset *cs,
>>>            * partition root.
>>>            */
>>>           WARN_ON_ONCE(is_remote_partition(child));
>>> -        WRITE_ONCE(child->prs_err, 0);
>>> -        if (!cpumask_subset(child->effective_xcpus,
>>> -                    cs->effective_xcpus))
>>> -            WRITE_ONCE(child->prs_err, PERR_INVCPUS);
>>> -        else if (populated &&
>>> -             cpumask_subset(new_ecpus, child->effective_xcpus))
>>> -            WRITE_ONCE(child->prs_err, PERR_NOCPUS);
>>> -
>>> -        if (child->prs_err) {
>>> +        WRITE_ONCE(child->prs_err, PERR_NONE);
>>> +        child_err = child_partition_error(child, cs->effective_xcpus,
>>> +                          new_ecpus, populated);
>>> +        if (child_err)
>>> +            WRITE_ONCE(child->prs_err, child_err);
>>> +
>>
>> You can ignore the inital PERR_NONE write and always write the child_err value 
>> into child->prs_err.
>>
>> Not big issue, just some nits.
>>
>> Cheers,
>> Longman
>>
>>> +        if (child_err) {
>>>               int old_prs = child->partition_root_state;
>>>               /*
>>
> 

-- 
Best regards
Ridong

