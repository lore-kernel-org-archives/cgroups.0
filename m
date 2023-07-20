From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC v5 00/17] DRM cgroup controller with scheduling control and
 memory stats
Date: Thu, 20 Jul 2023 11:55:11 +0100
Message-ID: <95de5c1e-f03b-8fb7-b5ef-59ac7ca82f31@linux.intel.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <CABdmKX1PUF+X897ZMOr0RNiYdoiL_2NkcSt+Eh55BfW-05LopQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689850518; x=1721386518;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1nzPh2ldW7JFgjNWEhtnVlvHO52nCzC4d7AFlh05n7E=;
  b=cVnn+wmexiQEqOxlofbZGplFs6GulSrxjEtfvEJFbDlqGRKE537h5wSj
   yzaVbv9aIfs2grPxKeOYq+JVUuPXiTZQIxBwISyi5a/zpQ/Y56HcjoLyI
   uprlf2rKQalk9JBctkKiSB8CljYKZPwRhHXVniiEDr70Upz5EIZpTi6/3
   zxqJXctyHggP7ToyltD+VsHwVl0g99nHZ/RSS93Wu1jkUbdQ1cwR2XJv7
   EcAA7wZTZ/5MZ1dhOJ1HX31ZyYfSVUeFInLKQY+8zxW9WzEu/hUVyUwqG
   b2keXxaMj/cWpoWzBHMrBw3h109zoglbBsjXM+zyPf2X8BEt9sZDSd096
   g==;
Content-Language: en-US
In-Reply-To: <CABdmKX1PUF+X897ZMOr0RNiYdoiL_2NkcSt+Eh55BfW-05LopQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


Hi,

On 19/07/2023 21:31, T.J. Mercier wrote:
> On Wed, Jul 12, 2023 at 4:47=E2=80=AFAM Tvrtko Ursulin
> <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>>
>>    drm.memory.stat
>>          A nested file containing cumulative memory statistics for the w=
hole
>>          sub-hierarchy, broken down into separate GPUs and separate memo=
ry
>>          regions supported by the latter.
>>
>>          For example::
>>
>>            $ cat drm.memory.stat
>>            card0 region=3Dsystem total=3D12898304 shared=3D0 active=3D0 =
resident=3D12111872 purgeable=3D167936
>>            card0 region=3Dstolen-system total=3D0 shared=3D0 active=3D0 =
resident=3D0 purgeable=3D0
>>
>>          Card designation corresponds to the DRM device names and multip=
le line
>>          entries can be present per card.
>>
>>          Memory region names should be expected to be driver specific wi=
th the
>>          exception of 'system' which is standardised and applicable for =
GPUs
>>          which can operate on system memory buffers.
>>
>>          Sub-keys 'resident' and 'purgeable' are optional.
>>
>>          Per category region usage is reported in bytes.
>>
>>   * Feedback from people interested in drm.active_us and drm.memory.stat=
 is
>>     required to understand the use cases and their usefulness (of the fi=
elds).
>>
>>     Memory stats are something which was easy to add to my series, since=
 I was
>>     already working on the fdinfo memory stats patches, but the question=
 is how
>>     useful it is.
>>
> Hi Tvrtko,
>=20
> I think this style of driver-defined categories for reporting of
> memory could potentially allow us to eliminate the GPU memory tracking
> tracepoint used on Android (gpu_mem_total). This would involve reading
> drm.memory.stat at the root cgroup (I see it's currently disabled on

I can put it available under root too, don't think there is any=20
technical reason to not have it. In fact, now that I look at it again,=20
memory.stat is present on root so that would align with my general=20
guideline to keep the two as similar as possible.

> the root), which means traversing the whole cgroup tree under the
> cgroup lock to generate the values on-demand. This would be done
> rarely, but I still wonder what the cost of that would turn out to be.

Yeah that's ugly. I could eliminate cgroup_lock by being a bit smarter.=20
Just didn't think it worth it for the RFC.

Basically to account memory stats for any sub-tree I need the equivalent=20
one struct drm_memory_stats per DRM device present in the hierarchy. So=20
I could pre-allocate a few and restart if run out of spares, or=20
something. They are really small so pre-allocating a good number, based=20
on past state or something, should would good enough. Or even total=20
number of DRM devices in a system as a pessimistic and safe option for=20
most reasonable deployments.

> The drm_memory_stats categories in the output don't seem like a big
> value-add for this use-case, but no real objection to them being

You mean the fact there are different categories is not a value add for=20
your use case because you would only use one?

The idea was to align 1:1 with DRM memory stats fdinfo and somewhat=20
emulate how memory.stat also offers a breakdown.

> there. I know it's called the DRM cgroup controller, but it'd be nice
> if there were a way to make the mem tracking part work for any driver
> that wishes to participate as many of our devices don't use a DRM
> driver. But making that work doesn't look like it would fit very

Ah that would be a challenge indeed to which I don't have any answers=20
right now.

Hm if you have a DRM device somewhere in the chain memory stats would=20
still show up. Like if you had a dma-buf producer which is not a DRM=20
driver, but then that buffer was imported by a DRM driver, it would show=20
up in a cgroup. Or vice-versa. But if there aren't any in the whole=20
chain then it would not.

> cleanly into this controller, so I'll just shut up now.

Not all all, good feedback!

Regards,

Tvrtko
