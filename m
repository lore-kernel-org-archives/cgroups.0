Received: from mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5348D3ACF10
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 03:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788492864; cv=none; b=FIC/GrsOSiqKmuLNr4zmLqvTTZhOH5rGTXepLDztsCNtA/GQOEskE3DSTR+IoWPPVUadC8qGMm1qrbF6r6XqeawKbfk83TatgHjtvkOPmlKMoLL6rLEXG+wsgZlMUao+4pHWQX8j345EZADApmBtXsSCkz6b/ZmtTa2qfTg6hG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788492864; c=relaxed/simple;
	bh=3SHH6vyIlZHKBx7a2xpBQWHNha23K0qy+t33DbJnCJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WUNNd+JDRRSfuJfImqw3Gaqris/BInvHBzffqTDd0b1xHI6wk95PScOSa+xoMqjDs7uucRLxYQ46YUbKcKieU8Zgno7shMxbvNoOA+ihtj1YxvE3c3ve+sOzI+l2uq0fT/qvYsmmP+ztBbfGC7pwnWnjYkCQ5ep5M1ZQhQ0+t9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gatbf+PX; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gatbf+PX"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3SHH6vyIlZHKBx7a2xpBQWHNha23K0qy+t33DbJnCJ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788492860; v=1; x=1789097660;
 b=gatbf+PXkROPX8r+/toXU0c7tzFZwmNXoMwnKB9jesRtDCuXkSmKWykcxVpaEa3YKCW39mrr
 d3LY0ltYkG842W0sgNSUPcf6S4wSLFxIhG8SfOIVLmooYFA+jZs+VpQQTUoo9Z97iSZeZuMdVL4
 XEHtFdtngQHVPlB01J7OYoBk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 76df9403c32be4f8;
	Fri, 04 Sep 2026 03:34:20 +0000
X-Mizu-Trace-ID: 76df9403c32be4f8
X-Migadu-Flow: FLOW_OUT
Message-ID: <ce8d1bec-d281-459f-920c-7ce5bb17e417@linux.dev>
Date: Fri, 4 Sep 2026 11:34:11 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in
 effective_protection()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Chris Down <chris@chrisdown.name>,
 Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
 <20260903031952.1120321-2-ridong.chen@linux.dev>
 <20260903140003.GR3004@cmpxchg.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260903140003.GR3004@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/3/2026 10:00 PM, Johannes Weiner wrote:
> On Thu, Sep 03, 2026 at 11:19:51AM +0800, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> effective_protection() scales a parent's protection by a ratio of page
>> counts, e.g. for recursive protection:
>>
>> 	(parent_effective - siblings_protected) * (usage - protected)
>> 		/ (parent_usage - siblings_protected)
>>
>> The multiply is done at unsigned long width before dividing. On systems
>> with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
>> protection value and silently breaking memory.min/low enforcement.
>>
>> Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
>> usage and parent_usage are not read atomically (a child is charged
>> before its parent), usage - protected can briefly exceed the divisor,
>> making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
>> the ratio stays <= 1.
>>
>> Reported by the sashiko review tool [1].
>>
>> [1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1
>>
>> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
>> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Claude:claude-opus-4-8
>> Reviewed-by: Barry Song <baohua@kernel.org>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   mm/page_counter.c | 19 +++++++++++++------
>>   1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/page_counter.c b/mm/page_counter.c
>> index 661e0f2a5127..e8bd512069c5 100644
>> --- a/mm/page_counter.c
>> +++ b/mm/page_counter.c
>> @@ -8,6 +8,7 @@
>>   #include <linux/page_counter.h>
>>   #include <linux/atomic.h>
>>   #include <linux/kernel.h>
>> +#include <linux/math64.h>
>>   #include <linux/string.h>
>>   #include <linux/sched.h>
>>   #include <linux/bug.h>
>> @@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
>>   	 * otherwise get a smaller chunk than what they claimed.
>>   	 */
>>   	if (siblings_protected > parent_effective)
>> -		return protected * parent_effective / siblings_protected;
>> +		return mul_u64_u64_div_u64(protected, parent_effective,
>> +					   siblings_protected);
>>   
>>   	/*
>>   	 * Ok, utilized protection of all children is within what the
>> @@ -397,13 +399,18 @@ static unsigned long effective_protection(unsigned long usage,
>>   	if (parent_effective > siblings_protected &&
>>   	    parent_usage > siblings_protected &&
>>   	    usage > protected) {
>> -		unsigned long unclaimed;
>> +		unsigned long unclaimed = parent_effective - siblings_protected;
>> +		unsigned long unprotected = usage - protected;
>> +		unsigned long parent_unprotected = parent_usage - siblings_protected;
>>   
>> -		unclaimed = parent_effective - siblings_protected;
>> -		unclaimed *= usage - protected;
>> -		unclaimed /= parent_usage - siblings_protected;
>> +		/*
>> +		 * The usages aren't read atomically, so a child can transiently
>> +		 * appear to use more than its parent, making the ratio exceed 1
>> +		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
>> +		 */
>> +		unprotected = min(unprotected, parent_unprotected);
> 
> Looks correct to me. But a few nits on readability, since this code
> already is quite painfully complicated.
> 
> Please don't do math in the declaration block.
> 
> `unclaimed` made a bit more sense when it held *this group's* final
> share of the unclaimed protection. As an intermediate, it's *the
> parent's* unclaimed protection.
> 
> Put together, it should look something like this:
> 
> 		unsigned long parent_unclaimed, parent_unprotected, unprotected;
> 
> 		parent_unclaimed = parent_effective - siblings_protected;
> 		parent_unprotected = parent_usage - siblings_protected;
> 		unprotected = usage - protected;
> 
> 		/* overflow comment */
> 		unprotected = min(usage - protected, parent_unprotected);
> 		ep += mul_u64_u64_div_u64(parent_unclaimed, unprotected, parent_unprotected);
> 
> With that,
> 
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Thank you for your suggestion. Will update.

-- 
Best regards
Ridong

