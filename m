From: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Sun, 21 Apr 2013 01:55:06 -0700
Message-ID: <CANN689GuN_5QdgPBjr7h6paVmPeCvLHYfLWNLsJMWib9V9G_Fw@mail.gmail.com>
References: <20130420002620.GA17179@mtj.dyndns.org>
	<20130420031611.GA4695@dhcp22.suse.cz>
	<20130421022321.GE19097@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=NIATeCRdQkcEHt/TB5WCO6pvEAxlxQrdVGicdWK9U5E=;
        b=XixOcNy9YacLXLzaeRm0Nh9M7zhV+YmFXadWcHkJnsOSylp12vMILDlb/q7CLDpZjg
         vSXZpjDBzOCLtdx+Q6i766wwTLEV9988vcxYCIhce6VTjPD+OgP+y2i+mBfs6N27CMwh
         O6H6u5kquuFk63c1M+xG8SOF78uKx659Pwg52+3Qyin4FHWIcRcumeWkw78GfvJSqzUA
         r0gvg8u7QMjBOX/Q2SilQ+KnCRPOT8k1Tec6NAsfZt4HEISbyIjgO6hYe+lR2O3uJZXZ
         59ZjPUKsZ5KRPkpfYODm+sSurdA7G9WBxPSGFKwHxFqMIleQQbLIjE0xqWJecyMSE5zE
         VHVQ==
In-Reply-To: <20130421022321.GE19097-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Tejun,

I don't remember exactly when you left - during the session I
expressed to Michal that while I think his proposal is an improvement
over the current situation, I think his handling of internal nodes is
confus(ed/ing).

On Sat, Apr 20, 2013 at 7:23 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Michal.
>
> On Fri, Apr 19, 2013 at 08:16:11PM -0700, Michal Hocko wrote:
>> > For example, please consider the following hierarchy where s denotes
>> > the "softlimit" and h hardlimit.
>> >
>> >       A (h:8G s:4G)
>> >      /            \
>> >     /              \
>> >  B (h:5G s:1G)    C (h:5G s:1G)
> ...
>> > It must not be any different for "softlimit".  If B or C are
>> > individually under 1G, they won't be targeted by the reclaimer and
>> > even if B and C are over 1G, let's say 2G, as long as the sum is under
>> > A's "softlimit" - 4G, reclaimer won't look at them.

I completely agree with you here. This is important to ensure
composability - someone that was using cgroups within a 4GB system can
be moved to use cgroups within a hierarchy with a 4GB soft limit on
the root, and still have its performance isolated from tasks running
in other cgroups in the system.

>> > Now, let's consider the following hierarchy just to be sure.  Let's
>> > assume that A itself doesn't have any tasks for simplicity.
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> >
>> >       A (h:16G s:4G)
>> >      /            \
>> >     /              \
>> >  B (h:7G s:5G)    C (h:7G s:5G)
>> >
>> > For hardlimit, it is clear that A's limit won't do anything.

Now the above is a very interesting case.

One thing some people worry about is that B and C's configuration
might be under a different administrator's control than A's. That is,
we could have a situation where the machine's sysadmin set up A for
someone else to play with, and that other person set up B and C within
his cgroup. In this scenario, one of the issues has to be how do we
prevent B and C's configuration settings from reserving (or protecting
from reclaim) more memory than the machine's admin intended when he
configured A.

Michal's proposal resolves this by saying that A,B and C all become
reclaimable as soon as A goes over its soft limit.

Tejun's proposal (as I understand it) is that B and C protected from
reclaim until they grow to 5G each, as their soft limits indicate.

I have a third view, which I talked about during Michal's
presentation. I think that when A's usage goes over 4G, we should be
able to reclaim from A's subtree. If B or C's usage are above their
soft limits, then we should reclaim from these cgroups; however if
both B and C have usage below their soft limits, then we are in a
situation where the soft limits can't be obeyed so we should ignore
them and reclaim from both B and C instead.

The idea is that I think soft limits should follow these design principles:
- Soft limits are used to steer reclaim. We should try to avoid
reclaiming from cgroups that are under their soft limits. However,
soft limits can't completely prevent reclaim - if all cgroups are
under their soft limits, then the soft limits become meaningless and
all cgroups become eligible for being reclaimed from (this is a
situation that the sysadmin can largely avoid by not over-committing
the soft limits).
- A child cgroup should not be able to grab more resources than its
parent (this is for the situation where the parent and child cgroups
might be under separate administrative control). So when a parent
cgroup hits its soft limit, the child cgroup soft limits should not be
able to prevent us from reclaiming from that hierarchy. The child
cgroup soft limits should still be obeyed to steer reclaim within the
hierarchy when possible, though.


Regardless about these differences, I still want to stress out that
Michal's proposal is a clear improvement over what we have, so I see
it as a large step in the right direction.

> Now I'm confused.  You're saying softlimit currently doesn't guarantee
> anything and what it means, even for flat hierarchy, isn't clearly
> defined?

The largest problem with softlimit today is that global reclaim
doesn't take it into account at all... So yes, I would say that
softlimit is very badly defined today (which may be why people have
such trouble agreeing about what it should mean in the first place).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
