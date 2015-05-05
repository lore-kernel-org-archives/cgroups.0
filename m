From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 15:00:48 -0400
Message-ID: <20150505190048.GY1971@htj.duckdns.org>
References: <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <20150505144104.GS1971@htj.duckdns.org>
 <20150505151113.GP21418@twins.programming.kicks-ass.net>
 <20150505161335.GT1971@htj.duckdns.org>
 <20150505165006.GR21418@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1505052007140.4225@nanos>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=R03rxQRztIL6XxLWdOnJ4gHxiNVHeD+s3B5LnFycWIE=;
        b=eYkVrL41YTfyrekcM6cAs7jBV0fG7iXpzRbIt3FpGvI16/Jn2/I9GHKubNq8dtDdvv
         QFWLX1hlYsl4xv4Nyuzufjw9fU6Uc/lndAuI6kL2vBGEobLZ/sMleXkGztkNE7ANJXm5
         QHz87IJKS3+pdtwDmaRQbNe4OjkEPoIdC7fLaDAiQvCQ06OVgCMoDZIHFiqKxpVRZo1O
         43zeEk2sVJ+sVByU87n3MKClHxspfro1uG1BExWdvCO4FpEYaVhtutfSBytNeS3geEQD
         MXYxGWob2u3Z+PmAHg/uG5J8lI4Nx/Iao06KOu9vLiJPD2XjM7dF9aOgwlCA5LsCnezw
         NCQw==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1505052007140.4225@nanos>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Thomas.

On Tue, May 05, 2015 at 08:29:28PM +0200, Thomas Gleixner wrote:
> I fully agree and after reading through this thread I really have to
> say that this whole notion of relax the admission control and then try
> to magically converge to the resource limits is horrible in all
> aspects.

This comes down to controllers allowing limits to be configured
current usage.  We need to allow and define what happens in that
situation and moving a process into a full cgroup inherently follows
the same pattern albeit from the other direction.

> The idea of allowing overcommitment and magically converging to back
> to the limits yells heuristics all over the place and we all know how
> reliable heuristics are.

It's not magic heuristics.  This is a core part of normal operation.

> As Peter said several times: hard failure is good and desired. It's a
> very clear information on which people can act on. If the failures
> modes are nilly-willy today, as you wrote somewhere, then we need to
> fix that and make them consistent and understandable and not replace
> them by half baken heuristics which postpone the failure to some point
> where it is even less understandable.

There are no such magic heuristics because controllers need well
defined behaviors when current is above limit anyway and behave
exactly the same way no matter how that state is reached.  For
resources like RR slices, this doesn't work and that's why this is an
issue, so yeah this is the process of finding out what must be able to
fail.

> If there are issues with run-away problems, i.e. upping a resource
> limit which gets eaten up from the existing tasks before you can admit
> a new one, then your magic convergence thing is again the wrong
> answer. The right approach is:
> 
>       1) Up the limit and make a reservation at the same time
>       2) Admit the new task and allow it to consume the reservation
>       3) Set it effective

I don't really think this is a scenario we need to worry about.  If we
choose to fail migration, let's just fail it.  There's no point in
building a mechanism to work around malbehavior from its users.

> > Are you really going to force us to abandon cgroups and invent yet
> > another grouping thing?
> 
> Sigh no. I think cgroups can be fixed, if we just adhere to the basic
> principles of hierarchical resource management and remove/reject all
> magic "we'll fix that for you" nonsense.

So, let's do -EBUSY for hard resource failures which have to be exact.

Thanks.

-- 
tejun
