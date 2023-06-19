From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem
 isolation
Date: Mon, 19 Jun 2023 19:30:44 +0200
Message-ID: <4p22vtjrpu4obmbjivgpe635gbpjmhsfisnxghgsson2g6yy5r@ovawhchw7maq>
References: <20230609082712.34889-1-wuyun.abel@bytedance.com>
 <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
 <b879d810-132b-38ab-c13d-30fabdc8954a@bytedance.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gmi7m3lyy75eha77"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1687195846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xQFY7fZePp2Fj2uiaSid1me/iXz0lajB7QFNjTT4+ls=;
        b=pQDFDQhHXe7phJt2fLX6ATZgBbeZhDTeziVy/2jZ2ixsWgmpbNLBNi7nbpYLDA8l/FFmcP
        TF2KLLk5U5yCq8QR0WdQC1HSOfTQDoivDzVuA9P7h1z4nK7a78h/gLR2/pNN2LoyLBKUhc
        /iogDsjyLttIrG2Z6PpDRYlw0dAv8hs=
Content-Disposition: inline
In-Reply-To: <b879d810-132b-38ab-c13d-30fabdc8954a-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Warloe <cwarloe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Xi


--gmi7m3lyy75eha77
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 13, 2023 at 02:46:32PM +0800, Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> Memory protection (memory.{min,low}) helps the important jobs less
> affected by memstalls. But once low priority jobs use lots of kernel
> memory like sockmem, the protection might become much less efficient.

What would happen if you applied memory.{min,low} to the important jobs
and memory.{max,high} to the low prio ones?

Thanks,
Michal

--gmi7m3lyy75eha77
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZJCQwgAKCRAGvrMr/1gc
jlfqAP4n8Ka+X+iVeFLtQT/sbo8Dudkos2fyhrkWo0/AJG9aogD9GEihJOOgAxk9
aCoZ0Kwdy6zyeUy+7PVrsCAOIKJHJQc=
=1Q4d
-----END PGP SIGNATURE-----

--gmi7m3lyy75eha77--
