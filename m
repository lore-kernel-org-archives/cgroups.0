From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 4/4] selftests: memcg: Remove protection from top level
 memcg
Date: Fri, 13 May 2022 12:14:59 -0700
Message-ID: <20220513191459.qgnmnu62xgxvhx5z@dev0025.ash9.facebook.com>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
 <20220513171811.730-1-mkoutny@suse.com>
 <20220513171811.730-5-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220513171811.730-5-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

On Fri, May 13, 2022 at 07:18:11PM +0200, Michal Koutn=FD wrote:
> The reclaim is triggered by memory limit in a subtree, therefore the
> testcase does not need configured protection against external reclaim.
>=20
> Also, correct/deduplicate respective comments
>=20
> Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/tes=
ting/selftests/cgroup/test_memcontrol.c
> index 9ffacf024bbd..9d370aafd799 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -247,7 +247,7 @@ static int cg_test_proc_killed(const char *cgroup)
> =20
>  /*
>   * First, this test creates the following hierarchy:
> - * A       memory.min =3D 50M,  memory.max =3D 200M
> + * A       memory.min =3D 0,    memory.max =3D 200M
>   * A/B     memory.min =3D 50M,  memory.current =3D 50M
>   * A/B/C   memory.min =3D 75M,  memory.current =3D 50M
>   * A/B/D   memory.min =3D 25M,  memory.current =3D 50M
> @@ -257,7 +257,7 @@ static int cg_test_proc_killed(const char *cgroup)
>   * Usages are pagecache, but the test keeps a running
>   * process in every leaf cgroup.
>   * Then it creates A/G and creates a significant
> - * memory pressure in it.
> + * memory pressure in A.
>   *
>   * A/B    memory.current ~=3D 50M
>   * A/B/C  memory.current ~=3D 29M
> @@ -335,8 +335,6 @@ static int test_memcg_min(const char *root)
>  			      (void *)(long)fd);
>  	}
> =20
> -	if (cg_write(parent[0], "memory.min", "50M"))
> -		goto cleanup;
>  	if (cg_write(parent[1], "memory.min", "50M"))
>  		goto cleanup;
>  	if (cg_write(children[0], "memory.min", "75M"))
> @@ -404,8 +402,8 @@ static int test_memcg_min(const char *root)
> =20
>  /*
>   * First, this test creates the following hierarchy:
> - * A       memory.low =3D 50M,  memory.max =3D 200M
> - * A/B     memory.low =3D 50M,  memory.current =3D 50M
> + * A       memory.low =3D 0,    memory.max =3D 200M
> + * A/B     memory.low =3D 50M,  memory.current =3D ...

Is there a reason that we would adjust this comment but not the A/B comment
from above in from test_memcg_low()? In both cases, I would just remove the
memory.current =3D ... part altogether, as Roman suggested.

>   * A/B/C   memory.low =3D 75M,  memory.current =3D 50M
>   * A/B/D   memory.low =3D 25M,  memory.current =3D 50M
>   * A/B/E   memory.low =3D 0,    memory.current =3D 50M
> @@ -490,8 +488,6 @@ static int test_memcg_low(const char *root)
>  			goto cleanup;
>  	}
> =20
> -	if (cg_write(parent[0], "memory.low", "50M"))
> -		goto cleanup;
>  	if (cg_write(parent[1], "memory.low", "50M"))
>  		goto cleanup;
>  	if (cg_write(children[0], "memory.low", "75M"))
> --=20
> 2.35.3
>=20

Looks good otherwise.

Reviewed-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
