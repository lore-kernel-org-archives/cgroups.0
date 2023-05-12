From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Fri, 12 May 2023 18:45:13 +1000
Message-ID: <87jzxe9baj.fsf@nvidia.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com> <874josz4rd.fsf@nvidia.com>
 <ZFPP71czDDxMPLQK@google.com> <877ctm518f.fsf@nvidia.com>
 <ZFbZZPkSpsKMe8iR@google.com> <87ttwnkzap.fsf@nvidia.com>
 <ZFuvhP5qGPivokc0@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fYnRjqsW/8HhzpKdzqtHgv0r/PK1OKsJSY2XrEGlv4=;
 b=CCTSQryFKPdv7bfM4AZIGttB/WNMGFYyldckoRbxOiWxsnbvjJ6g7QlLhKNt/3ePit03VMrcg3Qn8kr/JeDNvX9gV2bBKUapW9PPQhvgwbv6wFudx1uTpI9ehpv831SkEEaCapwLHv7ohU2E7fBPPI9klUfUXyiR5POBS7i38vz+miqkVywDBMwNl+9zcjfdGWbeeEhNBXLrNAHunvi9ZggpPnrAxolfc5dsMpJ+hHNdfXj8DtHx2SG/Q4tMVTPmhrIfUy9YQAlpeNjKe5Lq7SGKGpNDa3cjNrJAsTkWvmid89Pu3notY6utECLIEEhpjeCc07FzvqQ1za3Ay/lv7A==
In-reply-to: <ZFuvhP5qGPivokc0-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Hi Alistair,
>
> On Mon, May 08, 2023 at 06:17:04PM +1000, Alistair Popple wrote:
>> Actually I don't have an invite so might not make it. However I believe
>> Jason Gunthorpe is there and he has been helping with this as well so he
>> might be able to attend the session. Or we could discuss it in one of
>
> Yes, I talked to Jason Gunthorpe and asked him about the usage workflow
> of the pin memory controller. He tell me that his original intend is
> just to have something like RLIMIT but without the quirky limitation
> of the RLIMIT. It has nothing to do with sharing memory.
> Share memories are only brought up during the online discussion. =C2=A0I =
guess
> the share memory has similar reference count and facing similar challenge=
s
> on double counting.

Ok, good. Now I realise perhaps we delved into this discussion without
covering the background.

My original patch series implemented what Jason suggested. That was a
standalone pinscg controller (which perhaps should be implemented as a
misc controller) that behaves the same as RLIMIT does, just charged to a
pinscg rather than a process or user.

However review comments suggested it needed to be added as part of
memcg. As soon as we do that we have to address how we deal with shared
memory. If we stick with the original RLIMIT proposal this discussion
goes away, but based on feedback I think I need to at least investigate
integrating it into memcg to get anything merged.

[...]

>> However for shared mappings it isn't - processes in different cgroups
>> could be mapping the same page but the accounting should happen to the
>> cgroup the process is in, not the cgroup that happens to "own" the page.
>
> Ack. That is actually the root of the share memory problem. The model
> of charging to the first process does not work well for share usage.

Right. The RLIMIT approach avoids the shared memory problem by charging
every process in a pincg for every pin (see below). But I don't disagree
there is appeal to having pinning work in the same way as memcg hence
this discussion.

>> It is also possible that the page might not be mapped at all. For
>> example a driver may be pinning a page with pin_user_pages(), but the
>> userspace process may have munmap()ped it.
>
> Ack.
> In that case the driver will need to hold a reference count for it, right=
?

Correct. Drivers would normally drop that reference when the FD is
closed but there's nothing that says they have to.

[...]

> OK. This is the critical usage information that I want to know. Thanks fo=
r
> the explaination.
>
> So there are two different definition of the pin page count:
> 1) sum(total set of pages that this memcg process issue pin ioctl on)
> 2) sum(total set of pined page this memcg process own a reference count o=
n)
>
> It seems you want 2).
>
> If a page has three reference counts inside one memcg, e.g. map three tim=
es.=20
> Does the pin count three times or only once?

I'm going to be pedantic here because it's important - by "map three
times" I assume you mean "pin three times with an ioctl". For pinning it
doesn't matter if the page is actually mapped or not.

