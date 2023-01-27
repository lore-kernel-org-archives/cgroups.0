From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC v3 00/12] DRM scheduling cgroup controller
Date: Fri, 27 Jan 2023 14:00:34 +0100
Message-ID: <20230127130034.GE3527@blackbody.suse.cz>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230123154239.GA24348@blackbody.suse.cz>
 <371f3ce5-3468-b91d-d688-7e89499ff347@linux.intel.com>
 <20230126130050.GA22442@blackbody.suse.cz>
 <Y9KyiCPYj2Mzym3Z@slm.duckdns.org>
 <b8a0872c-fe86-b174-ca3b-0fc04a98e224@linux.intel.com>
 <20230127100428.GA3527@blackbody.suse.cz>
 <246fefac-6c1d-e4f1-c0df-721ca23ab56a@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674824436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hPAJZRcZIw8l4IeZe9764fbpW5e1B2UJbOXlv7w8laU=;
        b=EXsy5iehcokvf7vDjKGZhIuOEuNiBEgxMJt4TXSJ1fF0VPerj1y2/DuCXlrtN86+j3KnkX
        zL03ou3yuJpDQhbGkVXTYzcsDcZs4oGcLmhDPi6j3EVBPE7JRvIcv/+36VxMUmHN9vBavr
        QbADyJgeTaDEEeHmJHo5wMrHg+4d9Fs=
Content-Disposition: inline
In-Reply-To: <246fefac-6c1d-e4f1-c0df-721ca23ab56a@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robdclark@chromium.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>, "T . J . Mercier" <tjmercier@google.com>, Kenny.Ho@amd.com, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Brian Welty <brian.welty@intel.com>, Tvrtko Ursulin <tvrtko.ursulin@intel.com>


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 27, 2023 at 11:40:58AM +0000, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
> The main point is, should someone prove me wrong and come up a smarter way
> at some point in the future, then "drm.weight" as an ABI remains compatible
> and the improvement can happen completely under the hood. In the mean time
> users get external control, and _some_ ability to improve the user
> experience with the scenarios such as I described yesterday.

I'm on board now.

(I've done a mental switch of likening this rather to existing IO
control (higher variance of quanta size, worse preemption, limited
effect) than CPU control.)


> Cgroup tree hierarchy modifications being the reason for not converging can
> also happen, but I thought I can hand wave that as not a realistic scenario.
> Perhaps I am not imaginative enough?

My suggestion: simply skip offlined drmcgs instead of restarting whole
iteration. (A respawning cgroup-wrapped job or intentionally adverse
respawner could in my imagination cause that.)

> Under or over-accounting for migrating tasks I don't think can happen since
> I am explicitly handling that.

I'll reply to the patch for better context...

Regards,
Michal

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY9PK7AAKCRAkDQmsBEOq
uUvSAP45dKy3+20fgzaJJKeGlOLhVn428dDTDzrsnF0msJguNgEA7HZGBQ9eIq3K
s4r0t9sc6dRojhFsRm6duQjrEGdpFQk=
=+6m2
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--
