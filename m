From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Tue, 21 Apr 2020 13:06:12 +0200
Message-ID: <20200421110612.GD27314@dhcp22.suse.cz>
References: <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
 <20200417173615.GB43469@mtj.thefacebook.com>
 <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
 <20200417193539.GC43469@mtj.thefacebook.com>
 <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
 <20200417225941.GE43469@mtj.thefacebook.com>
 <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
 <20200420164740.GF43469@mtj.thefacebook.com>
 <20200420170318.GV27314@dhcp22.suse.cz>
 <20200420170650.GA169746@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200420170650.GA169746-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 20-04-20 13:06:50, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 20, 2020 at 07:03:18PM +0200, Michal Hocko wrote:
> > I have asked about the semantic of this know already and didn't really
> > get any real answer. So how does swap.high fit into high limit semantic
> > when it doesn't act as a limit. Considering that we cannot reclaim swap
> > space I find this really hard to grasp.
> 
> memory.high slow down is for the case when memory reclaim can't be depended
> upon for throttling, right? This is the same. Swap can't be reclaimed so the
> backpressure is applied by slowing down the source, the same way memory.high
> does.

Hmm, but the two differ quite considerably that we do not reclaim any
swap which means that while no reclaimable memory at all is pretty much
the corner case (essentially OOM) the no reclaimable swap is always in
that state. So whenever you hit the high limit there is no other way
then rely on userspace to unmap swap backed memory or increase the limit.
Without that there is always throttling. The question also is what do
you want to throttle in that case? Any swap backed allocation or swap
based reclaim? The patch throttles any allocations unless I am
misreading. This means that also any other !swap backed allocations get
throttled as soon as the swap quota is reached. Is this really desirable
behavior? I would find it quite surprising to say the least.

I am also not sure about the isolation aspect. Because an external
memory pressure might have pushed out memory to the swap and then the
workload is throttled based on an external event. Compare that to the
memory.high throttling which is not directly affected by the external
pressure.

There is also an aspect of non-determinism. There is no control over
the file vs. swap backed reclaim decision for memcgs. That means that
behavior is going to be very dependent on the internal implementation of
the reclaim. More swapping is going to fill up swap quota quicker.

> It fits together with memory.low in that it prevents runaway anon allocation
> when swap can't be allocated anymore. It's addressing the same problem that
> memory.high slowdown does. It's just a different vector.

I suspect that the problem is more related to the swap being handled as
a separate resource. And it is still not clear to me why it is easier
for you to tune swap.high than memory.high. You have said that you do
not want to set up memory.high because it is harder to tune but I do
not see why swap is easier in this regards. Maybe it is just that the
swap is almost never used so a bad estimate is much easier to tolerate
and you really do care about runaways?
-- 
Michal Hocko
SUSE Labs
