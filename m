From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Thu, 24 Aug 2023 11:50:51 -0700
Message-ID: <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-4-yosryahmed@google.com> <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
 <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz> <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz> <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692903088; x=1693507888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FIntCscqhDfEHiFTt/nLdYcoh0FY54rWEh/TsH/OwaQ=;
        b=YTj/bsBvUZUTjYN49dDIHhjUbcqUZnmwFrUEPy7wBE1yP8CClRJZcB2EqH8BTQ9L1p
         9rfVxKZVqXDZQGgj5YVz4GBx700Sa82keEh+vFvHbV2cDP51G+M+h52AeHFmD3rhQT/S
         KAjaYgd0InsPnpsp6p4u+LcvCftNLUwhzZ+GmDpg07XyqQf+hQVd/5t4uAHmpkqoqyIx
         vmLOEMUE89WpXkh3oTDnsYgyIlxzeAz8grVxGy6Iux4RvAMQlX6In2y406zdh46ESotF
         J2SvKFOD1STNKGBtkA7auuwY6QebYfK0veMj/+Eb8DraUFnVMB4WLcrBRvcODMDC0zcu
         v8Pw==
In-Reply-To: <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 24, 2023 at 11:15=E2=80=AFAM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> On Thu, Aug 24, 2023 at 12:13=E2=80=AFAM Michal Hocko <mhocko@suse.com> w=
rote:
> >
> > On Wed 23-08-23 07:55:40, Yosry Ahmed wrote:
> > > On Wed, Aug 23, 2023 at 12:33=E2=80=AFAM Michal Hocko <mhocko@suse.co=
m> wrote:
> > > >
> > > > On Tue 22-08-23 08:30:05, Yosry Ahmed wrote:
> > > > > On Tue, Aug 22, 2023 at 2:06=E2=80=AFAM Michal Hocko <mhocko@suse=
.com> wrote:
> > > > > >
> > > > > > On Mon 21-08-23 20:54:58, Yosry Ahmed wrote:
> > > > [...]
> > > > > So to answer your question, I don't think a random user can reall=
y
> > > > > affect the system in a significant way by constantly flushing. In
> > > > > fact, in the test script (which I am now attaching, in case you'r=
e
> > > > > interested), there are hundreds of threads that are reading stats=
 of
> > > > > different cgroups every 1s, and I don't see any negative effects =
on
> > > > > in-kernel flushers in this case (reclaimers).
> > > >
> > > > I suspect you have missed my point.
> > >
> > > I suspect you are right :)
> > >
> > >
> > > > Maybe I am just misunderstanding
> > > > the code but it seems to me that the lock dropping inside
> > > > cgroup_rstat_flush_locked effectivelly allows unbounded number of
> > > > contenders which is really dangerous when it is triggerable from th=
e
> > > > userspace. The number of spinners at a moment is always bound by th=
e
> > > > number CPUs but depending on timing many potential spinners might b=
e
> > > > cond_rescheded and the worst time latency to complete can be really
> > > > high. Makes more sense?
> > >
> > > I think I understand better now. So basically because we might drop
> > > the lock and resched, there can be nr_cpus spinners + other spinners
> > > that are currently scheduled away, so these will need to wait to be
> > > scheduled and then start spinning on the lock. This may happen for on=
e
> > > reader multiple times during its read, which is what can cause a high
> > > worst case latency.
> > >
> > > I hope I understood you correctly this time. Did I?
> >
> > Yes. I would just add that this could also influence the worst case
> > latency for a different reader - so an adversary user can stall others.
>
> I can add that for v2 to the commit log, thanks.
>
> > Exposing a shared global lock in uncontrolable way over generally
> > available user interface is not really a great idea IMHO.
>
> I think that's how it was always meant to be when it was designed. The
> global rstat lock has always existed and was always available to
> userspace readers. The memory controller took a different path at some
> point with unified flushing, but that was mainly because of high
> concurrency from in-kernel flushers, not because userspace readers
> caused a problem. Outside of memcg, the core cgroup code has always
> exercised this global lock when reading cpu.stat since rstat's
> introduction. I assume there hasn't been any problems since it's still
> there. I was hoping Tejun would confirm/deny this.

One thing we can do to remedy this situation is to replace the global
rstat lock with a mutex, and drop the resched/lock dropping condition.
Tejun suggested this in the previous thread. This effectively reverts
0fa294fb1985 ("cgroup: Replace cgroup_rstat_mutex with a spinlock")
since now all the flushing contexts are sleepable.

My synthetic stress test does not show any regressions with mutexes,
and there is a small boost to reading latency (probably because we
stop dropping the lock / rescheduling). Not sure if we may start
seeing need_resched warnings on big flushes though.

One other concern that Shakeel pointed out to me is preemption. If
someone holding the mutex gets preempted this may starve other
waiters. We can disable preemption while we hold the mutex, not sure
if that's a common pattern though.
