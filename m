From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Fri, 05 May 2023 23:53:24 +1000
Message-ID: <877ctm518f.fsf@nvidia.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com> <874josz4rd.fsf@nvidia.com>
 <ZFPP71czDDxMPLQK@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFzTmHoD0YW+y+JyJp63tu3++Ylp2gWaHOWpJbm059w=;
 b=sA8OzQ6MUTpAebtpHyYbws/2Rq253+ioTTJIb6ocEIwLzsL6/2M85FEQIxEQaQbYBqL2XfKWzbFKek0CxoO7JcZknfqD6BSxGrrN23mNL1e8pwVuX4fRpbwmrYM6KqGrMjWXKUptoX7gD4VcqWj6gin9l22w3a8wY3Czq63Djxo/mUo9VO3MHYCQxzFBMSaVCMmSl1D6YqJUmXKMIBDtvJYO1BNx+9hjOGKpRcxf3TO8/hQ2SjU8+nhwjIEoRYejaU3IFe4zLX6em8h1xdLyubdCn1m9/JW8kmMRqkF8rx4HMsc4//rwZEO67+M6aKGa8qmAOn4UOfluTU5dgSHu5w==
In-reply-to: <ZFPP71czDDxMPLQK-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
 -text follows this line--
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> On Thu, May 04, 2023 at 09:58:56PM +1000, Alistair Popple wrote:
>>=20
>> Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
>>=20
>> > Hi T.J.,
>> >
>> > On Tue, Apr 11, 2023 at 04:36:37PM -0700, T.J. Mercier wrote:
>> >> When a memcg is removed by userspace it gets offlined by the kernel.
>> >> Offline memcgs are hidden from user space, but they still live in the
>> >> kernel until their reference count drops to 0. New allocations cannot
>> >> be charged to offline memcgs, but existing allocations charged to
>> >> offline memcgs remain charged, and hold a reference to the memcg.
>> >>=20
>> >> As such, an offline memcg can remain in the kernel indefinitely,
>> >> becoming a zombie memcg. The accumulation of a large number of zombie
>> >> memcgs lead to increased system overhead (mainly percpu data in struc=
t
>> >> mem_cgroup). It also causes some kernel operations that scale with th=
e
>> >> number of memcgs to become less efficient (e.g. reclaim).
>> >>=20
>> >> There are currently out-of-tree solutions which attempt to
>> >> periodically clean up zombie memcgs by reclaiming from them. However
>> >> that is not effective for non-reclaimable memory, which it would be
>> >> better to reparent or recharge to an online cgroup. There are also
>> >> proposed changes that would benefit from recharging for shared
>> >> resources like pinned pages, or DMA buffer pages.
>> >
>> > I am also interested in this topic. T.J. and I have some offline
>> > discussion about this. We have some proposals to solve this
>> > problem.
>> >
>> > I will share the write up here for the up coming LSF/MM discussion.
>>=20
>> Unfortunately I won't be attending LSF/MM in person this year but I am
>
> Will you be able to join virtually?

I should be able to join afternoon sessions virtually.

>> interested in this topic as well from the point of view of limiting
>> pinned pages with cgroups. I am hoping to revive this patch series soon:
>
>>=20
>> https://lore.kernel.org/linux-mm/cover.c238416f0e82377b449846dbb2459ae9d=
7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org/
>>=20
>> The main problem with this series was getting agreement on whether to
>> add pinning as a separate cgroup (which is what the series currently
>> does) or whether it should be part of a per-page memcg limit.
>>=20
>> The issue with per-page memcg limits is what to do for shared
>> mappings. The below suggestion sounds promising because the pins for
>> shared pages could be charged to the smemcg. However I'm not sure how it
>> would solve the problem of a process in cgroup A being able to raise the
>> pin count of cgroup B when pinning a smemcg page which was one of the
>> reason I introduced a new cgroup controller.
>
> Now that I think of it, I can see the pin count memcg as a subtype of
> smemcg.
>
> The smemcg can have a limit as well, when it add to a memcg, the operatio=
n
> raise the pin count smemcg charge over the smemcg limit will fail.

I'm not sure that works for the pinned scenario. If a smemcg already has
pinned pages adding it to another memcg shouldn't raise the pin count of
the memcg it's being added to. The pin counts should only be raised in
memcg's of processes actually requesting the page be pinned. See below
though, the idea of borrowing seems helpful.

So for pinning at least I don't see a per smemcg limit being useful.

> For the detail tracking of shared/unshared behavior, the smemcg can model=
 it
> as a step 2 feature.
>
> There are four different kind of operation can perform on a smemcg:
>
> 1) allocate/charge memory. The charge will add on the per smemcg charge
> counter, check against the per smemcg limit. ENOMEM if it is over the lim=
it.
>
> 2) free/uncharge memory. Similar to above just subtract the counter.
>
> 3) share/mmap already charged memory. This will not change the smemcg cha=
rge
> count, it will add to a per <smemcg, memcg> borrow counter. It is possibl=
e to
> put a limit on that counter as well, even though I haven't given too much=
 thought
> of how useful it is. That will limit how much memory can mapped from the =
smemcg.

I would like to see the idea of a borrow counter fleshed out some more
but this sounds like it could work for the pinning scenario.

