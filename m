From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 7/8] mm: memcontrol: consolidate lruvec stat flushing
Date: Mon, 8 Feb 2021 15:54:14 -0500
Message-ID: <YCGk9ksAU8+tBv5y@cmpxchg.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
 <20210205182806.17220-8-hannes@cmpxchg.org>
 <CALvZod4ex5V2Xs_6YHmmLJw91rjKTSZ9XobXiRx4ftj=L=A6MA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WcpftL0I3Yn/sC6LOBOo9QXXxpF9jls61Dh3UGgrMhQ=;
        b=XGEs+1RNC81c2udolSMD/41WbwHBvqroEIblFLM6gl9MVclTdONeCq1jP0jJVv3DW7
         dqvBGlfkyGoSaJOFPO4C+/KygXrMmF6GgeZV38oFelwD8bYgQ4Y9FaDxTNylaeEkxhxN
         9/wMWF5GLFfZLkCkBzWMoFr2YsBTvzztvlTODSSdkywa0ZqSPz7MMES7R4ORrBwmRXAa
         inRSRsCQhcz07fMpBpDsQUbvvWjmpmN/ObDNeouvOi73LV0BXKKTABmritwmYEUUmzuj
         N6MX+1gkgsjC7cBc8+SIZf6tPoSoD/WIgebrPDZfgKnsLOKOtM1fzFUShy4hNgpDqfjO
         8aOQ==
Content-Disposition: inline
In-Reply-To: <CALvZod4ex5V2Xs_6YHmmLJw91rjKTSZ9XobXiRx4ftj=L=A6MA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Sun, Feb 07, 2021 at 06:28:37PM -0800, Shakeel Butt wrote:
> On Fri, Feb 5, 2021 at 10:28 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > There are two functions to flush the per-cpu data of an lruvec into
> > the rest of the cgroup tree: when the cgroup is being freed, and when
> > a CPU disappears during hotplug. The difference is whether all CPUs or
> > just one is being collected, but the rest of the flushing code is the
> > same. Merge them into one function and share the common code.
> >
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks!

> BTW what about the lruvec stats? Why not convert them to rstat as well?

Great question.

I actually started this series with the lruvec stats included, but I'm
worried about the readers being too hot to use rstat (in its current
shape, at least). For example, the refault code accesses the lruvec
stats for every page that is refaulting - at the root level, in case
of global reclaim. With an active workload, that would result in a
very high rate of whole-tree flushes.

We probably do need a better solution for the lruvecs as well, but in
this case it just started holding up fixing the memory.stat issue for
no reason and so I tabled it for another patch series.
