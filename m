From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch v3 -mm 3/3] vmscan, memcg: Do softlimit reclaim also for
 targeted reclaim
Date: Fri, 17 May 2013 09:50:19 +0200
Message-ID: <20130517075019.GF25158@dhcp22.suse.cz>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
 <1368431172-6844-4-git-send-email-mhocko@suse.cz>
 <51934A62.2030606@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51934A62.2030606-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 15-05-13 12:42:10, Glauber Costa wrote:
> On 05/13/2013 11:46 AM, Michal Hocko wrote:
> > Soft reclaim has been done only for the global reclaim (both background
> > and direct). Since "memcg: integrate soft reclaim tighter with zone
> > shrinking code" there is no reason for this limitation anymore as the
> > soft limit reclaim doesn't use any special code paths and it is a
> > part of the zone shrinking code which is used by both global and
> > targeted reclaims.
> > 
> > From semantic point of view it is even natural to consider soft limit
> > before touching all groups in the hierarchy tree which is touching the
> > hard limit because soft limit tells us where to push back when there is
> > a  memory pressure. It is not important whether the pressure comes from
> > the limit or imbalanced zones.
> > 
> > This patch simply enables soft reclaim unconditionally in
> > mem_cgroup_should_soft_reclaim so it is enabled for both global and
> > targeted reclaim paths. mem_cgroup_soft_reclaim_eligible needs to learn
> > about the root of the reclaim to know where to stop checking soft limit
> > state of parents up the hierarchy.
> > Say we have
> > A (over soft limit)
> >  \
> >   B (below s.l., hit the hard limit)
> >  / \
> > C   D (below s.l.)
> > 
> > B is the source of the outside memory pressure now for D but we
> > shouldn't soft reclaim it because it is behaving well under B subtree
> > and we can still reclaim from C (pressumably it is over the limit).
> > mem_cgroup_soft_reclaim_eligible should therefore stop climbing up the
> > hierarchy at B (root of the memory pressure).
> > 
> > Changes since v1
> > - add sc->target_mem_cgroup handling into mem_cgroup_soft_reclaim_eligible
> > 
> > Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > ---
> 
> Reviewed-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Thanks for the review Glauber!

-- 
Michal Hocko
SUSE Labs
