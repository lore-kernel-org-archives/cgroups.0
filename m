From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Mon, 08 May 2023 18:17:04 +1000
Message-ID: <87ttwnkzap.fsf@nvidia.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com> <874josz4rd.fsf@nvidia.com>
 <ZFPP71czDDxMPLQK@google.com> <877ctm518f.fsf@nvidia.com>
 <ZFbZZPkSpsKMe8iR@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZYqlWBIOQb7Beaw5luDQ+ZrBuPRiMyUf1eS0TLTTRw=;
 b=r+sGJHCToRJzvlvaZ6AWgm++v7ASryxXJa8WnMDg3qVoUaKK6QCIdCBr9C+vLDeYW6WTJxF3RSuBExKeeTIj6SzbkNsfplB11HcWwn/Qfvn1wFz7WK73+RGcZARnj4eDi/h0eJu6+4DqR8JPlHJX20nPTNQvK/SU5h0PTTgcUwjhTQQaluueSP5Y1xQWofSJcPxwGjLTf0QkqH24C3Yp4MxH5JlSi2kUJ8m4HWEB8U3al4Vxf6G6QwFbV/tw4YDeNk0hXn2zJgPesQD0tj63Yo5y93ZjiH1pzgc18nS1h7BW4L8Os3lG4mUBYVSw7gZqNeHM7DC30kuLpdsanDHenQ==
In-reply-to: <ZFbZZPkSpsKMe8iR-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> On Fri, May 05, 2023 at 11:53:24PM +1000, Alistair Popple wrote:
>>=20
>> >> Unfortunately I won't be attending LSF/MM in person this year but I a=
m
>> >
>> > Will you be able to join virtually?
>>=20
>> I should be able to join afternoon sessions virtually.
>
> Great.

Actually I don't have an invite so might not make it. However I believe
Jason Gunthorpe is there and he has been helping with this as well so he
might be able to attend the session. Or we could discuss it in one of
the Linux MM biweeklies. (TBH I've been busy on other work and am only
just getting back up to speed on this myself).

>> >> The issue with per-page memcg limits is what to do for shared
>> >> mappings. The below suggestion sounds promising because the pins for
>> >> shared pages could be charged to the smemcg. However I'm not sure how=
 it
>> >> would solve the problem of a process in cgroup A being able to raise =
the
>> >> pin count of cgroup B when pinning a smemcg page which was one of the
>> >> reason I introduced a new cgroup controller.
>> >
>> > Now that I think of it, I can see the pin count memcg as a subtype of
>> > smemcg.
>> >
>> > The smemcg can have a limit as well, when it add to a memcg, the opera=
tion
>> > raise the pin count smemcg charge over the smemcg limit will fail.
>>=20
>> I'm not sure that works for the pinned scenario. If a smemcg already has
>> pinned pages adding it to another memcg shouldn't raise the pin count of
>> the memcg it's being added to. The pin counts should only be raised in
>> memcg's of processes actually requesting the page be pinned. See below
>> though, the idea of borrowing seems helpful.
>
> I am very interested in letting smemcg=C2=A0support your pin usage case.
> I read your patch thread a bit but I still feel a bit fuzzy about
> the pin usage workflow.

Thanks!

> If you have some more detailed write up of the usage case, with a sequenc=
e
> of interaction and desired outcome that would help me understand. Links t=
o
> the previous threads work too.

Unfortunately I don't (yet) have a detailed write up. But the primary
use case we had in mind was sandboxing of containers and qemu instances
to be able to limit the total amount of memory they can pin.

This is just like the existing RLIMIT, just with the limit assigned via
a cgroup instead of a per-process or per-user limit as they can easily
be subverted, particularly the per-process limit.

The sandboxing requirement is what drove us to not use the existing
per-page memcg. For private mappings it would be fine because the page
would only ever be mapped by a process in a single cgroup (ie. a single
memcg).

However for shared mappings it isn't - processes in different cgroups
could be mapping the same page but the accounting should happen to the
cgroup the process is in, not the cgroup that happens to "own" the page.

It is also possible that the page might not be mapped at all. For
example a driver may be pinning a page with pin_user_pages(), but the
userspace process may have munmap()ped it.

For drivers pinned memory is generally associated with some operation on
a file-descriptor. So the desired interaction/outcome is:

1. Process in cgroup A opens file-descriptor
2. Calls an ioctl() on the FD to pin memory.
3. Driver charges the memory to a counter and checks it's under the
   limit.
4. If over limit the ioctl() will fail.

