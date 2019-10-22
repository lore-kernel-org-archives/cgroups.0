From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 5/8] mm: vmscan: replace shrink_node() loop with a retry
 jump
Date: Tue, 22 Oct 2019 22:46:57 +0000
Message-ID: <20191022224652.GA22777@tower.DHCP.thefacebook.com>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-6-hannes@cmpxchg.org>
 <20191022195629.GA24142@tower.DHCP.thefacebook.com>
 <20191022214249.GB361040@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WbsnqqUSzdFKRHlzwTEhlV4yqA2I4HU8EJNeRCKLVGU=;
 b=FNd7529pP+8Vc55F/Q9t/i876mWGMjannldvKhoVy5c+gRwDnHRemZerooy91prT3/d8
 AoYn98kCsuoRkoixPldSYEmE80SZu63wKeMLZ3b+BZiKEBWeZ/zRTnXocy8Lj76vwFd/
 Zfcdd7HyUaz0vN2dJKA91sKyFzVEb7QWFjE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbsnqqUSzdFKRHlzwTEhlV4yqA2I4HU8EJNeRCKLVGU=;
 b=f8Th9P1EuAhNG9oni7Tkov9s0ECYlNmlHDL4GFIivrcAUJcrxSo0RYHeMpDmJv6i6sFMBe0f7QVOdjCbVUMXcQAAH+oFHziBKv303otj5im4zpl0iMOq4sZOSkR+Fd66mbYFcrgqk8/llk9Sy1WgO4XZJeSDn++rhe84L7eIM0o=
In-Reply-To: <20191022214249.GB361040@cmpxchg.org>
Content-Language: en-US
Content-ID: <55484D1ED615434F824251448E8DE299@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 05:42:49PM -0400, Johannes Weiner wrote:
> On Tue, Oct 22, 2019 at 07:56:33PM +0000, Roman Gushchin wrote:
> > On Tue, Oct 22, 2019 at 10:48:00AM -0400, Johannes Weiner wrote:
> > > -			/* Record the group's reclaim efficiency */
> > > -			vmpressure(sc->gfp_mask, memcg, false,
> > > -				   sc->nr_scanned - scanned,
> > > -				   sc->nr_reclaimed - reclaimed);
> > > -
> > > -		} while ((memcg =3D mem_cgroup_iter(root, memcg, NULL)));
> > > +		reclaimed =3D sc->nr_reclaimed;
> > > +		scanned =3D sc->nr_scanned;
> > > +		shrink_node_memcg(pgdat, memcg, sc);
> > > =20
> > > -		if (reclaim_state) {
> > > -			sc->nr_reclaimed +=3D reclaim_state->reclaimed_slab;
> > > -			reclaim_state->reclaimed_slab =3D 0;
> > > -		}
> > > +		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
> > > +			    sc->priority);
> > > =20
> > > -		/* Record the subtree's reclaim efficiency */
> > > -		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> > > -			   sc->nr_scanned - nr_scanned,
> > > -			   sc->nr_reclaimed - nr_reclaimed);
> > > +		/* Record the group's reclaim efficiency */
> > > +		vmpressure(sc->gfp_mask, memcg, false,
> > > +			   sc->nr_scanned - scanned,
> > > +			   sc->nr_reclaimed - reclaimed);
> >=20
> > It doesn't look as a trivial change. I'd add some comments to the commi=
t message
> > why it's safe to do.
>=20
> It's an equivalent change - it's just really misleading because the
> +++ lines are not the counter-part of the --- lines here!
>=20
> There are two vmpressure calls in this function: one against the
> individual cgroups, and one against the tree. The diff puts them
> adjacent here, but the counter-part for the --- lines is here:
>=20
> > > +	/* Record the subtree's reclaim efficiency */
> > > +	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> > > +		   sc->nr_scanned - nr_scanned,
> > > +		   sc->nr_reclaimed - nr_reclaimed);
>=20
> And the counter-part to the +++ lines is further up (beginning of the
> quoted diff).
>=20

Ah, ok, got it. You were right in the foreword, indentation change
diffs are hard to read.

Thanks for the explanation!

Reviewed-by: Roman Gushchin <guro@fb.com>
