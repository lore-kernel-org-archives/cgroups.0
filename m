Received: from mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64AA1D416C
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 02:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788746921; cv=none; b=dpd6reIfrQ+HwG+N6HjvpGxT+aZkWEPJ9q78AkquSy++Sjjv8MN8vLgsktxWv12WqTBemoAJSKtQaVor+BW3xKHqZC7aJvrLs/uQJIBOus2GrJnkdmkoeK+DBH+JJZlQbpPpX0SgtCO4wlVXv4HLAsUWmtdO0L3f8HC0/S4tp2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788746921; c=relaxed/simple;
	bh=LzaE8JGTRIG+1dFbwA1G5yAmK7QHt16tXyvwzCJNb+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kVi+7sp+aeXiuWupbAjo1HgiZ1g6uZ7xAsCSDnufqQKjPG8G3QZ3OnyVACeiNw9KUX83BgyRHt0GRE7IvsnTCqHzzzUIvtR6JsKUwL0Y0opr3555Ve/iX7WjjVPJtVbz8gpQ1ihLOeDuXlRzCG+745IjhDOE0DNhJwQBlLkeJIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q9kMccRM; arc=none smtp.client-ip=95.215.58.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q9kMccRM"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LzaE8JGTRIG+1dFbwA1G5yAmK7QHt16tXyvwzCJNb+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788746915; v=1; x=1789351715;
 b=Q9kMccRMT3uafmyFewup31luuM6O10A1KE/oDyetb1ndPJ2hYkFQK42/jV12GtglNUpZt6r3
 CNs8k4vdBFB+KZwvHULoCNNoWg3KfdZ/DOa2l+Ojqz03fHeX3vvCOPS/0nNY/TVoSUwX0f5OXQK
 CMcOhvrDBDycS8Gm5UEnG2bs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 385f2f7eacdaa4a4;
	Mon, 07 Sep 2026 02:08:28 +0000
X-Mizu-Trace-ID: 385f2f7eacdaa4a4
X-Migadu-Flow: FLOW_OUT
Message-ID: <e081c02a-a663-484b-8ce6-1d7624a4188e@linux.dev>
Date: Mon, 7 Sep 2026 10:08:18 +0800
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
 <f65d4985-5e21-4e29-b5f4-dcff0fa479ab@linux.dev>
 <20260906111618.644362b3@pumpkin>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260906111618.644362b3@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/6/2026 6:16 PM, David Laight wrote:
> On Sun, 6 Sep 2026 09:11:24 +0800
> Ridong Chen<ridong.chen@linux.dev> wrote:
> 
>> On 9/4/2026 4:37 PM, David Laight wrote:
>>> On Thu,  3 Sep 2026 11:19:51 +0800
>>> Ridong Chen<ridong.chen@linux.dev> wrote:
>>>    
>>>> From: Ridong Chen<chenridong@xiaomi.com>
>>>>
>>>> effective_protection() scales a parent's protection by a ratio of page
>>>> counts, e.g. for recursive protection:
>>>>
>>>> 	(parent_effective - siblings_protected) * (usage - protected)
>>>> 		/ (parent_usage - siblings_protected)
>>>>
>>>> The multiply is done at unsigned long width before dividing. On systems
>>>> with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
>>>> protection value and silently breaking memory.min/low enforcement.
>>>>
>>>> Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
>>>> usage and parent_usage are not read atomically (a child is charged
>>>> before its parent), usage - protected can briefly exceed the divisor,
>>>> making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
>>>> the ratio stays <= 1.
>>>>
>>>> Reported by the sashiko review tool [1].
>>>>
>>>> [1]https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev? 
>>>> part=1
>>>>
>>>> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
>>>> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
>>>> Cc:stable@vger.kernel.org
>>>> Assisted-by: Claude:claude-opus-4-8
>>>> Reviewed-by: Barry Song<baohua@kernel.org>
>>>> Signed-off-by: Ridong Chen<chenridong@xiaomi.com>
>>>> ---
>>>>    mm/page_counter.c | 19 +++++++++++++------
>>>>    1 file changed, 13 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/mm/page_counter.c b/mm/page_counter.c
>>>> index 661e0f2a5127..e8bd512069c5 100644
>>>> --- a/mm/page_counter.c
>>>> +++ b/mm/page_counter.c
>>>> @@ -8,6 +8,7 @@
>>>>    #include <linux/page_counter.h>
>>>>    #include <linux/atomic.h>
>>>>    #include <linux/kernel.h>
>>>> +#include <linux/math64.h>
>>>>    #include <linux/string.h>
>>>>    #include <linux/sched.h>
>>>>    #include <linux/bug.h>
>>>> @@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
>>>>    	 * otherwise get a smaller chunk than what they claimed.
>>>>    	 */
>>>>    	if (siblings_protected > parent_effective)
>>>> -		return protected * parent_effective / siblings_protected;
>>>> +		return mul_u64_u64_div_u64(protected, parent_effective,
>>>> +					   siblings_protected);
>>> On 32bit it is only necessary to use a 64bit intermediary.
>>> mul_u64_u64_div_u64() will drop back to the (probably faster) 64 by 64
>>> divide (and then maybe to a 64 by 32 one).
>>> But there is a lot of extra code before that happens.
>>>    
>> Hi David,
>>
>> Thank you for your review.
>>
>> Do you want me to split this for 32-bit, or is keeping the single
>> mul_u64_u64_div_u64() call for readability fine with you?
> Maybe I'll look at wrapping mul_u64_add_u64_div_u64() with something that
> checks statically_true(((a) | (b) | (c) | (d)) < 1ull << 32).
> 
> Probably neater than the conditional here.
> 

