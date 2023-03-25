From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Fri, 24 Mar 2023 19:17:54 -0700
Message-ID: <CAJD7tkYhyMkD8SFf8b8L1W9QUrLOdw-HJ2NUbENjw5dgFnH3Aw@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <ZBz/V5a7/6PZeM7S@slm.duckdns.org>
 <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg@mail.gmail.com> <ZB5UalkjGngcBDEJ@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679710711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uw0vvRX6fB45yziv3c2fRfTS3bTqjYau48XTnRaZKUQ=;
        b=O7Jst4Abb03/2SPXMx5C68RHpw3r3kFMKH7fZnFXh0aJIp2ZBgoM9SwaZL0lI/9pGh
         nOnlLtm4EcFl3i8d0j46aVqMGUTdlYBqj5yZXFsOZY9Wt0HiaQAMqbcFmRL6lcVCWdbx
         TnkXpXZS53IaAukR3UsCxNyfv1DwvSSVUN2GtB8yMaLijLAA2wiQ4TtPwRaAWmO3RNMB
         ssGwMxA6FnWB+KLIdXXQrz42GNgvAWzmC9y1auxEEhX5ynPFv8qM/jW7VouPr1t8bz9W
         o/YBrB3nWIDIOZaWdVAxep7Nkgx0jPcDgraTEVMPnZzXibYcCq16TyKvx4l4lRaML3zU
         Wd7g==
In-Reply-To: <ZB5UalkjGngcBDEJ@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Fri, Mar 24, 2023 at 6:54=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, Mar 24, 2023 at 12:22:09AM -0700, Yosry Ahmed wrote:
> > I think a problem with this approach is that we risk having to contend
> > for the global lock at every CPU boundary in atomic contexts. Right
> > now we contend for the global lock once, and once we have it we go
> > through all CPUs to flush, only having to contend with updates taking
> > the percpu locks at this point. If we unconditionally release &
> > reacquire the global lock at every CPU boundary then we may contend
> > for it much more frequently with concurrent flushers.
> >
> > On the memory controller side, concurrent flushers are already held
> > back to avoid a thundering herd problem on the global rstat lock, but
> > flushers from outside the memory controller can still compete together
> > or with a flusher from the memory controller. In this case, we risk
> > contending the global lock more and concurrent flushers taking a
> > longer period of time, which may end up causing multi-CPU stalls
> > anyway, right? Also, if we keep _irq when spinning for the lock, then
> > concurrent flushers still need to spin with irq disabled -- another
> > problem that this series tries to fix.
> >
> > This is particularly a problem for flushers in atomic contexts. There
> > is a flusher in mem_cgroup_wb_stats() that flushes while holding
> > another spinlock, and a flusher in mem_cgroup_usage() that flushes
> > with irqs disabled. If flushing takes a longer period of time due to
> > repeated lock contention, it affects such atomic context negatively.
> >
> > I am not sure how all of this matters in practice, it depends heavily
> > on the workloads and the configuration like you mentioned. I am just
> > pointing out the potential disadvantages of reacquiring the lock at
> > every CPU boundary in atomic contexts.
>
> So, I'm not too convinced by the arguments for a couple reasons:
>
> * It's not very difficult to create conditions where a contented non-irq
>   protected spinlock is held unnecessarily long due to heavy IRQ irq load=
 on
>   the holding CPU. This can easily extend the amount of time the lock is
>   held by multiple times if not orders of magnitude. That is likely a
>   significantly worse problem than the contention on the lock cacheline
>   which will lead to a lot more gradual degradation.

I agree that can be a problem, it depends on the specific workload and
configuration. The continuous lock contention at each CPU boundary
causes a regression (see my reply to Waiman), but I am not sure if
it's worse than the scenario you are describing.

>
> * If concurrent flushing is an actual problem, we need and can implement =
a
>   better solution. There's quite a bit of maneuvering room here given tha=
t
>   the flushing operations are mostly idempotent in close time proximity a=
nd
>   there's no real atomicity requirement across different segments of
>   flushing operations.

Concurrent flushing can be a problem for some workloads, especially in
the MM code we flush in the reclaim and refault paths. This is
currently mitigated by only allowing one flusher at a time from the
memcg side, but contention can still happen with flushing when a
cgroup is being freed or other flushers in other subsystems.

I tried allowing concurrent flushing by completely removing the global
rstat lock, and only depending on the percpu locks for
synchronization. For this to be correct the global stat counters need
to be atomic, this introduced a slow down for flushing in general. I
also noticed heavier lock contention on the percpu locks, since all
flushers try to acquire all locks in the same order. I even tried
implementing a simple retry scheme where we try to acquire the percpu
lock, and if we fail we queue the current cpu and move to the next
one. This ended up causing a little bit of slowness as well. Together
with the slowness introduced by atomic operations it seemed like a
significant regression in the simple flushing path.

Don't get me wrong, I am all for modifying the current approach, I
just want to make sure we are making the correct decision for *most*
workloads. Keep in mind that this series aims to minimize the number
of flushers from atomic contexts as well, and for non-atomic flushers
we allow giving up the lock at CPU boundaries anyway. The current
approach only keeps the lock held throughout for atomic flushers.

Any ideas here are welcome!

>
> Thanks.
>
> --
> tejun
