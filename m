From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET v2 block/for-5.8] iocost: improve use_delay and latency
 target handling
Date: Mon, 13 Apr 2020 19:56:26 +0300
Message-ID: <dd55f890-740c-16b5-77bd-4c6fdb710b3d@gmail.com>
References: <20200413162758.97252-1-tj@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hFjuupwkWmuwpO9jhiJUUOPGSlwvofv9Q"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Xk2BsSDKDhxiXf1W9gwjsfp/DxSiKFq+bcaV0hQZsPk=;
        b=Ek6w3+2LwAgiEFDyJrzJ5+hBEeixOiDyTWppwlRHynKI7HKyY00VBh54AtmkM/tBT/
         HXgnDqaRJLaacub59m4ZAc8rIviUGL+EQAXy92qTwWo5CZ1vfpUeNZZX3/7Ide5puFIT
         Kg+AeTnkWlOwIFcQUYsUNJBC97RbveeDwLjyX18UgS+LAxOdjASYYAPjizDBWTIH22xy
         7a07z57tP6vAEbV8ngk8wuWHoAk6boUQQljYzOlGG/nbehfLgm0l0MTftg2tp45F1ECa
         vZCOtBbB/JbCFOrVcerRRIvoWd1SwAPF3IXGFk4hWVoh/d8+wEravjuDH/1xGD9lOvU7
         Z80g==
In-Reply-To: <20200413162758.97252-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hFjuupwkWmuwpO9jhiJUUOPGSlwvofv9Q
Content-Type: multipart/mixed; boundary="naT5wF3ZYUQA1LjeTnwfcxF3ZNXqJImDO";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org,
 josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
Message-ID: <dd55f890-740c-16b5-77bd-4c6fdb710b3d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET v2 block/for-5.8] iocost: improve use_delay and latency
 target handling
References: <20200413162758.97252-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20200413162758.97252-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--naT5wF3ZYUQA1LjeTnwfcxF3ZNXqJImDO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 13/04/2020 19:27, Tejun Heo wrote:
> Changes from v1[1]
>=20
> * Dropped 0002-block-add-request-io_data_len.patch and updated to use
>   rq->stats_sectors instead as suggested by Pavel Begunkov.

rq->stats_sectors is set only when there is QUEUE_FLAG_STATS, see
blk_mq_start_request(). I don't see blk-iocost requiring it. Did I miss s=
omething?

>=20
> This patchset improves the following two iocost control behaviors.
>=20
> * iocost was failing to punish heavy shared IO generators (file metadat=
a, memory
>   reclaim) through use_delay mechanism - use_delay automatically decays=
 which
>   works well for iolatency but doesn't match how iocost behaves. This l=
ed to
>   e.g. memory bombs which generate a lot of swap IOs to use over their =
allotted
>   amount. This is fixed by adding non-decaying use_delay mechanism.
>=20
> * The same latency targets were being applied regardless of the IO size=
s. While
>   this works fine for loose targets, it gets in the way when trying to =
tigthen
>   them - a latency target adequate for a 4k IO is too short for a 1 meg=
 IO.
>   iocost now discounts the size portion of cost when testing whether a =
given IO
>   met or missed its latency target.
>=20
> While at it, it also makes minor changse to iocost_monitor.py.
>=20
> This patchset contains the following five patches.
>=20
>  0001-blk-iocost-switch-to-fixed-non-auto-decaying-use_del.patch
>  0002-blk-iocost-account-for-IO-size-when-testing-latencie.patch
>  0003-iocost_monitor-exit-successfully-if-interval-is-zero.patch
>  0004-iocost_monitor-drop-string-wrap-around-numbers-when-.patch
>=20
> and is also available in the following git branch.
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git iocost-del=
ay-latency-v2
>=20
> diffstat follows. Thanks.
>=20
>  block/Kconfig                  |    1=20
>  block/blk-cgroup.c             |    6 ++++
>  block/blk-iocost.c             |   56 +++++++++++++++++++++++++++++---=
---------
>  include/linux/blk-cgroup.h     |   43 ++++++++++++++++++++++++-------
>  tools/cgroup/iocost_monitor.py |   48 +++++++++++++++++++-------------=
---
>  5 files changed, 106 insertions(+), 48 deletions(-)
>=20
> --
> tejun
>=20
> [1] http://lkml.kernel.org/r/20200408201450.3959560-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>=20

--=20
Pavel Begunkov


--naT5wF3ZYUQA1LjeTnwfcxF3ZNXqJImDO--

--hFjuupwkWmuwpO9jhiJUUOPGSlwvofv9Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl6Umb8ACgkQWt5b1Glr
+6UL3Q//cYxPSPCP602xbhfwteRZw+0SsyigabnibOPeoindiN7zG1pRZqRqVdBA
s0H7GfBW8f+DhVSPlgKYSYu4XQMwLRo1/adRJMeLtRvNh8b0CCdENXafKcMty5hK
y0r9/PeMV/xlYb+aRUYFVwwMfX/B35nPnJ0NydCZz6ZYRFgkFz/27YppfsZY1tyk
SBj+jWmBZgGmQoqoPwoCF8HN0KVb/8UIfx3be5b3KGAaB+pcYz26MJjKFufwap6r
31oNhC3GcXSR5GrlsJauwYB5641H3IdP+1a4jg6cvrGN0+h/THVB98JwgImmz6WJ
tWe6uiYXvDCrSdC9QNIJqIv3FiXaF/8pJMv4utJICPcB5xkq0cvz1yx+Zdca6o0b
ybD/7AAcXMOaWbKYxffji/jpChJM0kPdUhDNr79MLoNr7fUusoocxRmPwkWG+jBe
by8O/pGMsKOz3JXELwtWysQy0y/HqQSVYW8x58tdKXj0ACxSKwJqAgDzS5xdOJ1Y
qgauGp4Kx3SwvE0oqV0bC5TKXVxS0q1PCg1XTKicnT7QjQqXYYJdZLf2PkDlqmEE
Ug0P0dfH/ucNAXtv6lz/xfIgvfJnOtg+AHTBE1ol3gSRRbGccCVmrAxwYVcO+wFQ
fVayxegf7IY55PMAPMuNMVCovTih6+DgOgOnc3czO3Y0mi3MYzI=
=D3I7
-----END PGP SIGNATURE-----

--hFjuupwkWmuwpO9jhiJUUOPGSlwvofv9Q--
