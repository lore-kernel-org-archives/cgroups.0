From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH] blk-cgroup: fix missing pd_online_fn() while activating
 policy
Date: Thu, 5 Jan 2023 11:45:08 +0100
Message-ID: <20230105104241.GA16920@blackbody.suse.cz>
References: <20230103112833.2013432-1-yukuai1@huaweicloud.com>
 <20230104151241.GA13268@blackbody.suse.cz>
 <4b559d1d-31e4-6049-4548-451bf7afb4f4@huaweicloud.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4b559d1d-31e4-6049-4548-451bf7afb4f4@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 05, 2023 at 09:43:02AM +0800, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> This is based only on code review, currently the only negative effects
> is that root blkg from blk-throtl won't call pd_online_fn().

Good, that's a NOP and there are no other uses of pd_online_fn.

I wonder are the separate pd_init_fn and pd_online_fn callbacks
necessary today?
(IOW your fixup is a good catch and looks correct to me; I'd suggest
more of a clean up. Shall I look into that?)

> No, this is not true, before blkcg_activate_policy() is called,
> blkg_create() won't see this policy, hence pd_init_fn/pd_online_fn won't
> be called from blkg_create().

Thanks, I missed the q->blkcg_pols bit.

Michal

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY7aqMgAKCRAkDQmsBEOq
udG/AP443o4fnN2JypjVdH6EZJPRY/O5O0N3ywlBupWqtBkSeQD8DIJhUF+tVjlL
zXTyjDqKPgE2Ri3wEWklUqmarfiGJg4=
=7FAl
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
