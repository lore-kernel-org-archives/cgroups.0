From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v2] cgroup: pids: fix invalid get/put usage
Date: Tue, 25 Aug 2015 12:50:44 +1000
Message-ID: <1440471044-10154-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: n.borisov@siteground.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

Fix incorrect usage of css_get and css_put to put a different css in
pids_{cancel_,}attach() than the one grabbed in pids_can_attach(). This
could lead to quite serious memory leakage (and unsafe operations on the
putted css).

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 kernel/cgroup_pids.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index d75488824ae2..056564f8dd85 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -173,11 +173,11 @@ static int pids_can_attach(struct cgroup_subsys_state *css,
 		struct pids_cgroup *old_pids;
 
 		/*
-		 * Grab a ref to each task's css. We don't drop the ref until
-		 * we either fail and hit ->cancel_attach() or succeed and hit
-		 * ->attach().
+		 * We don't need to grab a ref between here and cancel_attach()
+		 * because cgroup_migrate_prepare_src() protects the task's css
+		 * from being freed before the migration completed or failed.
 		 */
-		old_css = task_get_css(task, pids_cgrp_id);
+		old_css = task_css(task, pids_cgrp_id);
 		old_pids = css_pids(old_css);
 
 		pids_charge(pids, 1);
@@ -202,19 +202,9 @@ static void pids_cancel_attach(struct cgroup_subsys_state *css,
 
 		pids_charge(old_pids, 1);
 		pids_uncharge(pids, 1);
-		css_put(old_css);
 	}
 }
 
-static void pids_attach(struct cgroup_subsys_state *css,
-			struct cgroup_taskset *tset)
-{
-	struct task_struct *task;
-
-	cgroup_taskset_for_each(task, tset)
-		css_put(task_css(task, pids_cgrp_id));
-}
-
 static int pids_can_fork(struct task_struct *task, void **priv_p)
 {
 	struct cgroup_subsys_state *css;
@@ -354,7 +344,6 @@ static struct cftype pids_files[] = {
 struct cgroup_subsys pids_cgrp_subsys = {
 	.css_alloc	= pids_css_alloc,
 	.css_free	= pids_css_free,
-	.attach		= pids_attach,
 	.can_attach 	= pids_can_attach,
 	.cancel_attach 	= pids_cancel_attach,
 	.can_fork	= pids_can_fork,
-- 
2.5.0
