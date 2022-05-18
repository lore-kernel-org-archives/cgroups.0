From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 4/4] selftests: memcg: Remove protection from top level
 memcg
Date: Tue, 17 May 2022 17:52:25 -0700
Message-ID: <YoRDSfv6xK/R+n+R@carbon>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
 <20220513171811.730-1-mkoutny@suse.com>
 <20220513171811.730-5-mkoutny@suse.com>
 <Yn6qrHHS935ppX98@carbon>
 <20220517172443.3e524a8319c693ab24c5f22e@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652835152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1o3oJN5gQQTieH2g5nQdeNUsC++N3DE8B+0iuF60aw4=;
        b=GewWqVjHhWuzqety2mXdbrWLrO/2oTjNznANQxyCkgxP+e0u82igfbs4pzNk60tmlj1tYB
        BlmTPiX2hXmz4bXqK+HQh8R74tV+IczWEnsR7jCoVrqBTpmbRGGdqnG2cWlqtXsyrIz6Sh
        JMQY/aTeFX58HSFvXL1xAE3A9SQntrI=
Content-Disposition: inline
In-Reply-To: <20220517172443.3e524a8319c693ab24c5f22e-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

On Tue, May 17, 2022 at 05:24:43PM -0700, Andrew Morton wrote:
> On Fri, 13 May 2022 11:59:56 -0700 Roman Gushchin <roman.gushchin-fxUVXft=
IFDnyG1zEObXtfA@public.gmane.org> wrote:
>=20
> > On Fri, May 13, 2022 at 07:18:11PM +0200, Michal Koutny wrote:
> > > The reclaim is triggered by memory limit in a subtree, therefore the
> > > testcase does not need configured protection against external reclaim.
> > >=20
> > > Also, correct/deduplicate respective comments
> > >=20
> > > Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> > > ---
> > >  tools/testing/selftests/cgroup/test_memcontrol.c | 12 ++++--------
> > >  1 file changed, 4 insertions(+), 8 deletions(-)
> > >=20
> > > diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools=
/testing/selftests/cgroup/test_memcontrol.c
> > > index 9ffacf024bbd..9d370aafd799 100644
> > > --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> > > +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> > > @@ -247,7 +247,7 @@ static int cg_test_proc_killed(const char *cgroup)
> > > =20
> > >  /*
> > >   * First, this test creates the following hierarchy:
> > > - * A       memory.min =3D 50M,  memory.max =3D 200M
> > > + * A       memory.min =3D 0,    memory.max =3D 200M
> > >   * A/B     memory.min =3D 50M,  memory.current =3D 50M
> > >   * A/B/C   memory.min =3D 75M,  memory.current =3D 50M
> > >   * A/B/D   memory.min =3D 25M,  memory.current =3D 50M
> > > @@ -257,7 +257,7 @@ static int cg_test_proc_killed(const char *cgroup)
> > >   * Usages are pagecache, but the test keeps a running
> > >   * process in every leaf cgroup.
> > >   * Then it creates A/G and creates a significant
> > > - * memory pressure in it.
> > > + * memory pressure in A.
> > >   *
> > >   * A/B    memory.current ~=3D 50M
> > >   * A/B/C  memory.current ~=3D 29M
> > > @@ -335,8 +335,6 @@ static int test_memcg_min(const char *root)
> > >  			      (void *)(long)fd);
> > >  	}
> > > =20
> > > -	if (cg_write(parent[0], "memory.min", "50M"))
> > > -		goto cleanup;
> > >  	if (cg_write(parent[1], "memory.min", "50M"))
> > >  		goto cleanup;
> > >  	if (cg_write(children[0], "memory.min", "75M"))
> > > @@ -404,8 +402,8 @@ static int test_memcg_min(const char *root)
> > > =20
> > >  /*
> > >   * First, this test creates the following hierarchy:
> > > - * A       memory.low =3D 50M,  memory.max =3D 200M
> > > - * A/B     memory.low =3D 50M,  memory.current =3D 50M
> > > + * A       memory.low =3D 0,    memory.max =3D 200M
> > > + * A/B     memory.low =3D 50M,  memory.current =3D ...
> >=20
> > Can you, please, just remove "memory.current =3D ...", it's not
> > because obvious what "..." means here.
> >=20
>=20
> You mean this?
>=20
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-re=
move-protection-from-top-level-memcg-fix
> +++ a/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -403,15 +403,14 @@ cleanup:
>  /*
>   * First, this test creates the following hierarchy:
>   * A       memory.low =3D 0,    memory.max =3D 200M
> - * A/B     memory.low =3D 50M,  memory.current =3D ...
> + * A/B     memory.low =3D 50M
>   * A/B/C   memory.low =3D 75M,  memory.current =3D 50M
>   * A/B/D   memory.low =3D 25M,  memory.current =3D 50M
>   * A/B/E   memory.low =3D 0,    memory.current =3D 50M
>   * A/B/F   memory.low =3D 500M, memory.current =3D 0
>   *
>   * Usages are pagecache.
> - * Then it creates A/G an creates a significant
> - * memory pressure in it.
> + * Then it creates A/G and creates significant memory pressure in it.
>   *
>   * Then it checks actual memory usages and expects that:
>   * A/B    memory.current ~=3D 50M
> _
>=20
> (includes gratuitous comment cleanup)

Yes, thank you!

>=20
> I assume your comment in
> https://lkml.kernel.org/r/Yn6pBPq+lAXm9NG8@carbon can be addressed in a
> later patch.
>=20
> I'm not sure what to amke of https://lkml.kernel.org/r/Yn6pWPodGPlz+D8G@c=
arbon
>=20
> Do we feel this series needs more work before merging it up?
>=20

Please, go ahead with it. If anything comes up, it can be addressed later.

Thanks!
