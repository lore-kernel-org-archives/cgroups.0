From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 00/11] mm: memcg: charge/uncharge improvements
Date: Thu,  5 Jul 2012 02:44:52 +0200
Message-ID: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

the biggest thing is probably #1, no longer trying (and failing) to
charge replacement pages during migration and thus compaction.  The
rest is cleanups and tiny optimizations that move some checks out of
the charge and uncharge core paths that do not apply to all types of
pages alike.

 include/linux/memcontrol.h |   11 +--
 mm/memcontrol.c            |  205 +++++++++++++++++++++++---------------------
 mm/migrate.c               |   27 ++-----
 mm/shmem.c                 |   11 ++-
 mm/swapfile.c              |    3 +-
 5 files changed, 124 insertions(+), 133 deletions(-)