Pinning could be charged to the per <smemcg, memcg> borrow counter and
the pin limit would be enforced against that plus the anonymous pins.

Implementation wise we'd need a way to lookup both the smemcg of the
struct page and the memcg that the pinning task belongs to.

> 4) unshare/unmmap already charged memory. That will reduce the per <smemc=
g, memcg>
> borrow counter.

Actually this is where things might get a bit tricky for pinning. We'd
have to reduce the pin charge when a driver calls put_page(). But that
implies looking up the borrow counter / <smemcg, memcg> pair a driver
charged the page to.

I will have to give this idea some more tought though. Most drivers
don't store anything other than the struct page pointers, but my series
added an accounting struct which I think could reference the borrow
counter.

> Will that work for your pin memory usage?

I think it could help. I will give it some thought.

>>=20
>> > Shared Memory Cgroup Controllers
>> >
>> > =3D Introduction
>> >
>> > The current memory cgroup controller does not support shared memory
>> > objects. For the memory that is shared between different processes, it
>> > is not obvious which process should get charged. Google has some
>> > internal tmpfs =E2=80=9Cmemcg=3D=E2=80=9D mount option to charge tmpfs=
 data to a
>> > specific memcg that=E2=80=99s often different from where charging proc=
esses
>> > run. However it faces some difficulties when the charged memcg exits
>> > and the charged memcg becomes a zombie memcg.
>> > Other approaches include =E2=80=9Cre-parenting=E2=80=9D the memcg char=
ge to the parent
>> > memcg. Which has its own problem. If the charge is huge, iteration of
>> > the reparenting can be costly.
>> >
>> > =3D Proposed Solution
>> >
>> > The proposed solution is to add a new type of memory controller for
>> > shared memory usage. E.g. tmpfs, hugetlb, file system mmap and
>> > dma_buf. This shared memory cgroup controller object will have the
>> > same life cycle of the underlying shared memory.
>> >
>> > Processes can not be added to the shared memory cgroup. Instead the
>> > shared memory cgroup can be added to the memcg using a =E2=80=9Csmemcg=
=E2=80=9D API
>> > file, similar to adding a process into the =E2=80=9Ctasks=E2=80=9D API=
 file.
>> > When a smemcg is added to the memcg, the amount of memory that has
>> > been shared in the memcg process will be accounted for as the part of
>> > the memcg =E2=80=9Cmemory.current=E2=80=9D.The memory.current of the m=
emcg is make up
>> > of two parts, 1) the processes anonymous memory and 2) the memory
>> > shared from smemcg.
>> >
>> > When the memcg =E2=80=9Cmemory.current=E2=80=9D is raised to the limit=
. The kernel
>> > will active try to reclaim for the memcg to make =E2=80=9Csmemcg memor=
y +
>> > process anonymous memory=E2=80=9D within the limit.
>>=20
>> That means a process in one cgroup could force reclaim of smemcg memory
>> in use by a process in another cgroup right? I guess that's no different
>> to the current situation though.
>>=20
>> > Further memory allocation
>> > within those memcg processes will fail if the limit can not be
>> > followed. If many reclaim attempts fail to bring the memcg
>> > =E2=80=9Cmemory.current=E2=80=9D within the limit, the process in this=
 memcg will get
>> > OOM killed.
>>=20
>> How would this work if say a charge for cgroup A to a smemcg in both
>> cgroup A and B would cause cgroup B to go over its memory limit and not
>> enough memory could be reclaimed from cgroup B? OOM killing a process in
>> cgroup B due to a charge from cgroup A doesn't sound like a good idea.
>
> If we separate out the charge counter with the borrow counter, that probl=
em
> will be solved. When smemcg is add to memcg A, we can have a policy speci=
fic
> that adding the <smemcg, memcg A> borrow counter into memcg A's "memory.c=
urrent".
>
> If B did not map that page, that page will not be part of <smemcg, memcg =
B>
> borrow count. B will not be punished.
>
> However if B did map that page, The <smemcg, memcg B> need to increase as=
 well.
> B will be punished for it.
>
> Will that work for your example situation?

I think so, although I have been looking at this more from the point of
view of pinning. It sounds like we could treat pinning in much the same
way as mapping though.

>> > =3D Benefits
>> >
>> > The benefits of this solution include:
>> > * No zombie memcg. The life cycle of the smemcg match the share memory=
 file system or dma_buf.
>>=20
>> If we added pinning it could get a bit messier, as it would have to hang
>> around until the driver unpinned the pages. But I don't think that's a
>> problem.
>
>
> That is exactly the reason pin memory can belong to a pin smemcg. You jus=
t need
> to model the driver holding the pin ref count as one of the share/mmap op=
eration.
>
> Then the pin smemcg will not go away if there is a pending pin ref count =
on it.
>
> We have have different policy option on smemcg.
> For the simple usage don't care the per memcg borrow counter, it can add =
the
> smemcg's charge count to "memory.current".
>
> Only the user who cares about per memcg usage of a smemcg will need to ma=
intain
> per <smemcg, memcg> borrow counter, at additional cost.

Right, I think pinning drivers will always have to care about the borrow
counter so will have to track that.

> Chris

