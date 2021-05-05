From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/2] mm: memcg/slab: Properly set up gfp flags for
 objcg pointer array
Date: Wed, 5 May 2021 09:09:14 -0700
Message-ID: <CALvZod6AfOiKC3tmnJzgAJEUKwXwS__n8on59qbmHyHG2XAc4w@mail.gmail.com>
References: <20210505154613.17214-1-longman@redhat.com> <20210505154613.17214-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KKsuEFeD+gJYSLJ7ekg4hfVqsnbJkGKmSnFbVOc/YJ0=;
        b=pGurct48b4cD8PojrnEnwDogn490UJ9vqixvhsKhgQxNctHN1tmUuM3UD9+ybdnCIY
         UxaEbOhE28qlVJbcYa48VZQspRkpa6R+BdyW29LwM/CJLY+97Y+uD6Cp5fdO4dnPj2rX
         A0mfjYE/DSuuRi1bqPpZG1hrFxCO7tuqYHZDpNQeXKfe+E+ImMxuIh9hdW3twa5HeDV6
         G2NJHXEeRLfd4fcv1JDhs3H8kWGJrtpuq9tLRg6pUf6vAquDmBcDLuBANRZ1u8FO36ON
         PDLNDLz8lbu0hary8tnz00mf3UhHAdg/2teGSWUTWOyMpHy/jr1tEsiXr/46vVNPzP75
         9Xag==
In-Reply-To: <20210505154613.17214-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, May 5, 2021 at 8:47 AM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Since the merging of the new slab memory controller in v5.9, the page
> structure may store a pointer to obj_cgroup pointer array for slab pages.
> Currently, only the __GFP_ACCOUNT bit is masked off. However, the array
> is not readily reclaimable and doesn't need to come from the DMA buffer.
> So those GFP bits should be masked off as well.
>
> Do the flag bit clearing at memcg_alloc_page_obj_cgroups() to make sure
> that it is consistently applied no matter where it is called.
>
> Fixes: 286e04b8ed7a ("mm: memcg/slab: allocate obj_cgroups for non-root slab pages")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
