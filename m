From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 2/2] PM/hibernate: remove the bogus call to get_gendisk
 in software_resume
Date: Fri, 25 Sep 2020 20:38:28 +0200
Message-ID: <20200925183828.GC7253@duo.ucw.cz>
References: <20200925161447.1486883-1-hch@lst.de>
 <20200925161447.1486883-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200925161447.1486883-3-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Minho Ban <mhban-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> get_gendisk grabs a reference on the disk and file operation, so this
> code will leak both of them while having absolutely no use for the
> gendisk itself.
>=20
> This effectively reverts commit 2df83fa4bce421f
> ("PM / Hibernate: Use get_gendisk to verify partition if resume_file is i=
nteger format")
>=20
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  kernel/power/hibernate.c | 11 -----------
>  1 file changed, 11 deletions(-)
>=20
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index e7aa57fb2fdc33..7d0b99d2e69631 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -948,17 +948,6 @@ static int software_resume(void)
> =20
>  	/* Check if the device is there */
>  	swsusp_resume_device =3D name_to_dev_t(resume_file);
> -
> -	/*
> -	 * name_to_dev_t is ineffective to verify parition if resume_file is in
> -	 * integer format. (e.g. major:minor)
> -	 */
> -	if (isdigit(resume_file[0]) && resume_wait) {
> -		int partno;
> -		while (!get_gendisk(swsusp_resume_device, &partno))
> -			msleep(10);
> -	}

I believe point of this code was to wait for resume device to appear
-- see the resume_wait condition. It should not be simply removed.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX245JAAKCRAw5/Bqldv6
8nqrAJ9qEdwnZpnNgalnaGH1r71lg+ujCQCfdWZzlCzS9I0pHUwKmZCAgAYm75o=
=9GW2
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
