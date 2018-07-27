From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Sat, 28 Jul 2018 00:01:23 +0200
Message-ID: <20180727220123.GB18879@amd>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The idea is to eventually incorporate this back into the kernel, so
> that Linux can avoid OOM livelocks (which TECHNICALLY aren't memory
> deadlocks, but for the user indistinguishable) out of the box.
>=20
> We also use psi memory pressure for loadshedding. Our batch job

psi->PSI?

> 		How do you use this feature?
>=20
> A kernel with CONFIG_PSI=3Dy will create a /proc/pressure directory with
> 3 files: cpu, memory, and io. If using cgroup2, cgroups will also

Could we get the config named CONFIG_PRESSURE to match /proc/pressure?
"PSI" is little too terse...

								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltbljMACgkQMOfwapXb+vJangCfazQXvp2udMeXISRfTR8kVg3Q
ReIAn1U+vmdcDISLPazXCUbd2cAXPJJI
=ua6C
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
