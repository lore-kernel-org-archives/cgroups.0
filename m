From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 3/7] cgroup: replace explicit ss_mask checking with for_each_subsys_which
Date: Sat, 16 May 2015 14:13:37 +1000
Message-ID: <1431749621-30451-4-git-send-email-cyphar@cyphar.com>
References: <1431749621-30451-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431749621-30451-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Replace the explicit checking against ss_masks inside a for_each_subsys
block with for_each_subsys_which(..., ss_mask), to take advantage of the
more readable macro.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 633d02a..eb5e4b3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1102,9 +1102,8 @@ static unsigned long cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
 	while (true) {
 		unsigned long new_ss_mask = cur_ss_mask;
 
-		for_each_subsys(ss, ssid)
-			if (cur_ss_mask & (1 << ssid))
-				new_ss_mask |= ss->depends_on;
+		for_each_subsys_which(ss, ssid, &cur_ss_mask)
+			new_ss_mask |= ss->depends_on;
 
 		/*
 		 * Mask out subsystems which aren't available.  This can
@@ -1242,10 +1241,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	for_each_subsys(ss, ssid) {
-		if (!(ss_mask & (1 << ssid)))
-			continue;
-
+	for_each_subsys_which(ss, ssid, &ss_mask) {
 		/* if @ss has non-root csses attached to it, can't move */
 		if (css_next_child(NULL, cgroup_css(&ss->root->cgrp, ss)))
 			return -EBUSY;
@@ -1282,18 +1278,14 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 	 * Nothing can fail from this point on.  Remove files for the
 	 * removed subsystems and rebind each subsystem.
 	 */
-	for_each_subsys(ss, ssid)
-		if (ss_mask & (1 << ssid))
-			cgroup_clear_dir(&ss->root->cgrp, 1 << ssid);
+	for_each_subsys_which(ss, ssid, &ss_mask)
+		cgroup_clear_dir(&ss->root->cgrp, 1 << ssid);
 
-	for_each_subsys(ss, ssid) {
+	for_each_subsys_which(ss, ssid, &ss_mask) {
 		struct cgroup_root *src_root;
 		struct cgroup_subsys_state *css;
 		struct css_set *cset;
 
-		if (!(ss_mask & (1 << ssid)))
-			continue;
-
 		src_root = ss->root;
 		css = cgroup_css(&src_root->cgrp, ss);
 
@@ -2567,13 +2559,11 @@ static void cgroup_print_ss_mask(struct seq_file *seq, unsigned long ss_mask)
 	bool printed = false;
 	int ssid;
 
-	for_each_subsys(ss, ssid) {
-		if (ss_mask & (1 << ssid)) {
-			if (printed)
-				seq_putc(seq, ' ');
-			seq_printf(seq, "%s", ss->name);
-			printed = true;
-		}
+	for_each_subsys_which(ss, ssid, &ss_mask) {
+		if (printed)
+			seq_putc(seq, ' ');
+		seq_printf(seq, "%s", ss->name);
+		printed = true;
 	}
 	if (printed)
 		seq_putc(seq, '\n');
@@ -2721,11 +2711,12 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 */
 	buf = strstrip(buf);
 	while ((tok = strsep(&buf, " "))) {
+		unsigned long tmp_ss_mask = ~cgrp_dfl_root_inhibit_ss_mask;
+
 		if (tok[0] == '\0')
 			continue;
-		for_each_subsys(ss, ssid) {
-			if (ss->disabled || strcmp(tok + 1, ss->name) ||
-			    ((1 << ss->id) & cgrp_dfl_root_inhibit_ss_mask))
+		for_each_subsys_which(ss, ssid, &tmp_ss_mask) {
+			if (ss->disabled || strcmp(tok + 1, ss->name))
 				continue;
 
 			if (*tok == '+') {
@@ -2812,10 +2803,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * still around.  In such cases, wait till it's gone using
 	 * offline_waitq.
 	 */
-	for_each_subsys(ss, ssid) {
-		if (!(css_enable & (1 << ssid)))
-			continue;
-
+	for_each_subsys_which(ss, ssid, &css_enable) {
 		cgroup_for_each_live_child(child, cgrp) {
 			DEFINE_WAIT(wait);
 
-- 
2.4.1
