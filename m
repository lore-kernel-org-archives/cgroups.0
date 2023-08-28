From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 28 Aug 2023 10:07:48 -0700
Message-ID: <CAJD7tkbnvMCNfQwY_dmVe2SWR5NeN+3RzFhsVyimM1ATaX0D5A@mail.gmail.com>
References: <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz> <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz> <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz> <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz> <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz> <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
 <CALvZod7uxDd3Lrd3VwTTC-SDvqhdj2Ly-dYVswO=TBM=XTnkcg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693242505; x=1693847305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgmSxEVlzi5fMkwnrM8LhIHtQEbm/jAUKGlrVKGkYss=;
        b=iFiaXdvNyP/PGupmYZQ4VDhihu4roD+VOTAYUOk648A8zr/NnetU0xeTBrkoG+AsPR
         2wxI9+4xAQyl3Xxl94EeAyF+UIHsPMJF7wGK0pCn3gzC4W2F4540PibPlUl5Zn6MTaR2
         o9vymucc9ynm4RNh82v145GN+bLsUwc0gP3U/tWXkGAjscoX/fm2tFx7pnKGjTA5r+bw
         1SR9g8zkzT/uibLlIedBK0SvUKoCFVbB3i1kaLcB1K4BYwKWqBKKzLSRxsgdcTYodIoi
         FusqkfeL0/iUTIn/J+n7J3p1yNB/tRDgBAeMhHmPuu5uQZq3RL4xZ0uTD5pWqvRs5dNW
         PSjw==
In-Reply-To: <CALvZod7uxDd3Lrd3VwTTC-SDvqhdj2Ly-dYVswO=TBM=XTnkcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 28, 2023 at 10:00=E2=80=AFAM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> On Mon, Aug 28, 2023 at 9:15=E2=80=AFAM Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >
> [...]
> > >
> > > Well, I really have to say that I do not like the notion that reading
> > > stats is unpredictable. This just makes it really hard to use. If
> > > the precision is to be sarificed then this should be preferable over
> > > potentially high global lock contention. We already have that model i=
n
> > > place of /proc/vmstat (configurable timeout for flusher and a way to
> > > flush explicitly). I appreciate you would like to have a better
> > > precision but as you have explored the locking is really hard to get =
rid
> > > of here.
> >
> > Reading the stats *is* unpredictable today. In terms of
> > accuracy/staleness and cost. Avoiding the flush entirely on the read
> > path will surely make the cost very stable and cheap, but will make
> > accuracy even less predictable.
> >
>
> On average you would get the stats at most 2 second old, so I would
> not say it is less predictable.
>
> > >
> > > So from my POV I would prefer to avoid flushing from the stats readin=
g
> > > path and implement force flushing by writing to stat file. If the 2s
> > > flushing interval is considered to coarse I would be OK to allow sett=
ing
> > > it from userspace. This way this would be more in line with /proc/vms=
tat
> > > which seems to be working quite well.
> > >
> > > If this is not accaptable or deemed a wrong approach long term then i=
t
> > > would be good to reonsider the current cgroup_rstat_lock at least.
> > > Either by turning it into mutex or by dropping the yielding code whic=
h
> > > can severly affect the worst case latency AFAIU.
> >
> > Honestly I think it's better if we do it the other way around. We make
> > flushing on the stats reading path non-unified and deterministic. That
> > model also exists and is used for cpu.stat. If we find a problem with
> > the locking being held from userspace, we can then remove flushing
> > from the read path and add interface(s) to configure the periodic
> > flusher and do a force flush.
> >
>
> Here I agree with you. Let's go with the approach which is easy to
> undo for now. Though I prefer the new explicit interface for flushing,
> that step would be very hard to undo. Let's reevaluate if the proposed
> approach shows negative impact on production traffic and I think
> Cloudflare folks can give us the results soon.

Do you prefer we also switch to using a mutex (with preemption
disabled) to avoid the scenario Michal described where flushers give
up the lock and sleep resulting in an unbounded wait time in the worst
case?
