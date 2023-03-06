From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RESEND PATCH v6] blk-throtl: Introduce sync and async queues
 for blk-throtl
Date: Mon, 6 Mar 2023 18:06:34 +0100
Message-ID: <20230306170634.os744umla72yoryw@blackpad>
References: <20230228085935.71465-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jhuwt4jvay5ya4x6"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678122395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SqhwY2lPFDKqTCuisG7qrwOwTn3FoFZkWgoREgP29v8=;
        b=hm2foqGrZ06Y6i1j0SnSjC4wlKPfurlYM008VAotDgueUi0QN4jlgObNfSS23IJKqFjKqG
        +a/FEvqy82lLP3iSMTqS9Punj69DQjt3JeOuGZCQTY7XqfzcjVuSvEplB1PwdhbR5evufB
        F3HHYNujVu4YQkYJexnd6mVfsAPF2KA=
Content-Disposition: inline
In-Reply-To: <20230228085935.71465-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org


--jhuwt4jvay5ya4x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jinke.

On Tue, Feb 28, 2023 at 04:59:35PM +0800, Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> and gives a huge priority to sync write ios. Sync queue only make sense
> for write ios as we treat all read io as sync io.
[...]
> +/* For write ios, dispatch 4 sync ios and 1 normal io in one loop */
> +#define THROTL_SYNC_FACTOR 4

This looks like an unexplained number wired in.
E.g. I'd expect that 1st iteration would have this factor==1, i.e. RR
between sync and async queue.

What is the reason for this value? E.g. I assume it'd depend on number
of synchronous writers and flusher threads and their activity, i.e.
could you describe why this value caters the best for wide range of
various sync and async situations? Or add a comment what is the
particular value based on (so that it can be reassessed should those
dependencies change in the future).

Thanks,
Michal

--jhuwt4jvay5ya4x6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZAYdmAAKCRAkDQmsBEOq
ub2YAQDaCWaGj/Xvs8G4Pm/2qCiJtHgjoH42bz+/IlGbTg3DywD/U7l4W1eG5LvM
oPCsWs+kfse5/fw4pnz49VDjkNLexgk=
=D9q5
-----END PGP SIGNATURE-----

--jhuwt4jvay5ya4x6--
