From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 2/4] selftests: memcg: Expect no low events in
 unprotected sibling
Date: Fri, 13 May 2022 10:42:11 -0700
Message-ID: <20220513174211.uv5yxzt5sochmwal@dev0025.ash9.facebook.com>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
 <20220513171811.730-1-mkoutny@suse.com>
 <20220513171811.730-3-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220513171811.730-3-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

On Fri, May 13, 2022 at 07:18:09PM +0200, Michal Koutn=FD wrote:
> This is effectively a revert of commit cdc69458a5f3 ("cgroup: account
> for memory_recursiveprot in test_memcg_low()"). The case test_memcg_low
> will fail with memory_recursiveprot until resolved in reclaim
> code.
> However, this patch preserves the existing helpers and variables for
> later uses.
>=20
> Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/tes=
ting/selftests/cgroup/test_memcontrol.c
> index 4958b42201a9..eba252fa64ac 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -528,7 +528,7 @@ static int test_memcg_low(const char *root)
>  	}
> =20
>  	for (i =3D 0; i < ARRAY_SIZE(children); i++) {
> -		int no_low_events_index =3D has_recursiveprot ? 2 : 1;
> +		int no_low_events_index =3D 1;
> =20
>  		oom =3D cg_read_key_long(children[i], "memory.events", "oom ");
>  		low =3D cg_read_key_long(children[i], "memory.events", "low ");
> --=20
> 2.35.3
>=20

Reviewed-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