This is basically where we need to get everyone aligned. The RLIMIT
approach currently implemented by my patch series does (2). For example:

1. If a process in a pincg requests (eg. via driver ioctl) to pin a page
   it is charged against the pincg limit and will fail if going over
   limit.

2. If the same process requests another pin (doesn't matter if it's the
   same page or not) it will be charged again and can't go over limit.

3. If another process in the same pincg requests a page (again, doesn't
   matter if it's the same page or not) be pinned it will be charged
   against the limit.

4. If a process not in the pincg pins the same page it will not be
   charged against the pincg limit.

From my perspective I think (1) would be fine (or even preferable) if
and only if the sharing issues can be resolved. In that case it becomes
much easier to explain how to set the limit.

For example it could be set as a percentage of total memory allocated to
the memcg, because all that really matters is the first pin within a
given memcg.

Subsequent pins won't impact system performance or stability because
once the page is pinned once it may as well be pinned a hundred
times. The only reason I didn't take this approach in my series is that
it's currently impossible to figure out what to do in the shared case
because we have no way of mapping pages back to multiple memcgs to see
if they've already been charged to that memcg, so they would have to be
charged to a single memcg which isn't useful.

>> Hence the interest in the total <smemcg, memcg>  limit.
>>=20
>> Pinned memory may also outlive the process that created it - drivers
>> associate it via a file-descriptor not a process and even if the FD is
>> closed there's nothing say a driver has to unpin the memory then
>> (although most do).
>
> Ack.
>
>>=20
>> > We can set up some meetings to discuss it as well.
>> >
>> >> So for pinning at least I don't see a per smemcg limit being useful.
>> >
>> > That is fine.  I see you are interested in the <smemcg, memcg> limit.
>>=20
>> Right, because it sounds like it will allow pinning the same struct page
>> multiple times to result in multiple charges. With the current memcg
>
> Multiple times to different memcgs I assume, please see the above questio=
n
> regard multiple times to the same memcg.

Right. If we have a page that is pinned by two processes in different
cgroups each cgroup should be charged once (and IMHO only once) for it.

In other words if two processes in the same memcg pin the same page that
should only count as a single pin towards that memcg's pin limit, and
the pin would be uncharged when the final pinner unpins the page.

Note this is not what is implemented by the RLIMIT approach hence why it
conflicts with my answer to the above question which describes that
approach.

[...]

>> >> Implementation wise we'd need a way to lookup both the smemcg of the
>> >> struct page and the memcg that the pinning task belongs to.
>> >
>> > The page->memcg_data points to the pin smemcg. I am hoping pinning API=
 or
>> > the current memcg can get to the pinning memcg.
>>=20
>> So the memcg to charge would come from the process doing the
>> pin_user_pages() rather than say page->memcg_data? Seems reasonable.
>
> That is more of a question for you. What is the desired behavior.
> If charge the current process that perform the pin_user_pages()
> works for you. Great.

Argh, if only I had the powers and the desire to commit what worked
solely for me :-)

My current RLIMIT implementation works, but is it's own seperate thing
and there was a strong and reasonable preference from maintainers to
have this integrated with memcg.

But that opens up this whole set of problems around sharing, etc. which
we need to solve. We didn't want to invent our own set of rules for
sharing, etc. and changing memcg to support sharing in the way that was
needed seemed like a massive project.

However if we tackle that project and resolve the sharing issues for
memcg then I think adding a pin limit per-memcg shouldn't be so hard.

>> >> > 4) unshare/unmmap already charged memory. That will reduce the per =
<smemcg, memcg>
>> >> > borrow counter.
>> >>=20
>> >> Actually this is where things might get a bit tricky for pinning. We'=
d
>> >> have to reduce the pin charge when a driver calls put_page(). But tha=
t
>> >> implies looking up the borrow counter / <smemcg, memcg> pair a driver
>> >> charged the page to.
>> >
>> > Does the pin page share between different memcg or just one memcg?
>>=20
>> In general it can share between different memcg. Consider a shared
>> mapping shared with processes in two different cgroups (A and B). There
>> is nothing stopping each process opening a file-descriptor and calling
>> an ioctl() to pin the shared page.
>
> Ack.
>
>> Each should be punished for pinning the page in the sense that the pin
>> count for their respective cgroups must go up.
>
> Ack. That clarfy my previous question. You want definition 2)

