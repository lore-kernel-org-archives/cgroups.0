From: Huan Yang <link-DGpbCiVdSXo@public.gmane.org>
Subject: [PATCH 2/3] mm: memcg: add per memcg "lru_gen" node
Date: Thu, 14 Sep 2023 18:47:44 +0800
Message-ID: <20230914104754.55-3-link@vivo.com>
References: <20230914104754.55-1-link@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33kzHFfosaT3/g9ZykY5vCyTfSUp4+rL/3ljfHikklM=;
 b=fykUqdvv0ARCGvduwSmSyeZieb4iagXe1y8y8SWrC93GOlWmcTPIVdT3h1JGsGVWawaUcL2YDcvPxY5ABwmlT0eDLsQaNUdlQ4EyDsFs77ZsT1Xv91xapLeirUrUKRfwJPRAU+zcSbDel+AsX7O3JEGWmnhnMAXOmKxqbfdCcgC9xtSQQb42gKnaWxhepmI0fufkOtJB1q03k+3BvYATibcoLLmlO+dKF3CAh5gjSSp1vlXy64uh7g8rJQI65nkZk/Dih3DYUQbtF11QbfedSeJgKmU7nLkEqNINplhMxi0GuA9bJE3T+MC/bkqtOeS+XL1s1QgRYJLzcJBDLG/76w==
In-Reply-To: <20230914104754.55-1-link-DGpbCiVdSXo@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Jan Alexander Steffens (heftig)" <heftig-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huan Yang <link-DGpbCiVdSXo@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Axel Rasmussen <axelrasmussen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Alumbaugh" <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm@kvac
Cc: kernel-DGpbCiVdSXo@public.gmane.org

This patch add "lru_gen" node in mem cgroup both in v1 and v2.

mem_cgroup_lru_gen_show just like global node, show lru_gen info,
but always show the full info due to per memcg no need to simple output.

Just like global node, per memcg "lru_gen" node can input cmd, but we
no need to type memcgid anymore to select one memcg.

Signed-off-by: Huan Yang <link-DGpbCiVdSXo@public.gmane.org>
---
 include/linux/mmzone.h |   4 +-
 mm/memcontrol.c        | 163 +++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c            |  37 ++++++++++
 3 files changed, 203 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4106fbc5b4b3..3d399ef177a4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -553,7 +553,9 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
 void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
-
+int mem_cgroup_lru_gen_cmd(char cmd, struct mem_cgroup *memcg, int nid,
+			   unsigned long seq, int swappiness,
+			   unsigned long opt);
 #else /* !CONFIG_MEMCG */
 
 #define MEMCG_NR_GENS	1
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ecc07b47e813..56385142c5b8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5052,6 +5052,155 @@ static int mem_cgroup_slab_show(struct seq_file *m, void *p)
 
 static int memory_stat_show(struct seq_file *m, void *v);
 
