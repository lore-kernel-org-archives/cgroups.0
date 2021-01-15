From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Fri, 15 Jan 2021 11:08:55 +0100
Message-ID: <YAFpt6aYW4nVQoZf@blackbook>
References: <20201218061755.121205-1-chenzhou10@huawei.com>
 <YABDWvI2PWQpnv59@blackbook>
 <d4ba14b0-ee06-b793-a840-2c2ff369d890@huawei.com>
 <YAB3Wuu+hFpN698N@blackbook>
 <7804658e-7644-8edb-5ca8-0c97389c8c62@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aW+Hjh85VlI7M/Bn"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610705337; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Faumz9gT2pY3vY0mqp7ThUzNaq8hQ/0YmK2KtYGiqU=;
        b=PikZd6Loq/f4lJ+0IwfPS4ziRz35aVE9uvjHZIwv3nfwj4vHIdyBtSUTm6roFQZCfNII9N
        hAx4VOnTH24PH3u6SUQTuEqb4uhDFA/h43axBKJ4eX3JsSJgPEP7DeB8NvzK6zuADoKoQv
        8480w8AivaghOJFUj+u26EGpztI/4vg=
Content-Disposition: inline
In-Reply-To: <7804658e-7644-8edb-5ca8-0c97389c8c62-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--aW+Hjh85VlI7M/Bn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 15, 2021 at 09:55:43AM +0800, chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> =
wrote:
> Yeah, this will select all enabled controllers, but which doesn't the beh=
avior we want.
I see what the issue is now.

> See above. Just the mount behavior isn't what we what.
I agree this a bug and your I find your approach correct

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

> The behavior was changed since commit f5dfb5315d34 ("cgroup: take
> options parsing into ->parse_monolithic()"), will add this as Fixes.
Thanks.

Michal

--aW+Hjh85VlI7M/Bn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmABabMACgkQia1+riC5
qSgNFg/9HhaSDxHBhPH86Pcz71+vllYTelnF1P8Bgbquc6o7w6cFhAsmQh9LpwpI
zHp+FSSxSzkdW7kjQpQpVPnmyUVvroFYqkLl2htJQMF8F6DfR1XlqtR47xOfqbDL
54slEHktuATW7SxwGu6P8wAE/Orq3gelNarEaW2I+nH3bg0SAUkdj6ThhbwZF9Tk
1Fd5AttK8/727Gw67YBl13CN8EYol8AfG+qC1SRtdtTSrk50EF9mLZy8PtlyYyyl
CYSetNahCaKaoYzBjl0UJQ8d3CPt8LAxyEMgjW/oieD7rYDyLffaqh7GcfXbFVpt
yBCIG4CWGlyDDqdJbXUA645nvXGUDGOB6K0cOTUBZlMPmHB/g0QJi6Mr7bMJ6XuN
gg5dhMcLLAbIoZfUmMsCjUOr+r5hShnId2L+0XLuzgFA6wYR2oV/2EAfmjXPKcGF
nznrKyYld8okjzYe/3SAwq5VJ/P71rwjIbHAxB/aVWpL0Kr7WQl0ygoknm4Lsx3r
zy9vMomoF1PibdROuX7Cuv1CDkullQsInTS4B33Wh8dtQjJRcZH8Kdkz2QwyXww3
IBQ+dYPV9ZSEAfRk1WRT4bGXmV4dLJIUWNuhwCTYkVG2KqKD7BiUfLGfDuzm3syR
BkXq0TXboV8LDaLliErZqwQcQJU9RjSz9UiPgHMXSmE/bKFk5QM=
=I1mY
-----END PGP SIGNATURE-----

--aW+Hjh85VlI7M/Bn--
