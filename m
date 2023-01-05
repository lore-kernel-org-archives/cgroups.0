From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/10] docs: cgroup-v1: formatting improv for "Memory
 Resource Controller" doc
Date: Thu, 5 Jan 2023 16:58:41 +0700
Message-ID: <Y7afUbFCdrHzebRO@debian.me>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
 <Y7XvS5LJK01lWq48@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="p5biEVtF7dmtOC3S"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eGriBr9FHpvs0SauQeUGJ1InK5l2j7/+3cssO4S/h24=;
        b=TolsQSFh6FHbuxIU2puCecqWwoajTx8yNv++zWEdF23ZhpClghzz0Bf2TFkzhKMFYX
         c4glMtxaBmOTKDkPOIK+wkCijRmQ+qvzCfJcMBVrji2ji+XFbRYfRiuRg5HH02Fc+bmJ
         d7gP9ytD+jTqYhIbN7urYGJHmMrJW9eyW67OJwoqrly2nOYpHO783tPb7nBZSnjLi4eL
         moHO5NNv4uKezk/s9/+FL3Nef3aFKd+Gmq8g3M81kz3y7eoMrda7WIijutzz//90n5jY
         8aJQ29RO88qRrsBNSN/NWjAFVTDxt3is7Jg04ZAtW1eh/T2JVOYoLAVTJ/Fr8879VV2L
         YB7A==
Content-Disposition: inline
In-Reply-To: <Y7XvS5LJK01lWq48-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


--p5biEVtF7dmtOC3S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 04, 2023 at 11:27:39AM -1000, Tejun Heo wrote:

> Patchset doesn't apply. Can you please rebase on top of linus#master and
> drop reference to the commit in -next?
>=20

OK, thanks!

--=20
An old man doll... just what I always wanted! - Clara

--p5biEVtF7dmtOC3S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7afTAAKCRD2uYlJVVFO
o20CAP9agXmFSnMIIo3uAuVlbWnWPPFlhc+75GAJz7qxeDkyBQEAt2cQhrJpxceg
a5OPlyiPBkrdCN+5nsP55ULJSSo2MAc=
=vANI
-----END PGP SIGNATURE-----

--p5biEVtF7dmtOC3S--
