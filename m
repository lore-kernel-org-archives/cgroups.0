From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] memcg v1: provide read access to memory.pressure_level
Date: Fri, 24 Mar 2023 16:03:50 +0100
Message-ID: <20230324150350.fu7itbqqvtjmyf3s@blackpad>
References: <20230322142525.162469-1-flosch@nutanix.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="giw5phpov7yliruv"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679670232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rfr8g5aJSVUWobCiA6CGIV3Ux30dV0HPukLuzQZq+hk=;
        b=UwCiahyMAVG4lGGaeiI26S5FSNGq7lKd3cTtrlRbhbaTyWMfUVFS0L7PWKD2QauBv0p/I8
        lB/cCsq1Be+SXtxVBk7V/yeSH2c5VS/0qOq4zqdmw2BI187JynDfaVlhM67l2q+WGdYnHh
        tbQhI2CEZSj5XRY2mooGLZOyrHgWw5k=
Content-Disposition: inline
In-Reply-To: <20230322142525.162469-1-flosch-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Florian Schmidt <flosch-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--giw5phpov7yliruv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Wed, Mar 22, 2023 at 02:25:25PM +0000, Florian Schmidt <flosch@nutanix.c=
om> wrote:
> cgroups v1 has a unique way of setting up memory pressure notifications:
=2E..
> There are several ways around this issue, but adding a dummy read
> handler seems like the least invasive to me. I'd be interested to hear:
> (a) do you think there is a less invasive way? Alternatively, we could
>     add a flag in cftype in include/linux/cgroup-defs.h, but that seems
>     more invasive for what is a legacy interface.

You can (as privileged user) modify file perms in userspace first (e.g.
chmod o+r memory.pressure_level) and then it can used by non-privileged
users. (Or do LSM prevent you from that too?)

> (b) would you be interested to take this patch, or is it too niche a fix
>     for a legacy subsystem?

I'd rather not extend this "unique way" with additionally unique dummy
helpers.

My 0.02 =E2=82=AC,
Michal

--giw5phpov7yliruv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZB271AAKCRAkDQmsBEOq
uaftAP9jAb8MRvyOlJlzSiA/74Dm588NNIhwB30zeAvi2Gy2DQD8Du97muUPss8S
XDdnabKXH1krN1zbPtFwqMvvCx5e6wI=
=7Q79
-----END PGP SIGNATURE-----

--giw5phpov7yliruv--
