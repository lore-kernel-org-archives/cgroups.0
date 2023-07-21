From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 17:07:14 -0700
Message-ID: <CAJD7tkYrF9OkfahXVqRMNo2-krrotjeY+Qp-pb9e1ebrFWS6PA@mail.gmail.com>
References: <20230720070825.992023-1-yosryahmed@google.com> <ZLnLDlQ/B81Qb9pj@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689898071; x=1690502871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OaecvBVf9Flq0C+mZ5QEkg9NA82UBvH6EXy41+0INrA=;
        b=faHYAA+C7baJNH4ty1xusZ1GAMizOuhswFoWstiefxPx5kIsdmuE9U8cUmQHhOeHrk
         5D0dko+MIjrr37VaAnnddqI178VcnobmLffPqhhTmjyA/ZJqzxsB9P3o3tXGl1KOXupN
         41KeL8AVmEyVjcLgywZInS05YyxV5osfdNAJfDYZdF/xdJZRYucW4OPzDbbYhaIpxG+h
         Brosl06kzi75w9/BHG8kM7Porua9q9p8IGdBTIMIO5EoUvyy8aXd9EGU6n3AVAUF8ezX
         36fwLy4GUQZnwDJwnTMrYZAckVf5TRZDItY9IV2nC9OuSWoD/25PQk0tp63E/TydQY1B
         YQ/Q==
In-Reply-To: <ZLnLDlQ/B81Qb9pj-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 20, 2023 at 5:02=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> On Thu, Jul 20, 2023 at 07:08:17AM +0000, Yosry Ahmed wrote:
> > This patch series implements the proposal in LSF/MM/BPF 2023 conference
> > for reducing offline/zombie memcgs by memory recharging [1]. The main
> > difference is that this series focuses on recharging and does not
> > include eviction of any memory charged to offline memcgs.
> >
> > Two methods of recharging are proposed:
> >
> > (a) Recharging of mapped folios.
> >
> > When a memcg is offlined, queue an asynchronous worker that will walk
> > the lruvec of the offline memcg and try to recharge any mapped folios t=
o
> > the memcg of one of the processes mapping the folio. The main assumptio=
n
> > is that a process mapping the folio is the "rightful" owner of the
> > memory.
> >
> > Currently, this is only supported for evictable folios, as the
> > unevictable lru is imaginary and we cannot iterate the folios on it. A
> > separate proposal [2] was made to revive the unevictable lru, which
> > would allow recharging of unevictable folios.
> >
> > (b) Deferred recharging of folios.
> >
> > For folios that are unmapped, or mapped but we fail to recharge them
> > with (a), we rely on deferred recharging. Simply put, any time a folio
> > is accessed or dirtied by a userspace process, and that folio is charge=
d
> > to an offline memcg, we will try to recharge it to the memcg of the
> > process accessing the folio. Again, we assume this process should be th=
e
> > "rightful" owner of the memory. This is also done asynchronously to avo=
id
> > slowing down the data access path.
>
> Unfortunately I have to agree with Johannes, Tejun and others who are not=
 big
> fans of this approach.
>
> Lazy recharging leads to an interesting phenomena: a memory usage of a ru=
nning
> workload may suddenly go up only because some other workload is terminate=
d and
> now it's memory is being recharged. I find it confusing. It also makes ha=
rd
> to set up limits and/or guarantees.

This can happen today.

If memcg A starts accessing some memory and gets charged for it, and
then memcg B also accesses it, it will not be charged for it. If at a
later point memcg A runs into reclaim, and the memory is freed, then
memcg B tries to access it, its usage will suddenly go up as well,
because some other workload experienced reclaim. This is a very
similar scenario, only instead of reclaim, the memcg was offlined. As
a matter of fact, it's common to try to free up a memcg before
removing it (by lowering the limit or using memory.reclaim). In that
case, the net result would be exactly the same -- with the difference
being that recharging will avoid freeing the memory and faulting it
back in.

>
> In general, I don't think we can handle shared memory well without gettin=
g rid
> of "whoever allocates a page, pays the full price" policy and making a sh=
ared
> ownership a fully supported concept. Of course, it's a huge work and I be=
lieve
> the only way we can achieve it is to compromise on the granularity of the
> accounting. Will the resulting system be better in the real life, it's ha=
rd to
> say in advance.
>
> Thanks!
