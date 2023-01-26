From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC v3 00/12] DRM scheduling cgroup controller
Date: Thu, 26 Jan 2023 17:57:24 +0000
Message-ID: <b8a0872c-fe86-b174-ca3b-0fc04a98e224@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230123154239.GA24348@blackbody.suse.cz>
 <371f3ce5-3468-b91d-d688-7e89499ff347@linux.intel.com>
 <20230126130050.GA22442@blackbody.suse.cz> <Y9KyiCPYj2Mzym3Z@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674755851; x=1706291851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BQUEAqzlE148mAgRStfAJ82IWpXoVVw/1OpuqObioe4=;
  b=aNCjuJfx62MGdq9qxugYoSpKZ5Bp6IoB3jukXxZvZzeqyRuo+w3GQgz9
   UkVdHyIBzMhxikOjsESo4VC7Y4H+y9DDthS0afiyZVzFf5gBWT0FcnrKJ
   RS3AR5UNp6+xuS/RZiwKE8/geG5w8+Lpo1Glj9ylhDvONq3w1LMeObUIF
   btxXZDpH+wvryLm3h3wcdFN0R6Gz7hlaJXT49I1yZb041+YcNGSQa6UlN
   LrkTm4TqIx8RU0rZ+yMuQZsUSmxUH2Ysur9QubcToJGt9f33GVoXkJ2sy
   eBrf1jKt8d2P9NWbj0bu3nusW7UrXOmc6/5qMHbqlESD5CYAJCkKr5lGl
   A==;
Content-Language: en-US
In-Reply-To: <Y9KyiCPYj2Mzym3Z-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


Hi,

(Two replies in one, hope you will manage to navigate it.)

On 26/01/2023 17:04, Tejun Heo wrote:
> Hello,
>=20
> On Thu, Jan 26, 2023 at 02:00:50PM +0100, Michal Koutn=C3=BD wrote:
>> On Wed, Jan 25, 2023 at 06:11:35PM +0000, Tvrtko Ursulin <tvrtko.ursulin=
-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>>> I don't immediately see how you envisage the half-userspace implementat=
ion
>>> would look like in terms of what functionality/new APIs would be provid=
ed by
>>> the kernel?
>>
>> Output:
>> 	drm.stat (with consumed time(s))
>>
>> Input:
>> 	drm.throttle (alternatives)
>> 	- a) writing 0,1 (in rough analogy to your proposed
>> 	     notifications)
>> 	- b) writing duration (in loose analogy to memory.reclaim)
>> 	     - for how long GPU work should be backed off
>>
>> An userspace agent sitting between these two and it'd do the measurement
>> and calculation depending on given policies (weighting, throttling) and
>> apply respective controls.

Right, I wouldn't recommend drm.throttle as ABI since my idea is to=20
enable drivers to do as good job as they individually can. Eg. some may=20
be able to be much smarter than simple throttling, or some may start of=20
simpler and later gain a better implementation. Some may even have=20
differing capability or granularity depending on the GPU model they are=20
driving, like in the case of i915.

So even if the RFC shows just a simple i915 implementation, the=20
controller itself shouldn't prevent a smarter approach (via exposed=20
ABI). And neither this simple i915 implementation works equally well for=20
all supported GPU generations! This will be a theme common for many DRM=20
drivers.

Secondly, doing this in userspace would require the ability to get some=20
sort of an atomic snapshot of the whole tree hierarchy to account for=20
changes in layout of the tree and task migrations. Or some retry logic=20
with some added ABI fields to enable it.

Even then I think the only thing we would be able to move to userspace=20
is the tree-walking logic and that sounds like not that much kernel code=20
saved to trade for increased inefficiency.

>> (In resemblance of e.g. https://denji.github.io/cpulimit/)
>=20
> Yeah, things like this can be done from userspace but if we're gonna build
> the infrastructure to allow that in gpu drivers and so on, I don't see why
> we wouldn't add a generic in-kernel control layer if we can implement a
> proper weight based control. We can of course also expose .max style
> interface to allow userspace to do whatever they wanna do with it.

Yes agreed, and to re-stress out, the ABI as proposed does not preclude=20
changing from scanning to charging or whatever. The idea was for it to=20
be compatible in concept with the CPU controller and also avoid baking=20
in the controlling method to individual drivers.

>>> Problem there is to find a suitable point to charge at. If for a moment=
 we
>>> limit the discussion to i915, out of the box we could having charging
>>> happening at several thousand times per second to effectively never. Th=
is is
>>> to illustrate the GPU context execution dynamics which range from many =
small
>>> packets of work to multi-minute, or longer. For the latter to be accoun=
ted
>>> for we'd still need some periodic scanning, which would then perhaps go=
 per
>>> driver. For the former we'd have thousands of needless updates per seco=
nd.
>>>
>>> Hence my thinking was to pay both the cost of accounting and collecting=
 the
>>> usage data once per actionable event, where the latter is controlled by=
 some
>>> reasonable scanning period/frequency.
>>>
>>> In addition to that, a few DRM drivers already support GPU usage queryi=
ng
>>> via fdinfo, so that being externally triggered, it is next to trivial to
>>> wire all those DRM drivers into such common DRM cgroup controller frame=
work.
>>> All that every driver needs to implement on top is the "over budget"
>>> callback.
>>
>> I'd also like show comparison with CPU accounting and controller.
>> There is tick-based (~sampling) measurement of various components of CPU
>> time (task_group_account_field()). But the actual schedulling (weights)
>> or throttling is based on precise accounting (update_curr()).
>>
>> So, if the goal is to have precise and guaranteed limits, it shouldn't
>> (cannot) be based on sampling. OTOH, if it must be sampling based due to
>> variability of the device landscape, it could be advisory mechanism with
>> the userspace component.

I don't think precise and guaranteed limits are feasible given the=20
heterogeneous nature of DRM driver capabilities, but I also don't think=20
sticking an userspace component in the middle is the way to go.

> As for the specific control mechanism, yeah, charge based interface would=
 be
> more conventional and my suspicion is that transposing the current
> implementation that way likely isn't too difficult. It just pushes "am I
> over the limit?" decisions to the specific drivers with the core layer
> telling them how much under/over budget they are. I'm curious what other =


As I have tried to explain in my previous reply, I don't think real time=20
charging is feasible. Because frequency of charging events can both be=20
too high and too low. Too high that it doesn't bring value apart from=20
increased processing times, where it is not useful to send out=20
notification at the same rate, and too low in the sense that some sort=20
of periodic query would then be needed in every driver implementation to=20
enable all classes of GPU clients to be properly handled.

I just don't see any positives to the charging approach in the DRM=20
landscape, but for sure see some negatives. (If we ignore the positive=20
of it being a more typical approach, but then I think that is not enough=20
to outweigh the negatives.)

gpu
> driver folks think about the current RFC tho. Is at least AMD on board wi=
th
> the approach?

Yes I am keenly awaiting comments from the DRM colleagues as well.

Regards,

Tvrtko

P.S. Note that Michal's idea to simplify client tracking is on my TODO=20
list. If that works out some patches, the series itself actually, would=20
become even simpler.
