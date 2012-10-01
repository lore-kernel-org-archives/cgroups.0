From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
Date: Mon, 1 Oct 2012 16:04:22 +0400
Message-ID: <506986C6.3050908@parallels.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-7-git-send-email-glommer@parallels.com> <20120926155108.GE15801@dhcp22.suse.cz> <5064392D.5040707@parallels.com> <20120927134432.GE29104@dhcp22.suse.cz> <50658B3B.9020303@parallels.com> <20121001094846.GC8622@dhcp22.suse.cz> <50696BC5.8040808@parallels.com> <20121001115157.GE8622@dhcp22.suse.cz> <506983B8.8010805@parallels.com> <20121001115847.GF8622@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121001115847.GF8622-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 10/01/2012 03:58 PM, Michal Hocko wrote:
> On Mon 01-10-12 15:51:20, Glauber Costa wrote:
>> On 10/01/2012 03:51 PM, Michal Hocko wrote:
>>> On Mon 01-10-12 14:09:09, Glauber Costa wrote:
>>>> On 10/01/2012 01:48 PM, Michal Hocko wrote:
>>>>> On Fri 28-09-12 15:34:19, Glauber Costa wrote:
>>>>>> On 09/27/2012 05:44 PM, Michal Hocko wrote:
>>>>>>>>> the reference count aquired by mem_cgroup_get will still prevent the
>>>>>>>>> memcg from going away, no?
>>>>>>> Yes but you are outside of the rcu now and we usually do css_get before
>>>>>>> we rcu_unlock. mem_cgroup_get just makes sure the group doesn't get
>>>>>>> deallocated but it could be gone before you call it. Or I am just
>>>>>>> confused - these 2 levels of ref counting is really not nice.
>>>>>>>
>>>>>>> Anyway, I have just noticed that __mem_cgroup_try_charge does
>>>>>>> VM_BUG_ON(css_is_removed(&memcg->css)) on a given memcg so you should
>>>>>>> keep css ref count up as well.
>>>>>>>
>>>>>>
>>>>>> IIRC, css_get will prevent the cgroup directory from being removed.
>>>>>> Because some allocations are expected to outlive the cgroup, we
>>>>>> specifically don't want that.
>>>>>
>>>>> Yes, but how do you guarantee that the above VM_BUG_ON doesn't trigger?
>>>>> Task could have been moved to another group between mem_cgroup_from_task
>>>>> and mem_cgroup_get, no?
>>>>>
>>>>
>>>> Ok, after reading this again (and again), you seem to be right. It
>>>> concerns me, however, that simply getting the css would lead us to a
>>>> double get/put pair, since try_charge will have to do it anyway.
>>>
>>> That happens only for !*ptr case and you provide a memcg here, don't
>>> you.
>>>
>>
>>         if (*ptr) { /* css should be a valid one */
>>                 memcg = *ptr;
>>                 VM_BUG_ON(css_is_removed(&memcg->css));
>>                 if (mem_cgroup_is_root(memcg))
>>                         goto done;
>>                 if (consume_stock(memcg, nr_pages))
>>                         goto done;
>>                 css_get(&memcg->css);
>>
>>
>> The way I read this, this will still issue a css_get here, unless
>> consume_stock suceeds (assuming non-root)
>>
>> So we'd still have to have a wrapping get/put pair outside the charge.
> 
> That is correct but it assumes that the css is valid so somebody upwards
> made sure css will not go away. This would suggest css_get is not
> necessary here but I guess the primary intention here is to make the
> code easier so that we do not have to check whether we took css
> reference on the return path.
> 
In any case, umem would also suffer from double reference, so I'm fine
taking it here as well, since a solution for that is orthogonal.

I still need mem_cgroup_get() to make sure the data structure stays
around, but we only need to do it once at first charge.


