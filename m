From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Thu, 5 May 2022 12:30:29 -0700
Message-ID: <CALvZod7_5CNjMqEo_SseW7VoVW9gRC8ZoVy=f9SAOL4+-1jR4A@mail.gmail.com>
References: <20220427160016.144237-1-hannes@cmpxchg.org> <20220427160016.144237-5-hannes@cmpxchg.org>
 <Ymmnrkn0mSWcuvmH@google.com> <YmmznQ8AO5RLxicA@cmpxchg.org>
 <Ymm3WpvJWby4gaD/@cmpxchg.org> <CALvZod5LBi5V6q1uHUTSNnLz64HbD499a+OZvdYsUcmcWSt8Jg@mail.gmail.com>
 <YmqmWPrIagEEceN1@cmpxchg.org> <CALvZod7wOyXpA3pycM2dav9_F9sW5ezC84or-75u8GdQyu30nw@mail.gmail.com>
 <Ymqv25+8IX2wqKzu@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gLvYPio/y1Rsy8ZWzpMgmaTLG4G8yUQ5M+BgkCxtwtA=;
        b=XQIzSd9nao1kbun84GbUFcH2P6yyzDFG+N0A2uCHmVBYC8oODM70pXR7xtStMpfyc5
         mtLLHkk0xuZbqCU7Z5wfpn1V3VrJczJhfpGwyYX1NsIjuxhnx3cpVEjvnU072DQm7TsC
         gFykdkxKL30lcwxhTxXlO00viowVHb31o4Z2Loba1USEpkQpfNxxSXoUolf1lg7eK28D
         gU4oWX58uS9Uc4wMyy34HH3NIIDZng79hu94xSbuNXAA5Q+YGYbWkVR7CXkiOn3GfgBN
         5WSfh48VFtwZ0Z7T/OV4fH9LnOoWTy+y8fK8buNSTDzi/szVTBJSmmRLPwFRFH2lKvwh
         WMhw==
In-Reply-To: <Ymqv25+8IX2wqKzu-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

+Yosry & Yuanchu

On Thu, Apr 28, 2022 at 8:17 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
[...]
> >
> > Yes, we have some modifications to zswap to make it work without any
> > backing real swap.
>
> Not sure if you can share them, but I would be interested in those
> changes. We have real backing swap, but because of the way swap
> entries are allocated, pages stored in zswap will consume physical
> disk slots. So on top of regular swap, you need to provision disk
> space for zswap as well, which is unfortunate.
>
> What could be useful is a separate swap entry address space that maps
> zswap slots and disk slots alike. This would fix the above problem. It
> would have the added benefit of making swapoff much simpler and faster
> too, as it doesn't need to chase down page tables to free disk slots.
>

I think we can share the code. Adding Yosry & Yuanchu who are
currently maintaining that piece of code.

Though that code might not be in an upstreamable state. At the high
level, it introduces a new type of swap (SWP_GHOST) which underlying
is a truncated file, so no real disk space is needed. The zswap always
accepts the page, so the kernel never tries to go to the underlying
swapfile (reality is a bit more complicated due to the presence of
incompressible memory and no real disk present on the system).
