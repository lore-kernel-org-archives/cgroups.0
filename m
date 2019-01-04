From: Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH] fork, memcg: fix cached_stacks case
Date: Fri, 04 Jan 2019 15:14:45 -0500
Message-ID: <a8e412e9e0983b380983099af9a90b9760f0edae.camel@surriel.com>
References: <20190102180145.57406-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-12qNsl9snEwifMAZ7N/9"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190102180145.57406-1-shakeelb@google.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, stable@vger.kernel.org


--=-12qNsl9snEwifMAZ7N/9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-01-02 at 10:01 -0800, Shakeel Butt wrote:
> Commit 5eed6f1dff87 ("fork,memcg: fix crash in free_thread_stack on
> memcg charge fail") fixes a crash caused due to failed memcg charge
> of
> the kernel stack. However the fix misses the cached_stacks case which
> this patch fixes. So, the same crash can happen if the memcg charge
> of
> a cached stack is failed.
>=20
> Fixes: 5eed6f1dff87 ("fork,memcg: fix crash in free_thread_stack on
> memcg charge fail")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: <stable@vger.kernel.org>

Good catch. Thank you.

Acked-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

--=-12qNsl9snEwifMAZ7N/9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAlwvvrUACgkQznnekoTE
3oNgnAgAq6FDLf8JFXdxaI5a/OrCOHkZMEgApfIj4niwaw4iM9qXvM5krVAQ2X+r
vPFrxY7h0mcDljuUAuKxMoBbKnBVHZM72iLk/iD8T2mXT43aEtLsDYM/Nn/B6ric
uOcG+ScFutfcfOoF0B62pPFIQ/WjA9EY5Oc5yx19lRe1/tZpatwHZnOmCbQa7xvp
EGNr3C7dkz4xmgAOEv9k2+yPqgM1AstekA85rQBiQWY/8pNx+vAxOy97UKrfJa2Z
C3Ar/TgmuN2xUwCtPWNAIt4tt3tND5rtdgoczUu5duORPLPpCqlgPwQcizLq85bI
p+DF4agefINLKG1AnjiNta1jjpiACQ==
=tR4H
-----END PGP SIGNATURE-----

--=-12qNsl9snEwifMAZ7N/9--

