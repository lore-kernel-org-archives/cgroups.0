From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH -next] blk-throttle: enable io throttle for root in
 cgroup v2
Date: Mon, 6 Feb 2023 16:10:31 +0100
Message-ID: <20230206151031.GB21332@blackbody.suse.cz>
References: <20220114093000.3323470-1-yukuai3@huawei.com>
 <YfGE9L4i7DtNTo08@slm.duckdns.org>
 <235b0757-d322-2b6e-3ab6-ecc8c82f8f1e@huawei.com>
 <Yflr4FzUTWsiLTC/@slm.duckdns.org>
 <32b6949d-60b1-82ce-ae44-1cf089a78276@huawei.com>
 <YgK7J8TFyFvp/rv1@slm.duckdns.org>
 <34ae7d06-4f6b-73f7-7299-65cb8859aad8@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675696233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sd5nDRHXJk++5A7W1c8QOz1iQG/3lZICXPVElgOmb6Y=;
        b=ThcOtschhlpEv1GvXgf49lGKS1ihus3Qw82rT2rJff2mbZ0TtKu1oxMV3OVvBaZBvjqWzU
        otCZwlDmUyqwx4FPNSP6bA2xRMz0PlsZXQQzMPIKQg2O1UqclWhVr+KStARpiwPvBq94v3
        ltYSws6YThw4EeL7+pbVF24NHIzvVz8=
Content-Disposition: inline
In-Reply-To: <34ae7d06-4f6b-73f7-7299-65cb8859aad8-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kuai.

On Wed, Feb 09, 2022 at 09:22:30AM +0800, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> Do you agree that the server can't control how many io it can receives
> from one client if we limit from server? I think the difference is that
> limit from client can control it...

(Perhaps it depends on the protocol used for the IO but) eventually
client requests would be noticably lost/dropped and that's how the
server propagates the requested control onto the clients without relying
on the clients throttling themselves.

(Maybe better place to implement this would be a "testing" device mapper
target akin to the 'delay' one.)

Regards,
Michal

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY+EYZQAKCRAkDQmsBEOq
uYmjAPsG5BcOsvviZP85LUOSIeXHZpkSx9/T2c2MgnKfcze59AD6A67gBQWTt2pC
/s80tllQKtomn3NTxSWL5rdz+oehegI=
=d/38
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
