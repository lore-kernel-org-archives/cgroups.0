From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/5] mm: page_owner: add support for splitting to any
 order in split page_owner.
Date: Fri, 24 Mar 2023 16:17:17 +0100
Message-ID: <20230324151717.hawuy5gs6cnxql55@blackpad>
References: <20230321004829.2012847-1-zi.yan@sent.com>
 <20230321004829.2012847-3-zi.yan@sent.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="exvxtogrhnfaw26c"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679671038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bwervvL2VqoJp7Lysjwx0FFEhlsKTjSqVYYrPqe2D7Q=;
        b=TgmwsbLl+DA5Nt70AmZzlhUhFnz2I8NZtHoXA9KZt0n0xrFCGQ/YcA+FBZzx5Gd9YKiOCI
        bHaGK3KdSJtjWhbFYpt8xp9g3zTgsEdqgjVpEmsD/3IKuaTKEB23gX1Z7Zdt3DkXUwoRe5
        7mksq3ezMiaJva+j+TCZ+oYN/uUqCH0=
Content-Disposition: inline
In-Reply-To: <20230321004829.2012847-3-zi.yan-vRdzynncJC4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--exvxtogrhnfaw26c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Mon, Mar 20, 2023 at 08:48:26PM -0400, Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org> wrote:
> @@ -5746,8 +5746,8 @@ static void *make_alloc_exact(unsigned long addr, u=
nsigned int order,
>  		struct page *page =3D virt_to_page((void *)addr);
>  		struct page *last =3D page + nr;
> =20
> -		split_page_owner(page, 1 << order);
> -		split_page_memcg(page, 1 << order);
> +		split_page_owner(page, 1 << order, 1);
> +		split_page_memcg(page, 1 << order, 1);

I think here should be

> +		split_page_owner(page, order, 0);
> +		split_page_memcg(page, 1 << order, 1);

because I was wondering why split_page_memcg() doesn't use orders too?
(E.g. it wouldn't work well if nr % new_new !=3D 0).

Thanks,
Michal

--exvxtogrhnfaw26c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZB2++wAKCRAkDQmsBEOq
uZYWAQCFTMigwoG6hG2bxKjAJtYDo8OWh0BZq1aPs9LM+QVdBwEAvayit0OXGxQ2
MDrtNVNB0nXobbi8EK0m4EAaSr9tCQA=
=FNxP
-----END PGP SIGNATURE-----

--exvxtogrhnfaw26c--
