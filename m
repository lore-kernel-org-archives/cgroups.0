From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: hierarchical soft limit reclaim
Date: Wed, 18 Jan 2012 10:25:09 +0100
Message-ID: <20120118092509.GI24386@cmpxchg.org>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
 <1326207772-16762-3-git-send-email-hannes@cmpxchg.org>
 <CALWz4izwNBN_qcSsqg-qYw-Esc9vBL3=4cv3Wsg1jf6001_fWQ@mail.gmail.com>
 <20120112085904.GG24386@cmpxchg.org>
 <CALWz4iz3sQX+pCr19rE3_SwV+pRFhDJ7Lq-uJuYBq6u3mRU3AQ@mail.gmail.com>
 <20120113224424.GC1653@cmpxchg.org>
 <4F158418.2090509@gmail.com>
 <20120117145348.GA3144@cmpxchg.org>
 <CAFj3OHWY2Biw54gaGeH5fkxzgOhxn7NAibeYT_Jmga-_ypNSRg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFj3OHWY2Biw54gaGeH5fkxzgOhxn7NAibeYT_Jmga-_ypNSRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 18, 2012 at 03:17:25PM +0800, Sha wrote:
> > > I don't think it solve the root of the problem, example:
> > > root
> > > -> A (hard limit 20G, soft limit 12G, usage 20G)
> > >   -> A1 ( soft limit 2G,   usage 1G)
> > >   -> A2 ( soft limit 10G, usage 19G)
> > >          ->B1 (soft limit 5G, usage 4G)
> > >          ->B2 (soft limit 5G, usage 15G)
> > >
> > > Now A is hitting its hard limit and start hierarchical reclaim under A.
> > > If we choose B1 to go through mem_cgroup_over_soft_limit, it will
> > > return true because its parent A2 has a large usage and will lead to
> > > priority=0 reclaiming. But in fact it should be B2 to be punished.
> 
> > Because A2 is over its soft limit, the whole hierarchy below it should
> > be preferred over A1, so both B1 and B2 should be soft limit reclaimed
> > to be consistent with behaviour at the root level.
> 
> Well it is just the behavior that I'm expecting actually. But with my
> humble comprehension, I can't catch the soft-limit-based hierarchical
> reclaiming under the target cgroup (A2) in the current implementation
> or after the patch. Both the current mem_cgroup_soft_reclaim or
> shrink_zone select victim sub-cgroup by mem_cgroup_iter, but it
> doesn't take soft limit into consideration, do I left anything ?

No, currently soft limits are ignored if pressure originates from
below root_mem_cgroup.

But iff soft limits are applied right now, they are applied
hierarchically, see mem_cgroup_soft_limit_reclaim().

In my opinion, the fact that soft limits are ignored when pressure is
triggered sub-root_mem_cgroup is an artifact of the per-zone tree, so
I allowed soft limits to be taken into account below root_mem_cgroup.

But IMO, this is something different from how soft limit reclaim is
applied once triggered: currently, soft limit reclaim applies to a
whole hierarchy, including all children.  And this I left unchanged.
