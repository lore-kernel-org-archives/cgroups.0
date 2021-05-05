From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm: memcg/slab: Create a new set of
 kmalloc-cg-<n> caches
Date: Wed, 5 May 2021 11:38:17 -0700
Message-ID: <YJLmGcGYLZwqehIX@carbon.dhcp.thefacebook.com>
References: <20210505154613.17214-1-longman@redhat.com>
 <20210505154613.17214-3-longman@redhat.com>
 <YJLWN6bNBYyKRPEN@carbon.DHCP.thefacebook.com>
 <235f45b4-2d99-f32d-ac2b-18b59fea5a25@suse.cz>
 <4e4b6903-2444-f4ed-f589-26d5beae3120@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=RAVf5S2ap8edtOM0cctuOMXgO8QEiKmMqbwR9owORi4=;
 b=m9TzShrDWKfcklKq/Y0yhNazXkHPBbEyfb8W343lCC6ulTPFhPvPJghEBubDI5QHxd4W
 4e8IAojpL3XgCKJ74ilzv8vpOc+xwFSm8dgyOVNCGhuyPq+jtiJmeRHnoyk1AVRQethJ
 a7wy1sG+wSQtK5JaGGVHLth5TNE4EGM/Aeo= 
Content-Disposition: inline
In-Reply-To: <4e4b6903-2444-f4ed-f589-26d5beae3120-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, May 05, 2021 at 02:31:28PM -0400, Waiman Long wrote:
> On 5/5/21 2:02 PM, Vlastimil Babka wrote:
> > On 5/5/21 7:30 PM, Roman Gushchin wrote:
> > > On Wed, May 05, 2021 at 11:46:13AM -0400, Waiman Long wrote:
> > > > With this change, all the objcg pointer array objects will come from
> > > > KMALLOC_NORMAL caches which won't have their objcg pointer arrays. =
So
> > > > both the recursive kfree() problem and non-freeable slab problem are
> > > > gone. Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no lo=
nger
> > > > have mixed accounted and unaccounted objects, this will slightly re=
duce
> > > > the number of objcg pointer arrays that need to be allocated and sa=
ve
> > > > a bit of memory.
> > > Unfortunately the positive effect of this change will be likely
> > > reversed by a lower utilization due to a larger number of caches.
> > >=20
> > > Btw, I wonder if we also need a change in the slab caches merging pro=
cedure?
> > > KMALLOC_NORMAL caches should not be merged with caches which can pote=
ntially
> > > include accounted objects.
> > Good point. But looks like kmalloc* caches are extempt from all merging=
 in
> > create_boot_cache() via
> >=20
> > 	s->refcount =3D -1;       /* Exempt from merging for now */
> >=20
> > It wouldn't hurt though to create the kmalloc-cg-* caches with SLAB_ACC=
OUNT flag
> > to prevent accidental merging in case the above is ever removed. It wou=
ld also
> > better reflect reality, and ensure that the array is allocated immediat=
ely with
> > the page, AFAICS.
> >=20
> I am not sure if this is really true.
>=20
> struct kmem_cache *__init create_kmalloc_cache(const char *name,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned int size, slab_fla=
gs_t flags,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned int useroffset, un=
signed int usersize)
> {
> =A0=A0=A0=A0=A0=A0=A0 struct kmem_cache *s =3D kmem_cache_zalloc(kmem_cac=
he, GFP_NOWAIT);
>=20
> =A0=A0=A0=A0=A0=A0=A0 if (!s)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 panic("Out of memory when c=
reating slab %s\n", name);
>=20
> =A0=A0=A0=A0=A0=A0=A0 create_boot_cache(s, name, size, flags, useroffset,=
 usersize);
> =A0=A0=A0=A0=A0=A0=A0 kasan_cache_create_kmalloc(s);
> =A0=A0=A0=A0=A0=A0=A0 list_add(&s->list, &slab_caches);
> =A0=A0=A0=A0=A0=A0=A0 s->refcount =3D 1;
> =A0=A0=A0=A0=A0=A0=A0 return s;
> }
>=20
> Even though refcount is set to -1 initially, it is set back to 1 afterwar=
d.
> So merging can still happen AFAICS.

Right, thanks, I already noticed it. Then yeah, we should make sure we're n=
ot
merging KMALLOC_NORMAL caches with any others.
