From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: Simplify code in css_set_move_task
Date: Thu, 27 Oct 2022 10:05:58 +0200
Message-ID: <20221027080558.GA23269@blackbody.suse.cz>
References: <20221020074701.84326-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666857960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JB+ZwAH3tZeB/xLL4oPkxw2lhqsXmnM+w4yaMWPtXfA=;
        b=UxCwOG8iaQ5z0kR30Xhv+T+YgXM6Da+nA+OAxZkukpkX/xt782QOG0p80yV8edfcvjWAOL
        YugPs+pZEe4xBn0214wiJrQSxaZbfa5pwFugb+c/m8i4KNEaHrIJEEIsQH1S4qEpD4ki6N
        0M0k6hECJ0Jx2+OMwt5QhqrwViPFonw=
Content-Disposition: inline
In-Reply-To: <20221020074701.84326-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Thu, Oct 20, 2022 at 07:47:01AM +0000, "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org> wrote:
> -	lockdep_assert_held(&css_set_lock);
> +	if (!cset || css_set_populated(cset))
> +		return;

1) the guard should be css_set_populated() ^ populated (when unsetting
the populated trait)

2) I'd keep the lockdep_assert_held() after it anyway.

Also the commit message should explain what's the reason to move
css_set_populated() after css_set_move_task().


Thanks,
Michal

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY1o75AAKCRAkDQmsBEOq
uXHDAQCOinrY1kFjcQOhAJCTkNGtfYQw8WGO+dSV9SKp6KVpKgD/aGGawMIRLY2k
sOu1Rbx6xA0c6ypKQLhvxZks/MOPuQU=
=pEmY
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
