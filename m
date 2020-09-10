From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm: memcontrol: Add the missing numa stat of anon and file for cgroup v2
Date: Thu, 10 Sep 2020 16:42:58 +0800
Message-ID: <20200910084258.22293-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DydHZR1p/a4YgWod1jge5YOze1r87n8O9ViW1sroOHE=;
        b=fW03118K7OqoKHn0n/T5KvrtUYFGItUGF5N6guUzhftq5pe6S/cCuNZOc7HvKn8Eey
         IDNdM9hwsCF4NZkTkAwKmCSYy5a2dFlOA9lp46ncqkgd1q3DoUJBFxmUZUZt6kufBXDw
         pYTgoq8v1ApLaGpSc4X6a84Kaosdt95njNvvWGVCbOHsa7bfTKEnm+5pbShj746vZxEM
         b+3wSM92YFInqZYqb9WhPEDbL8IxDn5xD9kvQ3mFFAd9hJY0Ini76LCw7FtbXR+ymhl4
         VUof+fRcGtKEQQO3SOy6ZDwd0/xU/N2QLdSZhnFwnfuFkKPNnJZKNuYqkAsm/aEf/aXB
         rmLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

In the cgroup v1, we have a numa_stat interface. This is useful for
providing visibility into the numa locality information within an
memcg since the pages are allowed to be allocated from any physical
node. One of the use cases is evaluating application performance by
combining this information with the application's CPU allocation.
But the cgroup v2 does not. So this patch adds the missing information.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75cd1a1e66c8..c779673f29b2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1492,10 +1492,34 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
 	return false;
 }
 
+#ifdef CONFIG_NUMA
+static unsigned long memcg_node_page_state(struct mem_cgroup *memcg,
+					   unsigned int nid,
+					   enum node_stat_item idx)
+{
+	long x;
+	struct mem_cgroup_per_node *pn;
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+
+	VM_BUG_ON(nid >= nr_node_ids);
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	x = atomic_long_read(&pn->lruvec_stat[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+#endif
+
 static char *memory_stat_format(struct mem_cgroup *memcg)
 {
 	struct seq_buf s;
 	int i;
+#ifdef CONFIG_NUMA
+	int nid;
+#endif
 
 	seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);
 	if (!s.buffer)
@@ -1512,12 +1536,30 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 	 * Current memory state:
 	 */
 
-	seq_buf_printf(&s, "anon %llu\n",
+	seq_buf_printf(&s, "anon %llu",
 		       (u64)memcg_page_state(memcg, NR_ANON_MAPPED) *
 		       PAGE_SIZE);
-	seq_buf_printf(&s, "file %llu\n",
+#ifdef CONFIG_NUMA
+	for_each_node_state(nid, N_MEMORY)
+		seq_buf_printf(&s, " N%d=%llu", nid,
+			       (u64)memcg_node_page_state(memcg, nid,
+							  NR_ANON_MAPPED) *
+			       PAGE_SIZE);
+#endif
+	seq_buf_putc(&s, '\n');
+
+	seq_buf_printf(&s, "file %llu",
 		       (u64)memcg_page_state(memcg, NR_FILE_PAGES) *
 		       PAGE_SIZE);
+#ifdef CONFIG_NUMA
+	for_each_node_state(nid, N_MEMORY)
+		seq_buf_printf(&s, " N%d=%llu", nid,
+			       (u64)memcg_node_page_state(memcg, nid,
+							  NR_FILE_PAGES) *
+			       PAGE_SIZE);
+#endif
+	seq_buf_putc(&s, '\n');
+
 	seq_buf_printf(&s, "kernel_stack %llu\n",
 		       (u64)memcg_page_state(memcg, NR_KERNEL_STACK_KB) *
 		       1024);
-- 
2.20.1

