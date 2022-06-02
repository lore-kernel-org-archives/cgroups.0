From: shisiyuan <shisiyuan19870131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: handle cset multiidentity issue when migration
Date: Fri,  3 Jun 2022 00:34:48 +0800
Message-ID: <1654187688-27411-1-git-send-email-shisiyuan@xiaomi.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=NPlK307c48MdlGmg7luqnrkmG504nwebNc0iVQuTMyY=;
        b=R45ge7K/GujP+0NWTnSdk8mJOV4UMKO7d6UUPo6iz8UstLYz3d8u2YLlad32RkzkjU
         j2mu8e54JF3vFiaSWeLeSKE0h68IkHwmtS8nySJ03CtYeH5XO6ICnj38kr6MLKKPvca+
         lL4PbU6Viq2oVeGX5PPkuP2iRmWdmGwYApAdKj6GDJbCPLZ6FxCdFFj1CtWjJhkL/oja
         N6AURuaiOph5XVI9tXu4GbDWKgJvh6z3Gk1p7+BrORp1hBzb5Zf4yj60nhkKYLApv6U7
         PGvdWAzM2zm0/rNgPd/3iLxHedl9TQnp44ExUZVpRHBVsZzpVqJSIGXVSBm454y6fhxc
         pAYQ==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shisiyuan <shisiyuan-95E7rUnPDLLQT0dZR+AlfA@public.gmane.org>

Bug code flow:
cset X's initial refcount is 1.
1. cgroup_attach_task()
2. [For thread1]
   cgroup_migrate_add_src()
   [For thread2]
   cgroup_migrate_add_src()
     cset X is thread2's src_cset , ref->2,
     and its mg_preload_node is added to
     mgctx->preloaded_src_csets.
3. cgroup_migrate_prepare_dst()
   [For thread1]
   find_css_set()
     cset X is thread1's dst_cset, ref->3
   put_css_set()
     ref->2 because cset X's mg_preload_node is not
     empty(already in mgctx->preloaded_src_csets).
   [For thread2]
   find_css_cset()
     cset X is also thread2's dst_cset, ref->3
     then drop src_cset, ref->1
[cgroup_free] ref->0
4. cgroup_migrate_execute
   [For thread1]
   ref -> 0xc0000000(UAF)
The issue occurs because cset X's refcount should
not be substraced by one in this case. So mark a flag
'multiidentity' to this cset and call put_css_set()
one more time if 'multiidentity' marked in cleanup
progress.

Signed-off-by: shisiyuan <shisiyuan-95E7rUnPDLLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup-defs.h |  5 +++++
 kernel/cgroup/cgroup.c      | 23 +++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8c19303..c9f2237 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -280,6 +280,11 @@ struct css_set {
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
+
+	/* Indicate if the css_set is the src_cset of one thread and
+	 * the dst_cset of anonther thread during migration process.
+	 */
+	bool multiidentity;
 };
 
 struct cgroup_base_stat {
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e914646..cfdd12e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2593,6 +2593,10 @@ void cgroup_migrate_finish(struct cgroup_mgctx *mgctx)
 		cset->mg_dst_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
 		list_del_init(&cset->mg_preload_node);
+		if (cset->multiidentity == true) {
+			cset->multiidentity = false;
+			put_css_set_locked(cset);
+		}
 		put_css_set_locked(cset);
 	}
 
@@ -2648,6 +2652,18 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 	list_add_tail(&src_cset->mg_preload_node, &mgctx->preloaded_src_csets);
 }
 
+static bool list_contains(struct list_head *node, struct list_head *head)
+{
+	struct list_head *tmp;
+
+	list_for_each(tmp, head) {
+		if (tmp == node)
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * cgroup_migrate_prepare_dst - prepare destination css_sets for migration
  * @mgctx: migration context
@@ -2700,6 +2716,13 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 		if (list_empty(&dst_cset->mg_preload_node))
 			list_add_tail(&dst_cset->mg_preload_node,
 				      &mgctx->preloaded_dst_csets);
+		/* If dst_cset is already in mgctx->preloaded_src_csets,
+		 * it means the dst_cset has multi identities. Keep it
+		 * in mgctx->preloaded_src_csets, and mark it.
+		 */
+		else if (list_contains(&dst_cset->mg_preload_node,
+					&mgctx->preloaded_src_csets))
+			dst_cset->multiidentity = true;
 		else
 			put_css_set(dst_cset);
 
-- 
2.7.4

