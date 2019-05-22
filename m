From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Fix comments with paths pointing to renamed or moved
 files.
Date: Wed, 22 May 2019 20:36:14 +0200
Message-ID: <20190522183614.GD10003@amd>
References: <20190521155430.14941-1-langspielplatte@black-mesa.xyz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sXc4Kmr5FA7axrvy"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190521155430.14941-1-langspielplatte@black-mesa.xyz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Lukas Prause <langspielplatte@black-mesa.xyz>
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, will.deacon@arm.com, rjw@rjwysocki.net, len.brown@intel.com, rostedt@goodmis.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-pm@vger.kernel.org, Lennart Glauer <mail@lennart-glauer.de>


--sXc4Kmr5FA7axrvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-05-21 17:54:30, Lukas Prause wrote:
> This patch corrects renamed or moved paths in comments.
>=20
> Signed-off-by: Lukas Prause <langspielplatte@black-mesa.xyz>
> Signed-off-by: Lennart Glauer <mail@lennart-glauer.de>

Acked-by: Pavel Machek <pavel@ucw.cz>

> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 9e58bdc8a562..5de8b0c7f657 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -182,7 +182,7 @@ extern int swsusp_unmark(void);
>  #endif
> =20
>  struct timeval;
> -/* kernel/power/swsusp.c */
> +/* kernel/power/hibernate.c */
>  extern void swsusp_show_speed(ktime_t, ktime_t, unsigned int, char *);
> =20
>  #ifdef CONFIG_SUSPEND

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--sXc4Kmr5FA7axrvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzllp4ACgkQMOfwapXb+vJZkQCfeKwSOh2FKYaMG98zV3Dzre+t
L5cAoIt7HOw2sWn9bbsMWeOfbg1PjNGy
=AwUp
-----END PGP SIGNATURE-----

--sXc4Kmr5FA7axrvy--
