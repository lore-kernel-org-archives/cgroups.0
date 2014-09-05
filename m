From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC] memory cgroup: my thoughts on memsw
Date: Fri, 5 Sep 2014 12:28:46 +0400
Message-ID: <20140905082846.GA25641@esperanza>
References: <20140904143055.GA20099@esperanza>
 <5408E1CD.3090004@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5408E1CD.3090004-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Motohiro Kosaki <Motohiro.Kosaki-gkcJ3tX5bYHQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Emelianov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khorenko <khorenko-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, LKML-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML-cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Kamezawa,

Thanks for reading this :-)

On Fri, Sep 05, 2014 at 07:03:57AM +0900, Kamezawa Hiroyuki wrote:
> (2014/09/04 23:30), Vladimir Davydov wrote:
> >  - memory.limit - container can't use memory above this
> >  - memory.memsw.limit - container can't use swappable memory above this
> 
> If one hits anon+swap limit, it just means OOM. Hitting limit means
> process's death.

Basically yes. Hitting the memory.limit will result in swap out + cache
reclaim no matter if it's an anon charge or a page cache one. Hitting
the swappable memory limit (anon+swap) can only occur on anon charge and
if it happens we have no choice rather than invoking OOM.

Frankly, I don't see anything wrong in such a behavior. Why is it worse
than the current behavior where we also kill processes if a cgroup
reaches memsw.limit and we can't reclaim page caches?

I admit I may be missing something. So I'd appreciate if you could
provide me with a use case where we want *only* the current behavior and
my proposal is a no-go.

> Is it useful ?

I think so, at least, if we want to use soft limits. The point is we
will have to kill a process if it eats too much anon memory *anyway*
when it comes to global memory pressure, but before finishing it we'll
be torturing the culprit as well as *innocent* processes by issuing
massive reclaim, as I tried to point out in the example above. IMO, this
is no good.

Besides, I believe such a distinction between swappable memory and
caches would look more natural to users. Everyone got used to it
actually. For example, when an admin or user or any userspace utility
looks at the output of free(1), it primarily pays attention to free
memory "-/+ buffers/caches", because almost all memory is usually full
with file caches. And they know that caches easy come, easy go. IMO, for
them it'd be more useful to limit this to avoid nasty surprises in the
future, and only set some hints for page cache reclaim.

The only exception is strict sand-boxing, but AFAIU we can sand-box apps
perfectly well with this either, because we would still have a strict
memory limit and a limit on maximal swap usage.

Please sorry if the idea looks to you totally stupid (may be it is!),
but let's just try to consider every possibility we have in mind.

Thanks,
Vladimir
