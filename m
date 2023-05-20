From: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Sat, 20 May 2023 08:31:01 -0700
Message-ID: <ZGjntWoAfgyT0doo@google.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com>
 <874josz4rd.fsf@nvidia.com>
 <ZFPP71czDDxMPLQK@google.com>
 <877ctm518f.fsf@nvidia.com>
 <ZFbZZPkSpsKMe8iR@google.com>
 <87ttwnkzap.fsf@nvidia.com>
 <ZFuvhP5qGPivokc0@google.com>
 <87jzxe9baj.fsf@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684596663;
        bh=SDFdEY5M6VQT8dUJDl+Tz+UxRV57s2ymsjeugVSGjzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CskNJM+Mp9beAWrZGNmoVuyZI/NNFo3PmdQP9IXQ200giKuot+qWiDARNiNNBzW6G
         HoiOSMAfqL9mq4/2R/TQz/ygN6wzfubbLbOne5tTRBeDMfq+kkRz7lmu9NWPn2DqyM
         Ny5rm8YZJn1nJgqkWrE4RVefgv55psyoVi/TFg52rk6D1bnWET2ZYzCLhNP9FhT3Sv
         d2Mf95eq4H/W9o433BhreRLlfdr9FZb8tmGlOws53QLb+Qj2gYyB2QHW42gZ27ARPX
         ArNnRG/9RgV9/yW9pqHi6WL6q1axi17RB/Ob8cYH7owu/bUSo1qsiDNdez+0VwxpnE
         bz/FQN9ZuEhbQ==
Content-Disposition: inline
In-Reply-To: <87jzxe9baj.fsf-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Alistair,

Sorry for the late reply. Super busy after return from LSF/MM.
Catching up my emails.

On Fri, May 12, 2023 at 06:45:13PM +1000, Alistair Popple wrote:
> > Yes, I talked to Jason Gunthorpe and asked him about the usage workflow
> > of the pin memory controller. He tell me that his original intend is
> > just to have something like RLIMIT but without the quirky limitation
> > of the RLIMIT. It has nothing to do with sharing memory.
> > Share memories are only brought up during the online discussion. =A0I g=
uess
> > the share memory has similar reference count and facing similar challen=
ges
> > on double counting.
>=20
> Ok, good. Now I realise perhaps we delved into this discussion without
> covering the background.
>=20
> My original patch series implemented what Jason suggested. That was a
> standalone pinscg controller (which perhaps should be implemented as a
> misc controller) that behaves the same as RLIMIT does, just charged to a
> pinscg rather than a process or user.
>=20
> However review comments suggested it needed to be added as part of
> memcg. As soon as we do that we have to address how we deal with shared
> memory. If we stick with the original RLIMIT proposal this discussion
> goes away, but based on feedback I think I need to at least investigate
> integrating it into memcg to get anything merged.
Ack.

>=20
> [...]
>=20
> >> However for shared mappings it isn't - processes in different cgroups
> >> could be mapping the same page but the accounting should happen to the
> >> cgroup the process is in, not the cgroup that happens to "own" the pag=
e.
> >
> > Ack. That is actually the root of the share memory problem. The model
> > of charging to the first process does not work well for share usage.
>=20
> Right. The RLIMIT approach avoids the shared memory problem by charging
> every process in a pincg for every pin (see below). But I don't disagree
> there is appeal to having pinning work in the same way as memcg hence
> this discussion.

Ack.

>=20
> >> It is also possible that the page might not be mapped at all. For
> >> example a driver may be pinning a page with pin_user_pages(), but the
> >> userspace process may have munmap()ped it.
> >
> > Ack.
> > In that case the driver will need to hold a reference count for it, rig=
ht?
>=20
> Correct. Drivers would normally drop that reference when the FD is
> closed but there's nothing that says they have to.

Ack.

>=20
> [...]
>=20
> > OK. This is the critical usage information that I want to know. Thanks =
for
> > the explaination.
> >
> > So there are two different definition of the pin page count:
> > 1) sum(total set of pages that this memcg process issue pin ioctl on)
> > 2) sum(total set of pined page this memcg process own a reference count=
 on)
