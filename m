From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC 3/7] mm: memory allocation speed throttle setup in hierarchy
Date: Thu, 27 May 2021 00:18:00 +0800
Message-ID: <5607e3530bc25307dd0e77bd73ae70fc6f33a146.1622043596.git.yuleixzhang@tencent.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7jHJGvj/WunXhmGaK7ypZOWSz/zhiqTHcN3tpdvjCAw=;
        b=ngG0ihAClNo2fzXIbvlPnBmLwfBE7y16n8auMPGCMtFfHMyTNpElOHxPpHVgcAzt5o
         1OUWctHEbMTDeUIIWIbodxS2MDIcXepDUjQuOesYx9I/ov4uoB01HtRiCsgyhp7YbPU+
         pojYfFVVqN0kKt23gxLlcKlyJgDGnFdlXXeoaNDTYPQ6f9PBDGDm1dZKyvZrzHG9KPN4
         l8syiplNm6BInR7jIy81nCUv0qNU1Hcq1V/eL/kWZV7HisyIaVyxVkY4MsAkQw2LPFVz
         c7OWb20kJiNYNXsD88lo1gBy4jJaTS1HaLoe4vc1ZrtZiCqpPEphwgkz/BPmriD7Eapc
         HnHg==
In-Reply-To: <cover.1622043596.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Init the memory allocation speed throttle parametersi to
make sure the throttle feature works in hierarchy structure.

Signed-off-by: Jiang Biao <benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 50 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4938397f321d..435515b1a709 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -233,6 +233,7 @@ struct obj_cgroup {
 #ifdef CONFIG_MEM_SPEED_THROTTLE
 struct mem_spd_ctl {
 	unsigned long mem_spd_lmt;
+	int has_lmt;
 };
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d59abe15d89d..9d7a86f7f51c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1393,6 +1393,35 @@ static int memcg_page_state_unit(int item)
 }
 
 #ifdef CONFIG_MEM_SPEED_THROTTLE
+static void mem_cgroup_mst_msc_reset(struct mem_cgroup *memcg)
+{
+	struct mem_spd_ctl *msc;
+
+	if (mem_cgroup_is_root(memcg))
+		return;
+
+	msc = &memcg->msc;
+	msc->has_lmt = 0;
+	msc->mem_spd_lmt = 0;
+}
+
+static void mem_cgroup_mst_has_lmt_init(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *iter = memcg;
+	struct cgroup_subsys_state *css = &memcg->css;
+
+	rcu_read_lock();
+	while (!mem_cgroup_is_root(iter)) {
+		if (iter->msc.mem_spd_lmt != 0) {
+			memcg->msc.has_lmt = 1;
+			return;
+		}
+		css = css->parent;
+		iter = mem_cgroup_from_css(css);
+	}
+	rcu_read_unlock();
+}
+
 static u64 mem_cgroup_mem_spd_lmt_read(struct cgroup_subsys_state *css,
 				       struct cftype *cft)
 {
@@ -1404,7 +1433,7 @@ static u64 mem_cgroup_mem_spd_lmt_read(struct cgroup_subsys_state *css,
 static int mem_cgroup_mem_spd_lmt_write(struct cgroup_subsys_state *css,
 					struct cftype *cft, u64 val)
 {
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg, *iter;
 	unsigned long lmt;
 
 	memcg = mem_cgroup_from_css(css);
@@ -1412,6 +1441,14 @@ static int mem_cgroup_mem_spd_lmt_write(struct cgroup_subsys_state *css,
 
 	memcg->msc.mem_spd_lmt = lmt;
 
+	/* Sync with mst_has_lmt_init*/
+	synchronize_rcu();
+
+	if (lmt) {
+		for_each_mem_cgroup_tree(iter, memcg)
+			iter->msc.has_lmt = 1;
+	}
+
 	return 0;
 }
 
@@ -1439,6 +1476,14 @@ static void mem_cgroup_mst_show_mem_spd_max(struct mem_cgroup *memcg,
 		   mem_cgroup_mst_get_mem_spd_max(memcg));
 }
 #else /* CONFIG_MEM_SPEED_THROTTLE */
+static void mem_cgroup_mst_has_lmt_init(struct mem_cgroup *memcg)
+{
+}
+
+static void mem_cgroup_mst_msc_reset(struct mem_cgroup *memcg)
+{
+}
+
 static void mem_cgroup_mst_show_mem_spd_max(struct mem_cgroup *memcg,
 					    struct seq_file *m)
 {
@@ -5198,6 +5243,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	/* Online state pins memcg ID, memcg ID pins CSS */
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
+	mem_cgroup_mst_has_lmt_init(memcg);
+
 	return 0;
 }
 
@@ -5287,6 +5334,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
+	mem_cgroup_mst_msc_reset(memcg);
 }
 
 static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
-- 
2.28.0

