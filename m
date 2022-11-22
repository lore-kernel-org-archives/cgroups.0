From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v1 4/4] mm: Add nodes= arg to memory.demote
Date: Tue, 22 Nov 2022 12:38:48 -0800
Message-ID: <20221122203850.2765015-4-almasrymina@google.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BSER/B4DnSDEXzptnYVRvY0Bxd0pX06XJiUIMZfJs1c=;
        b=Q8CGtJa+O00lg9Tqtd2xc0jsOMGOiJJRQKDl+HbQ4+RJuR4NE+I2vLParTPRJyK9dV
         HeSYxODpIYH636a5cGLJjdX3SPGMLDqJjaFcJ39VsuEELq4DgDIZX//2wGqsFd51QSJ+
         AZM/FTrtKnbmUqDMcYElZ3IbHtiXrin84UOmwRdMpGISPBEI8woUDxAgbVU4ym/RyNK7
         VWuGFbedYwWGh89zIthlnJvT8GU/8qlI9jP4fZERGstjvqu1lGm4VzeB6c1hICq2esGq
         a6HaxwII49NO4LMfOWNuAy3MP55sIxndD9RIDojCzutzGpi9VdKps5EppZgBJUct3an9
         k1NA==
In-Reply-To: <20221122203850.2765015-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

The nodes= arg instructs the kernel to only scan the given nodes for
demotion. For example use cases, consider a 3 tier memory system:

nodes 0,1 -> top tier
nodes 2,3 -> second tier
nodes 4,5 -> third tier

echo "1m nodes=2,3" > memory.demote

This instructs the kernel to attempt to demote 1m memory in the second tier
to the third, which can be desirable according to the userspace policy
if the second tier is filling up and there is available memory on the
third tier.

echo "1m" > memory.demote

Instructs the kernel to attempt to demote 1m of memory (regardless of
which tier the memory is currently on).

echo "1m nodes=0,1"

Instructs the kernel to demote memory from the top tier nodes, which can
be desirable according to the userspace policy if there is pressure on
the top tiers.

Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/swap.h |  3 ++-
 mm/memcontrol.c      | 64 ++++++++++++++++++++++++++++++++++++--------
 mm/vmscan.c          |  4 ++-
 3 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index f768171c2dc2..e195ee5f8efb 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -425,7 +425,8 @@ extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
-						  unsigned int reclaim_options);
+						  unsigned int reclaim_options,
+						  nodemask_t nodemask);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 427c79e467eb..cce446348358 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
 #include <linux/seq_buf.h>
+#include <linux/parser.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -2392,7 +2393,8 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		psi_memstall_enter(&pflags);
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
-							MEMCG_RECLAIM_DEFAULT);
+							MEMCG_RECLAIM_DEFAULT,
+							NODE_MASK_ALL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2683,7 +2685,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,

 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options);
+						    gfp_mask, reclaim_options,
+						    NODE_MASK_ALL);
 	psi_memstall_leave(&pflags);

 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -3504,7 +3507,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,

 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
 					memsw ? MEMCG_RECLAIM_NO_SWAP :
-						MEMCG_RECLAIM_DEFAULT)) {
+						MEMCG_RECLAIM_DEFAULT,
+						NODE_MASK_ALL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -3615,7 +3619,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 			return -EINTR;

 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_DEFAULT))
+						  MEMCG_RECLAIM_DEFAULT,
+						  NODE_MASK_ALL))
 			nr_retries--;
 	}

@@ -6408,7 +6413,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}

 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_DEFAULT);
+					GFP_KERNEL, MEMCG_RECLAIM_DEFAULT,
+					NODE_MASK_ALL);

 		if (!reclaimed && !nr_retries--)
 			break;
@@ -6457,7 +6463,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,

 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_DEFAULT))
+					GFP_KERNEL, MEMCG_RECLAIM_DEFAULT,
+					NODE_MASK_ALL))
 				nr_reclaims--;
 			continue;
 		}
@@ -6612,7 +6619,8 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,

 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						nr_to_reclaim - nr_reclaimed,
-						GFP_KERNEL, reclaim_options);
+						GFP_KERNEL, reclaim_options,
+						NODE_MASK_ALL);

 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
@@ -6623,6 +6631,16 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 	return nbytes;
 }

+enum {
+	MEMORY_DEMOTE_NODES = 0,
+	MEMORY_DEMOTE_NULL,
+};
+
+static const match_table_t if_tokens = {
+	{ MEMORY_DEMOTE_NODES, "nodes=%s" },
+	{ MEMORY_DEMOTE_NULL, NULL },
+};
+
 static ssize_t memory_demote(struct kernfs_open_file *of, char *buf,
 			     size_t nbytes, loff_t off)
 {
@@ -6631,11 +6649,35 @@ static ssize_t memory_demote(struct kernfs_open_file *of, char *buf,
 	unsigned long nr_to_demote, nr_demoted = 0;
 	unsigned int reclaim_options = MEMCG_RECLAIM_ONLY_DEMOTE;
 	int err;
+	char *old_buf, *start;
+	substring_t args[MAX_OPT_ARGS];
+	int token;
+	char value[256];
+	nodemask_t nodemask = NODE_MASK_ALL;

 	buf = strstrip(buf);
-	err = page_counter_memparse(buf, "", &nr_to_demote);
-	if (err)
-		return err;
+	old_buf = buf;
+	nr_to_demote = memparse(buf, &buf) / PAGE_SIZE;
+	if (buf == old_buf)
+		return -EINVAL;
+
+	buf = strstrip(buf);
+
+	while ((start = strsep(&buf, " ")) != NULL) {
+		if (!strlen(start))
+			continue;
+		token = match_token(start, if_tokens, args);
+		match_strlcpy(value, args, sizeof(value));
+		switch (token) {
+		case MEMORY_DEMOTE_NODES:
+			err = nodelist_parse(value, nodemask);
+			if (err < 0)
+				return -EINVAL;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}

 	while (nr_demoted < nr_to_demote) {
 		unsigned long demoted;
@@ -6645,7 +6687,7 @@ static ssize_t memory_demote(struct kernfs_open_file *of, char *buf,

 		demoted = try_to_free_mem_cgroup_pages(
 			memcg, nr_to_demote - nr_demoted, GFP_KERNEL,
-			reclaim_options);
+			reclaim_options, nodemask);

 		if (!demoted && !nr_retries--)
 			return -EAGAIN;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d7e509b3f07f..df5ade259b3a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6719,7 +6719,8 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-					   unsigned int reclaim_options)
+					   unsigned int reclaim_options,
+					   nodemask_t nodemask)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6734,6 +6735,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.nodemask = &nodemask,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
