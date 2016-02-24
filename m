From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/16] cgroup: explicitly track whether a cgroup_subsys_state is visible to userland
Date: Wed, 24 Feb 2016 17:02:34 -0500
Message-ID: <1456351368-786-3-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3STTqu6gI6CPbsvyH685E21jH1CbCAOllT2hJ7Pzcrk=;
        b=huLj4jlbN5nc2ofxnMhptBYVQQK9Fms+CXKsBnQhBt2Czfg7HXNdgC6APSN5RrJAou
         8Tp4NbBCIr5kqAGv9Q7mN9CdtrSkupbNUifEKrr9n2Lf7Gab/zShpfu0vH7QvZOqQ0tj
         OTIBf2aFdkJ48X+klEqcWovSa4odvARmnkav1dvE8bLJtJvw6XFQFTBgg5Flv3ZBD7VN
         zNODK95RJW9YzzEDas6gbz4j13rTfDURzDxyArVFoSdO3T8W2jz8BteRtoZWC4MGt6ZK
         2xyrTQLNUVEm/up13sLpt2vBw3TyuhRYRqZY/qbYcta0vHtaNfeDavBX0WmTWhHyYxmG
         Woow==
In-Reply-To: <1456351368-786-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, whether a css (cgroup_subsys_state) has its interface files
created is not tracked and assumed to change together with the owning
cgroup's lifecycle.  cgroup directory and interface creation is being
separated out from internal object creation to help refactoring and
eventually allow cgroups which are not visible through cgroupfs.

This patch adds CSS_VISIBLE to track whether a css has its interface
files created and perform management operations only when necessary
which helps decoupling interface file handling from internal object
lifecycle.  After this patch, all css interface file management
functions can be called regardless of the current state and will
achieve the expected result.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h |  1 +
 kernel/cgroup.c             | 13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8fc3f04..7593c1a 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -45,6 +45,7 @@ enum {
 	CSS_NO_REF	= (1 << 0), /* no reference counting for this css */
 	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
 	CSS_RELEASED	= (1 << 2), /* refcnt reached zero, released */
+	CSS_VISIBLE	= (1 << 3), /* css is visible to userland */
 };
 
 /* bits in struct cgroup flags field */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3784f5a..c5fa761 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1420,6 +1420,11 @@ static void css_clear_dir(struct cgroup_subsys_state *css,
 	struct cgroup *cgrp = cgrp_override ?: css->cgroup;
 	struct cftype *cfts;
 
+	if (!(css->flags & CSS_VISIBLE))
+		return;
+
+	css->flags &= ~CSS_VISIBLE;
+
 	list_for_each_entry(cfts, &css->ss->cfts, node)
 		cgroup_addrm_files(css, cgrp, cfts, false);
 }
@@ -1438,6 +1443,9 @@ static int css_populate_dir(struct cgroup_subsys_state *css,
 	struct cftype *cfts, *failed_cfts;
 	int ret;
 
+	if (css->flags & CSS_VISIBLE)
+		return 0;
+
 	if (!css->ss) {
 		if (cgroup_on_dfl(cgrp))
 			cfts = cgroup_dfl_base_files;
@@ -1454,6 +1462,9 @@ static int css_populate_dir(struct cgroup_subsys_state *css,
 			goto err;
 		}
 	}
+
+	css->flags |= CSS_VISIBLE;
+
 	return 0;
 err:
 	list_for_each_entry(cfts, &css->ss->cfts, node) {
@@ -3402,7 +3413,7 @@ static int cgroup_apply_cftypes(struct cftype *cfts, bool is_add)
 	css_for_each_descendant_pre(css, cgroup_css(root, ss)) {
 		struct cgroup *cgrp = css->cgroup;
 
-		if (cgroup_is_dead(cgrp))
+		if (!(css->flags & CSS_VISIBLE))
 			continue;
 
 		ret = cgroup_addrm_files(css, cgrp, cfts, is_add);
-- 
2.5.0

