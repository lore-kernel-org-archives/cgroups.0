From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v3 00/12] DRM scheduling cgroup controller
Date: Thu, 26 Jan 2023 14:00:50 +0100
Message-ID: <20230126130050.GA22442@blackbody.suse.cz>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230123154239.GA24348@blackbody.suse.cz>
 <371f3ce5-3468-b91d-d688-7e89499ff347@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674738051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jq01Sm8SBYrwuIbnTiDzZaS12Esjwjw+h71W4eebOX4=;
        b=K75+0LENCpiZZU3kMZnJrFUA4+44SN8LdEABzSCpIz22gmVv/HwH2lzrsYI5x0JZViHUUM
        wcy9eFyPF6rgsuViC3kbxwVm3DKMR3TWH902j64biJlGce/pyBzsBvmeyUGi3xeJTep5cp
        bSwZ++MfqmGC/D1s41XTt2GdZhZENIA=
Content-Disposition: inline
In-Reply-To: <371f3ce5-3468-b91d-d688-7e89499ff347-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 06:11:35PM +0000, Tvrtko Ursulin <tvrtko.ursulin@li=
nux.intel.com> wrote:
> I don't immediately see how you envisage the half-userspace implementation
> would look like in terms of what functionality/new APIs would be provided=
 by
> the kernel?

Output:
	drm.stat (with consumed time(s))

Input:
	drm.throttle (alternatives)
	- a) writing 0,1 (in rough analogy to your proposed
	     notifications)
	- b) writing duration (in loose analogy to memory.reclaim)
	     - for how long GPU work should be backed off

An userspace agent sitting between these two and it'd do the measurement
and calculation depending on given policies (weighting, throttling) and
apply respective controls.

(In resemblance of e.g. https://denji.github.io/cpulimit/)

> Problem there is to find a suitable point to charge at. If for a moment we
> limit the discussion to i915, out of the box we could having charging
> happening at several thousand times per second to effectively never. This=
 is
> to illustrate the GPU context execution dynamics which range from many sm=
all
> packets of work to multi-minute, or longer. For the latter to be accounted
> for we'd still need some periodic scanning, which would then perhaps go p=
er
> driver. For the former we'd have thousands of needless updates per second.
>=20
> Hence my thinking was to pay both the cost of accounting and collecting t=
he
> usage data once per actionable event, where the latter is controlled by s=
ome
> reasonable scanning period/frequency.
>=20
> In addition to that, a few DRM drivers already support GPU usage querying
> via fdinfo, so that being externally triggered, it is next to trivial to
> wire all those DRM drivers into such common DRM cgroup controller framewo=
rk.
> All that every driver needs to implement on top is the "over budget"
> callback.

I'd also like show comparison with CPU accounting and controller.
There is tick-based (~sampling) measurement of various components of CPU
time (task_group_account_field()). But the actual schedulling (weights)
or throttling is based on precise accounting (update_curr()).

So, if the goal is to have precise and guaranteed limits, it shouldn't
(cannot) be based on sampling. OTOH, if it must be sampling based due to
variability of the device landscape, it could be advisory mechanism with
the userspace component.

My 0.02=E2=82=AC,
Michal

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY9J5fQAKCRAkDQmsBEOq
uUg3AP4+ZWvuZ3xdlWSXFPWS/n5dpEobQswSJpRzulYDa0Y2kQEAvVvMx/X7B0zi
wV+jzd0bW0zXWpasGE5L8GxBJMNyRwA=
=pO2C
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
