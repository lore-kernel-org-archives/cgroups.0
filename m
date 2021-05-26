From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC 1/7] mm: record total charge and max speed counter in memcg
Date: Thu, 27 May 2021 00:17:58 +0800
Message-ID: <b27011d3876380a42a90bd915bf92418fcd28cbb.1622043596.git.yuleixzhang@tencent.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I2yY93jGyxk0j6mMQAkrKvIdrjtR7nEE3GsplJyVGmI=;
        b=FEmPqKxQV3HhjO44HYJUnBkPVLVUQDooSH4pxJiZEdZpezaQyXuOCLoarDrgXVylit
         vVpm+airEP5ae8tIMo25tJRm1BpBjpfdX+JnZB7mOCiwzXxwHCaveXdhxDK0Yy+/nQo5
         LoJfAJi5ksqr09UxzhsLfMO2KfnX9+u3GLZR6hxy/plsZcRe+1z6OQkkYleVyulJMTIp
         xFfsTuaoGXSrVaLrrBHTCfGAmcpidbyLzsmcr5d51SGBzTrGylMmnUbB72/D5pEmmXOO
         k3Fp5gJ91tC5MZrpfDYIDrIlVhwRC+TcDdhGlsIbXZNBNxIyPJ1OX74ivQBzfrcY6CHw
         HV7Q==
In-Reply-To: <cover.1622043596.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Add max memory allocation speed counter and total charge
counter recording in memcg. Total charge page_counter aims to
count the total number of charged pages, which will be used to
do allocation speed throttle in following patches.

Max memory speed counter is used to record the memory alloction
burst, and to evaluate the performace of the memory speed
throttle(mst).

No lock used, we may live with the tiny inaccuracy.

Signed-off-by: Jiang Biao <benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/page_counter.h |  8 ++++++++
 init/Kconfig                 |  8 ++++++++
 mm/memcontrol.c              | 38 +++++++++++++++++++++++++++++++++++
 mm/page_counter.c            | 39 ++++++++++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 679591301994..b8286c8f6704 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -27,6 +27,14 @@ struct page_counter {
 	unsigned long watermark;
 	unsigned long failcnt;
 
+#ifdef CONFIG_MEM_SPEED_THROTTLE
+	/* allocation speed throttle */
+	atomic_long_t total_chg;
+	atomic_long_t mem_spd_max;
+	atomic_long_t prev_spd_jifs;
+	atomic_long_t prev_total_chg;
+#endif
+
 	/*
 	 * 'parent' is placed here to be far from 'usage' to reduce
 	 * cache false sharing, as 'usage' is written mostly while
diff --git a/init/Kconfig b/init/Kconfig
index 1ea12c64e4c9..1e44be0675a2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -921,6 +921,14 @@ config MEMCG_KMEM
 	depends on MEMCG && !SLOB
 	default y
 
+config MEM_SPEED_THROTTLE
+	bool "Memory allocation speed throttle for memcg"
+	depends on MEMCG
+	help
+	  This enables memory allocation speed throttle feature for memcg.
+	  It can be used to limit the memory allocation speed(bps) for memcg,
+	  and only works under memory pressure.
+
 config BLK_CGROUP
 	bool "IO controller"
 	depends on BLOCK
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 64ada9e650a5..7ef6aa088680 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1392,6 +1392,37 @@ static int memcg_page_state_unit(int item)
 	}
 }
 
+#ifdef CONFIG_MEM_SPEED_THROTTLE
+static unsigned long mem_cgroup_mst_get_mem_spd_max(struct mem_cgroup *memcg)
+{
+	struct page_counter *c = &memcg->memory;
+	unsigned long deadline;
+
+	/* Reset speed if it is too old */
+	deadline = atomic_long_read(&c->prev_spd_jifs) + 5 * HZ;
+	if (time_after(jiffies, deadline))
+		atomic_long_set(&c->mem_spd_max, 0);
+
+	/* Clear after read */
+	return atomic_long_xchg(&c->mem_spd_max, 0) << PAGE_SHIFT;
+}
+
+static void mem_cgroup_mst_show_mem_spd_max(struct mem_cgroup *memcg,
+					    struct seq_file *m)
+{
+	if (mem_cgroup_is_root(memcg))
+		return;
+
+	seq_printf(m, "mst_mem_spd_max %lu\n",
+		   mem_cgroup_mst_get_mem_spd_max(memcg));
+}
+#else /* CONFIG_MEM_SPEED_THROTTLE */
+static void mem_cgroup_mst_show_mem_spd_max(struct mem_cgroup *memcg,
+					    struct seq_file *m)
+{
+}
+#endif
+
 static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg,
 						    int item)
 {
@@ -1462,6 +1493,11 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 		       memcg_events(memcg, THP_COLLAPSE_ALLOC));
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#ifdef CONFIG_MEM_SPEED_THROTTLE
+	seq_buf_printf(&s, "mst_mem_spd_max %lu\n",
+		mem_cgroup_mst_get_mem_spd_max(memcg));
+#endif
+
 	/* The above should easily fit into one page */
 	WARN_ON_ONCE(seq_buf_has_overflowed(&s));
 
@@ -3909,6 +3945,8 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 	}
 #endif
 
+	mem_cgroup_mst_show_mem_spd_max(memcg, m);
+
 	return 0;
 }
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 7d83641eb86b..d5e2cf4daf4f 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -61,6 +61,39 @@ void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
 	propagate_protected_usage(counter, new);
 }
 
+#ifdef CONFIG_MEM_SPEED_THROTTLE
+static void mem_speed_update(struct page_counter *c, unsigned long nr_pages)
+{
+	unsigned long prev_jifs, chg, spd_max;
+	long delta_jifs, delta_chg;
+
+	chg = atomic_long_add_return(nr_pages, &c->total_chg);
+	prev_jifs = atomic_long_read(&c->prev_spd_jifs);
+
+	/* First time we get here? */
+	if (!prev_jifs)
+		goto done;
+
+	delta_jifs = jiffies - prev_jifs;
+	delta_chg = chg - atomic_long_read(&c->prev_total_chg);
+
+	if (delta_jifs <= HZ || delta_chg <= 0)
+		return;
+
+	spd_max = max(delta_chg * HZ / delta_jifs,
+			atomic_long_read(&c->mem_spd_max));
+	atomic_long_set(&c->mem_spd_max, spd_max);
+
+done:
+	atomic_long_set(&c->prev_spd_jifs, jiffies);
+	atomic_long_set(&c->prev_total_chg, chg);
+}
+#else
+static void mem_speed_update(struct page_counter *c, unsigned long nr_pages)
+{
+}
+#endif
+
 /**
  * page_counter_charge - hierarchically charge pages
  * @counter: counter
@@ -83,6 +116,9 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 		 */
 		if (new > READ_ONCE(c->watermark))
 			WRITE_ONCE(c->watermark, new);
+
+		/* Update mem speed max, maybe inaccurate due to races */
+		mem_speed_update(c, nr_pages);
 	}
 }
 
@@ -137,6 +173,9 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 */
 		if (new > READ_ONCE(c->watermark))
 			WRITE_ONCE(c->watermark, new);
+
+		/* Update mem speed max, maybe inaccurate due to races */
+		mem_speed_update(c, nr_pages);
 	}
 	return true;
 
-- 
2.28.0

