From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 6/8] mm: memcontrol: move kmem accounting code to
 CONFIG_MEMCG
Date: Thu, 10 Dec 2015 09:00:12 -0500
Message-ID: <20151210140012.GA21987@cmpxchg.org>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
 <1449599665-18047-7-git-send-email-hannes@cmpxchg.org>
 <20151210131718.GL19496@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151210131718.GL19496-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Dec 10, 2015 at 02:17:18PM +0100, Michal Hocko wrote:
> On Tue 08-12-15 13:34:23, Johannes Weiner wrote:
> > The cgroup2 memory controller will account important in-kernel memory
> > consumers per default. Move all necessary components to CONFIG_MEMCG.
> 
> Hmm, that bloats the kernel also for users who are not using cgroup2
> and have CONFIG_MEMCG_KMEM disabled.

Huh? The clock is ticking for them. We'll keep the original cgroup
interface around for backwards compatibility as long as we think there
are activer users, but this is not the time to microoptimize v1. A
slight increase to kernel size is unfortunate, but I don't think this
could be considered a regression in the sense that it breaks anything.

I'm more concerned with cgroup2 users having to pay the excessive cost
of v1-only features, like the entire soft limit implementation, charge
migration, which also has its fangs in VM hotpaths, the eventfd stuff,
arbitrarily-configurable usage thresholds. That's a *ton* of code. If
you want to tackle kernel bloat, grouping this stuff all together and
slapping a CONFIG_MEMCG_LEGACY around it would be a real step forward.
