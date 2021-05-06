From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/3] mm: memcg/slab: Create a new set of kmalloc-cg-<n> caches
Date: Thu, 6 May 2021 09:07:24 -0700
Message-ID: <CALvZod69Ge5QzQsbNbf6gwHvSY92TGo0Cc5pxyyu55CHfNhfZg@mail.gmail.com>
References: <20210505200610.13943-1-longman@redhat.com> <20210505200610.13943-3-longman@redhat.com>
 <3344a04c-0cff-b997-f357-2ffc8e3de242@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hHJ2if4WJkg2du4T57AGBZ6P/jf0214NaTU4kr7th0=;
        b=d+zf6gym8dKCyDd+UW2gOZhjv9TbxL+FJK8ovpix4foAPy8PgxTh8HkOnZDMQ/cd26
         WGRoTUYFIYN69v5oodnGIbj20EyykcmxDgIZWoyp/1w0l9muEsYf9Uk/tfZiHoYJCBfi
         BCjZKZ5gq0Lxjohp3E8Pr6WYBt4oIh+6lw6uTaWaQZ2aBWi1SzUaRWklhTvAAPD58Zvj
         V5yJrXUENoSbELQPDjZoCE1TVtfzCVleSru6ZHEl5Txc5G5XcRPl/Lha+BpLumBgd911
         uZnYv10zevCWk1djhUDzkakEUnhG6oLg7C6aFXvvUQ38kSYeZxkWHaU6gaPF22aPGCmt
         KSBw==
In-Reply-To: <3344a04c-0cff-b997-f357-2ffc8e3de242-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, May 6, 2021 at 9:00 AM Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
>
>
> On 5/5/21 10:06 PM, Waiman Long wrote:
> > There are currently two problems in the way the objcg pointer array
> > (memcg_data) in the page structure is being allocated and freed.
> >
> > On its allocation, it is possible that the allocated objcg pointer
> > array comes from the same slab that requires memory accounting. If this
> > happens, the slab will never become empty again as there is at least
> > one object left (the obj_cgroup array) in the slab.
> >
> > When it is freed, the objcg pointer array object may be the last one
> > in its slab and hence causes kfree() to be called again. With the
> > right workload, the slab cache may be set up in a way that allows the
> > recursive kfree() calling loop to nest deep enough to cause a kernel
> > stack overflow and panic the system.
> >
> > One way to solve this problem is to split the kmalloc-<n> caches
> > (KMALLOC_NORMAL) into two separate sets - a new set of kmalloc-<n>
> > (KMALLOC_NORMAL) caches for unaccounted objects only and a new set of
> > kmalloc-cg-<n> (KMALLOC_CGROUP) caches for accounted objects only. All
> > the other caches can still allow a mix of accounted and unaccounted
> > objects.
> >
> > With this change, all the objcg pointer array objects will come from
> > KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
> > both the recursive kfree() problem and non-freeable slab problem are
> > gone.
> >
> > Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer have
> > mixed accounted and unaccounted objects, this will slightly reduce the
> > number of objcg pointer arrays that need to be allocated and save a bit
> > of memory. On the other hand, creating a new set of kmalloc caches does
> > have the effect of reducing cache utilization. So it is properly a wash.
> >
> > The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
> > KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
> > will include the newly added caches without change.
> >
> > Suggested-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> > Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Reviewed-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
>
> I still believe the cgroup.memory=nokmem parameter should be respected,
> otherwise the caches are not only created, but also used. I offer this followup
> for squashing into your patch if you and Andrew agree:
>
> ----8<----
> From c87378d437d9a59b8757033485431b4721c74173 Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Date: Thu, 6 May 2021 17:53:21 +0200
> Subject: [PATCH] mm: memcg/slab: don't create kmalloc-cg caches with
>  cgroup.memory=nokmem
>
> The caches should not be created when kmemcg is disabled on boot, otherwise
> they are also filled by kmalloc(__GFP_ACCOUNT) allocations. When booted with
> cgroup.memory=nokmem, link the kmalloc_caches[KMALLOC_CGROUP] entries to
> KMALLOC_NORMAL entries instead.
>
> Signed-off-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

Yes this makes sense:

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
