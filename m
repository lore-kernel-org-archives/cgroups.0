From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] memcg: print more detailed info while memcg oom happening
Date: Thu, 28 Jun 2012 19:06:49 +0800
Message-ID: <1340881609-5935-1-git-send-email-handai.szj@taobao.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=0U09jn4dIFa5ecnqshWsmDmVto8gDhv8PLMhdCjxne4=;
        b=HaOuDHVPOG0w3pgZY/pw7G/L9PmAqKlxxH0FsVVm1ywKgJ2iVc08tzko7CrsX5Md+o
         LlYXUiR5DiEFMIgQmGTxuo2RGP5r+V0o8tyBT2d0lH0b1wKiEPZ2QwXYWutYoGtTKQsc
         mPSTETvdii87aWNSTjE0tOmHT/xU42wu82evx4QvPVx5DWJpWEpDHmAouGmU9Q+0hRo9
         1+sY88Q9iGiOVezX2/cnLgPm4Upu213FVAv4wXP6U5fU4bFumBzRS4iB2LrmgmL/IjqG
         o2E1ASw1vuMUKEiRWAjrXWESGWkdCCojI0HEg/lNjSBkgpfd4+26f6iA6EETg6SeMwtV
         fxYQ==
In-Reply-To: <1340880885-5427-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

While memcg oom happening, the dump info is limited, so add this
to provide memcg page stat.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c |   42 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8493119..3ed41e9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -101,6 +101,14 @@ static const char * const mem_cgroup_events_names[] = {
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
@@ -1358,6 +1366,30 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
 	spin_unlock_irqrestore(&memcg->move_lock, *flags);
 }
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
+{
+	int i;
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
+	printk(KERN_CONT "\n");
+
+}
+
 /**
  * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
  * @memcg: The memory cgroup that went over limit
@@ -1422,6 +1454,8 @@ done:
 		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
+
+	mem_cgroup_print_oom_stat(memcg);
 }
 
 /*
@@ -4043,14 +4077,6 @@ static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
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
