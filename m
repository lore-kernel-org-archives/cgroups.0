From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/9] cgroup: update error handling in cgroup_populate_dir()
Date: Fri, 28 Jun 2013 16:45:41 -0700
Message-ID: <1372463145-4245-6-git-send-email-tj@kernel.org>
References: <1372463145-4245-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=VtUKQKY4uDQkU3of+OAMHuEB19MxKWE0ysCdU4tyrHA=;
        b=DjMmNtDDBqMGLWnecuWXPNCFwVuX2uipQS5BA+JTqjizB6kknfVOiqeNPmWWlmAUX4
         zaWn6moVZ7UKsAhQR+GGBvUJ55WndKXzf2VeHfT3/y4s4wN+uP/dsx3wanotjkuDqf7M
         wVHd21DTByM6HG576b+0EaIc9cnplLFzYx3GgQzZlXNbkj0h6ip87VtvadqXtKuKYkD6
         PieB7hK/AgaAEkc+D4bNB1VSJU5nqbKKWch9rD60RqWubC0c0cIWb3rgaFLl9jTEGKZ6
         tMQ9IGNnPWlW5pumKYZLht51KflQOeyTTY6vkhpa3495Gge9c2GU6AxXG7srdHCx7XSS
         qxjw==
In-Reply-To: <1372463145-4245-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup_populate_dir() didn't use to check whether the actual file
creations were successful and could return success with only subset of
the requested files created, which is nasty.

This patch udpates cgroup_populate_dir() so that it either succeeds
with all files or fails with no file.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 254d54e..3475267 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -965,10 +965,12 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 static void cgroup_clear_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 {
 	struct cgroup_subsys *ss;
+	int i;
 
-	for_each_root_subsys(cgrp->root, ss) {
+	for_each_subsys(ss, i) {
 		struct cftype_set *set;
-		if (!test_bit(ss->subsys_id, &subsys_mask))
+
+		if (!test_bit(i, &subsys_mask))
 			continue;
 		list_for_each_entry(set, &ss->cftsets, node)
 			cgroup_addrm_files(cgrp, NULL, set->cfts, false);
@@ -4171,19 +4173,26 @@ static struct cftype cgroup_base_files[] = {
  * cgroup_populate_dir - create subsys files in a cgroup directory
  * @cgrp: target cgroup
  * @subsys_mask: mask of the subsystem ids whose files should be added
+ *
+ * On failure, no file is added.
  */
 static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 {
 	struct cgroup_subsys *ss;
+	int i, ret = 0;
 
 	/* process cftsets of each subsystem */
-	for_each_root_subsys(cgrp->root, ss) {
+	for_each_subsys(ss, i) {
 		struct cftype_set *set;
-		if (!test_bit(ss->subsys_id, &subsys_mask))
+
+		if (!test_bit(i, &subsys_mask))
 			continue;
 
-		list_for_each_entry(set, &ss->cftsets, node)
-			cgroup_addrm_files(cgrp, ss, set->cfts, true);
+		list_for_each_entry(set, &ss->cftsets, node) {
+			ret = cgroup_addrm_files(cgrp, ss, set->cfts, true);
+			if (ret < 0)
+				goto err;
+		}
 	}
 
 	/* This cgroup is ready now */
@@ -4201,6 +4210,9 @@ static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 	}
 
 	return 0;
+err:
+	cgroup_clear_dir(cgrp, subsys_mask);
+	return ret;
 }
 
 static void css_dput_fn(struct work_struct *work)
-- 
1.8.3.1
