From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: Prevent inode/dentry trashing?
Date: Fri, 25 Jun 2021 17:55:22 +0200
Message-ID: <YNX8anv2yCnkVPXy@blackbook>
References: <ce330972-78e6-4347-9735-72ee7bb21ef5@pmhahn.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GRfnHW8roRpdCmLl"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624636524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1HmjupcRz3JaQfNq8HfL9gsd0zczzHm8Vkl0SLmvU3I=;
        b=Cfo47BpXwTuQyIkermF36Mz6Go/NxmItV2XTmAuUvXXYB2AQwW4PPZ53ShpoAhVlOH+pJO
        PEQFOPS4ryan0JBVlJl8uw02JGPeJmiXZefue/JSb2Tc2/nuqrY+39WqrmInIsgdcDmrw6
        ittbSCEihOI1rEfSTJWdZMFeDCQgbiU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624636524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1HmjupcRz3JaQfNq8HfL9gsd0zczzHm8Vkl0SLmvU3I=;
        b=Cfo47BpXwTuQyIkermF36Mz6Go/NxmItV2XTmAuUvXXYB2AQwW4PPZ53ShpoAhVlOH+pJO
        PEQFOPS4ryan0JBVlJl8uw02JGPeJmiXZefue/JSb2Tc2/nuqrY+39WqrmInIsgdcDmrw6
        ittbSCEihOI1rEfSTJWdZMFeDCQgbiU=
Content-Disposition: inline
In-Reply-To: <ce330972-78e6-4347-9735-72ee7bb21ef5-isSyJ6YaLy+zQB+pC5nmwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Philipp Hahn <pmhahn+lkml-isSyJ6YaLy+zQB+pC5nmwQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--GRfnHW8roRpdCmLl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Phillip.

On Mon, Jun 07, 2021 at 02:39:35PM +0200, Philipp Hahn <pmhahn+lkml@pmhahn.=
de> wrote:
> The trashed caches affect all other processes running in parallel or the
> first processes started each morning.
>=20
> Is it possible to prevent inode/dentry trashing for example by limiting t=
he
> cache per process(-group)?

Yes. Unless you have disabled it with CONFIG_MEMCG_KMEM or
cgroup.memory=3Dnokmem, dentries and inodes are charged to respective
cgroups. And you can limit overall memory of a cgroup, see
memory.{max,high} attributes. (You suggest this inode/dentry consumption
is dominant enough to affect other jobs, so the limit would keep it
constrained as you intend).

HTH,
Michal

--GRfnHW8roRpdCmLl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmDV/GQACgkQia1+riC5
qShfZA//ZacjmyfT7nNWjlUA6bEyGPVXkjxHZedOUfWqCr2SGXbwd57ND+ROHSwA
EbSVYP3TaN7+BJBPrL3y8NjnKFaRJsLosiRiKsA6VWS9pibmgVKzSiW5H5aS03/S
nl6GDIp0mt8sg2DDjn/raS+AopLt/iD7awWIT8LAugfs2h4AueUZ/kC01Cmzja7F
5F5C2vG1T8pKinSMow3OCtZVMmMl18U+JEFiNWKqrQkMlAHu6GlwUTIEtEc6X4hS
h/GKJ/xplD/avp1rjJSr+FUFZG4+jPTnQu0LqUdwR80VEO9gdiSvavJCARCjbKvb
54qPhiPtovHk9UfZJe8fcN807cdYNrWNHY0n6/Z2M/28oq6gF81Ra7Ig4/3I2DfU
qT6+vXrvjF7ZEO9y8okJiGfdpYInlsJbNIQvkjaL156Uz70HLosGFsg5NAnYY0Mc
9HJXhnIQCRke4O/JccAAftxdmDoPVDmJvl7QMMD7D2AoGVEALv8XTzdxpequUK/q
PFW4qoelNaEx2NNs01Wzr76fphdav5zWn1+ctdGRbKCyAAv2ZMTLwNut4p1K58gg
CZpYLN6S8fioX45P4uRaO6VTbWf+o5W+URJM06n/o94ha+cRlIU7uonqb3gx0eU2
ucM216qE2TT/NdqAqfE3sWAKaM1BhA8HNNpMsiZgwGEbOIUFdRE=
=I/eJ
-----END PGP SIGNATURE-----

--GRfnHW8roRpdCmLl--
