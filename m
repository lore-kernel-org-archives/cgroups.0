From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Fri, 25 Aug 2023 11:21:16 -0700
Message-ID: <CAJD7tka=60_vPMY9Tg8tH+55g-feV1B24VNmDpp_3iMHqrUh7Q@mail.gmail.com>
References: <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz> <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz> <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz> <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz> <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOjwNR2wv5mOdWv0@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692987713; x=1693592513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nfk4Ajg9vZhcSJWkO4D5es2l67WvnVitf3sD+Mxoc/o=;
        b=eDIt+Z+t627KQ2EZuZm+87kajqqn1K0HU8KLFxdTLDCtD+wuMKjgaQ0qcwTIwSas49
         WVDEYaMECWylUXWij+/jZvNoA9yx94nlAFZ8gWNnKx8KwewXBrVeKKK0QX4ejzgIPAQf
         My1sCy+8zFZoDJZE7G08x+z+xA6WRPVttme9RirqimuSbFF6j9jfwyGfr54yrjgftsk4
         xbmtMURmQ8TxfI7sySNl8Va+n7TPBzz4u5b6jN4EGP9duBqU2b2DEnuCcanhLGxOp3pW
         77/h6WaPZTub5smuhLHICbRihdS/4AZopPwU7UN1pi4987SXBEhUn5Ng44/jEuYiINfx
         ugIw==
In-Reply-To: <ZOjwNR2wv5mOdWv0@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Aug 25, 2023 at 11:17=E2=80=AFAM Michal Hocko <mhocko@suse.com> wro=
te:
>
> On Fri 25-08-23 08:14:54, Yosry Ahmed wrote:
> > On Fri, Aug 25, 2023 at 12:05=E2=80=AFAM Michal Hocko <mhocko@suse.com>=
 wrote:
> [...]
> > > I might be wrong but the whole discussion so far suggests that the
> > > global rstat lock should be reconsidered. From my personal experience
> > > global locks easily triggerable from the userspace are just a receip =
for
> > > problems. Stats reading shouldn't be interfering with the system runt=
ime
> > > as much as possible and they should be deterministic wrt runtime as
> > > well.
> >
> > The problem is that the global lock also serializes the global
> > counters that we flush to. I will talk from the memcg flushing
> > perspective as that's what I am familiar with. I am not sure how much
> > this is transferable to other flushers.
> >
> > On the memcg side (see mem_cgroup_css_rstat_flush()), the global lock
> > synchronizes access to multiple counters, for this discussion what's
> > most important are:
> > - The global stat counters of the memcg being flushed (e.g.
> > memcg->vmstats->state).
> > - The pending stat counters of the parent being flushed (e.g.
> > parent->vmstats->state_pending).
>
> I haven't digested the rest of the email yet (Friday brain, sorry) but I
> do not think you are adressing this particular part so let me ask before
> I dive more into the following. I really do not follow the serialization
> requirement here because the lock doesn't really serialize the flushing,
> does it? At least not in a sense of a single caller to do the flushing
> atomicaly from other flushers. It is possible that the current flusher
> simply drops the lock midway and another one retakes the lock and
> performs the operation again. So what additional flushing
> synchronization does it provide and why cannot parallel flushers simply
> compete over pcp spinlocks?
>
> So what am I missing?

Those counters are non-atomic. The lock makes sure we don't have two
concurrent flushers updating the same counter locklessly and
non-atomically, which would be possible if we flush the same cgroup on
two different cpus in parallel.

> --
> Michal Hocko
> SUSE Labs
