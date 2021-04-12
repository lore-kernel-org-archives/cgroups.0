From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 0/5] mm/memcg: Reduce kmemcache memory accounting overhead
Date: Mon, 12 Apr 2021 12:05:13 -0700
Message-ID: <YHSZ6X/DvgddiZBi@carbon.dhcp.thefacebook.com>
References: <20210409231842.8840-1-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=SWQh6fOs5hf3i14BKkmI1kbUCyGj+KZOy+9MMxfVCYw=;
 b=JN4OtfAoJFVRy0U8q5kFWFjNOMmAylsGuica7k1bN2Pr4jMy0fxobs5QVLDtdT/jgjR/
 r/3ohTBml2B23pt5V6egQ6fGMQoEGAHtwyMtcsNHAWDmUHRCvgsLZf+b3TWqY/wlMzY1
 2SrNxPCeq0JQzoz1ACHtndcHNEs2OCmKlSg= 
Content-Disposition: inline
In-Reply-To: <20210409231842.8840-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8@public.gmane.org>

On Fri, Apr 09, 2021 at 07:18:37PM -0400, Waiman Long wrote:
> With the recent introduction of the new slab memory controller, we
> eliminate the need for having separate kmemcaches for each memory
> cgroup and reduce overall kernel memory usage. However, we also add
> additional memory accounting overhead to each call of kmem_cache_alloc()
> and kmem_cache_free().
> 
> For workloads that require a lot of kmemcache allocations and
> de-allocations, they may experience performance regression as illustrated
> in [1].
> 
> With a simple kernel module that performs repeated loop of 100,000,000
> kmem_cache_alloc() and kmem_cache_free() of 64-byte object at module
> init. The execution time to load the kernel module with and without
> memory accounting were:
> 
>   with accounting = 6.798s
>   w/o  accounting = 1.758s
> 
> That is an increase of 5.04s (287%). With this patchset applied, the
> execution time became 4.254s. So the memory accounting overhead is now
> 2.496s which is a 50% reduction.

Btw, there were two recent independent report about benchmark results
regression caused by the introduction of the per-object accounting:
1) Xing reported a hackbench regression:
https://lkml.org/lkml/2021/1/13/1277
2) Masayoshi reported a pgbench regression:
https://www.spinics.net/lists/linux-mm/msg252540.html

I wonder if you can run them (or at least one) and attach the result
to the series? It would be very helpful.

Thank you!
