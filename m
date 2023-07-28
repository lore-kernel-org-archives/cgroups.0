From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 16/17] cgroup/drm: Expose memory stats
Date: Fri, 28 Jul 2023 15:15:29 +0100
Message-ID: <0d51725f-d4d3-ae75-1d14-e9816cb8d33c@linux.intel.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-17-tvrtko.ursulin@linux.intel.com>
 <ZLsFBHqCQdPHoZVw@slm.duckdns.org>
 <ea64d7bf-c01b-f4ad-a36b-f77e2c2ea931@linux.intel.com>
 <89d7181c-6830-ca6e-0c39-caa49d14d474@linux.intel.com>
 <fb734626-6041-1e68-38d7-221837284cf1@linux.intel.com>
 <5d65d387-2718-06c3-ee5d-8a7da6e3ddfd@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690553739; x=1722089739;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=AZ/ocz0hEyx4b7zjwB+nv50Nb+TCW7LuxkGS/3Orf7M=;
  b=MMohJhwRXLC5sVZtoRZsxTLJc5rdelLxmOOy6SOJyzDlIyD0hSdwxYB8
   bvLziTmxNWkWra1cyo/3T1Zl2YQBEnS9GQVf3IRqfKf9UF+lCR9m7dIY0
   qVAw2n2nQ+YgISJY7W9mY8g3ikXbrOEGUbxQUuQRHde4sMuInjKyFaUGF
   KteOn7qdUQO2+uOO3kV4Jo1Cn3g1JnBZoY8j0jGh/YUwjDG7K9J2h4SwT
   AfTCPtxmTbdjtI0WunbaDVbcxVXohz8qvGw9Oth4W/8zWBW2BbmxaRdyJ
   +OvRbXcNTcJC2t/hNE4e5tTDsGSSNp8ejkfwS2T9sMQbK/G5nDzN9vQFK
   A==;
Content-Language: en-US
In-Reply-To: <5d65d387-2718-06c3-ee5d-8a7da6e3ddfd-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


One additional thought on one sub-topic:

On 27/07/2023 18:08, Tvrtko Ursulin wrote:

[snip]

>>>> For something like this,=C2=A0 you would probably want it to work insi=
de=20
>>>> the drm scheduler first. Presumably, this can be done by setting a=20
>>>> weight on each runqueue, and perhaps adding a callback to update one=20
>>>> for a running queue. Calculating the weights hierarchically might be=20
>>>> fun..
>>>
>>> It is not needed to work in drm scheduler first. In fact drm=20
>>> scheduler based drivers can plug into what I have since it already=20
>>> has the notion of scheduling priorities.
>>>
>>> They would only need to implement a hook which allow the cgroup=20
>>> controller to query client GPU utilisation and another to received=20
>>> the over budget signal.
>>>
>>> Amdgpu and msm AFAIK could be easy candidates because they both=20
>>> support per client utilisation and priorities.
>>>
>>> Looks like I need to put all this info back into the cover letter.
>>>
>>> Also, hierarchic weights and time budgets are all already there. What=20
>>> could be done later is make this all smarter and respect the time=20
>>> budget with more precision. That would however, in many cases=20
>>> including Intel, require co-operation with the firmware. In any case=20
>>> it is only work in the implementation, while the cgroup control=20
>>> interface remains the same.
>>>
>>>> I have taken a look at how the rest of cgroup controllers change=20
>>>> ownership when moved to a different cgroup, and the answer was: not=20
>>>> at all. If we attempt to create the scheduler controls only on the=20
>>>> first time the fd is used, you could probably get rid of all the=20
>>>> tracking.
>>>
>>> Can you send a CPU file descriptor from process A to process B and=20
>>> have CPU usage belonging to process B show up in process' A cgroup,=20
>>> or vice-versa? Nope, I am not making any sense, am I? My point being=20
>>> it is not like-to-like, model is different.
>>>
>>> No ownership transfer would mean in wide deployments all GPU=20
>>> utilisation would be assigned to Xorg and so there is no point to any=20
>>> of this. No way to throttle a cgroup with un-important GPU clients=20
>>> for instance.
>> If you just grab the current process' cgroup when a drm_sched_entity=20
>> is created, you don't have everything charged to X.org. No need for=20
>> complicated ownership tracking in drm_file. The same equivalent should=20
>> be done in i915 as well when a context is created as it's not using=20
>> the drm scheduler.
>=20
> Okay so essentially nuking the concept of DRM clients belongs to one=20
> cgroup and instead tracking at the context level. That is an interesting =

> idea. I suspect implementation could require somewhat generalizing the=20
> concept of an "execution context", or at least expressing it via the DRM =

> cgroup controller.
>=20
> I can give this a spin, or at least some more detailed thought, once we=20
> close on a few more details regarding charging in general.

I didn't get much time to brainstorm this just yet, only one downside=20
randomly came to mind later - with this approach for i915 we wouldn't=20
correctly attribute any GPU activity done in the receiving process=20
against our default contexts. Those would still be accounted to the=20
sending process.

How much problem in practice that would be remains to be investigated,=20
including if it applies to other drivers too. If there is a good amount=20
of deployed userspace which use the default context, then it would be a=20
bit messy.

Regards,

Tvrtko

*) For non DRM and non i915 people, default context is a GPU submission=20
context implicitly created during the device node open. It always=20
remains valid, including in the receiving process if SCM_RIGHTS is used.
