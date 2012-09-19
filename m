From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 05/13] Add a __GFP_KMEMCG flag
Date: Wed, 19 Sep 2012 11:39:33 +0400
Message-ID: <505976B5.6090801@parallels.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-6-git-send-email-glommer@parallels.com> <00000139d9ea69c6-109249c2-5176-4a1e-b000-4c076d05844d-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00000139d9ea69c6-109249c2-5176-4a1e-b000-4c076d05844d-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>

On 09/18/2012 07:06 PM, Christoph Lameter wrote:
> On Tue, 18 Sep 2012, Glauber Costa wrote:
> 
>> +++ b/include/linux/gfp.h
>> @@ -35,6 +35,11 @@ struct vm_area_struct;
>>  #else
>>  #define ___GFP_NOTRACK		0
>>  #endif
>> +#ifdef CONFIG_MEMCG_KMEM
>> +#define ___GFP_KMEMCG		0x400000u
>> +#else
>> +#define ___GFP_KMEMCG		0
>> +#endif
> 
> Could you leave __GFP_MEMCG a simple definition and then define GFP_MEMCG
> to be zer0 if !MEMCG_KMEM? I think that would be cleaner and the
> __GFP_KMEMCHECK another case that would be good to fix up.
> 
> 
> 
I can, but what does this buy us?
Also, in any case, this can be done incrementally, and for the other
flag as well, as you describe.


