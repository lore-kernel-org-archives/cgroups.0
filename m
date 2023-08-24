From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Thu, 24 Aug 2023 11:15:46 -0700
Message-ID: <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-4-yosryahmed@google.com> <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
 <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz> <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692900983; x=1693505783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7V339yE8bPMm+KmAAdyGZ6ExwOtcmP76lDiycvZ+QhM=;
        b=P7byTXhX2Ze5Ua+2lm2QhtKtc3P56x6cahDM1celc3QwjF0+Ix+nBD+S1+b0WJDZCI
         6IxZTNq5SGvVmyLTnhZ8Bo1bXlPtpi7L/5qqwTm0JgNJJxJmI8jfnwNCEIB6gnl1srAD
         tNC/V8X0CKXn4FEpmR2LSJeRRvVvKMDXOH9IWAGqEYCCyY9tIALrfOlZHSbRgHOaIqPm
         WeWyljfyHCv8gpRcPCZV5ImGaxPPJyqn8uSXCGLdjtXxtYRmprRbyyI+qBrAvmt8lqmg
         Qwyss28dCn8v2XA2KpRopKuaZuXDNde1+NZ+p6/slJ6Lluyf6LCArRlnwV0XKXMAPKrS
         Pong==
In-Reply-To: <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 24, 2023 at 12:13=E2=80=AFAM Michal Hocko <mhocko@suse.com> wro=
te:
>
> On Wed 23-08-23 07:55:40, Yosry Ahmed wrote:
> > On Wed, Aug 23, 2023 at 12:33=E2=80=AFAM Michal Hocko <mhocko@suse.com>=
 wrote:
> > >
> > > On Tue 22-08-23 08:30:05, Yosry Ahmed wrote:
> > > > On Tue, Aug 22, 2023 at 2:06=E2=80=AFAM Michal Hocko <mhocko@suse.c=
om> wrote:
> > > > >
> > > > > On Mon 21-08-23 20:54:58, Yosry Ahmed wrote:
> > > [...]
> > > > So to answer your question, I don't think a random user can really
> > > > affect the system in a significant way by constantly flushing. In
> > > > fact, in the test script (which I am now attaching, in case you're
> > > > interested), there are hundreds of threads that are reading stats o=
f
> > > > different cgroups every 1s, and I don't see any negative effects on
> > > > in-kernel flushers in this case (reclaimers).
> > >
> > > I suspect you have missed my point.
> >
> > I suspect you are right :)
> >
> >
> > > Maybe I am just misunderstanding
> > > the code but it seems to me that the lock dropping inside
> > > cgroup_rstat_flush_locked effectivelly allows unbounded number of
> > > contenders which is really dangerous when it is triggerable from the
> > > userspace. The number of spinners at a moment is always bound by the
> > > number CPUs but depending on timing many potential spinners might be
> > > cond_rescheded and the worst time latency to complete can be really
> > > high. Makes more sense?
> >
> > I think I understand better now. So basically because we might drop
> > the lock and resched, there can be nr_cpus spinners + other spinners
> > that are currently scheduled away, so these will need to wait to be
> > scheduled and then start spinning on the lock. This may happen for one
> > reader multiple times during its read, which is what can cause a high
> > worst case latency.
> >
> > I hope I understood you correctly this time. Did I?
>
> Yes. I would just add that this could also influence the worst case
> latency for a different reader - so an adversary user can stall others.

I can add that for v2 to the commit log, thanks.

> Exposing a shared global lock in uncontrolable way over generally
> available user interface is not really a great idea IMHO.

I think that's how it was always meant to be when it was designed. The
global rstat lock has always existed and was always available to
userspace readers. The memory controller took a different path at some
point with unified flushing, but that was mainly because of high
concurrency from in-kernel flushers, not because userspace readers
caused a problem. Outside of memcg, the core cgroup code has always
exercised this global lock when reading cpu.stat since rstat's
introduction. I assume there hasn't been any problems since it's still
there. I was hoping Tejun would confirm/deny this.
