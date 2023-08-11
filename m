From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Fri, 11 Aug 2023 11:17:23 +0200
Message-ID: <fwzsn3wyqpthfkegnlq7obl3uy6hhodobvcswena2z42ndzmzp@izv4k6wy6opt>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
 <6637e6cd-20aa-110a-40ae-53ecd6eb4184@huaweicloud.com>
 <d4050f7e-d491-c111-3e26-160e7d5a4208@huaweicloud.com>
 <dtobag743cbzb3rxzldu36wszqtnbayz2grpyj2cctptfybtt3@66ico6n2clrr>
 <60dbff4b-d823-5dc9-ff8e-36648ddf7207@huaweicloud.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6koa3vpku6zfzfmx"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691745444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7YZepTMAv/Au26R8+gI+UkHj/wQbzQF2/pHToHgZrjg=;
        b=SMJPFU2WEyswb6twc8sKVxaTwcMcOCA2fafyXmHrwYXp0JCAKjQQPGzX4UJD8RpLDrEIJ6
        LVt6756QWGxgmfp7oFpUSyY12/CQzA0MtZbbVBJPFURfiXMGti1Vi0lBQlAxUbmqPh5Eb7
        bNoOLvx6Qgk0RX22PkWdZJu72KiIEVY=
Content-Disposition: inline
In-Reply-To: <60dbff4b-d823-5dc9-ff8e-36648ddf7207@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Li Lingfeng <lilingfeng@huaweicloud.com>, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linan122@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com, lilingfeng3@huawei.com, "yukuai (C)" <yukuai3@huawei.com>


--6koa3vpku6zfzfmx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 11, 2023 at 04:53:44PM +0800, Yu Kuai <yukuai1@huaweicloud.com>=
 wrote:
> Yes, it'm implemented in the upper layer that rq_qos_add() and
> blkcg_activate_policy() should be atmoic, and currently there is no
> comments for that.

The check (iolat_rq_qos()) and use (activating the policy) should be the
atomic pair.

> Perhaps it's better to add some comments like following in rq_qos_add()
> instead?

Honestly, I find the current variant (v3) good as it is -- closest to
the pair of the operations.

(But it's merely a comment so =C2=AF\_(=E3=83=84)_/=C2=AF)

Michal

--6koa3vpku6zfzfmx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZNX8oAAKCRAGvrMr/1gc
jh2HAQDn5ssFKhK4z/OdWTcfgO8LfZnvmBz3+V8z54G2a+DN+QEAlsCwIo1klPtg
YTfZCKcGYeRkwlEtUpWCOjTchuJkIAo=
=CKR8
-----END PGP SIGNATURE-----

--6koa3vpku6zfzfmx--
