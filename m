From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v1 0/7] mm/memcontrol: recharge mlocked pages
Date: Wed, 4 Sep 2019 16:37:47 +0200
Message-ID: <20190904143747.GA3838@dhcp22.suse.cz>
References: <156760509382.6560.17364256340940314860.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156760509382.6560.17364256340940314860.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>

On Wed 04-09-19 16:53:08, Konstantin Khlebnikov wrote:
> Currently mlock keeps pages in cgroups where they were accounted.
> This way one container could affect another if they share file cache.
> Typical case is writing (downloading) file in one container and then
> locking in another. After that first container cannot get rid of cache.
> Also removed cgroup stays pinned by these mlocked pages.
> 
> This patchset implements recharging pages to cgroup of mlock user.
> 
> There are three cases:
> * recharging at first mlock
> * recharging at munlock to any remaining mlock
> * recharging at 'culling' in reclaimer to any existing mlock
> 
> To keep things simple recharging ignores memory limit. After that memory
> usage temporary could be higher than limit but cgroup will reclaim memory
> later or trigger oom, which is valid outcome when somebody mlock too much.

I assume that this is mlock specific because the pagecache which has the
same problem is reclaimable and the problem tends to resolve itself
after some time.

Anyway, how big of a problem this really is? A lingering memcg is
certainly not nice but pages are usually not mlocked for ever. Or is
this a way to protect from an hostile actor?

> Konstantin Khlebnikov (7):
>       mm/memcontrol: move locking page out of mem_cgroup_move_account
>       mm/memcontrol: add mem_cgroup_recharge
>       mm/mlock: add vma argument for mlock_vma_page()
>       mm/mlock: recharge memory accounting to first mlock user
>       mm/mlock: recharge memory accounting to second mlock user at munlock
>       mm/vmscan: allow changing page memory cgroup during reclaim
>       mm/mlock: recharge mlocked pages at culling by vmscan
> 
> 
>  Documentation/admin-guide/cgroup-v1/memory.rst |    5 +
>  include/linux/memcontrol.h                     |    9 ++
>  include/linux/rmap.h                           |    3 -
>  mm/gup.c                                       |    2 
>  mm/huge_memory.c                               |    4 -
>  mm/internal.h                                  |    6 +
>  mm/ksm.c                                       |    2 
>  mm/memcontrol.c                                |  104 ++++++++++++++++--------
>  mm/migrate.c                                   |    2 
>  mm/mlock.c                                     |   14 +++
>  mm/rmap.c                                      |    5 +
>  mm/vmscan.c                                    |   17 ++--
>  12 files changed, 121 insertions(+), 52 deletions(-)
> 
> --
> Signature

-- 
Michal Hocko
SUSE Labs
