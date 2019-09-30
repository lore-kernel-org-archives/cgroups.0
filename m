From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RESEND RFC PATCH 0/2] Fix misuse of blk_rq_stats in
 blk-iolatency
Date: Mon, 30 Sep 2019 11:29:21 +0300
Message-ID: <276a02f3-3b1a-0580-54fb-497f85103ae3@gmail.com>
References: <cover.1560510935.git.asml.silence@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vpDpuljOak4VUjubg0p6HLJIDCCP6aiBm"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=cMSmKksRpZvm7DjI+W2FPVfuQhvxd33fHRo5ksvWmP4=;
        b=dRuBx2TC1uq36DDhogFse6nwMfAp/ucimdeY6k5ppTn2Xho+z3y/ZjUdHhQcPoazXo
         cUl5M2Tc2K6mKaKlg+SBDvdy7Oi3X7/ikExmnGLRT8sGsNOpxOiEHe6QK7uPo/VY0CXK
         CVzAd7AnOL8C+caYQYuaodnOP3e54tWdY5iqQe/Cyb8kAEKxKQs1s1QktwlZCCLiO/VU
         u/RomifRoQXgVF/ZB3ahSgGkC3anJWf1MWewAskf6e5kleYuhEMhhAW5MmC81Er9o0Et
         N8BH6XxrP3+LHJxEPhEDwii7muqWvRD/et3s8ml3IWlUZYc7iWKvuRtsKTfBeoTgGStr
         Gkaw==
In-Reply-To: <cover.1560510935.git.asml.silence@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, josef@toxicpanda.com, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vpDpuljOak4VUjubg0p6HLJIDCCP6aiBm
Content-Type: multipart/mixed; boundary="iwCQfC1143W97Fjrsn5ILXvfBDPud4pYO";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, josef@toxicpanda.com, Tejun Heo
 <tj@kernel.org>, cgroups@vger.kernel.org
Message-ID: <276a02f3-3b1a-0580-54fb-497f85103ae3@gmail.com>
Subject: Re: [RESEND RFC PATCH 0/2] Fix misuse of blk_rq_stats in
 blk-iolatency
References: <cover.1560510935.git.asml.silence@gmail.com>
In-Reply-To: <cover.1560510935.git.asml.silence@gmail.com>

--iwCQfC1143W97Fjrsn5ILXvfBDPud4pYO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I claim, that there is a bug, that hopefully doesn't show itself apart
from a minor disabled optimisation. It's _too_ easy to misuse, and if
somebody try to reuse, this could lead to quite interesting issues.

Could somebody at last take a look?
Thanks

On 25/07/2019 00:35, Pavel Begunkov (Silence) wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
>=20
> There are implicit assumptions about struct blk_rq_stats, which make
> it's very easy to misuse. The first patch fixes consequences, and the
> second employs type-system to prevent recurrences.
>=20
> Acked-by: Josef Bacik <josef@toxicpanda.com>
>=20
> Pavel Begunkov (2):
>   blk-iolatency: Fix zero mean in previous stats
>   blk-stats: Introduce explicit stat staging buffers
>=20
>  block/blk-iolatency.c     | 60 ++++++++++++++++++++++++++++++---------=

>  block/blk-stat.c          | 48 +++++++++++++++++++++++--------
>  block/blk-stat.h          |  9 ++++--
>  include/linux/blk_types.h |  6 ++++
>  4 files changed, 94 insertions(+), 29 deletions(-)
>=20

--=20
Yours sincerely,
Pavel Begunkov


--iwCQfC1143W97Fjrsn5ILXvfBDPud4pYO--

--vpDpuljOak4VUjubg0p6HLJIDCCP6aiBm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl2RvOEACgkQWt5b1Glr
+6UKiBAAgW2BL4yvqLYVizbAQnkdFQG/KreGrf5vyKZhcv2UHjoMvO2EUQzpwX2v
FMaHbFAx5tOnjeoWmwXjYuAJLAnu3qT1+tGtVUFxWcDbyTnrnqAEMB9dItDr2Ga5
K6smdf9rZhnFufPiJfJ0dFqBlfqJ1YhY3L5PG8as5/9Um9B/JCCb0Hjft5yoG2Gs
lsVh+RFzw8hHSptJOru/Fz6oKVDiMloqRSCWhiS7hXquMUhcPusAJLzGPhQ8Kv7o
W8bZOcs99Ijp8Ye5xlgLtohBtpN1C/+ZFMHVxv4UH+JrPvwFzLDCD/mCfGLWTbUK
N8ypzi5AW4KmlBAbzUs8HjQk7FvswcazyWRRm9bg4JWEE1TLgUMrrWmUsHxLlnDO
knNWMjD9+PO7BrYtQm6OUX4+0Jz9wUtYBGSZF7IXLCutJ9/NloHRTFIQWXnp2NX8
WWhB1x590ljZ1REULO1312qztHOQyEOgI9vGV1jlMMQPp5RzRAHeJyC2Ay0JSt43
RZBkbjkG5tcSZ/atpzi/LhXW4PIN3IBvto9F1WYpf465ISjFhmHfEk7K+Tcfa+S1
QfHO3/t2dmFEH/2vm2/foff0av4HedV3gtulofAjpH7c4SVFWJGRjGDewrsap/C2
zMKGPSyJnh8D+boNOMkiLV8qI0juyFQD7MTybazl6u8vHqVssVQ=
=CxFQ
-----END PGP SIGNATURE-----

--vpDpuljOak4VUjubg0p6HLJIDCCP6aiBm--
