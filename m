From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg v3 2/3] mm, oom: do not trigger out_of_memory from
 the #PF
Date: Tue, 26 Oct 2021 16:07:41 +0200
Message-ID: <YXgLrQwC/gKZAusv@dhcp22.suse.cz>
References: <YXJ/63kIpTq8AOlD@dhcp22.suse.cz>
 <cover.1634994605.git.vvs@virtuozzo.com>
 <f5fd8dd8-0ad4-c524-5f65-920b01972a42@virtuozzo.com>
 <e2a847a2-a414-2535-e3d1-b100a023b9d1@i-love.sakura.ne.jp>
 <YXZk9Lr217e+saSM@dhcp22.suse.cz>
 <62a326bc-37d2-b8c9-ddbf-7adaeaadf341@i-love.sakura.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635257263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sW8fX/bIkRavS2IM2SW67s4/k2HA13rrU7KuzOI/OYA=;
        b=XLQpg2KAcIM7gQTqzvrzY5Igd4UdGIws6JdRiIfbJQ8F1ubXcXk+95Wocng0fDJL/i/Ivg
        +OQ//LuLM9kDN56S0F6gBVNZDMP9o95FO5Zp3iFWP01ds7iy0/TOwJlitIe5kfi10yAwSG
        408Z8qmYPv7D5KNsFCV4RRii8RLmGfk=
Content-Disposition: inline
In-Reply-To: <62a326bc-37d2-b8c9-ddbf-7adaeaadf341-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue 26-10-21 22:56:44, Tetsuo Handa wrote:
> On 2021/10/25 17:04, Michal Hocko wrote:
> > I do not think there is any guarantee. This code has meant to be a
> > safeguard but it turns out to be adding more harm than a safety. There
> > are several scenarios mentioned in this thread where this would be
> > counter productive or outright wrong thing to do.
> 
> Setting PR_IO_FLUSHER via prctl(PR_SET_IO_FLUSHER) + hitting legacy kmem
> charge limit might be an unexpected combination?

I am not sure I follow or why PR_SET_IO_FLUSHER should be relevant. But
triggering the global OOM killer on kmem charge limit failure is
certainly not the right thing to do. Quite opposite because this would
be effectivelly a global DoS as a result of a local memory constrain.
 
> > On the other hand it is hard to imagine any legitimate situation where
> > this would be a right thing to do. Maybe you have something more
> > specific in mind? What would be the legit code to rely on OOM handling
> > out of the line (where the details about the allocation scope is lost)?
> 
> I don't have specific scenario, but I feel that it might be a chance to
> retry killable vmalloc(). Commit b8c8a338f75e ("Revert "vmalloc: back off
> when the current task is killed"") was 4.5 years ago, and fuzz testing found
> many bugs triggered by memory allocation fault injection. Thus, I think that
> the direction is going towards "we can fail memory allocation upon SIGKILL
> (rather than worrying about depleting memory reserves and/or escalating to
> global OOM killer invocations)". Most memory allocation requests which
> allocate memory for userspace process are willing to give up upon SIGKILL.
> 
> Like you are trying to add NOFS, NOIO, NOFAIL support to vmalloc(), you could
> consider KILLABLE support as well. Of course, direct reclaim makes it difficult
> to immediately give up upon SIGKILL, but killable allocation sounds still nice
> even if best-effort basis.

This is all fine but I am not sure how this is realated to this patch.
The previous patch already gives up in pagefault_out_of_memory on fatal
signal pending. So this code is not really reachable.

Also alowing more allocations to fail doesn't really suggest that we
should trigger OOM killer from #PF. I would argue that the opposite is
the case actually. Or I just haven't understood your concern?
-- 
Michal Hocko
SUSE Labs
