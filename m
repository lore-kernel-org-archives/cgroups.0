From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH v3 8/8] memcg: do not modify rstat tree for zero updates
Date: Tue, 4 Apr 2023 18:53:14 +0200
Message-ID: <20230404165314.swb7bide2mkjap3p@blackpad>
References: <20230330191801.1967435-1-yosryahmed@google.com>
 <20230330191801.1967435-9-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v5h2bvm4dmip3h3q"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680627195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HsMVP1Gx6bqzvFmi3XkM83yTiX2CMmFn0tLAqTXnpkI=;
        b=btRPMMcl2b2uFZz5YK+tZE32E88Ja+m/EkIvXmlf/VcbcyPt8UXBCI+1HfaQcy83X/zun0
        q8RT3lcBoIJDjqhQN0pXO17r2yZOR2oRKUkxYGi1adL3BezoX5ydpiXRqzkCA18uWnHeQF
        XP2lmbvyGFA9b3jQoIJi4gEXoZ7IQ7M=
Content-Disposition: inline
In-Reply-To: <20230330191801.1967435-9-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>


--v5h2bvm4dmip3h3q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 30, 2023 at 07:18:01PM +0000, Yosry Ahmed <yosryahmed@google.co=
m> wrote:
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--v5h2bvm4dmip3h3q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCxV9QAKCRAkDQmsBEOq
uYK9AP0WJYtFSeSrHica60KBnkpC0zuL6ZB9oq/HdqUH8N7N9gEAxT/BKJqjFEX1
f8Ij/Sc8okkrXt+NvEbGkgBVVJnCNAA=
=86rE
-----END PGP SIGNATURE-----

--v5h2bvm4dmip3h3q--
