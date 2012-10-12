From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v4 09/14] memcg: kmem accounting lifecycle management
Date: Fri, 12 Oct 2012 11:47:17 +0400
Message-ID: <5077CB05.907@parallels.com>
References: <1349690780-15988-1-git-send-email-glommer@parallels.com> <1349690780-15988-10-git-send-email-glommer@parallels.com> <20121011131143.GF29295@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121011131143.GF29295-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On 10/11/2012 05:11 PM, Michal Hocko wrote:
> On Mon 08-10-12 14:06:15, Glauber Costa wrote:
>> Because kmem charges can outlive the cgroup, we need to make sure that
>> we won't free the memcg structure while charges are still in flight.
>> For reviewing simplicity, the charge functions will issue
>> mem_cgroup_get() at every charge, and mem_cgroup_put() at every
>> uncharge.
>>
>> This can get expensive, however, and we can do better. mem_cgroup_get()
>> only really needs to be issued once: when the first limit is set. In the
>> same spirit, we only need to issue mem_cgroup_put() when the last charge
>> is gone.
>>
>> We'll need an extra bit in kmem_accounted for that: KMEM_ACCOUNTED_DEAD.
>> it will be set when the cgroup dies, if there are charges in the group.
>> If there aren't, we can proceed right away.
>>
>> Our uncharge function will have to test that bit every time the charges
>> drop to 0. Because that is not the likely output of
>> res_counter_uncharge, this should not impose a big hit on us: it is
>> certainly much better than a reference count decrease at every
>> operation.
>>
>> [ v3: merged all lifecycle related patches in one ]
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
>> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> OK, I like the optimization. I have just one comment to the
> memcg_kmem_dead naming but other than that
> 
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> [...]
>> +static bool memcg_kmem_dead(struct mem_cgroup *memcg)
> 
> The name is tricky because it doesn't tell you that it clears the flag
> which made me scratch my head when reading comment in kmem_cgroup_destroy
> 
memcg_kmem_finally_kill_that_bastard() ?
