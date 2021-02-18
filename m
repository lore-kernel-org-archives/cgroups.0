From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 4/8] cgroup: rstat: support cgroup1
Date: Thu, 18 Feb 2021 16:45:11 +0100
Message-ID: <YC6Lh8BRfMA2Ppdk@blackbook>
References: <20210209163304.77088-1-hannes@cmpxchg.org>
 <20210209163304.77088-5-hannes@cmpxchg.org>
 <20210217174232.GA19239@blackbody.suse.cz>
 <YC2CKyaeF2bqvpMk@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xS+is/W892RytHV4"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613663113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kndRiznQhLZKdWjvHBON40ykfoLHDXlmWt2IkZM5PBU=;
        b=c/Ju6GZd7mODmFOw0RU+s3Te8Rj6FISqx3vLAeSpNv+lm8vJob7on1EyKZCeD86O5KSxzW
        B5wEAEdwPrXvyqEfYIg2Wgaug4Q3XAByoUNxJ7AZsk+bfOKK8GorHWXhGXQMDv5p9QMlNK
        JsjZGrpqYhvgKCMZjE/nCTSfaAkF2lY=
Content-Disposition: inline
In-Reply-To: <YC2CKyaeF2bqvpMk-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


--xS+is/W892RytHV4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 17, 2021 at 03:52:59PM -0500, Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> It's possible, but I don't think worth the trouble.
You're right. I gave it a deeper look and what would be saved on data,
would be paid in code complexity.

> In this case, we're talking about a relatively small data structure
> and the overhead is per mountpoint.
IIUC, it is per each mountpoint's number of cgroups. But I still accept
the argument above. Furthermore, this can be changed later.

> The default root group has statically preallocated percpu data before
> and after this patch. See cgroup.c:
I stand corrected, the comment is still valid.

Therefore,
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--xS+is/W892RytHV4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmAui4cACgkQia1+riC5
qSiJ4w/8DUxQueOw6E/q3wd6I9lRyh4brtboIOu0xAz+2INf5BsbykFQJEEIoAA+
nsM+ICp+et0ABUMFGA34a3+vX0dOb2IkF84foWIIqnR683/gjF+tiQJrmbZBztBP
R5MnPRKG/R2JtJer/q4SFDGtBblFUr78Y56k7mO2lbXCeHvkAJLMit6VfQZAmS6R
BWbTTWJQov5DWTA0gtfWM5vXIe0sFkiJKz2oi6xHiKBIuUrISGGrpMzlxOP0abpU
Gm1/IVaspHWJ0LB6XFjU0KnjpW1WJVQKEmg5pecEL5M5V01Bc0sA+s2F/XDq/beZ
8MUdVgw+le4omSkvi3rjpX5Pk006SEJfOYpB+/m9fRA23yC1zYLLPvoimHHGS7Ir
QMLkVfozsOWqMpTSdWO9eKIFFt1FL7S4kaR5cWxI4gbvJDR89t9Q6do16+jP4FGM
mWb47ipEwi/52Ib6YxYosV9MIqpSpfa6bQYkCHdj4mRoot+HwfWthOnV3PKUaGzT
XWJVh9UWac6rydWCi5j0L865dZrDMeGT8xYmOx1Dm7AfrDyNXpJGoTb+n4rn+nw9
lGETsYGzcIhRDU2vILI5MaROqjfn2ZU1bIKQRUCmhpYqF5Fa3Ejglzdy2MM/hfd3
SIx50o61u3w6k10SzaS3mjPu6ROBhtLTXhU2e+pmfY84qJLRdW0=
=H1Nj
-----END PGP SIGNATURE-----

--xS+is/W892RytHV4--
