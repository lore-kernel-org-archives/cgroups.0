From: Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH] mm: memcontrol: fix NR_WRITEBACK leak in memcg and
 system stats
Date: Sat, 03 Feb 2018 13:23:08 -0500
Message-ID: <1517682188.31954.57.camel@surriel.com>
References: <20180203082353.17284-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-uD5WZE9zfQrUF8OJBowJ"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20180203082353.17284-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com


--=-uD5WZE9zfQrUF8OJBowJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2018-02-03 at 03:23 -0500, Johannes Weiner wrote:
>=20
> This patch makes the joint stat and event API irq safe.
>=20
> Fixes: a983b5ebee57 ("mm: memcontrol: fix excessive complexity in
> memory.stat reporting")
> Debugged-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>=20
Reviewed-by: Rik van Riel <riel@surriel.com>
--=20
All Rights Reversed.
--=-uD5WZE9zfQrUF8OJBowJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEyBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAlp1/gwACgkQznnekoTE
3oNBXQf3XPmSj1hhxNPGUqxVvwfXEaAbX5U2msBACnXF6xBia9BgwXPh2Zti1L1x
7O1Qc/pJSKSrkMkHOv1aLuTKPwVZtQR2ulOrPBSpLzdL7JrToPI64HsR2TsMvP8y
J8W334x0fbItbZUx8At1+t6fXRNs6QkiDEy1yYv8RjqUlSybA2rqeoKEqwsFwnDS
JP1GHoWZTF+TfcvkEEk7baDDaO90liqpufIUyZXTcR4f0rlmPaXdz8lQNacypbQZ
x7DAW1mr9LqsQUnecD1V3TAMncwb39Vsuy2RRDE+pyKYsIUORcnsG9nc9KJ/KNDG
14NZ273Erz5+stw/E2bCerB7wseu
=z9Fg
-----END PGP SIGNATURE-----

--=-uD5WZE9zfQrUF8OJBowJ--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
