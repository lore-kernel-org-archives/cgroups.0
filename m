From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: enable accounting for pids in nested pid
 namespaces
Date: Fri, 23 Apr 2021 18:54:08 +0200
Message-ID: <YIL7sFV1Nwn4APMQ@blackbook>
References: <7b777e22-5b0d-7444-343d-92cbfae5f8b4@virtuozzo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9FS6vHwXtex6rLae"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619196850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ll6Np5J0ObgGj5/lQZXML8j8I+cP0yDeL1zSZRCohEA=;
        b=ozhwWE8+QRBR6iW6ZlJiHIe8/4RE+C/iU0wFZkU+wNFvGxnNRAxR6bJWUiODhKSLQWAPmx
        PdE1dDOB4A3wjjA2p74VW0Tn9u8Og0vRQddHy5/z/O3d730tx6DNomIh5uvhvlc3BmPXn4
        7nQCo60jcnxoctqMQVTOxPmOfMFTMzk=
Content-Disposition: inline
In-Reply-To: <7b777e22-5b0d-7444-343d-92cbfae5f8b4-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>


--9FS6vHwXtex6rLae
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 22, 2021 at 08:44:15AM +0300, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>=
 wrote:
> init_pid_ns.pid_cachep have enabled memcg accounting, though this
> setting was disabled for nested pid namespaces.
Good catch.
Cursory grep of user_namespace.c and nsproxy.c suggests it's the only
case of namespace-induced new cache.

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--9FS6vHwXtex6rLae
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmCC+60ACgkQia1+riC5
qSgs8w/+JXih+h7iyY1ihmOXwaKhPUoa861OiJLAtvBfyszsYF1uk+A9Pe0Q7HxX
epvnc1RNc2m315if7ofAcNLsOt4XTS0QnqKYp6uT/aBvCUYX6fxRhgAwHaLsorhe
6hFsCMsxlAkiPYe5o2D3wYoVpTppNwIcsz/lTwD+Wc6zpyIVG9iiyFZlns2CT7N8
saCKexLshHsnDDpvH5RgKRBDKsdJ7otZ/r9BNiSTBApZkU+W6hcw7X9Qw6xxgyOb
Ik/Df4OhVGtAyUN4wu9R35lHrCFr9zBurz27v5+xKTIJ4vx8BhWR95aHbaV7zZXS
Yx630HqfdcRMB2P1TctjuGZCF4gS04AhASAMbkOXvT6+WhJ20CK5j1YeyRDxhOAq
erZa9eZhZSlDBTwZGtQiWMsHyHChBdJfEMpC1ah6Xq96TR/aorWLWfcDP76cSgse
VK4369H6vdgad2RUMMnhs5r2k+JrLa6EeffOHiiKV6Ru7uWxI3Mx1WS1cqzZDvo5
fGSGohq7nJRf4DldOOdXiBg7yHMkbW/Nkeplvu6Ep9vbuusG/0N3pBtIpEKSJTZQ
oZ4aa8UuaFs4WgbM++LtMKD4XvAQ6WyYekxj/N3c6CWgSgOxVtbtlBVVXaa0K0/k
No9fOFqFt08TBQ2eYsWr0bZsx1Z7zzwyhNmpYUkv5lDWGCaZHkk=
=H1qH
-----END PGP SIGNATURE-----

--9FS6vHwXtex6rLae--
