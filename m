From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH 2/2] cgroup: pids: fix invalid get/put usage
Date: Sun, 23 Aug 2015 23:10:32 +1000
Message-ID: <1440335432-4202-3-git-send-email-cyphar@cyphar.com>
References: <CAOviyag1ZOgjtNWmnpfMm=fDgkhDn9UGKoJXy6HLWQMGb-tQAg@mail.gmail.com>
 <1440335432-4202-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440335432-4202-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

Fix incorrect usage of css_get and css_put to put a different css in
pids_{cancel_,}attach() than the one grabbed in pids_can_attach(). This
could lead to quite serious memory leakage (and unsafe operations on the
putted css).

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 kernel/cgroup_pids.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index d75488824ae2..f116ca77a658 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -177,7 +177,7 @@ static int pids_can_attach(struct cgroup_subsys_state *css,
 		 * we either fail and hit ->cancel_attach() or succeed and hit
 		 * ->attach().
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
