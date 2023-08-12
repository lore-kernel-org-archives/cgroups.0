From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Sat, 12 Aug 2023 04:04:32 -0700
Message-ID: <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
References: <CAJD7tkZFxbjas=VfhYSGU84Y5vyjuqHqGsRjiDEOSDWh2BxNAg@mail.gmail.com>
 <ZNYnx9NqwSsXKhX3@dhcp22.suse.cz> <CAJD7tkbJ1fnMDudtsS2xubKn0RTWz7t0Hem=PSRQQp3sGf-iOw@mail.gmail.com>
 <ZNaLGVUtPu7Ua/jL@dhcp22.suse.cz> <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
 <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com> <ZNdEaw2nktq1NfmH@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691838310; x=1692443110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJxz5Wo5bQtCB2HrXnTdvzAAMp9CCbg8i6pks8wxkuI=;
        b=vW6Bzk3RwWmtvH8JO/t1CTcYatZkRByvpzHoneTQf+aOWO2q6PtapSd13f+GAjvAB9
         dEJtx1rlOAzoje9tcR+r+pWtS7GqPYv+uiN1BQrXS7fiF8u1cJskNVJasN37/yE29xaV
         25z+J4ZFzTd7bVkED/r1019GQ/xvCBJVphitX47LbgN3UYkoo8VziKEpAjytsOe4vc5c
         OhzmBN30ubbXyg3yJpcUqdMmhBYwD18Iu9gOyt6DiYRZUg0ShkUFH32S2DM2E7G/l0Wh
         DTbG0KqyEseULb0XPtYqU+wYqMGsJiZwLIesBg2RUlPJ0TQFKta67UVzVEuN3ConbNBo
         t2dw==
In-Reply-To: <ZNdEaw2nktq1NfmH-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Sat, Aug 12, 2023 at 1:35=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Fri 11-08-23 19:48:14, Shakeel Butt wrote:
> > On Fri, Aug 11, 2023 at 7:36=E2=80=AFPM Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > >
> > > On Fri, Aug 11, 2023 at 7:29=E2=80=AFPM Shakeel Butt <shakeelb@google=
.com> wrote:
> > > >
> > > > On Fri, Aug 11, 2023 at 7:12=E2=80=AFPM Yosry Ahmed <yosryahmed@goo=
gle.com> wrote:
> > > > >
> > > > [...]
> > > > >
> > > > > I am worried that writing to a stat for flushing then reading wil=
l
> > > > > increase the staleness window which we are trying to reduce here.
> > > > > Would it be acceptable to add a separate interface to explicitly =
read
> > > > > flushed stats without having to write first? If the distinction
> > > > > disappears in the future we can just short-circuit both interface=
s.
> > > >
> > > > What is the acceptable staleness time window for your case? It is h=
ard
> > > > to imagine that a write+read will always be worse than just a read.
> > > > Even the proposed patch can have an unintended and larger than
> > > > expected staleness window due to some processing on
> > > > return-to-userspace or some scheduling delay.
> > >
> > > Maybe I am worrying too much, we can just go for writing to
> > > memory.stat for explicit stats refresh.
> > >
> > > Do we still want to go with the mutex approach Michal suggested for
> > > do_flush_stats() to support either waiting for ongoing flushes
> > > (mutex_lock) or skipping (mutex_trylock)?
> >
> > I would say keep that as a separate patch.
>
> Separate patches would be better but please make the mutex conversion
> first. We really do not want to have any busy waiting depending on a
> sleep exported to the userspace. That is just no-go.

+tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

That makes sense.

Taking a step back though, and considering there have been other
complaints about unified flushing causing expensive reads from
memory.stat [1], I am wondering if we should tackle the fundamental
problem.

We have a single global rstat lock for flushing, which protects the
global per-cgroup counters as far as I understand. A single lock means
a lot of contention, which is why we implemented unified flushing on
the memcg side in the first place, where we only let one flusher
operate and everyone else skip, but that flusher needs to flush the
entire tree.

This can be unnecessarily expensive (see [1]), and to avoid how
expensive it is we sacrifice accuracy (what this patch is about). I am
exploring breaking down that lock into per-cgroup locks, where a
flusher acquires locks in a top down fashion. This allows for some
concurrency in flushing, and makes unified flushing unnecessary. If we
retire unified flushing we fix both accuracy and expensive reads at
the same time, while not sacrificing performance for concurrent
in-kernel flushers.

What do you think? I am prototyping something now and running some
tests, it seems promising and simple-ish (unless I am missing a big
correctness issue).

[1] https://lore.kernel.org/lkml/CABWYdi3YNwtPDwwJWmCO-ER50iP7CfbXkCep5TKb-=
9QzY-a40A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

>
> Thanks!
> --
> Michal Hocko
> SUSE Labs
