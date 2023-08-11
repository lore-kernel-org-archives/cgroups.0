From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Fri, 11 Aug 2023 10:23:49 +0200
Message-ID: <dtobag743cbzb3rxzldu36wszqtnbayz2grpyj2cctptfybtt3@66ico6n2clrr>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
 <6637e6cd-20aa-110a-40ae-53ecd6eb4184@huaweicloud.com>
 <d4050f7e-d491-c111-3e26-160e7d5a4208@huaweicloud.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zqhlkl5irnp4pmde"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691742231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XAHLRJ91aICIGGOaaGit2Y6QwMl3ywOsiEqwUzwig6c=;
        b=hi4xqu/Xfb/lRFWXg7qi1rorGt75xQyV7YSBTBCzbp54A1sqfXGGQ0CMDnBSR1tjGbLqaA
        RF9GfgvYb7hKLzmRQrqQIk7arD6AZgAuIrpY6Z4doEpsGxRhamIyCz+HcYBMh2vcRIkNin
        q1NpSE1INhzEIH2Vp6IeCwfvg3d4aLo=
Content-Disposition: inline
In-Reply-To: <d4050f7e-d491-c111-3e26-160e7d5a4208-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>


--zqhlkl5irnp4pmde
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 11, 2023 at 09:44:55AM +0800, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org> wrote:
> Now that this problem doesn't exist, I think it's ok just to remove this
> comment.

Why doesn't the problem exist now?
IIUC, it does but it's prevented thanks to outer synchronization via
rq_qos_mutex. Hence the comment clarifies why is the lockdep_assert
placed here.


Michal

--zqhlkl5irnp4pmde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZNXwBgAKCRAGvrMr/1gc
jh/AAP9SvWJp6Nz9+hOawByX3LxRnZ9iMEwthx4HdWkkUFWzigEA5WqdymnqVleY
CwTyxjDyPdWnuMyLErCzkRgA/BTmYgo=
=qLjb
-----END PGP SIGNATURE-----

--zqhlkl5irnp4pmde--
