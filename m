From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/2] memcg: use seq_buf_do_printk() with mem_cgroup_print_oom_meminfo()
Date: Fri, 28 Apr 2023 13:24:05 +0000
Message-ID: <20230428132406.2540811-2-yosryahmed@google.com>
References: <20230428132406.2540811-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682688252; x=1685280252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+FzrFpmnoCmeFQ217D+x4Ju8+C0DQecKfFykJdZXOk=;
        b=ahJ5tf1zjA7jhOV/9LiwCRyuWOWHRwEdLk7R0d3XMmILa09rKnfx5nny2uPly2tetM
         yQe3PTogi+hkDTWAyAo3/jS9Bq4LZKPSzrbVPycPHL0j37hx58O3J7vo7Edyyivmccmm
         18Pb9GBVLPvYnxrvGeLG3aEwVfIhh0fflwdlhi4SSOB7+PY4t+ZYcJNyWcYRam9KFuAA
         PmhzEKiIFCk0EIXEsZHJ8Nv/iwsB92yyqpsd4da+lc/aDt5ZKzGH3eSQwh3kWSWXQgsr
         XAdD201Y1DEr8SPDG9gavkbwwkpUB/LVYwXboCYPhs7zxuzM6GotdmSf09vq72UBrtAr
         SZ2w==
In-Reply-To: <20230428132406.2540811-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Currently, we format all the memcg stats into a buffer in
mem_cgroup_print_oom_meminfo() and use pr_info() to dump it to the logs.
However, this buffer is large in size. Although it is currently working
as intended, ther is a dependency between the memcg stats buffer and the
printk record size limit.

If we add more stats in the future and the buffer becomes larger than
the printk record size limit, or if the prink record size limit is
reduced, the logs may be truncated.

It is safer to use seq_buf_do_printk(), which will automatically break
up the buffer at line breaks and issue small printk() calls.

Refactor the code to move the seq_buf from memory_stat_format() to its
callers, and use seq_buf_do_printk() to print the seq_buf in
mem_cgroup_print_oom_meminfo().

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 mm/memcontrol.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abffe6f8389..5922940f92c9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1551,13 +1551,10 @@ static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg,
 	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
 }
 
-static void memory_stat_format(struct mem_cgroup *memcg, char *buf, int bufsize)
+static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
-	struct seq_buf s;
 	int i;
 
-	seq_buf_init(&s, buf, bufsize);
-
 	/*
 	 * Provide statistics on the state of the memory subsystem as
 	 * well as cumulative event counters that show past behavior.
@@ -1574,21 +1571,21 @@ static void memory_stat_format(struct mem_cgroup *memcg, char *buf, int bufsize)
 		u64 size;
 
 		size = memcg_page_state_output(memcg, memory_stats[i].idx);
-		seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
+		seq_buf_printf(s, "%s %llu\n", memory_stats[i].name, size);
 
 		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
 			size += memcg_page_state_output(memcg,
 							NR_SLAB_RECLAIMABLE_B);
-			seq_buf_printf(&s, "slab %llu\n", size);
+			seq_buf_printf(s, "slab %llu\n", size);
 		}
 	}
 
 	/* Accumulated memory events */
-	seq_buf_printf(&s, "pgscan %lu\n",
+	seq_buf_printf(s, "pgscan %lu\n",
 		       memcg_events(memcg, PGSCAN_KSWAPD) +
 		       memcg_events(memcg, PGSCAN_DIRECT) +
 		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
-	seq_buf_printf(&s, "pgsteal %lu\n",
+	seq_buf_printf(s, "pgsteal %lu\n",
 		       memcg_events(memcg, PGSTEAL_KSWAPD) +
 		       memcg_events(memcg, PGSTEAL_DIRECT) +
 		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
@@ -1598,13 +1595,13 @@ static void memory_stat_format(struct mem_cgroup *memcg, char *buf, int bufsize)
 		    memcg_vm_event_stat[i] == PGPGOUT)
 			continue;
 
-		seq_buf_printf(&s, "%s %lu\n",
+		seq_buf_printf(s, "%s %lu\n",
 			       vm_event_name(memcg_vm_event_stat[i]),
 			       memcg_events(memcg, memcg_vm_event_stat[i]));
 	}
 
 	/* The above should easily fit into one page */
-	WARN_ON_ONCE(seq_buf_has_overflowed(&s));
+	WARN_ON_ONCE(seq_buf_has_overflowed(s));
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
@@ -1642,6 +1639,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 {
 	/* Use static buffer, for the caller is holding oom_lock. */
 	static char buf[PAGE_SIZE];
+	struct seq_buf s;
 
 	lockdep_assert_held(&oom_lock);
 
@@ -1664,8 +1662,9 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 	pr_info("Memory cgroup stats for ");
 	pr_cont_cgroup_path(memcg->css.cgroup);
 	pr_cont(":");
-	memory_stat_format(memcg, buf, sizeof(buf));
-	pr_info("%s", buf);
+	seq_buf_init(&s, buf, sizeof(buf));
+	memory_stat_format(memcg, &s);
+	seq_buf_do_printk(&s, KERN_INFO);
 }
 
 /*
@@ -6573,10 +6572,12 @@ static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct seq_buf s;
 
 	if (!buf)
 		return -ENOMEM;
-	memory_stat_format(memcg, buf, PAGE_SIZE);
+	seq_buf_init(&s, buf, PAGE_SIZE);
+	memory_stat_format(memcg, &s);
 	seq_puts(m, buf);
 	kfree(buf);
 	return 0;
-- 
2.40.1.495.gc816e09b53d-goog

