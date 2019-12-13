From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/3] mm: memcontrol: fix memory.low proportional
 distribution
Date: Fri, 13 Dec 2019 20:40:31 +0000
Message-ID: <20191213204026.GA6830@localhost.localdomain>
References: <20191213192158.188939-1-hannes@cmpxchg.org>
 <20191213192158.188939-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xmhSo78XG/Xh/3Beki0lQpTIQHBa0peK1JipYU3Zz9o=;
 b=ecWral3DjDCBZbn9g66ixPrC3ajoxhAv4kOacNlPnzng346HpehKv9B7y2sYE3kA8g2q
 wnUY5gAZcsiKGWNet0QZA/0NMI2m6MyxJXwrd4UwfkhsFZr7uUvQ1P/+5DRyDnLG2+cQ
 a4PsVgu6fsbLV1T9/H/KJ5j4xF60RZgv6xI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmhSo78XG/Xh/3Beki0lQpTIQHBa0peK1JipYU3Zz9o=;
 b=ECWM3DJ2pEfZxWLuhSE09uOp8iQQu+FAHM7v9GD2PgSJ3OC/JfqwKyPKFiphVEcSFSPTIDUs5yk/xpeECMb+iDeJc8J3YhqH+kiRQYCATy9gI7YvODkwkTmvFfXOw9Y5P3VHcBSOk2ed1Bap5UomDQpXjpqsLhoFybLEJCj7kYM=
In-Reply-To: <20191213192158.188939-2-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <026E6C99126A814AA2697837C6CF363B@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Fri, Dec 13, 2019 at 02:21:56PM -0500, Johannes Weiner wrote:
> When memory.low is overcommitted - i.e. the children claim more
> protection than their shared ancestor grants them - the allowance is
> distributed in proportion to each siblings's utilized protection:
>=20
> 	low_usage =3D min(low, usage)
> 	elow =3D parent_elow * (low_usage / siblings_low_usage)
>=20
> However, siblings_low_usage is not the sum of all low_usages. It sums
> up the usages of *only those cgroups that are within their memory.low*
> That means that low_usage can be *bigger* than siblings_low_usage, and
> consequently the total protection afforded to the children can be
> bigger than what the ancestor grants the subtree.
>=20
> Consider three groups where two are in excess of their protection:
>=20
>   A/memory.low =3D 10G
>   A/A1/memory.low =3D 10G, A/memory.current =3D 20G
>   A/A2/memory.low =3D 10G, B/memory.current =3D 20G
>   A/A3/memory.low =3D 10G, C/memory.current =3D  8G
>=20
>   siblings_low_usage =3D 8G (only A3 contributes)
>   A1/elow =3D parent_elow(10G) * low_usage(20G) / siblings_low_usage(8G) =
=3D 25G
>=20
> The 25G are then capped to A1's own memory.low setting, i.e. 10G. The
> same is true for A2. And A3 would also receive 10G. The combined
> protection of A1, A2 and A3 is 30G, when A limits the tree to 10G.
>=20
> What does this mean in practice? A1 and A2 would still be in excess of
> their 10G allowance and would be reclaimed, whereas A3 would not. As
> they eventually drop below their protection setting, they would be
> counted in siblings_low_usage again and the error would right itself.
>=20
> When reclaim is applied in a binary fashion - cgroup is reclaimed when
> it's above its protection, otherwise it's skipped - this could work
> actually work out just fine - although it's not quite clear to me why
> we'd introduce this error in the first place.

This complication is not simple an error, it protects cgroups under
their low limits if there is unprotected memory.

So, here is an example:

      A      A/memory.low =3D 2G, A/memory.current =3D 4G
     / \
    B   C    B/memory.low =3D 3G  B/memory.current =3D 2G
             C/memory.low =3D 1G  C/memory.current =3D 2G

as now:

B/elow =3D 2G * 2G / 2G =3D 2G =3D=3D B/memory.current
C/elow =3D 2G * 1G / 2G =3D 1G < C/memory.current

with this fix:

B/elow =3D 2G * 2G / 3G =3D 4/3 G < B/memory.current
C/elow =3D 2G * 1G / 3G =3D 2/3 G < C/memory.current

So in other words, currently B won't be scanned at all, because
there is 1G of unprotected memory in C. With your patch both B and C
will be scanned.

> However, since
> 1bc63fb1272b ("mm, memcg: make scan aggression always exclude
> protection"), reclaim pressure is scaled to how much a cgroup is above
> its protection. As a result this calculation error unduly skews
> pressure away from A1 and A2 toward the rest of the system.

It could be that with 1bc63fb1272b the target memory distribution
will be fine. However the patch will change the memory pressure in B and C
(in the example above). Maybe it's ok, but at least it should be discussed
and documented.

>=20
> Fix this by by making siblings_low_usage the sum of all protected
> memory among siblings, including those that are in excess of their
> protection.

So I'm afraid the fix need to be more complex. I need to think a bit more a=
bout
it.

Thanks!
