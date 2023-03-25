From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Fri, 24 Mar 2023 21:37:08 -0700
Message-ID: <CAJD7tkY_ESpMYMw72bsATpp6tPphv8qS6VbfEUjpKZW6vUqQSQ@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <ZBz/V5a7/6PZeM7S@slm.duckdns.org>
 <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg@mail.gmail.com>
 <ZB5UalkjGngcBDEJ@slm.duckdns.org> <CAJD7tkYhyMkD8SFf8b8L1W9QUrLOdw-HJ2NUbENjw5dgFnH3Aw@mail.gmail.com>
 <CALvZod6rF0D21hcV7xnqD+oRkn=x5NLi5GOkPpyaPa859uDH+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679719064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMuWO+eqM4F8nQZaJRTjXyqs2/5MQPRiPwC4jEGB2Rs=;
        b=L+/JPY/0iREVQLvI7pggvIU85qKWyZuwLse9KHVQy00x8LnQk15zEqQ2dItfbkf8Xc
         jinjmlAjwTxba/K+cbeiot0mNiIF15Oi4eDBVwxanGDJjspzMRs/QEKZhb3nTnGG20Qk
         VCIX3A1iKO2CtSUq+wB+uKNxtSvCDACGv/ulf6pILtz7hI/K1gI6rhNEP0DsLW0t3JSg
         AzhYalbZFDACojW1EW0rFcfP25ejlhpDyTw+3o3AN5EoMcU49k0QrbmBymzShyxBd/Kn
         HTBVcaYssSwFsoVs2gUZS47oZ5CUrOJQR6m1EZ/9EUrtjdiIBWvfQH4XA7Ier1JLOUtr
         7ZBw==
In-Reply-To: <CALvZod6rF0D21hcV7xnqD+oRkn=x5NLi5GOkPpyaPa859uDH+Q@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Fri, Mar 24, 2023 at 9:31=E2=80=AFPM Shakeel Butt <shakeelb@google.com> =
wrote:
>
> On Fri, Mar 24, 2023 at 7:18=E2=80=AFPM Yosry Ahmed <yosryahmed@google.co=
m> wrote:
> >
> [...]
> > Any ideas here are welcome!
> >
>
> Let's move forward. It seems like we are not going to reach an
> agreement on making cgroup_rstat_lock a non-irq lock. However there is
> agreement on the memcg code of not flushing in irq context and the
> cleanup Johannes has requested. Let's proceed with those for now. We
> can come back to cgroup_rstat_lock later if we still see issues in
> production.

Even if we do not flush from irq context, we still flush from atomic
contexts that will currently hold the lock with irqs disabled
throughout the entire flush sequence. A primary purpose of this reason
is to avoid that.

We can either:
(a) Proceed with the following approach of making cgroup_rstat_lock a
non-irq lock.
(b) Proceed with Tejun's suggestion of always releasing and
reacquiring the lock at CPU boundaries, even for atomic flushes (if
the spinlock needs a break ofc).
(c) Something else.

I am happy to proceed with any solution, but we need to address the
fact that interrupts are always disabled throughout the flush. My main
concern about Tejun's suggestion is atomic contexts having to contend
cgroup_rstat_lock much more than they do now, but it's still better
than what we have today.

>
> Tejun, do you have any concerns on adding WARN_ON_ONCE(!in_task()) in
> the rstat flushing code?
