From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Fri, 29 May 2020 11:08:58 +0100
Message-ID: <20200529100858.GA98458@chrisdown.name>
References: <20200520175135.GA793901@cmpxchg.org>
 <20200521073245.GI6462@dhcp22.suse.cz>
 <20200521135152.GA810429@cmpxchg.org>
 <20200521143515.GU6462@dhcp22.suse.cz>
 <20200521163833.GA813446@cmpxchg.org>
 <20200521173701.GX6462@dhcp22.suse.cz>
 <20200521184505.GA815980@cmpxchg.org>
 <20200528163101.GJ27484@dhcp22.suse.cz>
 <20200528164848.GB839178@chrisdown.name>
 <20200529073118.GE4406@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EGCTr//CJ/0Q2eA0EeEmXyU8B15617Zs/uV0IexoscQ=;
        b=Y11uIhOmRXyo7ieDj5COXVZGcR2zPt8sa+tZoxdWPwOhh82K5aMgVHdKX8MwCKQog6
         R5xkeI26afEweBp7Mx7N7MkVhsgf+2kKhl8P2I8yKYZyAHWvoHSt/vK1imWNu4m3iKGH
         pOwGMBJuSK1v0vztOth0Idw9xsAZeoIm1s9KQ=
Content-Disposition: inline
In-Reply-To: <20200529073118.GE4406@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Michal Hocko writes:
>> > > task->memcg_nr_pages_over_high is not vague, it's a best-effort
>> > > mechanism to distribute fairness. It's the current task's share of the
>> > > cgroup's overage, and it allows us in the majority of situations to
>> > > distribute reclaim work and sleeps in proportion to how much the task
>> > > is actually at fault.
>> >
>> > Agreed. But this stops being the case as soon as the reclaim target has
>> > been reached and new reclaim attempts are enforced because the memcg is
>> > still above the high limit. Because then you have a completely different
>> > reclaim target - get down to the limit. This would be especially visible
>> > with a large memcg_nr_pages_over_high which could even lead to an over
>> > reclaim.
>>
>> We actually over reclaim even before this patch -- this patch doesn't bring
>> much new in that regard.
>>
>> Tracing try_to_free_pages for a cgroup at the memory.high threshold shows
>> that before this change, we sometimes even reclaim on the order of twice the
>> number of pages requested. For example, I see cases where we requested 1000
>> pages to be reclaimed, but end up reclaiming 2000 in a single reclaim
>> attempt.
>
>This is interesting and worth looking into. I am aware that we can
>reclaim potentially much more pages during the icache reclaim and that
>there was a heated discussion without any fix merged in the end IIRC.
>Do you have any details?

Sure, we can look into this more, but let's do it separately from this patch -- 
I don't see that its merging should be contingent on that discussion :-)
