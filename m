From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/3] mm: memcontrol: fix memory.low proportional
 distribution
Date: Mon, 16 Dec 2019 19:11:35 +0000
Message-ID: <20191216191131.GB3760@localhost.localdomain>
References: <20191213192158.188939-1-hannes@cmpxchg.org>
 <20191213192158.188939-2-hannes@cmpxchg.org>
 <20191213204026.GA6830@localhost.localdomain>
 <20191216182518.GA209920@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DoO0l2psZNOhC8HxuixcokzTJJOPI9PvHeEkLcoSny0=;
 b=oLbpTEHFDy3rPtVaB8bd/l8p/Ewj+8vSrbjs7kHz0BTfiBos2/Xkmo6eIHpeh6v5PZ9L
 CryZT4Si7bgf9iurVaEJFW4ThZqHFBs5L1fon7QdMz8WewxHppyzRIuMiqRdHTWbabnR
 pXK3092f1wxOiCY5tIqKv0sRjCLOWMirQI0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoO0l2psZNOhC8HxuixcokzTJJOPI9PvHeEkLcoSny0=;
 b=HuysLj5lx6wk4Oocgt957LX8/cV0rnDcvkqYndPaZniVSxMHyz25VJ3pM81Tkz7+u/zxwf1Sa1IPM7iIHNcHk4mphhdz6B/WPpYNIYE+4gPqvYz6hxHPQc8wfmVeUeGwjrTlVf+2K2/7U7ZSYb6Bykido6u3KKm6LmSFi2fAvW8=
In-Reply-To: <20191216182518.GA209920@cmpxchg.org>
Content-Language: en-US
Content-ID: <080A4AC9D9F95A44A81CD56E29FE6C02@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Mon, Dec 16, 2019 at 01:25:18PM -0500, Johannes Weiner wrote:
> On Fri, Dec 13, 2019 at 08:40:31PM +0000, Roman Gushchin wrote:
> > On Fri, Dec 13, 2019 at 02:21:56PM -0500, Johannes Weiner wrote:
> > > When memory.low is overcommitted - i.e. the children claim more
> > > protection than their shared ancestor grants them - the allowance is
> > > distributed in proportion to each siblings's utilized protection:
> > >=20
> > > 	low_usage =3D min(low, usage)
> > > 	elow =3D parent_elow * (low_usage / siblings_low_usage)
> > >=20
> > > However, siblings_low_usage is not the sum of all low_usages. It sums
> > > up the usages of *only those cgroups that are within their memory.low=
*
> > > That means that low_usage can be *bigger* than siblings_low_usage, an=
d
> > > consequently the total protection afforded to the children can be
> > > bigger than what the ancestor grants the subtree.
> > >=20
> > > Consider three groups where two are in excess of their protection:
> > >=20
> > >   A/memory.low =3D 10G
> > >   A/A1/memory.low =3D 10G, A/memory.current =3D 20G
> > >   A/A2/memory.low =3D 10G, B/memory.current =3D 20G
> > >   A/A3/memory.low =3D 10G, C/memory.current =3D  8G
> > >=20
> > >   siblings_low_usage =3D 8G (only A3 contributes)
> > >   A1/elow =3D parent_elow(10G) * low_usage(20G) / siblings_low_usage(=
8G) =3D 25G
> > >=20
> > > The 25G are then capped to A1's own memory.low setting, i.e. 10G. The
> > > same is true for A2. And A3 would also receive 10G. The combined
> > > protection of A1, A2 and A3 is 30G, when A limits the tree to 10G.
> > >=20
> > > What does this mean in practice? A1 and A2 would still be in excess o=
f
> > > their 10G allowance and would be reclaimed, whereas A3 would not. As
> > > they eventually drop below their protection setting, they would be
> > > counted in siblings_low_usage again and the error would right itself.
> > >=20
> > > When reclaim is applied in a binary fashion - cgroup is reclaimed whe=
n
> > > it's above its protection, otherwise it's skipped - this could work
> > > actually work out just fine - although it's not quite clear to me why
> > > we'd introduce this error in the first place.
> >=20
> > This complication is not simple an error, it protects cgroups under
> > their low limits if there is unprotected memory.
> >=20
> > So, here is an example:
> >=20
> >       A      A/memory.low =3D 2G, A/memory.current =3D 4G
> >      / \
> >     B   C    B/memory.low =3D 3G  B/memory.current =3D 2G
> >              C/memory.low =3D 1G  C/memory.current =3D 2G
> >=20
> > as now:
> >=20
> > B/elow =3D 2G * 2G / 2G =3D 2G =3D=3D B/memory.current
> > C/elow =3D 2G * 1G / 2G =3D 1G < C/memory.current
> >=20
> > with this fix:
> >=20
> > B/elow =3D 2G * 2G / 3G =3D 4/3 G < B/memory.current
> > C/elow =3D 2G * 1G / 3G =3D 2/3 G < C/memory.current
> >=20
> > So in other words, currently B won't be scanned at all, because
> > there is 1G of unprotected memory in C. With your patch both B and C
> > will be scanned.
>=20
> Looking at the B and C numbers alone: C is bigger than what it claims
> for protection and B is smaller than what it claims for protection.
>=20
> However, A doesn't provide 4G to its children. It provides 2G to be
> distributed between the two. So how can B claim 3G and be exempted
> from reclaim?