This is effectively how the vm_pinned/locked RLIMIT works today. Even if
a shared page is already pinned the process should still be "punished"
for pinning the page. Hence the interest in the total <smemcg, memcg>
limit.

Pinned memory may also outlive the process that created it - drivers
associate it via a file-descriptor not a process and even if the FD is
closed there's nothing say a driver has to unpin the memory then
(although most do).

> We can set up some meetings to discuss it as well.
>
>> So for pinning at least I don't see a per smemcg limit being useful.
>
> That is fine.  I see you are interested in the <smemcg, memcg> limit.

Right, because it sounds like it will allow pinning the same struct page
multiple times to result in multiple charges. With the current memcg
implementation this isn't possible because a page can only be associated
with a single memcg.

A limit on just smemcg doesn't seem useful from a sandboxing perspective
because processes from other cgroups can use up the limit.

>> > For the detail tracking of shared/unshared behavior, the smemcg can mo=
del it
>> > as a step 2 feature.
>> >
>> > There are four different kind of operation can perform on a smemcg:
>> >
>> > 1) allocate/charge memory. The charge will add on the per smemcg charg=
e
>> > counter, check against the per smemcg limit. ENOMEM if it is over the =
limit.
>> >
>> > 2) free/uncharge memory. Similar to above just subtract the counter.
>> >
>> > 3) share/mmap already charged memory. This will not change the smemcg =
charge
>> > count, it will add to a per <smemcg, memcg> borrow counter. It is poss=
ible to
>> > put a limit on that counter as well, even though I haven't given too m=
uch thought
>> > of how useful it is. That will limit how much memory can mapped from t=
he smemcg.
>>=20
>> I would like to see the idea of a borrow counter fleshed out some more
>> but this sounds like it could work for the pinning scenario.
>>=20
>> Pinning could be charged to the per <smemcg, memcg> borrow counter and
>> the pin limit would be enforced against that plus the anonymous pins.
>>=20
>> Implementation wise we'd need a way to lookup both the smemcg of the
>> struct page and the memcg that the pinning task belongs to.
>
> The page->memcg_data points to the pin smemcg. I am hoping pinning API or
> the current memcg can get to the pinning memcg.

So the memcg to charge would come from the process doing the
pin_user_pages() rather than say page->memcg_data? Seems reasonable.

>> > 4) unshare/unmmap already charged memory. That will reduce the per <sm=
emcg, memcg>
>> > borrow counter.
>>=20
>> Actually this is where things might get a bit tricky for pinning. We'd
>> have to reduce the pin charge when a driver calls put_page(). But that
>> implies looking up the borrow counter / <smemcg, memcg> pair a driver
>> charged the page to.
>
> Does the pin page share between different memcg or just one memcg?

In general it can share between different memcg. Consider a shared
mapping shared with processes in two different cgroups (A and B). There
is nothing stopping each process opening a file-descriptor and calling
an ioctl() to pin the shared page.

Each should be punished for pinning the page in the sense that the pin
count for their respective cgroups must go up.

Drivers pinning shared pages is I think relatively rare, but it's
theorectically possible and if we're going down the path of adding
limits for pinning to memcg it's something we need to deal with to make
sandboxing effective.

> If it is shared, can the put_page() API indicate it is performing in beha=
lf
> of which memcg?

I think so - although it varies by driver.

Drivers have to store the array of pages pinned so should be able to
track the memcg with that as well. My series added a struct vm_account
which would be the obvious place to keep that reference. Each set of pin
operations on a FD would need a new memcg reference though so it would
add overhead for drivers that only pin a small number of pages at a
time.

Non-driver users such as the mlock() syscall don't keep a pinned pages
array around but they should be able to use the current memcg during
munlock().

>> I will have to give this idea some more tought though. Most drivers
>> don't store anything other than the struct page pointers, but my series
>> added an accounting struct which I think could reference the borrow
>> counter.
>
> Ack.
>
>>=20
>> > Will that work for your pin memory usage?
>>=20
>> I think it could help. I will give it some thought.
>
> Ack.
>>=20
>> >>=20
>> >> > Shared Memory Cgroup Controllers
>> >> >
>> >> > =3D Introduction
>> >> >
>> >> > The current memory cgroup controller does not support shared memory
>> >> > objects. For the memory that is shared between different processes,=
 it
