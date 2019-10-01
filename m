From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH RFC v4 02/16] cgroup: Introduce cgroup for drm subsystem
Date: Tue, 1 Oct 2019 16:31:06 +0200
Message-ID: <20191001143106.GA4749@blackbody.suse.cz>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-3-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2072972227=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190829060533.32315-3-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Cc: daniel-/w4YWyX8dFk@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org


--===============2072972227==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi.

On Thu, Aug 29, 2019 at 02:05:19AM -0400, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org> wrote:
> +struct cgroup_subsys drm_cgrp_subsys = {
> +	.css_alloc	= drmcg_css_alloc,
> +	.css_free	= drmcg_css_free,
> +	.early_init	= false,
> +	.legacy_cftypes	= files,
Do you really want to expose the DRM controller on v1 hierarchies (where
threads of one process can be in different cgroups, or children cgroups
compete with their parents)?

> +	.dfl_cftypes	= files,
> +};

Just asking,
Michal

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl2TYykACgkQia1+riC5
qSiNOhAAj+V8JbkviYhAkKfW2XIQz6L02LM+3vfiRHzZZJhcqdSs+4WB6xhmjKme
aG0SzH8NOiWzLpq+XPq4iW4G6v7QNjQcniUtb0kBiGvFfWpczCaFs9K0hyeUKCu0
2Xn/VIVvMqkPWDgirANCa/Dgsc5JMpsGY5A+E44aiPyqO/6UrQSDYXmvqu7132yx
L/4UtNJpH2SFnGJ7l0n1Gspe8W50WkKEscmLh3jlWcPFqUNY3JpdZ6rJ+LniGVck
xdEGSGbGnoZmfkg+lCLTnVU8p8fPUHh6Z8ZRoUey9d63+XCNvNqpWLfTp72kgIRr
48XrUaUKu49DO081Qehg4hLFb6uayHfoXMDHR/URLStF3AdPF3XZ/pStA3A0owp8
HztqK6hn/BfZuDSMZ5Vvtfqkqqjq68EmMdZ0TI4Ab/9dY5RMthv8ADVbKE58vC8K
KF4jbEKJFUGNWUpSVuX2BJOE9rTOk64MqSUmJs2KDKTZnwLeuOlHoUYUH1YLHxsj
6SEZZ6+3hiHMGQYAFz6bxSvzF/abDe/O9tW/MnOQT3VkxHBSWnMyC3j0KRlgUJ/j
HnWawWW4SPRkhykkzBxpp2Qs4YY29JqiExVfmFxQlt46MgnqH4V9DteH0H7EI0MY
eUvqey3L9y3hBv1B8Z9XjOix4HwxFpK4HZH8SrQArcyeThtNnuE=
=je6w
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--

--===============2072972227==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBt
YWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4

--===============2072972227==--
