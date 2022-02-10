From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] memcg: unify force charging conditions
Date: Thu, 10 Feb 2022 14:25:01 -0800
Message-ID: <CALvZod5FBEHzNcXD-Wo5BPmMxu+Kf-ZA8s6N9EmD6TeFocs3_w@mail.gmail.com>
References: <20220210081437.1884008-1-shakeelb@google.com> <20220210081437.1884008-3-shakeelb@google.com>
 <YgVvgCbbTrDPb5tT@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+9taNQqr53065W1oX4JDNtAk/+njpm3x8DzxRxP1lHU=;
        b=D959OvVwl7BXuwDxGu0YH5B8iaG9JycwJXSActYL0Rhkvl1XpSclE6R6SP/TS9KpOb
         uIITo6yOM2u/NW7Lpt2qvugxdahKXm7DxUSfw4CvZOax6yiLj0PuPiJD0kxUvrCoLRZE
         8+tEADL2hNCtlzAphVfr0GXuxsruicxdkryZKu4A3EZQYGNy1YGT2PXBJWQ7cmvCU5sT
         JmTq6TyMVzqerdn7CZcyv983bkS+4BRuAEOfAWl2vQTFGVVjXWYx7YXbhJ8zrn9tghSq
         n6Z4aZpGnza7LI6CgiHjzXoxAuxZQeb8ZX3fWnC9sHKXTbS9MAdJvXlr3WYwA+ZhdPb1
         7tbA==
In-Reply-To: <YgVvgCbbTrDPb5tT-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Feb 10, 2022 at 12:03 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Thu, Feb 10, 2022 at 12:14:35AM -0800, Shakeel Butt wrote:
> > Currently the kernel force charges the allocations which have __GFP_HIGH
> > flag without triggering the memory reclaim. __GFP_HIGH indicates that
> > the caller is high priority and since commit 869712fd3de5 ("mm:
> > memcontrol: fix network errors from failing __GFP_ATOMIC charges") the
> > kernel let such allocations do force charging. Please note that
> > __GFP_ATOMIC has been replaced by __GFP_HIGH.
> >
> > __GFP_HIGH does not tell if the caller can block or can trigger reclaim.
> > There are separate checks to determine that. So, there is no need to
> > skip reclaim for __GFP_HIGH allocations. So, handle __GFP_HIGH together
> > with __GFP_NOFAIL which also does force charging.
>
> This sounds very reasonable. But shouldn't we check if __GFP_DIRECT_RECLAIM
> is set and bail out otherwise?
>

We already have a gfpflags_allow_blocking() check which checks for
__GFP_DIRECT_RECLAIM.
