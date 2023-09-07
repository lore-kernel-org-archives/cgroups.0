From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Thu, 7 Sep 2023 17:06:48 +0200
Message-ID: <lqcl5cblo3s45afvtgqjkbz2an3zwccsckglhpe3ufyffqavjk@ui45m6itz4ne>
References: <20230906005712.66461-1-luizcap@amazon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fb522kinagxi363h"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694099209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jlk2aVZRvC2y/qKDlLstKtfgf2Vh9rUftT3QduXr7LQ=;
        b=og32zLaWxL+nBMJpNev005pWzlZ8xcaftNekvoDckFB9fNls3DMj51BpD/mL6rsum2WDqk
        NI5Ut9JSRIAYoaRE1XOVzik/fl02jwg7IJvJk3CEKtKN+eWkxj2NTEZTnXLanV5OO58CH1
        eIfOHGCTdrycY4aDYbYpUKJ3cccECMM=
Content-Disposition: inline
In-Reply-To: <20230906005712.66461-1-luizcap@amazon.com>
List-ID: <cgroups.vger.kernel.org>
To: Luiz Capitulino <luizcap@amazon.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, longman@redhat.com, lcapitulino@gmail.com


--fb522kinagxi363h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 06, 2023 at 12:57:12AM +0000, Luiz Capitulino <luizcap@amazon.com> wrote:
> We have a need of using favordynmods with cgroup v1, which doesn't support
> changing mount flags during remount. Enabling CONFIG_FAVOR_DYNMODS at
> build-time is not an option because we want to be able to selectively
> enable it for certain systems.

Could this be implemented by a utility that would read /proc/cmdline
(while kernel ignores the arg) and remount respective hierarchies
accordingly? Or what do I miss?

Thanks,
Michal

--fb522kinagxi363h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZPnnBQAKCRAGvrMr/1gc
jkAPAP97oDuOi9qLFPYmLAYQvF0zxgwO1uM7BUMdlLfLcLl5cQEAqUN0ZTNPFM6f
W8z+8KTpA6lbp2Cn/PVij8rH1I/V3wA=
=YGWh
-----END PGP SIGNATURE-----

--fb522kinagxi363h--
