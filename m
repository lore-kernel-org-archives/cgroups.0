From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH] vmscan: memcg: Always use swappiness of the
 reclaimed memcg swappiness and oom_control
Date: Wed, 30 Apr 2014 19:06:55 -0400
Message-ID: <20140430230655.GG26041@cmpxchg.org>
References: <1397682798-22906-1-git-send-email-hannes@cmpxchg.org>
 <20140418113611.GA7568@dhcp22.suse.cz>
 <20140424121917.GB4107@cmpxchg.org>
 <20140424142704.GC7644@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=MuHssGCw41IfQ1MQ9olTA6y927eFOX1VSHa5rys5kH0=;
	b=u7lONikBbvLKtmJvyme9dibq/kQwVb0dWXOW7yM0KjyLo66Hgg5el+LKtmnNcvk4Cvda1+cznPRsiMSk4fdG9QhF/vabfZRh+u5YRZwgbeHLyRYMfJs2yCP76Zp03AsKzp3uHrotWHzJKVVszUaXVD3V6vutL8kr4ms4y1q85d4=;
Content-Disposition: inline
In-Reply-To: <20140424142704.GC7644@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 04:27:04PM +0200, Michal Hocko wrote:
> On Thu 24-04-14 08:19:17, Johannes Weiner wrote:
> > On Fri, Apr 18, 2014 at 01:36:11PM +0200, Michal Hocko wrote:
> > > On Wed 16-04-14 17:13:18, Johannes Weiner wrote:
> > > > Per-memcg swappiness and oom killing can currently not be tweaked on a
> > > > memcg that is part of a hierarchy, but not the root of that hierarchy.
> > > > Users have complained that they can't configure this when they turned
> > > > on hierarchy mode.  In fact, with hierarchy mode becoming the default,
> > > > this restriction disables the tunables entirely.
> > > 
> > > Except when we would handle the first level under root differently,
> > > which is ugly.
> > > 
> > > > But there is no good reason for this restriction. 
> > > 
> > > I had a patch for this somewhere on the think_more pile. I wasn't
> > > particularly happy about the semantic so I haven't posted it.
> > > 
> > > > The settings for
> > > > swappiness and OOM killing are taken from whatever memcg whose limit
> > > > triggered reclaim and OOM invocation, regardless of its position in
> > > > the hierarchy tree.
> > > 
> > > This is OK for the OOM knob because the memory pressure cannot be
> > > handled at that level in hierarchy and that is where the OOM happens.
> > > 
> > > I am not so sure about the swappiness though. The swappiness tells us
> > > how to proportionally scan anon vs. file LRUs and those are per-memcg,
> > > not per-hierarchy (unlike the charge) so it makes sense to use it
> > > per-memcg IMO.
> > > 
> > > Besides that using the reclaim target value might be quite confusing.
> > > Say, somebody wants to prevent from swapping in a certain group and
> > > yet the pages find their way to swap depending on where the reclaim is
> > > triggered from.
> > > Another thing would be that setting swappiness on an unlimited group has
> > > no effect although I would argue it makes some sense in configuration
> > > when parent is controlled by somebody else. I would like to tell how
> > > to reclaim me when I cannot say how much memory I can have. 
> > > 
> > > It is true that we have a different behavior for the global reclaim
> > > already but I am not entirely happy about that. Having a different
> > > behavior for the global vs. limit reclaims just calls for troubles and
> > > should be avoided as much as possible.
> > > 
> > > So let's think what is the best semantic before we merge this. I would
> > > be more inclined for using per-memcg swappiness all the time (root using
> > > the global knob) for all reclaims.
> > 
> > Yeah, we've always used the triggering group's swappiness value but at
> > the same time forced the whole hierarchy to have the same setting as
> > the root.
> > 
> > I don't really feel strongly about this.  If you prefer the per-memcg
> > swappiness I can send a followup patch - or you can.
> 
> OK, I originally thought this would be in the same patch but now that I
> think about it some more it would be better to have it separate in case
> it turns out this will cause some issues (at least
> global_reclaim-always-use-global-vm_swappiness is a behavior change).
> So what do you think about this?
> ---
> >From 3a865b7b53aed96d93bbcf865028e63fd6f582ab Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Thu, 24 Apr 2014 15:28:05 +0200
> Subject: [RFC PATCH] vmscan: memcg: Always use swappiness of the reclaimed memcg
> 
> The memory reclaim always uses swappiness of the reclaim target memcg
> (origin of the memory pressure) or vm_swappiness for the global memory
> reclaim. This behavior was consistent (except for difference between
> global and hard limit reclaim) because swappiness was enforced to be
> consistent within each memcg hierarchy.
> 
> After "mm: memcontrol: remove hierarchy restrictions for swappiness
> and oom_control" each memcg can have its own swappiness independent on
> hierarchical parents, though, so the consistency guarantee is gone.
> This can lead to an unexpected behavior. Say that a group is explicitly
> configured to not swapout by memory.swappiness=0 but its memory gets
> swapped out anyway when the memory pressure comes from its parent with a
> different swapping policy.
> It is also unexpected that the knob is meaningless without setting the
> hard limit which would trigger the reclaim and enforce the swappiness.
> There are setups where the hard limit is configured higher in the
> hierarchy by an administrator and children groups are under control of
> somebody else who is interested in the swapout behavior but not
> necessarily about the memory limit.
> 
> >From a semantic point of view swappiness is an attribute defining
> anon vs. file proportional scanning of LRU which is memcg specific
> (unlike charges which are propagated up the hierarchy) so it should be
> applied to the particular memcg's LRU regardless where the memory
> pressure comes from.
> 
> This patch removes vmscan_swappiness() and stores the swappiness into
> the scan_control structure. mem_cgroup_swappiness is then used to
> provide the correct value before shrink_lruvec is called.  The global
> vm_swappiness is used for the root memcg.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> @@ -2221,6 +2217,7 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
>  
>  			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
>  
> +			sc->swappiness = mem_cgroup_swappiness(memcg);
>  			shrink_lruvec(lruvec, sc);

This is a little nasty, but oh well...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
