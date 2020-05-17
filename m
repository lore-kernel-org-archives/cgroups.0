From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH v2 3/4] mm/slub: Fix another circular locking dependency in slab_attr_store()
Date: Sat, 16 May 2020 22:19:12 -0400
Message-ID: <F1FA6654-C07C-42FD-B497-61EB635B264C@lca.pw>
References: <20200427235621.7823-4-longman@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=reILY0Vqckz9zOXZI1PQPYQDzXOJemhFua89GW65fy0=;
        b=pIAwb2eoYglLwoftFfZRHOH1Iauxv47DwFt8guUDUzepmhBtdWKnf6tj+cBDhU9OTF
         kECfnujvTJKr8YeroaSRIiYeVy5KG310PnOC4OsyxQQpkXo6JV8KUh6wHeidXXdnYJLi
         2urTKHfOv2+fh2Z/drc7aLYPMpFOhLMO8thHY7q6ZR2EHH3E3rk2TZMBw375QmdTfjhS
         WVxV5sKNACulZvEq6O83Mxk6dZiv9ieiAuoy2dCn3CpaWCc0E4KZvCOUTZwVthhcZqmp
         hwBOf1zuiZPtXjLHkbZSyw6nLiwrG/RWBgQdUOmCje4sXZHYx8G88VLOW5OwZabR568J
         jUkg==
In-Reply-To: <20200427235621.7823-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



> On Apr 27, 2020, at 7:56 PM, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> It turns out that switching from slab_mutex to memcg_cache_ids_sem in
> slab_attr_store() does not completely eliminate circular locking dependenc=
y
> as shown by the following lockdep splat when the system is shut down:
>=20
> [ 2095.079697] Chain exists of:
> [ 2095.079697]   kn->count#278 --> memcg_cache_ids_sem --> slab_mutex
> [ 2095.079697]
> [ 2095.090278]  Possible unsafe locking scenario:
> [ 2095.090278]
> [ 2095.096227]        CPU0                    CPU1
> [ 2095.100779]        ----                    ----
> [ 2095.105331]   lock(slab_mutex);
> [ 2095.108486]                                lock(memcg_cache_ids_sem);
> [ 2095.114961]                                lock(slab_mutex);
> [ 2095.120649]   lock(kn->count#278);
> [ 2095.124068]
> [ 2095.124068]  *** DEADLOCK ***

Can you show the full splat?

>=20
> To eliminate this possibility, we have to use trylock to acquire
> memcg_cache_ids_sem. Unlikely slab_mutex which can be acquired in
> many places, the memcg_cache_ids_sem write lock is only acquired
> in memcg_alloc_cache_id() to double the size of memcg_nr_cache_ids.
> So the chance of successive calls to memcg_alloc_cache_id() within
> a short time is pretty low. As a result, we can retry the read lock
> acquisition a few times if the first attempt fails.
>=20
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The code looks a bit hacky and probably not that robust. Since it is the shu=
tdown path which is not all that important without lockdep, maybe you could d=
rop this single patch for now until there is a better solution?

> ---
> include/linux/memcontrol.h |  1 +
> mm/memcontrol.c            |  5 +++++
> mm/slub.c                  | 25 +++++++++++++++++++++++--
> 3 files changed, 29 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index d275c72c4f8e..9285f14965b1 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1379,6 +1379,7 @@ extern struct workqueue_struct *memcg_kmem_cache_wq;=

> extern int memcg_nr_cache_ids;
> void memcg_get_cache_ids(void);
> void memcg_put_cache_ids(void);
> +int  memcg_tryget_cache_ids(void);
>=20
> /*
>  * Helper macro to loop through all memcg-specific caches. Callers must st=
ill
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5beea03dd58a..9fa8535ff72a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -279,6 +279,11 @@ void memcg_get_cache_ids(void)
>    down_read(&memcg_cache_ids_sem);
> }
>=20
> +int memcg_tryget_cache_ids(void)
> +{
> +    return down_read_trylock(&memcg_cache_ids_sem);
> +}
> +
> void memcg_put_cache_ids(void)
> {
>    up_read(&memcg_cache_ids_sem);
> diff --git a/mm/slub.c b/mm/slub.c
> index 44cb5215c17f..cf2114ca27f7 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -34,6 +34,7 @@
> #include <linux/prefetch.h>
> #include <linux/memcontrol.h>
> #include <linux/random.h>
> +#include <linux/delay.h>
>=20
> #include <trace/events/kmem.h>
>=20
> @@ -5572,6 +5573,7 @@ static ssize_t slab_attr_store(struct kobject *kobj,=

>        !list_empty(&s->memcg_params.children)) {
>        struct kmem_cache *c, **pcaches;
>        int idx, max, cnt =3D 0;
> +        int retries =3D 3;
>        size_t size, old =3D s->max_attr_size;
>        struct memcg_cache_array *arr;
>=20
> @@ -5585,9 +5587,28 @@ static ssize_t slab_attr_store(struct kobject *kobj=
,
>            old =3D cmpxchg(&s->max_attr_size, size, len);
>        } while (old !=3D size);
>=20
> -        memcg_get_cache_ids();
> -        max =3D memcg_nr_cache_ids;
> +        /*
> +         * To avoid the following circular lock chain
> +         *
> +         *   kn->count#278 --> memcg_cache_ids_sem --> slab_mutex
> +         *
> +         * We need to use trylock to acquire memcg_cache_ids_sem.
> +         *
> +         * Since the write lock is acquired only in
> +         * memcg_alloc_cache_id() to double the size of
> +         * memcg_nr_cache_ids. The chance of successive
> +         * memcg_alloc_cache_id() calls within a short time is
> +         * very low except at the beginning where the number of
> +         * memory cgroups is low. So we retry a few times to get
> +         * the memcg_cache_ids_sem read lock.
> +         */
> +        while (!memcg_tryget_cache_ids()) {
> +            if (retries-- <=3D 0)
> +                return -EBUSY;
> +            msleep(100);
> +        }
>=20
> +        max =3D memcg_nr_cache_ids;
>        pcaches =3D kmalloc_array(max, sizeof(void *), GFP_KERNEL);
>        if (!pcaches) {
>            memcg_put_cache_ids();
