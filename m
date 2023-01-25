From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC v3 00/12] DRM scheduling cgroup controller
Date: Wed, 25 Jan 2023 18:11:35 +0000
Message-ID: <371f3ce5-3468-b91d-d688-7e89499ff347@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230123154239.GA24348@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674670301; x=1706206301;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JuYjKJS9gbqNnrhb2oKijdYn0zeQyxwNNDDSL14po5s=;
  b=MUzoJvJRgjC8StWM9h5gzXFN+rMqNyjVZrQ+nvIRBy+x8MzBrDdVPbq0
   dmTgjJ9LN1ACosLtt3f/Icjzi0853RZE+fhlupUhfDi5ZytyQfjcKm3Ii
   W8PdaBMCpkXtRgeVjhvAj1D/UFJJT/1BO5snjkJcR7wZV2D5+23K10QEd
   SbfGTpxuAbFwL4LlG4Xw1yF+M9vXtUDGBwnCbHykvfa1qgWgwToKnseAX
   d+IrMlQqhOl2ZHU2aPLoBrMX3RyH5+IszUJviSDPTfwfQ4UbAJ6rhnlxZ
   Ltw1u+3OtLwgsxv0iFhaQJgyuet+FosIUvpUkIoxzWiy3a0DcBB0EE2aX
   g==;
Content-Language: en-US
In-Reply-To: <20230123154239.GA24348-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


Hi,

On 23/01/2023 15:42, Michal Koutn=C3=BD wrote:
> Hello Tvrtko.
>=20
> Interesting work.

Thanks!

> On Thu, Jan 12, 2023 at 04:55:57PM +0000, Tvrtko Ursulin <tvrtko.ursulin-=
VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>> Because of the heterogenous hardware and driver DRM capabilities, soft l=
imits
>> are implemented as a loose co-operative (bi-directional) interface betwe=
en the
>> controller and DRM core.
>=20
> IIUC, this periodic scanning, calculating and applying could be partly
> implemented with userspace utilities. (As you write, these limits are
> best effort only, so it sounds to me such a total implementation is
> unnecessary.)

I don't immediately see how you envisage the half-userspace=20
implementation would look like in terms of what functionality/new APIs=20
would be provided by the kernel?

> I think a better approach would be to avoid the async querying and
> instead require implementing explicit foo_charge_time(client, dur) API
> (similar to how other controllers achieve this).
> Your argument is the heterogenity of devices -- does it mean there are
> devices/drivers that can't implement such a synchronous charging?

Problem there is to find a suitable point to charge at. If for a moment=20
we limit the discussion to i915, out of the box we could having charging=20
happening at several thousand times per second to effectively never.=20
This is to illustrate the GPU context execution dynamics which range=20
from many small packets of work to multi-minute, or longer. For the=20
latter to be accounted for we'd still need some periodic scanning, which=20
would then perhaps go per driver. For the former we'd have thousands of=20
needless updates per second.

Hence my thinking was to pay both the cost of accounting and collecting=20
the usage data once per actionable event, where the latter is controlled=20
by some reasonable scanning period/frequency.

In addition to that, a few DRM drivers already support GPU usage=20
querying via fdinfo, so that being externally triggered, it is next to=20
trivial to wire all those DRM drivers into such common DRM cgroup=20
controller framework. All that every driver needs to implement on top is=20
the "over budget" callback.

>> DRM core provides an API to query per process GPU utilization and 2nd AP=
I to
>> receive notification from the cgroup controller when the group enters or=
 exits
>> the over budget condition.
>=20
> The return value of foo_charge_time() would substitute such a
> notification synchronously. (By extension all clients in an affected
> cgroup could be notified to achieve some broader actions.)

Right, it is doable in theory, but as mention above some rate limit=20
would have to be added. And the notification would still need to have=20
unused budget propagation through the tree, so it wouldn't work to=20
localize the action to the single cgroup (the one getting the charge).

>> Individual DRM drivers which implement the interface are expected to act=
 on this
>> in the best-effort manner only. There are no guarantees that the soft li=
mits
>> will be respected.
>=20
> Back to original concern -- must all code reside in the kernel when it's
> essentially advisory resource control?
>=20
>>   * DRM core is required to track all DRM clients belonging to processes=
 so it
>>     can answer when asked how much GPU time is a process using.
>>   [...]
>>   * Individual drivers need to implement two similar hooks, but which wo=
rk for
>>     a single DRM client. Over budget callback and GPU utilisation query.
>=20
> This information is eventually aggregated for each process in a cgroup.
> (And the action is carried on a single client, not a process.)
> The per-process tracking seems like an additional indirection.
> Could be the clients associated directly with DRM cgroup? [1]

I think you could be right here - with some deeper integration with the=20
cgroup subsystem this could probably be done. It would require moving=20
the list of drm clients into the cgroup css state itself. Let me try and=20
sketch that out in the following weeks because it would be a nice=20
simplification if it indeed worked out.

Regards,

Tvrtko

>=20
>=20
> Regards,
> Michal
>=20
> [1] I understand the sending a fd of a client is a regular operation, so
>      I'm not sure how cross-cg migrations would have to be handled in any
>      case.
