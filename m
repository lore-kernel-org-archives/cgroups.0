From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 06/11] cgroup: fix -Wzero-length-bounds warnings
Date: Tue, 30 Mar 2021 10:41:34 +0200
Message-ID: <YGLkPjSBdgpriC0E@blackbook>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-7-arnd@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Gbn4BprmVLVWv2rO"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617093697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jiLzz+FDg8IDgOr7Ru1IW7IRXYaqlH8yrJkDxBSOd+M=;
        b=SwyQOSqvaO5avOz2XsxkAeyYpWcAxuEpeTup5y2W/3hjoJIa9VL+ySLWFEDXOGMXYYzaNj
        yfuPCkvCrHUDqDn4OiHjX+VW5qEwgFf/bjJtmVzQs0eem+tKxgSvbAVrRlz0EIt6ankmR8
        9g4gU0a0vUOWreF+dSJDr1Ih1BW0A9I=
Content-Disposition: inline
In-Reply-To: <20210322160253.4032422-7-arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, ath11k-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--Gbn4BprmVLVWv2rO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2021 at 05:02:44PM +0100, Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> w=
rote:
> I'm not sure what is expected to happen for such a configuration,
> presumably these functions are never calls in that case.
Yes, the functions you patched would only be called from subsystems or
there should be no way to obtain a struct cgroup_subsys reference
anyway (hence it's ok to always branch as if ss=3D=3DNULL).

I'd prefer a variant that wouldn't compile the affected codepaths when
there are no subsystems registered, however, I couldn't come up with a
way how to do it without some preprocessor ugliness.

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--Gbn4BprmVLVWv2rO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBi5DcACgkQia1+riC5
qSjuqxAAkm/zoS+xvdcQUERzkcuVxIruGtTqOse/NCPQQR9aGuJl6iybyjQw7D+r
63+BYz7+BdP8zDg+NSTO354Yt0vsWFtCvuZBBabO91wCheLRPaZhHnGByJa0fXyM
SKC2VSvFHKKiFuCG7mG7/WfDQxTGSaUL2jiFXlA5HAV5dKfkia/Jpuf+KtIy5nBR
g8g4f44M2wW/TCoBzd5Elt5Cpx6fU2aKuJRCRCE04ts4CQy06/lLcc9H0N7bvgHj
0oxkHbAjXeEnylnni4pfpmJpInUT2kOZuCjSF/WPw2XeLs00AnBnNB3lDP9Pe2qo
ippcDc3AFqYMqewKnnxDWoTI3lyMTm8r0yzrDdwpb9Zv28bOCAYiwyoIsFV7+kdN
C7DnhiL6d+UgKIzCqRuTPXnluthvSmHGzeblqF1vOAaWOFif4CcRmUtsR7v3EyZN
5aiUTGqVtoKr/pcBNnRU1e2w7ulYpq5sbL/8f9HtnKsZ8MZlLdhdcDoSLjOkuohK
OlQgS6p+2otxwk3xft0CdFPPHAFb5/WM6IyKdewFGuY0fohxczWJCRI92x94cfe9
p0JSNLl19JjdM8loYpmBRcmlkoBH+MtkdZiR68b5yX5wcXypubmZPZ9o8ZzQqx1j
ZX1/nhuyDl6KHuGW7gJXx8FhCLd6nPyKYVu4wbay23oLzdL/1sk=
=nVTO
-----END PGP SIGNATURE-----

--Gbn4BprmVLVWv2rO--
