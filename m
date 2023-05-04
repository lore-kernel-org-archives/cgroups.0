From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Thu, 04 May 2023 21:58:56 +1000
Message-ID: <874josz4rd.fsf@nvidia.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5szf8TwFuAsz9A0LEeXgJT6P+vT32Z4m/UJu+0Anuc=;
 b=QgGD0nxqIFar0Uf+siJYdSZOsB3OAYx+WQ2OSYwJ4jJU0BEtt1aYEyTQodAzKU742vVFfynZ8+u+UZKEM/4wRWhKxivkXpmBMnk6GPIDE3xnvK01Yv+n8f0BYMG6bPD1psypbW01AFba/1aGP7yVR2ALOWzeG3SNXgGI2vyLxVQgUdiBWmWZzP3rPbH4/gq/NGNzaBIPaenM/kTzt0AySwBCgoRwS2ifdj1qwmIK9C+K3zBQeFWK6Ak/oBPXsAxUSCKxLxEoD2++FP9+EHPnohHwGC4vb2OboRbFJdanNtaXriI1vgEGvUJ3ypnDT7VmdiO/n/kSiJb1GGo6Se3IMw==
In-reply-to: <ZFLdDyHoIdJSXJt+-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Hi T.J.,
>
> On Tue, Apr 11, 2023 at 04:36:37PM -0700, T.J. Mercier wrote:
>> When a memcg is removed by userspace it gets offlined by the kernel.
>> Offline memcgs are hidden from user space, but they still live in the
>> kernel until their reference count drops to 0. New allocations cannot
>> be charged to offline memcgs, but existing allocations charged to
>> offline memcgs remain charged, and hold a reference to the memcg.
>>=20
>> As such, an offline memcg can remain in the kernel indefinitely,
>> becoming a zombie memcg. The accumulation of a large number of zombie
>> memcgs lead to increased system overhead (mainly percpu data in struct
>> mem_cgroup). It also causes some kernel operations that scale with the
>> number of memcgs to become less efficient (e.g. reclaim).
>>=20
>> There are currently out-of-tree solutions which attempt to
>> periodically clean up zombie memcgs by reclaiming from them. However
>> that is not effective for non-reclaimable memory, which it would be
>> better to reparent or recharge to an online cgroup. There are also
>> proposed changes that would benefit from recharging for shared
>> resources like pinned pages, or DMA buffer pages.
>
> I am also interested in this topic. T.J. and I have some offline
> discussion about this. We have some proposals to solve this
> problem.
>
> I will share the write up here for the up coming LSF/MM discussion.

Unfortunately I won't be attending LSF/MM in person this year but I am
interested in this topic as well from the point of view of limiting
pinned pages with cgroups. I am hoping to revive this patch series soon:

https://lore.kernel.org/linux-mm/cover.c238416f0e82377b449846dbb2459ae9d703=
0c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org/

The main problem with this series was getting agreement on whether to
add pinning as a separate cgroup (which is what the series currently
does) or whether it should be part of a per-page memcg limit.

The issue with per-page memcg limits is what to do for shared
mappings. The below suggestion sounds promising because the pins for
shared pages could be charged to the smemcg. However I'm not sure how it
would solve the problem of a process in cgroup A being able to raise the
pin count of cgroup B when pinning a smemcg page which was one of the
reason I introduced a new cgroup controller.

> Shared Memory Cgroup Controllers
>
> =3D Introduction
>
> The current memory cgroup controller does not support shared memory
> objects. For the memory that is shared between different processes, it
> is not obvious which process should get charged. Google has some
> internal tmpfs =E2=80=9Cmemcg=3D=E2=80=9D mount option to charge tmpfs da=
ta to a
> specific memcg that=E2=80=99s often different from where charging process=
es
> run. However it faces some difficulties when the charged memcg exits
> and the charged memcg becomes a zombie memcg.
> Other approaches include =E2=80=9Cre-parenting=E2=80=9D the memcg charge =
to the parent
> memcg. Which has its own problem. If the charge is huge, iteration of
> the reparenting can be costly.
>
> =3D Proposed Solution
>
> The proposed solution is to add a new type of memory controller for
> shared memory usage. E.g. tmpfs, hugetlb, file system mmap and
> dma_buf. This shared memory cgroup controller object will have the
> same life cycle of the underlying shared memory.
>
> Processes can not be added to the shared memory cgroup. Instead the
> shared memory cgroup can be added to the memcg using a =E2=80=9Csmemcg=E2=
=80=9D API
> file, similar to adding a process into the =E2=80=9Ctasks=E2=80=9D API fi=
le.
> When a smemcg is added to the memcg, the amount of memory that has
> been shared in the memcg process will be accounted for as the part of
> the memcg =E2=80=9Cmemory.current=E2=80=9D.The memory.current of the memc=
g is make up
> of two parts, 1) the processes anonymous memory and 2) the memory
> shared from smemcg.
>
> When the memcg =E2=80=9Cmemory.current=E2=80=9D is raised to the limit. T=
he kernel
> will active try to reclaim for the memcg to make =E2=80=9Csmemcg memory +
> process anonymous memory=E2=80=9D within the limit.

That means a process in one cgroup could force reclaim of smemcg memory
in use by a process in another cgroup right? I guess that's no different
to the current situation though.

> Further memory allocation
> within those memcg processes will fail if the limit can not be
> followed. If many reclaim attempts fail to bring the memcg
> =E2=80=9Cmemory.current=E2=80=9D within the limit, the process in this me=
mcg will get
> OOM killed.

How would this work if say a charge for cgroup A to a smemcg in both
cgroup A and B would cause cgroup B to go over its memory limit and not
enough memory could be reclaimed from cgroup B? OOM killing a process in
cgroup B due to a charge from cgroup A doesn't sound like a good idea.

> =3D Benefits
>
> The benefits of this solution include:
> * No zombie memcg. The life cycle of the smemcg match the share memory fi=
le system or dma_buf.

If we added pinning it could get a bit messier, as it would have to hang
around until the driver unpinned the pages. But I don't think that's a
problem.

> * No reparenting. The shared memory only charge once to the smemcg
> object. A memcg can include a smemcg to as part of the memcg memory
> usage. When process exit and memcg get deleted, the charge remain to
> the smemcg object.
> * Much cleaner mental model of the smemcg, each share memory page is char=
ge to one smemcg only once.
> * Notice the same smemcg can add to more than one memcg. It can better
> describe the shared memory relation.
>
> Chris
>
>
>
>> Suggested attendees:
>> Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>> Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>=20

