From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [patch] mm, memcg: provide a stat to describe reclaimable memory
Date: Fri, 17 Jul 2020 13:17:50 +0100
Message-ID: <20200717121750.GA367633@chrisdown.name>
References: <alpine.DEB.2.23.453.2007142018150.2667860@chino.kir.corp.google.com>
 <20200715131048.GA176092@chrisdown.name>
 <alpine.DEB.2.23.453.2007151046320.2788464@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n/pa5dW3hIKbP2t0G0f2EcEX6PNbXUQ5fuTdYCae6vA=;
        b=IV2BvGMeNhyhjNOB2Es2XKswxXP3OHp2eQYgh22DqMsl6TerVaUZO23vPyszdLx9Vq
         cFTst0pdov917g0M4eFrsOopy4Cz34VvQ0sBXmpZlszX7IvigmOqk0zp5ZJeXNZMYjF/
         q10TaZMjTNhDQu2wLqIjdFpM8JxdSQ8TzCI80=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2007151046320.2788464-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi David,

David Rientjes writes:
>With the proposed anon_reclaimable, do you have any reliability concerns?
>This would be the amount of lazy freeable memory and memory that can be
>uncharged if compound pages from the deferred split queue are split under
>memory pressure.  It seems to be a very precise value (as slab_reclaimable
>already in memory.stat is), so I'm not sure why there is a reliability
>concern.  Maybe you can elaborate?

Ability to reclaim a page is largely about context at the time of reclaim. For 
example, if you are running at the edge of swap, at a metric that truly 
describes "reclaimable memory" will contain vastly different numbers from one 
second to the next as cluster and page availability increases and decreases. We 
may also have to do things like look for youngness at reclaim time, so I'm not 
convinced metrics like this makes sense in the general case.

>Today, this information is indeed possible to calculate from userspace.
>The idea is to present this information that will be backwards compatible,
>however, as the kernel implementation changes.  When lazy freeable memory
>was added, for instance, userspace likely would not have preemptively been
>doing an "active_file + inactive_file - file" calculation to factor that
>in as reclaimable anon :)

I agree it's hard to calculate from userspace without assistance, but I also 
generally think generally exposing a highly nuanced and situational value to 
userspace is a recipe for confusion. The user either knows mm internals and can 
understand it, or don't and probably only misunderstand it. There is a non-zero 
cognitive cost to adding more metrics like this, which is why I'm interested in 
knowing more about the userspace usage semantics intended :-)

>The example I gave earlier in the thread showed how dramatically different
>memory.current is before and after the introduction of deferred split
>queues.  Userspace sees ballooning memcg usage and alerts on it (suspects
>a memory leak, for example) when in reality this is purely reclaimable
>memory under pressure and is the result of a kernel implementation detail.

Again, I'm curious why this can't be solved by artificial workingset 
pressurisation and monitoring. Generally, the most reliable reclaim metrics 
come from operating reclaim itself.
