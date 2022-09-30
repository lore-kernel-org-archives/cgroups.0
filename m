From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: calling reclaim_high(GFP_KERNEL) in GFP_NOFS
 context deadlocks
Date: Fri, 30 Sep 2022 14:18:56 +0200
Message-ID: <YzbesGeUkX3qwqj8@blackbook>
References: <20220929215440.1967887-1-david@fromorbit.com>
 <20220929222006.GI3600936@dread.disaster.area>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="33Qom3szwTZ9RgHI"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664540338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BaGYgYOltcuFMagUnNo4H7/eNx7M5K3c/+7aHMYsQnk=;
        b=E5aIcQKedCKEd937mwLvNyq8KdU+SfVo36mF+OKdVSFEcOyCbGZIoQBiLQgU8di7R6vCVj
        MBYf8f8vxXuOKp35z4ezICExHFn0cHzFcuINkRCzkvbIsSZpfxDdV/EZP20Oiyz8pzBJKm
        M7fFXAH3FAXpaTH/YcnqAPtZlxKF6Aw=
Content-Disposition: inline
In-Reply-To: <20220929222006.GI3600936-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--33Qom3szwTZ9RgHI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 30, 2022 at 08:20:06AM +1000, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> Fixes: b3ff92916af3 ("mm, memcg: reclaim more aggressively before high allocator throttling")

Perhaps you meant this instead?

Fixes: c9afe31ec443 ("memcg: synchronously enforce memory.high for large overcharges")

Thanks,
Michal

--33Qom3szwTZ9RgHI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYzbejAAKCRAkDQmsBEOq
uV68AP9hdmCM6Vtov4cMYIgG++x22J/zOiQgKt35KYTsLOyL3gEAkryZGyGkaHFJ
SgTK9XCwM7Y010kO2jDfXgtyLUSNcAw=
=fG5j
-----END PGP SIGNATURE-----

--33Qom3szwTZ9RgHI--
