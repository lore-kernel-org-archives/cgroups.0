From: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [Intel-gfx] [RFC PATCH 0/4] Add support for DRM cgroup memory
 accounting.
Date: Thu, 11 May 2023 21:58:02 +0200
Message-ID: <a7200fd7-769c-6a32-0fa7-6a37b7214d70@linux.intel.com>
References: <20230503083500.645848-1-maarten.lankhorst@linux.intel.com>
 <ZFVeI2DKQXddKDNl@slm.duckdns.org>
 <4d6fbce3-a676-f648-7a09-6f6dcc4bdb46@linux.intel.com>
 <ZFvmaGNo0buQEUi1@slm.duckdns.org>
 <562bd20d-36b9-a617-92cc-460f2eece22e@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683835089; x=1715371089;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oZQ2G4WUfAcfYRxx/1cCaNzzx8xkE/WLQXfCP4Oc3BE=;
  b=J1Q9LW9qKHiIAECKGTfYpf0wRw0t0TKBr2XKntWceh6atxq2mcQwpcD7
   zosXh86LgRMA/Ovu+YtL59JbN8spLECJNs/rfZXs0v9Q+B01nOW7aMMcw
   qUxcDnIrFbenMxRocOVva1vbXfekzNLJ6L92NCDZsuOfYYfNV+iFy1LSR
   3BWB5lK8Bm8kIDQ+iPKFcUyBiYMdMn/1nP/qxWea0zJCXs5Uxo+Rn0rJB
   T59w9YnMKWeXYA/0IKmXO2uB0/Ou+FDcx0+Zymj1Zmoqk4btxPdmJp6V1
   W3Mv5LwrX/+bt2kuyYKHmBNyErmTpy4m8maym2vJs+CuAuaColSjfbm1x
   A==;
Content-Language: en-US
In-Reply-To: <562bd20d-36b9-a617-92cc-460f2eece22e-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, intel-xe-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org

Hey,

On 2023-05-11 12:14, Tvrtko Ursulin wrote:
>
> On 10/05/2023 19:46, Tejun Heo wrote:
>> Hello,
>>
>> On Wed, May 10, 2023 at 04:59:01PM +0200, Maarten Lankhorst wrote:
>>> The misc controller is not granular enough. A single computer may have =
any number of
>>> graphics cards, some of them with multiple regions of vram inside a sin=
gle card.
>>
>> Extending the misc controller to support dynamic keys shouldn't be that
>> difficult.
>>
>> ...
>>> In the next version, I will move all the code for handling the resource=
 limit to
>>> TTM's eviction layer, because otherwise it cannot handle the resource l=
imit correctly.
>>>
>>> The effect of moving the code to TTM, is that it will make the code eve=
n more generic
>>> for drivers that have vram and use TTM. When using TTM, you only have t=
o describe your
>>> VRAM, update some fields in the TTM manager and (un)register your devic=
e with the
>>> cgroup handler on (un)load. It's quite trivial to add vram accounting t=
o amdgpu and
>>> nouveau. [2]
>>>
>>> If you want to add a knob for scheduling weight for a process, it makes=
 sense to
>>> also add resource usage as a knob, otherwise the effect of that knob is=
 very
>>> limited. So even for Tvrtko's original proposed usecase, it would make =
sense.
>>
>> It does make sense but unlike Tvrtko's scheduling weights what's being
>> proposed doesn't seem to encapsulate GPU memory resource in a generic en=
ough
>> manner at least to my untrained eyes. ie. w/ drm.weight, I don't need any
>> specific knoweldge of how a specific GPU operates to say "this guy should
>> get 2x processing power over that guy". This more or less holds for other
>> major resources including CPU, memory and IO. What you're proposing seem=
s a
>> lot more tied to hardware details and users would have to know a lot more
>> about how memory is configured on that particular GPU.
>>
>> Now, if this is inherent to how all, or at least most, GPUs operate, sur=
e,
>> but otherwise let's start small in terms of interface and not take up sp=
ace
>> which should be for something universal. If this turns out to be the way,
>> expanding to take up the generic interface space isn't difficult.
>>
>> I don't know GPU space so please educate me where I'm wrong.
>
> I was hoping it might be passable in principle (in some form, pending dis=
cussion on semantics) given how Maarten's proposal starts with only very sp=
ecific per-device-per-memory regions controls, which is applicable to many =
devices. And hard limit at that, which probably has less complicated semant=
ics, or at least implementation.
>
> My understanding of the proposal is that the allocation either fits, or i=
t evicts from the parent's hierarchy (if possible) and then fits, or it fai=
ls. Which sounds simple enough.

Yeah, for vram it=C5=9B that simple. I think for mapped and sysmem regions =
we may require the
possiblity to ignore the limits as well, as it's possible to move to those =
regions from
eviction. We probably don't want eviction to fail because of too low limits.

> I do however agree that it is a limited use case. So from the negative si=
de of the debating camp I have to ask if this use case could be simply sati=
sfied by providing a driver/device global over commit yes/no control? In ot=
her words, is it really important to partition the vram space ahead of time=
, and from the kernel side too? Wouldn't the relevant (highly specialised) =
applications work just fine with global over commit disabled? Even if the o=
ption to configure their maximum allowed working set from the userspace sid=
e was needed.

Disabling overcommit? Do you mean pinning the memory workload? This causes =
a denial of service if
done without limits, and that's what we're trying to avoid. There is no nee=
d for immunity from
eviction. Overcommit is still useful inside the cgroup itself, we only want=
 immunity from being
evicted by another process performing another workload.

> Or if we conclude cgroup controller is the way to go, would adding less s=
pecific limits make it more palatable? I am thinking here some generic "dev=
ice memory resident". Not per device, not per memory region. So userspace/a=
dmins have some chance of configuring generic limits. That would require co=
ming up with more generic use cases though so another thing to discuss. Lik=
e who would use that and for what.

You would run into ambiguity with that. I think it's fine to assume any num=
ber of vram regions. In most cases, the number is 1.

I don't see that number going much higher, 2 is already on the high side. A=
 simple controller could just half each region separately.

> Assuming also we can agree that "device memory resident" is a stable/soli=
d concept across drm. Should be easier than for integrated GPUs, for which =
I have to admit I currently don't remember if allocations are already consi=
stently covered by the memory controller. Even if they are ownership is pro=
bably wrong.
Likely, especially when evicting another process' memory. That needs some t=
hought. Likely we have to keep the original cgroup as an owner.
> Group ownership is possibly a concern in this proposal too. Because I rem=
ember the previous attempt of adding some drm stats to memcg explained that=
 for instance on Android all buffers are allocated by a central process and=
 then handed over to other processes. So transferring ownership was explain=
ed as critical.
Is this done using dma-buf? Ownership could be handed over on import then. =
If not, what is the mechanism they use?
> Regards,
>
> Tvrtko
>
> P.S.
> On the matter of naming the uapi interface - in any case I wouldn't use t=
he "unqualified" drm namespace such as drm.max/current/capacity. I think al=
l those should include a specific prefix to signify it is about memory. In =
some way.

I've deliberately added region to each key, so what happens is that drm.cap=
acity/max/current contains: $pciid region.vram0=3D$value, that way, if we w=
ant to add non-memory resources, it becomes possible to do so by choosing a=
 different prefix.

For example number of engines that can be created would also be possible to=
 add to those files, but that might be more driver specific.

I tried to keep it generic like that. In this way I didn't immediately poll=
ute the entire namespace.

Of course, if needed, we can make it drm.region_max etc instead and drop it=
 from the cgroup key entries instead.

Cheers,

Maarten

