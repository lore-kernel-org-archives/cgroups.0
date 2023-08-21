From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Mon, 21 Aug 2023 13:58:22 -0700
Message-ID: <CAJD7tkZNfaWcMmCizRMfw_EQ0=nZ+xUkLEBdxvp5GK3+poV2aQ@mail.gmail.com>
References: <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org> <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg@mail.gmail.com>
 <ZNrLO5PAEZw4yjI9@slm.duckdns.org> <CAJD7tkYgCySTX28zK9GZiWwsabR4nv7M2hQ57y12si-fqtv7zg@mail.gmail.com>
 <CALvZod6KRxiDzrppCgx+=SHg2+96nFE5crwXCKwe9PZbWM_6cQ@mail.gmail.com>
 <CAJD7tkaUzhvZPohpo1F8TUKRPuXH7bjDeg9VCzN2CbywQbRutQ@mail.gmail.com>
 <CALvZod6HUtYhDaXiwXSrcwfxLSrZ37sZhKY1Mg4kmpDFk13aYw@mail.gmail.com>
 <CAJD7tkYzr2cg-aQ899vfqB4jR7iP83t8f-Z4AH8d9iW-yw-nnQ@mail.gmail.com>
 <CALvZod441xBoXzhqLWTZ+xnqDOFkHmvrzspr9NAr+nybqXgS-A@mail.gmail.com>
 <ZN0eqq4hLRYQPHCI@slm.duckdns.org> <CAJD7tkYSk-73c1=5vmuRdykAQO=pJSkQFgRqkpdfnh7f-Zufkw@mail.gmail.com>
 <CAJD7tkYGeYzQ=zVm_Ewgqfc4u1udSvjThLxOrghmMHO=rqvaDA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692651539; x=1693256339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbpQ6J2JbDbq9n2VQq/6we3rCBQZ2LXRiD+xapKkGXw=;
        b=U8qf/ENQTd2sCVviFY7hWlKIaAEj8on8IZmLHdWDcLUdn1xNFXFpQF+vAd/IQdGYHC
         opuIAkQgOKr5sqPudhkcPSXI4KMe3WtfotnVUiiHfqZZxttlyJRij/6AJTOdzKjdiycI
         N1TZStvj86wlanUfbAFjmwF/jq9QGZyWZXVvuBa/9vYvSqpkxlJNRNDzCj35JQf3iw2c
         dP8ARm2Tu1mUD25pF9mpx9GTvjhq+swewTo0XQfKxKNrhB9GXY8vH5adzkEuuMMsunxB
         7xF3zah+cMidpUjvkveU5hTtr9xzy9mK24FfKEXNDFHF2Q7ah4RPJVwGuK5IdJ91wr0i
         F/sw==
In-Reply-To: <CAJD7tkYGeYzQ=zVm_Ewgqfc4u1udSvjThLxOrghmMHO=rqvaDA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Ivan Babrou <ivan@cloudflare.com>

On Fri, Aug 18, 2023 at 2:40=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com>=
 wrote:
>
> On Wed, Aug 16, 2023 at 3:35=E2=80=AFPM Yosry Ahmed <yosryahmed@google.co=
m> wrote:
> >
> > On Wed, Aug 16, 2023 at 12:08=E2=80=AFPM Tejun Heo <tj@kernel.org> wrot=
e:
> > >
> > > Hello,
> > >
> > > On Wed, Aug 16, 2023 at 10:11:20AM -0700, Shakeel Butt wrote:
> > > > These options are not white and black and there can be something in
> > > > between but let me be very clear on what I don't want and would NAC=
K.
> > >
> > > I'm not a big fan of interfaces with hidden states. What you're propo=
sing
> > > isn't strictly that but it's still a bit nasty. So, if we can get by =
without
> > > doing that, that'd be great.
> >
> > Agreed. I will try to send patches soon implementing option (2) above,
> > basically removing unified flushing. I will try to document any
> > potential regressions that may happen and how we may fix them. Ideally
> > we see no regressions.
> >
> > >
> > > > I don't want a global sleepable lock which can be taken by potentia=
lly
> > > > any application running on the system. We have seen similar global
> > > > locks causing isolation and priority inversion issues in production=
.
> > > > So, not another lock which needs to be taken under extreme conditio=
n
> > > > (reading stats under OOM) by a high priority task (node controller)
> > > > and might be held by a low priority task.
> > >
> > > Yeah, this is a real concern. Those priority inversions do occur and =
can be
> > > serious but causing serious problems under memory pressure usually re=
quires
> > > involving memory allocations and IOs. Here, it's just all CPU. So, at=
 least
