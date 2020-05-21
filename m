From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 13:23:27 +0100
Message-ID: <20200521122327.GB990580@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
 <20200521120455.GM6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uwOifwCrhhMbK5Uq7O2JD6i7Fke3H2izTnc0aJuCXEg=;
        b=XPG2fmle0UHD0TI3rprNxDcmfUfFqTRmNpREToIIZtED2Tw1ccSUVY3s4nRvf2eeHI
         6fyQbuYFMmtWFb/NIweeYDAxLIZQggq40/t2t6OcwndTJ9KfQbOi2cjxxCdmgouj8g5f
         PWs23lR8s68dqTVlmt13rZ3Mv+n9u0mXUNON0=
Content-Disposition: inline
In-Reply-To: <20200521120455.GM6462-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

(I'll leave the dirty throttling discussion to Johannes, because I'm not so 
familiar with that code or its history.)

Michal Hocko writes:
>> > The main problem I see with that approach is that the loop could easily
>> > lead to reclaim unfairness when a heavy producer which doesn't leave the
>> > kernel (e.g. a large read/write call) can keep a different task doing
>> > all the reclaim work. The loop is effectivelly unbound when there is a
>> > reclaim progress and so the return to the userspace is by no means
>> > proportional to the requested memory/charge.
>>
>> It's not unbound when there is reclaim progress, it stops when we are within
>> the memory.high throttling grace period. Right after reclaim, we check if
>> penalty_jiffies is less than 10ms, and abort and further reclaim or
>> allocator throttling:
>
>Just imagine that you have parallel producers increasing the high limit
>excess while somebody reclaims those. Sure in practice the loop will be
>bounded but the reclaimer might perform much more work on behalf of
>other tasks.

A cgroup is a unit and breaking it down into "reclaim fairness" for individual 
tasks like this seems suspect to me. For example, if one task in a cgroup is 
leaking unreclaimable memory like crazy, everyone in that cgroup is going to be 
penalised by allocator throttling as a result, even if they aren't 
"responsible" for that reclaim.

So the options here are as follows when a cgroup is over memory.high and a 
single reclaim isn't enough:

1. Decline further reclaim. Instead, throttle for up to 2 seconds.
2. Keep on reclaiming. Only throttle if we can't get back under memory.high.

The outcome of your suggestion to decline further reclaim is case #1, which is 
significantly more practically "unfair" to that task. Throttling is extremely 
disruptive to tasks and should be a last resort when we've exhausted all other 
practical options. It shouldn't be something you get just because you didn't 
try to reclaim hard enough.
