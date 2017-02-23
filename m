From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: [PATCH v2 2/2] mm/cgroup: delay soft limit data allocation
Date: Thu, 23 Feb 2017 14:36:39 +0100
Message-ID: <1487856999-16581-3-git-send-email-ldufour@linux.vnet.ibm.com>
References: <1487856999-16581-1-git-send-email-ldufour@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1487856999-16581-1-git-send-email-ldufour@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Balbir Singh <bsingharora@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Until a soft limit is set to a cgroup, the soft limit data are useless
so delay this allocation when a limit is set.

Suggested-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
---
 mm/memcontrol.c | 67 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a9f10fde44a6..c639c898809d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -142,7 +142,7 @@ struct mem_cgroup_tree {
 	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
 };
 
-static struct mem_cgroup_tree soft_limit_tree __read_mostly;
+static struct mem_cgroup_tree *soft_limit_tree __read_mostly;
 
 /* for OOM */
 struct mem_cgroup_eventfd_list {
@@ -381,10 +381,52 @@ mem_cgroup_page_nodeinfo(struct mem_cgroup *memcg, struct page *page)
 	return memcg->nodeinfo[nid];
 }
 
+static bool soft_limit_initialize(void)
+{
+	static DEFINE_MUTEX(soft_limit_mutex);
+	struct mem_cgroup_tree *tree;
+	bool ret = true;
+	int node;
+
+	mutex_lock(&soft_limit_mutex);
+	if (soft_limit_tree)
+		goto bail;
+
+	tree = kmalloc(sizeof(*soft_limit_tree), GFP_KERNEL);
+	if (!tree) {
+		ret = false;
+		goto bail;
+	}
+	for_each_node(node) {
+		struct mem_cgroup_tree_per_node *rtpn;
+
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
+				    node_online(node) ? node : NUMA_NO_NODE);
+		if (!rtpn)
+			goto cleanup;
+
+		rtpn->rb_root = RB_ROOT;
+		spin_lock_init(&rtpn->lock);
+		tree->rb_tree_per_node[node] = rtpn;
+	}
+	WRITE_ONCE(soft_limit_tree, tree);
+bail:
+	mutex_unlock(&soft_limit_mutex);
+	return ret;
+cleanup:
+	for_each_node(node)
+		kfree(tree->rb_tree_per_node[node]);
+	kfree(tree);
+	ret = false;
+	goto bail;
+}
+
 static struct mem_cgroup_tree_per_node *
 soft_limit_tree_node(int nid)
 {
-	return soft_limit_tree.rb_tree_per_node[nid];
+	if (!soft_limit_tree)
+		return NULL;
+	return soft_limit_tree->rb_tree_per_node[nid];
 }
 
 static struct mem_cgroup_tree_per_node *
@@ -392,7 +434,9 @@ soft_limit_tree_from_page(struct page *page)
 {
 	int nid = page_to_nid(page);
 
-	return soft_limit_tree.rb_tree_per_node[nid];
+	if (!soft_limit_tree)
+		return NULL;
+	return soft_limit_tree->rb_tree_per_node[nid];
 }
 
 static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
@@ -3003,6 +3047,10 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 		}
 		break;
 	case RES_SOFT_LIMIT:
+		if (!soft_limit_initialize()) {
+			ret = -ENOMEM;
+			break;
+		}
 		memcg->soft_limit = nr_pages;
 		ret = 0;
 		break;
@@ -5777,7 +5825,7 @@ __setup("cgroup.memory=", cgroup_memory);
  */
 static int __init mem_cgroup_init(void)
 {
-	int cpu, node;
+	int cpu;
 
 #ifndef CONFIG_SLOB
 	/*
@@ -5797,17 +5845,6 @@ static int __init mem_cgroup_init(void)
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
