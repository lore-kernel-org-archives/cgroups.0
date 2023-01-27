From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v3 00/12] DRM scheduling cgroup controller
Date: Fri, 27 Jan 2023 11:04:28 +0100
Message-ID: <20230127100428.GA3527@blackbody.suse.cz>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230123154239.GA24348@blackbody.suse.cz>
 <371f3ce5-3468-b91d-d688-7e89499ff347@linux.intel.com>
 <20230126130050.GA22442@blackbody.suse.cz>
 <Y9KyiCPYj2Mzym3Z@slm.duckdns.org>
 <b8a0872c-fe86-b174-ca3b-0fc04a98e224@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674813870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J2Yj6ff8IbmYEbxojhB+2vw+NfQJD3sa9mrK8gYDrlU=;
        b=oSpjoRiphsPb9FjCgcMhy4VMAxtwPO7mmwnC1JnlR3dGohGzYh9aJWGao+j9UryNeC7RbJ
        Q4Z9uPAqEzLwsc6JPhlq/lTGl9xZ1KiDkNWdbyrhh8DlJ2boPQYc6NV25oxAH15r7EcWn6
        D3mX/jmvrHxA40e5tWuM6ITw4MR6uEA=
Content-Disposition: inline
In-Reply-To: <b8a0872c-fe86-b174-ca3b-0fc04a98e224-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 26, 2023 at 05:57:24PM +0000, Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> So even if the RFC shows just a simple i915 implementation, the controller
> itself shouldn't prevent a smarter approach (via exposed ABI).

scan/query + over budget notification is IMO limited in guarantees.

> [...]
> Yes agreed, and to re-stress out, the ABI as proposed does not preclude
> changing from scanning to charging or whatever. The idea was for it to be
> compatible in concept with the CPU controller and also avoid baking in the
> controlling method to individual drivers.
> [...]

But I submit to your point of rather not exposing this via cgroup API
for possible future refinements.

> Secondly, doing this in userspace would require the ability to get some sort
> of an atomic snapshot of the whole tree hierarchy to account for changes in
> layout of the tree and task migrations. Or some retry logic with some added
> ABI fields to enable it.

Note, that the proposed implementation is succeptible to miscount due to
concurrent tree modifications and task migrations too (scanning may not
converge under frequent cgroup layout modifications, and migrating tasks
may be summed 0 or >1 times). While in-kernel implementation may assure
the snapshot view, it'd come at cost. (Read: since the mechanism isn't
precise anyway, I don't suggest a fully synchronized scanning.)

Regards,
Michal

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY9OhlwAKCRAkDQmsBEOq
ufYHAQCnD9btPT6J56fYnI1rsJHumK+TajFM5kqwWR6eIphScQD+NCFpWhvbh6n2
F2dtfltgBBeFK/0OaFCJuhoi7uIPUQA=
=ZjfL
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
