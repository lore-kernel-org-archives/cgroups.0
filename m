From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] memcg, oom: Provide more info while memcg oom happening
Date: Wed, 25 Jul 2012 00:09:20 +0800
Message-ID: <1343146160-15012-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=ELZmIgx91GJVJs7KkUJsIIeZ8WsFBlggxajpxGeTZrA=;
        b=xSCNEOSijrNUdwTBQyXm+I0GxHtRU1akM48eXh378JAU2TxMcISzYq719hpVFz+X/a
         fwKuiwaxv8IOOchruU6EvfTyUoaiNDUYa22DCG8rRZ/ZTckt90UpQO9W+0XyTpebtzVm
         MeMIuDco5Tc2GiqySAR1HtPo69RAb4Da3hGnvWOVNNAtWgzUir+j4XKVaAmoot0Qda5X
         k+Gj2dsvZzLDxDOMZAe/WMy6OxXy9l1hesm7k+Op/zuYsnsDpT32U8IfaNAfW9FdQjIq
         rmgo0dOblqpy0V1hU8pFp95fE40/r7XHhvWd8U7oEWiA1xFuaNgjiqaq4K/H/+818d4W
         yWIg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

While memcg oom happening, the current memcg related dump information
is limited for debugging. This patch provides more detailed memcg page
statistics together with the total one while hierarchy is enabled.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Cc: kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org
Cc: gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
---
 mm/memcontrol.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b8a347a..a3037af 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -113,6 +113,14 @@ static const char * const mem_cgroup_events_names[] = {
 	"pgmajfault",
 };
 
+static const char * const mem_cgroup_lru_names[] = {
+	"inactive_anon",
+	"active_anon",
+	"inactive_file",
+	"active_file",
+	"unevictable",
+};
+
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
  * it will be incremated by the number of pages. This counter is used for
@@ -1372,6 +1380,59 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
 	spin_unlock_irqrestore(&memcg->move_lock, *flags);
 }
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
+{
+	int i;
+	struct mem_cgroup *mi;
+
+	printk(KERN_INFO "Memory cgroup stat:\n");
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
+		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
+			continue;
+		printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
+			   K(mem_cgroup_read_stat(memcg, i)));
+	}
+
+	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
+		printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
+			   mem_cgroup_read_events(memcg, i));
+
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
+			   K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
+
+	/* Dump the total statistics if hierarchy is enabled. */
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
+		long long val = 0;
+
+		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
+			continue;
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_read_stat(mi, i);
+		printk(KERN_CONT "total_%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
+	}
+
+	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
+		unsigned long long val = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_read_events(mi, i);
+		printk(KERN_CONT "total_%s:%llu ", mem_cgroup_events_names[i], val);
+	}
+
+	for (i = 0; i < NR_LRU_LISTS; i++) {
+		unsigned long long val = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_nr_lru_pages(mi, BIT(i));
+		printk(KERN_CONT "total_%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
+	}
+
+	printk(KERN_CONT "\n");
+
+}
+
 /**
  * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
  * @memcg: The memory cgroup that went over limit
@@ -1436,6 +1497,8 @@ done:
 		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
+
+	mem_cgroup_print_oom_stat(memcg);
 }
 
 /*
@@ -4129,14 +4192,6 @@ static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 }
 #endif /* CONFIG_NUMA */
 
-static const char * const mem_cgroup_lru_names[] = {
-	"inactive_anon",
-	"active_anon",
-	"inactive_file",
-	"active_file",
-	"unevictable",
-};
-
 static inline void mem_cgroup_lru_names_not_uptodate(void)
 {
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
-- 
1.7.1
