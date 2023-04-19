From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH mm-unstable RFC 2/5] memcg: flush stats non-atomically in
 mem_cgroup_wb_stats()
Date: Wed, 19 Apr 2023 13:44:39 +0200
Message-ID: <cqc5gdh4yfh3m3inpm455rgsd55hh543biogpoip6mufr6axh5@z5w6rljgvvpb>
References: <20230403220337.443510-1-yosryahmed@google.com>
 <20230403220337.443510-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4c7lxtjmc74hxkg5"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1681904681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0zDQDkGE+9vuGnAAMyp+Znl0fdBKE7XNVtwBU2+M3G8=;
        b=L1c1XBQWg0zfnc1ZlLr5NC2ZiL4OhHV8ZPPfGePt2lWqMqOCK7PpdvtAzWjM1IVSJ97UKS
        Ow/DimNzfFpB3GccFVDp/mCqgwckdUZZOTZXxYoO7o+ihnvHX1hWCrLjJCl3kipob72hGB
        tpDNhcDAMCvOMANT0sPJo0dIDzJIJmQ=
Content-Disposition: inline
In-Reply-To: <20230403220337.443510-3-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org


--4c7lxtjmc74hxkg5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 10:03:34PM +0000, Yosry Ahmed <yosryahmed@google.co=
m> wrote:
>  mm/memcontrol.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--4c7lxtjmc74hxkg5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZD/UIwAKCRAkDQmsBEOq
ubusAQDpyzbgmh2mOJdPSwZsaNGY368cPzgmuzn5NvkS1ukAewD+NuwrN3Kx3JM9
MfK4fKoWXWwu5X0+LDN+fUY8dakRawo=
=ztJP
-----END PGP SIGNATURE-----

--4c7lxtjmc74hxkg5--