Agreed. Other callers face the same 32-bit concern, so a wrapper that does the 
statically_true(...) check once would be cleaner than open-coding a conditional 
in each site.

>>>>    
>>>>    	/*
>>>>    	 * Ok, utilized protection of all children is within what the
>>>> @@ -397,13 +399,18 @@ static unsigned long effective_protection(unsigned long usage,
>>>>    	if (parent_effective > siblings_protected &&
>>>>    	    parent_usage > siblings_protected &&
>>>>    	    usage > protected) {
>>>> -		unsigned long unclaimed;
>>>> +		unsigned long unclaimed = parent_effective - siblings_protected;
>>>> +		unsigned long unprotected = usage - protected;
>>>> +		unsigned long parent_unprotected = parent_usage - siblings_protected;
>>>>    
>>>> -		unclaimed = parent_effective - siblings_protected;
>>>> -		unclaimed *= usage - protected;
>>>> -		unclaimed /= parent_usage - siblings_protected;
>>>> +		/*
>>>> +		 * The usages aren't read atomically, so a child can transiently
>>>> +		 * appear to use more than its parent, making the ratio exceed 1
>>>> +		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
>>>> +		 */
>>>> +		unprotected = min(unprotected, parent_unprotected);
>>>>    
>>>> -		ep += unclaimed;
>>>> +		ep += mul_u64_u64_div_u64(unclaimed, unprotected, parent_unprotected);
>>> If the ratio is forced to 1 there is no point doing the scaling.
>>> So maybe:
>>> 		if (likely(parent_unprotected > unprotected))
>>> 			unclaimed = mul_u64_u64_div_u64(unclaimed, unprotected,
>>> 							parent_unprotected);
>>> 		ep += unclaimed;
>>> OTOH if the min() generates a cmov rather than a conditional branch
>>> then you don't get a statically mispredicted branch in the normal case
>>> (which is very likely with the empty 'else' branch).
>>>    
>> I'd rather keep it as-is and avoid the extra branch. Does that work for you?
> I nearly came to that conclusion while writing the comment!
> Actually the same might go for the other three tests - generating a 0 or 1
> from a conditional move ought to be better than the possibly mispredicted
> very unlikely branch.
> (I am right in thinking that they should never fail?)
> 

No — these three checks fail all the time in normal operation, so I'd
keep the branch:

if (parent_effective > siblings_protected &&
	parent_usage > siblings_protected &&
	usage > protected) {

Checks 1 and 3 just ask "is there anything left to distribute?". Often
there isn't, so they fail routinely.

Check 2 is a divide-by-zero guard. parent_usage - siblings_protected is
the divisor. A conditional-move can't replace it: the division would run
anyway and only get multiplied by zero afterwards, so we'd still divide
by zero when the two are equal. The branch is what stops us reaching the
division.

> I also suspect the #UD is the least of the problems.
> You don't want the scaling to produce a bigger number at all.
> 

Agreed, and the min() already ensures that. It caps the value so the
result can never be larger than unclaimed. Avoiding the trap is just a
bonus of that same cap.

So I'll keep the patch as-is. Thanks for the review!

-- 
Best regards
Ridong

