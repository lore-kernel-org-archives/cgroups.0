From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
Date: Thu, 23 Aug 2012 11:51:31 +0400
Message-ID: <5035E103.3010101@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-7-git-send-email-glommer@parallels.com> <xr93boi3ewxt.fsf@gthelen.mtv.corp.google.com> <503499CC.7070704@parallels.com> <xr93boi2v5bi.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr93boi2v5bi.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>


>>> Perhaps we're just trying to take a conservative initial implementation
>>> which is consistent with user visible pages.
>>>
>>
>> The way I see it, is not about being conservative, but rather about my
>> physical safety. It is quite easy and natural to assume that "all
>> modifications to page cgroup are done under lock". So someone modifying
>> this later will likely find out about this exception in a rather
>> unpleasant way. They know where I live, and guns for hire are everywhere.
>>
>> Note that it is not unreasonable to believe that we can modify this
>> later. This can be a way out, for example, for the memcg lifecycle problem.
>>
>> I agree with your analysis and we can ultimately remove it, but if we
>> cannot pinpoint any performance problems to here, maybe consistency
>> wins. Also, the locking operation itself is a bit expensive, but the
>> biggest price is the actual contention. If we'll have nobody contending
>> for the same page_cgroup, the problem - if exists - shouldn't be that
>> bad. And if we ever have, the lock is needed.
> 
> Sounds reasonable. Another reason we might have to eventually revisit
> this lock is the fact that lock_page_cgroup() is not generally irq_safe.
> I assume that slab pages may be freed in softirq and would thus (in an
> upcoming patch series) call __memcg_kmem_free_page.  There are a few
> factors that might make it safe to grab this lock here (and below in
> __memcg_kmem_free_page) from hard/softirq context:
> * the pc lock is a per page bit spinlock.  So we only need to worry
>   about interrupting a task which holds the same page's lock to avoid
>   deadlock.
> * for accounted kernel pages, I am not aware of other code beyond
>   __memcg_kmem_charge_page and __memcg_kmem_free_page which grab pc
>   lock.  So we shouldn't find __memcg_kmem_free_page() called from a
>   context which interrupted a holder of the page's pc lock.
> 

All very right.

