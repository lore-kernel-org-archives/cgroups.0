Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260F73F23D9
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784562010; cv=none; b=oSCa7RtEvn313pxHCDbwRuiTvPnIhzFCSFDhh40JmsszS8if2ZZZP39p9JiQVE6EM6eh3RtgKDcd3j9vD4D2tDUtIspeDepWto3+oSjvokn66SXVr16KnXRVZLkRhUWzF5VA4c4vn/gGlTrdl7jIk9F1bqCfKhU+qPxP0eXR5dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784562010; c=relaxed/simple;
	bh=WTJZCYdLdl8FvunXaL2ze6xuXe7D5qLnu1F81BOoh9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F0snHS280gafbYPHafnumiW/q4jqQYq2SV7zsrka8PCpMeWVlOVuXnJxG87G8xWMzObsgFoPjBOdVNbv8b7JQwWVa4tR2qWfK5VaxdO6NbiYrG/6HVP1FzrWXnk1BLoh1wsar4q2kb50iGs3UK7CLcvnqFF0VngIp12SmJcb6Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hEWlrGBj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hEWlrGBj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784562008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jt02QDsLMxarH6FUTUASUvUrNta1BkEjDt9XXRaS8dM=;
	b=hEWlrGBjULxEhM33sEHzkDAcv3rweukXmMtkYuMJxsz2LMHhfFqp40syDvPzyzUJ67Yqde
	gKexOA8h0+XqM2ScXAt8/24UIRsXaQZHsETjT7X77XM1GrRRtpSwBlte+eQ8e7QI+jbiHC
	UtJ8BcGXr1+NoOMxJPhdCk4/3upeUcM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-v9baXIgfP_K6cqlTDX-iPg-1; Mon,
 20 Jul 2026 11:40:04 -0400
X-MC-Unique: v9baXIgfP_K6cqlTDX-iPg-1
X-Mimecast-MFC-AGG-ID: v9baXIgfP_K6cqlTDX-iPg_1784562003
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA1F81955F1F;
	Mon, 20 Jul 2026 15:40:02 +0000 (UTC)
Received: from [10.22.89.125] (unknown [10.22.89.125])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 465CB195422E;
	Mon, 20 Jul 2026 15:40:01 +0000 (UTC)
Message-ID: <1d064ce3-8c3e-42a4-bec6-24f3bdab0111@redhat.com>
Date: Mon, 20 Jul 2026 11:40:00 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-cgroup/for-7.3] selftests/cgroup: Fix minor defects in
 test_cpuset
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260717191814.989215-1-longman@redhat.com>
 <al4tyJ2lRMj32Wpn@localhost.localdomain>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <al4tyJ2lRMj32Wpn@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


On 7/20/26 11:01 AM, Michal Koutný wrote:
> On Fri, Jul 17, 2026 at 03:18:14PM -0400, Waiman Long <longman@redhat.com> wrote:
>> With commit 98149f542530 ("selftests/cgroup: Add test for cpuset affinity
>> on controller disable"), sashiko [1] had report 3 different issues with
>> the new test_cpuset_affinity_on_controller_disable() test.
>>
>>   1) `cpu_set_equal` iterates over mask bytes instead of bits, ignoring
>>      CPUs >= 8.
> Inline comment
>
>>   2) Thread synchronization logic allows the main thread to read
>>      uninitialized stack memory, causing test flakiness.
> Hm, I cannot see it (alhtough I don't see it through), what was the
> stack memory?
> (test_phase is static, then re-initalized)
I believe it means the followings:
         cpu_set_t affinity_a_before, affinity_a_after;
         cpu_set_t affinity_b_before, affinity_b_after;

These variables are supposed to be set by child_a and child_b, but it is 
possible that child_b runs first, set ready_phase to 
AFFINITY_THREADS_READY before child_a run and set affinity_a_before 
which can be any value depending on its previous state of the stack. So 
the subsequent cpu_set_equal(&affinity_a_before, 0x3) call can pass or 
fail. That is what I believe the problem is.

>
>>   3) Test fails instead of skipping gracefully on uniprocessor systems
>>      or when CPU 1 is unavailable.
> Interesting catch.
>
>> Fix the reported issues by:
>>   1) Iterates over the bit size of the mask.
>>   2) Test the new ready flag for each thread to end the wait
>>      on the condoitional variable and eliminate the now unneeded
>>      AFFINITY_THREAD_A_READY and AFFINITY_THREADS_READY test phases.
> But the symmetric synchronization with counter is easier to reason
> about.
>
>>   3) Return KSFT_SKIP on "cpuset.cpus" setting failure.
> It'd be better to have same style with test_cpuset_prs.sh, i.e. a guard
> at the beginning requesting a minimal number of CPUs. Next time...
Yes, that can be another alternative. It is just that the current fix is 
easier.
>
>> @@ -251,7 +251,7 @@ static int cpu_set_equal(cpu_set_t *dst, unsigned long mask)
>>   	CPU_ZERO(&expected);
>>   	assert(sizeof(mask) < CPU_SETSIZE);
>>   
>> -	for (int cpu = 0; cpu < sizeof(mask); ++cpu)
>> +	for (int cpu = 0; cpu < sizeof(mask) * 8; ++cpu)
>>   		if ((1UL << cpu) & mask)
>>   			CPU_SET(cpu, &expected);
> Oh, that was my braino in how masks are stored.
> Thanks for correcting me!
>
> It should also extend the assert accordingly:
>    	assert(sizeof(mask) * 8 < CPU_SETSIZE);
>
I don't think we need an assertion like that as CPU_SETSIZE will always 
be a multiple of a long bit size . Perhaps we could have something like

     int max = min(sizeof(mask) * 8, CPU_SETSIZE);
     for (...; cpu < max; ...)

Maybe next time when we need to update test_cpuset.c.

Cheers,
Longman

