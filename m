From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle
 CLONE_INTO_CGROUP properly
Date: Mon, 3 Apr 2023 18:55:23 +0200
Message-ID: <20230403165523.aphsec2epqi72k27@blackpad>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-2-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hqjzbb4yslshnocc"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680540924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YjHTDLKnu47Af8/RYRI8Ep8eWiGDBHSZDf7lS1gT7w8=;
        b=CEfOfG3UaWRbtseNKY9DpsYv+24G2DErlSrzrBLWXwn7D9NOSFcy7jOqZsSWAfOKQNB9vC
        w0OKgbKTVzYTREfxDKWgjtGaNzyYHCFpfTVzLWYiCgrnFjS4xOKNhnoFEkauyNHAIded4E
        9b1BuHPOi+OUq7CGt3aCyfpOT1O7Hcs=
Content-Disposition: inline
In-Reply-To: <20230331145045.2251683-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


--hqjzbb4yslshnocc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 31, 2023 at 10:50:43AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> By default, the clone(2) syscall spawn a child process into the same
> cgroup as its parent. With the use of the CLONE_INTO_CGROUP flag
> introduced by commit ef2c41cf38a7 ("clone3: allow spawning processes
> into cgroups"), the child will be spawned into a different cgroup which
> is somewhat similar to writing the child's tid into "cgroup.threads".
>=20
> The current cpuset_fork() method does not properly handle the
> CLONE_INTO_CGROUP case where the cpuset of the child may be different
> from that of its parent.  Update the cpuset_fork() method to treat the
> CLONE_INTO_CGROUP case similar to cpuset_attach().

Should .can_fork=3Dcpuset_can_fork in analogy to cpuset_can_attach be also
devised? (Sorry if I missed that in the previous discussion.)

>=20
> Since the newly cloned task has not been running yet, its actual
> memory usage isn't known. So it is not necessary to make change to mm
> in cpuset_fork().
>=20
> Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Michal

--hqjzbb4yslshnocc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCsE9gAKCRAkDQmsBEOq
uXNEAP4yZWUDQPS5MdBJKxg7KPFXijvx7boOQCgxkNjZYray+wD+JXdFvFEi1rKM
oOJu9alNdUlt9cXh0vK+1QGgfk7KggQ=
=9fk7
-----END PGP SIGNATURE-----

--hqjzbb4yslshnocc--
