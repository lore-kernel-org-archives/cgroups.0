From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [RFC PATCH 3/3] cgroup: Do not take css_set_lock in
 cgroup_show_path
Date: Fri, 5 May 2023 19:32:40 +0200
Message-ID: <ta7bilcvc7lzt5tvs44y5wxqt6i3gdmvzwcr5h2vxhjhshmivk@3mecui76fxvy>
References: <20230502133847.14570-1-mkoutny@suse.com>
 <20230502133847.14570-4-mkoutny@suse.com>
 <ZFUktg4Yxa30jRBX@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rylaem3izw3vqdtr"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683307962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=08FuX13wN9U4YYw2axhJqWpBUnoUcHOE2BMKcuHHIII=;
        b=dSvKo4grqGLt7OmzVg7CvER57EhkmRq43a6GttLWDA5VsTzGOjkr03cZx88FUETDQfnQKQ
        +6cC/JbCvornmP+fW+kmIflQXd0nBQ67ryVRD/tVNdVe9L3/bISJGQv+7ggjZLE7hzD8fN
        UuFbRmICbHw5Y0K1bER7vze628L+ysM=
Content-Disposition: inline
In-Reply-To: <ZFUktg4Yxa30jRBX@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <dchinner@redhat.com>, Rik van Riel <riel@surriel.com>, Jiri Wiesner <jwiesner@suse.de>


--rylaem3izw3vqdtr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 05, 2023 at 05:45:58AM -1000, Tejun Heo <tj@kernel.org> wrote:
> > There are three relevant nodes for each cgroupfs entry:
> >=20
> >         R ... cgroup hierarchy root
> >         M ... mount root
> >         C ... reader's cgroup NS root
> >=20
> > mountinfo is supposed to show path from C to M.
>=20
> At least for cgroup2, the path from C to M isn't gonna change once NS is
> established, right?

Right. Although, the argument about M (when C above M or when C and M in
different subtrees) implicitly relies on the namespace_sem.

> Nothing can be moved or renamed while the NS root is there. If so,
> can't we just cache the formatted path and return the same thing
> without any locking?

Here I find the caching complexity not worth it for v2 only (also C is
in the eye of the beholder) -- because then css_set_lock can be dropped
=66rom cgroup_show_path with simpler reasoning.

(Sadly, the bigger benefit would be on hybrid setups multiplied by the
number of v1 hierarchies listed.)

(OTOH, the caching argument and weights for it may be different for
/proc/$pid/cgroup.)

> The proposed changes seem a bit too brittle to me.

OK, I'll look into separate cgroup_show_path and cgroup1_show_path
approach.

Thanks,
Michal

--rylaem3izw3vqdtr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZFU9swAKCRAkDQmsBEOq
uSoLAQD754ptzc5v4SJdwNDmNSnDSByFIjlKbnAxKHci/pO4ywD+MIDAb1A+syAS
I2WGGvHWDmD2tCQtQb85PVVcokfqkQ0=
=uY1H
-----END PGP SIGNATURE-----

--rylaem3izw3vqdtr--
