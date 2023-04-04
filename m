From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup/cpuset: Allow only one active attach
 operation per cpuset
Date: Tue, 4 Apr 2023 11:07:37 +0200
Message-ID: <20230404090737.3g3uxga52bojgdu5@blackpad>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-4-longman@redhat.com>
 <20230403164736.lpjdpzxxnjlpxrqv@blackpad>
 <24b67530-62ce-4f9c-7b74-d41d2ccc710e@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ilogas4aec7si4wz"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680599258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rp1byrR7s3fkY4PjvvNsxVQi+oUszqEO+iMKVPDKdIk=;
        b=vN5Ed2ujeDnWAjclyPn/8Eom7F+TJM78c7KtgnToFgnIAyfD/Aqnrk2NbDUMKyifUwUr3n
        1Z0YS0qvLrdWg5nhZro2NuiBBACFME+zaWDHYJj5dEu53In+Z1Nw3swHJXTXv6oHw5ffoW
        rhiePGvP9y7/aefjEMuTGxZqtjWmjIc=
Content-Disposition: inline
In-Reply-To: <24b67530-62ce-4f9c-7b74-d41d2ccc710e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


--ilogas4aec7si4wz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi.

On Mon, Apr 03, 2023 at 01:41:33PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This patch is actually not related to the CLONE_INTO_GROUP problem in patch
> 1. It is a generic problem when multiple users are moving threads into
> cgroup.threads of the same or different cpusets simultaneously.

I meant this:
	__cgroup_procs_write
	  cgroup_kn_lock_live
	    mutex_lock(&cgroup_mutex)

and (more succintly)
	cgroup_update_dfl_csses
	  lockdep_assert_held(&cgroup_mutex)

Even the threaded migrations should be synchronized here.
Can you please explain in more detail what's the problematic case?

> I don't believe this patch has a dependency on patch 1.

(I meant the opposite, patch 1 would depend in this 3/3. But maybe this
one isn't need.)

Michal

--ilogas4aec7si4wz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCvoyAAKCRAkDQmsBEOq
uWSoAP41lQ11CXnVKE2G4jMF7tULituGE65Jni9yu8QGOPvQEAD/cthzkgC2745v
rrgDBOyUhh+6zjNzCq6nigOTN7j16w8=
=z1SR
-----END PGP SIGNATURE-----

--ilogas4aec7si4wz--
