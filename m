From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [HMM-v25 10/19] mm/memcontrol: support MEMORY_DEVICE_PRIVATE v4
Date: Tue, 5 Sep 2017 13:21:21 -0400
Message-ID: <20170905172120.GB19397@redhat.com>
References: <20170817000548.32038-1-jglisse@redhat.com>
 <20170817000548.32038-11-jglisse@redhat.com>
 <f239d1c2-7006-5ce4-7848-7d82e67533a9@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f239d1c2-7006-5ce4-7848-7d82e67533a9@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>, Dan Williams <dan.j.williams@intel.com>, David Nellans <dnellans@nvidia.com>, Balbir Singh <bsingharora@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org

On Tue, Sep 05, 2017 at 07:13:15PM +0200, Laurent Dufour wrote:
> On 17/08/2017 02:05, J=E9r=F4me Glisse wrote:
> > HMM pages (private or public device pages) are ZONE_DEVICE page and
> > thus need special handling when it comes to lru or refcount. This
> > patch make sure that memcontrol properly handle those when it face
> > them. Those pages are use like regular pages in a process address
> > space either as anonymous page or as file back page. So from memcg
> > point of view we want to handle them like regular page for now at
> > least.
> >=20
> > Changed since v3:
> >   - remove public support and move those chunk to separate patch
> > Changed since v2:
> >   - s/host/public
> > Changed since v1:
> >   - s/public/host
> >   - add comments explaining how device memory behave and why
> >=20
> > Signed-off-by: J=E9r=F4me Glisse <jglisse@redhat.com>
> > Acked-by: Balbir Singh <bsingharora@gmail.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: cgroups@vger.kernel.org
> > ---
> >  kernel/memremap.c |  1 +
> >  mm/memcontrol.c   | 52 +++++++++++++++++++++++++++++++++++++++++++++++=
+----
> >  2 files changed, 49 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/kernel/memremap.c b/kernel/memremap.c
> > index 398630c1fba3..f42d7483e886 100644
> > --- a/kernel/memremap.c
> > +++ b/kernel/memremap.c
> > @@ -492,6 +492,7 @@ void put_zone_device_private_page(struct page *page)
> >  		__ClearPageWaiters(page);
> >=20
> >  		page->mapping =3D NULL;
> > +		mem_cgroup_uncharge(page);
> >=20
> >  		page->pgmap->page_free(page, page->pgmap->data);
> >  	} else if (!count)
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 604fb3ca8028..977d1cf3493a 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4407,12 +4407,13 @@ enum mc_target_type {
> >  	MC_TARGET_NONE =3D 0,
> >  	MC_TARGET_PAGE,
> >  	MC_TARGET_SWAP,
> > +	MC_TARGET_DEVICE,
> >  };
> >=20
> >  static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
> >  						unsigned long addr, pte_t ptent)
> >  {
> > -	struct page *page =3D vm_normal_page(vma, addr, ptent);
> > +	struct page *page =3D _vm_normal_page(vma, addr, ptent, true);
>=20
> Hi J=E9r=F4me,
>=20
> As _vm_normal_page() is defined later in the patch 18, so this patch shou=
ld
>  break the bisectability.

Correct, it seems i miss that when re-org patch order. The vm_normal_page()
changes can be move to patch 18 as it would be more logical to change call
site with the patch that adds the new special function.

Dunno if patch can be edited now ?

Cheers,
J=E9r=F4me
