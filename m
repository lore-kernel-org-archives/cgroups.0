From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup/cpuset: Make cpuset_attach_task() skip
 subpartitions CPUs for top_cpuset
Date: Mon, 3 Apr 2023 18:35:19 +0200
Message-ID: <20230403163519.6xyb66firoqm5eti@blackpad>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-3-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dt4gx7d3cwpgnbwk"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680539720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YumwonmjqV5t8gQykDIe5ctbpkmmD9ZrmoXWSUWe1do=;
        b=N0VbH0/+8edCmRFNoLs7Nov6WXcDZGyB9J97iFTrRiHXqz+LakqSg32CAN27DF4AynJUnB
        vLQQRta/XZsWkTZ+dE/8+egPOtY3Z/0K0XvulUL8oleP+EuBeYYM1i9+6MDWZ8o9BwA0x2
        lWs9+7ZOlxpKoXxG2HxY84tAqA1l2SM=
Content-Disposition: inline
In-Reply-To: <20230331145045.2251683-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


--dt4gx7d3cwpgnbwk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, Mar 31, 2023 at 10:50:44AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> It is found that attaching a task to the top_cpuset does not currently
> ignore CPUs allocated to subpartitions in cpuset_attach_task(). So the
> code is changed to fix that.
>=20
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cpuset.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--dt4gx7d3cwpgnbwk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCsAPwAKCRAkDQmsBEOq
ue7hAQCSejv7qXqOG2OYhV4G4WEbQ0/ok1yV2453mEPMO20QoQEArOj5iQ9yrLXt
pXQCdi4gTkstrXHCQ5IzHq1FFQO2jgU=
=Rr4W
-----END PGP SIGNATURE-----

--dt4gx7d3cwpgnbwk--
