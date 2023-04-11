From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH mm-unstable RFC 3/5] memcg: calculate root usage from
 global state
Date: Tue, 11 Apr 2023 14:53:20 +0200
Message-ID: <rdjvbr5zuwic27s27xcmguce2wfbqiyeu4bjr5pfxhprlxecui@4wsoogvb4ivp>
References: <20230403220337.443510-1-yosryahmed@google.com>
 <20230403220337.443510-4-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eqj63t727ravqnne"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1681217601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EkSlnfLVrBuvRIjHTj4YkNGB03MrlcmP9bduCieRg3g=;
        b=ajgGNA5WZlfmxWLIlPe/Fpt1PDYRI4impchyX4YLBiQwzNnLCAlHV9BMmxRWvfKCM5FFn3
        /u7FPMnBH9I30kLtg7c7jl5pJXsA9xlGV25vO6RWpBXBbAJdu/lpXaOrPHxT+3GRwna4T4
        F81VTw+DSswzCM0ouu3Dmz/5JqJuNLI=
Content-Disposition: inline
In-Reply-To: <20230403220337.443510-4-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org


--eqj63t727ravqnne
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 10:03:35PM +0000, Yosry Ahmed <yosryahmed@google.co=
m> wrote:
> Instead, approximate the root usage from global state. This is not 100%
> accurate, but the root usage has always been ill-defined anyway.

Technically, this approximation should be closer to truth because global
counters aren't subject to flushing "delay".

>=20
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  mm/memcontrol.c | 24 +++++-------------------
>  1 file changed, 5 insertions(+), 19 deletions(-)

But feel free to add
Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>


--eqj63t727ravqnne
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZDVYOgAKCRAkDQmsBEOq
ua0bAP9/m5FltliE3jipY2X5GBKY+6HwLMPDQ7kZw0YMt1coPwEAhI5ND5ReXLBV
+llW9zWanuFkJ28pU6DrJah5+c1hBQ8=
=0lKn
-----END PGP SIGNATURE-----

--eqj63t727ravqnne--
