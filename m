From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: consistently use vmalloc for page_cgroup allocations
Date: Fri, 5 Apr 2013 16:27:56 +0400
Message-ID: <515EC34C.8040704@parallels.com>
References: <1365156072-24100-1-git-send-email-glommer@parallels.com> <1365156072-24100-2-git-send-email-glommer@parallels.com> <20130405120604.GN1953@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130405120604.GN1953-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

On 04/05/2013 04:06 PM, Johannes Weiner wrote:
> On Fri, Apr 05, 2013 at 02:01:11PM +0400, Glauber Costa wrote:
>> Right now, allocation for page_cgroup is a bit complicated, dependent on
>> a variety of system conditions:
>>
>> For flat memory, we are likely to need quite big pages, so the page
>> allocator won't cut. We are forced to init flatmem mappings very early,
>> because if we run after the page allocator is in place those allocations
>> will be denied. Flatmem mappings thus resort to the bootmem allocator.
>>
>> We can fix this by using vmalloc for flatmem mappings. However, we now
>> have the situation in which flatmem mapping allocate using vmalloc, but
>> sparsemem may or may not allocate with vmalloc. It will try the
>> page_allocator first, and retry vmalloc if it fails.
> 
> Vmalloc space is a precious resource on 32-bit systems and harder on
> the TLB than the identity mapping.
> 
> It's a last resort thing for when you need an unusually large chunk of
> contiguously addressable memory during runtime, like loading a module,
> buffers shared with userspace etc..  But here we know, during boot
> time, the exact amount of memory we need for the page_cgroup array.
> 
> Code cleanup is not a good reason to use vmalloc in this case, IMO.
> 
This is indeed a code cleanup, but a code cleanup with a side goal:
freeing us from the need to register page_cgroup mandatorily at init
time. This is done because page_cgroup_init_flatmem will use the bootmem
allocator, to avoid the page allocator limitations.

What I can try to do, and would happily do, is to try a normal page
allocation and then resort to vmalloc if it is too big.

Would that be okay to you ?
