From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH -next] blk-throttle: enable io throttle for root in
 cgroup v2
Date: Mon, 6 Feb 2023 16:00:05 +0100
Message-ID: <20230206150005.GA21332@blackbody.suse.cz>
References: <YgMxjyVjMjmkMQU5@T590>
 <20230205155541.1320485-1-ofir.gal@volumez.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675695607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CHr5Q9e/qYSR9V7lQvVbstMTRujY37JvhtvhbDdNFhc=;
        b=enJco1GFYEfekNRXGEjHa1Y2bGfrnhXYglwlqDZW2Sv4Qk1qm0y4/4RCCjo+Xihi+IuVOA
        ePgWSGg1LBdHFyZfUnbe0cAI60zlC54RcqWcKG6Xrrc3Y8s61rAy4aQkl18x0CDEKO1L4L
        cUoroXDioBA0ZPiMfXdkUlPZrOoTikY=
Content-Disposition: inline
In-Reply-To: <20230205155541.1320485-1-ofir.gal@volumez.com>
List-ID: <cgroups.vger.kernel.org>
To: Ofir Gal <ofir.gal@volumez.com>
Cc: ming.lei@redhat.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, yi.zhang@huawei.com, yukuai3@huawei.com, Ofir Gal <ofir@gal.software>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 05, 2023 at 05:55:41PM +0200, Ofir Gal <ofir.gal@volumez.com> w=
rote:
> I have tried to limit the SSD on Server #1, but it seems that the NVME
> target kworkers are not affected unless I use Yu Kuai's patch.
>=20
> Can you elaborate on the issues with this patch or how the scenario
> described above can be done with cgroups v2?

The issue is that if there's a client that doesn't implement
self-throttling you cannot guarantee anything on the server side.
Hence the mechanism must exist on the server side.

The NVME target should charge IO to respective blkcg's (just a generic
advice, I'm not familiar with that interface; see also
kthread_associate_blkcg() use in loop device driver).

HTH,
Michal

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY+EV8wAKCRAkDQmsBEOq
uYzSAQC5yFq4obBPBxGW7dUITuiVPv6Svw5a8kySKrK/nZPGYAD+KRMo99VYj9Y2
xbYlmja7pXl+uBz41omMQ8YYSzDE2Ag=
=Ujhj
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
