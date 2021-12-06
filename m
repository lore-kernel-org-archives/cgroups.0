From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 2/2] block: cancel all throttled bios in del_gendisk()
Date: Mon, 6 Dec 2021 16:43:01 +0100
Message-ID: <20211206154301.GD45344@blackbody.suse.cz>
References: <20211202130440.1943847-1-yukuai3@huawei.com>
 <20211202130440.1943847-3-yukuai3@huawei.com>
 <20211202144818.GB16798@blackbody.suse.cz>
 <95825098-a532-a0e4-9ed0-0b5f2a0e5f04@huawei.com>
 <20211203102739.GB64349@blackbody.suse.cz>
 <c8a16fe9-4ad2-682d-0d34-1049dc217d62@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tEFtbjk+mNEviIIX"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638805382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/uP9SPjURf9HFURwZMv6YyO0EUqdpWSbn3GJwO2TAZ4=;
        b=p5M6xJcqWuVRb4DSC/shUnJyVMqkf+k8ZzasFRPZ4LknAfvc7Y7pxwNEkZephU/942yefd
        nOhV7p+RIKZgSgUy4fq2jCfeMQLIowYlJJM671UkrMWA2766khdos+rzvf07QaUN+gDV2v
        0+NiPoHbSInzwYmQv1XNF58sjzdGuYI=
Content-Disposition: inline
In-Reply-To: <c8a16fe9-4ad2-682d-0d34-1049dc217d62-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


--tEFtbjk+mNEviIIX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 04, 2021 at 04:03:53PM +0800, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> I was thinking that if there are active blkgs, holding queue_lock will
> ensure blkcg won't be freed.

My take is that the function traverses the whole blkcg tree (from global
root) and nothing prevents concurrent blkcg_css_free() in a possibly
unrelated branch (or queue).

> By the way, does spin_lock can guarantee this since it disables preempt
> like what rcu_read_lock() does?

Yes (but don't quoRTe me on that :-).

(It even isn't issue with a non-preemptible kernel neither but the code
IMO should be generic to allow for different configs -- or as I
mentioned initially, make a comment why the tree traversal is not
affected by concurrent frees.)

Thanks,
Michal

--tEFtbjk+mNEviIIX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTiq06H1IhXbF2mqzsiXqxkP0JkRwUCYa4vgQAKCRAiXqxkP0Jk
R37hAPkBlhUea4e+RY45MvG7rbiOlzMuuNw1T7b6FsVs+XbTUwEA6TPNgcddtJl4
zeg0w3Fvz/XJjRDhQv9Oa1fyXlv04wQ=
=Hf9G
-----END PGP SIGNATURE-----

--tEFtbjk+mNEviIIX--