I wouldn't say "want" so much as that seemed the quickest/easiest path
forward without having to fix the problems with support for shared pages
in memcg.

>> Drivers pinning shared pages is I think relatively rare, but it's
>> theorectically possible and if we're going down the path of adding
>> limits for pinning to memcg it's something we need to deal with to make
>> sandboxing effective.
>
> The driver will still have a current processor. Do you mean in this case,
> the current processor is not the right one to charge?
> Another option can be charge to a default system/kernel smemcg or a drive=
r
> smemcg as well.

It's up to the driver to inform us which process should be
charged. Potentially it's not current. But my point here was drivers are
pretty much always pinning pages in private mappings. Hence why we
thought the trade-off taking a pincg RLIMIT style approach that
occasionally double charges pages would be fine because dealing with
pinning a page in a shared mapping was both hard and rare.

But if we're solving the shared memcg problem that might at least change
the "hard" bit of that equation.

>>=20
>> > If it is shared, can the put_page() API indicate it is performing in b=
ehalf
>> > of which memcg?
>>=20
>> I think so - although it varies by driver.
>>=20
>> Drivers have to store the array of pages pinned so should be able to
>> track the memcg with that as well. My series added a struct vm_account
>> which would be the obvious place to keep that reference.
>
> Where does the struct vm_account lives?

I am about to send a rebased version of my series, but typically drivers
keep some kind of per-FD context structure and we keep the vm_account
there.

The vm_account holds references to the task_struct/mm_struct/pinscg as
required.

>> Each set of pin=20
>> operations on a FD would need a new memcg reference though so it would
>> add overhead for drivers that only pin a small number of pages at a
>> time.
>
> Set is more complicate then allow double counting the same page in the
> same smemcg. Again mostly just collecting requirement from you.

Right. Hence why we just went with double counting. I think it would be
hard to figure out if a particular page is already pinned by a
particular <memcg, smemcg> or not.

Thanks.

 - Alistair

>>=20
>> Non-driver users such as the mlock() syscall don't keep a pinned pages
>> array around but they should be able to use the current memcg during
>> munlock().
>
> Ack.
>
> Chris
>
>>=20
>> >> I will have to give this idea some more tought though. Most drivers
>> >> don't store anything other than the struct page pointers, but my seri=
es
>> >> added an accounting struct which I think could reference the borrow
>> >> counter.
>> >
>> > Ack.
>> >
>> >>=20
>> >> > Will that work for your pin memory usage?
>> >>=20
>> >> I think it could help. I will give it some thought.
>> >
>> > Ack.
>> >>=20
>> >> >>=20
>> >> >> > Shared Memory Cgroup Controllers
>> >> >> >
>> >> >> > =3D Introduction
>> >> >> >
>> >> >> > The current memory cgroup controller does not support shared mem=
ory
>> >> >> > objects. For the memory that is shared between different process=
es, it
>> >> >> > is not obvious which process should get charged. Google has some
>> >> >> > internal tmpfs =E2=80=9Cmemcg=3D=E2=80=9D mount option to charge=
 tmpfs data to a
>> >> >> > specific memcg that=E2=80=99s often different from where chargin=
g processes
>> >> >> > run. However it faces some difficulties when the charged memcg e=
xits
>> >> >> > and the charged memcg becomes a zombie memcg.
>> >> >> > Other approaches include =E2=80=9Cre-parenting=E2=80=9D the memc=
g charge to the parent
>> >> >> > memcg. Which has its own problem. If the charge is huge, iterati=
on of
>> >> >> > the reparenting can be costly.
>> >> >> >
>> >> >> > =3D Proposed Solution
>> >> >> >
>> >> >> > The proposed solution is to add a new type of memory controller =
for
>> >> >> > shared memory usage. E.g. tmpfs, hugetlb, file system mmap and
>> >> >> > dma_buf. This shared memory cgroup controller object will have t=
he
>> >> >> > same life cycle of the underlying shared memory.
>> >> >> >
>> >> >> > Processes can not be added to the shared memory cgroup. Instead =
the
>> >> >> > shared memory cgroup can be added to the memcg using a =E2=80=9C=
smemcg=E2=80=9D API
>> >> >> > file, similar to adding a process into the =E2=80=9Ctasks=E2=80=
=9D API file.
>> >> >> > When a smemcg is added to the memcg, the amount of memory that h=
as
>> >> >> > been shared in the memcg process will be accounted for as the pa=
rt of
>> >> >> > the memcg =E2=80=9Cmemory.current=E2=80=9D.The memory.current of=
 the memcg is make up
