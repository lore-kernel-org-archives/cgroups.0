From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Wed, 22 Mar 2023 22:15:05 -0700
Message-ID: <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679548542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YiBnEdYy6Aid4dyiIRb9ptP+TZS4JSWAxv3bvFBhfG4=;
        b=KjytUVYDmXDoW1kHgbDCbvCLYfxK+63b9aN2H7qBDtgtsxUI5OrZu53Lwl+GZnw0aJ
         01ArWTb9RVmWC495n9DxCFBjmF0qY/lqyeeIAVSiAn/aUnYfvmYR3QRULUpzpOBma5HJ
         1+ytefxZiq0W1QKk5BPSDY7oYrkC4lDmQhAqbKsHhetsX6cK5fJcoZErFKGhWuRXhxyI
         p2BcFq4WozSFWYwoA28WxVcjRBVpqMyGmKeVHUGeck+Via4SQbj3gRnZsH2+wmdGGYqJ
         m3bky+4aHeeGT/A27qicrKyfuYVue8fxY0dpOhHe+LAcLJLzrkBD+xp1/xz5qYKXjWiw
         GJsQ==
In-Reply-To: <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 22, 2023 at 9:29=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> On Wed, Mar 22, 2023 at 9:00=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >
> > Currently, when sleeping is not allowed during rstat flushing, we hold
> > the global rstat lock with interrupts disabled throughout the entire
> > flush operation. Flushing in an O(# cgroups * # cpus) operation, and
> > having interrupts disabled throughout is dangerous.
> >
> > For some contexts, we may not want to sleep, but can be interrupted
> > (e.g. while holding a spinlock or RCU read lock). As such, do not
> > disable interrupts throughout rstat flushing, only when holding the
> > percpu lock. This breaks down the O(# cgroups * # cpus) duration with
> > interrupts disabled to a series of O(# cgroups) durations.
> >
> > Furthermore, if a cpu spinning waiting for the global rstat lock, it
> > doesn't need to spin with interrupts disabled anymore.
> >
> > If the caller of rstat flushing needs interrupts to be disabled, it's u=
p
> > to them to decide that, and it should be fine to hold the global rstat
> > lock with interrupts disabled. There is currently a single context that
> > may invoke rstat flushing with interrupts disabled, the
> > mem_cgroup_flush_stats() call in mem_cgroup_usage(), if called from
> > mem_cgroup_threshold().
> >
> > To make it safe to hold the global rstat lock with interrupts enabled,
> > make sure we only flush from in_task() contexts. The side effect of tha=
t
> > we read stale stats in interrupt context, but this should be okay, as
> > flushing in interrupt context is dangerous anyway as it is an expensive
> > operation, so reading stale stats is safer.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Couple of questions:
>
> 1. What exactly is cgroup_rstat_lock protecting? Can we just remove it
> altogether?

I believe it protects the global state variables that we flush into.
For example, for memcg, it protects mem_cgroup->vmstats.

I tried removing the lock and allowing concurrent flushing on
different cpus, by changing mem_cgroup->vmstats to use atomics
instead, but that turned out to be a little expensive. Also,
cgroup_rstat_lock is already contended by different flushers
(mitigated by stats_flush_lock on the memcg side). If we remove it,
concurrent flushers contend on every single percpu lock instead, which
also seems to be expensive.

> 2. Are we really calling rstat flush in irq context?

I think it is possible through the charge/uncharge path:
memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usage(). I
added the protection against flushing in an interrupt context for
future callers as well, as it may cause a deadlock if we don't disable
interrupts when acquiring cgroup_rstat_lock.

> 3. The mem_cgroup_flush_stats() call in mem_cgroup_usage() is only
> done for root memcg. Why is mem_cgroup_threshold() interested in root
> memcg usage? Why not ignore root memcg in mem_cgroup_threshold() ?

I am not sure, but the code looks like event notifications may be set
up on root memcg, which is why we need to check thresholds.

Even if mem_cgroup_threshold() does not flush memcg stats, the purpose
of this patch is to make sure the rstat flushing code itself is not
disabling interrupts; which it currently does for any unsleepable
context, even if it is interruptible.
