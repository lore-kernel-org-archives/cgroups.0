From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: use new hashtable implementation
Date: Tue, 8 Jan 2013 15:51:45 +0800
Message-ID: <50EBD011.7040801@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Switch cgroup to use the new hashtable implementation. No functional changes.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 92 ++++++++++++++++++++++++---------------------------------
 1 file changed, 39 insertions(+), 53 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4855892..d8df073 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -52,7 +52,7 @@
 #include <linux/module.h>
 #include <linux/delayacct.h>
 #include <linux/cgroupstats.h>
-#include <linux/hash.h>
+#include <linux/hashtable.h>
 #include <linux/namei.h>
 #include <linux/pid_namespace.h>
 #include <linux/idr.h>
@@ -376,22 +376,18 @@ static int css_set_count;
  * account cgroups in empty hierarchies.
  */
 #define CSS_SET_HASH_BITS	7
-#define CSS_SET_TABLE_SIZE	(1 << CSS_SET_HASH_BITS)
-static struct hlist_head css_set_table[CSS_SET_TABLE_SIZE];
+static DEFINE_HASHTABLE(css_set_table, CSS_SET_HASH_BITS);
 
-static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
+static unsigned long css_set_hash(struct cgroup_subsys_state *css[])
 {
 	int i;
-	int index;
-	unsigned long tmp = 0UL;
+	unsigned long key = 0UL;
 
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
-		tmp += (unsigned long)css[i];
-	tmp = (tmp >> 16) ^ tmp;
+		key += (unsigned long)css[i];
+	key = (key >> 16) ^ key;
 
-	index = hash_long(tmp, CSS_SET_HASH_BITS);
-
-	return &css_set_table[index];
+	return key;
 }
 
 /* We don't maintain the lists running through each css_set to its
@@ -418,7 +414,7 @@ static void __put_css_set(struct css_set *cg, int taskexit)
 	}
 
 	/* This css_set is dead. unlink it and release cgroup refcounts */
