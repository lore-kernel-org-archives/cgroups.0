From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Wed, 6 Apr 2022 10:11:19 +0800
Message-ID: <CAGWkznG=QH3HRSzgum0sQBkyQAahqgiWf8nXCv1qXstxrn7e8w@mail.gmail.com>
References: <CAGWkznF7cSyPU0ceYwH6zweJzf-X1bQnS6AJ2-J+WEL0u8jzng@mail.gmail.com>
 <CAJuCfpHneDZMXO_MmQDPA+igAOdAPRUChiq+zftFXGfDzPHNhQ@mail.gmail.com>
 <CAGWkznFTQCm0cusVxA_55fu2WfT-w2coVHrT=JA1D_9_2728mQ@mail.gmail.com>
 <YkqxpEW4m6iU3zMq@dhcp22.suse.cz> <CAGWkznG4L3w=9bpZp8TjyWHmqFyZQk-3m4xCZ96zhHCLPawBgQ@mail.gmail.com>
 <CAGWkznGMRohE2_at4Qh8KbwSqNmNqOAG2N1EM+7uE9wKqzRm0A@mail.gmail.com>
 <Ykq7KUleuAg5QnNU@dhcp22.suse.cz> <CAGWkznGbd5TOTHZE8uUhak3SnHqEWx_9QCJVtUFUSg9rk3xYEQ@mail.gmail.com>
 <Ykrkx4JML4c81gBV@dhcp22.suse.cz> <CAGWkznEaEavCz9GeiYuTqsox2qZK43iQKevt8njkzaHv6KiW-A@mail.gmail.com>
 <YkwxNaJIg6ptJOYT@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wf8pQwHnRNmaHjWr1ZOvrwWsnNuIT93e+BIdPY7Vuuo=;
        b=eR2P6EjBqwGm0I3XlightluFGFW6/4Q1Fk0IBFVv0J7whG/+EutaNF17I/sCk8/LEf
         JkTfcbbNvUq52C1a5meMMepcUHtv/+Y3VUv4b4qaz+VXEQshKicKgiNOzSNV+CRAZotn
         ydZwRQKutAFaqxcZem8W/v46M/8z998iLTS2BguFC0O7aE4d7u6pC4J1nxyntWDQlgzu
         9/2x6HcSRhN3lEc5TW3hexP8tzYak8NdWbYTPUUowbw2PGXJe4x0J2dfZpCsMrmmAoBc
         gc96Y2Eu3GR0Y3I8E8r2dfVQTP2SJct6y2F5NnnR6aMK8wq6UnA0xDVBbs9bnYbRPvP1
         bsPQ==
In-Reply-To: <YkwxNaJIg6ptJOYT-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 5, 2022 at 8:08 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 04-04-22 21:14:40, Zhaoyang Huang wrote:
> [...]
> > Please be noticed that this patch DOES protect the memcg when external
> > pressure is 1GB as fixed low does.
>
> This is getting more and more confusing (at least to me). Could you
> describe the behavior of the reclaim for the following setups/situations?
>
> a) mostly reclaiming a clean page cache - via kswapd
> b) same as above but the direct reclaim is necessary but very
>    lightweight
> c) direct reclaim makes fwd progress but not enough to satisfy the
>    allocation request (so the reclaim has to be retried)
> d) direct reclaim not making progress and low limit protection is
>    ignored.
>
> Say we have several memcgs and only some have low memory protection
> configured. What is the user observable state of the protected group and
> when and how much the protection can be updated?
I am not sure if I understand you right. Do you have suspicions on the
test result as you think protected memcg has no chance to update the
protection or the global reclaim should have been satisfied with the
reclaiming(step d is hard to reach?). Let me try to answer it under my
understanding, please give me feedback if you need more info. The
protection is updated while mem_cgroup_calculate_protection is called
during either kswapd or direct reclaim for each round of the priority
reclaiming and then the memcg's lruvec will be reached in step d.
>
> I think it would be also helpful to describe the high level semantic of
> this feature.
>
> > Besides, how does the admin decide
> > the exact number of low/min if it expand from small to even xGB in a
> > quick changing scenario?
>
> This is not really related, is it? There are different ways to tune for
> the protection.
I don't think so. IMO, it is hard to protect when memcg has a wide and
random range of its usage especially when depending on scenarios. Does
the example of EAS on scheduler make more sense? When comparing with
the legacy CFS, EAS does be against to some original design as load
balance etc, while it will keep some small tasks into one CORE.
>
> [...]
> --
> Michal Hocko
> SUSE Labs
