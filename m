From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 1/2] mm: memcg/slab: Properly set up gfp flags for
 objcg pointer array
Date: Wed, 5 May 2021 13:32:12 +0200
Message-ID: <b85f5b2b-cd5c-74ba-918b-f61ec0e540b0@suse.cz>
References: <20210504132350.4693-1-longman@redhat.com>
 <20210504132350.4693-2-longman@redhat.com>
 <CALvZod438=YKZtV0qckoaMkdL1seu5PiLnvPPQyRzA0S60-TpQ@mail.gmail.com>
 <267501a0-f416-4058-70d3-e32eeec3d6da@redhat.com>
 <CALvZod5gakHaAZfU2gH6QVNJRcX90MVSmqBpBSgCmF-Zhpz_vw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvZod5gakHaAZfU2gH6QVNJRcX90MVSmqBpBSgCmF-Zhpz_vw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On 5/4/21 10:06 PM, Shakeel Butt wrote:
> On Tue, May 4, 2021 at 1:02 PM Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On 5/4/21 3:37 PM, Shakeel Butt wrote:
>> > On Tue, May 4, 2021 at 6:24 AM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >> Since the merging of the new slab memory controller in v5.9, the page
>> >> structure may store a pointer to obj_cgroup pointer array for slab pages.
>> >> Currently, only the __GFP_ACCOUNT bit is masked off. However, the array
>> >> is not readily reclaimable and doesn't need to come from the DMA buffer.
>> >> So those GFP bits should be masked off as well.
>> >>
>> >> Do the flag bit clearing at memcg_alloc_page_obj_cgroups() to make sure
>> >> that it is consistently applied no matter where it is called.
>> >>
>> >> Fixes: 286e04b8ed7a ("mm: memcg/slab: allocate obj_cgroups for non-root slab pages")
>> >> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> ---
>> >>   mm/memcontrol.c | 8 ++++++++
>> >>   mm/slab.h       | 1 -
>> >>   2 files changed, 8 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> >> index c100265dc393..5e3b4f23b830 100644
>> >> --- a/mm/memcontrol.c
>> >> +++ b/mm/memcontrol.c
>> >> @@ -2863,6 +2863,13 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
>> >>   }
>> >>
>> >>   #ifdef CONFIG_MEMCG_KMEM
>> >> +/*
>> >> + * The allocated objcg pointers array is not accounted directly.
>> >> + * Moreover, it should not come from DMA buffer and is not readily
>> >> + * reclaimable. So those GFP bits should be masked off.
>> >> + */
>> >> +#define OBJCGS_CLEAR_MASK      (__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
>> > What about __GFP_DMA32? Does it matter? It seems like DMA32 requests
>> > go to normal caches.
>>
>> I included __GFP_DMA32 in my first draft patch. However, __GFP_DMA32 is
>> not considered in determining the right kmalloc_type() (patch 2), so I
>> took it out to make it consistent. I can certainly add it back.
>>
> 
> No this is fine and DMA32 question is unrelated to this patch series.

We never supported them in kmalloc(), only explicit caches with SLAB_CACHE_DMA32
flag.
