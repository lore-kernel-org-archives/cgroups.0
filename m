From: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm/memcontrol: use kstrtobool for swapaccount param parsing
Date: Thu, 8 Sep 2022 16:34:52 +0800
Message-ID: <20220908083452.2844125-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Use kstrtobool which is more powerful to handle all kinds of parameters
like 'Yy1Nn0' or [oO][NnFf] for "on" and "off".

Signed-off-by: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 7 ++++---
 mm/memcontrol.c                                 | 8 ++++----
 mm/swap_cgroup.c                                | 2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2434c6729f1c..5f8531e39bc9 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6037,10 +6037,11 @@
 			Execution Facility on pSeries.
 
 	swapaccount=	[KNL]
-			Format: [0|1]
+			Format: { [oO][Nn]/Y/y/1 | [oO][Ff]/N/n/0 }
 			Enable accounting of swap in memory resource
-			controller if no parameter or 1 is given or disable
-			it if 0 is given (See Documentation/admin-guide/cgroup-v1/memory.rst)
+			controller if no parameter or [oO][Nn]/Y/y/1 is given
+			or disable it if [oO][Ff]/N/n/0 is given
+			(See Documentation/admin-guide/cgroup-v1/memory.rst)
 
 	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
 			Format: { <int> [,<int>] | force | noforce }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0a1a8a846870..5511c0c120d9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7434,10 +7434,10 @@ bool mem_cgroup_swap_full(struct folio *folio)
 
 static int __init setup_swap_account(char *s)
 {
-	if (!strcmp(s, "1"))
-		cgroup_memory_noswap = false;
-	else if (!strcmp(s, "0"))
-		cgroup_memory_noswap = true;
+	bool res;
+
+	if (!kstrtobool(s, &res))
+		cgroup_memory_noswap = !res;
 	return 1;
 }
 __setup("swapaccount=", setup_swap_account);
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index 5a9442979a18..107dd0e94b01 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -194,7 +194,7 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
 	return 0;
 nomem:
 	pr_info("couldn't allocate enough memory for swap_cgroup\n");
-	pr_info("swap_cgroup can be disabled by swapaccount=0 boot option\n");
+	pr_info("swap_cgroup can be disabled by swapaccount=[oO][Ff]/N/n/0 boot option\n");
 	return -ENOMEM;
 }
 
-- 
2.25.1

