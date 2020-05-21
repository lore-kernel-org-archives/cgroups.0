From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 12:27:11 +0100
Message-ID: <20200521112711.GA990580@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H4LfaHt6L10FeQY8nm9a57dmlVVdNDF0YNl/G/MF8qI=;
        b=AP4vNlFUdr95Qzwx1esLpuRN96kKRbg57is1WmSaj4Cf7+i9PxbEVUd63qKTadoE8z
         Vtcqy+TmjyJZwfzBvl2qC1fe7HAEZYtsdsW66LFMRako4UkQclny8yqU+w0amxnGTmJ5
         nd40M/6vZ5mJfATTC7HNb+lcUtBeBZfOSPFlY=
Content-Disposition: inline
In-Reply-To: <20200521071929.GH6462@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Michal Hocko writes:
>On Wed 20-05-20 21:26:50, Chris Down wrote:
>> Michal Hocko writes:
>> > Let me try to understand the actual problem. The high memory reclaim has
>> > a target which is proportional to the amount of charged memory. For most
>> > requests that would be SWAP_CLUSTER_MAX though (resp. N times that where
>> > N is the number of memcgs in excess up the hierarchy). I can see to be
>> > insufficient if the memcg is already in a large excess but if the
>> > reclaim can make a forward progress this should just work fine because
>> > each charging context should reclaim at least the contributed amount.
>> >
>> > Do you have any insight on why this doesn't work in your situation?
>> > Especially with such a large inactive file list I would be really
>> > surprised if the reclaim was not able to make a forward progress.
>>
>> Reclaim can fail for any number of reasons, which is why we have retries
>> sprinkled all over for it already. It doesn't seem hard to believe that it
>> might just fail for transient reasons and drive us deeper into the hole as a
>> result.
>
>Reclaim can certainly fail. It is however surprising to see it fail with
>such a large inactive lru list and reasonably small reclaim target.

Why do you think the reclaim target is small? In the case of generating tons of 
dirty pages, current->memcg_nr_pages_over_high can grow to be huge (on the 
order of several tens of megabytes or more).

>Having the full LRU of dirty pages sounds a bit unusual, IO throttling
>for v2 and explicit throttling during the reclaim for v1 should prevent
>from that. If the reclaim gives up too easily then this should be
>addressed at the reclaim level.

I'm not sure I agree. Reclaim knows what you asked it to do: reclaim N pages, 
but what to do about the situation when it fails to satisfy that is a job for 
the caller. In this case, we are willing to even tolerate a little bit of 
overage up to the 10ms throttle threshold. In other cases, we want to do other 
checks first before retrying, because the tradeoffs are different. Putting all 
of this inside the reclaim logic seems unwieldy.

>> In this case, a.) the application is producing tons of dirty pages, and b.)
>> we have really heavy systemwide I/O contention on the affected machines.
>> This high load is one of the reasons that direct and kswapd reclaim cannot
>> keep up, and thus nr_pages can become a number of orders of magnitude larger
>> than SWAP_CLUSTER_MAX. This is trivially reproducible on these machines,
>> it's not an edge case.
>
>Please elaborate some more. memcg_nr_pages_over_high shouldn't really
>depend on the system wide activity. It should scale with the requested
>charges. So yes it can get large for something like a large read/write
>which does a lot of allocations in a single syscall before returning to
>the userspace.

It can also get large if a number of subsequent reclaim attempts are making 
progress, but not satisfying demand fully, as is happening here. As a facetious 
example, even if we request N and reclaim can satisfy N-1 each time, eventually 
those single pages can grow to become a non-trivial size.

>But ok, let's say that the reclaim target is large and then a single
>reclaim attempt might fail. Then I am wondering why your patch is not
>really targetting to reclaim memcg_nr_pages_over_high pages and instead
>push for reclaim down to the high limit.
>
>The main problem I see with that approach is that the loop could easily
>lead to reclaim unfairness when a heavy producer which doesn't leave the
>kernel (e.g. a large read/write call) can keep a different task doing
>all the reclaim work. The loop is effectivelly unbound when there is a
>reclaim progress and so the return to the userspace is by no means
>proportional to the requested memory/charge.

It's not unbound when there is reclaim progress, it stops when we are within 
the memory.high throttling grace period. Right after reclaim, we check if 
penalty_jiffies is less than 10ms, and abort and further reclaim or allocator 
throttling:

	retry_reclaim:
		nr_reclaimed = reclaim_high(memcg, nr_pages, GFP_KERNEL);

		/*
		 * memory.high is breached and reclaim is unable to keep up. Throttle
		 * allocators proactively to slow down excessive growth.
		 */
		penalty_jiffies = calculate_high_delay(memcg, nr_pages);

		/*
		 * Don't sleep if the amount of jiffies this memcg owes us is so low
		 * that it's not even worth doing, in an attempt to be nice to those who
		 * go only a small amount over their memory.high value and maybe haven't
		 * been aggressively reclaimed enough yet.
		 */
		if (penalty_jiffies <= HZ / 100)
			goto out;

Regardless, you're pushing for different reclaim semantics for memory.high than 
memory.max here, which requires evidence that the current approach taken for 
memory.max is wrong or causing issues. And sure, you can say that that's 
because in memory.max's case we would have a memcg OOM, but again, that's not 
really different from how memory.high is supposed to work: with a userspace OOM 
killer monitoring it and producing OOM kills as necessary.
