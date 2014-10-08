From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 0/3] mm: memcontrol: eliminate charge reparenting
Date: Wed, 8 Oct 2014 14:48:23 +0200
Message-ID: <20141008124823.GA4592@dhcp22.suse.cz>
References: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411243235-24680-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat 20-09-14 16:00:32, Johannes Weiner wrote:
> Hi,
> 
> we've come a looong way when it comes to the basic cgroups model, and
> the recent changes there open up a lot of opportunity to make drastic
> simplifications to memory cgroups as well.
> 
> The decoupling of css from the user-visible cgroup, word-sized per-cpu
> css reference counters, and css iterators that include offlined groups
> means we can take per-charge css references, continue to reclaim from
> offlined groups, and so get rid of the error-prone charge reparenting.
> 
> Combined with the higher-order reclaim fixes, lockless page counters,
> and memcg iterator simplification I sent on Friday, the memory cgroup
> core code is finally no longer the biggest file in mm/.  Yay!

Yeah, the code reduction (as per the diffstat - I didn't get to the code
yet) seems really promising.

> These patches are based on mmotm + the above-mentioned changes

> + Tj's percpu-refcount conversion to atomic_long_t.

This is https://lkml.org/lkml/2014/9/20/11 right?

> Thanks!
> 
>  include/linux/cgroup.h          |  26 +++
>  include/linux/percpu-refcount.h |  43 ++++-
>  mm/memcontrol.c                 | 337 ++------------------------------------
>  3 files changed, 75 insertions(+), 331 deletions(-)
> 

-- 
Michal Hocko
SUSE Labs
