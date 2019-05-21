From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Tue, 21 May 2019 15:47:30 +0200
Message-ID: <20190521134730.GA12346@blackbody.suse.cz>
References: <20190408214539.2705660-1-songliubraving@fb.com>
 <20190410115907.GE19434@e105550-lin.cambridge.arm.com>
 <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Song Liu <songliubraving@fb.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, Kernel Team <Kernel-team@fb.com>, "peterz@infradead.org" <peterz@infradead.org>, "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Song.

On Wed, Apr 10, 2019 at 07:43:35PM +0000, Song Liu <songliubraving@fb.com> =
wrote:
> The load level above is measured as requests-per-second.=20
>=20
> When there is no side workload, the system has about 45% busy CPU with=20
> load level of 1.0; and about 75% busy CPU at load level of 1.5.=20
>=20
> The saturation starts before the system hitting 100% utilization. This is
> true for many different resources: ALUs in SMT systems, cache lines,=20
> memory bandwidths, etc.=20
I have read through the thread continuation and it appears to me there
is some misunderstanding on the latency metric (scheduler latency <=3D
your latency <=3D request wall time?).

Could you please describe how is the latency that you report defined and
measured?

Thanks,
Michal


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+amhwRV4jZeXdUhoK2l36XSZ9y4FAlzkAW4ACgkQK2l36XSZ
9y6i5Q/+PtvIsPw08gmvSIO/fdv4U5u+tI7WHJcUXGWD+sTVdVSlB+MWDfdlblUH
HIyGgIBDGL184mq4kiYzxvSMPyorrtlI2Nbvq9SYqLJWPnZGMTWtOgVgb7roVJQG
xk96LUF3nmWjy6wU5wY0GD3J1yaygsqMLOuCP9LQLx8Mqv7yZ5xY+J98Sdm6s1Uo
y9ePTJLq8r8vA/oHSaLyRTiQeN+QYnFmqJvMaqdImM9FH9pO6WADa1Hp/UfN6KT5
06NwWzaqPJ1e5JZqZ5DZMKZSCaLHNS7pywwuTgHgxoGacbBYywQ3VOF67SDwb5zK
oOsE0YL//9Wd2cH6qh3i5301z+lx+WvFyXu3hnKBUKt2RzlT/CqwickpZxamJ3Pk
PtV/7U/gJV404Z2TXE1cMOwfEfgjIE2WanjfMSyIuhkdxGjruQ0Ik+9DDIWMed08
lgH33hEOLGu1qK4TKVXR/MJjdsUNAR60c4SgAWB5oc9hSjrdFDV9wD+UWviizgjM
WMasTRwVoOaP2H9iiXlXQXX2Tei04aHR2fbW0XawsFO/bne47S/r4eHL2TvxuRZR
W/6Q5p5o4nHvOuRQpZ2zTQ5/SXpcRSMHM7xnvxNzFJxjiR3LJmVb1fsGv7D+xIY4
J74b5569lroFCynIj+8XxVv21JHeVtBgYEH2HKUowuk6/DyftnE=
=vB4R
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
