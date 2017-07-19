From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Wed, 19 Jul 2017 13:09:38 -0400
Message-ID: <e6a9daf1-461d-080c-a301-12cdad5e2b73@redhat.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <825f2eaa-568a-a156-f04d-9235b20e2614@redhat.com>
 <5fa00590-551f-85d2-511b-ef4033781228@redhat.com>
 <20170718171034.GE585283@devbig577.frc2.facebook.com>
 <df14a222-f1f8-3415-b29a-2712c9e77f94@redhat.com>
 <20170719162937.GP3365493@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com CEDED7EBD3
In-Reply-To: <20170719162937.GP3365493-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 07/19/2017 12:29 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Jul 18, 2017 at 01:23:14PM -0400, Waiman Long wrote:
>>> If we could get rid of the invalid state completely that way, I'd
>>> completely agree with you but that isn't the case here as you noted
>>> yourself, so the choice between the two isn't something trivially
>>> clear.  Both choices come with their pros and cons.  We can absoultely
>>> discuss them comparing the pros and cons.
>> I am not advocating on removing the invalid state now as I note about
> Yeah, removing invalid state would be great but we can't at least yet.
>
>> sibling cgroups. I am just saying that there is no point in not doing an
>> automatic conversion to threaded for newly created children of threaded
>> cgroups (not thread root). I don't see any cons in doing that.
> So, the cons I see is inconsistency, now and in the future.
>
> This may seem less clear with system root because we can have both
> domain and theraded children below it, which makes a newly created
> cgroup being a domain seem natural.  More importantly, we can't do it
> any other way because we'd break existing users otherwise - creating a
> threaded cgroup would cause future first level cgroups to be threaded
> which will be very unexpected.
>
> Let's think about a non-root threaded domain.  At least for now, a
> non-root threaded domain is terminal - they can't host valid domain
> children.  As the alternative term "thread root" implies, the threaded
> domain can be the root of a threaded subtree and nothing else, so it's
> kinda weird to make a new child cgroup there start out as a domain
> which can't be used, just like it'd be for the second level descendant
> cgroup.
>
> However, the alternative is even stranger.  Let's say we make the
> first level child automatically threaded, but that is inconsistent
> with when we first enable threaded mode.  We either would have to turn
> all siblings at the same time or disallow enabling threaded mode if
> there are domain siblings, which I fear would be unnecessarily
> restrictive.
>
> Another point is that what if we eventually make non-root threaded
> roots able to host domain children?  Making children automatically
> threaded wouldn't make any sense then, right?  I'll come back to this
> later.
>
> So, it looks like if we're gonna automatically turn on threaded mode
> for new cgroups, the only thing we can do right now is what you're
> suggesting; however, we didn't arrive there through some
> straight-forward intuition or overall design.  It started as a simple
> idea (I want it to be automatic) but the end result is a contorted
> destination shaped by constraints and happenstance.
>
> To me, behaving differently on the first-level threaded children than
> on second+ level ones is too strange to be justified by the
> convenience of not having to turn on threaded on new cgroups.

OK, I get your point of being inconsistent. However, I don't think that
is a big deal.

> On top of that, what happens if we get to implement PeterZ's idea of
> skipping over threaded internal cgroups to allow domains under
> threaded subtrees?  That'd imply that we'd be able to host domains
> under threaded domains too.  The end result would be completely
> non-sensical.  We'd be defaulting to different modes for different
> reasons where half of those reasons won't hold anymore.  This isn't
> surprising given that there's nothing actually consistent about the
> suggested default behavior.

For me, that is the only good reason why we should keep the current
behavior. So I am fine with that.

+ cgrp->dom_cgrp = cgrp->dom_cgrp;

However, I am still puzzled by above line of code, should it be just

  cgrp->dom_cgrp = cgrp;

Cheers,
Longman
