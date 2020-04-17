From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Fri, 17 Apr 2020 09:11:33 -0700
Message-ID: <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
References: <20200417010617.927266-1-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c1APeQIZSwYvgzGtI49u613t4lCqukuDkbPUvWkvPzU=;
        b=ThYKyseGRAxgJFZMUU4L4u54kmHxMZkY8P61z911368jzyeY/e9JAfj8tF2wCkj6bA
         V5ZduIWFzynFO88OwEbWxf1JjarT+nqTzButGm04VyflH+r9Ibs22c7zQFOCl29NhUP+
         6mL1TkTeUxBY9Ifi3JreaImUiuqjAcM2j0HdBQxnr+ggLD+6Y/gO+PXQsc25/Bu5zTir
         mtlHksZ3pCs3gTsN1zuxUHgTZ+LTvYuY5D0UkbrML+Oqx56cP8qPYsHh+w1C5u5R7jFV
         DqPtL7fhjmjx5VfGf9JIqqDMx5KZwBJUp60FWDviwDPbWVNroD/VGG/oNusPZ+fsQ0vD
         vEJg==
In-Reply-To: <20200417010617.927266-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Apr 16, 2020 at 6:06 PM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Tejun describes the problem as follows:
>
> When swap runs out, there's an abrupt change in system behavior -
> the anonymous memory suddenly becomes unmanageable which readily
> breaks any sort of memory isolation and can bring down the whole
> system.

Can you please add more info on this abrupt change in system behavior
and what do you mean by anon memory becoming unmanageable?

Once the system is in global reclaim and doing swapping the memory
isolation is already broken. Here I am assuming you are talking about
memcg limit reclaim and memcg limits are overcommitted. Shouldn't
running out of swap will trigger the OOM earlier which should be
better than impacting the whole system.

> To avoid that, oomd [1] monitors free swap space and triggers
> kills when it drops below the specific threshold (e.g. 15%).
>
> While this works, it's far from ideal:
>  - Depending on IO performance and total swap size, a given
>    headroom might not be enough or too much.
>  - oomd has to monitor swap depletion in addition to the usual
>    pressure metrics and it currently doesn't consider memory.swap.max.
>
> Solve this by adapting the same approach that memory.high uses -
> slow down allocation as the resource gets depleted turning the
> depletion behavior from abrupt cliff one to gradual degradation
> observable through memory pressure metric.
>
> [1] https://github.com/facebookincubator/oomd
>
> Jakub Kicinski (3):
>   mm: prepare for swap over-high accounting and penalty calculation
>   mm: move penalty delay clamping out of calculate_high_delay()
>   mm: automatically penalize tasks with high swap use
>
>  include/linux/memcontrol.h |   4 +
>  mm/memcontrol.c            | 166 ++++++++++++++++++++++++++++---------
>  2 files changed, 131 insertions(+), 39 deletions(-)
>
> --
> 2.25.2
>
