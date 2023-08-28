From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 28 Aug 2023 09:15:04 -0700
Message-ID: <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
References: <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz> <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz> <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz> <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz> <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693239341; x=1693844141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afndblcX2lRDuYfUApnBPqsi2v65E21M+ezFScH4A9I=;
        b=z9hy+WFbV3mqJF5+e6G+9u318/zbHUxgPF7+6+RgQPVzS2F5Y8Bz0h2q8ekbD5EBSf
         3emje4+dmIqG2khkmT56tknzwt2pJK9F5mUEBE1sRZqjj4NoKg1RIMx1tMK/OatzB47d
         myhHtFxWRnoQX7/L26zjMrpg118ISAL9x21YlZJg+AuLaeVErL1X/bQheZkJUhNp+o26
         W0+oN1sA/CLo6UgAX6spklh9+MAMtebMFNvwI0vI801GXMOn1XvB5k/7E0EWQFbAkupP
         0xLP96B2UJ+NjPvLpb1tylYlizIBbIEOFofWuZi6xRkuy1C2JgwPw6fASZILjuvpW2M3
         zaeQ==
In-Reply-To: <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 28, 2023 at 8:47=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> Done my homework and studied the rstat code more (sorry should have done
> that earlier).
>
> On Fri 25-08-23 08:14:54, Yosry Ahmed wrote:
> [...]
> > I guess what I am trying to say is, breaking down that lock is a major
> > surgery that might require re-designing or re-implementing some parts
> > of rstat. I would be extremely happy to be proven wrong. If we can
> > break down that lock then there is no need for unified flushing even
> > for in-kernel contexts, and we can all live happily ever after with
> > cheap(ish) and accurate stats flushing.
>
> Yes, this seems like a big change and also over complicating the whole
> thing. I am not sure this is worth it.
>
> > I really hope we can move forward with the problems at hand (sometimes
> > reads are expensive, sometimes reads are stale), and not block fixing
> > them until we can come up with an alternative to that global lock
> > (unless, of course, there is a simpler way of doing that).
>
> Well, I really have to say that I do not like the notion that reading
> stats is unpredictable. This just makes it really hard to use. If
> the precision is to be sarificed then this should be preferable over
> potentially high global lock contention. We already have that model in
> place of /proc/vmstat (configurable timeout for flusher and a way to
> flush explicitly). I appreciate you would like to have a better
> precision but as you have explored the locking is really hard to get rid
> of here.

Reading the stats *is* unpredictable today. In terms of
accuracy/staleness and cost. Avoiding the flush entirely on the read
path will surely make the cost very stable and cheap, but will make
accuracy even less predictable.

>
> So from my POV I would prefer to avoid flushing from the stats reading
> path and implement force flushing by writing to stat file. If the 2s
> flushing interval is considered to coarse I would be OK to allow setting
> it from userspace. This way this would be more in line with /proc/vmstat
> which seems to be working quite well.
>
> If this is not accaptable or deemed a wrong approach long term then it
> would be good to reonsider the current cgroup_rstat_lock at least.
> Either by turning it into mutex or by dropping the yielding code which
> can severly affect the worst case latency AFAIU.

Honestly I think it's better if we do it the other way around. We make
flushing on the stats reading path non-unified and deterministic. That
model also exists and is used for cpu.stat. If we find a problem with
the locking being held from userspace, we can then remove flushing
from the read path and add interface(s) to configure the periodic
flusher and do a force flush.

I would like to avoid introducing additional interfaces and
configuration knobs unless it's necessary. Also, if we remove the
flush entirely the cost will become really cheap. We will have a hard
time reversing that in the future if we want to change the
implementation.

IOW, moving forward with this change seems much more reversible than
adopting the /proc/vmstat model.

If using a mutex will make things better, we can do that now. It
doesn't introduce performance issues in my testing. My only concern is
someone sleeping or getting preempted while holding the mutex, so I
would prefer disabling preemption while we flush if that doesn't cause
problems.

Thanks!
