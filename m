From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/isolation: Add cpu_is_isolated() API
Date: Mon, 6 Feb 2023 16:47:10 +0100
Message-ID: <20230206154710.GC21332@blackbody.suse.cz>
References: <20230203232409.163847-1-frederic@kernel.org>
 <20230203232409.163847-3-frederic@kernel.org>
 <0f388863-9498-e61e-e2dc-965654544489@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675698432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A6gmdUnhXsh7F4Q5zhkhB8x3HI32ubbjTYXnnm6617s=;
        b=TKoEbDH2jSv0bb1xA/TIpfuqrEK9SpggArYwLP+ikxpLtL5CRk3bD7ngMACkIw0VedzTtP
        cJMtJkSSFdtOM70Cyy0ORW/pbsaM1Te6hbLfpqXfwCqAkGBvPHtq04YGwSBHN9GHhJcaIK
        LhSybdGzki92Wxjlz6kPfmaPVDSeXp4=
Content-Disposition: inline
In-Reply-To: <0f388863-9498-e61e-e2dc-965654544489-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Fri, Feb 03, 2023 at 10:53:46PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> CPUs in an isolated cpuset partition is similar to HK_TYPE_DOMAIN CPUs as
> load balancing is disabled. I can add an API to access the cpumask and add
> to this API. However, that list is dynamic as it can be changed at run ti=
me.
> Will that be a problem?

I can see a problem already -- as a CPU can be dynamically switched to
"isolated" mode so should all dependent operations support that (switch)
too, i.e. the CPUs local PCP caches would have to be drained when the
CPU enters isolation.

> Or should that be used separately?

It'd be nice to have both (cpuset and cmdline flags) eventually unified.

Alas, it only leads me conservatively to:

#ifndef CONFIG_CPUSETS
// the proposed implementaion
else
static inline bool cpu_is_isolated(int cpu) {
	return true;
}
#endif

My 0.02=E2=82=AC,
Michal


--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY+Eg/AAKCRAkDQmsBEOq
uez7AQDvZKyGoF72K2smV4hq3/IPwBfNLn2t+ww7L0b8II8ihgD+L95xmOMksNcs
blBIR3kqNeUmmECFUeYuPOGLfWIGygc=
=chfl
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
