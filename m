From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 1/5] mm/memcg: Move mod_objcg_state() to memcontrol.c
Date: Mon, 19 Apr 2021 13:13:42 -0400
Message-ID: <YH26RrMBOxLaMg4l@cmpxchg.org>
References: <20210419000032.5432-1-longman@redhat.com>
 <20210419000032.5432-2-longman@redhat.com>
 <YH2eT+JCII48hX80@cmpxchg.org>
 <ffb5705e-8629-808d-9d09-0c9c7f509326@redhat.com>
 <140444ea-14e7-b305-910f-f23fafe45488@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Pte6gDNJh8xhmbfylrLlVHUNlTRi/dJM7p92ChkQdLw=;
        b=MwMmN19pYgiiPxO22E5Bn0qD6lq60MgWWDGEz0TubxyILZCMzhCPfXDVCVEDSTtYDg
         1nfmtoD4j9390fHkbbIVqjJxO8le3005eLFTk4YOGXlpwcUu8NeucgF56hni/Z4/4H96
         hjZPsaC4TB/U1cY+mFAGTYw9VUOfWgIzXBlndKEF1cuIJIKuz+BNR3QbWRJj+VR1vjrQ
         LBm94K2doToMiYJK/LvFAcquSUTPiiWtGJno+re8gnauJslto4r/DCHPKPLMt9DNYGfy
         kOK08NDrLO1kA3L9zeTWIADkRO9VM9Vr32AIuNWKbeIvtecS9RTcBNSfmIcMR3ngEUAx
         F19w==
Content-Disposition: inline
In-Reply-To: <140444ea-14e7-b305-910f-f23fafe45488-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <>

On Mon, Apr 19, 2021 at 12:18:29PM -0400, Waiman Long wrote:
> On 4/19/21 11:21 AM, Waiman Long wrote:
> > On 4/19/21 11:14 AM, Johannes Weiner wrote:
> > > On Sun, Apr 18, 2021 at 08:00:28PM -0400, Waiman Long wrote:
> > > > The mod_objcg_state() function is moved from mm/slab.h to
> > > > mm/memcontrol.c
> > > > so that further optimization can be done to it in later patches wit=
hout
> > > > exposing unnecessary details to other mm components.
> > > >=20
> > > > Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.g=
mane.org>
> > > > ---
> > > > =A0 mm/memcontrol.c | 13 +++++++++++++
> > > > =A0 mm/slab.h=A0=A0=A0=A0=A0=A0 | 16 ++--------------
> > > > =A0 2 files changed, 15 insertions(+), 14 deletions(-)
> > > >=20
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index e064ac0d850a..dc9032f28f2e 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -3150,6 +3150,19 @@ void __memcg_kmem_uncharge_page(struct
> > > > page *page, int order)
> > > > =A0=A0=A0=A0=A0 css_put(&memcg->css);
> > > > =A0 }
> > > > =A0 +void mod_objcg_state(struct obj_cgroup *objcg, struct
> > > > pglist_data *pgdat,
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enum node_stat_item idx, int =
nr)
> > > > +{
> > > > +=A0=A0=A0 struct mem_cgroup *memcg;
> > > > +=A0=A0=A0 struct lruvec *lruvec =3D NULL;
> > > > +
> > > > +=A0=A0=A0 rcu_read_lock();
> > > > +=A0=A0=A0 memcg =3D obj_cgroup_memcg(objcg);
> > > > +=A0=A0=A0 lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
> > > > +=A0=A0=A0 mod_memcg_lruvec_state(lruvec, idx, nr);
> > > > +=A0=A0=A0 rcu_read_unlock();
> > > > +}
> > > It would be more naturally placed next to the others, e.g. below
> > > __mod_lruvec_kmem_state().
> > >=20
> > > But no deal breaker if there isn't another revision.
> > >=20
> > > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane=
.org>
> > >=20
> > Yes, there will be another revision by rebasing patch series on the
> > linux-next. I will move the function then.
>=20
> OK, it turns out that mod_objcg_state() is only defined if
> CONFIG_MEMCG_KMEM. That was why I put it in the CONFIG_MEMCG_KMEM block w=
ith
> the other obj_stock functions. I think I will keep it there.

The CONFIG_MEMCG_KMEM has become sort of useless now. It used to be
configurable, but now it just means CONFIG_MEMCG && !CONFIG_SLOB. And
even that doesn't make sense because while slob doesn't support slab
object tracking, we can still do all the other stuff we do under
KMEM. I have a patch in the works to remove the symbol and ifdefs.

With that in mind, it's better to group the functions based on what
they do rather than based on CONFIG_MEMCG_KMEM. It's easier to just
remove another ifdef later than it is to reorder the functions.
