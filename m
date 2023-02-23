From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: add memory.peak in cgroup root
Date: Thu, 23 Feb 2023 15:20:53 +0100
Message-ID: <20230223142053.ejpygn4asiks7uue@blackpad>
References: <20230221143421.10385-1-matthew.chae@axis.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q22yp5mylqojoxly"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677162054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kav8FmN/Pj89hSxrGp53cgOm8Q4RadxShRyIj0aVt2M=;
        b=KCM/GkDJ5CtrBapJmm08Wf0Llp3zhiGYXKrM4uUOajtjgJm1kj8pXs2eksaizhJIHaIvux
        giEr4JnWA2DcaeQVK7kAsTR0tU68shsJhTBm4/Q/OyvKGeQp1CKXopYhQCk/ovC0IJ/keI
        QnKHkQpZqz8LzK3EIVQZqqymtg9rcKQ=
Content-Disposition: inline
In-Reply-To: <20230221143421.10385-1-matthew.chae-VrBV9hrLPhE@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Matthew Chae <matthew.chae-VrBV9hrLPhE@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-VrBV9hrLPhE@public.gmane.org, christopher.wong-VrBV9hrLPhE@public.gmane.org, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--q22yp5mylqojoxly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Matthew.

On Tue, Feb 21, 2023 at 03:34:20PM +0100, Matthew Chae <matthew.chae-VrBV9hrLPhE@public.gmane.org> wrote:
> The kernel currently doesn't provide any method to show the overall
> system's peak memory usage recorded. Instead, only each slice's peak
> memory usage recorded except for cgroup root is shown through each
> memory.peak.

The memory.peak value is useful as a calibration insight when you want to
configure memcg limit.
But there is no global (memcg) limit on memory. So what would be this
(not clearly) defined value good for? Or better then userspace sampling
of chosen available metric?

Thanks,
Michal

--q22yp5mylqojoxly
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY/d2QgAKCRAkDQmsBEOq
uZKPAP0XDln51ca97Q7J1pGYE4mYyE5HiobHbhWmbtWeDr85qwD9GTceOFjkX9Xb
q33nFRFD1ixImjgy/z6X9cnP0dK/WQ4=
=3ruE
-----END PGP SIGNATURE-----

--q22yp5mylqojoxly--
