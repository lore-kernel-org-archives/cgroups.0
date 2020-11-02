From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [QUESTION] Cgroup namespace and cgroup v2
Date: Mon, 2 Nov 2020 15:09:21 +0100
Message-ID: <20201102140921.GA4691@blackbook>
References: <d223c6ba-9fcf-8728-214b-1bce30f26441@oracle.com>
 <20201027182659.GA62134@blackbook>
 <001e7b1d-1b7c-e3d8-493f-2b78b3b093b1@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604326166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rzClJdernid9DZjs+LXc6mlLzbVlffJS5KXlyFdrG7k=;
        b=tr4G+t5mSX8DExPZbrwb/Ed7X0gqPsFbeubq83nMeARlFpnqMZdUw4gIWg0Um2N+YHYB7D
        yCf1YBjpV4s+aJddXnFy2FRXXzNZoZNnAejIJWU/pUA8LxrTcxC7aJs8LDEyJcmytW6VBV
        d4zA+2Ezl6g3eH23z57HF/LJKBcDJUs=
Content-Disposition: inline
In-Reply-To: <001e7b1d-1b7c-e3d8-493f-2b78b3b093b1-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2020 at 07:11:20AM -0600, Tom Hromatka <tom.hromatka@oracle=
=2Ecom> wrote:
> Would you mind sharing some of the other discrepancies?=A0 I
> would like to be prepared when we run into them as well.
Search for CFTYPE_NOT_ON_ROOT flag (that was on my mind above). It
causes a visible difference between host and container (OTOH, you won't
be able to write into such files typically, so that's effectively equal
to the host).

Michal


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl+gEwwACgkQia1+riC5
qSifaA/+N7Jnx5DhGUIqKKYkuMebh/f49HQhMhigXv8N4qLNUGNwWqgP0wEP69Ex
SzwHoiw5S/cuqziGASB4DKdzcmdfLKK2dER1NZccT6aDjPbjBveCHA4L8BEf1piX
PwrEPoZBR6hBaHBSndn+S2fQecmB7WvZjfRxFol0VivCi+DWgNfNlRZyJHml17nA
i7J/xc5mgxpceZP2xhyw8S5LSgtYXdWIQqEbYEotRg7r0dhvt3BMAszDtu8asmBB
NKnkExNTi6f7Cw3P4EzI2/UUcYTUgD4NoDSAWIbx3NbmTWeYjAqhj0kpG4WJw87g
5TA2kohDozxzX1A+BFjg5yX50CoVZvXEuufbgjCNuWXVcZL1ft+8YUfSiHL/TH0b
9TMYUiFp7Yqv7Wyf5P5V+HSSPr1gtJrjkuzjGaTs1rCeFn2I2OcJvVBf4lV53FzS
iCXQS90w58yUuABF9U0eObciB+nqsM1k8/FjSFz0eJvCRe7X38jrrEk1zsOUZoDR
BiLDD0jhyQ8jZv6uozs5N8Z5pzCaF4XvZZRrekvfPUKVWFaND+AA+wiiFz5mQvMO
ULfM+HKWDH4YOsmc5qQq20Zf+vKtVAVLoV0ibrorimgh8gqj1HMDStYm2JGKFx2B
UJjVTHiBa+OmdtCZrnL/kmjwKbGnAd9etDSMCLwUY1faSkfv9zA=
=QbyZ
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
