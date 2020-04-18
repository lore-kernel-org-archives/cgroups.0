From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v2 0/2] always record memcg id for swapped memcg pages
Date: Sat, 18 Apr 2020 21:33:07 +0800
Message-ID: <1587216789-42342-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Johannes,

2 patches fold MEMCG_SWAP feature into kernel as default. I don't know if
they could fit your new solution.

But just in case if they can save you some typing. :)

Thanks
Alex
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Alex Shi (2):
  memcg: folding CONFIG_MEMCG_SWAP as default
  mm/memcg: remove swapaccount kernel parameter

 Documentation/admin-guide/kernel-parameters.txt |  5 --
 arch/arm/configs/omap2plus_defconfig            |  1 -
 arch/arm64/configs/defconfig                    |  1 -
 arch/mips/configs/db1xxx_defconfig              |  1 -
 arch/mips/configs/generic_defconfig             |  1 -
 arch/mips/configs/loongson3_defconfig           |  1 -
 arch/parisc/configs/generic-64bit_defconfig     |  1 -
 arch/powerpc/configs/powernv_defconfig          |  1 -
 arch/powerpc/configs/pseries_defconfig          |  1 -
 arch/s390/configs/debug_defconfig               |  1 -
 arch/s390/configs/defconfig                     |  1 -
 arch/sh/configs/sdk7786_defconfig               |  1 -
 arch/sh/configs/urquell_defconfig               |  1 -
 include/linux/memcontrol.h                      |  4 --
 include/linux/swap.h                            | 27 ----------
 include/linux/swap_cgroup.h                     | 30 -----------
 init/Kconfig                                    | 20 --------
 mm/Makefile                                     |  4 +-
 mm/memcontrol.c                                 | 68 ++++++-------------------
 mm/swap_cgroup.c                                |  7 ---
 20 files changed, 17 insertions(+), 160 deletions(-)

-- 
1.8.3.1

