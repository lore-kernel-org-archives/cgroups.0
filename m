From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Thu, 30 Mar 2023 00:13:16 -0700
Message-ID: <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-5-yosryahmed@google.com> <ZCQfZJFufkJ10o01@dhcp22.suse.cz>
 <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
 <20230329192059.2nlme5ubshzdbpg6@google.com> <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680160433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIO+xjpPvxFE7p3Fg529YdgqYE0es+Za65fM8K1qjgQ=;
        b=UvXOXvaKg5W3pOiKg4eDH9lHl4Zdbajrfr9yCdPGB59p3EbanzUW5AbZ60M0Fo1jLj
         xgrtU13pG+2HRUXSZV1YHQUF6aAPx8bmMFTsyT+tMN4I6uSd3iTp4e0p5o0dlpChmR1N
         kgpM/rCb2oFLWV87Mo4Q+i3t95OakU3lMRj4YQ1nysYmA+Tpl5yBca0fvDqMPohFxbDB
         Y7+D8BKyWgRNceAUWpnfWnDi7HIUgkBAG3eDp8W+4bCHX6Cc8wGgEGVLJTMMQ7fZWTfd
         8/Oa9xlswq0vuQl+sJims+8vhoieSnu1v+Z91iZH9bXW/MlL8LF9mWWEI22UEcU5KFZ+
         xqbQ==
In-Reply-To: <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 30, 2023 at 12:06=E2=80=AFAM Michal Hocko <mhocko@suse.com> wro=
te:
>
> On Wed 29-03-23 19:20:59, Shakeel Butt wrote:
> > On Wed, Mar 29, 2023 at 11:41:39AM -0700, Yosry Ahmed wrote:
> > > On Wed, Mar 29, 2023 at 4:22=E2=80=AFAM Michal Hocko <mhocko@suse.com=
> wrote:
> > > >
> > > > On Tue 28-03-23 22:16:39, Yosry Ahmed wrote:
> > > > > rstat flushing is too expensive to perform in irq context.
> > > > > The previous patch removed the only context that may invoke an rs=
tat
> > > > > flush from irq context, add a WARN_ON_ONCE() to detect future
> > > > > violations, or those that we are not aware of.
> > > > >
> > > > > Ideally, we wouldn't flush with irqs disabled either, but we have=
 one
> > > > > context today that does so in mem_cgroup_usage(). Forbid callers =
from
> > > > > irq context for now, and hopefully we can also forbid callers wit=
h irqs
> > > > > disabled in the future when we can get rid of this callsite.
> > > >
> > > > I am sorry to be late to the discussion. I wanted to follow up on
> > > > Johannes reply in the previous version but you are too fast ;)
> > > >
> > > > I do agree that this looks rather arbitrary. You do not explain how=
 the
> > > > warning actually helps. Is the intention to be really verbose to th=
e
> > > > kernel log when somebody uses this interface from the IRQ context a=
nd
> > > > get bug reports? What about configurations with panic on warn? Do w=
e
> > > > really want to crash their systems for something like that?
> > >
> > > Thanks for taking a look, Michal!
> > >
> > > The ultimate goal is not to flush in irq context or with irqs
> > > disabled, as in some cases it causes irqs to be disabled for a long
> > > time, as flushing is an expensive operation. The previous patch in th=
e
> > > series should have removed the only context that flushes in irq
> > > context, and the purpose of the WARN_ON_ONCE() is to catch future use=
s
> > > or uses that we might have missed.
> > >
> > > There is still one code path that flushes with irqs disabled (also
> > > mem_cgroup_usage()), and we cannot remove this just yet; we need to
> > > deprecate usage threshold events for root to do that. So we cannot
> > > enforce not flushing with irqs disabled yet.
> > >
> > > So basically the patch is trying to enforce what we have now, not
> > > flushing in irq context, and hopefully at some point we will also be
> > > able to enforce not flushing with irqs disabled.
> > >
> > > If WARN_ON_ONCE() is the wrong tool for this, please let me know.
> > >
> >
> > If I understand Michal's concern, the question is should be start with
> > pr_warn_once() instead of WARN_ON_ONCE() and I think yes we should star=
t
> > with pr_warn_once().
>
> Yes, I do not really like the WARN_ON here. It is an overkill. pr_warn
> would much less intrusive but potentially incomplete because you won't
> know who that offender is. So if you really care about those then you
> would need to call dump_stack as well.
>
> So the real question is. Do we really care so deeply? After all somebody
> might be calling this from within a spin lock or irq disabled section
> resulting in a similar situation without noticing.

There are discussions in [1] about making atomic rstat flush not
disable irqs throughout the process, so in that case it would only
result in a similar situation if the caller has irq disabled. The only
caller that might have irq disabled is the same caller that might be
in irq context before this series: mem_cgroup_usage().

On that note, and while I have your attention, I was wondering if we
can eliminate the flush call completely from mem_cgroup_usage(), and
read the global stats counters for root memcg instead of the root
counters. There might be subtle differences, but the root memcg usage
isn't super accurate now anyway (e.g. it doesn't include kernel
memory).

With that removed, no callers to rstat flushing would be from irq
context or have irqs disabled. There will only be one atomic flusher
(mem_cgroup_wb_stats()), and we can proceed with [1] if it causes a
problem.

What do you think?

[1] https://lore.kernel.org/lkml/CAJD7tkZrp=3D4zWvjE9_010TAG1T_crCbf9P64UzJ=
ABspgcrGPKg@mail.gmail.com/

> --
> Michal Hocko
> SUSE Labs
