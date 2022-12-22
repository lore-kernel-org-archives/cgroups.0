From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Thu, 22 Dec 2022 14:39:12 +0100
Message-ID: <20221222133912.GA20830@blackbody.suse.cz>
References: <20221218111314.55525-1-hanjinke.666@bytedance.com>
 <20221221104246.37714-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671716354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vtrUvg4YowUHHaB/oWDczwXqJMHTjVYGpm9kUzl8kTI=;
        b=BX65IxCWiuGYFzvTkZ+nr3VtDH+usLyg+BU9HM+jdMWyoRpJ+3k3OCpwuGNDqcMNpirHtA
        DLSXITsn3LTiR/TPLke2cOGEITISuFRggz4oAfhTnUt14xTl305toFm7z1ogtSDIOxn92w
        CihiLx8o6X0kl8zur6D6H4APW/OxlSs=
Content-Disposition: inline
In-Reply-To: <20221221104246.37714-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
To: Jinke Han <hanjinke.666@bytedance.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Jinke.

On Wed, Dec 21, 2022 at 06:42:46PM +0800, Jinke Han <hanjinke.666@bytedance=
=2Ecom> wrote:
> In our test, fio writes a 100g file in sequential 4k blocksize in
> a container with low bps limit configured (wbps=3D10M). More than 1200
> ios were throttled in blk-throtl queue and the avarage throtle time
> of each io is 140s. At the same time, the operation of saving a small
> file by vim will be blocked amolst 140s. As a fsync will be send by vim,
> the sync ios of fsync will be blocked by a huge amount of buffer write
> ios ahead. This is also a priority inversion problem within one cgroup.
> In the database scene, things got really bad with blk-throtle enabled
> as fsync is called very often.

I'm trying to make sense of the numbers:
- at 10 MB/s, it's 0.4 ms per 4k block
- there are 1.2k throttled bios that gives waiting time of roughly 0.5s
  ~ 0.4ms * 1200
- you say that you observe 280 times longer throttling time,
- that'd mean there should be 340k queued bios=20
  - or cummulative dispatch of ~1400 MB of data

So what are the queued quantities? Are there more than 1200 bios or are
they bigger than the 4k you mention?

Thanks for clarification.

(I acknowledge the possible problem with a large population of async
writes delaying scarce sync writes.)

Michal

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY6Rd9AAKCRAkDQmsBEOq
ua1JAQDsiMRSLjxEJBtDI7L1TSV+aXGoBObxymsZ8wdIom3evQD/RFAuRv6/4e6V
GjV/UcnvMk5iZ5R2P+SQNC3uHiNJTQU=
=95C9
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
