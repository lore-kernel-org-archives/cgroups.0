From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 14/18] memcg/sl[au]b: shrink dead caches
Date: Mon, 22 Oct 2012 11:37:22 +0400
Message-ID: <5084F7B2.7000105@parallels.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-15-git-send-email-glommer@parallels.com> <0000013a7a9144d1-de184c46-2a7d-4e6c-8606-927cc1f48969-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0000013a7a9144d1-de184c46-2a7d-4e6c-8606-927cc1f48969-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 10/19/2012 11:47 PM, Christoph Lameter wrote:
> On Fri, 19 Oct 2012, Glauber Costa wrote:
> 
>> An unlikely branch is used to make sure this case does not affect
>> performance in the usual slab_free path.
>>
>> The slab allocator has a time based reaper that would eventually get rid
>> of the objects, but we can also call it explicitly, since dead caches
>> are not a likely event.
> 
> This is also something that could be done from slab_common since all
> allocators have kmem_cache_shrink and kmem_cache_shrink can be used to
> drain the caches and free up empty slab pages.
> 

The changelog needs to be updated. I updated the code, forgot the
changelog =(

I am actually now following Tejun's last suggestion, and no longer using
my old verify_dead code.

So I am basically calling shrink_slab every once in a while until the
cache disappears.

The only change I still need in the allocators is to count the amount of
pages they have, so I can differentiate between need-to-shrink and
need-to-destroy
