From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Tue, 13 Dec 2022 11:53:42 -0800
Message-ID: <CAHS8izPVbCZOeXxr=Fawa6N92WqJ=6CgP4vHuh-LA_aOH1QOvQ@mail.gmail.com>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz> <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
 <Y5g41HF2TcLzro4o@dhcp22.suse.cz> <Y5iet+ch24YrvExA@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G68UrwkYoX/Qe/LoWiVKT0TgPWlsfh6ss6fYKw0/u6Q=;
        b=Sm8jgscfl0bxKQljesMfB/GLmzJaJD2vpXZGfn0SUkb5+iYT7soSkMXvoJkuAmGEi8
         Xf50Z0xzzN+cwQkwCYl+q6vPKzbkk4kB1e8tTanObV8TGNuryvpt+NjUQ2TkXxxqIzpO
         LYcjE7/r+2zyTzC2NQSG5lb8ylYzAAhsRfiQYBJ4M7f2VPPi5KYBls3PFjee2xiNgiCU
         +k3NJS+AJ0CdsG4wCv36sgBuDF+yZcefMFa7BEGCR1GbvSbdSINRBb/q5jrbF0UZrufz
         3hLaS3wKXAXEwWDVCMxik4Ytq8v6dEUK4LcVueiRfgrW+BpP7dnoSEuoNaVY6dRzSENK
         AT+Q==
In-Reply-To: <Y5iet+ch24YrvExA-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Dec 13, 2022 at 7:58 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Tue, Dec 13, 2022 at 09:33:24AM +0100, Michal Hocko wrote:
> > I do recognize your need to control the demotion but I argue that it is
> > a bad idea to rely on an implicit behavior of the memory reclaim and an
> > interface which is _documented_ to primarily _reclaim_ memory.
>
> I think memory.reclaim should demote as part of page aging. What I'd
> like to avoid is *having* to manually control the aging component in
> the interface (e.g. making memory.reclaim *only* reclaim, and
> *requiring* a coordinated use of memory.demote to ensure progress.)
>
> > Really, consider that the current demotion implementation will change
> > in the future and based on a newly added heuristic memory reclaim or
> > compression would be preferred over migration to a different tier.  This
> > might completely break your current assumptions and break your usecase
> > which relies on an implicit demotion behavior.  Do you see that as a
> > potential problem at all? What shall we do in that case? Special case
> > memory.reclaim behavior?
>
> Shouldn't that be derived from the distance propertiers in the tier
> configuration?
>
> I.e. if local compression is faster than demoting to a slower node, we
> should maybe have a separate tier for that. Ignoring proactive reclaim
> or demotion commands for a second: on that node, global memory
> pressure should always compress first, while the oldest pages from the
> compression cache should demote to the other node(s) - until they
> eventually get swapped out.
>
> However fine-grained we make proactive reclaim control over these
> stages, it should at least be possible for the user to request the
> default behavior that global pressure follows, without jumping through
> hoops or requiring the coordinated use of multiple knobs. So IMO there
> is an argument for having a singular knob that requests comprehensive
> aging and reclaiming across the configured hierarchy.
>
> As far as explicit control over the individual stages goes - no idea
> if you would call the compression stage demotion or reclaim. The
> distinction still does not make much of sense to me, since reclaim is
> just another form of demotion. Sure, page faults have a different
> access latency than dax to slower memory. But you could also have 3
> tiers of memory where the difference between tier 1 and 2 is much
> smaller than the difference between 2 and 3, and you might want to
> apply different demotion rates between them as well.
>
> The other argument is that demotion does not free cgroup memory,
> whereas reclaim does. But with multiple memory tiers of vastly
> different performance, isn't there also an argument for granting
> cgroups different shares of each memory? So that a higher priority
> group has access to a bigger share of the fastest memory, and lower
> prio cgroups are relegated to lower tiers. If we split those pools,
> then "demotion" will actually free memory in a cgroup.
>

I would also like to say I implemented something in line with that in [1].

In this patch, pages demoted from inside the nodemask to outside the
nodemask count as 'reclaimed'. This, in my mind, is a very generic
solution to the 'should demoted pages count as reclaim?' problem, and
will work in all scenarios as long as the nodemask passed to
shrink_folio_list() is set correctly by the call stack.

> This is why I liked adding a nodes= argument to memory.reclaim the
> best. It doesn't encode a distinction that may not last for long.
>
> The problem comes from how to interpret the input argument and the
> return value, right? Could we solve this by requiring the passed
> nodes= to all be of the same memory tier? Then there is no confusion
> around what is requested and what the return value means.
>

I feel like I arrived at a better solution in [1], where pages demoted
from inside of the nodemask to outside count as reclaimed and the rest
don't. But I think we could solve this by explicit checks that nodes=
arg are from the same tier, yes.

> And if no nodes are passed, it means reclaim (from the lowest memory
> tier) X pages and demote as needed, then return the reclaimed pages.
>
> > Now to your specific usecase. If there is a need to do a memory
> > distribution balancing then fine but this should be a well defined
> > interface. E.g. is there a need to not only control demotion but
> > promotions as well? I haven't heard anybody requesting that so far
> > but I can easily imagine that like outsourcing the memory reclaim to
> > the userspace someone might want to do the same thing with the numa
> > balancing because $REASONS. Should that ever happen, I am pretty sure
> > hooking into memory.reclaim is not really a great idea.
>
> Should this ever happen, it would seem fair that that be a separate
> knob anyway, no? One knob to move the pipeline in one direction
> (aging), one knob to move it the other way.

[1] https://lore.kernel.org/linux-mm/20221206023406.3182800-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
