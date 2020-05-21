From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 16:02:13 +0100
Message-ID: <20200521150213.GH990580@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520165131.GB630613@cmpxchg.org>
 <20200520170430.GG6462@dhcp22.suse.cz>
 <20200520175135.GA793901@cmpxchg.org>
 <20200521073245.GI6462@dhcp22.suse.cz>
 <20200521135152.GA810429@cmpxchg.org>
 <20200521143515.GU6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L4UDchNoiuDX4tkUCL0dxdfAR6sFJ+v5DRcDTgeiOEA=;
        b=SPCXhfg+nCTAzglbOSxpGGWlT4LbcyT5ov7iVCRWlOjDg9vw3QGDFNbTOWFcM0RhsX
         2AiHhCFhMdO1ch6CMvgSCrtXVOLUYItHW4m86skN7YWl+QEHjVJ3hnwozUyrpbPbXJg9
         3AqRr6E5qlhw697AgVjHizpUyQ1BeM3NRaHuE=
Content-Disposition: inline
In-Reply-To: <20200521143515.GU6462-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Michal Hocko writes:
>> I have a good reason why we shouldn't: because it's special casing
>> memory.high from other forms of reclaim, and that is a maintainability
>> problem. We've recently been discussing ways to make the memory.high
>> implementation stand out less, not make it stand out even more. There
>> is no solid reason it should be different from memory.max reclaim,
>> except that it should sleep instead of invoke OOM at the end. It's
>> already a mess we're trying to get on top of and straighten out, and
>> you're proposing to add more kinks that will make this work harder.
>
>I do see your point of course. But I do not give the code consistency
>a higher priority than the potential unfairness aspect of the user
>visible behavior for something that can do better. Really the direct
>reclaim unfairness is really painfull and hard to explain to users. You
>can essentially only hand wave that system is struggling so fairness is
>not really a priority anymore.

It's not handwaving. When using cgroup features, including memory.high, the 
unit for consideration is a cgroup, not a task. That we happen to act on 
individual tasks in this case is just an implementation detail.

That one task in that cgroup is may be penalised "unfairly" is well within the 
specification: we set limits as part of a cgroup, we account as part of a 
cgroup, and we throttle and reclaim as part of a cgroup. We may make some very 
rudimentary attempts to "be fair" on a per-task basis where that's trivial, but 
that's just one-off niceties, not a statement of precedent.

When exceeding memory.high, the contract is "this cgroup must immediately 
attempt to shrink". Breaking it down per-task in terms of fairness at that 
point doesn't make sense: all the tasks in one cgroup are in it together.
