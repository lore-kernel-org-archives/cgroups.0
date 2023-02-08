From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 1/2] sched/psi: simplify cgroup psi retrieving
Date: Wed, 8 Feb 2023 18:17:22 +0100
Message-ID: <20230208171722.GE24523@blackbody.suse.cz>
References: <20230208161654.99556-1-ryncsn@gmail.com>
 <20230208161654.99556-2-ryncsn@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675876643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oKiKDcbX0O3C0B5XD/0OrKN1mlV/CCJFvoMfJCxlhbI=;
        b=lWaEd33QaHTanA50H4oKn1xkRJTVCdWnoCf0A/vduJWWyNtpD241CG6E07XTVjUv11eFWo
        ki6GQxVQvonR5jhFfwsVJOZPhfsoUD3UIJzgBWxkcHG7QveRZuXVr069rAKLn30yHjbJJw
        51UnzDqzVuraHYyBoEhLfLdBUdNMFpc=
Content-Disposition: inline
In-Reply-To: <20230208161654.99556-2-ryncsn@gmail.com>
List-ID: <cgroups.vger.kernel.org>
To: Kairui Song <kasong@tencent.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>, Chengming Zhou <zhouchengming@bytedance.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 09, 2023 at 12:16:53AM +0800, Kairui Song <ryncsn@gmail.com> wr=
ote:
>  include/linux/psi.h    | 2 +-
>  kernel/cgroup/cgroup.c | 7 ++++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY+PZIAAKCRAkDQmsBEOq
uXmaAP9GahvmyU1IMscq/W8nIcRpdXXf5uzJ2rdXIi3O0wGeogEApX/xE7jsIBDr
aJiP9He48sQ6TTXy0X0NtNU45JjqvQg=
=h2+9
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
