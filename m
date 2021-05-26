From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC 2/7] mm: introduce alloc_bps to memcg for memory allocation speed throttle
Date: Thu, 27 May 2021 00:17:59 +0800
Message-ID: <6633783bc0900ce095ff75dbe603946ee900d5fb.1622043596.git.yuleixzhang@tencent.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=afnfUzVttge2WkHYKcBQlzvu8O2ytUcvyB9H4FdbWXU=;
        b=X3GhEbmocCb8p8S0ucrVTE84kBDM82YugbsYUoQHT19gsMXNTUyAMtLprQNzuYGWCE
         x0rE9FbyR+KdNisBlcRGT/JR7W7L0eOgvaVvOxTQRHpNIwqDUl199S5Vc/5YR2PxMnKB
         PjGa4KOTAqtb3o8ScD87ijaVHRfi9CrvmYOpxeeGbL4RbEd6HdIpigI6f5tawGg19AP7
         sCfzlWOSYzOGpZc9KaySf1qRcdSXWWuJAiOsin2gZGjdHPV0P5myN3xRj8NaBUndOPQU
         J5VkPv5Qns4/N2i6EdqWtNs42u1gE42yqpKpmf4vzA9Ae0bmkmmMhcUZ6GCwBg+2/Ara
         X/Lw==
In-Reply-To: <cover.1622043596.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Add read/write attribute memory.alloc_bps to configure the allowable
memory allocation speed of the memory cgroup in bytes.

Signed-off-by: Jiang Biao <benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/memcontrol.h | 10 ++++++++++
 mm/memcontrol.c            | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c193be760709..4938397f321d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -230,6 +230,12 @@ struct obj_cgroup {
 	};
 };
 
+#ifdef CONFIG_MEM_SPEED_THROTTLE
+struct mem_spd_ctl {
+	unsigned long mem_spd_lmt;
+};
+#endif
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -349,6 +355,10 @@ struct mem_cgroup {
 	struct deferred_split deferred_split_queue;
 #endif
 
+#ifdef CONFIG_MEM_SPEED_THROTTLE
+	struct mem_spd_ctl msc;
+#endif
+
 	struct mem_cgroup_per_node *nodeinfo[0];
 	/* WARNING: nodeinfo must be the last member here */
 };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ef6aa088680..d59abe15d89d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1393,6 +1393,28 @@ static int memcg_page_state_unit(int item)
 }
 
 #ifdef CONFIG_MEM_SPEED_THROTTLE
+static u64 mem_cgroup_mem_spd_lmt_read(struct cgroup_subsys_state *css,
+				       struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)(memcg->msc.mem_spd_lmt << PAGE_SHIFT);
+}
+
+static int mem_cgroup_mem_spd_lmt_write(struct cgroup_subsys_state *css,
+					struct cftype *cft, u64 val)
+{
+	struct mem_cgroup *memcg;
+	unsigned long lmt;
+
+	memcg = mem_cgroup_from_css(css);
+	lmt = val >> PAGE_SHIFT;
+
+	memcg->msc.mem_spd_lmt = lmt;
+
+	return 0;
+}
+
 static unsigned long mem_cgroup_mst_get_mem_spd_max(struct mem_cgroup *memcg)
 {
 	struct page_counter *c = &memcg->memory;
@@ -4805,6 +4827,14 @@ static struct cftype mem_cgroup_legacy_files[] = {
 		.write_u64 = mem_cgroup_hierarchy_write,
 		.read_u64 = mem_cgroup_hierarchy_read,
 	},
+#ifdef CONFIG_MEM_SPEED_THROTTLE
+	{
+		.name = "alloc_bps",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = mem_cgroup_mem_spd_lmt_read,
+		.write_u64 = mem_cgroup_mem_spd_lmt_write,
+	},
+#endif
 	{
 		.name = "cgroup.event_control",		/* XXX: for compat */
 		.write = memcg_write_event_control,
@@ -6358,6 +6388,14 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_oom_group_show,
 		.write = memory_oom_group_write,
 	},
+#ifdef CONFIG_MEM_SPEED_THROTTLE
+	{
+		.name = "alloc_bps",
+		.write_u64 = mem_cgroup_mem_spd_lmt_write,
+		.read_u64 = mem_cgroup_mem_spd_lmt_read,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+#endif
 	{ }	/* terminate */
 };
 
-- 
2.28.0

