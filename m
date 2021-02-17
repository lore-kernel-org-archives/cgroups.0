From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 3/8] mm: memcontrol: privatize memcg_page_state query
 functions
Date: Wed, 17 Feb 2021 18:44:20 +0100
Message-ID: <20210217174420.GD19239@blackbody.suse.cz>
References: <20210209163304.77088-1-hannes@cmpxchg.org>
 <20210209163304.77088-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613583861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EzOKje4WL0kVoheIE3+A7Z4mHaEdboezPhHAQ+ElTW8=;
        b=StyzdM+6sBl1ztWv65eULrf4hjCKFEf843Tr0IwKdnr86PqzzDohDsAOkrFN0u6pZmPXyl
        BxoFHjHrdAHJQb58+iWNedkWTYC2HI0bzfLQtfVoz6HA7EgnerKK4CuDNxKbFuuzDw7e9n
        IfWkVNFZ2KJYiJ28Z6kHSElmRXWm2Zo=
Content-Disposition: inline
In-Reply-To: <20210209163304.77088-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 11:32:59AM -0500, Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
>  include/linux/memcontrol.h | 44 --------------------------------------
>  mm/memcontrol.c            | 32 +++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 44 deletions(-)
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmAtVfQACgkQia1+riC5
qShclBAAlogxv5YghyRoLey9Ry1bJ5alDXX5JzcvBTHKgzWcUwtzv77ckze9p54r
nkerpq7ndgxFuJ5ogb5JzkwX+r1kDuidWQj/Qcpfv6T4ZkTGYJ/2nF0mjtW48o6L
Fcl+2Q9oVh0nsN0zr3MKEPj6dPxpwg1nKGuT+FzyvCEOQMOYKZsUT6bUCKMz7xzU
qAoNFNk1dusb9V/nGz+XYT1eLyRITUp+WULuhk0+ubNhOj9HcuRI5THyjcw/cXfb
+L8FHkwdoorulHgVLISahipKmUPc85OOI5GezcehnMPD+mmW6oFs71P7K8P6pGiP
3EVFbX5Dj8BjS9kp0GPYZ50QuSofw8j5YN/cW8cjW15FWes3hlnpfnH0yu5oPWys
jo79//YgNBhGka0RnWALhbr+L/nxHlLoo6FXteH0PU1nXau7QQ14exB7rqI3qalQ
fN1WrWijFDYkGv2eknVdkduSpIi+cu8NzmCIkdmaW0k6VyLBm698zkH+5wpghN6W
ypucVEuRniclM4ckftGGO5JKu1+dlyWYEiyCru+FLwAMxby4EDuYT3B8Xh+UiyCy
bsen0xV+0EPsit1OCRF41HCu8ouAqhV4BKz9aQT3SyDc2snhnpMbc2ZpVx5T2FLY
PxBk2D4Rv81JWXHO/Jcyy3YWSkuXrc7sfJ9bQj7rCwmfNt8fZ7s=
=07gk
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--
