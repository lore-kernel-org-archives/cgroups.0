From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 1/4] selftests: memcg: Fix compilation
Date: Fri, 13 May 2022 12:09:52 -0700
Message-ID: <Yn6tAOLLA8U+PR5V@carbon>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
 <20220513171811.730-1-mkoutny@suse.com>
 <20220513171811.730-2-mkoutny@suse.com>
 <Yn6pHbHh027S5c33@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652468997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kCBVoc6lYe16FY7d0e0dFTCVD0ucTi0jf0UlBuTq+3o=;
        b=Ocf9FoXp8spyscHpEzxfyBuEOGxocpgRSSfg462ROFs8S7hILkbn49hl1CDgBKLH9cNJlZ
        JUMNb2PXigJ7yZtVDsU8lVoqTXBLgUgbNITjQfu53A3A0kHU63xoqRjW6JqCcoExP2DO61
        yqOSGlRPdTrIIBJZpzdZ0g9IU+alaeo=
Content-Disposition: inline
In-Reply-To: <Yn6pHbHh027S5c33@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

On Fri, May 13, 2022 at 11:53:26AM -0700, Roman Gushchin wrote:
> On Fri, May 13, 2022 at 07:18:08PM +0200, Michal Koutny wrote:
> > This fixes mis-applied changes from commit 72b1e03aa725 ("cgroup:
> > account for memory_localevents in test_memcg_oom_group_leaf_events()").
> >=20
> > Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> > ---
> >  .../selftests/cgroup/test_memcontrol.c        | 25 +++++++++++--------
> >  1 file changed, 14 insertions(+), 11 deletions(-)
> >=20
> > diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/t=
esting/selftests/cgroup/test_memcontrol.c
> > index 6ab94317c87b..4958b42201a9 100644
> > --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> > +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> > @@ -1241,7 +1241,16 @@ static int test_memcg_oom_group_leaf_events(cons=
t char *root)
> >  	if (cg_read_key_long(child, "memory.events", "oom_kill ") <=3D 0)
> >  		goto cleanup;
> > =20
> > -	if (cg_read_key_long(parent, "memory.events", "oom_kill ") <=3D 0)
> > +	parent_oom_events =3D cg_read_key_long(
> > +			parent, "memory.events", "oom_kill ");
> > +	/*
> > +	 * If memory_localevents is not enabled (the default), the parent sho=
uld
> > +	 * count OOM events in its children groups. Otherwise, it should not
> > +	 * have observed any events.
> > +	 */
> > +	if (has_localevents && parent_oom_events !=3D 0)
> > +		goto cleanup;
> > +	else if (!has_localevents && parent_oom_events <=3D 0)
> >  		goto cleanup;
> > =20
> >  	ret =3D KSFT_PASS;
> > @@ -1349,20 +1358,14 @@ static int test_memcg_oom_group_score_events(co=
nst char *root)
> >  	if (!cg_run(memcg, alloc_anon, (void *)MB(100)))
> >  		goto cleanup;
> > =20
> > -	parent_oom_events =3D cg_read_key_long(
> > -			parent, "memory.events", "oom_kill ");
> > -	/*
> > -	 * If memory_localevents is not enabled (the default), the parent sho=
uld
> > -	 * count OOM events in its children groups. Otherwise, it should not
> > -	 * have observed any events.
> > -	 */
> > -	if ((has_localevents && parent_oom_events =3D=3D 0) ||
> > -	     parent_oom_events > 0)
> > -		ret =3D KSFT_PASS;
> > +	if (cg_read_key_long(memcg, "memory.events", "oom_kill ") !=3D 3)
> > +		FAIL(cleanup);
> > =20
> >  	if (kill(safe_pid, SIGKILL))
> >  		goto cleanup;
> > =20
> > +	ret =3D KSFT_PASS;
> > +
> >  cleanup:
> >  	if (memcg)
> >  		cg_destroy(memcg);
> > --=20
> > 2.35.3
> >=20
>=20
> My bad.

Actually not, as pointed by David.
Seems like it's git fault. The original patch looks correct.