>> >> > is not obvious which process should get charged. Google has some
>> >> > internal tmpfs =E2=80=9Cmemcg=3D=E2=80=9D mount option to charge tm=
pfs data to a
>> >> > specific memcg that=E2=80=99s often different from where charging p=
rocesses
>> >> > run. However it faces some difficulties when the charged memcg exit=
s
>> >> > and the charged memcg becomes a zombie memcg.
>> >> > Other approaches include =E2=80=9Cre-parenting=E2=80=9D the memcg c=
harge to the parent
>> >> > memcg. Which has its own problem. If the charge is huge, iteration =
of
>> >> > the reparenting can be costly.
>> >> >
>> >> > =3D Proposed Solution
>> >> >
>> >> > The proposed solution is to add a new type of memory controller for
>> >> > shared memory usage. E.g. tmpfs, hugetlb, file system mmap and
>> >> > dma_buf. This shared memory cgroup controller object will have the
>> >> > same life cycle of the underlying shared memory.
>> >> >
>> >> > Processes can not be added to the shared memory cgroup. Instead the
>> >> > shared memory cgroup can be added to the memcg using a =E2=80=9Csme=
mcg=E2=80=9D API
>> >> > file, similar to adding a process into the =E2=80=9Ctasks=E2=80=9D =
API file.
>> >> > When a smemcg is added to the memcg, the amount of memory that has
>> >> > been shared in the memcg process will be accounted for as the part =
of
>> >> > the memcg =E2=80=9Cmemory.current=E2=80=9D.The memory.current of th=
e memcg is make up
>> >> > of two parts, 1) the processes anonymous memory and 2) the memory
>> >> > shared from smemcg.
>> >> >
>> >> > When the memcg =E2=80=9Cmemory.current=E2=80=9D is raised to the li=
mit. The kernel
>> >> > will active try to reclaim for the memcg to make =E2=80=9Csmemcg me=
mory +
>> >> > process anonymous memory=E2=80=9D within the limit.
>> >>=20
>> >> That means a process in one cgroup could force reclaim of smemcg memo=
ry
>> >> in use by a process in another cgroup right? I guess that's no differ=
ent
>> >> to the current situation though.
>> >>=20
>> >> > Further memory allocation
>> >> > within those memcg processes will fail if the limit can not be
>> >> > followed. If many reclaim attempts fail to bring the memcg
>> >> > =E2=80=9Cmemory.current=E2=80=9D within the limit, the process in t=
his memcg will get
>> >> > OOM killed.
>> >>=20
>> >> How would this work if say a charge for cgroup A to a smemcg in both
>> >> cgroup A and B would cause cgroup B to go over its memory limit and n=
ot
>> >> enough memory could be reclaimed from cgroup B? OOM killing a process=
 in
>> >> cgroup B due to a charge from cgroup A doesn't sound like a good idea=
.
>> >
>> > If we separate out the charge counter with the borrow counter, that pr=
oblem
>> > will be solved. When smemcg is add to memcg A, we can have a policy sp=
ecific
>> > that adding the <smemcg, memcg A> borrow counter into memcg A's "memor=
y.current".
>> >
>> > If B did not map that page, that page will not be part of <smemcg, mem=
cg B>
>> > borrow count. B will not be punished.
>> >
>> > However if B did map that page, The <smemcg, memcg B> need to increase=
 as well.
>> > B will be punished for it.
>> >
>> > Will that work for your example situation?
>>=20
>> I think so, although I have been looking at this more from the point of
>> view of pinning. It sounds like we could treat pinning in much the same
>> way as mapping though.
>
> Ack.
>>=20
>> >> > =3D Benefits
>> >> >
>> >> > The benefits of this solution include:
>> >> > * No zombie memcg. The life cycle of the smemcg match the share mem=
ory file system or dma_buf.
>> >>=20
>> >> If we added pinning it could get a bit messier, as it would have to h=
ang
>> >> around until the driver unpinned the pages. But I don't think that's =
a
>> >> problem.
>> >
>> >
>> > That is exactly the reason pin memory can belong to a pin smemcg. You =
just need
>> > to model the driver holding the pin ref count as one of the share/mmap=
 operation.
>> >
>> > Then the pin smemcg will not go away if there is a pending pin ref cou=
nt on it.
>> >
>> > We have have different policy option on smemcg.
>> > For the simple usage don't care the per memcg borrow counter, it can a=
dd the
>> > smemcg's charge count to "memory.current".
>> >
>> > Only the user who cares about per memcg usage of a smemcg will need to=
 maintain
>> > per <smemcg, memcg> borrow counter, at additional cost.
>>=20
>> Right, I think pinning drivers will always have to care about the borrow
>> counter so will have to track that.
>
> Ack.
>
> Chris

