From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 14:41:47 +0100
Message-ID: <20200521133324.GF990580@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
 <20200521120455.GM6462@dhcp22.suse.cz>
 <20200521122327.GB990580@chrisdown.name>
 <20200521123742.GO6462@dhcp22.suse.cz>
 <20200521125759.GD990580@chrisdown.name>
 <20200521132120.GR6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xV51Tcrf9NcqZbm5wUPmCudngXiKCmzHzaVIGwxSLX0=;
        b=mVLBa0YkwB4qr/nGUx3mTqt/IBNkDYMevgIGIDvGXl6mMe9hC/iNBgUGd5KNQhW1C2
         9VRaEeFAhHWBGnn62P2YYa9mMqk5yFn72KsrQrJt2qlo1uogjLnYcd8FWbScxgkMXJYD
         LjLNQZqXCO3CrKOtpR884DuapuK4oJipI1hO8=
Content-Disposition: inline
In-Reply-To: <20200521132120.GR6462-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Michal Hocko writes:
>On Thu 21-05-20 13:57:59, Chris Down wrote:
>> Michal Hocko writes:
>> > > A cgroup is a unit and breaking it down into "reclaim fairness" for
>> > > individual tasks like this seems suspect to me. For example, if one task in
>> > > a cgroup is leaking unreclaimable memory like crazy, everyone in that cgroup
>> > > is going to be penalised by allocator throttling as a result, even if they
>> > > aren't "responsible" for that reclaim.
>> >
>> > You are right, but that doesn't mean that it is desirable that some
>> > tasks would be throttled unexpectedly too long because of the other's activity.
>>
>> Are you really talking about throttling, or reclaim? If throttling, tasks
>> are already throttled proportionally to how much this allocation is
>> contributing to the overage in calculate_high_delay.
>
>Reclaim is a part of the throttling mechanism. It is a productive side
>of it actually.

I guess let's avoid using the term "throttling", since in this context it 
sounds like we're talking about allocator throttling :-)

>> If you're talking about reclaim, trying to reason about whether the overage
>> is the result of some other task in this cgroup or the task that's
>> allocating right now is something that we already know doesn't work well
>> (eg. global OOM).
>
>I am not sure I follow you here.

Let me rephrase: your statement is that it's not desirable "that some task 
would be throttled unexpectedly too long because of [the activity of another 
task also within that cgroup]" (let me know if that's not what you meant). But 
trying to avoid that requires knowing which activity abstractly instigates this 
entire mess in the first place, which we have nowhere near enough context to 
determine.
