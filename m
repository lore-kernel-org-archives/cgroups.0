From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: remove hierarchy restrictions for
 swappiness and oom_control
Date: Fri, 18 Apr 2014 13:36:11 +0200
Message-ID: <20140418113611.GA7568@dhcp22.suse.cz>
References: <1397682798-22906-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1397682798-22906-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 16-04-14 17:13:18, Johannes Weiner wrote:
> Per-memcg swappiness and oom killing can currently not be tweaked on a
> memcg that is part of a hierarchy, but not the root of that hierarchy.
> Users have complained that they can't configure this when they turned
> on hierarchy mode.  In fact, with hierarchy mode becoming the default,
> this restriction disables the tunables entirely.

Except when we would handle the first level under root differently,
which is ugly.

> But there is no good reason for this restriction. 

I had a patch for this somewhere on the think_more pile. I wasn't
particularly happy about the semantic so I haven't posted it.

> The settings for
> swappiness and OOM killing are taken from whatever memcg whose limit
> triggered reclaim and OOM invocation, regardless of its position in
> the hierarchy tree.

This is OK for the OOM knob because the memory pressure cannot be
handled at that level in hierarchy and that is where the OOM happens.

I am not so sure about the swappiness though. The swappiness tells us
how to proportionally scan anon vs. file LRUs and those are per-memcg,
not per-hierarchy (unlike the charge) so it makes sense to use it
per-memcg IMO.

Besides that using the reclaim target value might be quite confusing.
Say, somebody wants to prevent from swapping in a certain group and
yet the pages find their way to swap depending on where the reclaim is
triggered from.
Another thing would be that setting swappiness on an unlimited group has
no effect although I would argue it makes some sense in configuration
when parent is controlled by somebody else. I would like to tell how
to reclaim me when I cannot say how much memory I can have. 

It is true that we have a different behavior for the global reclaim
already but I am not entirely happy about that. Having a different
behavior for the global vs. limit reclaims just calls for troubles and
should be avoided as much as possible.

So let's think what is the best semantic before we merge this. I would
be more inclined for using per-memcg swappiness all the time (root using
the global knob) for all reclaims.

> Allow setting swappiness on any group.  The knob on the root memcg
> already reads the global VM swappiness, make it writable as well.

I am OK with the change but I think we should discuss the semantic
first.

[...]
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
