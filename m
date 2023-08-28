From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 28 Aug 2023 10:00:21 -0700
Message-ID: <CALvZod7uxDd3Lrd3VwTTC-SDvqhdj2Ly-dYVswO=TBM=XTnkcg@mail.gmail.com>
References: <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz> <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz> <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz> <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz> <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz> <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693242034; x=1693846834; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PvhYL8hBy4EhCScbuINCvu74ArNIyYfg31Et1gNQXGg=;
        b=vvTz0ai8HUIA+vLkOnfvPV4GJ+rvtQg66soouQp/qVbyTNcEWLGOOatIH9UcVq9TOP
         BE4gT/LLv9MGa/TGbqN3HewTBeffDFuZBmENMkrrtFhTk1nfNKw9BFtslefvHxEUodld
         ZMEx81BVZOrp1cqk8cRjTM3uKlNcX/Xofy4o/3dIMDCkRMfSEmMzckYofGd6rK7Yu18G
         ge/axaAZGem1x4F1Mx7NlrvpVNYbJhK6FWbrQrSsGP4oFkzd6MjUGRHYpXyaz9vhkPwU
         kJr5ioWc09dzPgJWoHVpeu6BRnMe0UDndMDsDDNBnWKlmfU7p2J8lRCkAsD3vvfJ/9uC
         WrHg==
In-Reply-To: <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 28, 2023 at 9:15=E2=80=AFAM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
[...]
> >
> > Well, I really have to say that I do not like the notion that reading
> > stats is unpredictable. This just makes it really hard to use. If
> > the precision is to be sarificed then this should be preferable over
> > potentially high global lock contention. We already have that model in
> > place of /proc/vmstat (configurable timeout for flusher and a way to
> > flush explicitly). I appreciate you would like to have a better
> > precision but as you have explored the locking is really hard to get ri=
d
> > of here.
>
> Reading the stats *is* unpredictable today. In terms of
> accuracy/staleness and cost. Avoiding the flush entirely on the read
> path will surely make the cost very stable and cheap, but will make
> accuracy even less predictable.
>

On average you would get the stats at most 2 second old, so I would
not say it is less predictable.

> >
> > So from my POV I would prefer to avoid flushing from the stats reading
> > path and implement force flushing by writing to stat file. If the 2s
> > flushing interval is considered to coarse I would be OK to allow settin=
g
> > it from userspace. This way this would be more in line with /proc/vmsta=
t
> > which seems to be working quite well.
> >
> > If this is not accaptable or deemed a wrong approach long term then it
> > would be good to reonsider the current cgroup_rstat_lock at least.
> > Either by turning it into mutex or by dropping the yielding code which
> > can severly affect the worst case latency AFAIU.
>
> Honestly I think it's better if we do it the other way around. We make
> flushing on the stats reading path non-unified and deterministic. That
> model also exists and is used for cpu.stat. If we find a problem with
> the locking being held from userspace, we can then remove flushing
> from the read path and add interface(s) to configure the periodic
> flusher and do a force flush.
>

Here I agree with you. Let's go with the approach which is easy to
undo for now. Though I prefer the new explicit interface for flushing,
that step would be very hard to undo. Let's reevaluate if the proposed
approach shows negative impact on production traffic and I think
Cloudflare folks can give us the results soon.
