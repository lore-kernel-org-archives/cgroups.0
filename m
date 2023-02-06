From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 1/2] sched/isolation: Merge individual nohz_full features
 into a common housekeeping flag
Date: Mon, 6 Feb 2023 16:51:09 +0100
Message-ID: <20230206155107.GA31453@blackbody.suse.cz>
References: <20230203232409.163847-1-frederic@kernel.org>
 <20230203232409.163847-2-frederic@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675698670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7fhVqQ68veOG9L/p1SZuHOGXVu/+YnsgNDr8L++Nf6Y=;
        b=hasfkwf5qLMSjdjBN6tNl9erNVm4U6hoHsFNNv8OenccPiydH09u+yHslUPouNtKnn2j4N
        IRgHQtzLbkOt8iKWYtUOv6bo1JcUIFxWHwPmp2gSgcxRDuF2Ctx5P6pQwAe+dzYWZqeVsp
        54yNNtbDWOGQDl97k5EHhRinkwPr6Gw=
Content-Disposition: inline
In-Reply-To: <20230203232409.163847-2-frederic@kernel.org>
List-ID: <cgroups.vger.kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@suse.com>, Marcelo Tosatti <mtosatti@redhat.com>, Leonardo <leobras@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, cgroups@vger.kernel.org, linux-mm@kvack.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Frederic.

On Sat, Feb 04, 2023 at 12:24:08AM +0100, Frederic Weisbecker <frederic@ker=
nel.org> wrote:
> The individual isolation features turned on by nohz_full were initially
> split in order for each of them to be tunable through cpusets. However
> plans have changed in favour of an interface (be it cpusets or sysctl)
> grouping all these features to be turned on/off altogether.
> Then should the need ever arise, the interface can still be expanded
> to handle the individual isolation features.
>=20
> Therefore the current isolation split between tick/timer/workqueue/rcu/
> kthreads/misc doesn't make sense anymore.

Why it doesn't make sense? I think it's a useful annotation of
respective operations wrt CPU isolation.

The grouping you did into HK_TYPE_KERNEL_NOISE (or even coarser) should
IMO be done at the place where it'll be exposed into the favored
interface (like it's with nohz_full=3D).

Thanks,
Michal

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY+Eh4QAKCRAkDQmsBEOq
uY4SAQCzuyUGyy1DTu07dJpsvqnTWqj22goDeqZvTqIu0AP03gEAyBFBBPOZ8x2z
1AxH3gDttpfyCcnalCsgb2sHDcUf+gA=
=pZsI
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
