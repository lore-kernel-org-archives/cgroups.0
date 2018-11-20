From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH RFC 4/5] drm/amdgpu: Add accounting of
 command submission via DRM cgroup
Date: Tue, 20 Nov 2018 12:57:33 -0800
Message-ID: <87r2ff79he.fsf@anholt.net>
References: <20181120185814.13362-1-Kenny.Ho@amd.com>
 <20181120185814.13362-5-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1076449786=="
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20181120185814.13362-5-Kenny.Ho@amd.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Kenny Ho <Kenny.Ho@amd.com>, y2kenny@gmail.com, Kenny.Ho@amd.com, cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org

--===============1076449786==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Kenny Ho <Kenny.Ho@amd.com> writes:

> Account for the number of command submitted to amdgpu by type on a per
> cgroup basis, for the purpose of profiling/monitoring applications.

For profiling other drivers, I've used perf tracepoints, which let you
get useful timelines of multiple events in the driver.  Have you made
use of this stat for productive profiling?

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlv0dT0ACgkQtdYpNtH8
nugKoA//SsLocOcohCUR9cppO+vnmzsSMVn0S6CUmE/ltY2q14LsKvmL23VgjgkN
5iC1eEq1waFrfoDeYhBYOL3j8dHxQA3b2kk3gXbUcaV04fPb+stNIM0V82eMAm9C
JZKY+/Rd5nKC9nSLuA4berAy+Pg4A/WsY6QnV37WuVWBdPm3jVPN720Gmpm0ZLX2
6acwxqJoaGzvf4YuS2FxITymzQke/fwa+zd4tIhbc9CG2u9b8hmBpi7eG2dkycLt
a5d4TR/P7Ez9AVcYCmiyN55PaoVXTPn2p0cb5vNcVrU1TbNaOBIPlJSgQazsmyyq
X7q/kACo79I50zO1jXrO9BmimXik39V9XHb4u1Hycpr5BWUld/2cbwt5JLoKiJ9a
Fx52aBs5mcmREF6eSnAsvj5ZbJ82S2Edj2lxehD7P7OIoqmBpklG2EB2mIaNSbh7
laibAVKDKVApHBB2VmBBZAOgZlRcHnaggaIRHMOenLhhy2hFAIF839c/07tS/xxu
6UVCVpabtIVCjzy7h4gUdqCurffrK7lotZuggg9s41JEWewCD+5KuTX3S7e1REPM
O81oI8X0gQ7L1LmR8bjF0IVfovGJ6EK3GiwcjQDMw64FbKoFy/ClDP9CSXaY62x+
+Z6OlHnOsoae0tdYh06vtvISgkNK4M93NRUT+mCQS7hzQod4kVU=
=5vQ5
-----END PGP SIGNATURE-----
--=-=-=--

--===============1076449786==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4
IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4Cg==

--===============1076449786==--
