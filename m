From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC 10/12] cgroup/drm: Introduce weight based drm cgroup control
Date: Fri, 27 Jan 2023 15:11:37 +0100
Message-ID: <20230127141136.GG3527@blackbody.suse.cz>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230112165609.1083270-11-tvrtko.ursulin@linux.intel.com>
 <20230127130134.GA15846@blackbody.suse.cz>
 <a96e6b5c-b538-f7e7-d603-cabb29137de7@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xs+9IvWevLaxKUtW"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674828698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mSncck0uCNO0XEG+dAMJPtpF70wyeN5+vS8xanKFqy0=;
        b=C1YoRptlDUvtsZPxFNqni7kpmNoA5+rRt8/CIEw/LMiA/d9XXDsAxWTxbwAVOmi07VCulg
        IipcUh7HGReprrPS0A3KwTN54ZPuwyAR9p56cSkttQ5A0UAnWgx2XnXBeLOO3PpGMWzzFu
        +EaUCvzEhrzzuBA9tz3O87ZIe5AbYoU=
Content-Disposition: inline
In-Reply-To: <a96e6b5c-b538-f7e7-d603-cabb29137de7@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robdclark@chromium.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>, "T . J . Mercier" <tjmercier@google.com>, Kenny.Ho@amd.com, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Brian Welty <brian.welty@intel.com>, Tvrtko Ursulin <tvrtko.ursulin@intel.com>


--xs+9IvWevLaxKUtW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 27, 2023 at 01:31:54PM +0000, Tvrtko Ursulin <tvrtko.ursulin@li=
nux.intel.com> wrote:
> I think you missed the finish_suspend_scanning() part:
>=20
> 	if (root_drmcs.suspended_period_us)
> 		cancel_delayed_work_sync(&root_drmcs.scan_work);
>=20
> So if scanning was in progress migration will wait until it finishes.

Indeed, I've missed that. Thank you!

> Not claiming I did not miss something because I was totally new with cgro=
up
> internals when I started working on this. So it is definitely useful to h=
ave
> more eyes looking.

The custom with (especially v2, especially horizontal) migrations
is that they're treated leniently to avoid performance costs.

I'm afraid waiting for scan in can_attach() can propagate globally (via
cgroup_update_dfl_csses() and cgroup_attach_lock()) sometimes.

OTOH, unless I misunderstood, you need to cover explicit (not task but
resource, when sending client FD around) migration anyway?
(I.e. my suggestion would be to mutualy exclude scanning and explicit
migration but not scanning and task migration in order to avoid possible
global propagation.)

Thanks,
Michal

--xs+9IvWevLaxKUtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY9PblAAKCRAkDQmsBEOq
ucw5AQC5ZB3HI12pF2NT0El6kZyt7tb80DxhDnscyavv+b0IdQEAiK5mjOqXAtP+
SYfNfDKskxKUJ4WdJnbrY4PbeeQlLwk=
=Rwoe
-----END PGP SIGNATURE-----

--xs+9IvWevLaxKUtW--
