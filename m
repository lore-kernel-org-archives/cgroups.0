From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Fri, 6 May 2022 07:24:51 +0900
Message-ID: <CABCjUKAoTmqvyBbFH7A188s8Hwi1XbLgfb6znzgFOuRWBMBxig@mail.gmail.com>
References: <20220427160016.144237-1-hannes@cmpxchg.org> <20220427160016.144237-5-hannes@cmpxchg.org>
 <Ymmnrkn0mSWcuvmH@google.com> <YmmznQ8AO5RLxicA@cmpxchg.org>
 <Ymm3WpvJWby4gaD/@cmpxchg.org> <CALvZod5LBi5V6q1uHUTSNnLz64HbD499a+OZvdYsUcmcWSt8Jg@mail.gmail.com>
 <YmqmWPrIagEEceN1@cmpxchg.org> <CALvZod7wOyXpA3pycM2dav9_F9sW5ezC84or-75u8GdQyu30nw@mail.gmail.com>
 <CAHbLzkqOUkaud4hQZeAbnO3T6VJpku4aKn1EYv9RunB+Kmu9Sg@mail.gmail.com> <CALvZod5CReJZeGxkX9i6k7+R+3kF5dikXx9akbiP_L0j4Qu=6A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZTU61zGXmWFiJ96Frh3Jz27MZBWaPQRzBHvvGIgt+qo=;
        b=QZRowjxdyK3cW28/2AurA6uZk0guOaXUobYrDQoZCXWjvLQ/UqqjkspA5cq5vJ+lmO
         +3VbOyg8tu+9HHC1yNMS9fsG78gc0LDsxRKGKuxDPRLFtxvfi6CwNOqKaTu2udwfQwkv
         kR9lBSbM5k/K8gXDLSshvj7HkXa/BzC0t91oaM4geJKTL/jxwdmyKz/neojgz/Uo6xaw
         AOiiQ8YF0qfzCUU3y/7/icQ5tkmKsKoBTJn5cIyN71HYj/JFEs9X81LOQVThWl5uXnKb
         3HnpMtxMR/nY9nHCaG3a0wOMj9PnPQKa4DCx8yQwXiLEURUhuk9+smXGAN7Fyv6N/LU0
         tzvw==
In-Reply-To: <CALvZod5CReJZeGxkX9i6k7+R+3kF5dikXx9akbiP_L0j4Qu=6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Fri, May 6, 2022 at 4:33 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, Apr 28, 2022 at 9:54 AM Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> [...]
> > > Yes, we have some modifications to zswap to make it work without any
> > > backing real swap. Though there is a future plan to move to zram
> > > eventually.
> >
> > Interesting, if so why not just simply use zram?
> >
>
> Historical reasons. When we started trying out the zswap, I think zram
> was still in staging or not stable enough (Suleiman can give a better
> answer).

One of the reasons we chose zswap instead of zram is that zswap can
reject pages.
Also, we wanted to have per-memcg pools, which zswap made much easier to do.

-- Suleiman
