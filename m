From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 2/2] block: cancel all throttled bios in del_gendisk()
Date: Fri, 3 Dec 2021 11:27:39 +0100
Message-ID: <20211203102739.GB64349@blackbody.suse.cz>
References: <20211202130440.1943847-1-yukuai3@huawei.com>
 <20211202130440.1943847-3-yukuai3@huawei.com>
 <20211202144818.GB16798@blackbody.suse.cz>
 <95825098-a532-a0e4-9ed0-0b5f2a0e5f04@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638527260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DvmP4cB/KNSRMgh4UcYVFP3x4fPHzjzEcFBhVdgCru0=;
        b=MhFZ5ke24T5q0Sb3wHgjIeX2G1ZCb5g6d41PhS8Trge8RFGVLrwzMO/HycD4Jd2kNRV7bz
        LrhPHTIzUonH7t8N+MMz6ch2dmM1oBJQagD7Ep3UpZ4/paqZtZNwk4JwzY92h8umG1HitZ
        tMhsu1WaLNQpPDIgIacn1YgtL6q7hC8=
Content-Disposition: inline
In-Reply-To: <95825098-a532-a0e4-9ed0-0b5f2a0e5f04-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 03, 2021 at 03:50:01PM +0800, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>=
 wrote:
> blkg_destroy() is protected by the queue_lock=EF=BC=8Cso I think queue_lo=
ck can
> protect such concurrent scenario.

blkg_destroy() is not as destroying :-) as actual free, you should
synchronize against (the queue_lock ensures this for
pd_free_fn=3Dthrotl_pd_free but you may still trip on blkcg after
blkcg_css_free()).

[Actually, I think you should see a warning in your situation if you
enable CONFIG_PROVE_RCU.]

HTH,
Michal

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTiq06H1IhXbF2mqzsiXqxkP0JkRwUCYanxCgAKCRAiXqxkP0Jk
R3lBAP4oljvRynKApFVPUyqI5k6NuqpWC4Yv1Ll3PdCiKrZkiwEAtozR8aRyinFF
NPyhhAKCpdU+IAXi7JXzqU982GQDEAs=
=YebJ
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
