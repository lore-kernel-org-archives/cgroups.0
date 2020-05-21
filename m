From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 13:57:59 +0100
Message-ID: <20200521125759.GD990580@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
 <20200521120455.GM6462@dhcp22.suse.cz>
 <20200521122327.GB990580@chrisdown.name>
 <20200521123742.GO6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zE0q+anVt0YABBKa0iOm9d1qeItC3z2sLcxqGncBVQI=;
        b=bLOzNR/s9S7I+d6/VAHg3FcIB91TnIH4PTsQDruoSc+fbSfnEh3cUbmsQecHLhLaOX
         4vj+ItRpXsQBcQkYDtk35GJ237GUVOK950cf+h6475GY+7lSmLi/9YcoCmEDa9fwkyN1
         veDn1mKKC0Xc4FQ/FjilKO0iTyrz98Xo8C16s=
Content-Disposition: inline
In-Reply-To: <20200521123742.GO6462@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Michal Hocko writes:
>> A cgroup is a unit and breaking it down into "reclaim fairness" for
>> individual tasks like this seems suspect to me. For example, if one task in
>> a cgroup is leaking unreclaimable memory like crazy, everyone in that cgroup
>> is going to be penalised by allocator throttling as a result, even if they
>> aren't "responsible" for that reclaim.
>
>You are right, but that doesn't mean that it is desirable that some
>tasks would be throttled unexpectedly too long because of the other's activity.

Are you really talking about throttling, or reclaim? If throttling, tasks are 
already throttled proportionally to how much this allocation is contributing to 
the overage in calculate_high_delay.

If you're talking about reclaim, trying to reason about whether the overage is 
the result of some other task in this cgroup or the task that's allocating 
right now is something that we already know doesn't work well (eg. global OOM). 

>> So the options here are as follows when a cgroup is over memory.high and a
>> single reclaim isn't enough:
>>
>> 1. Decline further reclaim. Instead, throttle for up to 2 seconds.
>> 2. Keep on reclaiming. Only throttle if we can't get back under memory.high.
>>
>> The outcome of your suggestion to decline further reclaim is case #1, which
>> is significantly more practically "unfair" to that task. Throttling is
>> extremely disruptive to tasks and should be a last resort when we've
>> exhausted all other practical options. It shouldn't be something you get
>> just because you didn't try to reclaim hard enough.
>
>I believe I have asked in other email in this thread. Could you explain
>why enforcint the requested target (memcg_nr_pages_over_high) is
>insufficient for the problem you are dealing with? Because that would
>make sense for large targets to me while it would keep relatively
>reasonable semantic of the throttling - aka proportional to the memory
>demand rather than the excess.

memcg_nr_pages_over_high is related to the charge size. As such, if you're way 
over memory.high as a result of transient reclaim failures, but the majority of 
your charges are small, it's going to hard to make meaningful progress:

1. Most nr_pages will be MEMCG_CHARGE_BATCH, which is not enough to help;
2. Large allocations will only get a single reclaim attempt to succeed.

As such, in many cases we're either doomed to successfully reclaim a paltry 
amount of pages, or fail to reclaim a lot of pages. Asking try_to_free_pages() 
to deal with those huge allocations is generally not reasonable, regardless of 
the specifics of why it doesn't work in this case.
