From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 1/4] cgroup/cpuset: Wake up cpuset_attach_wq tasks in
 cpuset_cancel_attach()
Date: Wed, 5 Apr 2023 10:30:48 +0200
Message-ID: <20230405083048.rjmmcgi5pf2fghl5@blackpad>
References: <20230404170546.2585050-1-longman@redhat.com>
 <20230404170546.2585050-2-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dotmodrsnhmcfw25"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680683449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qYT3efqmHupYQzBMEWpHyiW3zRVpGSvNxrK3q6d/Z5Y=;
        b=BiTyZQ4po4bomPYKWo6d6qsQRVFEIhovjNpaQ1YKONLThAsO7Ylz7XJ90Fo6co43jdLMkp
        +EWnfAaHoLX4M2fGMYspnxpyRRtwf08nJryPJ2V3n2x4WDuiV+ZcV8Odwhn0ttX52OoPLW
        tykNg3ZsU50ztNG7wI7cIKyqQlTVuAk=
Content-Disposition: inline
In-Reply-To: <20230404170546.2585050-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


--dotmodrsnhmcfw25
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2023 at 01:05:43PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>  kernel/cgroup/cpuset.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--dotmodrsnhmcfw25
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZC0xswAKCRAkDQmsBEOq
ucxiAP9ShvWz5fRrmtWn2/9Q3HBI+48SYFw86Qmn/mUFBG5qSAD/Rs+iroyu1MsW
+1iL+QZz6CNF+O4heMZjFBjMmY+ieAY=
=phxN
-----END PGP SIGNATURE-----

--dotmodrsnhmcfw25--
