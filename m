From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [HMM-CDM 4/5] mm/memcontrol: support MEMORY_DEVICE_PRIVATE and
 MEMORY_DEVICE_PUBLIC
Date: Wed, 14 Jun 2017 22:04:55 -0400
Message-ID: <20170615020454.GA4666@redhat.com>
References: <20170614201144.9306-1-jglisse@redhat.com>
 <20170614201144.9306-5-jglisse@redhat.com>
 <20170615114159.11a1eece@firefly.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 4CB8FC008605
Content-Disposition: inline
In-Reply-To: <20170615114159.11a1eece-czjtt42qU+xukE8zL+fsbsxtgHpCUUYS@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 15, 2017 at 11:41:59AM +1000, Balbir Singh wrote:
> On Wed, 14 Jun 2017 16:11:43 -0400
> J=E9r=F4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > HMM pages (private or public device pages) are ZONE_DEVICE page and
> > thus need special handling when it comes to lru or refcount. This
> > patch make sure that memcontrol properly handle those when it face
> > them. Those pages are use like regular pages in a process address
> > space either as anonymous page or as file back page. So from memcg
> > point of view we want to handle them like regular page for now at
> > least.
> >=20
> > Signed-off-by: J=E9r=F4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public=
.gmane.org>
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.=
org>
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > ---
> >  kernel/memremap.c |  2 ++
> >  mm/memcontrol.c   | 58 +++++++++++++++++++++++++++++++++++++++++++++++=
+++-----
> >  2 files changed, 55 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/kernel/memremap.c b/kernel/memremap.c
> > index da74775..584984c 100644
> > --- a/kernel/memremap.c
> > +++ b/kernel/memremap.c
> > @@ -479,6 +479,8 @@ void put_zone_device_private_or_public_page(struct =
page *page)
> >  		__ClearPageActive(page);
> >  		__ClearPageWaiters(page);
> > =20
> > +		mem_cgroup_uncharge(page);
> > +
>=20
> A zone device page could have a mem_cgroup charge if
>=20
> 1. The old page was charged to a cgroup and the new page from ZONE_DEVICE=
 then
> gets the charge that we need to drop here
>=20
> And should not be charged
>=20
> 2. If the driver allowed mmap based allocation (these pages are not on LRU
>=20
>=20
> Since put_zone_device_private_or_public_page() is called from release_pag=
es(),
> I think the assumption is that 2 is not a problem? I've not tested the mm=
ap
> bits yet.

Well that is one of the big question. Do we care about memory cgroup despite
page not being on lru and thus not being reclaimable through the usual path=
 ?

I believe we do want to keep charging ZONE_DEVICE page against memory cgroup
so that userspace limit are enforced. This is important especialy for device
private when migrating back to system memory due to CPU page fault. We do n=
ot
want the migration back to fail because of memory cgroup limit.

Hence why i do want to charge ZONE_DEVICE page just like regular page. If we
have people that run into OOM because of this then we can start thinking ab=
out
how to account those pages slightly differently inside the memory cgroup.

For now i believe we do want this patch.


[...]

> > @@ -4610,6 +4637,9 @@ static enum mc_target_type get_mctgt_type(struct =
vm_area_struct *vma,
> >  		 */
> >  		if (page->mem_cgroup =3D=3D mc.from) {
> >  			ret =3D MC_TARGET_PAGE;
> > +			if (is_device_private_page(page) ||
> > +			    is_device_public_page(page))
> > +				ret =3D MC_TARGET_DEVICE;
> >  			if (target)
> >  				target->page =3D page;
> >  		}
> > @@ -4669,6 +4699,11 @@ static int mem_cgroup_count_precharge_pte_range(=
pmd_t *pmd,
> > =20
> >  	ptl =3D pmd_trans_huge_lock(pmd, vma);
> >  	if (ptl) {
> > +		/*
> > +		 * Note their can not be MC_TARGET_DEVICE for now as we do not
>                         there
> > +		 * support transparent huge page with MEMORY_DEVICE_PUBLIC or
> > +		 * MEMORY_DEVICE_PRIVATE but this might change.
>=20
> I am trying to remind myself why THP and MEMORY_DEVICE_* pages don't work=
 well
> together today, the driver could allocate a THP size set of pages and mig=
rate it.
> There are patches to do THP migration, not upstream yet. Could you remind=
 me
> of any other limitations?

No there is nothing that would be problematic AFAICT. Persistent memory alr=
eady
use huge page so we should be in the clear. But i would rather enable that =
as
a separate patchset alltogether and have proper testing specificaly for such
scenario.

J=E9r=F4me