First, what if the memory pressure comes from memory.high/max set on A?

Second, it's up to semantics we define. Looking at it from the other side:
there is clearly 1G of memory in C which is not protected no matter what.
B wants it's memory to be fully protected, but it's limited by the competit=
ion
on the parent level. Now we try to satisfy B's requirements until we can.
Should we treat B and C equally from scratch?

I think both approaches is acceptable, but if we're switching from one opti=
on
to another, let's make it clear.

>=20
> But more importantly, it isn't in either case! The end result is the
> same in both implementations. Because as soon as C is reclaimed down
> to below 1G, A is still in excess of its memory.low (because it's
> overcommitted!), and they both will be reclaimed proportionally.

I do not disagree: the introduction of the proportional reclaim
made this complication (partially?) obsolete. But originally it was
required to make target distribution correct.

>=20
> From the example in the current code:
>=20
>  * For example, if there are memcgs A, A/B, A/C, A/D and A/E:
>  *
>  *     A      A/memory.low =3D 2G, A/memory.current =3D 6G
>  *    //\\
>  *   BC  DE   B/memory.low =3D 3G  B/memory.current =3D 2G
>  *            C/memory.low =3D 1G  C/memory.current =3D 2G
>  *            D/memory.low =3D 0   D/memory.current =3D 2G
>  *            E/memory.low =3D 10G E/memory.current =3D 0
>  *
>  * and the memory pressure is applied, the following memory distribution
>  * is expected (approximately):
>  *
>  *     A/memory.current =3D 2G
>  *
>  *     B/memory.current =3D 1.3G
>  *     C/memory.current =3D 0.6G
>  *     D/memory.current =3D 0
>  *     E/memory.current =3D 0
>=20
> Even though B starts out within whatever it claims to be its
> protection, A is overcommitted and so B and C converge on their
> proportional share of the parent's allowance.
>=20
> So to go back to the example chosen above:
>=20
> >       A      A/memory.low =3D 2G, A/memory.current =3D 4G
> >      / \
> >     B   C    B/memory.low =3D 3G  B/memory.current =3D 2G
> >              C/memory.low =3D 1G  C/memory.current =3D 2G
>=20
> With either implementation we'd expect the distribution to be about
> 1.5G and 0.5G for B and C, respectively.
>=20
> And they'd have to be, too. Otherwise the semantics would be
> completely unpredictable to anyone trying to configure this.
>=20
> So I think mixing proportional distribution with absolute thresholds
> like this makes the implementation unnecessarily hard to reason
> about. It's also clearly buggy as pointed out in the changelog.
>=20
> > > However, since
> > > 1bc63fb1272b ("mm, memcg: make scan aggression always exclude
> > > protection"), reclaim pressure is scaled to how much a cgroup is abov=
e
> > > its protection. As a result this calculation error unduly skews
> > > pressure away from A1 and A2 toward the rest of the system.
> >=20
> > It could be that with 1bc63fb1272b the target memory distribution
> > will be fine. However the patch will change the memory pressure in B an=
d C
> > (in the example above). Maybe it's ok, but at least it should be discus=
sed
> > and documented.
>=20
> I'll try to improve the changelog based on this, thanks for filling in
> the original motivation. But I do think it's a change we want to make.

Absolutely, I'm not against the change. I just want to make sure we will
put all details into the changelog.

Thanks!
