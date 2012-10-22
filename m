From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
Date: Mon, 22 Oct 2012 16:34:15 +0400
Message-ID: <50853D47.4030409@parallels.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210171515290.20712@chino.kir.corp.google.com> <507FCA90.8060307@parallels.com> <alpine.DEB.2.00.1210181454100.30894@chino.kir.corp.google.com> <5081269B.5000603@parallels.com> <alpine.DEB.2.00.1210191331400.17804@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1210191331400.17804-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On 10/20/2012 12:34 AM, David Rientjes wrote:
> On Fri, 19 Oct 2012, Glauber Costa wrote:
> 
>>>>> What about gfp & __GFP_FS?
>>>>>
>>>>
>>>> Do you intend to prevent or allow OOM under that flag? I personally
>>>> think that anything that accepts to be OOM-killed should have GFP_WAIT
>>>> set, so that ought to be enough.
>>>>
>>>
>>> The oom killer in the page allocator cannot trigger without __GFP_FS 
>>> because direct reclaim has little chance of being very successful and 
>>> thus we end up needlessly killing processes, and that tends to happen 
>>> quite a bit if we dont check for it.  Seems like this would also happen 
>>> with memcg if mem_cgroup_reclaim() has a large probability of failing?
>>>
>>
>> I can indeed see tests for GFP_FS in some key locations in mm/ before
>> calling the OOM Killer.
>>
>> Should I test for GFP_IO as well?
> 
> It's not really necessary, if __GFP_IO isn't set then it wouldn't make 
> sense for __GFP_FS to be set.
> 
>> If the idea is preventing OOM to
>> trigger for allocations that can write their pages back, how would you
>> feel about the following test:
>>
>> may_oom = (gfp & GFP_KERNEL) && !(gfp & __GFP_NORETRY) ?
>>
> 
> I would simply copy the logic from the page allocator and only trigger oom 
> for __GFP_FS and !__GFP_NORETRY.
> 

That seems reasonable to me. Michal ?
