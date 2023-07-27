From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 16/17] cgroup/drm: Expose memory stats
Date: Thu, 27 Jul 2023 17:43:33 +0100
Message-ID: <6ed5478c-8a67-5ad8-3e6d-51c300702cf3@linux.intel.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-17-tvrtko.ursulin@linux.intel.com>
 <ZLsFBHqCQdPHoZVw@slm.duckdns.org>
 <ea64d7bf-c01b-f4ad-a36b-f77e2c2ea931@linux.intel.com>
 <ZMF3rLioJK9QJ0yj@slm.duckdns.org>
 <05178cf3-df1c-80a7-12ad-816fafbc2df7@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690476220; x=1722012220;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EPPEG5IjRpK3UjK14v1TE0oHNl+auGdkynzlUa5wKQI=;
  b=LeAxHdSe4yD2QqqGpjKi6F0xw1xll7EEwTxXwCwXwKPK+NCzBS0UtlBX
   JkZCytIyjIY3E0Qt+ArKjv+h1T0BXP+0KJT7vVMSNda4Zan21qb0lk1En
   o9/0CvJnkNFAIUeAUEEGaOXRyRSJJEdrzshGDcVwmKbmBqBzUrpiaNUKI
   tzreaMKR+6TTxpT0zy1gZ6QT77HuuQ0tuN0sDN2JzwnjGLMbgYzC0drTl
   iBZqCqxVxt+W4ZXImlBM/4vbP6VeVrPcWL2nB+bXaVqcT4ulZStd4FW03
   3rQCqkP7r29CEXEbidVTmyNGtuAnkPZklzUsOGKcIeyqVd2/qxdHSFoLA
   A==;
Content-Language: en-US
In-Reply-To: <05178cf3-df1c-80a7-12ad-816fafbc2df7-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


On 27/07/2023 14:42, Maarten Lankhorst wrote:
> On 2023-07-26 21:44, Tejun Heo wrote:
>> Hello,
>>
>> On Wed, Jul 26, 2023 at 12:14:24PM +0200, Maarten Lankhorst wrote:
>>>> So, yeah, if you want to add memory controls, we better think 
>>>> through how
>>>> the fd ownership migration should work.
>>>
>>> I've taken a look at the series, since I have been working on cgroup 
>>> memory
>>> eviction.
>>>
>>> The scheduling stuff will work for i915, since it has a purely software
>>> execlist scheduler, but I don't think it will work for GuC (firmware)
>>> scheduling or other drivers that use the generic drm scheduler.
>>>
>>> For something like this,  you would probably want it to work inside 
>>> the drm
>>> scheduler first. Presumably, this can be done by setting a weight on 
>>> each
>>> runqueue, and perhaps adding a callback to update one for a running 
>>> queue.
>>> Calculating the weights hierarchically might be fun..
>>
>> I don't have any idea on this front. The basic idea of making high level
>> distribution decisions in core code and letting individual drivers 
>> enforce
>> that in a way which fits them the best makes sense to me but I don't know
>> enough to have an opinion here.
>>
>>> I have taken a look at how the rest of cgroup controllers change 
>>> ownership
>>> when moved to a different cgroup, and the answer was: not at all. If we
>>
>> For persistent resources, that's the general rule. Whoever instantiates a
>> resource gets to own it until the resource gets freed. There is an 
>> exception
>> with the pid controller and there are discussions around whether we want
>> some sort of migration behavior with memcg but yes by and large 
>> instantiator
>> being the owner is the general model cgroup follows.
>>
>>> attempt to create the scheduler controls only on the first time the 
>>> fd is
>>> used, you could probably get rid of all the tracking.
>>> This can be done very easily with the drm scheduler.
>>>
>>> WRT memory, I think the consensus is to track system memory like normal
>>> memory. Stolen memory doesn't need to be tracked. It's kernel only 
>>> memory,
>>> used for internal bookkeeping  only.
>>>
>>> The only time userspace can directly manipulate stolen memory, is by 
>>> mapping
>>> the pinned initial framebuffer to its own address space. The only 
>>> allocation
>>> it can do is when a framebuffer is displayed, and framebuffer 
>>> compression
>>> creates some stolen memory. Userspace is not
>>> aware of this though, and has no way to manipulate those contents.
>>
>> So, my dumb understanding:
>>
>> * Ownership of an fd can be established on the first ioctl call and 
>> doesn't
>>    need to be migrated afterwards. There are no persistent resources to
>>    migration on the first call.

Yes, keyword is "can". Trouble is migration may or may not happen.

One may choose "Plasma X.org" session type in your login manager and all 
DRM fds would be under Xorg if not migrated. Or one may choose "Plasma 
Wayland" and migration wouldn't matter. But former is I think has a huge 
deployed base so that not supporting implicit migration would be a 
significant asterisk next to the controller.

>> * Memory then can be tracked in a similar way to memcg. Memory gets 
>> charged
>>    to the initial instantiator and doesn't need to be moved around
>>    afterwards. There may be some discrepancies around stolen memory 
>> but the
>>    magnitude of inaccuracy introduced that way is limited and bound 
>> and can
>>    be safely ignored.
>>
>> Is that correct?
> 
> Hey,
> 
> Yeah mostly, I think we can stop tracking stolen memory. I stopped doing 
> that for Xe, there is literally nothing to control for userspace in there.

Right, but for reporting stolen is a red-herring. In this RFC I simply 
report on all memory regions known by the driver. As I said in the other 
reply, imagine the keys are 'system' and 'vram0'. Point was just to 
illustrate multiplicity of regions.

Regards,

Tvrtko