-	hlist_del(&cg->hlist);
+	hash_del(&cg->hlist);
 	css_set_count--;
 
 	list_for_each_entry_safe(link, saved_link, &cg->cg_links,
@@ -550,9 +546,9 @@ static struct css_set *find_existing_css_set(
 {
 	int i;
 	struct cgroupfs_root *root = cgrp->root;
-	struct hlist_head *hhead;
 	struct hlist_node *node;
 	struct css_set *cg;
+	unsigned long key;
 
 	/*
 	 * Build the set of subsystem state objects that we want to see in the
@@ -572,8 +568,8 @@ static struct css_set *find_existing_css_set(
 		}
 	}
 
-	hhead = css_set_hash(template);
-	hlist_for_each_entry(cg, node, hhead, hlist) {
+	key = css_set_hash(template);
+	hash_for_each_possible(css_set_table, cg, node, hlist, key) {
 		if (!compare_css_sets(cg, oldcg, cgrp, template))
 			continue;
 
@@ -657,8 +653,8 @@ static struct css_set *find_css_set(
 
 	struct list_head tmp_cg_links;
 
-	struct hlist_head *hhead;
 	struct cg_cgroup_link *link;
+	unsigned long key;
 
 	/* First see if we already have a cgroup group that matches
 	 * the desired set */
@@ -704,8 +700,8 @@ static struct css_set *find_css_set(
 	css_set_count++;
 
 	/* Add this cgroup group to the hash table */
-	hhead = css_set_hash(res->subsys);
-	hlist_add_head(&res->hlist, hhead);
+	key = css_set_hash(res->subsys);
+	hash_add(css_set_table, &res->hlist, key);
 
 	write_unlock(&css_set_lock);
 
@@ -1597,6 +1593,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		struct cgroupfs_root *existing_root;
 		const struct cred *cred;
 		int i;
+		struct hlist_node *node;
+		struct css_set *cg;
 
 		BUG_ON(sb->s_root != NULL);
 
@@ -1650,14 +1648,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		/* Link the top cgroup in this hierarchy into all
 		 * the css_set objects */
 		write_lock(&css_set_lock);
-		for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
-			struct hlist_head *hhead = &css_set_table[i];
-			struct hlist_node *node;
-			struct css_set *cg;
-
-			hlist_for_each_entry(cg, node, hhead, hlist)
-				link_css_set(&tmp_cg_links, cg, root_cgrp);
-		}
+		hash_for_each(css_set_table, i, node, cg, hlist)
+			link_css_set(&tmp_cg_links, cg, root_cgrp);
 		write_unlock(&css_set_lock);
 
 		free_cg_links(&tmp_cg_links);
@@ -4438,6 +4430,9 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 {
 	struct cgroup_subsys_state *css;
 	int i, ret;
+	struct hlist_node *node, *tmp;
+	struct css_set *cg;
+	unsigned long key;
 
 	/* check name and function validity */
 	if (ss->name == NULL || strlen(ss->name) > MAX_CGROUP_TYPE_NAMELEN ||
@@ -4503,23 +4498,17 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	 * this is all done under the css_set_lock.
 	 */
 	write_lock(&css_set_lock);
-	for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
-		struct css_set *cg;
-		struct hlist_node *node, *tmp;
-		struct hlist_head *bucket = &css_set_table[i], *new_bucket;
-
-		hlist_for_each_entry_safe(cg, node, tmp, bucket, hlist) {
-			/* skip entries that we already rehashed */
-			if (cg->subsys[ss->subsys_id])
-				continue;
-			/* remove existing entry */
-			hlist_del(&cg->hlist);
-			/* set new value */
-			cg->subsys[ss->subsys_id] = css;
-			/* recompute hash and restore entry */
-			new_bucket = css_set_hash(cg->subsys);
-			hlist_add_head(&cg->hlist, new_bucket);
-		}
+	hash_for_each_safe(css_set_table, i, node, tmp, cg, hlist) {
+		/* skip entries that we already rehashed */
+		if (cg->subsys[ss->subsys_id])
+			continue;
+		/* remove existing entry */
+		hlist_del(&cg->hlist);
+		/* set new value */
+		cg->subsys[ss->subsys_id] = css;
+		/* recompute hash and restore entry */
+		key = css_set_hash(cg->subsys);
+		hash_add(css_set_table, node, key);
 	}
 	write_unlock(&css_set_lock);
 
@@ -4551,7 +4540,6 @@ EXPORT_SYMBOL_GPL(cgroup_load_subsys);
 void cgroup_unload_subsys(struct cgroup_subsys *ss)
 {
 	struct cg_cgroup_link *link;
-	struct hlist_head *hhead;
 
 	BUG_ON(ss->module == NULL);
 
@@ -4585,11 +4573,12 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	write_lock(&css_set_lock);
 	list_for_each_entry(link, &dummytop->css_sets, cgrp_link_list) {
 		struct css_set *cg = link->cg;
+		unsigned long key;
 
-		hlist_del(&cg->hlist);
+		hash_del(&cg->hlist);
 		cg->subsys[ss->subsys_id] = NULL;
-		hhead = css_set_hash(cg->subsys);
-		hlist_add_head(&cg->hlist, hhead);
+		key = css_set_hash(cg->subsys);
+		hash_add(css_set_table, &cg->hlist, key);
 	}
 	write_unlock(&css_set_lock);
 
@@ -4631,9 +4620,6 @@ int __init cgroup_init_early(void)
 	list_add(&init_css_set_link.cg_link_list,
 		 &init_css_set.cg_links);
 
-	for (i = 0; i < CSS_SET_TABLE_SIZE; i++)
-		INIT_HLIST_HEAD(&css_set_table[i]);
-
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 
@@ -4667,7 +4653,7 @@ int __init cgroup_init(void)
 {
 	int err;
 	int i;
-	struct hlist_head *hhead;
+	unsigned long key;
 
 	err = bdi_init(&cgroup_backing_dev_info);
 	if (err)
@@ -4686,8 +4672,8 @@ int __init cgroup_init(void)
 	}
 
 	/* Add init_css_set to the hash table */
-	hhead = css_set_hash(init_css_set.subsys);
-	hlist_add_head(&init_css_set.hlist, hhead);
+	key = css_set_hash(init_css_set.subsys);
+	hash_add(css_set_table, &init_css_set.hlist, key);
 	BUG_ON(!init_root_id(&rootnode));
 
 	cgroup_kobj = kobject_create_and_add("cgroup", fs_kobj);
-- 
1.8.0.2
