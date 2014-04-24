From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch] mm: memcontrol: remove hierarchy restrictions for
 swappiness and oom_control
Date: Thu, 24 Apr 2014 08:19:17 -0400
Message-ID: <20140424121917.GB4107@cmpxchg.org>
References: <1397682798-22906-1-git-send-email-hannes@cmpxchg.org>
 <20140418113611.GA7568@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=fPTp1YPK3RSNgN/LpUJoi4/RExIYXiaidNV+8d/Qb9M=;
	b=cbwl8rmEqzLVWp+BaxDh0ThIcJmmK/bkbil+/QNjjyE0Pl+xbrQodr4ORg2r5Z5ZSEp829kBaNTPo5RHZ2xsIp8zR/SyP/fg+F8WyxEVp1qKCUi2ZHCqCA4aSP6dz/PKitWEG1dIqOLqlhK/r+TuICtCIczpvOQkrxP5w13Yl5w=;
Content-Disposition: inline
In-Reply-To: <20140418113611.GA7568@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 01:36:11PM +0200, Michal Hocko wrote:
> On Wed 16-04-14 17:13:18, Johannes Weiner wrote:
> > Per-memcg swappiness and oom killing can currently not be tweaked on a
> > memcg that is part of a hierarchy, but not the root of that hierarchy.
> > Users have complained that they can't configure this when they turned
> > on hierarchy mode.  In fact, with hierarchy mode becoming the default,
> > this restriction disables the tunables entirely.
> 
> Except when we would handle the first level under root differently,
> which is ugly.
> 
> > But there is no good reason for this restriction. 
> 
> I had a patch for this somewhere on the think_more pile. I wasn't
> particularly happy about the semantic so I haven't posted it.
> 
> > The settings for
> > swappiness and OOM killing are taken from whatever memcg whose limit
> > triggered reclaim and OOM invocation, regardless of its position in
> > the hierarchy tree.
> 
> This is OK for the OOM knob because the memory pressure cannot be
> handled at that level in hierarchy and that is where the OOM happens.
> 
> I am not so sure about the swappiness though. The swappiness tells us
> how to proportionally scan anon vs. file LRUs and those are per-memcg,
> not per-hierarchy (unlike the charge) so it makes sense to use it
> per-memcg IMO.
> 
> Besides that using the reclaim target value might be quite confusing.
> Say, somebody wants to prevent from swapping in a certain group and
> yet the pages find their way to swap depending on where the reclaim is
> triggered from.
> Another thing would be that setting swappiness on an unlimited group has
> no effect although I would argue it makes some sense in configuration
> when parent is controlled by somebody else. I would like to tell how
> to reclaim me when I cannot say how much memory I can have. 
> 
> It is true that we have a different behavior for the global reclaim
> already but I am not entirely happy about that. Having a different
> behavior for the global vs. limit reclaims just calls for troubles and
> should be avoided as much as possible.
> 
> So let's think what is the best semantic before we merge this. I would
> be more inclined for using per-memcg swappiness all the time (root using
> the global knob) for all reclaims.

Yeah, we've always used the triggering group's swappiness value but at
the same time forced the whole hierarchy to have the same setting as
the root.

I don't really feel strongly about this.  If you prefer the per-memcg
swappiness I can send a followup patch - or you can.

> > Allow setting swappiness on any group.  The knob on the root memcg
> > already reads the global VM swappiness, make it writable as well.
> 
> I am OK with the change but I think we should discuss the semantic
> first.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
