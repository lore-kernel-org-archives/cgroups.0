From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: fix build error around the usage of kmem_caches
Date: Thu, 6 Feb 2020 09:15:47 +0800
Message-ID: <CALOAHbDaHifzkf8ZVBdNr60hkuke8aapsHwh8Fb9+BPJ5M==Uw@mail.gmail.com>
References: <1580922215-5272-1-git-send-email-laoar.shao@gmail.com> <1ef8ee2e-0f50-fcd6-ae13-d6524fcf9764@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=chLy6GSqBy+/ujDvuDbaQr9IHlDEdCi1z2Q2e8diLQ8=;
        b=qWv+0a7lMviAtTjNnAhSW6ND/5nGN3RodZOnsMKnv4AJkUYAklJ2g2Fp/S9s2S3JAu
         blKHSdIES0qLGdq9AVfz0GTp4ieYwFM9pCQ15JXZ4/XpRO2U92IWzP7fd9vsvDuZ/g7J
         uRcWMALZxvOEjC82DQ8heQ/0A/MczdlTIBmzUhp++Rv61anYp/wCgmXimFB1PTdpW8rU
         yRhnxVoRLu0h4XKmosThqKaWJUPQN6UKmL8vzFEa3eiQYytIiyNmjiCsjiSDITJFUMJ4
         x01FFn3M6VPUGBKl5VjlLoO3RIEOQvi+5sSbnvkE9qgJhBUMNt94/DeX8XH+CxdD4idu
         ATQA==
In-Reply-To: <1ef8ee2e-0f50-fcd6-ae13-d6524fcf9764-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Feb 6, 2020 at 1:19 AM David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 05.02.20 18:03, Yafang Shao wrote:
> > When I manually set default n to MEMCG_KMEM in init/Kconfig, bellow error
> > occurs,
> >
> > mm/slab_common.c: In function 'memcg_slab_start':
> > mm/slab_common.c:1530:30: error: 'struct mem_cgroup' has no member named
> > 'kmem_caches'
> >   return seq_list_start(&memcg->kmem_caches, *pos);
> >                               ^
> > mm/slab_common.c: In function 'memcg_slab_next':
> > mm/slab_common.c:1537:32: error: 'struct mem_cgroup' has no member named
> > 'kmem_caches'
> >   return seq_list_next(p, &memcg->kmem_caches, pos);
> >                                 ^
> > mm/slab_common.c: In function 'memcg_slab_show':
> > mm/slab_common.c:1551:16: error: 'struct mem_cgroup' has no member named
> > 'kmem_caches'
> >   if (p == memcg->kmem_caches.next)
> >                 ^
> >   CC      arch/x86/xen/smp.o
> > mm/slab_common.c: In function 'memcg_slab_start':
> > mm/slab_common.c:1531:1: warning: control reaches end of non-void function
> > [-Wreturn-type]
> >  }
> >  ^
> > mm/slab_common.c: In function 'memcg_slab_next':
> > mm/slab_common.c:1538:1: warning: control reaches end of non-void function
> > [-Wreturn-type]
> >  }
> >  ^
> >
> > That's because kmem_caches is defined only when CONFIG_MEMCG_KMEM is set,
> > while memcg_slab_start() will use it no matter CONFIG_MEMCG_KMEM is defined
> > or not.
> >
> > By the way, the reason I mannuly undefined CONFIG_MEMCG_KMEM is to verify
> > whether my some other code change is still stable when CONFIG_MEMCG_KMEM is
> > not set. Unfortunately, the existing code has been already unstable since
> > v4.11.
> >
> > Fixes: bc2791f857e1 ("slab: link memcg kmem_caches on their associated memory cgroup")
> > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  mm/memcontrol.c  | 2 ++
> >  mm/slab_common.c | 2 +-
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6f6dc8712e39..43f0125b45bb 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4723,6 +4723,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
> >               .write = mem_cgroup_reset,
> >               .read_u64 = mem_cgroup_read_u64,
> >       },
> > +#ifdef CONFIG_MEMCG_KMEM
> >  #if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
>
> Not sure if
>
> #if defined(CONFIG_MEMCG_KMEM) && \
>     (defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
>
> is preffered
>

Seems better. Thanks for your suggestion.

Thanks
Yafang
