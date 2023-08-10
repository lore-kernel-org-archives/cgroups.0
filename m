From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Thu, 10 Aug 2023 10:59:47 +0200
Message-ID: <5n6ti5ym5ean7nk3meul4nzpd6poimyfx5hn3mfj436k64qkz3@uzhut3yeszcu>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hj4duincgs2uethd"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691657988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jy/YCn0JOglkNZoKf+HHCofDjT30/Uw6kt1m0VyWxSM=;
        b=aAu4rrdfNPSY9/SthNOTGY4CcP4k23StpfFeloLpGY6m0J63bPGetURM2yapPQ5RR377Sw
        un1UUxcQIlFfbIE8OayE0qBIBWs4wra2XowlN5r+AHzYeAmm+zdW5doEF8qSmj4iq/0XmX
        2l4+ypNoD3XdbgUreuByjoX5UuAXuuY=
Content-Disposition: inline
In-Reply-To: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
To: Li Lingfeng <lilingfeng@huaweicloud.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, yukuai3@huawei.com, linan122@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com, lilingfeng3@huawei.com


--hj4duincgs2uethd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 10, 2023 at 11:51:11AM +0800, Li Lingfeng <lilingfeng@huaweiclo=
ud.com> wrote:
> ---
>   v1->v2: open-code blk_iolatency_try_init()
>   v2->v3: add lockdep check
>  block/blk-iolatency.c | 35 +++++++++++------------------------
>  1 file changed, 11 insertions(+), 24 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

Thanks.

--hj4duincgs2uethd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZNSnAQAKCRAGvrMr/1gc
jssIAP0S+pqij21mDTM9cHk5Ner222D9hnl4pzbvxyJZSBlg2gD/V7I3A4pTZgvm
sK+hU4OXge5gDrsskiOKZkE19TZpHgM=
=CNhy
-----END PGP SIGNATURE-----

--hj4duincgs2uethd--
