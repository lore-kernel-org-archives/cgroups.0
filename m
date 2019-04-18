From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 4/5] mm: rework non-root kmem_cache lifecycle management
Date: Thu, 18 Apr 2019 18:05:15 +0000
Message-ID: <20190418180510.GB11008@tower.DHCP.thefacebook.com>
References: <20190417215434.25897-1-guro@fb.com>
 <20190417215434.25897-5-guro@fb.com>
 <0100016a30abc330-011d895a-b4af-40a9-8937-990297ed4ffd-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rtCtANNIr/1Sg2LyrELfXsaYNGiy8l+IvutL0qSsLpo=;
 b=O0/YsIB8j91b1QurTeZgnLlicpJGnVJXlvJugK/y8TXFPMUjohT1kDv0NGBAgn/hoSvc
 XICPATH/F7VuzdxZqrkPtiOqVF6cbKE3zvhoW5BXodgEX9O3534MiXaNOW8yX5gR5JqW
 AsLG3bGpNXMYDpfGYTJIYZxVUdrlxRG5pMk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtCtANNIr/1Sg2LyrELfXsaYNGiy8l+IvutL0qSsLpo=;
 b=VOx+HOyQmIGnolCFHmc3EzyBHJJzE8LJrkbHw4yginIAfGOFYeyL7L8WrSsnTQD/4LvHWpsYkvjFWRkFRgw3qg0vcuItYN126ylK2QUMm2hM89DwEQFQg6wzfLuKw0aeSrp/IQ6jO9BDPtmv+gKvubSRedRTf8ulqWC4lH4NYqw=
In-Reply-To: <0100016a30abc330-011d895a-b4af-40a9-8937-990297ed4ffd-000000@email.amazonses.com>
Content-Language: en-US
Content-ID: <B63A3F64D484F84F9EBD4788F5ACDCFA@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christopher Lameter <cl@linux.com>
Cc: Roman Gushchin <guroan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, "david@fromorbit.com" <david@fromorbit.com>, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

On Thu, Apr 18, 2019 at 01:38:44PM +0000, Christopher Lameter wrote:
> On Wed, 17 Apr 2019, Roman Gushchin wrote:
>=20
> >  static __always_inline int memcg_charge_slab(struct page *page,
> >  					     gfp_t gfp, int order,
> >  					     struct kmem_cache *s)
> >  {
> > -	if (is_root_cache(s))
> > +	int idx =3D (s->flags & SLAB_RECLAIM_ACCOUNT) ?
> > +		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
> > +	struct mem_cgroup *memcg;
> > +	struct lruvec *lruvec;
> > +	int ret;
> > +
> > +	if (is_root_cache(s)) {
> > +		mod_node_page_state(page_pgdat(page), idx, 1 << order);
>=20
> Hmmm... This is functionality that is not memcg specific being moved into
> a memcg function??? Maybe rename the function to indicate that it is not
> memcg specific and add the proper #ifdefs?
>=20
> >  static __always_inline void memcg_uncharge_slab(struct page *page, int=
 order,
> >  						struct kmem_cache *s)
> >  {
> > -	memcg_kmem_uncharge(page, order);
> > +	int idx =3D (s->flags & SLAB_RECLAIM_ACCOUNT) ?
> > +		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
> > +	struct mem_cgroup *memcg;
> > +	struct lruvec *lruvec;
> > +
> > +	if (is_root_cache(s)) {
> > +		mod_node_page_state(page_pgdat(page), idx, -(1 << order));
> > +		return;
> > +	}
>=20
> And again.
>=20

Good point! Will do in v2.

Thanks!
