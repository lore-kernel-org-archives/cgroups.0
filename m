From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 00/10] mm: memcg: charge/uncharge improvements v2
Date: Wed, 11 Jul 2012 19:02:12 +0200
Message-ID: <1342026142-7284-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

second version of tiny charge/uncharge improvements, with incorporated
feedback and acks added (thanks guys).

changes:
o fixed the 03/10 PageSwapCache check in end_migration(), spotted by Kame
o dropped the v1 03/11 shmem patch in favor of Hugh's cleanup
o included default group charging comment fix in 07/10, spotted by Wanpeng

 include/linux/memcontrol.h |   11 +--
 mm/memcontrol.c            |  207 +++++++++++++++++++++++---------------------
 mm/migrate.c               |   27 ++-----
 mm/swapfile.c              |    3 +-
 4 files changed, 119 insertions(+), 129 deletions(-)
