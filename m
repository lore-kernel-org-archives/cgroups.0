From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/6] mm: add NR_SECONDARY_PAGETABLE stat
Date: Tue, 26 Apr 2022 05:38:59 +0000
Message-ID: <20220426053904.3684293-2-yosryahmed@google.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pqJIcFO1YbM2kMD/7P/nIKLZQYZcxdFTC0Vu8kenpz8=;
        b=hMgaPC2CMNA38BUc/4Z6knwfUpImRGhDmly5NSUZyOtnP8B4CuknojlkCLYqYS4Xx1
         Mhi5lC5QrZ7YRgbk+KhF1jxO4da//wil1kv0DtVbRdO8F+TyX8sogYFIfc6A4c6xm3ms
         lYBbLBA0PvfaZECq+R+oZTMXzoWCVObiN+831v/ZE7dPqbNMSBmVDHDznmgQjIaZcF80
         DbgNwnHh+LuA3EHgAweI6pmmir7P1NHgymNtVNBQQWlypnpCZ27UdD5h4YOFmIpgGjKJ
         bshFBhtMcvXmKyOL1UgI8bURuYaux5ZQU9gUxnGIys2/Uzfi1iE84Wa9YQO783bR8pr0
         4w0A==
In-Reply-To: <20220426053904.3684293-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huacai Chen <chenhuacai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aleksandar Markovic <aleksandar.qemu.devel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anup Patel <anup-aa5cPYPs4nSSZfiimGR9Ow@public.gmane.org>, Atish Patra <atishp-WKKQYwWt7ev9JmXXK+q4OQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Shameer Kolothum <shameerali.kolothum.thodi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mips-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-riscv-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
KVM shadow page tables. This provides more insights on the kernel memory
used by a workload.

This stat will be used by subsequent patches to count KVM pagetable
pages usage.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/base/node.c    | 2 ++
 fs/proc/meminfo.c      | 2 ++
 include/linux/mmzone.h | 1 +
 mm/memcontrol.c        | 1 +
 mm/page_alloc.c        | 6 +++++-
 mm/vmstat.c            | 1 +
 6 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index ec8bb24a5a22..9fe716832546 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -433,6 +433,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     "Node %d ShadowCallStack:%8lu kB\n"
 #endif
 			     "Node %d PageTables:     %8lu kB\n"
+			     "Node %d SecPageTables:  %8lu kB\n"
 			     "Node %d NFS_Unstable:   %8lu kB\n"
 			     "Node %d Bounce:         %8lu kB\n"
 			     "Node %d WritebackTmp:   %8lu kB\n"
@@ -459,6 +460,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     nid, node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
 			     nid, K(node_page_state(pgdat, NR_PAGETABLE)),
+			     nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 			     nid, 0UL,
 			     nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
 			     nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 6fa761c9cc78..fad29024eb2e 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -108,6 +108,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #endif
 	show_val_kb(m, "PageTables:     ",
 		    global_node_page_state(NR_PAGETABLE));
+	show_val_kb(m, "SecPageTables:	",
+		    global_node_page_state(NR_SECONDARY_PAGETABLE));
 
 	show_val_kb(m, "NFS_Unstable:   ", 0);
 	show_val_kb(m, "Bounce:         ",
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 962b14d403e8..35f57f2578c0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -219,6 +219,7 @@ enum node_stat_item {
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
 #endif
 	NR_PAGETABLE,		/* used for pagetables */
+	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 725f76723220..89fbd1793960 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1388,6 +1388,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "kernel",			MEMCG_KMEM			},
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
+	{ "secondary_pagetables",	NR_SECONDARY_PAGETABLE		},
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
 	{ "vmalloc",			MEMCG_VMALLOC			},
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2db95780e003..96d00ae9d5c1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5932,7 +5932,8 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
 		" unevictable:%lu dirty:%lu writeback:%lu\n"
 		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
-		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+		" mapped:%lu shmem:%lu pagetables:%lu\n"
+		" secondary_pagetables:%lu bounce:%lu\n"
 		" kernel_misc_reclaimable:%lu\n"
 		" free:%lu free_pcp:%lu free_cma:%lu\n",
 		global_node_page_state(NR_ACTIVE_ANON),
@@ -5949,6 +5950,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		global_node_page_state(NR_FILE_MAPPED),
 		global_node_page_state(NR_SHMEM),
 		global_node_page_state(NR_PAGETABLE),
+		global_node_page_state(NR_SECONDARY_PAGETABLE),
 		global_zone_page_state(NR_BOUNCE),
 		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
 		global_zone_page_state(NR_FREE_PAGES),
@@ -5982,6 +5984,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			" shadow_call_stack:%lukB"
 #endif
 			" pagetables:%lukB"
+			" secondary_pagetables:%lukB"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -6007,6 +6010,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
+			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
 	}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b75b1a64b54c..50bbec73809b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1240,6 +1240,7 @@ const char * const vmstat_text[] = {
 	"nr_shadow_call_stack",
 #endif
 	"nr_page_table_pages",
+	"nr_secondary_page_table_pages",
 #ifdef CONFIG_SWAP
 	"nr_swapcached",
 #endif
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

