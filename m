From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH-next] MEMCG: memcontrol: make local symbol static
Date: Thu, 18 Jan 2018 11:23:03 -0800
Message-ID: <1516303383.14023.2.camel@perches.com>
References: <20180118150805.18521-1-chrisadr@gentoo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180118150805.18521-1-chrisadr-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Christopher =?ISO-8859-1?Q?D=EDaz?= Riveros <chrisadr-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2018-01-18 at 10:08 -0500, Christopher D=EDaz Riveros wrote:
> Fixes the following sparse warning:
>=20
> mm/memcontrol.c:1097:14: warning:
>   symbol 'memcg1_stats' was not declared. Should it be static?
>=20
> Signed-off-by: Christopher D=EDaz Riveros <chrisadr-aBrp7R+bbdUdnm+yROfE0=
A@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
[]
> @@ -1094,7 +1094,7 @@ static bool mem_cgroup_wait_acct_move(struct mem_cg=
roup *memcg)
>  	return false;
>  }
> =20
> -unsigned int memcg1_stats[] =3D {
> +static unsigned int memcg1_stats[] =3D {

This should almost certainly be static const

>  	MEMCG_CACHE,
>  	MEMCG_RSS,
>  	MEMCG_RSS_HUGE,
