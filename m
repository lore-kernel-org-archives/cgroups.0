Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53D13093CB
	for <cgroups@vger.kernel.org>; Sun,  6 Sep 2026 01:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788657107; cv=none; b=sjWQoCtnbvO5BxTwtbEFYC6BeF3/qpI6F4v8qYDSxHZKLTFubzSvJ70Q4mZslUqmDB+FpUPUhB1ZIPVE9+2DcKVtCfIEON2A0Hp7A0Wa50s881d6VsqYGOz032TDPaLq7v0fYYcPl119bDzQAX5WLNDKFTY/dFGzu8CBLrMakjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788657107; c=relaxed/simple;
	bh=zW7QNqiwYguh6Fh5GCujAnJ8mRwsK4X04rOZ+SnCXzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OSjpvzvDU6vicqKgFd36kfSX22NdwYVfiLfe+OsR5Zn+bydCwW4oKCmctHasNktOvXzXLLgNVXvYITu2/nQ8nnmLKOt9ziViAFOP/UbopHDZe/NxtN12RXKlGlD78Vt//ThOPsleJarLSu6v2PE/s5MbkkJu4WqT56AEMKlTMfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TIs/2n7U; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TIs/2n7U"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zW7QNqiwYguh6Fh5GCujAnJ8mRwsK4X04rOZ+SnCXzU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788657102; v=1; x=1789261902;
 b=TIs/2n7UPrFFtv67oCWx/Km/lwRhljfKn3fPIRoN9oGPoYy/DjooFk1oMYppJxjBtW8V8SX2
 zfGxbVPfTtAQetOA+9sohO8ihXzBWoB5SLzHfyXRRpIiJ5ls64s9pv8CFxS3uDctIkPOqpH183S
 iwoKZWvHi/K/BhI5S23Q/+D8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d50bff216045863e;
	Sun, 06 Sep 2026 01:11:32 +0000
X-Mizu-Trace-ID: d50bff216045863e
X-Migadu-Flow: FLOW_OUT
Message-ID: <f65d4985-5e21-4e29-b5f4-dcff0fa479ab@linux.dev>
Date: Sun, 6 Sep 2026 09:11:24 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in
 effective_protection()
To: David Laight <david.laight.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
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
 <20260904093743.23cde26b@pumpkin>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260904093743.23cde26b@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/4/2026 4:37 PM, David Laight wrote:
> On Thu,  3 Sep 2026 11:19:51 +0800
> Ridong Chen <ridong.chen@linux.dev> wrote:
> 
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
> 
> On 32bit it is only necessary to use a 64bit intermediary.
> mul_u64_u64_div_u64() will drop back to the (probably faster) 64 by 64
> divide (and then maybe to a 64 by 32 one).
> But there is a lot of extra code before that happens.
> 

Hi David,

Thank you for your review.

Do you want me to split this for 32-bit, or is keeping the single
mul_u64_u64_div_u64() call for readability fine with you?

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
>>   
>> -		ep += unclaimed;
>> +		ep += mul_u64_u64_div_u64(unclaimed, unprotected, parent_unprotected);
> 
> If the ratio is forced to 1 there is no point doing the scaling.
> So maybe:
> 		if (likely(parent_unprotected > unprotected))
> 			unclaimed = mul_u64_u64_div_u64(unclaimed, unprotected,
> 							parent_unprotected);
> 		ep += unclaimed;
> OTOH if the min() generates a cmov rather than a conditional branch
> then you don't get a statically mispredicted branch in the normal case
> (which is very likely with the empty 'else' branch).
> 

I'd rather keep it as-is and avoid the extra branch. Does that work for you?

> 
>>   	}
>>   
>>   	return ep;
> 

-- 
Best regards
Ridong

