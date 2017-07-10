From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 4/5] mm/memcontrol: allow to uncharge page without using
 page->lru field
Date: Mon, 10 Jul 2017 12:54:21 -0400
Message-ID: <20170710165420.GC4964@redhat.com>
References: <20170703211415.11283-1-jglisse@redhat.com>
 <20170703211415.11283-5-jglisse@redhat.com>
 <20170704125113.GC14727@dhcp22.suse.cz>
 <20170705143528.GB3305@redhat.com>
 <20170710082805.GD19185@dhcp22.suse.cz>
 <20170710153222.GA4964@redhat.com>
 <20170710160444.GB7071@dhcp22.suse.cz>
 <20170710162542.GB4964@redhat.com>
 <20170710163651.GD7071@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com A1BA23D956
Content-Disposition: inline
In-Reply-To: <20170710163651.GD7071@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>, David Nellans <dnellans@nvidia.com>, Dan Williams <dan.j.williams@intel.com>, Balbir Singh <bsingharora@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org

On Mon, Jul 10, 2017 at 06:36:52PM +0200, Michal Hocko wrote:
> On Mon 10-07-17 12:25:42, Jerome Glisse wrote:
> [...]
> > Bottom line is that we can always free and uncharge device memory
> > page just like any regular page.
>=20
> OK, this answers my earlier question. Then it should be feasible to
> charge this memory. There are still some things to handle. E.g. how do
> we consider this memory during oom victim selection (this is not
> accounted as an anonymous memory in get_mm_counter, right?), maybe others.
> But the primary point is that nobody pins the memory outside of the
> mapping.

At this point it is accounted as a regular page would be (anonymous, file
or share memory). I wanted mm_counters to reflect memcg but i can untie
that. Like i said at this point we are unsure how usage of such memory
will impact thing so i wanted to keep all thing as if it was regular
memory to avoid anuything to behave too much differently.

J=E9r=F4me

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