> >
> > It seems you want 2).
> >
> > If a page has three reference counts inside one memcg, e.g. map three t=
imes.=20
> > Does the pin count three times or only once?
>=20
> I'm going to be pedantic here because it's important - by "map three
> times" I assume you mean "pin three times with an ioctl". For pinning it
> doesn't matter if the page is actually mapped or not.

Pedantic is good.
I actually thinking about the other way around: pin the page with
ioctl once, then that page is map to other process three times with
three virtual addresses.

My guess from your reply is that it counts as one pin only.

>=20
> This is basically where we need to get everyone aligned. The RLIMIT
> approach currently implemented by my patch series does (2). For example:
>=20
> 1. If a process in a pincg requests (eg. via driver ioctl) to pin a page
>    it is charged against the pincg limit and will fail if going over
>    limit.
>=20
> 2. If the same process requests another pin (doesn't matter if it's the
>    same page or not) it will be charged again and can't go over limit.
>=20
> 3. If another process in the same pincg requests a page (again, doesn't
>    matter if it's the same page or not) be pinned it will be charged
>    against the limit.

I see. You want to track and punish the number of time process
issue pin ioctl on the page.

>=20
> 4. If a process not in the pincg pins the same page it will not be
>    charged against the pincg limit.

Ack, because it is not in the pincg.

>=20
> From my perspective I think (1) would be fine (or even preferable) if
> and only if the sharing issues can be resolved. In that case it becomes
> much easier to explain how to set the limit.

Ack.

> For example it could be set as a percentage of total memory allocated to
> the memcg, because all that really matters is the first pin within a
> given memcg.
>=20
> Subsequent pins won't impact system performance or stability because
> once the page is pinned once it may as well be pinned a hundred
> times. The only reason I didn't take this approach in my series is that
> it's currently impossible to figure out what to do in the shared case
> because we have no way of mapping pages back to multiple memcgs to see
> if they've already been charged to that memcg, so they would have to be
> charged to a single memcg which isn't useful.
>=20

Ack.

> >> Hence the interest in the total <smemcg, memcg>  limit.
> >>=20
> >> Pinned memory may also outlive the process that created it - drivers
> >> associate it via a file-descriptor not a process and even if the FD is
> >> closed there's nothing say a driver has to unpin the memory then
> >> (although most do).
> >
> > Ack.
> >
> >>=20
> >> > We can set up some meetings to discuss it as well.
> >> >
> >> >> So for pinning at least I don't see a per smemcg limit being useful.
> >> >
> >> > That is fine.  I see you are interested in the <smemcg, memcg> limit.
> >>=20
> >> Right, because it sounds like it will allow pinning the same struct pa=
ge
> >> multiple times to result in multiple charges. With the current memcg
> >
> > Multiple times to different memcgs I assume, please see the above quest=
ion
> > regard multiple times to the same memcg.
>=20
> Right. If we have a page that is pinned by two processes in different
> cgroups each cgroup should be charged once (and IMHO only once) for it.
>=20
Ack.

> In other words if two processes in the same memcg pin the same page that
> should only count as a single pin towards that memcg's pin limit, and
> the pin would be uncharged when the final pinner unpins the page.

Ack. You need to track the set of page you already pin on.=20

> Note this is not what is implemented by the RLIMIT approach hence why it
> conflicts with my answer to the above question which describes that
> approach.

Ack.

>=20
> [...]
>=20
> >> >> Implementation wise we'd need a way to lookup both the smemcg of the
> >> >> struct page and the memcg that the pinning task belongs to.
> >> >
> >> > The page->memcg_data points to the pin smemcg. I am hoping pinning A=
PI or
> >> > the current memcg can get to the pinning memcg.
> >>=20
> >> So the memcg to charge would come from the process doing the
> >> pin_user_pages() rather than say page->memcg_data? Seems reasonable.
> >
> > That is more of a question for you. What is the desired behavior.
> > If charge the current process that perform the pin_user_pages()
> > works for you. Great.
>=20
> Argh, if only I had the powers and the desire to commit what worked
> solely for me :-)

I want to learn about your usage case first. Of course others might have
different usage cases in mind. Let's start with yours.

