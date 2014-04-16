From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: remove hierarchy restrictions for
 swappiness and oom_control
Date: Wed, 16 Apr 2014 14:34:25 -0700
Message-ID: <20140416143425.c2b6f511cf4c6cd7336134b3@linux-foundation.org>
References: <1397682798-22906-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397682798-22906-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 16 Apr 2014 17:13:18 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> Per-memcg swappiness and oom killing can currently not be tweaked on a
> memcg that is part of a hierarchy, but not the root of that hierarchy.
> Users have complained that they can't configure this when they turned
> on hierarchy mode.  In fact, with hierarchy mode becoming the default,
> this restriction disables the tunables entirely.
> 
> But there is no good reason for this restriction.  The settings for
> swappiness and OOM killing are taken from whatever memcg whose limit
> triggered reclaim and OOM invocation, regardless of its position in
> the hierarchy tree.
> 
> Allow setting swappiness on any group.  The knob on the root memcg
> already reads the global VM swappiness, make it writable as well.
> 
> Allow disabling the OOM killer on any non-root memcg.

Documentation/cgroups/memory.txt needs updates?
