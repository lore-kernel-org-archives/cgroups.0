From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Tue, 25 Apr 2023 04:36:53 -0700
Message-ID: <CAJD7tkb56gR0X5v3VHfmk3az3bOz=wF2jhEi+7Eek0J8XXBeWQ@mail.gmail.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <CAJD7tkZw9uVPe5KH2xrihsv5nDmExJmkmsUPYP6Npvv6Q0NcVw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682422651; x=1685014651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsngWKOv6aKbFUh03eXnVj16rHV0v3GvuIuES1vw7XQ=;
        b=sW7PePOlREhSSKOqwGhCAUa77Mfx2c0oO5NMs11uS6k4rpmQJiEZ+KnZAm+9x5JaWZ
         1pSVRErSatbvbV/KIHwODNwd4hoXQYP5XagVp9VVMamtMHynOgzq7Emtzvq5Ihq7l+cl
         2PYeEe9XuELLvkdd6eOYPwDg+Vq87Kno3Yq/heJacEBz3XMX1izHs47JdCGizKtfY7Fb
         tDfzeahJeIXAXFVGyNWmUL1vyTDbbG3iXv+iUSxi6aEdzikXWbDoM1VgQ2qPIC2QYGLD
         MLhv3M/4d707lxq4XD4KeTvYo/ZeOLhvJLLLMz77q8BWWOfaIeLGlQp6PT63pRu4n8Se
         8guA==
In-Reply-To: <CAJD7tkZw9uVPe5KH2xrihsv5nDmExJmkmsUPYP6Npvv6Q0NcVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

 +David Rientjes +Greg Thelen +Matthew Wilcox

On Tue, Apr 11, 2023 at 4:48=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> On Tue, Apr 11, 2023 at 4:36=E2=80=AFPM T.J. Mercier <tjmercier-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >
> > When a memcg is removed by userspace it gets offlined by the kernel.
> > Offline memcgs are hidden from user space, but they still live in the
> > kernel until their reference count drops to 0. New allocations cannot
> > be charged to offline memcgs, but existing allocations charged to
> > offline memcgs remain charged, and hold a reference to the memcg.
> >
> > As such, an offline memcg can remain in the kernel indefinitely,
> > becoming a zombie memcg. The accumulation of a large number of zombie
> > memcgs lead to increased system overhead (mainly percpu data in struct
> > mem_cgroup). It also causes some kernel operations that scale with the
> > number of memcgs to become less efficient (e.g. reclaim).
> >
> > There are currently out-of-tree solutions which attempt to
> > periodically clean up zombie memcgs by reclaiming from them. However
> > that is not effective for non-reclaimable memory, which it would be
> > better to reparent or recharge to an online cgroup. There are also
> > proposed changes that would benefit from recharging for shared
> > resources like pinned pages, or DMA buffer pages.
>
> I am very interested in attending this discussion, it's something that
> I have been actively looking into -- specifically recharging pages of
> offlined memcgs.
>
> >
> > Suggested attendees:
> > Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> > Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> > Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I was hoping I would bring a more complete idea to this thread, but
here is what I have so far.

The idea is to recharge the memory charged to memcgs when they are
offlined. I like to think of the options we have to deal with memory
charged to offline memcgs as a toolkit. This toolkit includes:

(a) Evict memory.

This is the simplest option, just evict the memory.

For file-backed pages, this writes them back to their backing files,
uncharging and freeing the page. The next access will read the page
again and the faulting process=E2=80=99s memcg will be charged.

For swap-backed pages (anon/shmem), this swaps them out. Swapping out
a page charged to an offline memcg uncharges the page and charges the
swap to its parent. The next access will swap in the page and the
parent will be charged. This is effectively deferred recharging to the
parent.

Pros:
- Simple.

Cons:
- Behavior is different for file-backed vs. swap-backed pages, for
swap-backed pages, the memory is recharged to the parent (aka
reparented), not charged to the "rightful" user.
- Next access will incur higher latency, especially if the pages are active=
.

(b) Direct recharge to the parent

This can be done for any page and should be simple as the pages are
already hierarchically charged to the parent.

Pros:
- Simple.

Cons:
- If a different memcg is using the memory, it will keep taxing the
parent indefinitely. Same not the "rightful" user argument.

(c) Direct recharge to the mapper

This can be done for any mapped page by walking the rmap and
identifying the memcg of the process(es) mapping the page.

Pros:
- Memory is recharged to the =E2=80=9Crightful=E2=80=9D user.

Cons:
- More complicated, the =E2=80=9Crightful=E2=80=9D user=E2=80=99s memcg mig=
ht run into an OOM
situation =E2=80=93 which in this case will be unpredictable and hard to
correlate with an allocation.

(d) Deferred recharging

This is a mixture of (b) & (c) above. It is a two-step process. We
first recharge the memory to the parent, which should be simple and
reliable. Then, we mark the pages so that the next time they are
accessed or mapped we recharge them to the "rightful" user.

For mapped pages, we can use the numa balancing approach of protecting
the mapping (while the vma is still accessible), and then in the fault
path recharge the page. This is better than eviction because the fault
on the next access is minor, and better than direct recharging to the
mapping in the sense that the charge is correlated with an
allocation/mapping. Of course, it is more complicated, we have to
handle different protection interactions (e.g. what if the page is
already protected?). Another disadvantage is that the recharging
happens in the context of a page fault, rather than asynchronously in
the case of directly recharging to the mapper. Page faults are more
latency sensitive, although this shouldn't be a common path.

For unmapped pages, I am struggling to find a way that is simple
enough to recharge the memory on the next access. My first intuition
was to add a hook to folio_mark_accessed(), but I was quickly told
that this is not invoked in all access paths to unmapped pages (e.g.
writes through fds). We can also add a hook to folio_mark_dirty() to
add more coverage, but it seems like this path is fragile, and it
would be ideal if there is a shared well-defined common path (or
paths) for all accesses to unmapped pages. I would imagine if such a
path exists or can be forged it would probably be in the page cache
code somewhere.

For both cases, if a new mapping is created, we can do recharging there.

Pros:
- Memory is recharged to the =E2=80=9Crightful=E2=80=9D user, eventually.
- The charge is predictable and correlates to a user's access.
- Less overhead on next access than eviction.

Cons:
- The memory will remain charged to the parent until the next access
happens, if it ever happens.
- Worse overhead on next access than directly recharging to the mapper.

With this (incompletely defined) toolkit, a recharging algorithm can
look like this (as a rough example):

- If the page is file-backed:
  - Unmapped? evict (a).
  - Mapped? recharge to the mapper -- direct (c) or deferred (d).
- If the page is swap-backed:
  - Unmapped? deferred recharge to the next accessor (d).
  - Mapped? recharge to the mapper -- direct (c) or deferred (d).

There are, of course, open questions:
1) How do we do deferred recharging for unmapped pages? Is deferred
recharging even a reliable option to begin with? What if the pages are
never accessed again?

2) How do we avoid hiding kernel bugs (e.g. extraneous references)
with recharging? Ideally, all recharged pages eventually end up
somewhere other than root, such that accumulation of recharged pages
at root signals a kernel bug.

3) What do we do about swapped pages charged to offline memcgs? Even
if we recharge all charged pages, preexisting swap entries will pin
the offline memcg. Do we walk all swap_cgroup entries and reparent the
swap entries?

Again, I was hoping to come up with a more concrete proposal, but as
LSF/MM/BPF is approaching, I wanted to share my thoughts on the
mailing list looking for any feedback.

Thanks!
