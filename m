From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH RFC 4/5] drm/amdgpu: Add accounting of command submission
 via DRM cgroup
Date: Fri, 23 Nov 2018 09:36:28 -0800
Message-ID: <871s7b7l2b.fsf@anholt.net>
References: <20181120185814.13362-1-Kenny.Ho@amd.com>
 <20181120185814.13362-5-Kenny.Ho@amd.com> <87r2ff79he.fsf@anholt.net>
 <56833f60-1636-d149-c9b0-c021a6ad99d1@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1616063232=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <56833f60-1636-d149-c9b0-c021a6ad99d1@gmail.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: christian.koenig@amd.com, Kenny Ho <Kenny.Ho@amd.com>, y2kenny@gmail.com, cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org

--===============1616063232==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Christian K=C3=B6nig <ckoenig.leichtzumerken@gmail.com> writes:

> Am 20.11.18 um 21:57 schrieb Eric Anholt:
>> Kenny Ho <Kenny.Ho@amd.com> writes:
>>
>>> Account for the number of command submitted to amdgpu by type on a per
>>> cgroup basis, for the purpose of profiling/monitoring applications.
>> For profiling other drivers, I've used perf tracepoints, which let you
>> get useful timelines of multiple events in the driver.  Have you made
>> use of this stat for productive profiling?
>
> Yes, but this is not related to profiling at all.
>
> What we want to do is to limit the resource usage of processes.

That sounds great, and something I'd be interested in for vc4.  However,
as far as I saw explained here, this patch doesn't let you limit
resource usage of a process and is only useful for
"profiling/monitoring" so I'm wondering how it is useful for that
purpose.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlv4OpwACgkQtdYpNtH8
nuisag//cE0Np/kVFyEqmSwGSjAUUFQlcU8hw9wFMGoCbeNdWzpcciUtTP2gNlMX
Ujxuc6Z9woYmAGOsTf1i1Hc/wZ32TLKMh66tSB6fHLJNfK3js04nmJRurBr/0SIr
QYlOieQl6U+AAFUyXMtSMyDWu8KX9ZnHpodbDiIm0jqSLsvsIQt9M9+pny5hgwkz
dDeprOAEhI8TtP367Dy/nDnd7bS8f3prEhonGPiMul1MyowAsrNMRGG4IUox93SY
0MRlaBPjkPCQKvS2jT4T8+bMoGb3eO2QrR87oiywxhTLORZYxRvI/aT2sSMgA9/A
EbVryTlR7Jj0XNwY11JGwlO1Pg3YsU4DJZqyuX2l/d+v6bNbZYkQB30d+5ETiZNM
D7m0kz7/NTaJEBttlMFJOexJgd5on+J94CkLvzlhiJhyWICJoV5Uhpvvoxad/plK
1p5jTRC/lOzR38XDfcTWkCbEE8VJJvr2Vjc5zMypeDny05I7cQ5puZ8tDlZDETdK
/yal9PeiujPmUBMYbm+bGDHe3EYy3uXC5s+Sa3t7nO5SNIiCQH34pcNTgsw1YQjQ
Hua85qgR1859FAn333zOnvcp5L9Lnwn5OFrr/SUlJygLz1mUL8VSFKWXpnDICty5
B0KxEpgziHzS75JQlAahsx63SmFyTPjIbgFoi4lZDsrE9M5RgFk=
=HeYD
-----END PGP SIGNATURE-----
--=-=-=--

--===============1616063232==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============1616063232==--
