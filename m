From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC 10/12] cgroup/drm: Introduce weight based drm cgroup control
Date: Fri, 27 Jan 2023 14:01:34 +0100
Message-ID: <20230127130134.GA15846@blackbody.suse.cz>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230112165609.1083270-11-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674824496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xwqwimypfYhckyzFeaCO359/Wbd8QLK/UU3i+F4YZ9M=;
        b=kxTr+5nGawv5c+31CyMgEt3X4+S1+4evQh+J1Dg58MqKbnjUH9unrBer5bNpBAJ7R6Wd77
        VD8rwA1obRyuqw3M5hAh8MdMuDbuxNMJ6FF6ifulfEzRrlWc+ZEF0jMeIKKA5K1fu2uvGE
        9d0zsWLGDEgFESRukKgMT7/bh9bYObU=
Content-Disposition: inline
In-Reply-To: <20230112165609.1083270-11-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 04:56:07PM +0000, Tvrtko Ursulin <tvrtko.ursulin@li=
nux.intel.com> wrote:
> +static int drmcs_can_attach(struct cgroup_taskset *tset)
> +{
> +	int ret;
> +
> +	/*
> +	 * As processes are getting moved between groups we need to ensure
> +	 * both that the old group does not see a sudden downward jump in the
> +	 * GPU utilisation, and that the new group does not see a sudden jump
> +	 * up with all the GPU time clients belonging to the migrated process
> +	 * have accumulated.
> +	 *
> +	 * To achieve that we suspend the scanner until the migration is
> +	 * completed where the resume at the end ensures both groups start
> +	 * observing GPU utilisation from a reset state.
> +	 */
> +
> +	ret =3D mutex_lock_interruptible(&drmcg_mutex);
> +	if (ret)
> +		return ret;
> +	start_suspend_scanning();
> +	mutex_unlock(&drmcg_mutex);
> +
> +	finish_suspend_scanning();

Here's scanning suspension, communicated via=20

	root_drmcs.scanning_suspended =3D true;
	root_drmcs.suspended_period_us =3D root_drmcs.period_us;
	root_drmcs.period_us =3D 0;

but I don't see those used in scan_worker() and the scanning traversal
can apparently run concurrently with a task migration.

> [...]
> +static bool
> +__start_scanning(struct drm_cgroup_state *root, unsigned int period_us)
> [...]
> +	css_for_each_descendant_post(node, &root->css) {
> [...]
> +		active =3D drmcs_get_active_time_us(drmcs);
> +		if (period_us && active > drmcs->prev_active_us)
> +			drmcs->active_us +=3D active - drmcs->prev_active_us;
> +		drmcs->prev_active_us =3D active;

drmcs_get_active_time_us() could count a task's contribution here,
the task would migrate to a different drmcs,
and it'd be counted 2nd time.



--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY9PLLAAKCRAkDQmsBEOq
uR23AQDwt1E9t+jVuVU7H8uzqQ4NU955UNFhUY+uPnN1iQs1hwD+InLBJmA61dva
zuO/RFocXhzfrqMboDPUdkJFDknEYAw=
=+pK0
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
