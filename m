From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v3 00/12] DRM scheduling cgroup controller
Date: Mon, 23 Jan 2023 16:42:39 +0100
Message-ID: <20230123154239.GA24348@blackbody.suse.cz>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674488561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=55apZeYnu6RO07C6lWHKMqZeQ9QD+dZi2oV45IYgqR8=;
        b=NwZHaPnSdW0sTqWIpW2Ep2zUuQal9AFNwBLp9xUmbUjAfDGelZ/xsCQDuUGJM72HmTIzWD
        OVGHfd0I8eI2RL5CanevYwNgICrTG+L9yMtGcFVikSQMyfesIE/B6sHkF1jegMTYHs7TtI
        KIBufBqOPxkvvdIyiJwOXwaUEQXgNhs=
Content-Disposition: inline
In-Reply-To: <20230112165609.1083270-1-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Tvrtko.

Interesting work.

On Thu, Jan 12, 2023 at 04:55:57PM +0000, Tvrtko Ursulin <tvrtko.ursulin@li=
nux.intel.com> wrote:
> Because of the heterogenous hardware and driver DRM capabilities, soft li=
mits
> are implemented as a loose co-operative (bi-directional) interface betwee=
n the
> controller and DRM core.

IIUC, this periodic scanning, calculating and applying could be partly
implemented with userspace utilities. (As you write, these limits are
best effort only, so it sounds to me such a total implementation is
unnecessary.)

I think a better approach would be to avoid the async querying and
instead require implementing explicit foo_charge_time(client, dur) API
(similar to how other controllers achieve this).
Your argument is the heterogenity of devices -- does it mean there are
devices/drivers that can't implement such a synchronous charging?=20

> DRM core provides an API to query per process GPU utilization and 2nd API=
 to
> receive notification from the cgroup controller when the group enters or =
exits
> the over budget condition.

The return value of foo_charge_time() would substitute such a
notification synchronously. (By extension all clients in an affected
cgroup could be notified to achieve some broader actions.)

> Individual DRM drivers which implement the interface are expected to act =
on this
> in the best-effort manner only. There are no guarantees that the soft lim=
its
> will be respected.

Back to original concern -- must all code reside in the kernel when it's
essentially advisory resource control?

>  * DRM core is required to track all DRM clients belonging to processes s=
o it
>    can answer when asked how much GPU time is a process using.
>  [...]
>  * Individual drivers need to implement two similar hooks, but which work=
 for
>    a single DRM client. Over budget callback and GPU utilisation query.

This information is eventually aggregated for each process in a cgroup.
(And the action is carried on a single client, not a process.)
The per-process tracking seems like an additional indirection.
Could be the clients associated directly with DRM cgroup? [1]


Regards,
Michal

[1] I understand the sending a fd of a client is a regular operation, so
    I'm not sure how cross-cg migrations would have to be handled in any
    case.

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY86q5AAKCRAkDQmsBEOq
ueEGAQDI5fZQTAIasuzhXqvhso/sSZM6kjJABNN/jGexID1/AgEA7ESyKCV82koM
JsjtlGG3kRl/Y0LhTvA4J7akVFgGdQo=
=vAYz
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
