From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Wed, 29 Mar 2023 11:41:39 -0700
Message-ID: <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-5-yosryahmed@google.com> <ZCQfZJFufkJ10o01@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680115336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eIBZAFv2wQMorQ5lc8tGcKMX+DgU71oiqiwG/4lRhic=;
        b=aPynEkp0gt2yrrh6KFRsPFu4+QI+22LUjC71jLtYRdPz3tvtiYrWpQlMXP+93X3yGB
         FiYhI/lB1nm7o983gXqChQwZJgo7TUHZHozyA54eTsiL7qEpKTDtVNZjtT5OnUGO3FcT
         /Ghx5u5imvI3Gsd9iJAQJreaU9lhZCpMwvKLL4xwq3MEiupMjCgS2J6LanHI7FZzdNHE
         DD5BkwhMH87ZYXPw7tl2iLTM3LS+8SO6AidoBxBPFw0iS+D9jzkDX1w9ejhJCbS882ck
         3Y9hQaaQPnDbj315Xgi6CAnGj+I61uN4wFCd/FWxc6pmq9vBaD7hAvSlXrhKcXQw6j9r
         0zJQ==
In-Reply-To: <ZCQfZJFufkJ10o01@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Wed, Mar 29, 2023 at 4:22=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Tue 28-03-23 22:16:39, Yosry Ahmed wrote:
> > rstat flushing is too expensive to perform in irq context.
> > The previous patch removed the only context that may invoke an rstat
> > flush from irq context, add a WARN_ON_ONCE() to detect future
> > violations, or those that we are not aware of.
> >
> > Ideally, we wouldn't flush with irqs disabled either, but we have one
> > context today that does so in mem_cgroup_usage(). Forbid callers from
> > irq context for now, and hopefully we can also forbid callers with irqs
> > disabled in the future when we can get rid of this callsite.
>
> I am sorry to be late to the discussion. I wanted to follow up on
> Johannes reply in the previous version but you are too fast ;)
>
> I do agree that this looks rather arbitrary. You do not explain how the
> warning actually helps. Is the intention to be really verbose to the
> kernel log when somebody uses this interface from the IRQ context and
> get bug reports? What about configurations with panic on warn? Do we
> really want to crash their systems for something like that?

Thanks for taking a look, Michal!

The ultimate goal is not to flush in irq context or with irqs
disabled, as in some cases it causes irqs to be disabled for a long
time, as flushing is an expensive operation. The previous patch in the
series should have removed the only context that flushes in irq
context, and the purpose of the WARN_ON_ONCE() is to catch future uses
or uses that we might have missed.

There is still one code path that flushes with irqs disabled (also
mem_cgroup_usage()), and we cannot remove this just yet; we need to
deprecate usage threshold events for root to do that. So we cannot
enforce not flushing with irqs disabled yet.

So basically the patch is trying to enforce what we have now, not
flushing in irq context, and hopefully at some point we will also be
able to enforce not flushing with irqs disabled.

If WARN_ON_ONCE() is the wrong tool for this, please let me know.

>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > Reviewed-by: Shakeel Butt <shakeelb@google.com>
> > ---
> >  kernel/cgroup/rstat.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> > index d3252b0416b6..c2571939139f 100644
> > --- a/kernel/cgroup/rstat.c
> > +++ b/kernel/cgroup/rstat.c
> > @@ -176,6 +176,8 @@ static void cgroup_rstat_flush_locked(struct cgroup=
 *cgrp, bool may_sleep)
> >  {
> >       int cpu;
> >
> > +     /* rstat flushing is too expensive for irq context */
> > +     WARN_ON_ONCE(!in_task());
> >       lockdep_assert_held(&cgroup_rstat_lock);
> >
> >       for_each_possible_cpu(cpu) {
> > --
> > 2.40.0.348.gf938b09366-goog
>
> --
> Michal Hocko
> SUSE Labs
