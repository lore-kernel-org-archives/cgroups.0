From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Fri, 25 Aug 2023 09:05:46 +0200
Message-ID: <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
 <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz>
 <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
 <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692947147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFvqr2Mve2mQrFrdi3E/iQQ9tHKEJ+bL4oJ5DR3ONuA=;
        b=MRWBXewvJx4BQ8TNp/VntnCHY7bc0N+hCIA4Mr74fzytvbYazp8mM3CvngYeuTrbMnMDej
        mv5H77Tl1V23moyDMh5iLSMEBZWwD1inNjZ/Gf9AqYSnCq2eQWBUmqtzJ4ZQNMIBZrdDl9
        t6NQNNjgN4lPtm5PdLWfN6lgFOHOdqk=
Content-Disposition: inline
In-Reply-To: <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 24-08-23 11:50:51, Yosry Ahmed wrote:
> On Thu, Aug 24, 2023 at 11:15 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > On Thu, Aug 24, 2023 at 12:13 AM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Wed 23-08-23 07:55:40, Yosry Ahmed wrote:
> > > > On Wed, Aug 23, 2023 at 12:33 AM Michal Hocko <mhocko@suse.com> wrote:
> > > > >
> > > > > On Tue 22-08-23 08:30:05, Yosry Ahmed wrote:
> > > > > > On Tue, Aug 22, 2023 at 2:06 AM Michal Hocko <mhocko@suse.com> wrote:
> > > > > > >
> > > > > > > On Mon 21-08-23 20:54:58, Yosry Ahmed wrote:
> > > > > [...]
> > > > > > So to answer your question, I don't think a random user can really
> > > > > > affect the system in a significant way by constantly flushing. In
> > > > > > fact, in the test script (which I am now attaching, in case you're
> > > > > > interested), there are hundreds of threads that are reading stats of
> > > > > > different cgroups every 1s, and I don't see any negative effects on
> > > > > > in-kernel flushers in this case (reclaimers).
> > > > >
> > > > > I suspect you have missed my point.
> > > >
> > > > I suspect you are right :)
> > > >
> > > >
> > > > > Maybe I am just misunderstanding
> > > > > the code but it seems to me that the lock dropping inside
> > > > > cgroup_rstat_flush_locked effectivelly allows unbounded number of
> > > > > contenders which is really dangerous when it is triggerable from the
> > > > > userspace. The number of spinners at a moment is always bound by the
> > > > > number CPUs but depending on timing many potential spinners might be
> > > > > cond_rescheded and the worst time latency to complete can be really
> > > > > high. Makes more sense?
> > > >
> > > > I think I understand better now. So basically because we might drop
> > > > the lock and resched, there can be nr_cpus spinners + other spinners
> > > > that are currently scheduled away, so these will need to wait to be
> > > > scheduled and then start spinning on the lock. This may happen for one
> > > > reader multiple times during its read, which is what can cause a high
> > > > worst case latency.
> > > >
> > > > I hope I understood you correctly this time. Did I?
> > >
> > > Yes. I would just add that this could also influence the worst case
> > > latency for a different reader - so an adversary user can stall others.
> >
> > I can add that for v2 to the commit log, thanks.
> >
> > > Exposing a shared global lock in uncontrolable way over generally
> > > available user interface is not really a great idea IMHO.
> >
> > I think that's how it was always meant to be when it was designed. The
> > global rstat lock has always existed and was always available to
> > userspace readers. The memory controller took a different path at some
> > point with unified flushing, but that was mainly because of high
> > concurrency from in-kernel flushers, not because userspace readers
> > caused a problem. Outside of memcg, the core cgroup code has always
> > exercised this global lock when reading cpu.stat since rstat's
> > introduction. I assume there hasn't been any problems since it's still
> > there.

I suspect nobody has just considered a malfunctioning or adversary
workloads so far.

> > I was hoping Tejun would confirm/deny this.

Yes, that would be interesting to hear.

> One thing we can do to remedy this situation is to replace the global
> rstat lock with a mutex, and drop the resched/lock dropping condition.
> Tejun suggested this in the previous thread. This effectively reverts
> 0fa294fb1985 ("cgroup: Replace cgroup_rstat_mutex with a spinlock")
> since now all the flushing contexts are sleepable.

I would have a very daring question. Do we really need a global lock in
the first place? AFAIU this locks serializes (kinda as the lock can be
dropped midway) flushers and cgroup_rstat_flush_hold/release caller (a
single one ATM). I can see cgroup_base_stat_cputime_show would like to
have a consistent view on multiple stats but can we live without a
strong guarantee or to replace the lock with seqlock instead?

> My synthetic stress test does not show any regressions with mutexes,
> and there is a small boost to reading latency (probably because we
> stop dropping the lock / rescheduling). Not sure if we may start
> seeing need_resched warnings on big flushes though.

Reading 0fa294fb1985 ("cgroup: Replace cgroup_rstat_mutex with a spinlock")
it seems the point of moving away from mutex was to have a more usable
API.

> One other concern that Shakeel pointed out to me is preemption. If
> someone holding the mutex gets preempted this may starve other
> waiters. We can disable preemption while we hold the mutex, not sure
> if that's a common pattern though.

No, not really. It is expected that holder of mutex can sleep and can be
preempted as well.

I might be wrong but the whole discussion so far suggests that the
global rstat lock should be reconsidered. From my personal experience
global locks easily triggerable from the userspace are just a receip for
problems. Stats reading shouldn't be interfering with the system runtime
as much as possible and they should be deterministic wrt runtime as
well.
-- 
Michal Hocko
SUSE Labs
