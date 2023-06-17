From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: remove unneeded header files
Date: Sat, 17 Jun 2023 15:26:58 +0800
Message-ID: <20230617072658.1826560-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Remove some unneeded header files. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d42742edfeac..a2c82a18745d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -30,14 +30,10 @@
 #include <linux/cgroup.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
-#include <linux/shmem_fs.h>
-#include <linux/hugetlb.h>
 #include <linux/pagemap.h>
 #include <linux/vm_event_item.h>
 #include <linux/smp.h>
 #include <linux/page-flags.h>
-#include <linux/backing-dev.h>
-#include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/limits.h>
 #include <linux/export.h>
@@ -66,7 +62,6 @@
 #include <linux/sched/isolation.h>
 #include "internal.h"
 #include <net/sock.h>
-#include <net/ip.h>
 #include "slab.h"
 #include "swap.h"
 
-- 
2.27.0

