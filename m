From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: memcg/slab: Don't create unfreeable slab
Date: Mon, 3 May 2021 09:24:28 -0700
Message-ID: <CALvZod4aW0P2a5ZG4JO4YH2oQ8a1kM9_Tsjz-tAGP_-9hLyOpw@mail.gmail.com>
References: <20210502180755.445-1-longman@redhat.com> <20210502180755.445-2-longman@redhat.com>
 <699e5ac8-9044-d664-f73f-778fe72fd09b@suse.cz> <4c90cf79-9c61-8964-a6fd-2da087893339@redhat.com>
 <d767ff72-711d-976c-d897-9cea0375c827@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TcATYEvqWtFfx/44txhT0Spsn4kumnm2+a2rXW71+CM=;
        b=Eaj4rKKhZajb/S9uMXpRE9KCEfy5HuJE+EtOo+Se6CW6ZyQY6bjKa68nq45phIbM8c
         9TspWHri3VmH+anix1LFL9doASiwyNTqks3Vv/7hIOtmUu9iGOYIp1pDR+mJj140dErP
         2zdwQ4ZzQCYdtRvlXSW3nT+Oui+b+dcaeR9qAq78qteAVIv+oBCqxsjuJawt+JhI0XDR
         WSEvmIiMehxJm2M0t2lllY238waLTBfzWXMAcWNGZzTHFzl8495jjZshk4PXeB+VzL88
         D/Yv7r5Rda77+oUmHrJMYIxfK2ANAzAvW5iNyhVv2B933abB++3JB+BeSQFVVtKcg//l
         P0nw==
In-Reply-To: <d767ff72-711d-976c-d897-9cea0375c827-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, May 3, 2021 at 8:32 AM Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
>
> On 5/3/21 4:20 PM, Waiman Long wrote:
> > On 5/3/21 8:22 AM, Vlastimil Babka wrote:
> >> On 5/2/21 8:07 PM, Waiman Long wrote:
> >>> The obj_cgroup array (memcg_data) embedded in the page structure is
> >>> allocated at the first instance an accounted memory allocation happens.
> >>> With the right size object, it is possible that the allocated obj_cgroup
> >>> array comes from the same slab that requires memory accounting. If this
> >>> happens, the slab will never become empty again as there is at least one
> >>> object left (the obj_cgroup array) in the slab.
> >>>
> >>> With instructmentation code added to detect this situation, I got 76
> >>> hits on the kmalloc-192 slab when booting up a test kernel on a VM.
> >>> So this can really happen.
> >>>
> >>> To avoid the creation of these unfreeable slabs, a check is added to
> >>> memcg_alloc_page_obj_cgroups() to detect that and double the size
> >>> of the array in case it happens to make sure that it comes from a
> >>> different kmemcache.
> >>>
> >>> This change, however, does not completely eliminate the presence
> >>> of unfreeable slabs which can still happen if a circular obj_cgroup
> >>> array dependency is formed.
> >> Hm this looks like only a half fix then.
> >> I'm afraid the proper fix is for kmemcg to create own set of caches for the
> >> arrays. It would also solve the recursive kfree() issue.
> >
> > Right, this is a possible solution. However, the objcg pointers array should
> > need that much memory. Creating its own set of kmemcaches may seem like an
> > overkill.
>
> Well if we go that way, there might be additional benefits:
>
> depending of gfp flags, kmalloc() would allocate from:
>
> kmalloc-* caches that never have kmemcg objects, thus can be used for the objcg
> pointer arrays
> kmalloc-cg-* caches that have only kmemcg unreclaimable objects
> kmalloc-rcl-* and dma-kmalloc-* can stay with on-demand
> memcg_alloc_page_obj_cgroups()
>
> This way we fully solve the issues that this patchset solves. In addition we get
> better separation between kmemcg and !kmemcg thus save memory - no allocation of
> the array as soon as a single object appears in slab. For "kmalloc-8" we now
> have 8 bytes for the useful data and 8 bytes for the obj_cgroup  pointer.
>

Yes this seems like a better approach.
