From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v5 2/3] mm: memcg/slab: Create a new set of
 kmalloc-cg-<n> caches
Date: Wed, 12 May 2021 17:32:12 -0700
Message-ID: <20210512173212.738f592c36bf0e4c205f628e@linux-foundation.org>
References: <20210505200610.13943-1-longman@redhat.com>
        <20210512145107.6208-1-longman@redhat.com>
        <0919aaab-cc08-f86d-1f9a-8ddfeed7bb31@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620865933;
        bh=NqerZcueDe5Vdup5YWaIr/cMiCRyTzm7WBaBKhWYa7o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L00Jcm0ErlbgR36ajW4jCZFAKDnlSvY9k0wYlsDluPw9zlduW/bOD6JVblaQcOt+q
         z46YCVZw8lws+725jTiNN7kC0DWof2X8vMlEDhc1T5+yyuhwo3cRh+uQaGIs4NQBX6
         VKcQn7lVOU3pR8dh+zEbvvU3oM6VTG9J4VaohlS4=
In-Reply-To: <0919aaab-cc08-f86d-1f9a-8ddfeed7bb31-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, 12 May 2021 10:54:19 -0400 Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> >   include/linux/slab.h | 42 +++++++++++++++++++++++++++++++++---------
> >   mm/slab_common.c     | 25 +++++++++++++++++--------
> >   2 files changed, 50 insertions(+), 17 deletions(-)
>=20
> The following are the diff's from previous version. It turns out that=20
> the previous patch doesn't work if CONFIG_ZONE_DMA isn't defined.
>=20
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index a51cad5f561c..aa7f6c222a60 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -312,16 +312,17 @@ static inline void __check_heap_object(const void=20
> *ptr, un
> signed long n,
>  =A0 */
>  =A0enum kmalloc_cache_type {
>  =A0=A0=A0=A0 KMALLOC_NORMAL =3D 0,
> -#ifdef CONFIG_MEMCG_KMEM
> -=A0=A0=A0 KMALLOC_CGROUP,
> -#else
> +#ifndef CONFIG_ZONE_DMA
> +=A0=A0=A0 KMALLOC_DMA =3D KMALLOC_NORMAL,
> +#endif
> +#ifndef CONFIG_MEMCG_KMEM
>  =A0=A0=A0=A0 KMALLOC_CGROUP =3D KMALLOC_NORMAL,
> +#else
> +=A0=A0=A0 KMALLOC_CGROUP,
>  =A0#endif
>  =A0=A0=A0=A0 KMALLOC_RECLAIM,
>  =A0#ifdef CONFIG_ZONE_DMA
>  =A0=A0=A0=A0 KMALLOC_DMA,
> -#else
> -=A0=A0=A0 KMALLOC_DMA =3D KMALLOC_NORMAL,
>  =A0#endif
>  =A0=A0=A0=A0 NR_KMALLOC_TYPES
>  =A0};

I assume this fixes
https://lkml.kernel.org/r/20210512152806.2492ca42-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org?

