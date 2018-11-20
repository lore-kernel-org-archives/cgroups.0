From: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH RFC 5/5] drm/amdgpu: Add accounting of buffer object
 creation request via DRM cgroup
Date: Tue, 20 Nov 2018 12:56:05 -0800
Message-ID: <87tvkb79ju.fsf@anholt.net>
References: <20181120185814.13362-1-Kenny.Ho@amd.com>
 <20181120185814.13362-6-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1375956667=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20181120185814.13362-6-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
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
To: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org

--===============1375956667==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org> writes:

> Account for the total size of buffer object requested to amdgpu by
> buffer type on a per cgroup basis.
>
> x prefix in the control file name x.bo_requested.amd.stat signify
> experimental.

Why is a counting of the size of buffer objects ever allocated useful,
as opposed to the current size of buffer objects allocated?

And, really, why is this stat in cgroups, instead of a debugfs entry?

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlv0dOUACgkQtdYpNtH8
nujhhw//bXx9tdGEAxnvdNW7OssdWk6uZvqc2P8EwZaraQonObSIawTmaK8Iw/He
ebILvlcxf0jadJWcB70G3k1m1yRW/GS6d990HZ8+fzu0sNDHh2pXW7Rre+wIaDgf
69f29x6kz0VlhscY5SwSMBnfIhR+/v/8xZtQ+QGZnGLt4MpRDFympm95GhzrB9fC
bs6VSe1gJDYs/vcEK0IIrymCG3NjvTni8uY/UQPJKr8LxO6e+Nj3k41zUGg5F6U+
49BFB0gzXnBf9M3BRVCj9APxEhWuRifmiHz50aH6bgIXpmhvzh0MfgnEkkzZbRzq
ClM2jUmKzaYBhnTQvLEwTEYjd4mw1p2a7nCZhQKm6u3hZGmzyjPmxXOD/noOybBm
HnZ/km+eNE60ge+rjVG9ewloa8gPjozZGc4zUUE6tmmveV659RbgNXocZrfcVGuU
1cth0VOdslAV9Mw6TtUGUqGzTsEfxUtISWVznZX0kjfeiOQLrZsJ3m146hDUIqod
4RSt75LQyR0yXvtdvOh2AlImSvLpOEgXQnaMywgBSIpVSpV25YMlYxKNaedN8GU/
kowMGmmgP9rki+215pXjELZWYsq8bBOwQ7bMu07LYz138cHuX9VdukgXdFq1x268
J1+AYDlrOce8Xdgy5hwfzIcwcs8hjHk8PmBhWwsT8bhnrWQrY04=
=TyVf
-----END PGP SIGNATURE-----
--=-=-=--

--===============1375956667==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBt
YWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4Cg==

--===============1375956667==--
