From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: vmscan: fix IO/refault regression in cache
 workingset transition
Date: Wed, 05 Apr 2017 18:11:04 -0400
Message-ID: <1491430264.16856.43.camel@redhat.com>
References: <20170404220052.27593-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZVQRuuSzGMtMeuKPGMPj"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 334F73DBCB
In-Reply-To: <20170404220052.27593-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


--=-ZVQRuuSzGMtMeuKPGMPj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-04-04 at 18:00 -0400, Johannes Weiner wrote:

> +
> +	/*
> +	=C2=A0* When refaults are being observed, it means a new
> workingset
> +	=C2=A0* is being established. Disable active list protection to
> get
> +	=C2=A0* rid of the stale workingset quickly.
> +	=C2=A0*/

This looks a little aggressive. What is this
expected to do when you have multiple workloads
sharing the same LRU, and one of the workloads
is doing refaults, while the other workload is
continuing to use the same working set as before?

I have been trying to wrap my mind around that for
the past day or so, and figure I should just ask
the question :)

> +	if (file && actual_reclaim && lruvec->refaults !=3D refaults)
> {
> +		inactive_ratio =3D 0;
> +	} else {
> +		gb =3D (inactive + active) >> (30 - PAGE_SHIFT);
> +		if (gb)
> +			inactive_ratio =3D int_sqrt(10 * gb);
> +		else
> +			inactive_ratio =3D 1;
> +	}

--=20
All rights reversed

--=-ZVQRuuSzGMtMeuKPGMPj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJY5Wt4AAoJEM553pKExN6DwZEH/3vYvvFtryLqCOy63GZcK9lS
ytfChfTSDqflsX9lIj06z1LVyQZbeDHO/NcKV8iQa7g2XKYq21piJEm4yfGfR9fT
bn0kyKZUhxYB7z8U4qV4mBG5gle2u1O5jxX83c2LGFf4FhueLpJdRZJtXBPb/aBR
ojSd+qAF/iVaFrjDlt21eEa0PB5K6QAKHZ2NrA+jGNHeWUVxh1mJUhrIVep+8kfj
/4WendQKIZNy5tMzvQWA4mxiV04+gpRMH/4DkKgBzpepCRC3jzKmc8QZi4DYmK1m
3vBJ+Gy3W6M9gKlnFJvFcBlnrynX3ChhKtLpsb1hszKgw43Y/5lHbWCJLB0arfw=
=qtdw
-----END PGP SIGNATURE-----

--=-ZVQRuuSzGMtMeuKPGMPj--
