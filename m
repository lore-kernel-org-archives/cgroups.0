From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: [PATCH 2/2] mm/cgroup: delay soft limit data allocation
Date: Wed, 22 Feb 2017 16:58:11 +0100
Message-ID: <1487779091-31381-3-git-send-email-ldufour@linux.vnet.ibm.com>
References: <1487779091-31381-1-git-send-email-ldufour@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1487779091-31381-1-git-send-email-ldufour@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Until a soft limit is set to a cgroup, the soft limit data are useless
so delay this allocation when a limit is set.

Suggested-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
---
 mm/memcontrol.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 228ac44f77e1..bc2e6ab69c0c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -142,6 +142,8 @@ struct mem_cgroup_tree {
 	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
 };
 
+static DEFINE_MUTEX(soft_limit_mutex);
+static bool soft_limit_initialized;
 static struct mem_cgroup_tree soft_limit_tree __read_mostly;
 
 /* for OOM */
@@ -381,6 +383,36 @@ mem_cgroup_page_nodeinfo(struct mem_cgroup *memcg, struct page *page)
 	return memcg->nodeinfo[nid];
 }
 
+static void soft_limit_initialize(void)
+{
+	int node;
+
+	mutex_lock(&soft_limit_mutex);
+	if (soft_limit_initialized)
+		goto bail;
+
+	for_each_node(node) {
+		struct mem_cgroup_tree_per_node *rtpn;
+
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
+				    node_online(node) ? node : NUMA_NO_NODE);
+		/* Best effort, but should we warn if allocation failed */
+		if (rtpn) {
+			rtpn->rb_root = RB_ROOT;
+			spin_lock_init(&rtpn->lock);
+			/*
+			 * We don't want the compiler to set rb_tree_per_node
+			 * before rb_root and lock are initialized.
+			 */
+			WRITE_ONCE(soft_limit_tree.rb_tree_per_node[node],
+				   rtpn);
+		}
+	}
+	soft_limit_initialized = true;
+bail:
+	mutex_unlock(&soft_limit_mutex);
+}
+
 static struct mem_cgroup_tree_per_node *
 soft_limit_tree_node(int nid)
 {
@@ -465,6 +497,8 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
 	struct mem_cgroup_tree_per_node *mctz;
 
 	mctz = soft_limit_tree_from_page(page);
+	if (!mctz)
+		return;
 	/*
 	 * Necessary to update all ancestors when hierarchy is used.
 	 * because their event counter is not touched.
@@ -502,7 +536,8 @@ static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
 	for_each_node(nid) {
 		mz = mem_cgroup_nodeinfo(memcg, nid);
 		mctz = soft_limit_tree_node(nid);
-		mem_cgroup_remove_exceeded(mz, mctz);
+		if (mctz)
+			mem_cgroup_remove_exceeded(mz, mctz);
 	}
 }
 
@@ -3000,6 +3035,8 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 		}
 		break;
 	case RES_SOFT_LIMIT:
+		if (!soft_limit_initialized)
+			soft_limit_initialize();
 		memcg->soft_limit = nr_pages;
 		ret = 0;
 		break;
@@ -5774,7 +5811,7 @@ __setup("cgroup.memory=", cgroup_memory);
  */
 static int __init mem_cgroup_init(void)
 {
-	int cpu, node;
+	int cpu;
 
 #ifndef CONFIG_SLOB
 	/*
@@ -5794,17 +5831,6 @@ static int __init mem_cgroup_init(void)
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_stock);
 
-	for_each_node(node) {
-		struct mem_cgroup_tree_per_node *rtpn;
-
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
-				    node_online(node) ? node : NUMA_NO_NODE);
-
-		rtpn->rb_root = RB_ROOT;
-		spin_lock_init(&rtpn->lock);
-		soft_limit_tree.rb_tree_per_node[node] = rtpn;
-	}
-
 	return 0;
 }
 subsys_initcall(mem_cgroup_init);
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
