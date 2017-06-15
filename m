From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [HMM-CDM 4/5] mm/memcontrol: support MEMORY_DEVICE_PRIVATE and
 MEMORY_DEVICE_PUBLIC
Date: Thu, 15 Jun 2017 13:10:30 +1000
Message-ID: <20170615131030.35fe8d57@firefly.ozlabs.ibm.com>
References: <20170614201144.9306-1-jglisse@redhat.com>
	<20170614201144.9306-5-jglisse@redhat.com>
	<20170615114159.11a1eece@firefly.ozlabs.ibm.com>
	<20170615020454.GA4666@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dp4qL4z7rd5dYkoLmb79ZkGrPsvI1ABTkMuTf7cBjeI=;
        b=cTjJBqJ3pEuA832ar8IZq8+XUsQ56XcUVTnXWgmdjPprclU3Lfn6v1vMDGuZTdPG44
         VTXDLiwykRWcvFnUqKxIXZYFpyu4B3xMPfavz5n8bgVH0Eaxn3WXxyuPpxG+s3FBwuKJ
         mF/V0ZLkQcWIc3tQ1fj+GxObw7ehcjJ6OW04TdnvlLvqS5a0AeaRXC7jxaQwhFLXLo3O
         0akVek91ayPKtgiW/ex90ewqOSXBpaQh4APak7I5ym/TOXeRZfrTh90cgscK22SatyL+
         3o4Gbh6Pa8V5N2LA5GC16j1r6MPW8cGSxpQSMWmq3+iWcTGvYTgLgSO1TNYO+nrB054d
         KI1w==
In-Reply-To: <20170615020454.GA4666@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>, David Nellans <dnellans@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org

On Wed, 14 Jun 2017 22:04:55 -0400
Jerome Glisse <jglisse@redhat.com> wrote:

> On Thu, Jun 15, 2017 at 11:41:59AM +1000, Balbir Singh wrote:
> > On Wed, 14 Jun 2017 16:11:43 -0400
> > J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com> wrote:
> >  =20
> > > HMM pages (private or public device pages) are ZONE_DEVICE page and
> > > thus need special handling when it comes to lru or refcount. This
> > > patch make sure that memcontrol properly handle those when it face
> > > them. Those pages are use like regular pages in a process address
> > > space either as anonymous page or as file back page. So from memcg
> > > point of view we want to handle them like regular page for now at
> > > least.
> > >=20
> > > Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: Michal Hocko <mhocko@kernel.org>
> > > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > > Cc: cgroups@vger.kernel.org
> > > ---
> > >  kernel/memremap.c |  2 ++
> > >  mm/memcontrol.c   | 58 +++++++++++++++++++++++++++++++++++++++++++++=
+++++-----
> > >  2 files changed, 55 insertions(+), 5 deletions(-)
> > >=20
> > > diff --git a/kernel/memremap.c b/kernel/memremap.c
> > > index da74775..584984c 100644
> > > --- a/kernel/memremap.c
> > > +++ b/kernel/memremap.c
> > > @@ -479,6 +479,8 @@ void put_zone_device_private_or_public_page(struc=
t page *page)
> > >  		__ClearPageActive(page);
> > >  		__ClearPageWaiters(page);
> > > =20
> > > +		mem_cgroup_uncharge(page);
> > > + =20
> >=20
> > A zone device page could have a mem_cgroup charge if
> >=20
> > 1. The old page was charged to a cgroup and the new page from ZONE_DEVI=
CE then
> > gets the charge that we need to drop here
> >=20
> > And should not be charged
> >=20
> > 2. If the driver allowed mmap based allocation (these pages are not on =
LRU
> >=20
> >=20
> > Since put_zone_device_private_or_public_page() is called from release_p=
ages(),
> > I think the assumption is that 2 is not a problem? I've not tested the =
mmap
> > bits yet. =20
>=20
> Well that is one of the big question. Do we care about memory cgroup desp=
ite
> page not being on lru and thus not being reclaimable through the usual pa=
th ?
>=20
> I believe we do want to keep charging ZONE_DEVICE page against memory cgr=
oup
> so that userspace limit are enforced. This is important especialy for dev=
ice
> private when migrating back to system memory due to CPU page fault. We do=
 not
> want the migration back to fail because of memory cgroup limit.
>=20
> Hence why i do want to charge ZONE_DEVICE page just like regular page. If=
 we
> have people that run into OOM because of this then we can start thinking =
about
> how to account those pages slightly differently inside the memory cgroup.
>=20
> For now i believe we do want this patch.
>=20

Yes, we do need the patch, I was trying to check if we'll end up trying to =
uncharge
a page that is not charged, just double checking

>=20
> [...]
>=20
> > > @@ -4610,6 +4637,9 @@ static enum mc_target_type get_mctgt_type(struc=
t vm_area_struct *vma,
> > >  		 */
> > >  		if (page->mem_cgroup =3D=3D mc.from) {
> > >  			ret =3D MC_TARGET_PAGE;
> > > +			if (is_device_private_page(page) ||
> > > +			    is_device_public_page(page))
> > > +				ret =3D MC_TARGET_DEVICE;
> > >  			if (target)
> > >  				target->page =3D page;
> > >  		}
> > > @@ -4669,6 +4699,11 @@ static int mem_cgroup_count_precharge_pte_rang=
e(pmd_t *pmd,
> > > =20
> > >  	ptl =3D pmd_trans_huge_lock(pmd, vma);
> > >  	if (ptl) {
> > > +		/*
> > > +		 * Note their can not be MC_TARGET_DEVICE for now as we do not =20
> >                         there =20
> > > +		 * support transparent huge page with MEMORY_DEVICE_PUBLIC or
> > > +		 * MEMORY_DEVICE_PRIVATE but this might change. =20
> >=20
> > I am trying to remind myself why THP and MEMORY_DEVICE_* pages don't wo=
rk well
> > together today, the driver could allocate a THP size set of pages and m=
igrate it.
> > There are patches to do THP migration, not upstream yet. Could you remi=
nd me
> > of any other limitations? =20
>=20
> No there is nothing that would be problematic AFAICT. Persistent memory a=
lready
> use huge page so we should be in the clear. But i would rather enable tha=
t as
> a separate patchset alltogether and have proper testing specificaly for s=
uch
> scenario.

Agreed
Balbir Singh.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
