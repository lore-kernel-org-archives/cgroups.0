From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v1 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Tue, 28 Mar 2023 11:59:59 -0700
Message-ID: <CAJD7tkYA=0rKSmtQzYQpZ2DuUoJq0bQcVqPgSpVEs0M4zAktnw@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-5-yosryahmed@google.com> <ZCMojk50vjiK6mBe@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680030036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VaFE8MJ/rJnWu49G6qaf7Zeu9SjJjHyr+HaKIIGZlo8=;
        b=hGNPwQWTEYe3CZmGYHi60X2aSfRWtVK8WiJ7nu3mjdJk4YmjuiqYe9pQ+CDJlPYyxd
         /pi9trbtJtSOm7MifwcGnSBImrwX+6Z42snV0nbBlJ7UXJ/eKh48Yn/EV7NYVDSmmbPt
         Rb0l9k4E3FCIRsq0+yQqNxV2ey483qI2f6DnbBWaNsDKB3buuC+B9cupFif5N8kLGalN
         EqIH5K8IIPJWWoiCFHfQlnBM7LhKzgagHTbCa9LC7C/ObuzCHw9amKjqLxPdo/JKx3RO
         c+XsEE64L2GpM8WO4QZD+clco6JbOEINCGSlyDLrWKVTxZp91kvGAVcL2J04SbpNs5mz
         w6JQ==
In-Reply-To: <ZCMojk50vjiK6mBe@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Tue, Mar 28, 2023 at 10:49=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Tue, Mar 28, 2023 at 06:16:33AM +0000, Yosry Ahmed wrote:
> > rstat flushing is too expensive to perform in irq context.
> > The previous patch removed the only context that may invoke an rstat
> > flush from irq context, add a WARN_ON_ONCE() to detect future
> > violations, or those that we are not aware of.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
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
>
> This seems a bit arbitrary. Why is an irq caller forbidden, but an
> irq-disabled, non-preemptible section caller is allowed? The latency
> impact on the system would be the same, right?

Thanks for taking a look.

So in the first patch series the initial purpose was to make sure
cgroup_rstat_lock was never acquired in an irq context, so that we can
stop disabling irqs while holding it. Tejun disagreed with this
approach though.

We currently have one caller that calls flushing with irqs disabled
(mem_cgroup_usage()) -- so we cannot forbid such callers (yet), but I
thought we can at least forbid callers from irq context now (or catch
those that we are not aware of), and then maybe forbid irqs_disabled()
contexts as well we can get rid of that callsite.

WDYT?
