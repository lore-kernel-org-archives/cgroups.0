From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/7] Introduce memory allocation speed throttle in memcg
Date: Wed, 26 May 2021 13:52:25 -0700
Message-ID: <CALvZod4SoCS6ym8ELTxWd6UwzUp8m_UUdw7oApAhW2WRq0BXqw@mail.gmail.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4rL4ZNue6Ljpbr80Um7+WtGuIj1VHDvK86mKdNmljQ=;
        b=sou9i15FmrPZqYAW4inB0oXUePHg0dRp+/RQm+k2ORf8kOWxRnW3uSS71J5nwMaBqy
         hQwrVYiPiha0h2fhKhCMQfklVYVgAvDFzKiH3OJ7eYfJOCjlA7yXPGZB3K6QokT2kDbE
         BaWSb6lnnvAEsw38nWWwbYGzjCNEgHmgtKm3rJIgiou4Av8AKKLfD706jIBaq1MJBUKY
         ewD3FlJtjbTCsOOIoDR6QHYJvjvMMPQlN5Tq1aWIdWifiHynqj6GwJmLEH4DCBa6Egsf
         y4tn2m1jfxW8EmFyHq6X1J03bsASNtdsmlS6BqBAvNJzfzK/bSYTX6lA0jqM2zKpeu3P
         531Q==
In-Reply-To: <cover.1622043596.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Adding linux-mm and related folks.



On Wed, May 26, 2021 at 9:18 AM <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>
> In this patch set we present the idea to suppress the memory allocation
> speed in memory cgroup, which aims to avoid direct reclaim caused by
> memory allocation burst while under memory pressure.
>

I am assuming here direct reclaim means global reclaim.

> As minimum watermark could be easily broken if certain tasks allocate
> massive amount of memory in a short period of time, in that case it will
> trigger the direct memory reclaim and cause unacceptable jitters for
> latency critical tasks, such as guaranteed pod task in K8s.
>
> With memory allocation speed throttle(mst) mechanism we could lower the
> memory allocation speed in certian cgroup, usually for low priority tasks,
> so that could avoid the direct memory reclaim in time.

Can you please explain why memory.high is not good enough for your
use-case? You can orchestrate the memory.high limits in such a way
that those certain cgroups hit their memory.high limit before causing
the global reclaim. You might need to dynamically adjust the limits
based on other workloads or unaccounted memory.

>
> And per-memcg interfaces are introduced under memcg tree, not visiable for
> root memcg.
> - <cgroup_root>/<cgroup_name>/memory.alloc_bps
>  - 0 -> means memory speed throttle disabled
>  - non-zero -> value in bytes for memory allocation speed limits
>
> - <cgroup_root>/<cgroup_name>/memory.stat:mst_mem_spd_max
>   it records the max memory allocation speed of the memory cgroup in the
>   last period of time slice
>
> - <cgroup_root>/<cgroup_name>/memory.stat:mst_nr_throttled
>   it represents the number of times for allocation throttling
>
> Yulei Zhang (7):
>   mm: record total charge and max speed counter in memcg
>   mm: introduce alloc_bps to memcg for memory allocation speed throttle
>   mm: memory allocation speed throttle setup in hierarchy
>   mm: introduce slice analysis into memory speed throttle mechanism
>   mm: introduce memory allocation speed throttle
>   mm: record the numbers of memory allocation throttle
>   mm: introduce mst low and min watermark
>
>  include/linux/memcontrol.h   |  23 +++
>  include/linux/page_counter.h |   8 +
>  init/Kconfig                 |   8 +
>  mm/memcontrol.c              | 295 +++++++++++++++++++++++++++++++++++
>  mm/page_counter.c            |  39 +++++
>  5 files changed, 373 insertions(+)
>
> --
> 2.28.0
>
