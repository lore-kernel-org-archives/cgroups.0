From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 15:22:23 +0100
Message-ID: <20200521142223.GG990580@chrisdown.name>
References: <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
 <20200521120455.GM6462@dhcp22.suse.cz>
 <20200521122327.GB990580@chrisdown.name>
 <20200521123742.GO6462@dhcp22.suse.cz>
 <20200521125759.GD990580@chrisdown.name>
 <20200521132120.GR6462@dhcp22.suse.cz>
 <20200521133324.GF990580@chrisdown.name>
 <20200521135838.GT6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HXVdafa9z18urmVF3KS9w5IeKlLTrJcs4nowtAYCuh4=;
        b=WUx7EMZXoTwxert//L8QB2qHfWrZiacoi76OCdMTNyuay8JGMq6fWNmQj0SQnbRFEh
         WRh1UcI6g53+15lQHxMx26j8V4Gxuc5gDqobeFXzjZDMWfdl3fkdcoRgn0v8vArqtsrt
         1Vv1WER8yCs5NkdKv+KCn0M/GlQDXzUtCKOAE=
Content-Disposition: inline
In-Reply-To: <20200521135838.GT6462@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Michal Hocko writes:
>On Thu 21-05-20 14:41:47, Chris Down wrote:
>> Michal Hocko writes:
>> > On Thu 21-05-20 13:57:59, Chris Down wrote:
>[...]
>> > > If you're talking about reclaim, trying to reason about whether the overage
>> > > is the result of some other task in this cgroup or the task that's
>> > > allocating right now is something that we already know doesn't work well
>> > > (eg. global OOM).
>> >
>> > I am not sure I follow you here.
>>
>> Let me rephrase: your statement is that it's not desirable "that some task
>> would be throttled unexpectedly too long because of [the activity of another
>> task also within that cgroup]" (let me know if that's not what you meant).
>> But trying to avoid that requires knowing which activity abstractly
>> instigates this entire mess in the first place, which we have nowhere near
>> enough context to determine.
>
>Yeah, if we want to be really precise then you are right, nothing like
>that is really feasible for the reclaim. Reclaiming 1 page might be much
>more expensive than 100 pages because LRU order doesn't reflect the
>cost of the reclaim at all. What, I believe, we want is a best effort,
>really. If the reclaim target is somehow bound to the requested amount
>of memory then we can at least say that more memory hungry consumers are
>reclaiming more. Which is something people can wrap their head around
>much easier than a free competition on the reclaim with some hard to
>predict losers who do all the work and some lucky ones which just happen
>to avoid throttling by a better timing. Really think of the direct
>reclaim and how the unfairness suck there.

I really don't follow this logic. You're talking about reclaim-induced latency, 
but the alternative isn't freedom from latency, it's scheduler-induced latency 
from allocator throttling (and probably of a significantly higher magnitude). 
And again, that's totally justified if you are part of a cgroup which is 
significantly above its memory.high -- that's the kind of grouping you sign up 
for when you put multiple tasks in the same cgroup.

The premise of being over memory.high is that everyone in the affected cgroup 
must do their utmost to reclaim where possible, and if they fail to get below 
it again, we're going to deschedule them. *That's* what's best-effort about it.

The losers aren't hard to predict. It's *all* the tasks in this cgroup if they 
don't each make their utmost attempt to get the cgroup's memory back under 
control. Doing more reclaim isn't even in the same magnitude of sucking as 
getting allocator throttled.
