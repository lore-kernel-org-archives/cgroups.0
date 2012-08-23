From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 09/11] memcg: propagate kmem limiting information to
 children
Date: Thu, 23 Aug 2012 11:55:02 +0400
Message-ID: <5035E1D6.6010503@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-10-git-send-email-glommer@parallels.com> <20120817090005.GC18600@dhcp22.suse.cz> <502E0BC3.8090204@parallels.com> <20120817093504.GE18600@dhcp22.suse.cz> <502E17C4.7060204@parallels.com> <20120817103550.GF18600@dhcp22.suse.cz> <502E1E90.1080805@parallels.com> <20120821075430.GA19797@dhcp22.suse.cz> <50335341.6010400@parallels.com> <20120821100007.GE19797@dhcp22.suse.cz> <xr93fw7fbumo.fsf@gthelen.mtv.corp.google.com> <503496D9.3020806@parallels.com> <xr93a9xmwly7.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr93a9xmwly7.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 08/23/2012 03:23 AM, Greg Thelen wrote:
> On Wed, Aug 22 2012, Glauber Costa wrote:
> 
>>>>>
>>>>> I am fine with either, I just need a clear sign from you guys so I don't
>>>>> keep deimplementing and reimplementing this forever.
>>>>
>>>> I would be for make it simple now and go with additional features later
>>>> when there is a demand for them. Maybe we will have runtimg switch for
>>>> user memory accounting as well one day.
>>>>
>>>> But let's see what others think?
>>>
>>> In my use case memcg will either be disable or (enabled and kmem
>>> limiting enabled).
>>>
>>> I'm not sure I follow the discussion about history.  Are we saying that
>>> once a kmem limit is set then kmem will be accounted/charged to memcg.
>>> Is this discussion about the static branches/etc that are autotuned the
>>> first time is enabled?  
>>
>> No, the question is about when you unlimit a former kmem-limited memcg.
>>
>>> The first time its set there parts of the system
>>> will be adjusted in such a way that may impose a performance overhead
>>> (static branches, etc).  Thereafter the performance cannot be regained
>>> without a reboot.  This makes sense to me.  Are we saying that
>>> kmem.limit_in_bytes will have three states?
>>
>> It is not about performance, about interface.
>>
>> Michal says that once a particular memcg was kmem-limited, it will keep
>> accounting pages, even if you make it unlimited. The limits won't be
>> enforced, for sure - there is no limit, but pages will still be accounted.
>>
>> This simplifies the code galore, but I worry about the interface: A
>> person looking at the current status of the files only, without
>> knowledge of past history, can't tell if allocations will be tracked or not.
> 
> In the current patch set we've conflating enabling kmem accounting with
> the kmem limit value (RESOURCE_MAX=disabled, all_other_values=enabled).
> 
> I see no problem with simpling the kernel code with the requirement that
> once a particular memcg enables kmem accounting that it cannot be
> disabled for that memcg.
> 
> The only question is the user space interface.  Two options spring to
> mind:
> a) Close to current code.  Once kmem.limit_in_bytes is set to
>    non-RESOURCE_MAX, then kmem accounting is enabled and cannot be
>    disabled.  Therefore the limit cannot be set to RESOURCE_MAX
>    thereafter.  The largest value would be something like
>    RESOURCE_MAX-PAGE_SIZE.  An admin wondering if kmem is enabled only
>    has to cat kmem.limit_in_bytes - if it's less than RESOURCE_MAX, then
>    kmem is enabled.
> 

If we need to choose between them, I like this better than your (b).
At least it is all clear, and "fix" the history problem, since it is
possible to look up the status of the files and figure it out.

> b) Or, if we could introduce a separate sticky kmem.enabled file.  Once
>    set it could not be unset.  Kmem accounting would only be enabled if
>    kmem.enabled=1.
> 
> I think (b) is clearer.
> 
Depends on your definition of clearer. We had a knob for
kmem_independent in the beginning if you remember, and it was removed.
The main reason being knobs complicate minds, and we happen to have a
very natural signal for this. I believe the same reasoning applies here.
