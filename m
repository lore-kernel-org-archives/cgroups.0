From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: Simplify code in css_set_move_task
Date: Mon, 31 Oct 2022 14:11:40 +0100
Message-ID: <20221031131140.GC27841@blackbody.suse.cz>
References: <20221020074701.84326-1-haifeng.xu@shopee.com>
 <20221027080558.GA23269@blackbody.suse.cz>
 <adb7418c-39a2-6202-970a-a039ad8201dd@shopee.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667221901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PKEWeuaqEd6vlqq7RTx8/3afjyq+Dr1cAWsD5nEX5GU=;
        b=MnEqUWgYzBToTXLZKf9RPYtbnqf4atIaTUw4xzKjI8Fe9YOOTbZMdSkdVkAJBKlsE/7zME
        R4YV6pswN0Rd6TYiyR8lgFEF8/yiqHcH7SK3vSkyUsfdcLyCd3Be1270B37jQSP5rd3hAx
        xF/pUYcxzWPtBCUJAPTj0fQrCtR+2j0=
Content-Disposition: inline
In-Reply-To: <adb7418c-39a2-6202-970a-a039ad8201dd-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

> 1) If calls 'css_set_update_populated' , the cset is either getting the
> first task or losing the last. There is a need to update the populated
> state of the cset only when 'css_set_populated' returns false.
> In other words, the last has been deleted from from_cset and the first
> hasn't been added to to_cset yet.

I've likely misread the condition previously. I see how this works now
(update happens after "from_cset" but before "to_cset" migration).

> 3) In order to update the populated state of to_cset the same way
> from_cset does, 'css_set_update_populated' is also invoked during the
> process of moving a task to to_cset.

As I think more about this in the context of vertical migrations
(ancestor<->descendant, such as during controller dis- or enablement),
I'm afraid the inverted order would lead to "spurious" emptiness
notifications in ancestors (in the case a there is just a single task
that migrates parent->child, parent/cgroup.populated would generate and
event that'd be nullified by the subsequent population of the child).

So I'm not sure the change is worth it.

Michal

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY1/JiQAKCRAkDQmsBEOq
uTWXAP4+msA6mEv17VE0bvXPosCxQHytBdxI4BLiZcaE9m59ggD/SDf7epi6xoIP
Ik6LZC+YlTL+GCTFIOhxdlJNT2RyAQE=
=SfdS
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
