From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Thu, 7 Apr 2022 09:40:22 +0200
Message-ID: <Yk6VZlGnB48RqnYW@dhcp22.suse.cz>
References: <CAGWkznFTQCm0cusVxA_55fu2WfT-w2coVHrT=JA1D_9_2728mQ@mail.gmail.com>
 <YkqxpEW4m6iU3zMq@dhcp22.suse.cz>
 <CAGWkznG4L3w=9bpZp8TjyWHmqFyZQk-3m4xCZ96zhHCLPawBgQ@mail.gmail.com>
 <CAGWkznGMRohE2_at4Qh8KbwSqNmNqOAG2N1EM+7uE9wKqzRm0A@mail.gmail.com>
 <Ykq7KUleuAg5QnNU@dhcp22.suse.cz>
 <CAGWkznGbd5TOTHZE8uUhak3SnHqEWx_9QCJVtUFUSg9rk3xYEQ@mail.gmail.com>
 <Ykrkx4JML4c81gBV@dhcp22.suse.cz>
 <CAGWkznEaEavCz9GeiYuTqsox2qZK43iQKevt8njkzaHv6KiW-A@mail.gmail.com>
 <YkwxNaJIg6ptJOYT@dhcp22.suse.cz>
 <CAGWkznG=QH3HRSzgum0sQBkyQAahqgiWf8nXCv1qXstxrn7e8w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649317223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7tdKrRRhBcgriuTuifhqw7ASOmfz1N4EF+9FSFvKM0E=;
        b=r6Fua2gzlgwm1Hp5y5shaiTcDw1GVtrXgPXQb3p55UEWWygcN+jDp11/05+NYmm1vYKIPm
        7lKd36aXjuqVnfrCXhRi1YOIr/f0RG7VdejwUm/BA3RtBxq+NH8LIxlM76mVrvdJ9L4eTi
        qlUYyggclZvcVPbb3HDCBf6Y35i3cPo=
Content-Disposition: inline
In-Reply-To: <CAGWkznG=QH3HRSzgum0sQBkyQAahqgiWf8nXCv1qXstxrn7e8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Wed 06-04-22 10:11:19, Zhaoyang Huang wrote:
> On Tue, Apr 5, 2022 at 8:08 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Mon 04-04-22 21:14:40, Zhaoyang Huang wrote:
> > [...]
> > > Please be noticed that this patch DOES protect the memcg when external
> > > pressure is 1GB as fixed low does.
> >
> > This is getting more and more confusing (at least to me). Could you
> > describe the behavior of the reclaim for the following setups/situations?
> >
> > a) mostly reclaiming a clean page cache - via kswapd
> > b) same as above but the direct reclaim is necessary but very
> >    lightweight
> > c) direct reclaim makes fwd progress but not enough to satisfy the
> >    allocation request (so the reclaim has to be retried)
> > d) direct reclaim not making progress and low limit protection is
> >    ignored.
> >
> > Say we have several memcgs and only some have low memory protection
> > configured. What is the user observable state of the protected group and
> > when and how much the protection can be updated?
> I am not sure if I understand you right. Do you have suspicions on the
> test result as you think protected memcg has no chance to update the
> protection or the global reclaim should have been satisfied with the
> reclaiming(step d is hard to reach?). Let me try to answer it under my
> understanding, please give me feedback if you need more info. The
> protection is updated while mem_cgroup_calculate_protection is called
> during either kswapd or direct reclaim for each round of the priority
> reclaiming and then the memcg's lruvec will be reached in step d.

This means that limits are altered even if there is memory to be
reclaimed from other memcgs. Why? How does this line up with the
basic property of the low limit to act as a protection from the reclaim?

> > I think it would be also helpful to describe the high level semantic of
> > this feature.

Please focus on this part. Without a high level semantic explained we
will not move forward.
-- 
Michal Hocko
SUSE Labs
