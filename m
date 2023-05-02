From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Tue, 2 May 2023 13:02:56 -0700
Message-ID: <CAJD7tkbT+J_LZUUtq2JxQ5LEO4iigL0zoGf-KBQc6Wj3hffmFw@mail.gmail.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <CAJD7tkZw9uVPe5KH2xrihsv5nDmExJmkmsUPYP6Npvv6Q0NcVw@mail.gmail.com>
 <CAJD7tkb56gR0X5v3VHfmk3az3bOz=wF2jhEi+7Eek0J8XXBeWQ@mail.gmail.com> <ZE/q+ZFWLEa6C6rq@P9FQF9L96D>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683057813; x=1685649813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCmu6qJCqnK26c1deDSnWNiRLvDncJpAwXbw3DsD1H0=;
        b=pqf6ltCtonpo0hWTk+tyOCHgD+RYIJ12oHdI6QmZrUfT7NPEmyLill6sm5+6dPj+Tz
         pqZDLLbb3Hq2kaw+lNE0EODy7A/PhqcNFg5TRSGVsIQKpOHuvDLL9zlCAniV5QQrfG+H
         ijq43v/41RQjWHS1B8oNjicdUFX7hVq66Tu/gG5S4u70V+whOoZ+ai5i2neqELYsirkl
         3t6puujOyclixrlAFHpG7c4/GkOeYvE75+Ks/UDL+AeXmLmNNH0EyKfCe90bsVo6U7vH
         HEYUPzSchNLylhLhBbd14E0uFWwAcTEUSdZpI6w4W9qDzWucrjNMYlt2+xDRbjibRIa9
         JYJQ==
In-Reply-To: <ZE/q+ZFWLEa6C6rq@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, May 1, 2023 at 9:38=E2=80=AFAM Roman Gushchin <roman.gushchin@linux=
.dev> wrote:
>
> On Tue, Apr 25, 2023 at 04:36:53AM -0700, Yosry Ahmed wrote:
> >  +David Rientjes +Greg Thelen +Matthew Wilcox
>
> Hi Yosry!
>
> Sorry for being late to the party, I was offline for a week.
>
> >
> > On Tue, Apr 11, 2023 at 4:48=E2=80=AFPM Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > >
> > > On Tue, Apr 11, 2023 at 4:36=E2=80=AFPM T.J. Mercier <tjmercier@googl=
e.com> wrote:
> > > >
> > > > When a memcg is removed by userspace it gets offlined by the kernel=
.
> > > > Offline memcgs are hidden from user space, but they still live in t=
he
> > > > kernel until their reference count drops to 0. New allocations cann=
ot
> > > > be charged to offline memcgs, but existing allocations charged to
> > > > offline memcgs remain charged, and hold a reference to the memcg.
> > > >
> > > > As such, an offline memcg can remain in the kernel indefinitely,
> > > > becoming a zombie memcg. The accumulation of a large number of zomb=
ie
> > > > memcgs lead to increased system overhead (mainly percpu data in str=
uct
> > > > mem_cgroup). It also causes some kernel operations that scale with =
the
> > > > number of memcgs to become less efficient (e.g. reclaim).
>
> The problem is even more fundamental:
> 1) offline memcgs are (almost) fully functional memcgs from the kernel's =
point
>    of view,
> 2) if memcg A allocates some memory, goes offline and now memcg B is usin=
g this
>    memory, the memory is effectively shared between memcgs A and B,
> 3) sharing memory was never really supported by memcgs.
>
> If memory is shared between memcgs, most memcg functionality is broken as=
ide
> from a case when memcgs are working in a very predictable and coordinated=
 way.
> But generally all counters and stats become racy (whoever allocated it fi=
rst,
> pays the full price, other get it for free), and memory limits and protec=
tions
> are based on the same counters.
>
> Depending on % memory shared, the rate at which memcg are created and des=
troyed,
> memory pressure and other workload-depending factors the problem can be
> significant or not.
>
> One way to tackle this problem is to stop using memcgs as wrappers for
> individual processes or workloads and use them more as performance classe=
s.
> This means more statically and with less memory sharing.
> However I admit it's the opposite direction to where all went for the
> last decade or so.
>
> > > >
> > > > There are currently out-of-tree solutions which attempt to
> > > > periodically clean up zombie memcgs by reclaiming from them. Howeve=
r
> > > > that is not effective for non-reclaimable memory, which it would be
> > > > better to reparent or recharge to an online cgroup. There are also
> > > > proposed changes that would benefit from recharging for shared
> > > > resources like pinned pages, or DMA buffer pages.
> > >
> > > I am very interested in attending this discussion, it's something tha=
t
> > > I have been actively looking into -- specifically recharging pages of
> > > offlined memcgs.
> > >
> > > >
> > > > Suggested attendees:
> > > > Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> > > > Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > > Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> > > > Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > I was hoping I would bring a more complete idea to this thread, but
> > here is what I have so far.
> >
> > The idea is to recharge the memory charged to memcgs when they are
> > offlined. I like to think of the options we have to deal with memory
> > charged to offline memcgs as a toolkit. This toolkit includes:
> >
> > (a) Evict memory.
> >
> > This is the simplest option, just evict the memory.
> >
> > For file-backed pages, this writes them back to their backing files,
> > uncharging and freeing the page. The next access will read the page
> > again and the faulting process=E2=80=99s memcg will be charged.
> >
> > For swap-backed pages (anon/shmem), this swaps them out. Swapping out
> > a page charged to an offline memcg uncharges the page and charges the
> > swap to its parent. The next access will swap in the page and the
> > parent will be charged. This is effectively deferred recharging to the
> > parent.
> >
> > Pros:
> > - Simple.
> >
> > Cons:
> > - Behavior is different for file-backed vs. swap-backed pages, for
> > swap-backed pages, the memory is recharged to the parent (aka
> > reparented), not charged to the "rightful" user.
> > - Next access will incur higher latency, especially if the pages are ac=
tive.
>
> Generally I think it's a good solution iff there is not much of memory sh=
aring
> with other memcgs. But in practice there is a high chance that some very =
hot
> pages (e.g. shlib pages shared by pretty much everyone) will get evicted.

