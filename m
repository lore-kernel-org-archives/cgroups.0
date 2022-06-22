From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH -next v5 3/8] blk-throttle: factor out code to calculate
 ios/bytes_allowed
Date: Wed, 22 Jun 2022 19:27:06 +0200
Message-ID: <20220622172706.GA28777@blackbody.suse.cz>
References: <20220528064330.3471000-1-yukuai3@huawei.com>
 <20220528064330.3471000-4-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655918828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=25UMif2KJVLcBXrmfApxtfUU35dfSSw3fpcCICtxyW8=;
        b=VvwAIGoDz+l1mAkHZ7Ci8GmQbbrSdA4ZL7MGpC7pXWaXvzYecJ0zZa3bjiNVxhWwXxQPOi
        c1ahBZimSpktVbRlaNbZivz7OeL07LjMauFEFAtU+9izL/QdsVNVvawoLRT1F257ZjbKfn
        ADVQi1piODXNJyF1VM1Ev4FipKeeVEk=
Content-Disposition: inline
In-Reply-To: <20220528064330.3471000-4-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 28, 2022 at 02:43:25PM +0800, Yu Kuai <yukuai3@huawei.com> wrote:
> +static u64 calculate_bytes_allowed(u64 bps_limit,
> +				   unsigned long jiffy_elapsed_rnd)

Just noticed with all series applied this argument needn't be called
_rnd. (It's a nit.)


--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYrNQ5QAKCRAkDQmsBEOq
uRC5AQC2JzZNZsl22etM1LtHU6Wno1hgy9s1Fj5YailfIQfTJwD/c6sCNnhojsjQ
PCgMBZaodtkg4p+8C/tt1eXOMBvsGgo=
=UiWF
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
