From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Tue, 5 May 2020 12:57:34 -0400
Message-ID: <20200505165734.GD58018@cmpxchg.org>
References: <20200504065600.GA22838@dhcp22.suse.cz>
 <CALvZod5Ao2PEFPEOckW6URBfxisp9nNpNeon1GuctuHehqk_6Q@mail.gmail.com>
 <20200504141136.GR22838@dhcp22.suse.cz>
 <CALvZod7Ls7rTDOr5vXwEiPneLqbq3JoxfFBxZZ71YWgvLkNr5A@mail.gmail.com>
 <20200504150052.GT22838@dhcp22.suse.cz>
 <CALvZod7EeQm-T4dsBddfMY_szYw3m8gRh5R5GfjQiuQAtCocug@mail.gmail.com>
 <20200504160613.GU22838@dhcp22.suse.cz>
 <CALvZod79hWns9366B+8ZK2Roz8c+vkdA80HqFNMep56_pumdRQ@mail.gmail.com>
 <20200505071324.GB16322@dhcp22.suse.cz>
 <CALvZod5H-fDbvu73=hkzN0Man_+03ZW0d5zc1N0YObVHSiy0Tw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fEeh741pti+zQtUqiU+d//divWdQ0COuz+a61BTeqwc=;
        b=YSNRusfE9U5u8q3v9LefCY1rU6K93jnDg4I/Se7sXa6/yvJwAIFJruFuN/+VjtbSYG
         WLGgbW8jcLo909cVZHzUEp9Vl+j+1knpGhiLLF/8yO7xI4PhQHn2jKn/XZ+7gIEL8BH/
         PhBIW0QTlorsqAK3ECYQ7eylm0EjiRTeEix3nV7MDzfl4adlAlpi/WyRmqf5Ia/KQN4O
         w1BXffany2R/o7burzJHOvzi7xx7uGRaTy/SVArfU9go+3KLVzW3kV2yZOZWk8hdENnp
         gMwRI/VptGu32D36XJgI8z1S2S8eSXN0uchSFh2cN9VI3jrNmhOGTKXONkufx5pguBgZ
         O5Ow==
Content-Disposition: inline
In-Reply-To: <CALvZod5H-fDbvu73=hkzN0Man_+03ZW0d5zc1N0YObVHSiy0Tw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 05, 2020 at 08:03:17AM -0700, Shakeel Butt wrote:
> On Tue, May 5, 2020 at 12:13 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > So instead of potentially removing a useful information can we focus on
> > the remote charging side of the problem and deal with it in a sensible
> > way? That would make memory.high usable for your usecase and I still
> > believe that this is what you should be using in the first place.
> 
> We talked about this at LSFMM'19 and I think the decision was to not
> fix high reclaim for remote memcg until it will be an actual issue. I
> suppose now we can treat it as an actual issue.
> 
> There are a couple of open questions:
> 1) Should the remote chargers be throttled and do the high reclaim?

I would say it depends on the caller. We may need both: a centralized
charger like a kthread that does work on behalf of many cgroups should
not be throttled, or we risk priority inversions - maybe not even held
up for reclaim, although that would need some thinking about
memory.max as well - whether remote charges should be allowed to
overrun memory.max temporarily, and we punt all reclaim from such
contexts to a worker. (Preferrably, in the future, with all the cpu
cycles of that worker accounted to the cgroup. We want that for
kswapd-style background reclaim as well).

We do similar things with IO for example, when offloading IO to a
central kthread. The kthread is allowed to proceed past a cgroup's
allowance in order to make forward progress, and the cgroup will be
forced to pay up retroactively when it comes back for more of the
resource.
