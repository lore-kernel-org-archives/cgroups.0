From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Thu, 23 Mar 2023 06:35:44 -0700
Message-ID: <CAJD7tkY6Wf2OWja+f-JeFM5DdMCyLzbXxZ8KF0MjcYOKri-vtA@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
 <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg@mail.gmail.com> <CALvZod5GT=bZsLXsG500pNkEJpMB1o2KJau4=r0eHB-c8US53A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679578580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuE0cJjbmK+/BhJwvJMFWgBmHM9057+RC8AkvA4HkKU=;
        b=DcDiKscPNUA4W1/GbdqN5BhxUIYoz9Wmqq3Xmd1C+DUMMpURN79kep/XyUMFs7O6WW
         MdqSEoZEpJh6K1uDYGXqCYwtqPCRXnq1QLfTpNV4Eo1IgdgOLTpM3R2PdOsbI+hV2kfK
         QVD9wZK3LA17mTvY76ITqoPHiau96K56j+TNrZ6a3QUQ5L79xAReQuBw7n00P8VHIWWm
         neNib3URA3K2d5FtCKba9hlgjdkmZkjza+ySCPA7jYZFPPJYNEHu2p+u2TV4VmmjgEJS
         llW6op2xvHlxZkcr/ECLM2jHofYIAEetci4tarDdc6n3marMfQcOD5Xx5wNyNvIJNjGD
         lz0Q==
In-Reply-To: <CALvZod5GT=bZsLXsG500pNkEJpMB1o2KJau4=r0eHB-c8US53A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Wed, Mar 22, 2023 at 11:33=E2=80=AFPM Shakeel Butt <shakeelb@google.com>=
 wrote:
>
> On Wed, Mar 22, 2023 at 10:15=E2=80=AFPM Yosry Ahmed <yosryahmed@google.c=
om> wrote:
> >
> [...]
> > > Couple of questions:
> > >
> > > 1. What exactly is cgroup_rstat_lock protecting? Can we just remove i=
t
> > > altogether?
> >
> > I believe it protects the global state variables that we flush into.
> > For example, for memcg, it protects mem_cgroup->vmstats.
> >
> > I tried removing the lock and allowing concurrent flushing on
> > different cpus, by changing mem_cgroup->vmstats to use atomics
> > instead, but that turned out to be a little expensive. Also,
> > cgroup_rstat_lock is already contended by different flushers
> > (mitigated by stats_flush_lock on the memcg side). If we remove it,
> > concurrent flushers contend on every single percpu lock instead, which
> > also seems to be expensive.
>
> We should add a comment on what it is protecting. I think block rstat
> are fine but memcg and bpf would need this.

I think it also protects the cpu base stats flushed by cgroup_base_stat_flu=
sh().

I will add a comment in the next version.

>
> >
> > > 2. Are we really calling rstat flush in irq context?
> >
> > I think it is possible through the charge/uncharge path:
> > memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usage(). I
> > added the protection against flushing in an interrupt context for
> > future callers as well, as it may cause a deadlock if we don't disable
> > interrupts when acquiring cgroup_rstat_lock.
> >
> > > 3. The mem_cgroup_flush_stats() call in mem_cgroup_usage() is only
> > > done for root memcg. Why is mem_cgroup_threshold() interested in root
> > > memcg usage? Why not ignore root memcg in mem_cgroup_threshold() ?
> >
> > I am not sure, but the code looks like event notifications may be set
> > up on root memcg, which is why we need to check thresholds.
>
> This is something we should deprecate as root memcg's usage is ill define=
d.

Right, but I think this would be orthogonal to this patch series.

>
> >
> > Even if mem_cgroup_threshold() does not flush memcg stats, the purpose
> > of this patch is to make sure the rstat flushing code itself is not
> > disabling interrupts; which it currently does for any unsleepable
> > context, even if it is interruptible.
>
> Basically I am saying we should aim for VM_BUG_ON(!in_task()) in the
> flush function rather than adding should_skip_flush() which does not
> stop potential new irq flushers.

I wanted to start with VM_BUG_ON(!in_task()) but I wasn't sure that
all contexts that call rstat flushing are not in irq contexts. I added
should_skip_flush() so that if there are existing flushers in irq
context, or new flushers are added, we are protected against a
deadlock.

We can change should_skip_flush() to have a WARN_ON_ONCE(!in_task())
to alert in this case. If you prefer removing should_skip_flush() and
just adding VM_BUG_ON(!in_task()) we can do that, but personally I was
not confident enough that we have no code paths today that may attempt
flushing from irq context.
