From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] mm: kmem: add direct objcg pointer to task_struct
Date: Mon, 2 Jan 2023 17:09:46 +0100
Message-ID: <20230102160946.GD16704@blackbody.suse.cz>
References: <20221220182745.1903540-1-roman.gushchin@linux.dev>
 <20221220182745.1903540-3-roman.gushchin@linux.dev>
 <20221222135044.GB20830@blackbody.suse.cz>
 <Y6SEHTkHSNYQmv5k@P9FQF9L96D>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672675787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3TXMFafqZSk+G4FHe0dFtLpO4ewGe6qnJ+N0wbs8SPY=;
        b=QTi3UzxN6Jw/VzGJjLhZQdsQ+UBM7B4GAP4tthZfQGXeYmVgc6UTwe+BvVvpUaumfvoFOC
        pDu4+IXoLkjUUez0lGE1mlsK48eJaXenqfirr60jtzJzW9r835sNXpqfDa7As9HZ2CZPx1
        9zOUopaIcFyvLCNDzjWv/+lTgbqQR0o=
Content-Disposition: inline
In-Reply-To: <Y6SEHTkHSNYQmv5k@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Thu, Dec 22, 2022 at 08:21:49AM -0800, Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
> Do you have any numbers to share?

The numbers are in bko#216038, let me explain them here a bit.
I used the will-it-scale benchmark that repeatedly locks/unlocks a file
and runs in parallel.

The final numbers were:
  sample			metric	 	  =CE=B4	 =CE=B4_cg
  no accounting implemented	32307750	  0 %	 =C2=AD
  accounting in cg		2.49577e+07	-23 %	 0 %
  accounting in cg + cache	2.51642e+07 	-22 %	+1 %

Hence my result was only 1% improvement.

(But it was a very simple try, not delving into any of the CPU cache
statistics.)

Question: Were your measurements multi-threaded?

> 1) some people periodically complain that accounted allocations are slow
>    in comparison to non-accounted and slower than they were with page-bas=
ed
>    accounting,

My result above would not likely satisfy those complainers I know about.
But if your additional changes are better the additional code complexity
may be justified in the end.


> Btw, I'm working on a patch 3 for this series, which in early tests brings
> additional ~25% improvement in my benchmark, hopefully will post it soon =
as
> a part of v1.

Please send it with more details about your benchmark to put the numbers
into context.


Michal

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY7MByAAKCRAkDQmsBEOq
uUG/AQC11XKCM/wWsjYXa9wOcZSD924NsT+jZ2ZVsvw96HBebAD9EYkrKAMMTTlE
Zk65EirkknPYoU5zwvfnv8zzrOvGWgk=
=ihb/
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
