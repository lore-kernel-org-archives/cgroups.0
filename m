From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/6] mm, memcg: Prevent memory.low load/store tearing
Date: Fri, 12 Jun 2020 19:03:52 +0200
Message-ID: <20200612170352.GA40768@blackbook>
References: <cover.1584034301.git.chris@chrisdown.name>
 <448206f44b0fa7be9dad2ca2601d2bcb2c0b7844.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <448206f44b0fa7be9dad2ca2601d2bcb2c0b7844.1584034301.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

I see suspicious asymmetry, in the current mainline:
>	WRITE_ONCE(memcg->memory.emin, effective_protection(usage, parent_usage,
>			READ_ONCE(memcg->memory.min),
>			READ_ONCE(parent->memory.emin),
>			atomic_long_read(&parent->memory.children_min_usage)));
>
>	WRITE_ONCE(memcg->memory.elow, effective_protection(usage, parent_usage,
>			memcg->memory.low, READ_ONCE(parent->memory.elow),
>			atomic_long_read(&parent->memory.children_low_usage)));

On Thu, Mar 12, 2020 at 05:33:01PM +0000, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>=
 wrote:
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aca2964ea494..c85a304fa4a1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6262,7 +6262,7 @@ enum mem_cgroup_protection mem_cgroup_protected(str=
uct mem_cgroup *root,
>  		return MEMCG_PROT_NONE;
> =20
>  	emin =3D memcg->memory.min;
> -	elow =3D memcg->memory.low;
> +	elow =3D READ_ONCE(memcg->memory.low);
> =20
>  	parent =3D parent_mem_cgroup(memcg);
>  	/* No parent means a non-hierarchical mode on v1 memcg */
> @@ -6291,7 +6291,7 @@ enum mem_cgroup_protection mem_cgroup_protected(str=
uct mem_cgroup *root,
>  	if (elow && parent_elow) {
>  		unsigned long low_usage, siblings_low_usage;
> =20
> -		low_usage =3D min(usage, memcg->memory.low);
> +		low_usage =3D min(usage, READ_ONCE(memcg->memory.low));
>  		siblings_low_usage =3D atomic_long_read(
>  			&parent->memory.children_low_usage);
Is it possible that these hunks were lost during rebase/merge?

IMHO it should apply as:

-- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6428,7 +6428,8 @@ enum mem_cgroup_protection mem_cgroup_protected(struc=
t mem_cgroup *root,
                        atomic_long_read(&parent->memory.children_min_usage=
)));

        WRITE_ONCE(memcg->memory.elow, effective_protection(usage, parent_u=
sage,
-                       memcg->memory.low, READ_ONCE(parent->memory.elow),
+                       READ_ONCE(memcg->memory.low),
+                       READ_ONCE(parent->memory.elow),
                        atomic_long_read(&parent->memory.children_low_usage=
)));

 out:


Michal

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl7jtXIACgkQia1+riC5
qSjUig//d3bjL+7mCpm6speHzN1vPZbVuEsBjl+P4DhMwGSl1iiwWP8chYdm30Xg
5l8eACsZox2Zta2TvNkqUKaYSanJ3+cY4j6vFecnJ2ADRwTG5OgKJHz4pPpTSDox
9YVzYsOzLVF/cfoOiD2GPer+YBaEMyppaqWwfzAb2XoKUmdHsY1A/nBllvbTSm6c
zbGdMqb3kt/ixm8cljE/0Wyk26QeyydHBQuU9XW1VQZniQhDWwi4tR7lfFCxMYtQ
9/PUKtgmZ+ku8YOEoc9twXbOxR8C3MZo7zZslrcVvqrF1bVOkpYAZMIMGnSLFf9Q
Mdcmbf81yPWEd/7hRO8vC8ICfBnU1nN14f1+MuXt56VWtmLnn/UqJ5sS3vqF5tgV
iBlucq9xjxMKsvoT15tNq3DX+CKL5bdqAOglSmT/XwUW1hsVycQ0spCWQ5J4K/bQ
ljahv3T9G4UgGouUwrVTZxU2+JC7YQg5BqJoC4sf0hLdFcVjdcq/aQis4b8TZLVs
36wBd/QpHGVEh1bZ5LN2AcFY+WhahNswJjM2rx2WB1S9IMhukeIe2C/PjpKnc2Zw
ff7+GBkyif/+0Xwj7N+aXSsLQ/0Xjv3kgcbOXGU0jjdoEpQxyOVtb8mAKGDRHt1D
hIr7XNHBIOUgzGC+YBl0fGDVYCWXEg45umFPdf6OTx8MCONUjQI=
=Uooi
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
