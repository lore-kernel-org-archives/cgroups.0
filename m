From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
Date: Tue, 21 Aug 2012 13:40:45 +0400
Message-ID: <5033579D.5000203@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-12-git-send-email-glommer@parallels.com> <20120821093513.GD19797@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120821093513.GD19797-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 08/21/2012 01:35 PM, Michal Hocko wrote:
> On Thu 09-08-12 17:01:19, Glauber Costa wrote:
>> Because those architectures will draw their stacks directly from the
>> page allocator, rather than the slab cache, we can directly pass
>> __GFP_KMEMCG flag, and issue the corresponding free_pages.
>>
>> This code path is taken when the architecture doesn't define
>> CONFIG_ARCH_THREAD_INFO_ALLOCATOR (only ia64 seems to), and has
>> THREAD_SIZE >= PAGE_SIZE. Luckily, most - if not all - of the remaining
>> architectures fall in this category.
> 
> quick git grep "define *THREAD_SIZE\>" arch says that there is no such
> architecture.
> 
>> This will guarantee that every stack page is accounted to the memcg the
>> process currently lives on, and will have the allocations to fail if
>> they go over limit.
>>
>> For the time being, I am defining a new variant of THREADINFO_GFP, not
>> to mess with the other path. Once the slab is also tracked by memcg, we
>> can get rid of that flag.
>>
>> Tested to successfully protect against :(){ :|:& };:
> 
> I guess there were no other tasks in the same group (except for the
> parent shell), right? 

Yes.

> I am asking because this should trigger memcg-oom
> but that one will usually pick up something else than the fork bomb
> which would have a small memory footprint. But that needs to be handled
> on the oom level obviously.
> 
Sure, but keep in mind that the main protection is against tasks *not*
in this memcg.