> > > in OOM conditions, this shouldn't be in the way (the system wouldn't =
have
> > > anything else to do anyway).
> > >
> > > It is true that this still can lead to priority through CPU competiti=
on tho.
> > > However, that problem isn't necessarily solved by what you're suggest=
ing
> > > either unless you want to restrict explicit flushing based on permiss=
ions
> > > which is another can of worms.
> >
> > Right. Also in the case of a mutex, if we disable preemption while
> > holding the mutex, this makes sure that whoever holding the mutex does
> > not starve waiters. Essentially the difference would be that waiters
> > will sleep with the mutex instead of spinning, but the mutex holder
> > itself wouldn't sleep.
> >
> > I will make this a separate patch, just in case it's too
> > controversial. Switching the spinlock to a mutex should not block
> > removing unified flushing.
> >
> > >
> > > My preference is not exposing this in user interface. This is mostly =
arising
> > > from internal implementation details and isn't what users necessarily=
 care
> > > about. There are many things we can do on the kernel side to make tra=
de-offs
> > > among overhead, staleness and priority inversions. If we make this an
> > > explicit userland interface behavior, we get locked into that semanti=
cs
> > > which we'll likely regret in some future.
> > >
> >
> > Yeah that's what I am trying to do here as well.  I will try to follow
> > up on this discussion with patches soon.
> >
> > Thanks everyone!
>
> So status update. I tried implementing removing unified flushing. I
> can send the patches if it helps visualize things, but essentially
> mem_cgroup_flush_stats{_ratelimited} takes a memcg argument that it
> passes to cgroup_flush_stats(). No skipping if someone else is
> flushing (stats_flush_ongoing) and no threshold at which we start
> flushing (stats_flush_threshold).
>
> I tested this by some synthetic reclaim stress test that I wrote,
> because reclaim is the easiest way to stress in-kernel flushing. I
> basically create 10s or 100s cgroups and run workers in them that keep
> allocating memory beyond the limit. I also run workers that
> periodically read the stats.
>
> Removing unified flushing makes such a synthetic benchmark 2-3 times
> slower. This is not surprising, as all these concurrent reclaimers
> used to just skip flushing, regardless of whether or not they get
> accurate stats. Now I don't know how realistic such a benchmark is,
> but if there's a workload somewhere that runs into such conditions it
> will surely regress.
>
> Sorry if the above is difficult to visualize. I can send the patches
> and the test script if it makes things easier, I just didn't want to
> overwhelm the thread.
>
> I think there are 2 options going forward:
> (a) If we believe removing unified flushing is the best way forward
> for most use cases, then we need to find a better way of testing this
> approach practically. Any suggestions here are useful.
>
> (b) Decide that it's too expensive to remove unified flushing
> completely, at least for in-kernel flushers that can see a lot of
> concurrency. We can only remove unified flushing for userspace reads.
> Only flush the memcg being read and never skip (essentially what Ivan
> tried). There are already some flushing contexts that do this (e.g.
> zswap memcg charging code). I believe as long as there isn't a lot of
> concurrency in these paths it should be fine to skip unified flushing
> for them, and keep it only for in-kernel flushers.

I sent a short series implementing (b) above:
https://lore.kernel.org/lkml/20230821205458.1764662-1-yosryahmed@google.com=
/

Basic testing shows that it works well.
