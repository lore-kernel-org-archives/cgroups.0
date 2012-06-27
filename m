From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 00/11] kmem controller for memcg: stripped down version
Date: Wed, 27 Jun 2012 12:39:54 +0400
Message-ID: <4FEAC6DA.1010806@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <20120625162745.eabe4f03.akpm@linux-foundation.org> <4FE9621D.2050002@parallels.com> <20120626145539.eeeab909.akpm@linux-foundation.org> <alpine.DEB.2.00.1206261804160.11287@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1206261804160.11287-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 06/27/2012 05:08 AM, David Rientjes wrote:
> On Tue, 26 Jun 2012, Andrew Morton wrote:
>
>> mm, maybe.  Kernel developers tend to look at code from the point of
>> view "does it work as designed", "is it clean", "is it efficient", "do
>> I understand it", etc.  We often forget to step back and really
>> consider whether or not it should be merged at all.
>>
>
> It's appropriate for true memory isolation so that applications cannot
> cause an excess of slab to be consumed.  This allows other applications to
> have higher reservations without the risk of incurring a global oom
> condition as the result of the usage of other memcgs.

Just a note for Andrew, we we're in the same page: The slab cache 
limitation is not included in *this* particular series. The goal was 
always to have other kernel resources limited as well, and the general 
argument from David holds: we want a set of applications to run truly 
independently from others, without creating memory pressure on the 
global system.

The way history develop in this series, I started from the slab cache, 
and a page-level tracking appeared on that series. I then figured it 
would be better to start tracking something that is totally page-based, 
such as the stack - that already accounts for 70 % of the 
infrastructure, and then merge the slab code later. In this sense, it 
was just a strategy inversion. But both are, and were, in the goals.

> I'm not sure whether it would ever be appropriate to limit the amount of
> slab for an individual slab cache, however, instead of limiting the sum of
> all slab for a set of processes.  With cache merging in slub this would
> seem to be difficult to do correctly.

Yes, I do agree.


