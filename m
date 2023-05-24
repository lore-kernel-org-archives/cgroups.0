From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup: rstat: Simplified
 cgroup_base_stat_flush() update last_bstat logic
Date: Wed, 24 May 2023 10:02:18 +0200
Message-ID: <remnwctqmxleig7ywt6puhxnpmzjo7xm6hlfhpnul46ulfnw7j@36sbuxhuatto>
References: <20230518124142.57644-1-jiahao.os@bytedance.com>
 <f39b9229-e59c-2b1c-7f3f-1aeedfad44dc@bytedance.com>
 <5g73i4yvi4ub4dqrf4dnq5qghkyckoygmgd2st6be3gg7twww2@w6zim6nxpt3b>
 <4d49f7e7-2488-9690-258e-34e617cfef6f@bytedance.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ixixg2dethhn6gyp"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1684915339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WqlOFgy8/FolADupE6AkHXzpXFhsTG20aogxrqmC9bo=;
        b=BMAQHwQ+haz+kQLroOOIGsgizMYwNwYD8kzZI6hAsngZzYKuB+I+0kHgf/PLLRbvr3XrM5
        eQ7foxYuTF3KprWqB30AgvgoKKtARBsTjTqpZ5tf5BKAwlKk739ir9Q/w6w0Mx/NkS3Ssb
        +z+6cG23iMD4wwFR4B2mYzb0aW3bP6Y=
Content-Disposition: inline
In-Reply-To: <4d49f7e7-2488-9690-258e-34e617cfef6f-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--ixixg2dethhn6gyp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 24, 2023 at 02:54:10PM +0800, Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> Yes, so we need @curr to record the bstat value after the sequence fetch is
> completed.

No, I still don't see a problem that it solves. If you find incorrect
data being reported, please explain it more/with an example.

> Yes, but it may not be obvious.
> Another reason is that when we complete an update, we snapshot last_bstat as
> the current bstat, which is better for readers to understand. Arithmetics is
> somewhat obscure.

The readability here is subjective. It'd be interesting to have some
data comparing arithmetics vs copying though.

HTH,
Michal

--ixixg2dethhn6gyp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZG3EdwAKCRAkDQmsBEOq
uSG7AQCCqh0Ztm3AvJ/AD3CDMG7kdKSMWs1vPOT5JeHoYIeO+QD+Nf1Fd5xQzIvV
XFrpdN/nyCT6u8+MgTJtO0zv1YTPHgE=
=l5cB
-----END PGP SIGNATURE-----

--ixixg2dethhn6gyp--