+#ifdef CONFIG_LRU_GEN
+static ssize_t mem_cgroup_lru_gen_write(struct kernfs_open_file *of, char *buf,
+					size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int n;
+	int end;
+	char cmd;
+	unsigned int nid;
+	unsigned long seq;
+	unsigned int swappiness = -1;
+	unsigned long opt = -1;
+	int ret;
+
+	buf = strstrip(buf);
+	n = sscanf(buf, "%c %u %lu %n %u %n %lu %n", &cmd, &nid, &seq, &end,
+		   &swappiness, &end, &opt, &end);
+	if (n < 3 || buf[end])
+		return -EINVAL;
+
+	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
+		return -EINVAL;
+
+	ret = mem_cgroup_lru_gen_cmd(cmd, memcg, nid, seq, swappiness, opt);
+	if (ret)
+		return ret;
+
+	return nbytes;
+}
+
+static void __lru_gen_show_info_full(struct seq_file *m, struct lruvec *lruvec,
+				  unsigned long max_seq, unsigned long *min_seq,
+				  unsigned long seq)
+{
+	int i;
+	int type, tier;
+	int hist = lru_hist_from_seq(seq);
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+
+	for (tier = 0; tier < MAX_NR_TIERS; tier++) {
+		seq_printf(m, "            %10d", tier);
+		for (type = 0; type < ANON_AND_FILE; type++) {
+			const char *s = "   ";
+			unsigned long n[3] = {};
+
+			if (seq == max_seq) {
+				s = "RT ";
+				n[0] = READ_ONCE(lrugen->avg_refaulted[type][tier]);
+				n[1] = READ_ONCE(lrugen->avg_total[type][tier]);
+			} else if (seq == min_seq[type] || NR_HIST_GENS > 1) {
+				s = "rep";
+				n[0] = atomic_long_read(&lrugen->refaulted[hist][type][tier]);
+				n[1] = atomic_long_read(&lrugen->evicted[hist][type][tier]);
+				if (tier)
+					n[2] = READ_ONCE(lrugen->protected[hist][type][tier - 1]);
+			}
+
+			for (i = 0; i < 3; i++)
+				seq_printf(m, " %10lu%c", n[i], s[i]);
+		}
+		seq_putc(m, '\n');
+	}
+
+	seq_puts(m, "                      ");
+	for (i = 0; i < NR_MM_STATS; i++) {
+		const char *s = "      ";
+		unsigned long n = 0;
+
+		if (seq == max_seq && NR_HIST_GENS == 1) {
+			s = "LOYNFA";
+			n = READ_ONCE(lruvec->mm_state.stats[hist][i]);
+		} else if (seq != max_seq && NR_HIST_GENS > 1) {
+			s = "loynfa";
+			n = READ_ONCE(lruvec->mm_state.stats[hist][i]);
+		}
+
+		seq_printf(m, " %10lu%c", n, s[i]);
+	}
+	seq_putc(m, '\n');
+}
+
+
+static int __lru_gen_show_info(struct seq_file *m, struct mem_cgroup *memcg, int nid)
+{
+	unsigned long seq;
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	DEFINE_MAX_SEQ(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+	char *path = kvmalloc(PATH_MAX, GFP_KERNEL);
+
+	if (unlikely(!path))
+		return -ENOMEM;
+
+	if (nid == first_memory_node) {
+		cgroup_path(memcg->css.cgroup, path, PATH_MAX);
+		seq_printf(m, "memcg %5u %s\n", mem_cgroup_id(memcg), path);
+	}
+
+	seq_printf(m, " node %5d\n", nid);
+
+	if (max_seq >= MAX_NR_GENS)
+		seq = max_seq - MAX_NR_GENS + 1;
+	else
+		seq = 0;
+
+	for (; seq <= max_seq; seq++) {
+		int type, zone;
+		int gen = lru_gen_from_seq(seq);
+		unsigned long birth = READ_ONCE(lrugen->timestamps[gen]);
+
+		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
+
+		for (type = 0; type < ANON_AND_FILE; type++) {
+			unsigned long size = 0;
+			char mark = seq < min_seq[type] ? 'x' : ' ';
+
+			for (zone = 0; zone < MAX_NR_ZONES; zone++)
+				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+			seq_printf(m, " %10lu%c", size, mark);
+		}
+
+		seq_putc(m, '\n');
+
+
+		__lru_gen_show_info_full(m, lruvec, max_seq, min_seq, seq);
+	}
+
+	kvfree(path);
+
+	return 0;
+}
+
+static int mem_cgroup_lru_gen_show(struct seq_file *m, void *v)
+{
+	int nid, ret;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for_each_node_state(nid, N_MEMORY) {
+		ret = __lru_gen_show_info(m, memcg, nid);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+#endif
+
 static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -5172,6 +5321,13 @@ static struct cftype mem_cgroup_legacy_files[] = {
 		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+#ifdef CONFIG_LRU_GEN
+	{
+		.name = "lru_gen",
+		.write = mem_cgroup_lru_gen_write,
+		.seq_show = mem_cgroup_lru_gen_show,
+	},
+#endif
 	{ },	/* terminate */
 };
 
@@ -6831,6 +6987,13 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NS_DELEGATABLE,
 		.write = memory_reclaim,
 	},
+#ifdef CONFIG_LRU_GEN
+	{
+		.name = "lru_gen",
+		.write = mem_cgroup_lru_gen_write,
+		.seq_show = mem_cgroup_lru_gen_show,
+	},
+#endif
 	{ }	/* terminate */
 };
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f59977964e81..4da200cda0b9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6072,6 +6072,43 @@ static int __process_one_cmd(char cmd, struct lruvec *lruvec, unsigned long seq,
 	return err;
 }
 
+#ifdef CONFIG_MEMCG
+int mem_cgroup_lru_gen_cmd(char cmd, struct mem_cgroup *memcg, int nid,
+			   unsigned long seq, int swappiness, unsigned long opt)
+{
+	int err;
+	struct lruvec *lruvec;
+	unsigned int flags;
+	struct blk_plug plug;
+	struct scan_control sc = {
+		.may_writepage = true,
+		.may_unmap = true,
+		.may_swap = true,
+		.reclaim_idx = MAX_NR_ZONES - 1,
+		.gfp_mask = GFP_KERNEL,
+	};
+
+	set_task_reclaim_state(current, &sc.reclaim_state);
+	flags = memalloc_noreclaim_save();
+	blk_start_plug(&plug);
+	if (!set_mm_walk(NULL, true)) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	lruvec = get_lruvec(memcg, nid);
+	err = __process_one_cmd(cmd, lruvec, seq, &sc, swappiness, opt);
+
+done:
+	clear_mm_walk();
+	blk_finish_plug(&plug);
+	memalloc_noreclaim_restore(flags);
+	set_task_reclaim_state(current, NULL);
+
+	return err;
+}
+#endif
+
 static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
 		   struct scan_control *sc, int swappiness, unsigned long opt)
 {
-- 
2.34.1

