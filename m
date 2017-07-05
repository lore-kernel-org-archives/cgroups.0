From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4/5] mm/memcontrol: allow to uncharge page without using
 page->lru field
Date: Wed, 5 Jul 2017 08:38:14 +0200
Message-ID: <20170705063813.GB10354@dhcp22.suse.cz>
References: <20170703211415.11283-1-jglisse@redhat.com>
 <20170703211415.11283-5-jglisse@redhat.com>
 <20170704125113.GC14727@dhcp22.suse.cz>
 <CAKTCnz=zTjYeqeTYZbnOMsT1Ccus4yW=jAws_OgXp3q4xmuSPA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAKTCnz=zTjYeqeTYZbnOMsT1Ccus4yW=jAws_OgXp3q4xmuSPA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Balbir Singh <bsingharora@gmail.com>
Cc: =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, John Hubbard <jhubbard@nvidia.com>, David Nellans <dnellans@nvidia.com>, Dan Williams <dan.j.williams@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

On Wed 05-07-17 13:18:18, Balbir Singh wrote:
> On Tue, Jul 4, 2017 at 10:51 PM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Mon 03-07-17 17:14:14, J=E9r=F4me Glisse wrote:
> >> HMM pages (private or public device pages) are ZONE_DEVICE page and
> >> thus you can not use page->lru fields of those pages. This patch
> >> re-arrange the uncharge to allow single page to be uncharge without
> >> modifying the lru field of the struct page.
> >>
> >> There is no change to memcontrol logic, it is the same as it was
> >> before this patch.
> >
> > What is the memcg semantic of the memory? Why is it even charged? AFAIR
> > this is not a reclaimable memory. If yes how are we going to deal with
> > memory limits? What should happen if go OOM? Does killing an process
> > actually help to release that memory? Isn't it pinned by a device?
> >
> > For the patch itself. It is quite ugly but I haven't spotted anything
> > obviously wrong with it. It is the memcg semantic with this class of
> > memory which makes me worried.
> >
>=20
> This is the HMM CDM case. Memory is normally malloc'd and then
> migrated to ZONE_DEVICE or vice-versa. One of the things we did
> discuss was seeing ZONE_DEVICE memory in user page tables.

This doesn't answer any of the above questions though.
--=20
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