>> >> >> > of two parts, 1) the processes anonymous memory and 2) the memor=
y
>> >> >> > shared from smemcg.
>> >> >> >
>> >> >> > When the memcg =E2=80=9Cmemory.current=E2=80=9D is raised to the=
 limit. The kernel
>> >> >> > will active try to reclaim for the memcg to make =E2=80=9Csmemcg=
 memory +
>> >> >> > process anonymous memory=E2=80=9D within the limit.
>> >> >>=20
>> >> >> That means a process in one cgroup could force reclaim of smemcg m=
emory
>> >> >> in use by a process in another cgroup right? I guess that's no dif=
ferent
>> >> >> to the current situation though.
>> >> >>=20
>> >> >> > Further memory allocation
>> >> >> > within those memcg processes will fail if the limit can not be
>> >> >> > followed. If many reclaim attempts fail to bring the memcg
>> >> >> > =E2=80=9Cmemory.current=E2=80=9D within the limit, the process i=
n this memcg will get
>> >> >> > OOM killed.
>> >> >>=20
>> >> >> How would this work if say a charge for cgroup A to a smemcg in bo=
th
>> >> >> cgroup A and B would cause cgroup B to go over its memory limit an=
d not
>> >> >> enough memory could be reclaimed from cgroup B? OOM killing a proc=
ess in
>> >> >> cgroup B due to a charge from cgroup A doesn't sound like a good i=
dea.
>> >> >
>> >> > If we separate out the charge counter with the borrow counter, that=
 problem
>> >> > will be solved. When smemcg is add to memcg A, we can have a policy=
 specific
>> >> > that adding the <smemcg, memcg A> borrow counter into memcg A's "me=
mory.current".
>> >> >
>> >> > If B did not map that page, that page will not be part of <smemcg, =
memcg B>
>> >> > borrow count. B will not be punished.
>> >> >
>> >> > However if B did map that page, The <smemcg, memcg B> need to incre=
ase as well.
>> >> > B will be punished for it.
>> >> >
>> >> > Will that work for your example situation?
>> >>=20
>> >> I think so, although I have been looking at this more from the point =
of
>> >> view of pinning. It sounds like we could treat pinning in much the sa=
me
>> >> way as mapping though.
>> >
>> > Ack.
>> >>=20
>> >> >> > =3D Benefits
>> >> >> >
>> >> >> > The benefits of this solution include:
>> >> >> > * No zombie memcg. The life cycle of the smemcg match the share =
memory file system or dma_buf.
>> >> >>=20
>> >> >> If we added pinning it could get a bit messier, as it would have t=
o hang
>> >> >> around until the driver unpinned the pages. But I don't think that=
's a
>> >> >> problem.
>> >> >
>> >> >
>> >> > That is exactly the reason pin memory can belong to a pin smemcg. Y=
ou just need
>> >> > to model the driver holding the pin ref count as one of the share/m=
map operation.
>> >> >
>> >> > Then the pin smemcg will not go away if there is a pending pin ref =
count on it.
>> >> >
>> >> > We have have different policy option on smemcg.
>> >> > For the simple usage don't care the per memcg borrow counter, it ca=
n add the
>> >> > smemcg's charge count to "memory.current".
>> >> >
>> >> > Only the user who cares about per memcg usage of a smemcg will need=
 to maintain
>> >> > per <smemcg, memcg> borrow counter, at additional cost.
>> >>=20
>> >> Right, I think pinning drivers will always have to care about the bor=
row
>> >> counter so will have to track that.
>> >
>> > Ack.
>> >
>> > Chris
>>=20
>>=20

