From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Wed, 6 Apr 2022 16:21:07 +0800
Message-ID: <CAGWkznEfT7qZbhjCUPHnAxSsYp3Rxm-RzEnWj4TQRO5B3fLvOQ@mail.gmail.com>
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
        bh=AFWezyJlqZ77VORHX3U0GwJuhQRt/uhTxdefuNmt42Q=;
        b=UdajeAwz5lRZFRXbxD0b6WdicDco/5iM+47a7VFFMBjwCmLgcEiDJIg7nWDLO+ji2k
         CkNHMl6aooBimIBDkw/xp6u2yjv2xEGsx/+kzbYrNShkzRVLJwOLOsVjqzHpMfixnZl0
         4cO/49izpHp3ca9V5F8qjww8XY3WRZZdDjbY1cVxZQ6PVn0vDIhLZbqfkykB9fzQOIBS
         KLpAKeY80xO37Hxbxzf4fCFAt1qxkfTvaCNHYh7wyNmpF0A4E3DVm5LVNtc9F0CaxlME
         /pd/fLotihhQ0LroBEuHJKYI64RmS2669IZmn3bOJWVpyEvNOfNmQwixkMW+TcsM65/G
         tUZA==
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
Ok. I guess you doubt why the external reclaiming on global LRU or
other unprotected memcg does not satisfy the requirement and have the
protected memcg have to face reclaim? According to my experience, this
is common for a large number of malloc from userspace OR high order
alloc_pages within the kernel. I have retested the previous case by
removing mlock and get the trend of result is same, where the pages on
global LRU could help to push some of the global memory pressure back
to global LRU and finally reach the protected memcg.
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
>
> [...]
> --
> Michal Hocko
> SUSE Labs
