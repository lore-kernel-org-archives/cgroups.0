From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [HMM-CDM 3/5] mm/memcontrol: allow to uncharge page without
 using page->lru field
Date: Thu, 15 Jun 2017 11:35:34 -0400
Message-ID: <20170615153533.GA3837@redhat.com>
References: <20170614201144.9306-1-jglisse@redhat.com>
 <20170614201144.9306-4-jglisse@redhat.com>
 <20170615133128.2fe2c33f@firefly.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 48FED7F6A1
Content-Disposition: inline
In-Reply-To: <20170615133128.2fe2c33f-czjtt42qU+xukE8zL+fsbsxtgHpCUUYS@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 15, 2017 at 01:31:28PM +1000, Balbir Singh wrote:
> On Wed, 14 Jun 2017 16:11:42 -0400
> J=E9r=F4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > HMM pages (private or public device pages) are ZONE_DEVICE page and
> > thus you can not use page->lru fields of those pages. This patch
> > re-arrange the uncharge to allow single page to be uncharge without
> > modifying the lru field of the struct page.
> >=20
> > There is no change to memcontrol logic, it is the same as it was
> > before this patch.
> >=20
> > Signed-off-by: J=E9r=F4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public=
.gmane.org>
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.=
org>
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > ---
> >  mm/memcontrol.c | 168 +++++++++++++++++++++++++++++++-----------------=
--------
> >  1 file changed, 92 insertions(+), 76 deletions(-)
> >=20
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e3fe4d0..b93f5fe 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5509,48 +5509,102 @@ void mem_cgroup_cancel_charge(struct page *pag=
e, struct mem_cgroup *memcg,
> >  	cancel_charge(memcg, nr_pages);
> >  }
> > =20
> > -static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgp=
gout,
> > -			   unsigned long nr_anon, unsigned long nr_file,
> > -			   unsigned long nr_kmem, unsigned long nr_huge,
> > -			   unsigned long nr_shmem, struct page *dummy_page)
> > +struct uncharge_gather {
> > +	struct mem_cgroup *memcg;
> > +	unsigned long pgpgout;
> > +	unsigned long nr_anon;
> > +	unsigned long nr_file;
> > +	unsigned long nr_kmem;
> > +	unsigned long nr_huge;
> > +	unsigned long nr_shmem;
> > +	struct page *dummy_page;
> > +};
> > +
> > +static inline void uncharge_gather_clear(struct uncharge_gather *ug)
> >  {
> > -	unsigned long nr_pages =3D nr_anon + nr_file + nr_kmem;
> > +	memset(ug, 0, sizeof(*ug));
> > +}
> > +
> > +static void uncharge_batch(const struct uncharge_gather *ug)
> > +{
>=20
> Can we pass page as an argument so that we can do check events on the pag=
e?

Well it is what dummy page is for, i wanted to keep code as close
to existing to make it easier for people to see that there was no
logic change with that patch.


[...]

> > +static void uncharge_page(struct page *page, struct uncharge_gather *u=
g)
> > +{
> > +	VM_BUG_ON_PAGE(PageLRU(page), page);
> > +	VM_BUG_ON_PAGE(!PageHWPoison(page) && page_count(page), page);
> > +
> > +	if (!page->mem_cgroup)
> > +		return;
> > +
> > +	/*
> > +	 * Nobody should be changing or seriously looking at
> > +	 * page->mem_cgroup at this point, we have fully
> > +	 * exclusive access to the page.
> > +	 */
> > +
> > +	if (ug->memcg !=3D page->mem_cgroup) {
> > +		if (ug->memcg) {
> > +			uncharge_batch(ug);
>=20
> What is ug->dummy_page set to at this point? ug->dummy_page is assigned b=
elow

So at begining ug->memcg is NULL and so is ug->dummy_page, after first
call to uncharge_page() if ug->memcg isn't NULL then ug->dummy_page
points to a valid page. So uncharge_batch() can never be call with
dummy_page =3D=3D NULL same as before this patch.


[...]

> >  static void uncharge_list(struct list_head *page_list)
> >  {
> > -	struct mem_cgroup *memcg =3D NULL;
> > -	unsigned long nr_shmem =3D 0;
> > -	unsigned long nr_anon =3D 0;
> > -	unsigned long nr_file =3D 0;
> > -	unsigned long nr_huge =3D 0;
> > -	unsigned long nr_kmem =3D 0;
> > -	unsigned long pgpgout =3D 0;
> > +	struct uncharge_gather ug;
> >  	struct list_head *next;
> > -	struct page *page;
> > +
> > +	uncharge_gather_clear(&ug);
> > =20
> >  	/*
> >  	 * Note that the list can be a single page->lru; hence the
> > @@ -5558,57 +5612,16 @@ static void uncharge_list(struct list_head *pag=
e_list)
> >  	 */
> >  	next =3D page_list->next;
> >  	do {
> > +		struct page *page;
> > +
>=20
> Nit pick
>=20
> VM_WARN_ON(is_zone_device_page(page));

Yeah probably good thing to add. I will add it as part of the
other memcontrol patch as i want to keep this one about moving
stuff around with no logic change.

Thanks for reviewing
J=E9r=F4me