> My current RLIMIT implementation works, but is it's own seperate thing
> and there was a strong and reasonable preference from maintainers to
> have this integrated with memcg.
>=20
> But that opens up this whole set of problems around sharing, etc. which
> we need to solve. We didn't want to invent our own set of rules for
> sharing, etc. and changing memcg to support sharing in the way that was
> needed seemed like a massive project.
>=20
> However if we tackle that project and resolve the sharing issues for
> memcg then I think adding a pin limit per-memcg shouldn't be so hard.

Ack.

I am consider the first step for smemcg should only include the simple
binary membership relationship. That will simplify things a lot, don't
need to track the per page shared usage count.

However it does not address your requirement of tracking each page
the share usage set. That I haven't figure out a good effective way to
do it. If any one knows, I am curious to know.


> >> >> > 4) unshare/unmmap already charged memory. That will reduce the pe=
r <smemcg, memcg>
> >> >> > borrow counter.
> >> >>=20
> >> >> Actually this is where things might get a bit tricky for pinning. W=
e'd
> >> >> have to reduce the pin charge when a driver calls put_page(). But t=
hat
> >> >> implies looking up the borrow counter / <smemcg, memcg> pair a driv=
er
> >> >> charged the page to.
> >> >
> >> > Does the pin page share between different memcg or just one memcg?
> >>=20
> >> In general it can share between different memcg. Consider a shared
> >> mapping shared with processes in two different cgroups (A and B). There
> >> is nothing stopping each process opening a file-descriptor and calling
> >> an ioctl() to pin the shared page.
> >
> > Ack.
> >
> >> Each should be punished for pinning the page in the sense that the pin
> >> count for their respective cgroups must go up.
> >
> > Ack. That clarfy my previous question. You want definition 2)
>=20
> I wouldn't say "want" so much as that seemed the quickest/easiest path
> forward without having to fix the problems with support for shared pages
> in memcg.

Ack.

>=20
> >> Drivers pinning shared pages is I think relatively rare, but it's
> >> theorectically possible and if we're going down the path of adding
> >> limits for pinning to memcg it's something we need to deal with to make
> >> sandboxing effective.
> >
> > The driver will still have a current processor. Do you mean in this cas=
e,
> > the current processor is not the right one to charge?
> > Another option can be charge to a default system/kernel smemcg or a dri=
ver
> > smemcg as well.
>=20
> It's up to the driver to inform us which process should be
> charged. Potentially it's not current. But my point here was drivers are
> pretty much always pinning pages in private mappings. Hence why we
> thought the trade-off taking a pincg RLIMIT style approach that
> occasionally double charges pages would be fine because dealing with
> pinning a page in a shared mapping was both hard and rare.
>=20
> But if we're solving the shared memcg problem that might at least change
> the "hard" bit of that equation.

Ack. The smemcg can start with simple binary membership relationship.
That does not help your pin controller much though.

> >> > If it is shared, can the put_page() API indicate it is performing in=
 behalf
> >> > of which memcg?
> >>=20
> >> I think so - although it varies by driver.
> >>=20
> >> Drivers have to store the array of pages pinned so should be able to
> >> track the memcg with that as well. My series added a struct vm_account
> >> which would be the obvious place to keep that reference.
> >
> > Where does the struct vm_account lives?
>=20
> I am about to send a rebased version of my series, but typically drivers
> keep some kind of per-FD context structure and we keep the vm_account
> there.
>=20
> The vm_account holds references to the task_struct/mm_struct/pinscg as
> required.

I will keep an eye out for your patches.

>=20
> >> Each set of pin=20
> >> operations on a FD would need a new memcg reference though so it would
> >> add overhead for drivers that only pin a small number of pages at a
> >> time.
> >
> > Set is more complicate then allow double counting the same page in the
> > same smemcg. Again mostly just collecting requirement from you.
>=20
> Right. Hence why we just went with double counting. I think it would be
> hard to figure out if a particular page is already pinned by a
> particular <memcg, smemcg> or not.

Agree. We can track it, the question is how to do it in a scalable way.
That I don't have a solution I am happy with yet.

Chris

