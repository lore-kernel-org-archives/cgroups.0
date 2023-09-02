From: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm, memcg: expose swapcache stat for memcg v1
Date: Sat, 2 Sep 2023 18:07:28 +0800
Message-ID: <20230902100728.3850149-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Since commit b6038942480e ("mm: memcg: add swapcache stat for memcg v2")
adds swapcache stat for the cgroup v2, it seems there is no reason to
hide it in memcg v1. Conversely, with swapcached it is more accurate to
evaluate the available memory for memcg.

Suggested-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 1 +
 mm/memcontrol.c                                | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index fabaad3fd9c2..fb4abe0dc228 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -546,6 +546,7 @@ memory.stat file includes following statistics:
                     event happens each time a page is unaccounted from the
                     cgroup.
     swap            # of bytes of swap usage
+    swapcached      # of bytes of swap cached in memory
     dirty           # of bytes that are waiting to get written back to the disk.
     writeback       # of bytes of file/anon cache that are queued for syncing to
                     disk.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c465829db92b..619acf479be7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4068,6 +4068,9 @@ static const unsigned int memcg1_stats[] = {
 	WORKINGSET_REFAULT_ANON,
 	WORKINGSET_REFAULT_FILE,
 	MEMCG_SWAP,
+#ifdef CONFIG_SWAP
+	NR_SWAPCACHE,
+#endif
 };
 
 static const char *const memcg1_stat_names[] = {
@@ -4083,6 +4086,9 @@ static const char *const memcg1_stat_names[] = {
 	"workingset_refault_anon",
 	"workingset_refault_file",
 	"swap",
+#ifdef CONFIG_SWAP
+	"swapcached",
+#endif
 };
 
 /* Universal VM events cgroup1 shows, original sort order */
-- 
2.25.1

