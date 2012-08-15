From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 07/11] mm: Allocate kernel pages to the right memcg
Date: Wed, 15 Aug 2012 17:51:40 +0400
Message-ID: <502BA96C.8070602@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-8-git-send-email-glommer@parallels.com> <20120814151616.GO4177@suse.de> <502B66F8.30909@parallels.com> <20120815132244.GQ4177@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120815132244.GQ4177-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 08/15/2012 05:22 PM, Mel Gorman wrote:
>> I believe it
>> > to be a better and less complicated approach then letting a page appear
>> > and then charging it. Besides being consistent with the rest of memcg,
>> > it won't create unnecessary disturbance in the page allocator
>> > when the allocation is to fail.
>> > 
> I still don't get why you did not just return a mem_cgroup instead of a
> handle.
> 

Forgot this one, sorry:

The reason is to keep the semantics simple.

What should we return if the code is not compiled in? If we return NULL
for failure, the test becomes

memcg = memcg_kmem_charge_page(gfp, order);
if (!memcg)
  exit;

If we're not compiled in, we'd either return positive garbage or we need
to wrap it inside an ifdef

I personally believe to be a lot more clear to standardize on true
to mean "allocation can proceed".

the compiled out case becomes:

if (!true)
   exit;

which is easily compiled away altogether. Now of course, using struct
mem_cgroup makes sense, and I have already changed that here.
