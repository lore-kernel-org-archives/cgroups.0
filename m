Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA351F3BAC
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 01:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485160; cv=none; b=LeNf7UJwxaFsWf7PRyBIlYqYzFb6pktU2cVNSjmpvdDOui0SajLYXqZIyoya0u1BFKtPAahypTolO0i7B0NprU80TmqlZvhtXMl19KPqgH9fJtOclOBSJwsai4wBcLlOVGcPQjUA7GcYcWFb7WtxZrvZEuwRBGNoCdHj24SDb2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485160; c=relaxed/simple;
	bh=1+ElzHUmhJhuo7DolAIPKbmlYPejZZyNql5uZisbrTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RPkVKfPvOJVIbWkyNGJ6fhffyJ8iIw6LynqTotq9Ri0qXL6b7RPNq29brNh7eCvkUIHhxzvPQRdy+l+UCH/BO9E9Xhv/lOsBKWot3DpeKGSSUMag5ljo0IXjcAzSb1Dem+XvgyHCpVcl5Tybo2FcZ6x9H1y5mXmdrLCTtLoheC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j6UA0BfV; arc=none smtp.client-ip=95.215.58.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j6UA0BfV"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1+ElzHUmhJhuo7DolAIPKbmlYPejZZyNql5uZisbrTs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788485157; v=1; x=1789089957;
 b=j6UA0BfVqdi39bQbxxNBOd01Rp8naCORtp/ZW8J3ej+w7ud2BLKjtR4tZuLUHr/XPv9hBQAi
 DyKvWVeTvC1yRR7DEG1HvPoISKUVQenV++thvCzdp97tzTkyhvpaimoRGYxd6aY8134Hvb5mWeE
 LpHx6TGb7K9Mw/v4gEW/cZC4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3680ecaac802fcbf;
	Fri, 04 Sep 2026 01:25:57 +0000
X-Mizu-Trace-ID: 3680ecaac802fcbf
X-Migadu-Flow: FLOW_OUT
Message-ID: <5e0d1386-b094-4d4e-8569-e6b584f955c5@linux.dev>
Date: Fri, 4 Sep 2026 09:25:52 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] cgroup/cpuset: Factor out child partition
 validation
To: Waiman Long <longman@redhat.com>, Guopeng Zhang
 <guopeng.zhang@linux.dev>, cgroups@vger.kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
 <20260902102615.79189-2-guopeng.zhang@linux.dev>
 <5842edcd-9283-4a87-afc9-50e51962368e@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <5842edcd-9283-4a87-afc9-50e51962368e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/4/2026 2:33 AM, Waiman Long wrote:
> On 9/2/26 6:26 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> compute_partition_effective_cpumask() checks whether each valid child
>> partition remains covered by the parent exclusive CPU mask and whether it
>> would consume all remaining CPUs of a populated parent.
>>
>> Factor these two checks into child_partition_error() so the same rules can
>> be reused when evaluating a proposed parent configuration. This is a
>> preparatory refactoring with no intended functional change.
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 38 +++++++++++++++++++++++++++++---------
>>   1 file changed, 29 insertions(+), 9 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 8f24171b6055..6994dc75d940 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct 
>> cpuset *cs, int cmd,
>>       return 0;
>>   }
>> +/*
>> + * Return the error that will invalidate a child partition under a proposed
>> + * parent partition configuration.
>> + */
>> +static enum prs_errcode
>> +child_partition_error(struct cpuset *child,
>> +              const struct cpumask *partition_cpus,
>> +              const struct cpumask *remaining_cpus,
>> +              bool parent_populated)
> I think you should add some functional comments on what "partition_cpus" and 
> "remaining_cpus" are supposed to be so that caller knows what to pass into this 
> helper.

Would it help to rename them to excpus and local_excpus?
local already implies "excluding children" (just like cgroup.stat.local), so I 
think that makes the intent clearer.

>> +{
>> +    if (!cpumask_subset(child->effective_xcpus, partition_cpus))
>> +        return PERR_INVCPUS;
>> +
>> +    if (parent_populated &&
>> +        cpumask_subset(remaining_cpus, child->effective_xcpus))
>> +        return PERR_NOCPUS;
>> +
>> +    return PERR_NONE;
>> +}
>> +
>>   /**
>>    * compute_partition_effective_cpumask - compute effective_cpus for partition
>>    * @cs: partition root cpuset
>> @@ -2121,6 +2141,8 @@ static void compute_partition_effective_cpumask(struct 
>> cpuset *cs,
>>       rcu_read_lock();
>>       cpuset_for_each_child(child, css, cs) {
>> +        enum prs_errcode child_err;
>> +
>>           if (!is_partition_valid(child))
>>               continue;
>> @@ -2129,15 +2151,13 @@ static void compute_partition_effective_cpumask(struct 
>> cpuset *cs,
>>            * partition root.
>>            */
>>           WARN_ON_ONCE(is_remote_partition(child));
>> -        WRITE_ONCE(child->prs_err, 0);
>> -        if (!cpumask_subset(child->effective_xcpus,
>> -                    cs->effective_xcpus))
>> -            WRITE_ONCE(child->prs_err, PERR_INVCPUS);
>> -        else if (populated &&
>> -             cpumask_subset(new_ecpus, child->effective_xcpus))
>> -            WRITE_ONCE(child->prs_err, PERR_NOCPUS);
>> -
>> -        if (child->prs_err) {
>> +        WRITE_ONCE(child->prs_err, PERR_NONE);
>> +        child_err = child_partition_error(child, cs->effective_xcpus,
>> +                          new_ecpus, populated);
>> +        if (child_err)
>> +            WRITE_ONCE(child->prs_err, child_err);
>> +
> 
> You can ignore the inital PERR_NONE write and always write the child_err value 
> into child->prs_err.
> 
> Not big issue, just some nits.
> 
> Cheers,
> Longman
> 
>> +        if (child_err) {
>>               int old_prs = child->partition_root_state;
>>               /*
> 

-- 
Best regards
Ridong

