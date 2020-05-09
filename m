From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: expose root cgroup's memory.stat
Date: Sat, 9 May 2020 07:06:38 -0700
Message-ID: <CALvZod5VHHUV+_AXs4+5sLOPGyxm709kQ1q=uHMPVxW8pwXZ=g@mail.gmail.com>
References: <20200508170630.94406-1-shakeelb@google.com> <20200508214405.GA226164@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i3sW6gGxSFYLbQMqiE2OgOKIm35ARKyWWruHIK3w6PQ=;
        b=CPCRxhMfKQFuwDgy/ZmcW/xhfqV9MdzE0YYS6RcYSPljXI+g3UHNduR7qxy2YGhc02
         GoaSSHkPldIsQRT8xbeolWkO3usdS1kv3Dhxp0Ca4hBTTQrWvNsZJuNkYkZLVpuXFoB8
         oI8WDKM34ouq9Js46hM3qWS8zrhxK2DBmWc9mPr/tqH1XX5lNSnvx6Yvw+vTiuNiFV2U
         Z+p5NLf4IIdQ4G5rPcYJbwweK01tArCoId4O6qFw7jvLqx2MJ87hZaMXC9WrTuzzQAXY
         OdOS/3YRXvUFDzEYQlGiyGA/TdrvopOsFm+IJyLwCx+BAU+35ZByFSjxEAknOiwmj5Yv
         E+kA==
In-Reply-To: <20200508214405.GA226164-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 8, 2020 at 2:44 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Fri, May 08, 2020 at 10:06:30AM -0700, Shakeel Butt wrote:
> > One way to measure the efficiency of memory reclaim is to look at the
> > ratio (pgscan+pfrefill)/pgsteal. However at the moment these stats are
> > not updated consistently at the system level and the ratio of these are
> > not very meaningful. The pgsteal and pgscan are updated for only global
> > reclaim while pgrefill gets updated for global as well as cgroup
> > reclaim.
> >
> > Please note that this difference is only for system level vmstats. The
> > cgroup stats returned by memory.stat are actually consistent. The
> > cgroup's pgsteal contains number of reclaimed pages for global as well
> > as cgroup reclaim. So, one way to get the system level stats is to get
> > these stats from root's memory.stat, so, expose memory.stat for the root
> > cgroup.
> >
> >       from Johannes Weiner:
> >       There are subtle differences between /proc/vmstat and
> >       memory.stat, and cgroup-aware code that wants to watch the full
> >       hierarchy currently has to know about these intricacies and
> >       translate semantics back and forth.
> >
> >       Generally having the fully recursive memory.stat at the root
> >       level could help a broader range of usecases.
>
> The changelog begs the question why we don't just "fix" the
> system-level stats. It may be useful to include the conclusions from
> that discussion, and why there is value in keeping the stats this way.
>

Right. Andrew, can you please add the following para to the changelog?

Why not fix the stats by including both the global and cgroup reclaim
activity instead of exposing root cgroup's memory.stat? The reason is
the benefit of having metrics exposing the activity that happens
purely due to machine capacity rather than localized activity that
happens due to the limits throughout the cgroup tree. Additionally
there are userspace tools like sysstat(sar) which reads these stats to
inform about the system level reclaim activity. So, we should not
break such use-cases.

> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks a lot.
