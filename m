Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F0844E659
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774519; cv=none; b=ITq6rt5n5BUSQzPKa65eFzAuTiriDbwUf3hlD2T88dXSGVjf/tscesQY4bPDr49hWIf/q8ey+eASWnoTyksUtXdnJPtlhKjYecOfp5YiJ8lcrbOJqiL8WFNMq966geT04luT0U37+UTThvkWlujkgJaPsCKNeAc+Kl9VtkpGQ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774519; c=relaxed/simple;
	bh=OwGbvgYEbOe76OK9GCEyBQybyVZ+vhGr7ZHbuXJ9nkI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=F7WdkRbvoLVttdfjb7L7R46Y+CVwuM7SB28b1OZNNCPeclfKbU3eRke2Nm7LG0ID+Aob41GwKGUKIkkCGK7ZebamZOJ1Onb+fUK1uQZre3eRgJ2ra9Z+I5qQjPGuCMoT6r0zpQqKZu3bKJqIjR3TlBohELzz4sJLMwr3262k4wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GC5JUerM; arc=none smtp.client-ip=95.215.58.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GC5JUerM"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OwGbvgYEbOe76OK9GCEyBQybyVZ+vhGr7ZHbuXJ9nkI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788774515; v=1; x=1789379315;
 b=GC5JUerMzz+jJyr/Z+K0JNdPwWvMBwzjdlO6PZ1itBe1h46hJJcxf083B9PehE3X0MzBY7E2
 xTrtKWRCNnabnmRxmE3xiJYJADTq+CmALjYxRHltT34knMdvJwW068WIwARYcR7tHD4AC/riKhC
 3UDkY7zcX8W2swutmKvY6tFM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8a4cd58bb8253468;
	Mon, 07 Sep 2026 09:48:35 +0000
X-Mizu-Trace-ID: 8a4cd58bb8253468
X-Migadu-Flow: FLOW_OUT
Message-ID: <8c4ae94b-503f-4ef5-9e60-724378b5fd23@linux.dev>
Date: Mon, 7 Sep 2026 17:48:30 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Guopeng Zhang <guopeng.zhang@linux.dev>
Subject: Re: [PATCH v3 1/7] cgroup/cpuset: Factor out child partition
 validation
To: Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 ridong.chen@linux.dev
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
 <20260902102615.79189-2-guopeng.zhang@linux.dev>
 <9ff85fed-190c-4a8d-8d47-2a37990c1cbb@redhat.com>
Content-Language: en-US
In-Reply-To: <9ff85fed-190c-4a8d-8d47-2a37990c1cbb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/4 03:11, Waiman Long 写道:
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
>> @@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>       return 0;
>>   }
>>   +/*
>> + * Return the error that will invalidate a child partition under a proposed
>> + * parent partition configuration.
>> + */
>> +static enum prs_errcode
>> +child_partition_error(struct cpuset *child,
>> +              const struct cpumask *partition_cpus,
>> +              const struct cpumask *remaining_cpus,
>> +              bool parent_populated)
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
>> @@ -2121,6 +2141,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>         rcu_read_lock();
>>       cpuset_for_each_child(child, css, cs) {
>> +        enum prs_errcode child_err;
>> +
>>           if (!is_partition_valid(child))
>>               continue;
>>   @@ -2129,15 +2151,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>            * partition root.
>>            */
>>           WARN_ON_ONCE(is_remote_partition(child));
>> -        WRITE_ONCE(child->prs_err, 0);
>> -        if (!cpumask_subset(child->effective_xcpus,
>> -                    cs->effective_xcpus))
> 
> Looking at the patch again, I now see that the current code is incorrect. It should be "if (!cpumask_subset(child->effective_xcpus, new_ecpus))" So you only need to pass the "parent_excpus" (for instance) to the new helper instead of passing two.
> 

Longman, thanks for your review.

Yes, you are right that using `cs->effective_xcpus` here is incorrect.

In v1, I had a change for this issue, and based on your comment [1], I moved it to another fix. I also followed Ridong's suggestion to split the original 17-patch series into smaller series. I split it into three parts locally, and the current series is the second part, so this fix is not included here.

I plan to address this in the third series, together with the CPU ownership and isolation accounting issues following child partition invalidation.

In that series, the two masks have different meanings: the newly computed unfiltered exclusive mask, including offline CPUs, is used for the child containment check, while the active CPU mask remaining after child ownership is accounted for is used for the `PERR_NOCPUS` check. So I would prefer to keep the two-mask interface here and clarify their meanings with comments.

Does this approach make sense to you?

[1] https://lore.kernel.org/all/3bf50da2-f13a-4cef-bfb8-cd592f862164@redhat.com/

Thanks,
Guopeng



