From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Thu, 5 Jan 2023 17:18:54 +0100
Message-ID: <20230105161854.GA1259@blackbody.suse.cz>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221226130505.7186-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jinke.

On Mon, Dec 26, 2022 at 09:05:05PM +0800, Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> In our test, fio writes a 100g file in sequential 4k blocksize in
> a container with low bps limit configured (wbps=10M).
> [...]
> At the same time, the operation of saving a small file by vim will be
> blocked amolst 140s.

Could you please elaborate why is this specific to blk-throtl?

I guess similar problem would arise for devices that are "naturally"
slow.
Then:
a) it must have been solved elsewhere in the block layer (but it's
   broken),
b) it should be solved generically in the block layer (thus this is only
   a partial solution).

Alternatively, I imagine your problem could be reduced with
corresponding memory limits on IO-constrained cgroups. (The memory limit
would increase cgwb's dirty throttling and consequently leaves more
IO bandwidth for sync IOs.)

Could you describe how the submitted solution compares to memory
limiting?

> This patch splits bio queue into sync and async queues for blk-throtl
> and gives a huge priority to sync write ios.

The "huge priority" corresponds to the THROTL_SYNC_FACTOR, right?
I'm slightly concerned about the introduction of the magical value.
What is the reasoning behind this? (E.g. I'd expect 1:1 could work as
well, while 1:4 suggests this is somehow better (empirically?).)

Thanks,
Michal


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY7b4bAAKCRAkDQmsBEOq
uQrgAQDs2aA08ChLFwdUU9xtUvTksAkbg4kIOJ6eonBHzYLMmQD9Eku/xsu7q+JO
bkt+bgPn6r1by/lxIByZFdvliq70/g0=
=VUBu
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
