From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] mm: memcontrol: Make the walk_page_range() limit obvious
Date: Thu, 1 Sep 2016 00:24:39 +0000
Message-ID: <20160901002438.GB9620@hori1.linux.bs1.fc.nec.co.jp>
References: <1472655897-22532-1-git-send-email-james.morse@arm.com>
 <20160831151730.GF21661@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160831151730.GF21661@dhcp22.suse.cz>
Content-Language: ja-JP
Content-ID: <04683ED2C346F642AE6658F0EAE1963D@gisp.nec.co.jp>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: James Morse <james.morse@arm.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov@virtuozzo.com>

On Wed, Aug 31, 2016 at 05:17:30PM +0200, Michal Hocko wrote:
> On Wed 31-08-16 16:04:57, James Morse wrote:
> > Trying to walk all of virtual memory requires architecture specific
> > knowledge. On x86_64, addresses must be sign extended from bit 48,
> > whereas on arm64 the top VA_BITS of address space have their own set
> > of page tables.
> >=20
> > mem_cgroup_count_precharge() and mem_cgroup_move_charge() both call
> > walk_page_range() on the range 0 to ~0UL, neither provide a pte_hole
> > callback, which causes the current implementation to skip non-vma regio=
ns.
> >=20
> > As this call only expects to walk user address space, make it walk
> > 0 to  'highest_vm_end'.
> >=20
> > Signed-off-by: James Morse <james.morse@arm.com>
> > Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > ---
> > This is in preparation for a RFC series that allows walk_page_range() t=
o
> > walk kernel page tables too.
>=20
> OK, so do I get it right that this is only needed with that change?
> Because AFAICS walk_page_range will be bound to the last vma->vm_end
> right now.

I think this is correct, find_vma() in walk_page_range() does that.

> If this is the case this should be mentioned in the changelog
> because the above might confuse somebody to think this is a bug fix.
>=20
> Other than that this seams reasonable to me.

I'm fine with this change.

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
