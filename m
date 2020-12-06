From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v2 08/12] mm: memcontrol: convert NR_KERNEL_SCS_KB account to bytes
Date: Sun,  6 Dec 2020 16:29:44 +0800
Message-ID: <20201206082948.11812-2-songmuchun@bytedance.com>
References: <20201206082948.11812-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IzVbUHzHNutFlJQXX/d4rCoABm7bks/8Sv9HD05GfEo=;
        b=XreRyw7hI2GhJlkkEvcGA2V6QiV/heX0OqkEPDJNiVRh13DkcCk2CnH8x5TOVy3I+s
         y02dVE1gUP3ZD3/imp3klJjjP+4ilXqHVYYUm7/LusipLgC3A7YPIWeCGylkxbl1GKXc
         bztOgUedenKv35sfCpKz81oU1YqoCh3PJmBLbhMW1zdX/wqEQQ4whVobfMBxoHctz4jI
         VomjFpsE1D/Mvz+q4IZvgsTAQmw9d8bvdRlG1exX9LrOzSPmLBy5AblhcxgFI2uh26+6
         rBWdMDiekPPNL+d04iEj9lketLc4Aex6bkD5FSH2c6a7TRQzehD3C1UViO1ys7fBoe5Q
         +jdw==
In-Reply-To: <20201206082948.11812-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Convert NR_KERNEL_SCS_KB account to bytes

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 drivers/base/node.c    | 2 +-
 fs/proc/meminfo.c      | 2 +-
 include/linux/mmzone.h | 2 +-
 kernel/scs.c           | 4 ++--
 mm/page_alloc.c        | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 92a75bad35c9..bc01ce0b2fcd 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -448,7 +448,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     nid, K(i.sharedram),
 			     nid, node_page_state(pgdat, NR_KERNEL_STACK_B) / SZ_1K,
 #ifdef CONFIG_SHADOW_CALL_STACK
-			     nid, node_page_state(pgdat, NR_KERNEL_SCS_KB),
+			     nid, node_page_state(pgdat, NR_KERNEL_SCS_B) / SZ_1K,
 #endif
 			     nid, K(sum_zone_node_page_state(nid, NR_PAGETABLE)),
 			     nid, 0UL,
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 799a537d4218..69895e83d4fc 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -104,7 +104,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		   global_node_page_state(NR_KERNEL_STACK_B) / SZ_1K);
 #ifdef CONFIG_SHADOW_CALL_STACK
 	seq_printf(m, "ShadowCallStack:%8lu kB\n",
-		   global_node_page_state(NR_KERNEL_SCS_KB));
+		   global_node_page_state(NR_KERNEL_SCS_B) / SZ_1K);
 #endif
 	show_val_kb(m, "PageTables:     ",
 		    global_zone_page_state(NR_PAGETABLE));
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bd34416293ec..1f9c83778629 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -204,7 +204,7 @@ enum node_stat_item {
 	NR_FOLL_PIN_RELEASED,	/* pages returned via unpin_user_page() */
 	NR_KERNEL_STACK_B,	/* measured in byte */
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
-	NR_KERNEL_SCS_KB,	/* measured in KiB */
+	NR_KERNEL_SCS_B,	/* measured in byte */
 #endif
 	NR_VM_NODE_STAT_ITEMS
 };
diff --git a/kernel/scs.c b/kernel/scs.c
index 4ff4a7ba0094..8db89c932ddc 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -17,8 +17,8 @@ static void __scs_account(void *s, int account)
 {
 	struct page *scs_page = virt_to_page(s);
 
-	mod_node_page_state(page_pgdat(scs_page), NR_KERNEL_SCS_KB,
-			    account * (SCS_SIZE / SZ_1K));
+	mod_node_page_state(page_pgdat(scs_page), NR_KERNEL_SCS_B,
+			    account * SCS_SIZE);
 }
 
 static void *scs_alloc(int node)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d2821ba7f682..58916b3afdab 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5574,7 +5574,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			node_page_state(pgdat, NR_KERNEL_STACK_B) / SZ_1K,
 #ifdef CONFIG_SHADOW_CALL_STACK
-			node_page_state(pgdat, NR_KERNEL_SCS_KB),
+			node_page_state(pgdat, NR_KERNEL_SCS_B) / SZ_1K,
 #endif
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
-- 
2.11.0

