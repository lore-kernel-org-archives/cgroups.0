From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] cgroup: cosmetic updates to rebind_subsystems()
Date: Tue, 11 Aug 2015 13:58:06 -0400
Message-ID: <1439315889-3492-6-git-send-email-tj@kernel.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q8eIU9IdamfFCnEKCEhiNqGntv+UQgDplfj9KiiFOG8=;
        b=bp2YplmmsRn0kVI8a0rroU08NbHrfRap6JHFmaTeHVr4y+eyC/Xy8/DOe5ucfO3124
         Soa3CyHx7WT6vrnnTi3MZtNa/XNKgaEqD0s9mCdFl3ZWkoUitzndbAiDNC6YAC/QLPiP
         pS6CcgTffF0iqj/Bg08EWZbYOnGOT3Y8lhP4iejo5B28Pm2WurKWrEn7FJaIyi/KxJh2
         U7YADZ/m/NC+ndwzzG6EKk+jn7h2ZWKz+SOmdg409lvl1FePoi6gAuz1SoeQdswEysd6
         f6DxrYWHKxT+folJfZ5vEy4y8XBJkTnBz+puWyz7OPchroNS5+tDtgsICdV3i6mcnpve
         eb8g==
In-Reply-To: <1439315889-3492-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, lizefan@huawei.com
Cc: mhocko@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

* Use local variables @scgrp and @dcgrp for @src_root->cgrp and
  @dst_root->cgrp respectively.

* Use initializers to set @src_root and @css in the inner bind loop.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/cgroup.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5e5a4e0..67d2ba3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1271,6 +1271,7 @@ static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned long ss_mask)
 {
+	struct cgroup *dcgrp = &dst_root->cgrp;
 	struct cgroup_subsys *ss;
 	unsigned long tmp_ss_mask;
 	int ssid, i, ret;
@@ -1292,7 +1293,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 	if (dst_root == &cgrp_dfl_root)
 		tmp_ss_mask &= ~cgrp_dfl_root_inhibit_ss_mask;
 
-	ret = cgroup_populate_dir(&dst_root->cgrp, tmp_ss_mask);
+	ret = cgroup_populate_dir(dcgrp, tmp_ss_mask);
 	if (ret) {
 		if (dst_root != &cgrp_dfl_root)
 			return ret;
@@ -1318,42 +1319,40 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		cgroup_clear_dir(&ss->root->cgrp, 1 << ssid);
 
 	for_each_subsys_which(ss, ssid, &ss_mask) {
-		struct cgroup_root *src_root;
-		struct cgroup_subsys_state *css;
+		struct cgroup_root *src_root = ss->root;
+		struct cgroup *scgrp = &src_root->cgrp;
+		struct cgroup_subsys_state *css = cgroup_css(scgrp, ss);
 		struct css_set *cset;
 
-		src_root = ss->root;
-		css = cgroup_css(&src_root->cgrp, ss);
-
-		WARN_ON(!css || cgroup_css(&dst_root->cgrp, ss));
+		WARN_ON(!css || cgroup_css(dcgrp, ss));
 
-		RCU_INIT_POINTER(src_root->cgrp.subsys[ssid], NULL);
-		rcu_assign_pointer(dst_root->cgrp.subsys[ssid], css);
+		RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
+		rcu_assign_pointer(dcgrp->subsys[ssid], css);
 		ss->root = dst_root;
-		css->cgroup = &dst_root->cgrp;
+		css->cgroup = dcgrp;
 
 		down_write(&css_set_rwsem);
 		hash_for_each(css_set_table, i, cset, hlist)
 			list_move_tail(&cset->e_cset_node[ss->id],
-				       &dst_root->cgrp.e_csets[ss->id]);
+				       &dcgrp->e_csets[ss->id]);
 		up_write(&css_set_rwsem);
 
 		src_root->subsys_mask &= ~(1 << ssid);
-		src_root->cgrp.subtree_control &= ~(1 << ssid);
-		cgroup_refresh_child_subsys_mask(&src_root->cgrp);
+		scgrp->subtree_control &= ~(1 << ssid);
+		cgroup_refresh_child_subsys_mask(scgrp);
 
 		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
 		if (dst_root != &cgrp_dfl_root) {
-			dst_root->cgrp.subtree_control |= 1 << ssid;
-			cgroup_refresh_child_subsys_mask(&dst_root->cgrp);
+			dcgrp->subtree_control |= 1 << ssid;
+			cgroup_refresh_child_subsys_mask(dcgrp);
 		}
 
 		if (ss->bind)
 			ss->bind(css);
 	}
 
-	kernfs_activate(dst_root->cgrp.kn);
+	kernfs_activate(dcgrp->kn);
 	return 0;
 }
 
-- 
2.4.3
