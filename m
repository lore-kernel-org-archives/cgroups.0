From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH RFC v4 07/16] drm, cgroup: Add total GEM buffer
 allocation limit
Date: Tue, 1 Oct 2019 16:30:01 +0200
Message-ID: <20191001142957.GK6694@blackbody.suse.cz>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-8-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0246902590=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190829060533.32315-8-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
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


--===============0246902590==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Pz0BBB9QxoYXlT+x"
Content-Disposition: inline


--Pz0BBB9QxoYXlT+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Thu, Aug 29, 2019 at 02:05:24AM -0400, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org> wrote:
> drm.buffer.default
>         A read-only flat-keyed file which exists on the root cgroup.
>         Each entry is keyed by the drm device's major:minor.
>=20
>         Default limits on the total GEM buffer allocation in bytes.
What is the purpose of this attribute (and alikes for other resources)?
I can't see it being set differently but S64_MAX in
drmcg_device_early_init.

> +static ssize_t drmcg_limit_write(struct kernfs_open_file *of, char *buf,
> [...]
> +		switch (type) {
> +		case DRMCG_TYPE_BO_TOTAL:
> +			p_max =3D parent =3D=3D NULL ? S64_MAX :
> +				parent->dev_resources[minor]->
> +				bo_limits_total_allocated;
> +
> +			rc =3D drmcg_process_limit_s64_val(sattr, true,
> +				props->bo_limits_total_allocated_default,
> +				p_max,
> +				&val);
IIUC, this allows initiating the particular limit value based either on
parent or the default per-device value. This is alas rather an
antipattern. The most stringent limit on the path from a cgroup to the
root should be applied at the charging time. However, the child should
not inherit the verbatim value from the parent (may race with parent and
it won't be updated upon parent change).
You already do the appropriate hierarchical check in
drmcg_try_chb_bo_alloc, so the parent propagation could be simply
dropped if I'm not mistaken.


Also, I can't find how the read of
parent->dev_resources[minor]->bo_limits_total_allocated and its
concurrent update are synchronized (i.e. someone writing
buffer.total.max for parent and child in parallel). (It may just my
oversight.)

I'm posting this to the buffer knobs patch but similar applies to lgpu
resource controls as well.

HTH,
Michal

--Pz0BBB9QxoYXlT+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl2TYt0ACgkQia1+riC5
qSgMsg/+KPKKABKL0I3Bt7ronW4ukeFfC/GBQsoVxzJYUUyBtdoFPUYXnEOcJ78L
TyDn6DOND9RB4Fy7UQueB1HVPc/hjrWTmDBZhfdRsq6bFhfO3IVFPxp10uyYNBm4
WYocCUsQQ3IZEFLDZj+3RQGEEtZWSktulpSiwxfWLHpD995LJMpNo1UtESu+U4Dq
Riv1NlgC+mCdOAhlNOQDF53VIPwqSgqKcv4qVR39hwhHgr/K8v3EkFrWfu3nd7tp
J8lHhxTG4F71wMH1/TYGetwYoYB6IraeGJB0fZjWsLqSEtl3HcQFQ07XsVP7g0XA
Xn7StiFOmuXFgCI6Vb0zpTdAUKR3jP1JoElBnWxT3J74Eze11rN0PjtvjzYU/UaW
wffTxB8Cj8AA4rZ9uyA/5zgPqmqyV2a8o0XAApli+fHvox0FWLLTU8nk5sXXCzhq
Drg5cYsNRcxMcebdoHeXZcDpkRQlYJ1/5GVpcH6nFkdasTO/ZrFrXnEOZCQgfJJJ
7d4zyQ/GPRfNXP+rqTtPmZxjMSGk0ZBxi35CqOQYQBzWn5jVkaj1JcP6/YLLHUEB
g1aHg0RRlxefABKqSIEoOv/LSveXSuJ3WUsnV2JWJ/fUaORS0uzJUnlVs44UcwV7
5tb24JpOk2VKyvtwvoGeSRD1T9jR+ab+vnuzZGxONbJfznl2+KY=
=RuK8
-----END PGP SIGNATURE-----

--Pz0BBB9QxoYXlT+x--

--===============0246902590==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBt
YWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4

--===============0246902590==--
