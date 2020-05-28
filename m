From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 28 May 2020 17:48:48 +0100
Message-ID: <20200528164848.GB839178@chrisdown.name>
References: <20200520165131.GB630613@cmpxchg.org>
 <20200520170430.GG6462@dhcp22.suse.cz>
 <20200520175135.GA793901@cmpxchg.org>
 <20200521073245.GI6462@dhcp22.suse.cz>
 <20200521135152.GA810429@cmpxchg.org>
 <20200521143515.GU6462@dhcp22.suse.cz>
 <20200521163833.GA813446@cmpxchg.org>
 <20200521173701.GX6462@dhcp22.suse.cz>
 <20200521184505.GA815980@cmpxchg.org>
 <20200528163101.GJ27484@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UwZ28g34UZ/LmYps/esI5h2JZjKeclqR/inpTX02z2o=;
        b=PPb3j7a/BdD86VI8igVSltNvHQ9B8pjLLH1ePEwa/baG3Wzmss76Lv0gRQbqiB0y7I
         qB3fSv9TLfHEKw23N/5h80TiBDGczfNsmJpY+OMnOWzCIfO1yGUMNJi8SGt8vStQ6HYl
         zOW8eKaK+Jq3r13HH3nV3qAD0HpX1p6KWe31I=
Content-Disposition: inline
In-Reply-To: <20200528163101.GJ27484-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Michal Hocko writes:
>> We send a simple bug fix: bring this instance of reclaim in line with
>> how everybody else is using the reclaim API, to meet the semantics as
>> they are intendend and documented.
>
>Here is where we are not on the same page though. Once you have identified
>that the main problem is that the reclaim fails too early to meet the
>target then the fix would be to enforce that target. I have asked why
>this hasn't been done and haven't got any real answer for that. Instead
>what you call "a simple bug fix" has larger consequences which are not
>really explained in the changelog and they are also not really trivial
>to see. If the changelog explicitly stated that the proportional memory
>reclaim is not sufficient because XYZ and the implementation has been
>changed to instead meet the high limit target then this would be a
>completely different story and I believe we could have saved some
>discussion.

I agree that the changelog can be made more clear. Any objection if I send v2 
with changelog changes to that effect, then? :-)

>> And somehow this is controversial, and we're just changing around user
>> promises as we see fit for our particular usecase?
>>
>> I don't even understand how the supposed alternate semantics you read
>> between the lines in the documentation would make for a useful
>> feature: It may fail to contain a group of offending tasks to the
>> configured limit, but it will be fair to those tasks while doing so?
>>
>> > But if your really want to push this through then let's do it
>> > properly at least. memcg->memcg_nr_pages_over_high has only very
>> > vague meaning if the reclaim target is the high limit.
>>
>> task->memcg_nr_pages_over_high is not vague, it's a best-effort
>> mechanism to distribute fairness. It's the current task's share of the
>> cgroup's overage, and it allows us in the majority of situations to
>> distribute reclaim work and sleeps in proportion to how much the task
>> is actually at fault.
>
>Agreed. But this stops being the case as soon as the reclaim target has
>been reached and new reclaim attempts are enforced because the memcg is
>still above the high limit. Because then you have a completely different
>reclaim target - get down to the limit. This would be especially visible
>with a large memcg_nr_pages_over_high which could even lead to an over
>reclaim.

We actually over reclaim even before this patch -- this patch doesn't bring 
much new in that regard.

Tracing try_to_free_pages for a cgroup at the memory.high threshold shows that 
before this change, we sometimes even reclaim on the order of twice the number 
of pages requested. For example, I see cases where we requested 1000 pages to 
be reclaimed, but end up reclaiming 2000 in a single reclaim attempt.
