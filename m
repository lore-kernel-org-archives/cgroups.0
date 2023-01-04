From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH] blk-cgroup: fix missing pd_online_fn() while activating
 policy
Date: Wed, 4 Jan 2023 16:12:41 +0100
Message-ID: <20230104151241.GA13268@blackbody.suse.cz>
References: <20230103112833.2013432-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672845162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cK854pd9Zs98xPWzA1GXwHSTWLX/srzXjI6ZWiC477A=;
        b=cH+VtVgskkQNDth3N6NwWyDS9lN1sKVg8Vn/Qi8LKSu1lriebiOJim04EXndrnDvUNug7u
        +A76W+SQbvN0ieAmwxN+ZD5aH2sNPdMAOgFhd113uLs6EwGno5wQ1ez3+J0t1+MO1+bu1A
        0qb7mZ9ZapFiyIPvI9PzKB68szHUApk=
Content-Disposition: inline
In-Reply-To: <20230103112833.2013432-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Tue, Jan 03, 2023 at 07:28:33PM +0800, Yu Kuai <yukuai1@huaweicloud.com>=
 wrote:
> If the policy defines pd_online_fn(), it should be called after
> pd_init_fn(), like blkg_create().

Is this based only on code review or has it some negative effects?

I assume this would affect hot-plugged (read after cgroup creation) devices.

I took a cursory look at:

	blkcg_init_disk
	  blkg_create
	    pol->pd_init_fn(blkg->pd[i]);
	    pol->pd_online_fn(blkg->pd[i]);
	  blk_throtl_init
	    blkcg_activate_policy
	      pol->pd_init_fn(blkg->pd[i]);
	      ?? pol->pd_online_fn(blkg->pd[i]);

I.e. the pd_online_fn is already called and pd_init_fn is called 2nd
time?=20

Thanks,
Michal

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY7WXZwAKCRAkDQmsBEOq
uYzCAQCQJvItX+0rH8KzvN8r0AYCi6gTM5ah+aXAYQr8dUNElAD/e8CzXJ5O5Duv
Pv8irMcwqhh3xMyMa381dZ2QS/G2iAo=
=m4Pb
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
