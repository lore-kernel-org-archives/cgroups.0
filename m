From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 2/8] mm: memcontrol: kill mem_cgroup_nodeinfo()
Date: Wed, 17 Feb 2021 18:43:56 +0100
Message-ID: <20210217174356.GC19239@blackbody.suse.cz>
References: <20210209163304.77088-1-hannes@cmpxchg.org>
 <20210209163304.77088-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613583837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j/ZtgzJTS8sfYI+iyPmXaUOn6wgHJtb6JG1LGqJ8/g4=;
        b=Ord+gEArWPgdEpyPYgS/7zv9Bc8tkAltk2MtV33aIp31/wcyn5BwRCyWSD3FmpMb/OVPLG
        jMkA0fJC8S2ExwhA4NIPPTHzmtn2rCkn9z/TwTdF9tsndlbN2iJiSlTtqQaXTbzn4AAjza
        Hsdqkjba6/FIsEZ3UigYQGnmLEUoAFo=
Content-Disposition: inline
In-Reply-To: <20210209163304.77088-3-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 11:32:58AM -0500, Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
>  include/linux/memcontrol.h |  8 +-------
>  mm/memcontrol.c            | 21 +++++++++++----------
>  2 files changed, 12 insertions(+), 17 deletions(-)
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmAtVdsACgkQia1+riC5
qSgrDA/8DQBh0fmXJ72HwUwx8bkZ2TznoNUnP6REmrRLuB1A/A+ToxOJiDJSa8+G
RzXS7d5Cr7RCx3NBfSVu4MmTMoHhrRbUMoTJEPFcso5N4tbgAq1O3S4b4kbNsLEb
sh/HrxEoaU+YBil9GdJpKLj72Z7fInoA1xxZA3adf9VlYGHUI1sMZEVynXiHjs4j
ubG5GmoUzWaImyneL4yGoPhhlVuzv8KAfpMLT44ReYCW5Vc3R69f2TjZK+srySX8
9fu/uYYGvWvzPuhUjb+Z7g2Vug8nOVz4CoxFTiAlLnBDpHA4y+tPS/Jcj9Bj9vj9
EOR19riVzDYpZxJ7pGRzwDtuRilA8nIrdHWCgfCxqB5h57yupy4WlsdjNib1Jbfz
txYfZwWdcHzX+hkd8iDINV3C6R33DiBCtD8VwsEeGHhsEuB34JbzTLXNx3Hirbxp
hVzRx+ivRp1ZTD/bzk8KIzy6xuPAZeWBmVH8SmScDMyrbsd9V183uuv0jHyLHRQl
9UwaKAeQQ8n/ofZ7rSZK3h1fZ8y3PLZRssm6F+rNJwK7ZFvmyNq1zXGO/Clpi2Ns
p0/fNVTBQsfRaTiqhSaNcxBgk2Etq0eOIVG35qGtIC8aEMhZVV1VCHEwUwpJbVf7
LTxFOk2+C97r8dNGYCn/TRp/Ocf+JX2WLp3ouDH/1kq5sChSRD0=
=zbvU
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
