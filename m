From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 0/9] mm: memcontrol: naturalize charge lifetime
Date: Fri, 2 May 2014 13:26:28 +0200
Message-ID: <20140502112627.GG3446@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1398889543-23671-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 30-04-14 16:25:34, Johannes Weiner wrote:
[...]
>  Documentation/cgroups/memcg_test.txt |  160 +--
>  include/linux/memcontrol.h           |   94 +-
>  include/linux/page_cgroup.h          |   43 +-
>  include/linux/swap.h                 |   15 +-
>  kernel/events/uprobes.c              |    1 +
>  mm/filemap.c                         |   13 +-
>  mm/huge_memory.c                     |   51 +-
>  mm/memcontrol.c                      | 1724 ++++++++++++--------------------
>  mm/memory.c                          |   41 +-
>  mm/migrate.c                         |   46 +-
>  mm/rmap.c                            |    6 -
>  mm/shmem.c                           |   28 +-
>  mm/swap.c                            |   22 +
>  mm/swap_state.c                      |    8 +-
>  mm/swapfile.c                        |   21 +-
>  mm/truncate.c                        |    1 -
>  mm/vmscan.c                          |    9 +-
>  mm/zswap.c                           |    2 +-
>  18 files changed, 833 insertions(+), 1452 deletions(-)

Impressive! I will get through the series but it will take some time.

-- 
Michal Hocko
SUSE Labs
