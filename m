From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v9 2/4] cgroups: replace explicit ss_mask checking with for_each_subsys_which
Date: Sun, 12 Apr 2015 10:51:55 +1000
Message-ID: <1428799917-15141-3-git-send-email-cyphar@cyphar.com>
References: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

Replace the explicit checking against ss_masks inside a for_each_subsys
block with for_each_subsys_which(ss_mask, ...), to take advantage of the
more readable macro.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 kernel/cgroup.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1d69a085..abd491f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1099,9 +1099,8 @@ static unsigned int cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
 	while (true) {
 		unsigned int new_ss_mask = cur_ss_mask;
 
-		for_each_subsys(ss, ssid)
-			if (cur_ss_mask & (1 << ssid))
-				new_ss_mask |= ss->depends_on;
+		for_each_subsys_which(cur_ss_mask, ss, ssid)
+			new_ss_mask |= ss->depends_on;
 
 		/*
 		 * Mask out subsystems which aren't available.  This can
@@ -1238,10 +1237,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	for_each_subsys(ss, ssid) {
-		if (!(ss_mask & (1 << ssid)))
-			continue;
-
+	for_each_subsys_which(ss_mask, ss, ssid) {
 		/* if @ss has non-root csses attached to it, can't move */
 		if (css_next_child(NULL, cgroup_css(&ss->root->cgrp, ss)))
 			return -EBUSY;
@@ -1278,18 +1274,14 @@ static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 	 * Nothing can fail from this point on.  Remove files for the
 	 * removed subsystems and rebind each subsystem.
 	 */
-	for_each_subsys(ss, ssid)
-		if (ss_mask & (1 << ssid))
-			cgroup_clear_dir(&ss->root->cgrp, 1 << ssid);
+	for_each_subsys_which(ss_mask, ss, ssid)
+		cgroup_clear_dir(&ss->root->cgrp, 1 << ssid);
 
-	for_each_subsys(ss, ssid) {
+	for_each_subsys_which(ss_mask, ss, ssid) {
 		struct cgroup_root *src_root;
 		struct cgroup_subsys_state *css;
 		struct css_set *cset;
 
-		if (!(ss_mask & (1 << ssid)))
-			continue;
-
 		src_root = ss->root;
 		css = cgroup_css(&src_root->cgrp, ss);
 
@@ -2563,13 +2555,11 @@ static void cgroup_print_ss_mask(struct seq_file *seq, unsigned int ss_mask)
 	bool printed = false;
 	int ssid;
 
-	for_each_subsys(ss, ssid) {
-		if (ss_mask & (1 << ssid)) {
-			if (printed)
-				seq_putc(seq, ' ');
-			seq_printf(seq, "%s", ss->name);
-			printed = true;
-		}
+	for_each_subsys_which(ss_mask, ss, ssid) {
+		if (printed)
+			seq_putc(seq, ' ');
+		seq_printf(seq, "%s", ss->name);
+		printed = true;
 	}
 	if (printed)
 		seq_putc(seq, '\n');
@@ -2719,9 +2709,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	while ((tok = strsep(&buf, " "))) {
 		if (tok[0] == '\0')
 			continue;
-		for_each_subsys(ss, ssid) {
-			if (ss->disabled || strcmp(tok + 1, ss->name) ||
-			    ((1 << ss->id) & cgrp_dfl_root_inhibit_ss_mask))
+		for_each_subsys_which(~cgrp_dfl_root_inhibit_ss_mask, ss, ssid) {
+			if (ss->disabled || strcmp(tok + 1, ss->name))
 				continue;
 
 			if (*tok == '+') {
@@ -2808,10 +2797,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * still around.  In such cases, wait till it's gone using
 	 * offline_waitq.
 	 */
-	for_each_subsys(ss, ssid) {
-		if (!(css_enable & (1 << ssid)))
-			continue;
-
+	for_each_subsys_which(css_enable, ss, ssid) {
 		cgroup_for_each_live_child(child, cgrp) {
 			DEFINE_WAIT(wait);
 
-- 
2.3.5
