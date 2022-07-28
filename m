From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH RESEND v6 4/8] blk-throttle: fix io hung due to config
 updates
Date: Thu, 28 Jul 2022 11:33:46 +0200
Message-ID: <20220728093346.GA2281@blackbody.suse.cz>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-5-yukuai1@huaweicloud.com>
 <YuGGVxdlOVk/eF2l@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659000827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SB6tJ4z7ixYCC4m5qWSYZT9XjUVOUuyqFKcfB92kx20=;
        b=hRehc4W65y4S7gZEYw54uweayg3E0ArpqGQbQyLN0cKr7UkMOcM3LGxp1AJoL2gltZtfYf
        9/67Du5A+am+IryU8wF2FrkwkiQm/O6/BS34np2EarxFoT4CF1HfFJuklyvvIzMp0NoZiW
        cTWD9/HFZfvIDiF+6tNyd0lEkZR0wfI=
Content-Disposition: inline
In-Reply-To: <YuGGVxdlOVk/eF2l@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 27, 2022 at 08:39:19AM -1000, Tejun Heo <tj@kernel.org> wrote:
> I'm not quiet sure this is correct. What if the limit keeps changing across
> different values? Then we'd be calculating the skipped amount based on the
> last configuration only which would be incorrect.

When one change of configuration is correct, then all changes must be
correct by induction. It's sufficient to take into account only the one
old config and the new one.

This __tg_update_skipped() calculates bytes_skipped with the limit
before the change and bytes_skipped are used (divided by) the new limit
in tg_with_in_bps_limit().
The accumulation of bytes_skipped across multiple changes (until slice
properly ends) is proportional to how bytes_allowed would grow over
time.
That's why I find this correct (I admit I had to look back into my
notes when this was first discussed).

HTH,
Michal

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYuJX3wAKCRAkDQmsBEOq
uen2AP9DlRReKs7tBs0MfsBYoy0j+l23U/bpUzVeRFefU6hqBQD/dwu4UjPCbCwb
oYbP30IoXD0s6tsiKY9PSyDBkf1xMAU=
=r1c9
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
