From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 06/11] cgroup: fix -Wzero-length-bounds warnings
Date: Tue, 30 Mar 2021 16:44:52 +0200
Message-ID: <YGM5ZJlK1V7ex9xR@blackbook>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-7-arnd@kernel.org>
 <YGLkPjSBdgpriC0E@blackbook>
 <CAK8P3a3nUCGwPpE+E820DniY8Haz1Xx72pA38P6s5MWsbi0iAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9pRQkLwCQMovNrXD"
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617115495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=llTp9KMmNhLgpFrt/A/4gk0SgpNaUf1ZpYpNvho6oEk=;
        b=iKbol1UC2cYC03I2rvUtoSu92j1pz2tv1L6/9iiw7cxLhRzh90EQvV5vkd5t59I4w79b5z
        //6Ea77uYBp+fXZGWtXmCr26hrFxJVsTlICwAL4byi52zB9FKuPbHVzN1zqRgW2z3Slp3o
        4tg7hayC693qItZd+Jni902Xu3F2GZQ=
Content-Disposition: inline
In-Reply-To: <CAK8P3a3nUCGwPpE+E820DniY8Haz1Xx72pA38P6s5MWsbi0iAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Intel Graphics <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, ath


--9pRQkLwCQMovNrXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 30, 2021 at 11:00:36AM +0200, Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Would it be possible to enclose most or all of kernel/cgroup/cgroup.c
> in an #ifdef CGROUP_SUBSYS_COUNT block?
Even without any controllers, there can still be named hierarchies (v1)
or the default hierarchy (v2) (for instance) for process tracking
purposes. So only parts of kernel/cgroup/cgroup.c could be ifdef'd.

Beware that CGROUP_SUBSYS_COUNT is not known at preprocessing stage (you
could have a macro alternative though).

> I didn't try that myself, but this might be a way to guarantee that
> there cannot be any callers (it would cause a link error).
Such a guarantee would be nicer, I agree. I tried a bit but anandoned it
when I saw macros proliferate (which I found less readable than your
current variant). But YMMV.

Michal

--9pRQkLwCQMovNrXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBjOV4ACgkQia1+riC5
qSgZNQ/9FFBZs5QQqEUHmbWyF9O2R2bGF8WCBz56zh+F2OZf+/GK7z4OGhkKUlEa
1lPOUoibt4aZZhWD30RcfB3i3qJ8VqY3wqwnS6W9uN9+sU22sgsx/elCqiua3EnM
4tGDRcLBfSuktgPo1T0oNvGGbFnFJ0kUenLZ6mVkWlSTzx8kp/B8h4S5LkYmRIov
fVmHURht22FPiA8wwlUb9LAp8ONF+68t6BtMWNmZbqmJ17qHSnLyQQUiHIHytASt
xgaQCJU8/nrtv2xPfp66aCQLO12b6OxpjPoRxo1hj9IP5HZPukzNDat/VaWyh0iE
t9GO85K0PVqcuvJpymes0yRT6RvEwlqEna0T+qbh+qih4S3+xRm/Js5IV5m8KfIc
wWUve4llNT1jq6zzgn28FkXe9coH7ybpwBaWeAdwEM3Wl9GvXimKwIQqg+3ZDnm4
CbDVh6scYVu3kFYHVy6ld5+fG2GWEKvNL+9AVH+wsXUb6OXtyOtxD3FWyiVVYBkl
Q4N0KWETd67BNb2NklxTkeC4hYusuHeFvxa9Ki6K6zbdxDxVwdcTWpWFVkTDs45S
sEVkmsPU9pLu5vm5o9kBCmr6q1lW6yzudcxBvcvcHXGQnkfcmDCo+C3OEwKzKUeh
8+BhDV9zMpKBpJfuPiI8UNIt8sI7YeTpjdk14YjWYQTgZCHc7WU=
=iFNx
-----END PGP SIGNATURE-----

--9pRQkLwCQMovNrXD--
