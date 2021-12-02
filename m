From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] block: Use div64_ul instead of do_div
Date: Thu, 2 Dec 2021 17:50:20 +0100
Message-ID: <20211202165020.GC16798@blackbody.suse.cz>
References: <20211117010358.158313-1-deng.changcheng@zte.com.cn>
 <20211118034033.163550-1-deng.changcheng@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638463822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B5c8jd312OU++3RBvwTLKAqm2dX4TEtVdTF/pGzwaMU=;
        b=ERGiyyAjqJwCriXlkkBwKYNIVm5nfhXbZQtznCFpuRSgkuGGnHiW5+L7iun6EDRILZDXKl
        S6w6GzOZ3iXyerJDBxg7VVTuB21DKsMPdfSLTc1lhoRKCVVI/yFR6l+H3sG7VPtUDQc22P
        tR8LEGsLjs1s2jm2wC47VF3t+1D6UWU=
Content-Disposition: inline
In-Reply-To: <20211118034033.163550-1-deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Thu, Nov 18, 2021 at 03:40:33AM +0000, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Signed-off-by: Changcheng Deng <deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Just feedback to the bot or to you -- the same do_div() is in the same
function for writes too. I think the processing shouldn't stop at the
first occurence.

Michal


--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTiq06H1IhXbF2mqzsiXqxkP0JkRwUCYaj5PgAKCRAiXqxkP0Jk
RyzZAQCz0MBVSF0oVpol11+mBLRmq7R1xgXflAx9rH3/Ge9yJwD/eURdhzAfYNm4
ZPElCRbhAn62Wi1zRHKFeFh8Ca4WBgI=
=ydev
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
