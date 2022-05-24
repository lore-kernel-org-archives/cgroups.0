From: hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] mm: memcontrol: add the mempolicy interface for cgroup v2.
Date: Tue, 24 May 2022 18:36:38 +0800
Message-ID: <20220524103638.473-1-hezhongkun.hzk@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mv0h03Fi/OtxPp/Z+fPoItRmuRgY3cwaQPU9funRX9c=;
        b=XSkF/bmPvGekW75aBNlxtn4mVjVNuZkS8BypyCMs1G5idGF4Ty3XbFkec8vlHBZMaj
         zZwD2LVcBdYOOHEDFY9XAoWlv78XpR6SeHp/n21hGalRs7qtlO8pDMhAQzN6/Sm7kUfI
         aiBO9h/VWkiDCNG8a5iZDWtmuNe/raMvjMRrCW9B4u8ZWES3W7Fdd2QnMvwP02HDxhRl
         yR+gXercw+VgwdzFpA171XoYDBJ4URP3bB0ZcxwNifVs6zwanO703O+XCetzwpoBPHl5
         1sxVk7U579O7sNBv8XzyWH3IHvyjibFJeXc8o4euBduT94QIJ6oZN+m0+ssKCU/X9GmZ
         j1jg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

From: Hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Mempolicy is difficult to use because it is set in-process
via a system call. We want to make it easier to use mempolicy
in cgroups, so that we can control low-priority cgroups to
allocate memory in specified nodes. So this patch want to
adds the mempolicy interface.

the mempolicy priority of memcgroup is higher than the priority
of task. The order of getting the policy is,
memcgroup->policy,task->policy or vma policy, default policy.
memcgroup's policy is owned by itself, so descendants will
not inherit it.

Signed-off-by: Hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 42 ++++++++++++++++++++++++++++++++++++++
 mm/mempolicy.c             | 30 ++++++++++++++++++++++-----
 3 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 89b14729d59f..2261eeb6100c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -343,6 +343,7 @@ struct mem_cgroup {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	struct deferred_split deferred_split_queue;
 #endif
+	struct mempolicy *mempolicy;
 
 	struct mem_cgroup_per_node *nodeinfo[];
 };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 598fece89e2b..38108fd4df64 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6332,6 +6332,42 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 
 	return 0;
 }
+
+static int memory_policy_show(struct seq_file *m, void *v)
+{
+	char buffer[64];
+	struct mempolicy *mpol = mem_cgroup_from_seq(m)->mempolicy;
+
+	memset(buffer, 0, sizeof(buffer));
+
+	if (!mpol || mpol->mode == MPOL_DEFAULT)
+		return 0;
+
+	mpol_to_str(buffer, sizeof(buffer), mpol);
+	seq_printf(m, buffer);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static ssize_t memory_policy_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	int err = 1;
+	struct mempolicy *mpol, *old;
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+
+	old = memcg->mempolicy;
+	buf = strstrip(buf);
+	err = mpol_parse_str(buf, &mpol);
+
+	if (err)
+		goto out;
+	mpol_put(old);
+	memcg->mempolicy = mpol;
+out:
+	return nbytes;
+}
+
 #endif
 
 static int memory_oom_group_show(struct seq_file *m, void *v)
@@ -6416,6 +6452,12 @@ static struct cftype memory_files[] = {
 		.name = "numa_stat",
 		.seq_show = memory_numa_stat_show,
 	},
+	{
+		.name = "policy",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_policy_show,
+		.write = memory_policy_write,
+	},
 #endif
 	{
 		.name = "oom.group",
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8c74107a2b15..5153b046f8c3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -176,6 +176,16 @@ struct mempolicy *get_task_policy(struct task_struct *p)
 	return &default_policy;
 }
 
+struct mempolicy *get_cgrp_or_task_policy(struct task_struct *p)
+{
+	struct mempolicy *pol;
+	struct mem_cgroup *memcg = mem_cgroup_from_task(p);
+
+	pol = (memcg && memcg->mempolicy) ? memcg->mempolicy : get_task_policy(p);
+	return pol;
+}
+
+
 static const struct mempolicy_operations {
 	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
 	void (*rebind)(struct mempolicy *pol, const nodemask_t *nodes);
@@ -1782,6 +1792,16 @@ static struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 	return pol;
 }
 
+static struct mempolicy *get_cgrp_or_vma_policy(struct vm_area_struct *vma,
+						unsigned long addr)
+{
+	struct mempolicy *pol;
+	struct mem_cgroup *memcg = mem_cgroup_from_task(current);
+
+	pol = (memcg && memcg->mempolicy) ? memcg->mempolicy : get_vma_policy(vma, addr);
+	return pol;
+}
+
 bool vma_policy_mof(struct vm_area_struct *vma)
 {
 	struct mempolicy *pol;
@@ -1896,7 +1916,7 @@ unsigned int mempolicy_slab_node(void)
 	if (!in_task())
 		return node;
 
-	policy = current->mempolicy;
+	policy = get_cgrp_or_task_policy(current);
 	if (!policy)
 		return node;
 
@@ -2005,7 +2025,7 @@ int huge_node(struct vm_area_struct *vma, unsigned long addr, gfp_t gfp_flags,
 	int nid;
 	int mode;
 
-	*mpol = get_vma_policy(vma, addr);
+	*mpol = get_cgrp_or_vma_policy(vma, addr);
 	*nodemask = NULL;
 	mode = (*mpol)->mode;
 
@@ -2158,7 +2178,7 @@ struct page *alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 	int preferred_nid;
 	nodemask_t *nmask;
 
-	pol = get_vma_policy(vma, addr);
+	pol = get_cgrp_or_vma_policy(vma, addr);
 
 	if (pol->mode == MPOL_INTERLEAVE) {
 		unsigned nid;
@@ -2257,7 +2277,7 @@ struct page *alloc_pages(gfp_t gfp, unsigned order)
 	struct page *page;
 
 	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
-		pol = get_task_policy(current);
+		pol = get_cgrp_or_task_policy(current);
 
 	/*
 	 * No reference counting needed for current->mempolicy
@@ -2562,7 +2582,7 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 	int polnid = NUMA_NO_NODE;
 	int ret = NUMA_NO_NODE;
 
-	pol = get_vma_policy(vma, addr);
+	pol = get_cgrp_or_vma_policy(vma, addr);
 	if (!(pol->flags & MPOL_F_MOF))
 		goto out;
 
-- 
2.17.1

