From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC 10/12] cgroup/drm: Introduce weight based drm cgroup control
Date: Fri, 27 Jan 2023 15:21:20 +0000
Message-ID: <63b6853a-f24f-d97b-0fea-6200a004c41f@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230112165609.1083270-11-tvrtko.ursulin@linux.intel.com>
 <20230127130134.GA15846@blackbody.suse.cz>
 <a96e6b5c-b538-f7e7-d603-cabb29137de7@linux.intel.com>
 <20230127141136.GG3527@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674832887; x=1706368887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TEe+LuzRxflW6HpNyLU4rEMAiDmakglx8dNsR89Re44=;
  b=mZ8jyyWWHfhrQDYnOEGlGSJyrx9JsrsZ/CQmgOO9UpxpESZb8cqYklZf
   vGxm/ggxm8L4q1YIPw430V9z6tgnEtyHCWSaQj5fl/ym3he7m1ExS7hiQ
   QbyufHip6/QvEu5Mn+Qxe7h1OCGqzS9DlXiERO0Izptt6s7ESrrnrA1ny
   NAHM8gJilSZlQmkRoKRHsfXvhR1Ec7t8670icgcrNQWtFi6hTETyrCYaB
   3w//MyxNAQep0Jr50CA1ye0PUyzOBZf7uhnwg7npcktp4IkLA3XP0rbnI
   G5V0ZdVXJuITNeMSJSuPrBjYf+jrX+OIZ7Yt3MsH2IJS6+nBBVTuV0TIg
   g==;
Content-Language: en-US
In-Reply-To: <20230127141136.GG3527-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


On 27/01/2023 14:11, Michal Koutn=C3=BD wrote:
> On Fri, Jan 27, 2023 at 01:31:54PM +0000, Tvrtko Ursulin <tvrtko.ursulin-=
VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>> I think you missed the finish_suspend_scanning() part:
>>
>> 	if (root_drmcs.suspended_period_us)
>> 		cancel_delayed_work_sync(&root_drmcs.scan_work);
>>
>> So if scanning was in progress migration will wait until it finishes.
>=20
> Indeed, I've missed that. Thank you!
>=20
>> Not claiming I did not miss something because I was totally new with cgr=
oup
>> internals when I started working on this. So it is definitely useful to =
have
>> more eyes looking.
>=20
> The custom with (especially v2, especially horizontal) migrations
> is that they're treated leniently to avoid performance costs.
>=20
> I'm afraid waiting for scan in can_attach() can propagate globally (via
> cgroup_update_dfl_csses() and cgroup_attach_lock()) sometimes.

That something along those lines might be a concern was indeed worrying=20
me when coming up with the scheme. Good inside knowledge hint, thank=20
you. I will have a deeper look.

> OTOH, unless I misunderstood, you need to cover explicit (not task but
> resource, when sending client FD around) migration anyway?

Correct. So far that was handled outside the cgroup controller in the=20
drm layer and any lock dependency propagation was hidden behind RCU.
But that will likely change once I try your suggestion of eliminating=20
the struct pid based client tracking and so become relevant.

> (I.e. my suggestion would be to mutualy exclude scanning and explicit
> migration but not scanning and task migration in order to avoid possible
> global propagation.)

Thanks, I will look into this all hopefully shortly. Perhaps what you=20
suggest will come naturally with the removal of struct pid based tracking.

Regards,

Tvrtko
