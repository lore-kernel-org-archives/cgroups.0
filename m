From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v4 23/25] memcg: propagate kmem limiting information to
 children
Date: Tue, 19 Jun 2012 09:16:20 +0900
Message-ID: <4FDFC4D4.1030303@jp.fujitsu.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-24-git-send-email-glommer@parallels.com> <4FDF20ED.4090401@jp.fujitsu.com> <4FDF227B.3080601@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FDF227B.3080601-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cristoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

(2012/06/18 21:43), Glauber Costa wrote:
> On 06/18/2012 04:37 PM, Kamezawa Hiroyuki wrote:
>> (2012/06/18 19:28), Glauber Costa wrote:
>>> The current memcg slab cache management fails to present satisfatory hierarchical
>>> behavior in the following scenario:
>>>
>>> ->   /cgroups/memory/A/B/C
>>>
>>> * kmem limit set at A
>>> * A and B empty taskwise
>>> * bash in C does find /
>>>
>>> Because kmem_accounted is a boolean that was not set for C, no accounting
>>> would be done. This is, however, not what we expect.
>>>
>>
>> Hmm....do we need this new routines even while we have mem_cgroup_iter() ?
>>
>> Doesn't this work ?
>>
>> 	struct mem_cgroup {
>> 		.....
>> 		bool kmem_accounted_this;
>> 		atomic_t kmem_accounted;
>> 		....
>> 	}
>>
>> at set limit
>>
>> 	....set_limit(memcg) {
>>
>> 		if (newly accounted) {
>> 			mem_cgroup_iter() {
>> 				atomic_inc(&iter->kmem_accounted)
>> 			}
>> 		} else {
>> 			mem_cgroup_iter() {
>> 				atomic_dec(&iter->kmem_accounted);
>> 			}
>> 	}
>>
>>
>> hm ? Then, you can see kmem is accounted or not by atomic_read(&memcg->kmem_accounted);
>>
> 
> Accounted by itself / parent is still useful, and I see no reason to use
> an atomic + bool if we can use a pair of bits.
> 
> As for the routine, I guess mem_cgroup_iter will work... It does a lot
> more than I need, but for the sake of using what's already in there, I
> can switch to it with no problems.
> 

Hmm. please start from reusing existing routines.
If it's not enough, some enhancement for generic cgroup  will be welcomed
rather than completely new one only for memcg.

Thanks,
-Kame


