From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: Fix io statistics for cgroup v1
Date: Mon, 3 Apr 2023 17:30:21 +0200
Message-ID: <20230403153021.z4smxxnxbgdcgcey@blackpad>
References: <20230401094708.77631-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zyxomnpk7u4ms5xp"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680535823; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YDwpYF4u/WbyyCSZ3xRLaLaKTiwTm4Y0OH0oxOZVABk=;
        b=l9MyysTeT5JhkZxjgLyTDnDn9swdOLi94eW+7mcQeIg2+njQJlaolClaSoA7hl0F7WrExj
        qJyGBmD+AmUjjrpfgx5KA4CUDB+4tJXxnQdZfYEARqoeezCLGSzAcI33I7rE4th2sVQErr
        bsCKR2DhASdb81S0vQ47j+J7mTEVT3c=
Content-Disposition: inline
In-Reply-To: <20230401094708.77631-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--zyxomnpk7u4ms5xp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 01, 2023 at 05:47:08PM +0800, Jinke Han <hanjinke.666@bytedance=
=2Ecom> wrote:
> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>=20
> After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
> blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
> the only stable io stats interface of cgroup v1,

There is also blkio.bfq.{io_serviced,io_service_bytes} couple, so it's
not the only. Or do you mean stable in terms of used IO scheduler?

> and these statistics are done in the blk-throttle code. But the
> current code only counts the bios that are actually throttled. When
> the user does not add the throttle limit,

=2E.. "or the limit doesn't kick in"

> the io stats for cgroup v1 has nothing.


> I fix it according to the statistical method of v2, and made it count
> all ios accurately.

s/all ios/all bios and split ios/=20

(IIUC you fix two things)

> Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")

Good catch.

Does it also undo the performance gain from that commit? (Or rather,
have you observed effect of your patch on v2-only performance?)

> Signed-off-by: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  block/blk-cgroup.c   | 6 ++++--
>  block/blk-throttle.c | 6 ------
>  block/blk-throttle.h | 9 +++++++++
>  3 files changed, 13 insertions(+), 8 deletions(-)

The code looks correct.

Thanks,
Michal

--zyxomnpk7u4ms5xp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCrxCQAKCRAkDQmsBEOq
uYrdAQDQZdcEO4tDtRmV1dkrKTvOziHQuJI0oy2suFYm6RIM5QEAhZBPPLwgfokP
zz+x15hzo4Ce/VUdKwWOjbjwsq0/9w0=
=32so
-----END PGP SIGNATURE-----

--zyxomnpk7u4ms5xp--
