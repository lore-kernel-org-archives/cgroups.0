From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 17/23] kmem controller charge/uncharge infrastructure
Date: Wed, 25 Apr 2012 11:43:28 -0300
Message-ID: <4F980D90.8050109@parallels.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1204231522320.13535@chino.kir.corp.google.com> <20120424142232.GC8626@somewhere> <4F96BB62.1030900@parallels.com> <alpine.DEB.2.00.1204241322390.753@chino.kir.corp.google.com> <4F971CC2.3090109@parallels.com> <alpine.DEB.2.00.1204241550110.2537@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1204241550110.2537-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On 04/24/2012 07:54 PM, David Rientjes wrote:
> On Tue, 24 Apr 2012, Glauber Costa wrote:
>
>>> Yes, for user memory, I see charging to p->mm->owner as allowing that
>>> process to eventually move and be charged to a different memcg and there's
>>> no way to do proper accounting if the charge is split amongst different
>>> memcgs because of thread membership to a set of memcgs.  This is
>>> consistent with charges for shared memory being moved when a thread
>>> mapping it moves to a new memcg, as well.
>>
>> But that's the problem.
>>
>> When we are dealing with kernel memory, we are allocating a whole slab page.
>> It is essentially impossible to track, given a page, which task allocated
>> which object.
>>
>
> Right, so you have to make the distinction that slab charges cannot be
> migrated by memory.move_charge_at_immigrate (and it's not even specified
> to do anything beyond user pages in Documentation/cgroups/memory.txt),

Never intended to.

> but
> it would be consistent to charge the same memcg for a process's slab
> allocations as the process's user allocations.
>
> My response was why we shouldn't be charging user pages to
> mem_cgroup_from_task(current) rather than
> mem_cgroup_from_task(current->mm->owner) which is what is currently
> implemented.

Ah, all right. Well, for user memory I agree with you. My point was 
exactly that user memory can always be pinpointed to a specific address 
space, while kernel memory can't.

>
> If that can't be changed so that we can still migrate user memory amongst
> memcgs for memory.move_charge_at_immigrate, then it seems consistent to
> have all allocations done by a task to be charged to the same memcg.
> Hence, I suggested current->mm->owner for slab charging as well.

All right. This can be done. Although I don't see this as a must for 
slab as already explained, I certainly don't oppose doing so as well.
