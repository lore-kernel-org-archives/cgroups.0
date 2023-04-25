From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Tue, 25 Apr 2023 11:53:21 -0700
Message-ID: <CAJD7tkb1W0bP3AU9KepOYPx-AD-fMKSfUhj_Cmth63RS9umMsg@mail.gmail.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <CAJD7tkZw9uVPe5KH2xrihsv5nDmExJmkmsUPYP6Npvv6Q0NcVw@mail.gmail.com>
 <CAJD7tkb56gR0X5v3VHfmk3az3bOz=wF2jhEi+7Eek0J8XXBeWQ@mail.gmail.com> <27e15be8-d0eb-ed32-a0ec-5ec9b59f1f27@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682448838; x=1685040838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RWVSQZ+0SzhYTj35AIqktL1T3erQBqIEznyQOxJFUF8=;
        b=cpBNalHy/F3AiuVvLY/LRZPtUf6B98St0z5R90iAuyRryxYnpzm2DpkqmUbG8mw4xX
         8geNDh5t1gL5S1EASloVvEyUcdUFqfWw4lsjk5EECiG9jusf+0ECM0njqOtOp7kd+YfX
         REqXAzY9/uabyFdd57SQ7/z70a/gUpxxdheY3AVgbrn5pFZKbsYLHI/Ahr4vKbChiVu7
         JIBisb8xwEGvnpkK/nQdfwPYiA4zg9N6wzOgXjF2+e10oYKOmhHukQXDTjTmk6dW862G
         V0BqDyUtnqPI9o31BL/0K8k4vgZjgZesOlo5yWaOW7YvfLN+/fgGko9m2MSK5iZvd1ve
         liEg==
In-Reply-To: <27e15be8-d0eb-ed32-a0ec-5ec9b59f1f27-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 25, 2023 at 11:42=E2=80=AFAM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>
> On 4/25/23 07:36, Yosry Ahmed wrote:
> >   +David Rientjes +Greg Thelen +Matthew Wilcox
> >
> > On Tue, Apr 11, 2023 at 4:48=E2=80=AFPM Yosry Ahmed <yosryahmed@google.=
com> wrote:
> >> On Tue, Apr 11, 2023 at 4:36=E2=80=AFPM T.J. Mercier <tjmercier@google=
.com> wrote:
> >>> When a memcg is removed by userspace it gets offlined by the kernel.
> >>> Offline memcgs are hidden from user space, but they still live in the
> >>> kernel until their reference count drops to 0. New allocations cannot
> >>> be charged to offline memcgs, but existing allocations charged to
> >>> offline memcgs remain charged, and hold a reference to the memcg.
> >>>
> >>> As such, an offline memcg can remain in the kernel indefinitely,
> >>> becoming a zombie memcg. The accumulation of a large number of zombie
> >>> memcgs lead to increased system overhead (mainly percpu data in struc=
t
> >>> mem_cgroup). It also causes some kernel operations that scale with th=
e
> >>> number of memcgs to become less efficient (e.g. reclaim).
> >>>
> >>> There are currently out-of-tree solutions which attempt to
> >>> periodically clean up zombie memcgs by reclaiming from them. However
> >>> that is not effective for non-reclaimable memory, which it would be
> >>> better to reparent or recharge to an online cgroup. There are also
> >>> proposed changes that would benefit from recharging for shared
> >>> resources like pinned pages, or DMA buffer pages.
> >> I am very interested in attending this discussion, it's something that
> >> I have been actively looking into -- specifically recharging pages of
> >> offlined memcgs.
> >>
> >>> Suggested attendees:
> >>> Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>> Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>> T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >>> Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>> Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> >>> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >>> Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> >>> Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> >>> Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> >>> Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
> Muchun had actually posted patch to do this last year. See
>
> https://lore.kernel.org/all/20220621125658.64935-10-songmuchun@bytedance.=
com/T/#me9dbbce85e2f3c4e5f34b97dbbdb5f79d77ce147
>
> I am wondering if he is going to post an updated version of that or not.
> Anyway, I am looking forward to learn about the result of this
> discussion even thought I am not a conference invitee.

There are a couple of problems that were brought up back then, mainly
that memory will be reparented to the root memcg eventually,
practically escaping accounting. Shared resources may end up being
eventually unaccounted. Ideally, we can come up with a scheme where
the memory is charged to the real user, instead of just to the parent.

Consider the case where processes in memcg A and B are both using
memory that is charged to memcg A. If memcg A goes offline, and we
reparent the memory, memcg B keeps using the memory for free, taxing
A's parent, or the entire system if that's root.

Also, if there is a kernel bug and a page is being pinned
unnecessarily, those pages will never be reclaimed and will stick
around and eventually be reparented to the root memcg. If being
reparented to the root memcg is a legitimate action, you can't simply
tell apart if pages are sticking around just because they are being
used by someone or if there is a kernel bug.

>
> Thanks,
> Longman
>
>