One other thing that I recently noticed. If a memcg has some pages
swapped out, or if userspace deliberately tries to free memory from a
memcg before removing it, then the memcg is offlined, then the swapped
pages will hold the memcg hostage until the next fault recharges or
reparents them.

If the pages are truly cold, this can take a while (or never happen).

Separate from recharging, one thing we can do is have a kthread loop
over swap_cgroup and reparent swap entries charged to offline memcgs
to unpin them. Ideally, we will mark those entries such that they get
recharged upon the next fault instead of just keeping them at the
parent.

Just thinking out loud here.

>
> >
> > (b) Direct recharge to the parent
> >
> > This can be done for any page and should be simple as the pages are
> > already hierarchically charged to the parent.
> >
> > Pros:
> > - Simple.
> >
> > Cons:
> > - If a different memcg is using the memory, it will keep taxing the
> > parent indefinitely. Same not the "rightful" user argument.
>
> It worked for slabs and other kmem objects to reduce the severity of the =
memcg
> zombie clogging. Muchun posted patches for lru pages. I believe it's a de=
cent
> way to solve the zombie problem, but it doesn't solve any issues with the=
 memory
> sharing.
>
> >
> > (c) Direct recharge to the mapper
> >
> > This can be done for any mapped page by walking the rmap and
> > identifying the memcg of the process(es) mapping the page.
> >
> > Pros:
> > - Memory is recharged to the =E2=80=9Crightful=E2=80=9D user.
> >
> > Cons:
> > - More complicated, the =E2=80=9Crightful=E2=80=9D user=E2=80=99s memcg=
 might run into an OOM
> > situation =E2=80=93 which in this case will be unpredictable and hard t=
o
> > correlate with an allocation.
> >
> > (d) Deferred recharging
> >
> > This is a mixture of (b) & (c) above. It is a two-step process. We
> > first recharge the memory to the parent, which should be simple and
> > reliable. Then, we mark the pages so that the next time they are
> > accessed or mapped we recharge them to the "rightful" user.
> >
> > For mapped pages, we can use the numa balancing approach of protecting
> > the mapping (while the vma is still accessible), and then in the fault
> > path recharge the page. This is better than eviction because the fault
> > on the next access is minor, and better than direct recharging to the
> > mapping in the sense that the charge is correlated with an
> > allocation/mapping. Of course, it is more complicated, we have to
> > handle different protection interactions (e.g. what if the page is
> > already protected?). Another disadvantage is that the recharging
> > happens in the context of a page fault, rather than asynchronously in
> > the case of directly recharging to the mapper. Page faults are more
> > latency sensitive, although this shouldn't be a common path.
> >
> > For unmapped pages, I am struggling to find a way that is simple
> > enough to recharge the memory on the next access. My first intuition
> > was to add a hook to folio_mark_accessed(), but I was quickly told
> > that this is not invoked in all access paths to unmapped pages (e.g.
> > writes through fds). We can also add a hook to folio_mark_dirty() to
> > add more coverage, but it seems like this path is fragile, and it
> > would be ideal if there is a shared well-defined common path (or
> > paths) for all accesses to unmapped pages. I would imagine if such a
> > path exists or can be forged it would probably be in the page cache
> > code somewhere.
>
> The problem is that we'd need to add hooks and checks into many hot paths=
,
> so the performance penalty will be likely severe.
> But of course hard to tell without actual patches.
> >
> > For both cases, if a new mapping is created, we can do recharging there=
.
> >
> > Pros:
> > - Memory is recharged to the =E2=80=9Crightful=E2=80=9D user, eventuall=
y.
> > - The charge is predictable and correlates to a user's access.
> > - Less overhead on next access than eviction.
> >
> > Cons:
> > - The memory will remain charged to the parent until the next access
> > happens, if it ever happens.
> > - Worse overhead on next access than directly recharging to the mapper.
> >
> > With this (incompletely defined) toolkit, a recharging algorithm can
> > look like this (as a rough example):
> >
> > - If the page is file-backed:
> >   - Unmapped? evict (a).
> >   - Mapped? recharge to the mapper -- direct (c) or deferred (d).
> > - If the page is swap-backed:
> >   - Unmapped? deferred recharge to the next accessor (d).
> >   - Mapped? recharge to the mapper -- direct (c) or deferred (d).
> >
> > There are, of course, open questions:
> > 1) How do we do deferred recharging for unmapped pages? Is deferred
> > recharging even a reliable option to begin with? What if the pages are
> > never accessed again?
>
> I believe the real question is how to handle memory shared between memcgs=
.
> Dealing with offline memcgs is just a specific case of this problem.
> >
> > Again, I was hoping to come up with a more concrete proposal, but as
> > LSF/MM/BPF is approaching, I wanted to share my thoughts on the
> > mailing list looking for any feedback.
>
> Thank you for bringing it in!
