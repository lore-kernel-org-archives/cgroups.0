From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] mm/memcontrol: allow to uncharge page without using
 page->lru field
Date: Mon, 10 Jul 2017 14:10:53 -0400
Message-ID: <20170710181053.GD4964@redhat.com>
References: <20170703211415.11283-5-jglisse@redhat.com>
 <20170704125113.GC14727@dhcp22.suse.cz>
 <20170705143528.GB3305@redhat.com>
 <20170710082805.GD19185@dhcp22.suse.cz>
 <20170710153222.GA4964@redhat.com>
 <20170710160444.GB7071@dhcp22.suse.cz>
 <20170710162542.GB4964@redhat.com>
 <20170710163651.GD7071@dhcp22.suse.cz>
 <20170710165420.GC4964@redhat.com>
 <20170710174857.GF7071@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 2D2F67F6A6
Content-Disposition: inline
In-Reply-To: <20170710174857.GF7071-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 10, 2017 at 07:48:58PM +0200, Michal Hocko wrote:
> On Mon 10-07-17 12:54:21, Jerome Glisse wrote:
> > On Mon, Jul 10, 2017 at 06:36:52PM +0200, Michal Hocko wrote:
> > > On Mon 10-07-17 12:25:42, Jerome Glisse wrote:
> > > [...]
> > > > Bottom line is that we can always free and uncharge device memory
> > > > page just like any regular page.
> > >=20
> > > OK, this answers my earlier question. Then it should be feasible to
> > > charge this memory. There are still some things to handle. E.g. how do
> > > we consider this memory during oom victim selection (this is not
> > > accounted as an anonymous memory in get_mm_counter, right?), maybe ot=
hers.
> > > But the primary point is that nobody pins the memory outside of the
> > > mapping.
> >=20
> > At this point it is accounted as a regular page would be (anonymous, fi=
le
> > or share memory). I wanted mm_counters to reflect memcg but i can untie
> > that.
>=20
> I am not sure I understand. If the device memory is accounted to the
> same mm counter as the original page then it is correct. I will try to
> double check the implementation (hopefully soon).

It is accounted like the original page. By same as memcg i mean i made
the same kind of choice for mm counter than i made for memcg. It is
all in the migrate code (migrate.c) ie i don't touch any of the mm
counter when migrating page.

J=E9r=F4me
