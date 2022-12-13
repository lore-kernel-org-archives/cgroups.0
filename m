From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Tue, 13 Dec 2022 16:58:50 +0100
Message-ID: <Y5iet+ch24YrvExA@cmpxchg.org>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
 <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
 <Y5g41HF2TcLzro4o@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BmoHPjxBfuv0L4/bABJBapiPnoh74ZtmvdJi1uPpypQ=;
        b=tYSHyL3uT8BsXSP/ddwQ0c6U4nhdyNjgWj87JFBf3wKrv2/u1Rhvnbh0tcm5zQCdx+
         Z3m6/3BDj8GObhrJtaTfOHOsj6JxliVkHsNt/y0O1l9MVpjQIn91+Sy3NrwwQeqcfZlQ
         S2PfH5LtOg/HYacxDBleObOg3/CePMpki5SMd7deB8e96YqDEQIAuxEAcxD2M+UZJxtA
         QqHXZx0xJUBuB9rXKD3WnIIY7Wo9FVQuTVEQnC4OudC5oSNZSw/P1OO6bf97dDABhUhK
         XjMDuG/ga6AuWOT2s47vBi+LPy3BfEM7s61d4FNSk/qXm+kDo6TDYl+nyQ5a4+92oU8M
         hROg==
Content-Disposition: inline
In-Reply-To: <Y5g41HF2TcLzro4o@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Huang Ying <ying.huang@intel.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, fvdl@google.com, bagasdotme@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue, Dec 13, 2022 at 09:33:24AM +0100, Michal Hocko wrote:
> I do recognize your need to control the demotion but I argue that it is
> a bad idea to rely on an implicit behavior of the memory reclaim and an
> interface which is _documented_ to primarily _reclaim_ memory.

I think memory.reclaim should demote as part of page aging. What I'd
like to avoid is *having* to manually control the aging component in
the interface (e.g. making memory.reclaim *only* reclaim, and
*requiring* a coordinated use of memory.demote to ensure progress.)

> Really, consider that the current demotion implementation will change
> in the future and based on a newly added heuristic memory reclaim or
> compression would be preferred over migration to a different tier.  This
> might completely break your current assumptions and break your usecase
> which relies on an implicit demotion behavior.  Do you see that as a
> potential problem at all? What shall we do in that case? Special case
> memory.reclaim behavior?

Shouldn't that be derived from the distance propertiers in the tier
configuration?

I.e. if local compression is faster than demoting to a slower node, we
should maybe have a separate tier for that. Ignoring proactive reclaim
or demotion commands for a second: on that node, global memory
pressure should always compress first, while the oldest pages from the
compression cache should demote to the other node(s) - until they
eventually get swapped out.

However fine-grained we make proactive reclaim control over these
stages, it should at least be possible for the user to request the
default behavior that global pressure follows, without jumping through
hoops or requiring the coordinated use of multiple knobs. So IMO there
is an argument for having a singular knob that requests comprehensive
aging and reclaiming across the configured hierarchy.

As far as explicit control over the individual stages goes - no idea
if you would call the compression stage demotion or reclaim. The
distinction still does not make much of sense to me, since reclaim is
just another form of demotion. Sure, page faults have a different
access latency than dax to slower memory. But you could also have 3
tiers of memory where the difference between tier 1 and 2 is much
smaller than the difference between 2 and 3, and you might want to
apply different demotion rates between them as well.

The other argument is that demotion does not free cgroup memory,
whereas reclaim does. But with multiple memory tiers of vastly
different performance, isn't there also an argument for granting
cgroups different shares of each memory? So that a higher priority
group has access to a bigger share of the fastest memory, and lower
prio cgroups are relegated to lower tiers. If we split those pools,
then "demotion" will actually free memory in a cgroup.

This is why I liked adding a nodes= argument to memory.reclaim the
best. It doesn't encode a distinction that may not last for long.

The problem comes from how to interpret the input argument and the
return value, right? Could we solve this by requiring the passed
nodes= to all be of the same memory tier? Then there is no confusion
around what is requested and what the return value means.

And if no nodes are passed, it means reclaim (from the lowest memory
tier) X pages and demote as needed, then return the reclaimed pages.

> Now to your specific usecase. If there is a need to do a memory
> distribution balancing then fine but this should be a well defined
> interface. E.g. is there a need to not only control demotion but
> promotions as well? I haven't heard anybody requesting that so far
> but I can easily imagine that like outsourcing the memory reclaim to
> the userspace someone might want to do the same thing with the numa
> balancing because $REASONS. Should that ever happen, I am pretty sure
> hooking into memory.reclaim is not really a great idea.

Should this ever happen, it would seem fair that that be a separate
knob anyway, no? One knob to move the pipeline in one direction
(aging), one knob to move it the other way.
