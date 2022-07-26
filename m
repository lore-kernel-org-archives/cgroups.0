From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH RESEND 3/3 cgroup/for-5.20] cgroup: Make !percpu
 threadgroup_rwsem operations optional
Date: Tue, 26 Jul 2022 16:32:57 +0200
Message-ID: <20220726143257.GA23882@blackbody.suse.cz>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
 <YtwFjPnCtw8ySnuv@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658845979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GmzxlrD4MfGqasLwf7DeQPvyp1YsjrHWacTayMiVBgs=;
        b=VzaexPvcMynfjlBtImA2nTgG3+dH5jaMLEtGNj2QeksXbstkDRq1u8e7ogp2JZUAqJFhEK
        +TgJXVLp7L7TwUNj+MkJRDnMCThwYCv0CKz6ZWhZFabsQjJMSm9ABubb+3Vf685KftagjK
        IyigtmDwXokwRz35tcgFW3KQ/BGxWfg=
Content-Disposition: inline
In-Reply-To: <YtwFjPnCtw8ySnuv@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, John Stultz <john.stultz@linaro.org>, Dmitry Shmidt <dimitrysh@google.com>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 23, 2022 at 04:28:28AM -1000, Tejun Heo <tj@kernel.org> wrote:
> This makes the hotter paths - fork and exit - slower as they're always
> forced into the slow path. There is no reason to force this on everyone
> especially given that more common static usage pattern can now completely
> avoid write-locking the rwsem. Write-locking is elided when turning on and
> off controllers on empty sub-trees and CLONE_INTO_CGROUP enables seeding a
> cgroup without grabbing the rwsem.

Just a practical note that CLONE_INTO_CGROUP may not be so widespread
yet [1][2].
But generally, the change makes sense to me.


> +	CGRP_ROOT_FAVOR_DYNMODS =3D (1 << 4),
> +
> +	/*
>  	 * Enable cpuset controller in v1 cgroup to use v2 behavior.
>  	 */
> -	CGRP_ROOT_CPUSET_V2_MODE =3D (1 << 4),
> +	CGRP_ROOT_CPUSET_V2_MODE =3D (1 << 16),
> =20
>  	/*
>  	 * Enable legacy local memory.events.
>  	 */
> -	CGRP_ROOT_MEMORY_LOCAL_EVENTS =3D (1 << 5),
> +	CGRP_ROOT_MEMORY_LOCAL_EVENTS =3D (1 << 17),
> =20
>  	/*
>  	 * Enable recursive subtree protection
>  	 */
> -	CGRP_ROOT_MEMORY_RECURSIVE_PROT =3D (1 << 6),
> +	CGRP_ROOT_MEMORY_RECURSIVE_PROT =3D (1 << 18),

Why this new gap in flag bits?

[1] https://github.com/systemd/systemd/pull/16706
[2] https://github.com/search?q=3Dorg%3Aopencontainers+CLONE_INTO_CGROUP&ty=
pe=3Dall (empty)

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYt/7FwAKCRAkDQmsBEOq
uUu7AQCTUIpH8K9WfOjrd4atmJg3ivYL9Dq6gqtpvNZrS7XStgD+Prz9fzwjGXvO
Fw86GZpQI02CRHvZdUw+lRMJ8r7qhAQ=
=bB6g
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
